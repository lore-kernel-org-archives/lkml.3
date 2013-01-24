Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab3AXCJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 21:09:10 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:43697 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab3AXCJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 21:09:03 -0500
X-Greylist: delayed 867 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jan 2013 21:09:03 EST
MIME-Version: 1.0
In-Reply-To: <20130109183248.GA8293@somewhere.redhat.com>
References: <20130107113144.GA7544@redhat.com>
	<20130109183248.GA8293@somewhere.redhat.com>
Date: Thu, 24 Jan 2013 09:46:56 +0800
Message-ID: <CAJn8CcE2eXK83-Jsia37dLoEwVjhQ=SiDru5fFzWGp+bzEScWA@mail.gmail.com>
Subject: Re: [PATCH v2 repost] sched: cputime: avoid multiplication overflow
 (in common cases)
From: Xiaotian Feng <xtfeng@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        akpm@linux-foundation.org, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 2:33 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Mon, Jan 07, 2013 at 12:31:45PM +0100, Stanislaw Gruszka wrote:
>> We scale stime, utime values based on rtime (sum_exec_runtime converted
>> to jiffies). During scaling we multiple rtime * utime, what seems to be
>> fine, since both values are converted to u64, but is not.
>>
>> Let assume HZ is 1000 - 1ms tick. Process consist of 64 threads, run
>> for 1 day, threads utilize 100% cpu on user space. Machine has 64 cpus.
>>
>> Process rtime = utime will be 64 * 24 * 60 * 60 * 1000 jiffies, what is
>> 0x149970000. Multiplication rtime * utime result is 0x1a855771100000000,
>> which can not be covered in 64 bits.
>>
>> Result of overflow is stall of utime values visible in user space
>> (prev_utime in kernel), even if application still consume lot of CPU
>> time.
>>
>> Probably good fix for the problem, will be using 128 bit variable and
>> proper mul128 and div_u128_u64 primitives. While mul128 is on it's
>> way to kernel, there is no 128 bit division yet. I'm not sure, if we
>> want to add it to kernel. Perhaps we could also change the way how
>> stime and utime are calculated, but I don't know how, so I come with
>> the below solution for the problem.
>>
>> To avoid overflow patch change value we scale to min(stime, utime). This
>> is more like workaround, but will work for processes, which perform
>> mostly on user space or mostly on kernel space. Unfortunately processes,
>> which perform on kernel and user space equally, and additionally utilize
>> lot of CPU time, still will hit this overflow pretty quickly. However
>> such processes seems to be uncommon.
>>
>> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>
> I can easily imagine that overflow to happen with user time on intensive
> CPU bound loads, or may be guests.
>
> But can we easily reach the same for system time? Even on intensive I/O bound
> loads we shouldn't spend that much time in the kernel. Most of it probably goes
> to idle.
>
> What do you think?
>
> If that assumption is right in most cases, the following patch should solve the
> issue:
>
> diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> index 293b202..0650dd4 100644
> --- a/kernel/sched/cputime.c
> +++ b/kernel/sched/cputime.c
> @@ -509,11 +509,11 @@ EXPORT_SYMBOL_GPL(vtime_account);
>  # define nsecs_to_cputime(__nsecs)     nsecs_to_jiffies(__nsecs)
>  #endif
>
> -static cputime_t scale_utime(cputime_t utime, cputime_t rtime, cputime_t total)
> +static cputime_t scale_utime(cputime_t stime, cputime_t rtime, cputime_t total)

s/scale_utime/scale_stime.

>  {
>         u64 temp = (__force u64) rtime;
>
> -       temp *= (__force u64) utime;
> +       temp *= (__force u64) stime;
>
>         if (sizeof(cputime_t) == 4)
>                 temp = div_u64(temp, (__force u32) total);
> @@ -531,10 +531,10 @@ static void cputime_adjust(struct task_cputime *curr,
>                            struct cputime *prev,
>                            cputime_t *ut, cputime_t *st)
>  {
> -       cputime_t rtime, utime, total;
> +       cputime_t rtime, stime, total;
>
> -       utime = curr->utime;
> -       total = utime + curr->stime;
> +       stime = curr->stime;
> +       total = stime + curr->utime;
>
>         /*
>          * Tick based cputime accounting depend on random scheduling
> @@ -549,17 +549,17 @@ static void cputime_adjust(struct task_cputime *curr,
>         rtime = nsecs_to_cputime(curr->sum_exec_runtime);
>
>         if (total)
> -               utime = scale_utime(utime, rtime, total);
> +               stime = scale_stime(stime, rtime, total);
>         else
> -               utime = rtime;
> +               stime = rtime;
>
>         /*
>          * If the tick based count grows faster than the scheduler one,
>          * the result of the scaling may go backward.
>          * Let's enforce monotonicity.
>          */
> -       prev->utime = max(prev->utime, utime);
> -       prev->stime = max(prev->stime, rtime - prev->utime);
> +       prev->stime = max(prev->stime, stime);
> +       prev->utime = max(prev->utime, rtime - prev->stime);
>
>         *ut = prev->utime;
>         *st = prev->stime;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
