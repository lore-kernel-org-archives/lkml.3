Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaEUOHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:07:33 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48222 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaEUOHc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:07:32 -0400
Message-ID: <537CB328.6000400@arm.com>
Date: Wed, 21 May 2014 15:07:36 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        Shawn Guo <shawn.guo@linaro.org>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        "inderpal.s@samsung.com" <inderpal.s@samsung.com>,
        "nm@ti.com" <nm@ti.com>,
        "chander.kashyap@linaro.org" <chander.kashyap@linaro.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "len.brown@intel.com" <len.brown@intel.com>
Subject: Re: [PATCH V2 5/7] cpufreq: imx6q: don't initialize opp table
References: <cover.1400670427.git.viresh.kumar@linaro.org> <cc399206d57ef946d27a98203c6b0a247cd1b245.1400670427.git.viresh.kumar@linaro.org>
In-Reply-To: <cc399206d57ef946d27a98203c6b0a247cd1b245.1400670427.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 21 May 2014 14:07:31.0074 (UTC) FILETIME=[0161DE20:01CF74FE]
X-MC-Unique: 114052115073004401
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 21/05/14 12:10, Viresh Kumar wrote:
> OPP tables are already initialized for CPU0 by cpufreq core and so we don't need
> to reinitialize them from imx6q specific code.
>
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>   arch/arm/mach-imx/mach-imx6q.c  | 36 ++++++++----------------------------
>   drivers/cpufreq/imx6q-cpufreq.c | 20 +-------------------
>   2 files changed, 9 insertions(+), 47 deletions(-)
>
> diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
> index e60456d..03819e7 100644
> --- a/arch/arm/mach-imx/mach-imx6q.c
> +++ b/arch/arm/mach-imx/mach-imx6q.c
> @@ -290,12 +290,18 @@ static void __init imx6q_init_machine(void)
>   #define OCOTP_CFG3_SPEED_996MHZ		0x2
>   #define OCOTP_CFG3_SPEED_852MHZ		0x1
>
> -static void __init imx6q_opp_check_speed_grading(struct device *cpu_dev)
> +static void __init imx6q_opp_check_speed_grading(void)
>   {
> +	struct device *cpu_dev = get_cpu_device(0);
>   	struct device_node *np;
>   	void __iomem *base;
>   	u32 val;
>
> +	if (!cpu_dev) {
> +		pr_warn("failed to get cpu0 device\n");
> +		return;
> +	}
> +
>   	np = of_find_compatible_node(NULL, NULL, "fsl,imx6q-ocotp");
>   	if (!np) {
>   		pr_warn("failed to find ocotp node\n");
> @@ -336,32 +342,6 @@ put_node:
>   	of_node_put(np);
>   }
>
> -static void __init imx6q_opp_init(void)
> -{
> -	struct device_node *np;
> -	struct device *cpu_dev = get_cpu_device(0);
> -
> -	if (!cpu_dev) {
> -		pr_warn("failed to get cpu0 device\n");
> -		return;
> -	}
> -	np = of_node_get(cpu_dev->of_node);
> -	if (!np) {
> -		pr_warn("failed to find cpu0 node\n");
> -		return;
> -	}
> -
> -	if (of_init_opp_table(cpu_dev)) {
> -		pr_warn("failed to init OPP table\n");
> -		goto put_node;
> -	}
> -
> -	imx6q_opp_check_speed_grading(cpu_dev);
> -
> -put_node:
> -	of_node_put(np);
> -}
> -
>   static struct platform_device imx6q_cpufreq_pdev = {
>   	.name = "imx6q-cpufreq",
>   };
> @@ -376,7 +356,7 @@ static void __init imx6q_init_late(void)
>   		imx6q_cpuidle_init();
>
>   	if (IS_ENABLED(CONFIG_ARM_IMX6Q_CPUFREQ)) {
> -		imx6q_opp_init();
> +		imx6q_opp_check_speed_grading();

[Query] Not exactly related to this patch, but asking it here to get clarified.

This OPP limiting is done as part of late initcall and if the cpufreq driver is
built in the kernel, there will be a small window where the OPPs not supported
are still enabled ? Will that not be an issue if say performance governor is
selected by default.

Regards,
Sudeep

