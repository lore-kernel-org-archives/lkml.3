Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbaIZPPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:15:21 -0400
Received: from mail-bl2on0056.outbound.protection.outlook.com ([65.55.169.56]:50784
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754412AbaIZPPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:15:19 -0400
X-Greylist: delayed 917 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Sep 2014 11:15:18 EDT
Message-ID: <54257E8C.8000102@opensource.altera.com>
Date: Fri, 26 Sep 2014 09:56:12 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: <atull@opensource.altera.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH 2/2] socfpga: support suspend to ram
References: <1411590449-9794-1-git-send-email-atull@opensource.altera.com> <1411590449-9794-3-git-send-email-atull@opensource.altera.com>
In-Reply-To: <1411590449-9794-3-git-send-email-atull@opensource.altera.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0050.namprd02.prod.outlook.com (10.141.56.50) To
 BY1PR0301MB1192.namprd03.prod.outlook.com (25.160.195.150)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1192;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(6009001)(51704005)(377454003)(479174003)(189002)(24454002)(22564002)(199003)(83322001)(54356999)(31966008)(87266999)(33656002)(92726001)(47776003)(120916001)(79102003)(101416001)(81342003)(50986999)(19580395003)(50466002)(85852003)(65816999)(15975445006)(76482002)(42186005)(23746002)(86362001)(4396001)(15202345003)(64126003)(92566001)(83506001)(76176999)(74502003)(20776003)(102836001)(46102003)(74662003)(65956001)(10300001)(21056001)(99136001)(66066001)(19580405001)(80316001)(77982003)(81542003)(59896002)(64706001)(105586002)(80022003)(107046002)(97736003)(83072002)(87976001)(95666004)(77096002)(99396003)(85306004)(65806001)(2004002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1192;H:[137.57.160.210];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 03:27 PM, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
> 
> Add code that requests that the sdr controller go into
> self-refresh mode.  This code is run from ocram.
> 
> This patch assumes that u-boot has already configured sdr:
>   sdr.ctrlcfg.lowpwreq.selfrfshmask = 3
>   sdr.ctrlcfg.lowpwrtiming.clkdisablecycles = 8
>   sdr.ctrlcfg.dramtiming4.selfrfshexit = 512
> 
> How to suspend to ram:
>  $ echo enabled > \
> /sys/devices/soc/ffc02000.serial0/tty/ttyS0/power/wakeup
> 
>  $ echo -n mem > /sys/power/state
> 
> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> ---
>  arch/arm/mach-socfpga/Makefile       |    1 +
>  arch/arm/mach-socfpga/core.h         |    4 +
>  arch/arm/mach-socfpga/pm.c           |  141 ++++++++++++++++++++++++++++++++
>  arch/arm/mach-socfpga/self-refresh.S |  148 ++++++++++++++++++++++++++++++++++
>  arch/arm/mach-socfpga/socfpga.c      |   10 +++
>  5 files changed, 304 insertions(+)
>  create mode 100644 arch/arm/mach-socfpga/pm.c
>  create mode 100644 arch/arm/mach-socfpga/self-refresh.S
> 
> diff --git a/arch/arm/mach-socfpga/Makefile b/arch/arm/mach-socfpga/Makefile
> index 6dd7a93..0591927 100644
> --- a/arch/arm/mach-socfpga/Makefile
> +++ b/arch/arm/mach-socfpga/Makefile
> @@ -4,3 +4,4 @@
>  
>  obj-y					:= socfpga.o
>  obj-$(CONFIG_SMP)	+= headsmp.o platsmp.o
> +obj-$(CONFIG_SUSPEND)	+= pm.o self-refresh.o
> diff --git a/arch/arm/mach-socfpga/core.h b/arch/arm/mach-socfpga/core.h
> index c4a0929..cc1a2fb 100644
> --- a/arch/arm/mach-socfpga/core.h
> +++ b/arch/arm/mach-socfpga/core.h
> @@ -38,6 +38,7 @@ extern void socfpga_sysmgr_init(void);
>  
>  extern void __iomem *sys_manager_base_addr;
>  extern void __iomem *rst_manager_base_addr;
> +extern void __iomem *sdr_ctl_base_addr;
>  
>  extern struct smp_operations socfpga_smp_ops;
>  extern char secondary_trampoline, secondary_trampoline_end;
> @@ -46,4 +47,7 @@ extern unsigned long cpu1start_addr;
>  
>  #define SOCFPGA_SCU_VIRT_BASE   0xfffec000
>  
> +u32 socfpga_sdram_self_refresh(u32 sdr_base, u32 scu_base);
> +extern unsigned int socfpga_sdram_self_refresh_sz;
> +
>  #endif
> diff --git a/arch/arm/mach-socfpga/pm.c b/arch/arm/mach-socfpga/pm.c
> new file mode 100644
> index 0000000..02c3719
> --- /dev/null
> +++ b/arch/arm/mach-socfpga/pm.c
> @@ -0,0 +1,141 @@
> +/*
> + *  arch/arm/mach-socfpga/pm.c
> + *
> + * Copyright (C) 2014 Altera Corporation. All rights reserved.
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
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/bitops.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/of_platform.h>
> +#include <linux/suspend.h>
> +#include <asm/suspend.h>
> +#include <asm/fncpy.h>
> +#include "core.h"
> +
> +/* Pointer to function copied to ocram */
> +static u32 (*socfpga_sdram_self_refresh_in_ocram)(u32 sdr_base, u32 scu_base);
> +
> +/* Round up a pointer address to fix aligment for fncpy() */
> +static void *fncpy_align(void *ptr)
> +{
> +	u32 value = (u32)ptr;
> +
> +	if ((value & (FNCPY_ALIGN - 1)) != 0)
> +		value = ((value & ~(FNCPY_ALIGN - 1)) + FNCPY_ALIGN);
> +
> +	return (void *)value;
> +}
> +
> +static void *socfpga_init_ocram_exec(void)
> +{
> +	struct device_node *np;
> +	const __be32 *prop;
> +	u32 ocram_hwaddr, len;
> +	void __iomem  *iomem_exec_ocram;
> +	size_t size;
> +
> +	np = of_find_compatible_node(NULL, NULL, "mmio-sram");
> +	if (!np) {
> +		pr_err("SOCFPGA: Unable to find mmio-sram in dtb\n");
> +		return 0;
> +	}
> +
> +	/* Determine the OCRAM address and size */
> +	prop = of_get_property(np, "reg", &size);
> +	ocram_hwaddr = be32_to_cpup(prop++);
> +	len = be32_to_cpup(prop);
> +
> +	if (!prop || size < sizeof(*prop)) {
> +		pr_err("SOCFPGA: Unable to find OCRAM mapping in dtb\n");
> +		return 0;
> +	}
> +
> +	iomem_exec_ocram = __arm_ioremap_exec(ocram_hwaddr, len, 0);

The call to __arm_ioremap_exec can fail. Also, this doesn't seem right,
what if a good chunk of OCRAM has been used by some other driver in the
system? From what I've seen, OCRAM should be using the generic allocator
framework.

> +
> +	/* Fix alignment to work with fncpy */
> +	iomem_exec_ocram = fncpy_align(iomem_exec_ocram);
> +
> +	return iomem_exec_ocram;
> +}
> +
> +static int socfpga_setup_ocram_self_refresh(void)
> +{
> +	void *ocram_addr;
> +
> +	/* Configure ocram and make it executable */
> +	ocram_addr = socfpga_init_ocram_exec();
> +	WARN(!ocram_addr, "Unable to initialize ocram for pm");
> +	if (!ocram_addr)
> +		return -EFAULT;
> +
> +	/* Copy the code that puts DDR in self refresh to ocram */
> +	socfpga_sdram_self_refresh_in_ocram =
> +		(void *)fncpy((void *)ocram_addr,
> +		      &socfpga_sdram_self_refresh,
> +		      socfpga_sdram_self_refresh_sz);
> +
> +	WARN(!socfpga_sdram_self_refresh_in_ocram,
> +	     "could not copy function to ocram");
> +	if (!socfpga_sdram_self_refresh_in_ocram)
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static int socfpga_pm_suspend(unsigned long arg)
> +{
> +	u32 ret;
> +
> +	ret = socfpga_sdram_self_refresh_in_ocram((u32)sdr_ctl_base_addr,
> +						  (u32)socfpga_scu_base_addr);

What if sdr_ctl_base_addr is not valid?

BR,
Dinh

