Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab3IUS6Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 14:58:24 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:55519 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab3IUS6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 14:58:21 -0400
MIME-Version: 1.0
In-Reply-To: <1379788235.2145.48.camel@buesod1.americas.hpqcorp.net>
References: <1379300677-24188-1-git-send-email-davidlohr@hp.com>
	<1379625742.2145.19.camel@buesod1.americas.hpqcorp.net>
	<1379700524.5434.22.camel@flatline.rdu.redhat.com>
	<1379788235.2145.48.camel@buesod1.americas.hpqcorp.net>
Date: Sat, 21 Sep 2013 11:58:20 -0700
X-Google-Sender-Auth: MvunxR5qFYRwZosA3OH3tgELr90
Message-ID: <CA+55aFwQp6Fm9-Zrn3uue9bFe9tERCbVv5Z-z9r4ZgOmS0VB+Q@mail.gmail.com>
Subject: Re: [PATCH 0/4] ipc: shm and msg fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 21, 2013 at 11:30 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>
> IPC uses security_xxx_free() at two levels: for freeing the structure
> (ie: shm_destroy()) and cleaning up upon error when creating the
> structure (ie: newseg()). For both I believe we can actually use RCU.
> What do you think of the below change, it is specific for shm, and we'd
> need an equivalent for msq and sems.

Ugh.

This code already has rcu-delaying, usign the existing "rcu" list
entry. I hate how you add a *new* rcu list entry, and we basically
case two callbacks.

More importantly, it's wrong. You do the call_rcu() unconditionally,
but it might not be the last use! You need to do it with the same
logic ipc_rcu_putref(), namely at the dropping of the last reference.

So how about just making ipc_rcu_putref() have a RCU callback
argument, and make the code look something like

    ipc_rcu_putref(shp, shm_rcu_free);

and then shm_rcu_free() just does

    #define ipc_rcu_to_struct(p)  ((void *)(p+1))

    void shm_rcu_free(struct rcu_head *head)
    {
        struct ipc_rcu *p = container_of(head, struct ipc_rcu, rcu);
        struct shmid_kernel *shp = ipc_rcu_to_struct(p);

        security_shm_free(shp);
        ipc_rcu_free(head);
    }

(that "ipc_rcu_free()" would do the current vfree-vs-kfree, just not
rcu-delayed, so it would look something like

    void ipc_rcu_free(struct rcu_head *head)
    {
        struct ipc_rcu *p = container_of(head, struct ipc_rcu, rcu);
        if (is_vmalloc_addr(p))
            vfree(p);
        else
            kfree(p);
    }

Other users would then just use

    ipc_rcu_putref(shp, ipc_rcu_free);

until they too decide that they want to do something extra at RCU freeing time..

Hmm?

           Linus
