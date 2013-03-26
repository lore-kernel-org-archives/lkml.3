Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933869Ab3CZNRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:17:14 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:59625 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128Ab3CZNRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:17:12 -0400
Message-ID: <51519FD3.5000402@gmail.com>
Date: Tue, 26 Mar 2013 08:17:07 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, nicolas.pitre@linaro.org,
        robin.randhawa@arm.com, linux@arm.linux.org.uk,
        mark.hambleton@broadcom.com, linux-pm@vger.kernel.org,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        devicetree-discuss@lists.ozlabs.org, Liviu.Dudau@arm.com,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Steve.Bannister@arm.com,
        arvind.chauhan@arm.com, linux-arm-kernel@lists.infradead.org,
        charles.garcia-tobin@arm.com,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH V2] cpufreq: ARM big LITTLE: Add generic cpufreq driver
 and its DT glue
References: <1f864ec505cae7c5daea3810a3c26e0f5cda38ea.1364290815.git.viresh.kumar@linaro.org>
In-Reply-To: <1f864ec505cae7c5daea3810a3c26e0f5cda38ea.1364290815.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2013 04:51 AM, Viresh Kumar wrote:
> big LITTLE is ARM's new Architecture focussing power/performance needs of modern
> world. More information about big LITTLE can be found here:
> 
> http://www.arm.com/products/processors/technologies/biglittleprocessing.php
> http://lwn.net/Articles/481055/
> 
> In order to keep cpufreq support for all big LITTLE platforms simple/generic,
> this patch tries to add a generic cpufreq driver layer for all big LITTLE
> platforms.
> 
> The driver is divided into two parts:
> - Core driver: Generic and shared across all big LITTLE SoC's
> - Glue drivers: Per platform drivers providing ops to the core driver
> 
> This patch adds in a generic glue driver which would extract information from
> Device Tree.
> 
> Future SoC's can either reuse the DT glue or write their own depending on the
> need.
> 
> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> V1->V2:
> - It was reviewed here earlier: https://lkml.org/lkml/2013/3/4/614
> - It supports OPP library now and doesn't create a new binding for cpufreq table
> - It doesn't add any dependency on cluster node in DT, rather we work with
>   existing cpu nodes, Documentation updated.
> - cpu_dev used because of OPP library and hence dev_err/dbg/info used at
>   multiple places.
> - Interface with glue driver updated a bit
> - IS_ERR_OR_NULL replaced with IS_ERR for clk_get
> - clk_get_sys used instead of clk_get and name of clk is also updated
> - Few more minor cleanups done.
> 
> It is pushed here:
> 
> http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/cpufreq-biglittle
> 
>  .../bindings/cpufreq/arm_big_little_dt.txt         |  65 +++++
>  MAINTAINERS                                        |  11 +
>  drivers/cpufreq/Kconfig.arm                        |  12 +
>  drivers/cpufreq/Makefile                           |   4 +
>  drivers/cpufreq/arm_big_little.c                   | 282 +++++++++++++++++++++
>  drivers/cpufreq/arm_big_little.h                   |  40 +++
>  drivers/cpufreq/arm_big_little_dt.c                |  92 +++++++
>  7 files changed, 506 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/cpufreq/arm_big_little_dt.txt
>  create mode 100644 drivers/cpufreq/arm_big_little.c
>  create mode 100644 drivers/cpufreq/arm_big_little.h
>  create mode 100644 drivers/cpufreq/arm_big_little_dt.c
> 
> diff --git a/Documentation/devicetree/bindings/cpufreq/arm_big_little_dt.txt b/Documentation/devicetree/bindings/cpufreq/arm_big_little_dt.txt
> new file mode 100644
> index 0000000..34a460d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/cpufreq/arm_big_little_dt.txt
> @@ -0,0 +1,65 @@
> +Generic ARM big LITTLE cpufreq driver's DT glue
> +-----------------------------------------------
> +
> +This is DT specific glue layer for generic cpufreq driver for big LITTLE
> +systems.

I fail to see anything bL specific here. This is just multi-cluster, but
even for that I don't see anything new other than simply allowing per
cpu or per cluster opp's. The fact that we have one opp for a cluster is
simply an implementation decision in CortexA cores.

> +
> +Both required and optional properties listed below must be defined
> +under node /cpus/cpu@x. Where x is the first cpu inside a cluster.
> +
> +NOTE: Cpus should boot in the order specified in DT and all cpus for a cluster
> +must be present contiguously. Generic DT driver will check only node 'x' for
> +cpu:x.

The OS cannot necessarily control the order. The OS should be able to
boot on which ever core comes up first.

> +
> +Required properties:
> +- operating-points: Refer to Documentation/devicetree/bindings/power/opp.txt
> +  for details
> +
> +Optional properties:
> +- clock-latency: Specify the possible maximum transition latency for clock,
> +  in unit of nanoseconds.

Don't we already have "transition-latency" defined? Don't create
something new. Ideally, this should have had "-ns" appended, but the
binding is already defined.

