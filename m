Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab3CJChK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 21:37:10 -0500
Received: from mail-ia0-f180.google.com ([209.85.210.180]:33637 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3CJChI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 21:37:08 -0500
MIME-Version: 1.0
In-Reply-To: <20130309182613.GA32343@redhat.com>
References: <1362717437-1729-1-git-send-email-walken@google.com>
	<20130309182613.GA32343@redhat.com>
Date: Sat, 9 Mar 2013 18:37:07 -0800
Message-ID: <CANN689HDiJN0GQYyos_-7Vudw9jLkDWEODCVL5PNsO5O4WV3oQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] tasklist_lock fairness issues
From: Michel Lespinasse <walken@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 9, 2013 at 10:26 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> Hi Michel,
>
> Well. I can't say I really like this. 4/5 itself looks fine, but other
> complications do not look nice, at least in the long term. Imho, imho,
> I can be wrong.
>
> Everyone seem to agree that tasklist should die, this series doesn't
> even try to solve the fundamental problems with this global lock.

I admit that this series does not make any progress towards removing
tasklist_lock call sites, which has been the direction so far.

However, I think that patches 1-3 are not very complex (they add
inline wrapper functions around the tasklist_lock locking calls, but
the compiled code ends up being the same). And by showing us which
tasklist_lock call sites are taken from interrupt contexts, they show
up which places are imposing the current tasklist_lock semantics on
us:

- sending signals, with the send_sigio() / send_sigurg() / kill_pgrp()
call sites;
- posix_cpu_timer_schedule()
- sysrq debugging features

These are only 9 call sites, so they should be more easily attackable
than the full tasklist_lock removal problem. And if we could get these
few eliminated, then it would become trivial to make the remaining
tasklist_lock fair (and maybe even remove the unfair rwlock_t
implementation), which would IMO be a significant step forward.

In other words, patch 5 is, in a way, cheating by trying to get some
tasklist_lock fairness benefits right now. There is a bit of
complexity to it since it replaces tasklist_lock with a pair of locks,
one fair and one unfair. But if we don't like patch 5, patches 1-3 can
still give us a closer intermediate goal of removing much of the
tasklist_lock nastyness by eliminating only 9 of the existing locking
sites.

> However, I agree. tasklist rework can take ages, so probably we need
> to solve at least the write-starvation problem right now. Probably this
> series is correct (I didn't read it except 4/5), but too complex.

Regarding the complexity - do you mean the complexity of implementing
a fair rwlock (I would guess not, since you said 4/5 look ok) or do
you mean that you don't like having inline wrapper functions around
tasklist_lock locking sites (which is what 1-3 do) ?

> Can't we do some simple hack to avoid the user-triggered livelocks?
> Say, can't we add
>
>         // Just for illustration, at least we need CONTENDED/etc
>
>         void read_lock_fair(rwlock_t *lock)
>         {
>                 while (arch_writer_active(lock))
>                         cpu_relax();
>                 read_lock(lock);
>         }
>
> and then turn some of read_lock's (do_wait, setpriority, more) into
> read_lock_fair?
>
> I have to admit, I do not know how rwlock_t actually works, and it seems
> that arch_writer_active() is not trivial even on x86. __write_lock_failed()
> changes the counter back, and afaics you can't detect the writer in the
> window between addl and subl. Perhaps we can change __write_lock_failed()
> to use RW_LOCK_BIAS + HUGE_NUMBER while it spins, but I am not sure...

IMO having a separate fair rw spinlock is less trouble than trying to
build it on top of rwlock_t - especially if we're planning to remove
the tasklist_lock use of rwlock_t, which is currently the main
justification for rwlock_t's existence. I'm hoping we can eventually
get rid of rwlock_t, so I prefer not to build on top of it when we can
easily avoid doing so.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
