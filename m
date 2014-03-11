Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbaCKAtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 20:49:24 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50501 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751945AbaCKAtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 20:49:22 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        joshc@codeaurora.org, robherring2@gmail.com
Subject: Re: [PATCH] cpufreq: SPEAr: Instantiate as platform_driver
Date: Tue, 11 Mar 2014 02:04:40 +0100
Message-ID: <3114708.oz7nbHtIzQ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <92837e0c0ed734bb82d3c7d78f58beb31b4e0c1f.1394446335.git.viresh.kumar@linaro.org>
References: <92837e0c0ed734bb82d3c7d78f58beb31b4e0c1f.1394446335.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 10, 2014 03:43:18 PM Viresh Kumar wrote:
> As multiplatform build is being adopted by more and more ARM platforms, initcall
> function should be used very carefully. For example, when SPEAr cpufreq driver
> is enabled on a kernel booted on a non-SPEAr board, we will get following boot
> time error:
> 
> 	spear_cpufreq: Invalid cpufreq_tbl
> 
> To eliminate this undesired the effect, the patch changes SPEAr driver to have
> it instantiated as a platform_driver. Then it will only run on platforms that
> create the platform_device "spear-cpufreq".
> 
> This patch also creates platform node for SPEAr13xx boards.
> 
> Reported-by: Josh Cartwright <joshc@codeaurora.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Whoever maintains the SPEAr platform, I need an ACK from that person in order
to take this patch.

> ---
>  arch/arm/mach-spear/spear1310.c |  1 +
>  arch/arm/mach-spear/spear1340.c |  1 +
>  drivers/cpufreq/spear-cpufreq.c | 13 +++++++++++--
>  3 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-spear/spear1310.c b/arch/arm/mach-spear/spear1310.c
> index 7ad0030..824b12a 100644
> --- a/arch/arm/mach-spear/spear1310.c
> +++ b/arch/arm/mach-spear/spear1310.c
> @@ -28,6 +28,7 @@
>  static void __init spear1310_dt_init(void)
>  {
>  	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> +	platform_device_register_simple("spear-cpufreq", -1, NULL, 0);
>  }
>  
>  static const char * const spear1310_dt_board_compat[] = {
> diff --git a/arch/arm/mach-spear/spear1340.c b/arch/arm/mach-spear/spear1340.c
> index 3fb6834..7b6bff7 100644
> --- a/arch/arm/mach-spear/spear1340.c
> +++ b/arch/arm/mach-spear/spear1340.c
> @@ -143,6 +143,7 @@ static void __init spear1340_dt_init(void)
>  {
>  	of_platform_populate(NULL, of_default_bus_match_table,
>  			spear1340_auxdata_lookup, NULL);
> +	platform_device_register_simple("spear-cpufreq", -1, NULL, 0);
>  }
>  
>  static const char * const spear1340_dt_board_compat[] = {
> diff --git a/drivers/cpufreq/spear-cpufreq.c b/drivers/cpufreq/spear-cpufreq.c
> index 410b54a..4cfdcff 100644
> --- a/drivers/cpufreq/spear-cpufreq.c
> +++ b/drivers/cpufreq/spear-cpufreq.c
> @@ -19,6 +19,7 @@
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/of_device.h>
> +#include <linux/platform_device.h>
>  #include <linux/slab.h>
>  #include <linux/types.h>
>  
> @@ -166,7 +167,7 @@ static struct cpufreq_driver spear_cpufreq_driver = {
>  	.attr		= cpufreq_generic_attr,
>  };
>  
> -static int spear_cpufreq_driver_init(void)
> +static int spear_cpufreq_probe(struct platform_device *pdev)
>  {
>  	struct device_node *np;
>  	const struct property *prop;
> @@ -234,7 +235,15 @@ out_put_node:
>  	of_node_put(np);
>  	return ret;
>  }
> -late_initcall(spear_cpufreq_driver_init);
> +
> +static struct platform_driver spear_cpufreq_platdrv = {
> +	.driver = {
> +		.name	= "spear-cpufreq",
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe		= spear_cpufreq_probe,
> +};
> +module_platform_driver(spear_cpufreq_platdrv);
>  
>  MODULE_AUTHOR("Deepak Sikri <deepak.sikri@st.com>");
>  MODULE_DESCRIPTION("SPEAr CPUFreq driver");
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
