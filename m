Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267AbaEMIO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:14:59 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:46440 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758621AbaEMIO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:14:56 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Tue, 13 May 2014 10:14:35 +0200
Message-ID: <CAKgNAkgcuvEqz6=EWnYvQrTsKd0_ZZ1gNCQWj14Wp0_Efq8KmA@mail.gmail.com>
Subject: Re: SCHED_DEADLINE, sched_getscheduler(), and sched_getparam()
To: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 10:50 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, May 12, 2014 at 09:42:44PM +0200, Michael Kerrisk (man-pages) wrote:
>> > Hmm,.. maybe. Can we still change this? Again, maybe, there's not really
>> > that much userspace that relies on this.
>>
>> I think the sched_getparam() change is worthwhile (and the patches
>> could (should?) be marked for -stable). I suspect there's no user
>> space that relies on the current SCHED_DEADLINE behavior, and it's
>> worth avoiding the above breakage for sched_getparam(). I'd be
>> inclined to leave sched_getscheduler() as is: there's arguments
>> either way for how it should behave.
>>
>> > In any case, the way I read the little there is on getparam() it seems
>> > to imply the only case where it does make sense to call it at all is
>> > when sched_getscheduler() returns either SCHED_FIFO or SCHED_RR.
>>
>> (Yes, that's my understanding too.)
>
> Something like so then, it encodes that reading explicitly.

Seems reasonable to me.

Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>

Thanks,

Michael


> ---
> Subject: sched: Change sched_getparam() behaviour vs SCHED_DEADLINE
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Mon May 12 22:22:47 CEST 2014
>
> The way we read POSIX one should only call sched_getparam() when
> sched_getscheduler() returns either SCHED_FIFO or SCHED_RR.
>
> Given that we currently return sched_param::sched_priority=0 for all
> others, extend the same behaviour to SCHED_DEADLINE.
>
> Requested-by: Michael Kerrisk <mtk.manpages@gmail.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  kernel/sched/core.c |    9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> Index: linux-2.6/kernel/sched/core.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched/core.c
> +++ linux-2.6/kernel/sched/core.c
> @@ -3759,7 +3759,7 @@ SYSCALL_DEFINE1(sched_getscheduler, pid_
>   */
>  SYSCALL_DEFINE2(sched_getparam, pid_t, pid, struct sched_param __user *, param)
>  {
> -       struct sched_param lp;
> +       struct sched_param lp = { .sched_priority = 0 };
>         struct task_struct *p;
>         int retval;
>
> @@ -3776,11 +3776,8 @@ SYSCALL_DEFINE2(sched_getparam, pid_t, p
>         if (retval)
>                 goto out_unlock;
>
> -       if (task_has_dl_policy(p)) {
> -               retval = -EINVAL;
> -               goto out_unlock;
> -       }
> -       lp.sched_priority = p->rt_priority;
> +       if (task_has_rt_policy(p))
> +               lp.sched_priority = p->rt_priority;
>         rcu_read_unlock();
>
>         /*



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
