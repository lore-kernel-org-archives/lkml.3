Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723AbaHVOHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:07:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:25767 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130AbaHVOHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:07:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,380,1406617200"; 
   d="scan'208";a="562149592"
Message-ID: <53F74E5D.2040108@linux.intel.com>
Date: Fri, 22 Aug 2014 22:06:21 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Len Brown <lenb@kernel.org>
CC: Kumar P Mahesh <mahesh.kumar.p@intel.com>, Alan Cox <alan@linux.intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] intel_idle: add idle values for Cherrytrail/Braswell
References: <1408701508-13636-1-git-send-email-mika.westerberg@linux.intel.com> <1408707540-12393-1-git-send-email-mika.westerberg@linux.intel.com>
In-Reply-To: <1408707540-12393-1-git-send-email-mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/8/22 19:39, Mika Westerberg wrote:
> From: Mahesh Kumar P <mahesh.kumar.p@intel.com>
> 
> Cherrytrail/Braswell is a successor of Intel Baytrail but has slighly
> different CPU idle values and latencies.
> 
> Signed-off-by: Kumar P Mahesh <mahesh.kumar.p@intel.com>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
> I learned from Mahesh that C1e, C4 and S0i2 states are deprecated so those
> are now removed.

If the platform has ACPI supported, I believe Len wants to see what
C-states number exported by ACPI.

Please boot the machine with "intel_idle.max_cstate=0" to disable
intel_idle, then post the output of the following commands

dmesg | grep idle
grep . /sys/devices/system/cpu/cpu0/cpuidle/*/*

Thanks,
-Aubrey

> 
>  drivers/idle/intel_idle.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index 9b7ee7e427df..e472580c1826 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -197,6 +197,42 @@ static struct cpuidle_state snb_cstates[] = {
>  		.enter = NULL }
>  };
>  
> +static struct cpuidle_state cht_cstates[] = {
> +	{ /* MWAIT C1 */
> +		.name = "C1-CHT",
> +		.desc = "MWAIT 0x00",
> +		.flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
> +		.exit_latency = 1,
> +		.target_residency = 4,
> +		.enter = &intel_idle },
> +	{ /* MWAIT C6 */
> +		.name = "C6-CHT",
> +		.desc = "MWAIT 0x52",
> +		.flags = MWAIT2flg(0x52) | CPUIDLE_FLAG_TIME_VALID
> +						| CPUIDLE_FLAG_TLB_FLUSHED,
> +		.exit_latency = 140,
> +		.target_residency = 560,
> +		.enter = &intel_idle },
> +	{ /* MWAIT C7-S0i1 */
> +		.name = "S0i1-CHT",
> +		.desc = "MWAIT 0x60",
> +		.flags = MWAIT2flg(0x60) | CPUIDLE_FLAG_TIME_VALID
> +						| CPUIDLE_FLAG_TLB_FLUSHED,
> +		.exit_latency = 1200,
> +		.target_residency = 4000,
> +		.enter = &intel_idle },
> +	{ /* MWAIT C9-S0i3 */
> +		.name = "S0i3-CHT",
> +		.desc = "MWAIT 0x64",
> +		.flags = MWAIT2flg(0x64) | CPUIDLE_FLAG_TIME_VALID
> +						| CPUIDLE_FLAG_TLB_FLUSHED,
> +		.exit_latency = 10000,
> +		.target_residency = 20000,
> +		.enter = &intel_idle },
> +	{
> +		.enter = NULL }
> +};
> +
>  static struct cpuidle_state byt_cstates[] = {
>  	{
>  		.name = "C1-BYT",
> @@ -677,6 +713,11 @@ static const struct idle_cpu idle_cpu_byt = {
>  	.byt_auto_demotion_disable_flag = true,
>  };
>  
> +static const struct idle_cpu idle_cpu_cht = {
> +	.state_table = cht_cstates,
> +	.disable_promotion_to_c1e = true,
> +};
> +
>  static const struct idle_cpu idle_cpu_ivb = {
>  	.state_table = ivb_cstates,
>  	.disable_promotion_to_c1e = true,
> @@ -725,6 +766,7 @@ static const struct x86_cpu_id intel_idle_ids[] = {
>  	ICPU(0x3f, idle_cpu_hsw),
>  	ICPU(0x45, idle_cpu_hsw),
>  	ICPU(0x46, idle_cpu_hsw),
> +	ICPU(0x4c, idle_cpu_cht),
>  	ICPU(0x4d, idle_cpu_avn),
>  	ICPU(0x3d, idle_cpu_bdw),
>  	ICPU(0x4f, idle_cpu_bdw),
> 

