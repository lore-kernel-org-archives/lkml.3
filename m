Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbaIZU3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:29:20 -0400
Received: from mail-bn1bon0058.outbound.protection.outlook.com ([157.56.111.58]:31648
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755234AbaIZU3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:29:19 -0400
Date: Fri, 26 Sep 2014 15:23:07 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Dinh Nguyen <dinguyen@opensource.altera.com>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <delicious.quinoa@gmail.com>,
        <yvanderv@opensource.altera.com>
Subject: Re: [PATCH 2/2] socfpga: support suspend to ram
In-Reply-To: <54257E8C.8000102@opensource.altera.com>
Message-ID: <alpine.DEB.2.02.1409261519320.1444@atx-linux-37>
References: <1411590449-9794-1-git-send-email-atull@opensource.altera.com> <1411590449-9794-3-git-send-email-atull@opensource.altera.com> <54257E8C.8000102@opensource.altera.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY2PR04CA060.namprd04.prod.outlook.com (10.141.249.178) To
 BL2PR03MB306.namprd03.prod.outlook.com (10.141.68.14)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB306;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(22564002)(51704005)(199003)(24454002)(377454003)(479174003)(85852003)(66066001)(76482002)(90102001)(95666004)(46406003)(106356001)(53416004)(86152002)(74502003)(50466002)(21056001)(50986999)(19580395003)(47776003)(15202345003)(101416001)(80022003)(54356999)(4396001)(81542003)(86362001)(83322001)(97736003)(64706001)(33716001)(69596002)(15975445006)(20776003)(92726001)(83506001)(19580405001)(77096002)(107046002)(85306004)(77982003)(83072002)(120916001)(81342003)(92566001)(87976001)(31966008)(99396003)(10300001)(23726002)(105586002)(46102003)(81156004)(102836001)(42186005)(110136001)(74662003)(76176999)(79102003)(2004002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB306;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2014, Dinh Nguyen wrote:

> On 09/24/2014 03:27 PM, atull@opensource.altera.com wrote:
> > From: Alan Tull <atull@opensource.altera.com>
> > 
> > Add code that requests that the sdr controller go into
> > self-refresh mode.  This code is run from ocram.
> > 
> > This patch assumes that u-boot has already configured sdr:
> >   sdr.ctrlcfg.lowpwreq.selfrfshmask = 3
> >   sdr.ctrlcfg.lowpwrtiming.clkdisablecycles = 8
> >   sdr.ctrlcfg.dramtiming4.selfrfshexit = 512
> > 
> > How to suspend to ram:
> >  $ echo enabled > \
> > /sys/devices/soc/ffc02000.serial0/tty/ttyS0/power/wakeup
> > 
> >  $ echo -n mem > /sys/power/state
> > 
> > Signed-off-by: Alan Tull <atull@opensource.altera.com>
> > ---
> >  arch/arm/mach-socfpga/Makefile       |    1 +
> >  arch/arm/mach-socfpga/core.h         |    4 +
> >  arch/arm/mach-socfpga/pm.c           |  141 ++++++++++++++++++++++++++++++++
> >  arch/arm/mach-socfpga/self-refresh.S |  148 ++++++++++++++++++++++++++++++++++
> >  arch/arm/mach-socfpga/socfpga.c      |   10 +++
> >  5 files changed, 304 insertions(+)
> >  create mode 100644 arch/arm/mach-socfpga/pm.c
> >  create mode 100644 arch/arm/mach-socfpga/self-refresh.S
> > 
> > diff --git a/arch/arm/mach-socfpga/Makefile b/arch/arm/mach-socfpga/Makefile
> > index 6dd7a93..0591927 100644
> > --- a/arch/arm/mach-socfpga/Makefile
> > +++ b/arch/arm/mach-socfpga/Makefile
> > @@ -4,3 +4,4 @@
> >  
> >  obj-y					:= socfpga.o
> >  obj-$(CONFIG_SMP)	+= headsmp.o platsmp.o
> > +obj-$(CONFIG_SUSPEND)	+= pm.o self-refresh.o
> > diff --git a/arch/arm/mach-socfpga/core.h b/arch/arm/mach-socfpga/core.h
> > index c4a0929..cc1a2fb 100644
> > --- a/arch/arm/mach-socfpga/core.h
> > +++ b/arch/arm/mach-socfpga/core.h
> > @@ -38,6 +38,7 @@ extern void socfpga_sysmgr_init(void);
> >  
> >  extern void __iomem *sys_manager_base_addr;
> >  extern void __iomem *rst_manager_base_addr;
> > +extern void __iomem *sdr_ctl_base_addr;
> >  
> >  extern struct smp_operations socfpga_smp_ops;
> >  extern char secondary_trampoline, secondary_trampoline_end;
> > @@ -46,4 +47,7 @@ extern unsigned long cpu1start_addr;
> >  
> >  #define SOCFPGA_SCU_VIRT_BASE   0xfffec000
> >  
> > +u32 socfpga_sdram_self_refresh(u32 sdr_base, u32 scu_base);
> > +extern unsigned int socfpga_sdram_self_refresh_sz;
> > +
> >  #endif
> > diff --git a/arch/arm/mach-socfpga/pm.c b/arch/arm/mach-socfpga/pm.c
> > new file mode 100644
> > index 0000000..02c3719
> > --- /dev/null
> > +++ b/arch/arm/mach-socfpga/pm.c
> > @@ -0,0 +1,141 @@
> > +/*
> > + *  arch/arm/mach-socfpga/pm.c
> > + *
> > + * Copyright (C) 2014 Altera Corporation. All rights reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms and conditions of the GNU General Public License,
> > + * version 2, as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope it will be useful, but WITHOUT
> > + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> > + * more details.
> > + *
> > + * You should have received a copy of the GNU General Public License along with
> > + * this program.  If not, see <http://www.gnu.org/licenses/>.
> > + */
> > +
> > +#include <linux/bitops.h>
> > +#include <linux/init.h>
> > +#include <linux/io.h>
> > +#include <linux/of_platform.h>
> > +#include <linux/suspend.h>
> > +#include <asm/suspend.h>
> > +#include <asm/fncpy.h>
> > +#include "core.h"
> > +
> > +/* Pointer to function copied to ocram */
> > +static u32 (*socfpga_sdram_self_refresh_in_ocram)(u32 sdr_base, u32 scu_base);
> > +
> > +/* Round up a pointer address to fix aligment for fncpy() */
> > +static void *fncpy_align(void *ptr)
> > +{
> > +	u32 value = (u32)ptr;
> > +
> > +	if ((value & (FNCPY_ALIGN - 1)) != 0)
> > +		value = ((value & ~(FNCPY_ALIGN - 1)) + FNCPY_ALIGN);
> > +
> > +	return (void *)value;
> > +}
> > +
> > +static void *socfpga_init_ocram_exec(void)
> > +{
> > +	struct device_node *np;
> > +	const __be32 *prop;
> > +	u32 ocram_hwaddr, len;
> > +	void __iomem  *iomem_exec_ocram;
> > +	size_t size;
> > +
> > +	np = of_find_compatible_node(NULL, NULL, "mmio-sram");
> > +	if (!np) {
> > +		pr_err("SOCFPGA: Unable to find mmio-sram in dtb\n");
> > +		return 0;
> > +	}
> > +
> > +	/* Determine the OCRAM address and size */
> > +	prop = of_get_property(np, "reg", &size);
> > +	ocram_hwaddr = be32_to_cpup(prop++);
> > +	len = be32_to_cpup(prop);
> > +
> > +	if (!prop || size < sizeof(*prop)) {
> > +		pr_err("SOCFPGA: Unable to find OCRAM mapping in dtb\n");
> > +		return 0;
> > +	}
> > +
> > +	iomem_exec_ocram = __arm_ioremap_exec(ocram_hwaddr, len, 0);
> 
> The call to __arm_ioremap_exec can fail. Also, this doesn't seem right,
> what if a good chunk of OCRAM has been used by some other driver in the
> system? From what I've seen, OCRAM should be using the generic allocator
> framework.

Good catch.  I will check for this faiure in v2.  Also, yes, use the generic
allocator framework.

> 
> > +
> > +	/* Fix alignment to work with fncpy */
> > +	iomem_exec_ocram = fncpy_align(iomem_exec_ocram);
> > +
> > +	return iomem_exec_ocram;
> > +}
> > +
> > +static int socfpga_setup_ocram_self_refresh(void)
> > +{
> > +	void *ocram_addr;
> > +
> > +	/* Configure ocram and make it executable */
> > +	ocram_addr = socfpga_init_ocram_exec();
> > +	WARN(!ocram_addr, "Unable to initialize ocram for pm");
> > +	if (!ocram_addr)
> > +		return -EFAULT;
> > +
> > +	/* Copy the code that puts DDR in self refresh to ocram */
> > +	socfpga_sdram_self_refresh_in_ocram =
> > +		(void *)fncpy((void *)ocram_addr,
> > +		      &socfpga_sdram_self_refresh,
> > +		      socfpga_sdram_self_refresh_sz);
> > +
> > +	WARN(!socfpga_sdram_self_refresh_in_ocram,
> > +	     "could not copy function to ocram");
> > +	if (!socfpga_sdram_self_refresh_in_ocram)
> > +		return -EFAULT;
> > +
> > +	return 0;
> > +}
> > +
> > +static int socfpga_pm_suspend(unsigned long arg)
> > +{
> > +	u32 ret;
> > +
> > +	ret = socfpga_sdram_self_refresh_in_ocram((u32)sdr_ctl_base_addr,
> > +						  (u32)socfpga_scu_base_addr);
> 
> What if sdr_ctl_base_addr is not valid?

I will check for NULL in v2.

Alan

> 
> BR,
> Dinh
> 
> 
