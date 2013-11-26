Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab3KZTjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 14:39:08 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37179 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab3KZTjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 14:39:04 -0500
Date: Tue, 26 Nov 2013 20:39:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@rjwysocki.net, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, tianyu.lan@intel.com, nm@ti.com,
        jinchoi@broadcom.com, sebastian.capella@linaro.org
Subject: Re: [PATCH V2 1/2] cpufreq: suspend governors on system
 suspend/hibernate
Message-ID: <20131126193902.GA2481@amd.pavel.ucw.cz>
References: <cover.1385118255.git.viresh.kumar@linaro.org>
 <e4bc55fac6bc68694e9905cc3cc6844173b64925.1385118256.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4bc55fac6bc68694e9905cc3cc6844173b64925.1385118256.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This patch adds cpufreq callbacks to dpm_{suspend|resume}_noirq() for handling
> suspend/resume of cpufreq governors. This is required for early suspend and late
> resume of governors.
> 
> There are multiple problems that are fixed by this patch:
> - Nishanth Menon (TI) found an interesting problem on his platform, OMAP. His board
>   wasn't working well with suspend/resume as calls for removing non-boot CPUs
>   was turning out into a call to drivers ->target() which then tries to play
>   with regulators. But regulators and their I2C bus were already suspended and
>   this resulted in a failure. This is why we need a PM notifier here.
> - Lan Tianyu (Intel) & Jinhyuk Choi (Broadcom) found another issue where
>   tunables configuration for clusters/sockets with non-boot CPUs was getting
>   lost after suspend/resume, as we were notifying governors with
>   CPUFREQ_GOV_POLICY_EXIT on removal of the last cpu for that policy and so
>   deallocating memory for tunables.
> 
> +/*
> + * Callbacks for suspending/resuming governors as some platforms can't change
> + * frequency after this point in suspend cycle. Because some of the devices
> + * (like: i2c, regulators, etc) they use for changing frequency are suspended
> + * quickly after this point.
> + */
> +void cpufreq_suspend(void)
> +{
> +	struct cpufreq_policy *policy;
> +	unsigned long flags;
> +
> +	if (!has_target())
> +		return;
> +
> +	pr_debug("%s: Suspending Governors\n", __func__);
> +
> +	list_for_each_entry(policy, &cpufreq_policy_list, policy_list)
> +		if (__cpufreq_governor(policy, CPUFREQ_GOV_STOP))
> +			pr_err("%s: Failed to stop governor for policy: %p\n",
> +					__func__, policy);

So... we freeze frequencies in whatever state they are, yes?

Should we go to some specific frequency?

For example, early athlon64 notebooks were unable to run on battery
power on max frequency... these days there are various "Turbo"
modes, but IIRC staying at high frequency there is only safe as long
as CPU stays cool enough...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
