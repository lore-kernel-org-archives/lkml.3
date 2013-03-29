Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab3C2Ul4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 16:41:56 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:59487 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816Ab3C2Ulz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 16:41:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130329161746.GA8391@redhat.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
	<20130326192852.GA25899@redhat.com>
	<20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
	<20130329161746.GA8391@redhat.com>
Date: Fri, 29 Mar 2013 13:41:53 -0700
X-Google-Sender-Auth: kKNegwXOISG_nhcrnVpRHc0XPLI
Message-ID: <CA+55aFyKhgwYUMGs8MBLY5WDXhHwXP3dLWs40ayCYfgiwwncsQ@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Peter Hurley <peter@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 9:17 AM, Dave Jones <davej@redhat.com> wrote:
>
> Now that I have that reverted, I'm not seeing msgrcv traces any more, but
> I've started seeing this..
>
> general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> RIP: 0010:[<ffffffff812c20fb>]  [<ffffffff812c20fb>] free_msg+0x2b/0x40
> Call Trace:
>  [<ffffffff812c289f>] freeque+0xcf/0x140
>  [<ffffffff812c2a93>] msgctl_down.constprop.9+0x183/0x200
>  [<ffffffff812c2da9>] sys_msgctl+0x139/0x400
>  [<ffffffff816cd942>] system_call_fastpath+0x16/0x1b
>
> Looks like seg was already kfree'd.

Hmm.

I have a suspicion.

The use of ipc_rcu_getref/ipc_rcu_putref() seems a bit iffy.

In particular, the refcount is not an atomic variable, so we
absolutely *depend* on the spinlock for it.

However, looking at "freeque()", that's not actually the case. It
releases the message queue spinlock *before* it does the
ipc_rcu_putref(), and it does that because the thing has become
unreachable (it did a msg_rmid(), which will set ->deleted, which in
turn will mean that nobody should successfully look it up any more).

HOWEVER.

While the "deleted" flag is serialized, the actual refcount is not. So
in *parallel* with the freeque() call, we may have some other user
that does something like

                ...
                ipc_rcu_getref(msq);
                msg_unlock(msq);
                schedule();

                ipc_lock_by_ptr(&msq->q_perm);
                ipc_rcu_putref(msq);
                if (msq->q_perm.deleted) {
                        err = -EIDRM;
                        goto out_unlock_free;
                }
                ...


which got the lock for the "deleted" test, so that part is all fine,
but notice the "ipc_rcu_putref()". It can happen at the same time that
freeque() also does its own ipc_rcu_putref().

So now refcount may get buggered, resulting in random early reuse,
double free's or leaking of the msq.

There may be some reason I don't see why this cannot happen, but it
does look suspicious. I wonder if the refcount should be an atomic
value.

The alternative would be to make sure the thing is always locked (and
in a rcu-read-safe region) before putref/getref. The only place (apart
from the initial allocation, which doesn't matter, because nothing can
see if itf that path fails) seems to be that freeque(), but I didn't
check everything.

Moving the

    msg_unlock(msq);

to the end of freeque() might be the way to go. It's going to cause us
to hold the lock for longer, but I'm not sure we care for that path.

Guys, am I missing something? This kind of refcounting problem might
well explain the rcu-freeing-time bugs reported with the scalability
patches: long-time race that just got *much* easier to expose with the
higher level of parallelism?

               Linus
