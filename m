Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab3IWQym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 12:54:42 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:33243 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab3IWQyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 12:54:38 -0400
MIME-Version: 1.0
In-Reply-To: <1379918525.2231.0.camel@buesod1.americas.hpqcorp.net>
References: <1379300677-24188-1-git-send-email-davidlohr@hp.com>
	<1379625742.2145.19.camel@buesod1.americas.hpqcorp.net>
	<1379700524.5434.22.camel@flatline.rdu.redhat.com>
	<1379788235.2145.48.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFwQp6Fm9-Zrn3uue9bFe9tERCbVv5Z-z9r4ZgOmS0VB+Q@mail.gmail.com>
	<1379918525.2231.0.camel@buesod1.americas.hpqcorp.net>
Date: Mon, 23 Sep 2013 09:54:37 -0700
X-Google-Sender-Auth: _IBK06VTS81UEtXAUEKExBMeyo0
Message-ID: <CA+55aFzVnivKb=nwzeTjGvi=LvnBLGnr=NZE+Ns6kLSm=WCN4w@mail.gmail.com>
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

On Sun, Sep 22, 2013 at 11:42 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>>
>> More importantly, it's wrong. You do the call_rcu() unconditionally,
>> but it might not be the last use! You need to do it with the same
>> logic ipc_rcu_putref(), namely at the dropping of the last reference.
>
> This is the way IPC has handled things for a long time, no? Security
> does not depend on the reference counter, as we unconditionally free
> security structs.

Yes, but that was ok back when the logic was idem-potent and you could
call it multiple times. Modulo races (I didn't check if we held a
lock).

You can't do "call_rcu()" more than once, because you'll corrupt the
rcu list if you do another call_rcu() while the first one is still
active (and that's a pretty big race window to hit).

That said, the old behavior was suspect for another reason too: having
the security blob go away from under a user sounds like it could cause
various other problems anyway, so I think the old code was at least
_prone_ to bugs even if it didn't have catastrophic behavior.

(In reality, I suspect the reference count is never elevated in
practice, so there is only one case that calls the security freeing
thing, so this may all be pretty much theoretical, but at least from a
logic standpoint the code clearly makes a big deal about the whole
refcount and "last user turns off the lights").

> What you're suggesting, is (i) freeing security will now depend on the
> refcount (wouldn't this cause cases where we actually never end up
> freeing?)

The security layer better not have any refcounted backpointers to the
shm, so I don't see why that would be a new issue.

>  and (ii) in the scenarios we actually need to free the
> security, delay it along with freeing the actual ipc_rcu stuff.

Well, that's the whole point. The security blob should have the same
lifetime as the ipc blob it is associated with.

Getting rid of the security blob before the thing it is supposed to
protect sounds like  a bug to me. In fact, it's the bug that this
whole thread has been about. No?

> If I understand correctly, then we'd have:
>
> void ipc_rcu_putref(void *ptr, void (*func)(struct rcu_head *head))
> {
>         struct ipc_rcu *p = ((struct ipc_rcu *)ptr) - 1;
>
>         if (!atomic_dec_and_test(&p->refcount))
>                 return;
>
>         call_rcu(&p->rcu, func);
> }

Exactly.

            Linus
