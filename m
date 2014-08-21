Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbaHUTAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 15:00:06 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:52147
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751905AbaHUTAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 15:00:03 -0400
Date: Thu, 21 Aug 2014 11:59:53 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
CC: Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 4/9] ARM: zynq: PM: Enable DDR self-refresh and clock stop
References: <1408567315-28479-1-git-send-email-soren.brinkmann@xilinx.com>
 <1408567315-28479-5-git-send-email-soren.brinkmann@xilinx.com>
 <57cd5124-bd1d-47b9-b467-647937c15fff@BN1BFFO11FD052.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <57cd5124-bd1d-47b9-b467-647937c15fff@BN1BFFO11FD052.protection.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <07c7c372-75e1-434d-bd0e-692091f72698@BY2FFO11FD009.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(377454003)(199003)(479174003)(189002)(377424004)(24454002)(51704005)(164054003)(87936001)(44976005)(81542001)(99396002)(50466002)(19580405001)(53416004)(74502001)(64706001)(85306004)(31696002)(74662001)(77096002)(104016003)(50986999)(575784001)(81342001)(20776003)(4396001)(80022001)(23676002)(47776003)(107046002)(83322001)(86362001)(90102001)(95666004)(70736001)(31966008)(85852003)(19580395003)(76176999)(79102001)(77982001)(102836001)(15975445006)(92566001)(85182001)(1496007)(76482001)(85202003)(110136001)(92726001)(6806004)(83506001)(74316001)(21056001)(15202345003)(54356999)(83072002)(46102001)(106466001)(107986001)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB041;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0310C78181
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-21 at 02:25PM +0200, Michal Simek wrote:
> On 08/20/2014 10:41 PM, Soren Brinkmann wrote:
> > The DDR controller can detect idle periods and leverage low power
> > features like self-refresh and clock stop.
> > When new requests occur, the DDRC resumes normal operation.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> >  arch/arm/mach-zynq/Makefile |  2 +-
> >  arch/arm/mach-zynq/common.c |  1 +
> >  arch/arm/mach-zynq/common.h |  2 ++
> >  arch/arm/mach-zynq/pm.c     | 84 +++++++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 88 insertions(+), 1 deletion(-)
> >  create mode 100644 arch/arm/mach-zynq/pm.c
> > 
> > diff --git a/arch/arm/mach-zynq/Makefile b/arch/arm/mach-zynq/Makefile
> > index 1b25d92ebf22..820dff6e1eba 100644
> > --- a/arch/arm/mach-zynq/Makefile
> > +++ b/arch/arm/mach-zynq/Makefile
> > @@ -3,7 +3,7 @@
> >  #
> >  
> >  # Common support
> > -obj-y				:= common.o slcr.o
> > +obj-y				:= common.o slcr.o pm.o
> >  CFLAGS_REMOVE_hotplug.o		=-march=armv6k
> >  CFLAGS_hotplug.o 		=-Wa,-march=armv7-a -mcpu=cortex-a9
> >  obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug.o
> > diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
> > index 3cb7c198615a..6bd13e5ce6b7 100644
> > --- a/arch/arm/mach-zynq/common.c
> > +++ b/arch/arm/mach-zynq/common.c
> > @@ -101,6 +101,7 @@ static int __init zynq_get_revision(void)
> >  static void __init zynq_init_late(void)
> >  {
> >  	zynq_core_pm_init();
> > +	zynq_pm_late_init();
> >  }
> >  
> >  /**
> > diff --git a/arch/arm/mach-zynq/common.h b/arch/arm/mach-zynq/common.h
> > index 596ef0b5067c..87945fa2a179 100644
> > --- a/arch/arm/mach-zynq/common.h
> > +++ b/arch/arm/mach-zynq/common.h
> > @@ -40,6 +40,8 @@ extern void __iomem *zynq_scu_base;
> >  /* Hotplug */
> >  extern void zynq_platform_cpu_die(unsigned int cpu);
> >  
> > +int zynq_pm_late_init(void);
> > +
> >  static inline void zynq_core_pm_init(void)
> >  {
> >  	/* A9 clock gating */
> > diff --git a/arch/arm/mach-zynq/pm.c b/arch/arm/mach-zynq/pm.c
> > new file mode 100644
> > index 000000000000..19955917aac8
> > --- /dev/null
> > +++ b/arch/arm/mach-zynq/pm.c
> > @@ -0,0 +1,84 @@
> > +/*
> > + * Zynq power management
> > + *
> > + *  Copyright (C) 2012 - 2014 Xilinx
> > + *
> > + *  Sören Brinkmann <soren.brinkmann@xilinx.com>
> > + *
> > + * This program is free software: you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation, either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> 
> IRC this paragraph is not necessary and can be just removed.
It's the standard header as suggested by gnu.org.

> 
> > + */
> > +
> > +#include <linux/io.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_device.h>
> > +#include "common.h"
> > +
> > +/* register offsets */
> > +#define DDRC_CTRL_REG1_OFFS		0x60
> > +#define DDRC_DRAM_PARAM_REG3_OFFS	0x20
> > +
> > +/* bitfields */
> > +#define DDRC_CLOCKSTOP_MASK	BIT(23)
> > +#define DDRC_SELFREFRESH_MASK	BIT(12)
> > +
> > +static void __iomem *ddrc_base;
> > +
> > +/**
> > + * zynq_pm_ioremap() - Create IO mappings
> > + * @comp:	DT compatible string
> > + * Returns a pointer to the mapped memory or NULL.
> > + *
> > + * Remap the memory region for a compatible DT node.
> > + */
> 
> [linux]$ ./scripts/kernel-doc -man -v arch/arm/mach-zynq/pm.c > /dev/null
> Info(arch/arm/mach-zynq/pm.c:38): Scanning doc for
> Warning(arch/arm/mach-zynq/pm.c:45): No description found for return value of 'zynq_pm_ioremap'
I'll fix that.

> 
> > +static void __iomem *zynq_pm_ioremap(const char *comp)
> > +{
> > +	struct device_node *np;
> > +	void __iomem *base = NULL;
> > +
> > +	np = of_find_compatible_node(NULL, NULL, comp);
> > +	if (np) {
> > +		base = of_iomap(np, 0);
> > +		of_node_put(np);
> > +	} else {
> > +		pr_warn("%s: no compatible node found for '%s'\n", __func__,
> > +				comp);
> > +	}
> > +
> > +	return base;
> > +}
> > +
> > +int __init zynq_pm_late_init(void)
> 
> kernel doc will be nice to have here.
I'll add a line or two.

> 
> > +{
> > +	u32 reg;
> > +
> > +	ddrc_base = zynq_pm_ioremap("xlnx,zynq-ddrc-a05");
> > +	if (!ddrc_base) {
> > +		pr_warn("%s: Unable to map DDRC IO memory.\n", __func__);
> > +	} else {
> > +		/*
> > +		 * Enable DDRC self-refresh and clock stop features. The HW
> > +		 * takes care of entering/exiting the correct modes depending
> > +		 * on activity state.
> > +		 */
> > +		reg = readl(ddrc_base + DDRC_CTRL_REG1_OFFS);
> > +		reg |= DDRC_SELFREFRESH_MASK;
> > +		writel(reg, ddrc_base + DDRC_CTRL_REG1_OFFS);
> > +
> > +		reg = readl(ddrc_base + DDRC_DRAM_PARAM_REG3_OFFS);
> > +		reg |= DDRC_CLOCKSTOP_MASK;
> > +		writel(reg, ddrc_base + DDRC_DRAM_PARAM_REG3_OFFS);
> > +	}
> > +
> > +	return 0;
> 
> You are not using this return value that's why I would just remove it and
> change function return type to void.
Right, I'll change it.

	Thanks,
	Sören

