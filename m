Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbaGIKeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 06:34:17 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:50553 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755598AbaGIKeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 06:34:13 -0400
Message-ID: <53BD1AA3.4000203@arm.com>
Date: Wed, 09 Jul 2014 11:34:11 +0100
From: Chris Redpath <Chris.Redpath@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
CC: "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>
Subject: Re: [RFC 2/7] hrtimer: don't check for active hrtimer after adding
 it
References: <cover.1404888801.git.viresh.kumar@linaro.org> <13861232628603285a2734e32b309abd73c8741c.1404888801.git.viresh.kumar@linaro.org>
In-Reply-To: <13861232628603285a2734e32b309abd73c8741c.1404888801.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On 09/07/14 07:55, Viresh Kumar wrote:
> hrtimer_start*() family never fails to enqueue a hrtimer to a clock-base. The
> only special case is when the hrtimer was in past. If it is getting enqueued to
> local CPUs's clock-base, we raise a softirq and exit, else we handle that on
> next interrupt on remote CPU.
>
> At several places in the kernel, we try to make sure if hrtimer was added
> properly or not by calling hrtimer_active(), like:
>
> 	hrtimer_start(timer, expires, mode);
> 	if (hrtimer_active(timer)) {
> 		/* Added successfully */
> 	} else {
> 		/* Was added in the past */
> 	}
>
> As hrtimer_start*() never fails, hrtimer_active() is guaranteed to return '1'.
> So, there is no point calling hrtimer_active().
>
> This patch updates hrtimer core to get this fixed.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>   kernel/hrtimer.c | 4 ----
>   1 file changed, 4 deletions(-)
>
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index cf40209..a76f962 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -1555,8 +1555,6 @@ static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mod
>   	do {
>   		set_current_state(TASK_INTERRUPTIBLE);
>   		hrtimer_start_expires(&t->timer, mode);
> -		if (!hrtimer_active(&t->timer))
> -			t->task = NULL;
>
>   		if (likely(t->task))
>   			freezable_schedule();
> @@ -1837,8 +1835,6 @@ schedule_hrtimeout_range_clock(ktime_t *expires, unsigned long delta,
>   	hrtimer_init_sleeper(&t, current);
>
>   	hrtimer_start_expires(&t.timer, mode);
> -	if (!hrtimer_active(&t.timer))
> -		t.task = NULL;
>
>   	if (likely(t.task))
>   		schedule();
>

Maybe safe to remove this if condition too.