> +
> +Examples:
> +
> +cpus {
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +
> +	cpu@0 {
> +		compatible = "arm,cortex-a15";
> +		reg = <0>;
> +		next-level-cache = <&L2>;
> +		operating-points = <
> +			/* kHz    uV */
> +			792000  1100000
> +			396000  950000
> +			198000  850000
> +		>;
> +		clock-latency = <61036>; /* two CLK32 periods */
> +	};
> +
> +	cpu@1 {
> +		compatible = "arm,cortex-a15";
> +		reg = <1>;
> +		next-level-cache = <&L2>;
> +	};
> +
> +	cpu@100 {
> +		compatible = "arm,cortex-a7";
> +		reg = <100>;
> +		next-level-cache = <&L2>;
> +		operating-points = <
> +			/* kHz    uV */
> +			792000  950000
> +			396000  750000
> +			198000  450000
> +		>;
> +		clock-latency = <61036>; /* two CLK32 periods */
> +	};
> +
> +	cpu@101 {
> +		compatible = "arm,cortex-a7";
> +		reg = <101>;
> +		next-level-cache = <&L2>;
> +	};
> +};
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4cf5fd3..4071b71 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2206,6 +2206,17 @@ S:	Maintained
>  F:	drivers/cpufreq/
>  F:	include/linux/cpufreq.h
>  
> +CPU FREQUENCY DRIVERS - ARM BIG LITTLE
> +M:	Viresh Kumar <viresh.kumar@linaro.org>
> +M:	Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> +L:	cpufreq@vger.kernel.org
> +L:	linux-pm@vger.kernel.org
> +W:	http://www.arm.com/products/processors/technologies/biglittleprocessing.php
> +S:	Maintained
> +F:	drivers/cpufreq/arm_big_little.h
> +F:	drivers/cpufreq/arm_big_little.c
> +F:	drivers/cpufreq/arm_big_little_dt.c
> +
>  CPUID/MSR DRIVER
>  M:	"H. Peter Anvin" <hpa@zytor.com>
>  S:	Maintained
> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
> index 030ddf6..87b7e48 100644
> --- a/drivers/cpufreq/Kconfig.arm
> +++ b/drivers/cpufreq/Kconfig.arm
> @@ -2,6 +2,18 @@
>  # ARM CPU Frequency scaling drivers
>  #
>  
> +config ARM_BIG_LITTLE_CPUFREQ
> +	tristate
> +	depends on ARM_CPU_TOPOLOGY
> +
> +config ARM_DT_BL_CPUFREQ
> +	tristate "Generic ARM big LITTLE CPUfreq driver probed via DT"
> +	select ARM_BIG_LITTLE_CPUFREQ
> +	depends on OF && HAVE_CLK
> +	help
> +	  This enables the Generic CPUfreq driver for ARM big.LITTLE platform.
> +	  This gets frequency tables from DT.
> +
>  config ARM_OMAP2PLUS_CPUFREQ
>  	bool "TI OMAP2+"
>  	depends on ARCH_OMAP2PLUS
> diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
> index 863fd18..d1b0832 100644
> --- a/drivers/cpufreq/Makefile
> +++ b/drivers/cpufreq/Makefile
> @@ -44,6 +44,10 @@ obj-$(CONFIG_X86_INTEL_PSTATE)		+= intel_pstate.o
>  
>  ##################################################################################
>  # ARM SoC drivers
> +obj-$(CONFIG_ARM_BIG_LITTLE_CPUFREQ)	+= arm_big_little.o
> +# big LITTLE per platform glues. Keep DT_BL_CPUFREQ as the last entry in all big
> +# LITTLE drivers, so that it is probed last.
> +obj-$(CONFIG_ARM_DT_BL_CPUFREQ)	+= arm_big_little_dt.o
>  obj-$(CONFIG_UX500_SOC_DB8500)		+= dbx500-cpufreq.o
>  obj-$(CONFIG_ARM_S3C2416_CPUFREQ)	+= s3c2416-cpufreq.o
>  obj-$(CONFIG_ARM_S3C64XX_CPUFREQ)	+= s3c64xx-cpufreq.o
> diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
> new file mode 100644
> index 0000000..1d29d1a
> --- /dev/null
> +++ b/drivers/cpufreq/arm_big_little.c
> @@ -0,0 +1,282 @@
> +/*
> + * ARM big.LITTLE Platforms CPUFreq support

What is specific to bL? This looks like just a multi-cluster cpufreq
driver and should be generalized to that. Also, why can't the existing
cpufreq-cpu0 driver be extended to support this?

> + * Copyright (C) 2013 ARM Ltd.
> + * Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> + *
> + * Copyright (C) 2013 Linaro.
> + * Viresh Kumar <viresh.kumar@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/clk.h>
> +#include <linux/cpu.h>
> +#include <linux/cpufreq.h>
> +#include <linux/cpumask.h>
> +#include <linux/export.h>
> +#include <linux/of_platform.h>
> +#include <linux/opp.h>
> +#include <linux/slab.h>
> +#include <linux/topology.h>
> +#include <linux/types.h>
> +
> +#include "arm_big_little.h"
> +
> +/* Currently we support only two clusters */
> +#define MAX_CLUSTERS	2

Why? Because that is what the define is or there are other limitations?
Seems like this could and should be dynamically discovered with DT.

Rob

