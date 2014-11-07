Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaKGURW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 15:17:22 -0500
Received: from mail-by2on0073.outbound.protection.outlook.com ([207.46.100.73]:13771
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752501AbaKGURU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 15:17:20 -0500
Message-ID: <545D27D2.1080305@opensource.altera.com>
Date: Fri, 7 Nov 2014 14:13:06 -0600
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: <tthayer@opensource.altera.com>, <bp@alien8.de>,
        <dougthompson@xmission.com>, <m.chehab@samsung.com>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <grant.likely@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>
Subject: Re: [PATCHv4 1/5] arm: socfpga: Enable L2 Cache ECC on startup.
References: <1415379263-12391-1-git-send-email-tthayer@opensource.altera.com> <1415379263-12391-2-git-send-email-tthayer@opensource.altera.com>
In-Reply-To: <1415379263-12391-2-git-send-email-tthayer@opensource.altera.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: AMSPR04CA0046.eurprd04.prod.outlook.com (10.242.87.164) To
 DM2PR0301MB1199.namprd03.prod.outlook.com (25.160.217.149)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1199;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(6009001)(24454002)(377454003)(22564002)(479174003)(189002)(51704005)(199003)(4396001)(83506001)(65806001)(50986999)(80316001)(15975445006)(64126003)(62966003)(47776003)(23746002)(50466002)(40100003)(19580395003)(87976001)(2201001)(101416001)(46102003)(19580405001)(20776003)(59896002)(86362001)(64706001)(65956001)(33656002)(106356001)(97736003)(95666004)(105586002)(15202345003)(77156002)(87266999)(65816999)(122386002)(42186005)(54356999)(92726001)(21056001)(92566001)(31966008)(102836001)(99396003)(575784001)(107046002)(66066001)(77096003)(120916001)(76176999)(2004002)(1121002)(921003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0301MB1199;H:[137.57.160.210];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1232;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thor,

On 11/07/2014 10:54 AM, tthayer@opensource.altera.com wrote:
> From: Thor Thayer <tthayer@opensource.altera.com>
> 
> This patch enables the ECC for L2 cache on machine
> startup.  The ECC has to be enabled before data is
> is stored in memory otherwise the ECC will fail on
> reads.
> 
> Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
> ---
> v2: Split OCRAM initialization into separate patch.
> 
> v3/4: No change
> ---
>  MAINTAINERS                      |    1 +
>  arch/arm/mach-socfpga/Makefile   |    1 +
>  arch/arm/mach-socfpga/l2_cache.c |   44 ++++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-socfpga/l2_cache.h |   28 ++++++++++++++++++++++++
>  arch/arm/mach-socfpga/socfpga.c  |    5 ++++-
>  5 files changed, 78 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/mach-socfpga/l2_cache.c
>  create mode 100644 arch/arm/mach-socfpga/l2_cache.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ee1bc5b..d0c7752 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1407,6 +1407,7 @@ ARM/SOCFPGA EDAC SUPPORT
>  M:	Thor Thayer <tthayer@opensource.altera.com>
>  S:	Maintained
>  F:	drivers/edac/altera_edac.
> +F:	arch/arm/mach-socfpga/l2_cache.*
>  
>  ARM/STI ARCHITECTURE
>  M:	Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
> diff --git a/arch/arm/mach-socfpga/Makefile b/arch/arm/mach-socfpga/Makefile
> index 6dd7a93..142609e 100644
> --- a/arch/arm/mach-socfpga/Makefile
> +++ b/arch/arm/mach-socfpga/Makefile
> @@ -4,3 +4,4 @@
>  
>  obj-y					:= socfpga.o
>  obj-$(CONFIG_SMP)	+= headsmp.o platsmp.o
> +obj-$(CONFIG_EDAC_ALTERA_L2C) += l2_cache.o
> diff --git a/arch/arm/mach-socfpga/l2_cache.c b/arch/arm/mach-socfpga/l2_cache.c
> new file mode 100644
> index 0000000..8e109f3
> --- /dev/null
> +++ b/arch/arm/mach-socfpga/l2_cache.c
> @@ -0,0 +1,44 @@
> +/*
> + * Copyright Altera Corporation (C) 2014. All rights reserved.
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
> +#include <linux/clk-provider.h>

Why clk-provider.h and not io.h?

> +#include <linux/of_platform.h>
> +#include <linux/of_address.h>
> +
> +#include "l2_cache.h"
> +
> +void socfpga_init_l2_ecc(void)
> +{
> +	struct device_node *np;
> +	void __iomem  *mapped_l2_edac_addr;
> +
> +	np = of_find_compatible_node(NULL, NULL, "altr,l2-edac");
> +	if (!np) {
> +		pr_err("SOCFPGA: Unable to find altr,l2-edac in dtb\n");
> +		return;
> +	}
> +
> +	mapped_l2_edac_addr = of_iomap(np, 0);
> +	if (!mapped_l2_edac_addr) {
> +		pr_err("SOCFPGA: Unable to find L2 ECC mapping in dtb\n");
> +		return;
> +	}
> +
> +	/* Enable ECC */
> +	writel(0x01, mapped_l2_edac_addr);
> +
> +	pr_debug("SOCFPGA: Success Initializing L2 cache ECC\n");
> +}
> +

Extra line here...

> diff --git a/arch/arm/mach-socfpga/l2_cache.h b/arch/arm/mach-socfpga/l2_cache.h
> new file mode 100644
> index 0000000..58e140d
> --- /dev/null
> +++ b/arch/arm/mach-socfpga/l2_cache.h
> @@ -0,0 +1,28 @@
> +/*
> + * Copyright Altera Corporation (C) 2014. All rights reserved.
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
> +#ifndef MACH_SOCFPGA_L2_CACHE_H
> +#define MACH_SOCFPGA_L2_CACHE_H
> +
> +#ifdef CONFIG_EDAC_ALTERA_L2C
> +void socfpga_init_l2_ecc(void);
> +#else
> +inline void socfpga_init_l2_ecc(void)
> +{
> +}
> +#endif
> +
> +#endif /* #ifndef MACH_SOCFPGA_L2_CACHE_H */
> diff --git a/arch/arm/mach-socfpga/socfpga.c b/arch/arm/mach-socfpga/socfpga.c
> index adbf383..af6413a 100644
> --- a/arch/arm/mach-socfpga/socfpga.c
> +++ b/arch/arm/mach-socfpga/socfpga.c
> @@ -1,5 +1,5 @@
>  /*
> - *  Copyright (C) 2012 Altera Corporation
> + *  Copyright (C) 2012;2014 Altera Corporation

Should be "2012-2014".

>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
> @@ -25,6 +25,8 @@
>  #include <asm/mach/map.h>
>  
>  #include "core.h"
> +#include "l2_cache.h"
> +#include "ocram.h"

Including ocram.h should go into patch 2/5. But I think ocram.h can be
removed as well if you just use IS_ENABLED().

>  
>  void __iomem *socfpga_scu_base_addr = ((void __iomem *)(SOCFPGA_SCU_VIRT_BASE));
>  void __iomem *sys_manager_base_addr;
> @@ -83,6 +85,7 @@ static void __init socfpga_init_irq(void)
>  {
>  	irqchip_init();
>  	socfpga_sysmgr_init();
> +	socfpga_init_l2_ecc();

If you use "if (IS_ENABLED(CONFIG_EDAC_ALTERA_L2C))", then you can
remove l2_cache.h.

Dinh


