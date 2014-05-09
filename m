Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbaEIQDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 12:03:16 -0400
Received: from mail1.windriver.com ([147.11.146.13]:50164 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaEIQDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 12:03:14 -0400
Message-ID: <536CFC46.8010408@windriver.com>
Date: Fri, 9 May 2014 12:03:18 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: John Stultz <john.stultz@linaro.org>,
        David Riley <davidriley@chromium.org>,
        Will Deacon <Will.Deacon@arm.com>, <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] init: Don't decrease loops_per_jiffy when a CPU comes
 up
References: <1399506651-20031-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1399506651-20031-1-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.56.57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-05-07 07:50 PM, Doug Anderson wrote:
> The loops_per_jiffy count continues to be updated as each CPU is
> brought up.  This causes problems when we've got an HMP system and
> different CPUs have different loops per jiffy.  On exynos 542x
> systems, for instance, the A7s will have significantly lower loops per
> jiffy than their big brothers.

Based on the other discussion for the ARM variant of this, I'm
assuming this also becomes a WFC issue.  And if not, then it
probably should go by John or similar ; getmaintainers is just
being dumb in spitting my name out, since I only made one
trivial change to this file a year ago or similar.

P.
--

> 
> We should always set the loops_per_jiffy the first time through, then
> use the max.
> 
> One could argue that complex HMP systems should really be completely
> ignoring the global loops_per_jiffy variable anyway.  That's probably
> why nobody has fixed this before.  With that argument you could say
> that while this change isn't incorrect, it's a bit misguided.  Still,
> it doesn't hurt and provides a better fallback than we had without
> this.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  init/calibrate.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/init/calibrate.c b/init/calibrate.c
> index 520702d..073bf9b 100644
> --- a/init/calibrate.c
> +++ b/init/calibrate.c
> @@ -265,40 +265,44 @@ unsigned long __attribute__((weak)) calibrate_delay_is_known(void)
>  void calibrate_delay(void)
>  {
>  	unsigned long lpj;
> -	static bool printed;
> +	static bool already_ran;
>  	int this_cpu = smp_processor_id();
>  
>  	if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
>  		lpj = per_cpu(cpu_loops_per_jiffy, this_cpu);
> -		if (!printed)
> +		if (!already_ran)
>  			pr_info("Calibrating delay loop (skipped) "
>  				"already calibrated this CPU");
>  	} else if (preset_lpj) {
>  		lpj = preset_lpj;
> -		if (!printed)
> +		if (!already_ran)
>  			pr_info("Calibrating delay loop (skipped) "
>  				"preset value.. ");
> -	} else if ((!printed) && lpj_fine) {
> +	} else if ((!already_ran) && lpj_fine) {
>  		lpj = lpj_fine;
>  		pr_info("Calibrating delay loop (skipped), "
>  			"value calculated using timer frequency.. ");
>  	} else if ((lpj = calibrate_delay_is_known())) {
>  		;
>  	} else if ((lpj = calibrate_delay_direct()) != 0) {
> -		if (!printed)
> +		if (!already_ran)
>  			pr_info("Calibrating delay using timer "
>  				"specific routine.. ");
>  	} else {
> -		if (!printed)
> +		if (!already_ran)
>  			pr_info("Calibrating delay loop... ");
>  		lpj = calibrate_delay_converge();
>  	}
>  	per_cpu(cpu_loops_per_jiffy, this_cpu) = lpj;
> -	if (!printed)
> +	if (!already_ran) {
>  		pr_cont("%lu.%02lu BogoMIPS (lpj=%lu)\n",
>  			lpj/(500000/HZ),
>  			(lpj/(5000/HZ)) % 100, lpj);
>  
> -	loops_per_jiffy = lpj;
> -	printed = true;
> +		loops_per_jiffy = lpj;
> +	} else {
> +		loops_per_jiffy = max(loops_per_jiffy, lpj);
> +	}
> +
> +	already_ran = true;
>  }
> 
