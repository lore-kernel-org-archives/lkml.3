Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbaJPPFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 11:05:43 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:48924 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaJPPFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 11:05:41 -0400
Message-ID: <543FDEC8.1080102@gmail.com>
Date: Thu, 16 Oct 2014 08:05:44 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: dirk.brandewie@gmail.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: intel_pstate: Fix setting max_perf_pct in performance
 policy
References: <1413415011-31290-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1413415011-31290-1-git-send-email-pali.rohar@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2014 04:16 PM, Pali Rohár wrote:
> Code which changes policy to powersave changes also max_policy_pct based on
> max_freq. Code which change max_perf_pct has upper limit base on value
> max_policy_pct. When policy is changing from powersave back to performance
> then max_policy_pct is not changed. Which means that changing max_perf_pct is
> not possible to high values if max_freq was too low in powersave policy.
>
> Test case:
>
> $ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
> 800000
> $ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
> 3300000
> $ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
> performance
> $ cat /sys/devices/system/cpu/intel_pstate/max_perf_pct
> 100
>
> $ echo powersave > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
> $ echo 800000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
> $ echo 20 > /sys/devices/system/cpu/intel_pstate/max_perf_pct
>
> $ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
> powersave
> $ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
> 800000
> $ cat /sys/devices/system/cpu/intel_pstate/max_perf_pct
> 20
>
> $ echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
> $ echo 3300000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
> $ echo 100 > /sys/devices/system/cpu/intel_pstate/max_perf_pct
>
> $ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
> performance
> $ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
> 3300000
> $ cat /sys/devices/system/cpu/intel_pstate/max_perf_pct
> 24
>
> And now intel_pstate driver allows to set maximal value for max_perf_pct based
> on max_policy_pct which is 24 for previous powersave max_freq 800000.
>
> This patch will set default value for max_policy_pct when setting policy to
> performance so it will allow to set also max value for max_perf_pct.
>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>

Acked-by: Dirk Brandewie <dirk.j.brandewie@intel.com>

> Cc: stable@vger.kernel.org
> ---
>   drivers/cpufreq/intel_pstate.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index 0668b38..7547ab5 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -714,6 +714,7 @@ static int intel_pstate_set_policy(struct cpufreq_policy *policy)
>   	if (policy->policy == CPUFREQ_POLICY_PERFORMANCE) {
>   		limits.min_perf_pct = 100;
>   		limits.min_perf = int_tofp(1);
> +		limits.max_policy_pct = 100;
>   		limits.max_perf_pct = 100;
>   		limits.max_perf = int_tofp(1);
>   		limits.no_turbo = limits.turbo_disabled;
>

