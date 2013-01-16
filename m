Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab3APMTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 07:19:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:30921 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab3APMS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 07:18:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,479,1355126400"; 
   d="scan'208";a="274439262"
Message-ID: <1358338729.2252.53.camel@rzhang1-mobl4>
Subject: Re: [PATCH v6 3/3] PM: Introduce Intel PowerClamp Driver
From: Zhang Rui <rui.zhang@intel.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Joe Perches <joe@perches.com>, Rob Landley <rob@landley.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Date: Wed, 16 Jan 2013 20:18:49 +0800
In-Reply-To: <1357297965-17839-4-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1357297965-17839-1-git-send-email-jacob.jun.pan@linux.intel.com>
	 <1357297965-17839-4-git-send-email-jacob.jun.pan@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jacob,

On Fri, 2013-01-04 at 03:12 -0800, Jacob Pan wrote:
> Intel PowerClamp driver performs synchronized idle injection across
> all online CPUs. The goal is to maintain a given package level C-state
> ratio.
> 
> Compared to other throttling methods already exist in the kernel,
> such as ACPI PAD (taking CPUs offline) and clock modulation, this is often
> more efficient in terms of performance per watt.
> 
> Please refer to Documentation/thermal/intel_powerclamp.txt for more details.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  Documentation/thermal/intel_powerclamp.txt |  307 +++++++++++
>  drivers/thermal/Kconfig                    |   10 +
>  drivers/thermal/Makefile                   |    2 +
>  drivers/thermal/intel_powerclamp.c         |  788 ++++++++++++++++++++++++++++
>  4 files changed, 1107 insertions(+)
>  create mode 100644 Documentation/thermal/intel_powerclamp.txt
>  create mode 100644 drivers/thermal/intel_powerclamp.c

> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index c2c77d1..7d90ab8 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -122,4 +122,14 @@ config DB8500_CPUFREQ_COOLING
>  	  bound cpufreq cooling device turns active to set CPU frequency low to
>  	  cool down the CPU.
>  
> +config INTEL_POWERCLAMP
> +	tristate "Intel PowerClamp idle injection driver"
> +	depends on THERMAL
> +	depends on X86
> +	depends on CPU_SUP_INTEL
> +	help
> +	  Enable this to enable Intel PowerClamp idle injection driver. This
> +	  enforce idle time which results in more package C-state residency. The
> +	  user interface is exposed via generic thermal framework.
> +
>  endif
> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
> index d8da683..574f5f5 100644
> --- a/drivers/thermal/Makefile
> +++ b/drivers/thermal/Makefile
> @@ -18,3 +18,5 @@ obj-$(CONFIG_RCAR_THERMAL)	+= rcar_thermal.o
>  obj-$(CONFIG_EXYNOS_THERMAL)	+= exynos_thermal.o
>  obj-$(CONFIG_DB8500_THERMAL)	+= db8500_thermal.o
>  obj-$(CONFIG_DB8500_CPUFREQ_COOLING)	+= db8500_cpufreq_cooling.o
> +obj-$(CONFIG_INTEL_POWERCLAMP)	+= intel_powerclamp.o
> +
> diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_powerclamp.c
> new file mode 100644
> index 0000000..314b6fc
> --- /dev/null
> +++ b/drivers/thermal/intel_powerclamp.c
> @@ -0,0 +1,788 @@
> +/*
> + * intel_powerclamp.c - package c-state idle injection
> + *
> + * Copyright (c) 2012, Intel Corporation.
> + *
> + * Authors:
> + *     Arjan van de Ven <arjan@linux.intel.com>
> + *     Jacob Pan <jacob.jun.pan@linux.intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> + *
> + *
> + *	TODO:
> + *           1. better handle wakeup from external interrupts, currently a fixed
> + *              compensation is added to clamping duration when excessive amount
> + *              of wakeups are observed during idle time. the reason is that in
> + *              case of external interrupts without need for ack, clamping down
> + *              cpu in non-irq context does not reduce irq. for majority of the
> + *              cases, clamping down cpu does help reduce irq as well, we should
> + *              be able to differenciate the two cases and give a quantitative
> + *              solution for the irqs that we can control. perhaps based on
> + *              get_cpu_iowait_time_us()
> + *
> + *	     2. synchronization with other hw blocks
> + *
> + *
> + */
> +
> +#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/delay.h>
> +#include <linux/kthread.h>
> +#include <linux/freezer.h>
> +#include <linux/cpu.h>
> +#include <linux/thermal.h>
> +#include <linux/slab.h>
> +#include <linux/tick.h>
> +#include <linux/debugfs.h>
> +#include <linux/seq_file.h>
> +#include <linux/nmi.h>
> +
drivers/thermal/intel_powerclamp.c: In function ‘clamp_thread’:
drivers/thermal/intel_powerclamp.c:435:4: error: implicit declaration of
function ‘local_touch_nmi’ [-Werror=implicit-function-declaration]

changing to 
#include <asm/nmi.h>
fixes the problem.

thanks,
rui


