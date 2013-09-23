Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab3IWGmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 02:42:12 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:27288 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab3IWGmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 02:42:10 -0400
Message-ID: <1379918525.2231.0.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 0/4] ipc: shm and msg fixes
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Paris <eparis@parisplace.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Date: Sun, 22 Sep 2013 23:42:05 -0700
In-Reply-To: <CA+55aFwQp6Fm9-Zrn3uue9bFe9tERCbVv5Z-z9r4ZgOmS0VB+Q@mail.gmail.com>
References: <1379300677-24188-1-git-send-email-davidlohr@hp.com>
	 <1379625742.2145.19.camel@buesod1.americas.hpqcorp.net>
	 <1379700524.5434.22.camel@flatline.rdu.redhat.com>
	 <1379788235.2145.48.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFwQp6Fm9-Zrn3uue9bFe9tERCbVv5Z-z9r4ZgOmS0VB+Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-09-21 at 11:58 -0700, Linus Torvalds wrote:
> On Sat, Sep 21, 2013 at 11:30 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> >
> > IPC uses security_xxx_free() at two levels: for freeing the structure
> > (ie: shm_destroy()) and cleaning up upon error when creating the
> > structure (ie: newseg()). For both I believe we can actually use RCU.
> > What do you think of the below change, it is specific for shm, and we'd
> > need an equivalent for msq and sems.
> 
> Ugh.
> 
> This code already has rcu-delaying, usign the existing "rcu" list
> entry. I hate how you add a *new* rcu list entry, and we basically
> case two callbacks.
> 
> More importantly, it's wrong. You do the call_rcu() unconditionally,
> but it might not be the last use! You need to do it with the same
> logic ipc_rcu_putref(), namely at the dropping of the last reference.

This is the way IPC has handled things for a long time, no? Security
does not depend on the reference counter, as we unconditionally free
security structs.

> 
> So how about just making ipc_rcu_putref() have a RCU callback
> argument, and make the code look something like
> 
>     ipc_rcu_putref(shp, shm_rcu_free);

What you're suggesting, is (i) freeing security will now depend on the
refcount (wouldn't this cause cases where we actually never end up
freeing?) and (ii) in the scenarios we actually need to free the
security, delay it along with freeing the actual ipc_rcu stuff.

> 
> and then shm_rcu_free() just does
> 
>     #define ipc_rcu_to_struct(p)  ((void *)(p+1))
> 
>     void shm_rcu_free(struct rcu_head *head)
>     {
>         struct ipc_rcu *p = container_of(head, struct ipc_rcu, rcu);
>         struct shmid_kernel *shp = ipc_rcu_to_struct(p);
> 
>         security_shm_free(shp);
>         ipc_rcu_free(head);
>     }

If I understand correctly, then we'd have:

void ipc_rcu_putref(void *ptr, void (*func)(struct rcu_head *head))
{
	struct ipc_rcu *p = ((struct ipc_rcu *)ptr) - 1;

	if (!atomic_dec_and_test(&p->refcount))
		return;

	call_rcu(&p->rcu, func);
}

> 
> (that "ipc_rcu_free()" would do the current vfree-vs-kfree, just not
> rcu-delayed, so it would look something like

The vfree/free would still be rcu delayed from whatever was passed to
ipc_rcu_putref(), but yes, the function wouldn't explicitly be calling
call_rcu/kfree_rcu.

> 
>     void ipc_rcu_free(struct rcu_head *head)
>     {
>         struct ipc_rcu *p = container_of(head, struct ipc_rcu, rcu);
>         if (is_vmalloc_addr(p))
>             vfree(p);
>         else
>             kfree(p);
>     }
> 
> Other users would then just use
> 
>     ipc_rcu_putref(shp, ipc_rcu_free);
> until they too decide that they want to do something extra at RCU freeing time..

I like this flexibility.

Thanks,
Davidlohr


