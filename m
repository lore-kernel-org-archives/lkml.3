Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935915Ab3DQBec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:34:32 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:46867 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756952Ab3DQBea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:34:30 -0400
MIME-Version: 1.0
In-Reply-To: <20130408235419.035A131C300@corp2gmr1-1.hot.corp.google.com>
References: <20130408235419.035A131C300@corp2gmr1-1.hot.corp.google.com>
Date: Wed, 17 Apr 2013 03:34:27 +0200
Message-ID: <CAFTL4hxGUPudBNuX8a68CFkM80aKr1M74A4SODZJzj7bypcavw@mail.gmail.com>
Subject: Re: + posix_timers-remove-dead-task-timer-expiry-caching.patch added
 to -mm tree
From: Frederic Weisbecker <fweisbec@gmail.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu,
        oleg@redhat.com, sgruszka@redhat.com, tglx@linutronix.de,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/9  <akpm@linux-foundation.org>:
>
> The patch titled
>      Subject: posix_timers: Remove dead task timer expiry caching
> has been added to the -mm tree.  Its filename is
>      posix_timers-remove-dead-task-timer-expiry-caching.patch
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
>
> ------------------------------------------------------
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Subject: posix_timers: Remove dead task timer expiry caching
>
> When reading a timer sample, posix_cpu_timer_get() and
> posix_cpu_timer_schedule() both perform a caching of the timer expiry time
> by converting its value from absolute to relative if the task has exited.
>
> The reason for this caching is not clear though, it could be:
>
> 1) For performance reasons: no need to calculate the delta after the
>    task has died, its cputime won't change anymore.  We can thus avoid
>    some locking (sighand, tasklist_lock, rq->lock for task_delta_exec(),
>    ...), and various operations to calculate the sample...
>
> 2) To keep the remaining delta for the timer available after the task
>    has died.  When it gets reaped, its sighand disappears, so accessing
>    the process wide cputime through tsk->signal is probably not safe.
>
> Now, is the first reason really worth it?  I have no idea if it is a case
> we really want to optimize.
>
> Considering the second reason, we return a disarmed zero'ed timer when
> tsk->sighand == NULL.  So if this is an assumed reason, it's broken.  And
> this case only concern process wide timers that have their group leader
> reaped.  The posix cpu timer shouldn't even be available anymore at that
> time.  Unless the group leader changed since we called
> posix_cpu_timer_create() after an exec?
>
> Anyway for now I'm sending this as an RFC because there may well be subtle
> things I left behind.
>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Stanislaw Gruszka <sgruszka@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

So this very patch probably shouldn't go to 3.10, I sent it early in
case I could get some hindsight from reviewers.
Anyway, let me some time to think more about it and all the possible
implications against exit, de_thread, etc... then I'll resend if that
sounds palatable.

Thanks.
