Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbaCZMkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 08:40:31 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:35396 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbaCZMka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 08:40:30 -0400
Message-ID: <5332CAA7.8000901@linux.vnet.ibm.com>
Date: Wed, 26 Mar 2014 18:10:07 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: tglx@linutronix.de, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        linaro-networking@linaro.org
Subject: Re: [PATCH 12/14] hrtimer: don't emulate notifier call to initialize
 timer base
References: <cover.1395832156.git.viresh.kumar@linaro.org> <7eb4d1a03031b4d873ce08e8912900d7936a3ca8.1395832156.git.viresh.kumar@linaro.org>
In-Reply-To: <7eb4d1a03031b4d873ce08e8912900d7936a3ca8.1395832156.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032612-8878-0000-0000-00000B7FAA11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2014 04:51 PM, Viresh Kumar wrote:
> In hrtimers_init() we need to call init_hrtimers_cpu() for boot CPU. For this,
> currently we are emulating a call to hotplug notifier. Probably this was done
> initially to get rid of code redundancy. But this sequence always called a
> single routine, i.e. init_hrtimers_cpu(), and so calling that routine directly
> would be better. This would get rid of emulating a notifier call, few typecasts
> and the extra steps we are doing in notifier callback.
> 
> So, this patch calls init_hrtimers_cpu() directly from hrtimers_init().
>

I don't think this is such a good idea. Open-coding a part of that callback
in the init routine can lead to loop-holes down the road: what if someone
changes or adds something to the CPU_UP_PREPARE switch-case, and forgets to
do the same in the init-routine?

It is more comforting to know that there is just one single place where CPU
hotplug operations are handled (hrtimer_cpu_notify). That, in turn is good
for reliability because it makes it easier to write bug-free code.

Regards,
Srivatsa S. Bhat
 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  kernel/hrtimer.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index f14d861..39dbdbd 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -1756,8 +1756,7 @@ static struct notifier_block hrtimers_nb = {
> 
>  void __init hrtimers_init(void)
>  {
> -	hrtimer_cpu_notify(&hrtimers_nb, (unsigned long)CPU_UP_PREPARE,
> -			  (void *)(long)smp_processor_id());
> +	init_hrtimers_cpu(smp_processor_id());
>  	register_cpu_notifier(&hrtimers_nb);
>  #ifdef CONFIG_HIGH_RES_TIMERS
>  	open_softirq(HRTIMER_SOFTIRQ, run_hrtimer_softirq);
> 

