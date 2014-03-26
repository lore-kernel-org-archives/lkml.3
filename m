Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaCZMoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 08:44:08 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:37147 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbaCZMoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 08:44:06 -0400
Message-ID: <5332CB7F.3070002@linux.vnet.ibm.com>
Date: Wed, 26 Mar 2014 18:13:43 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: tglx@linutronix.de, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        linaro-networking@linaro.org
Subject: Re: [PATCH 14/14] timer: don't emulate notifier call to initialize
 timer base
References: <cover.1395832156.git.viresh.kumar@linaro.org> <6df650d6e6d696a555b6cf81d53b428530496e63.1395832156.git.viresh.kumar@linaro.org>
In-Reply-To: <6df650d6e6d696a555b6cf81d53b428530496e63.1395832156.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032612-5564-0000-0000-00000CAF193D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2014 04:51 PM, Viresh Kumar wrote:
> In init_timers() we need to call init_timers_cpu() for boot CPU. For this,
> currently we are emulating a call to hotplug notifier. Probably this was done
> initially to get rid of code redundancy. But this sequence always called a
> single routine, i.e. init_timers_cpu(), and so calling that routine directly
> would be better. This would get rid of emulating a notifier call, few typecasts
> and the extra steps we are doing in notifier callback.
> 
> So, this patch calls init_timers_cpu() directly from init_timers().
>

Same here: I don't think this is a good idea, for the same reason I gave
for patch 12.

Regards,
Srivatsa S. Bhat
 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  kernel/timer.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/kernel/timer.c b/kernel/timer.c
> index 4360edc..d13eb56 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1666,15 +1666,9 @@ static struct notifier_block timers_nb = {
> 
>  void __init init_timers(void)
>  {
> -	int err;
> -
>  	/* ensure there are enough low bits for flags in timer->base pointer */
>  	BUILD_BUG_ON(__alignof__(struct tvec_base) & TIMER_FLAG_MASK);
> -
> -	err = timer_cpu_notify(&timers_nb, (unsigned long)CPU_UP_PREPARE,
> -			       (void *)(long)smp_processor_id());
> -	BUG_ON(err != NOTIFY_OK);
> -
> +	BUG_ON(init_timers_cpu(smp_processor_id()));
>  	init_timer_stats();
>  	register_cpu_notifier(&timers_nb);
>  	open_softirq(TIMER_SOFTIRQ, run_timer_softirq);
> 

