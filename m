Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab3KZGtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 01:49:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:24925 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117Ab3KZGtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 01:49:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,772,1378882800"; 
   d="scan'208";a="414901710"
Message-ID: <529441B7.90505@intel.com>
Date: Tue, 26 Nov 2013 14:37:43 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@rjwysocki.net, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, nm@ti.com, swarren@wwwdotorg.org,
        kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, jinchoi@broadcom.com,
        sebastian.capella@linaro.org, jhbird.choi@samsung.com
Subject: Re: [PATCH V3 0/6] cpufreq: suspend early/resume late
References: <cover.1385374819.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1385374819.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年11月25日 22:11, Viresh Kumar wrote:
> This patchset adds cpufreq callbacks to dpm_{suspend|resume}() for handling
> suspend/resume of cpufreq governors and core. This is required for early suspend
> and late resume of governors and cpufreq core.
> 
> There are multiple problems that are fixed by this patch:
> - Nishanth Menon (TI) found an interesting problem on his platform, OMAP. His board
>   wasn't working well with suspend/resume as calls for removing non-boot CPUs
>   was turning out into a call to drivers ->target() which then tries to play
>   with regulators. But regulators and their I2C bus were already suspended and
>   this resulted in a failure. Many platforms have such problems, samsung, tegra,
>   etc.. They solved it with driver specific PM notifiers where they used to
>   disable their driver's ->target() routine. Most of these are updated in this
>   patchset to use new infrastructure.
> 
> - Lan Tianyu (Intel) & Jinhyuk Choi (Broadcom) found another issue where
>   tunables configuration for clusters/sockets with non-boot CPUs was getting
>   lost after suspend/resume, as we were notifying governors with
>   CPUFREQ_GOV_POLICY_EXIT on removal of the last cpu for that policy and so
>   deallocating memory for tunables. This is also fixed with this patch as don't
>   allow any operation on Governors during suspend/resume now.
> 
> 
> So to solve these issues we introduce early suspend and late resume callbacks
> which would remove need of cpufreq drivers to implement PM notifiers to disable
> transition after suspend and before resume.
> 
> @Nishanth: Can you please test V2 as well and confirm that suspend_noirq()
> doesn't work for you. I am sure it will not, but would be better if you confirm
> that.
> 
> Viresh Kumar (6):
>   cpufreq: suspend governors on system suspend/hibernate
>   cpufreq: call driver's suspend/resume for each policy
>   cpufreq: Implement cpufreq_generic_suspend()
>   cpufreq: exynos: Use cpufreq_generic_suspend()
>   cpufreq: s5pv210: Use cpufreq_generic_suspend()
>   cpufreq: Tegra: Use cpufreq_generic_suspend()
> 

Patch 1-2,
Tested-by: Lan Tianyu <tianyu.lan@intel.com>

>  drivers/base/power/main.c         |   5 ++
>  drivers/cpufreq/cpufreq.c         | 133 +++++++++++++++++++++-----------------
>  drivers/cpufreq/exynos-cpufreq.c  |  97 ++-------------------------
>  drivers/cpufreq/s5pv210-cpufreq.c |  49 +-------------
>  drivers/cpufreq/tegra-cpufreq.c   |  54 ++--------------
>  include/linux/cpufreq.h           |   6 ++
>  6 files changed, 99 insertions(+), 245 deletions(-)
> 


-- 
Best regards
Tianyu Lan
