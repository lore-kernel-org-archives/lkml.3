Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbaFWTa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 15:30:56 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:23798
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755071AbaFWTax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 15:30:53 -0400
Message-ID: <1403550798.9081.5.camel@linux-builds1>
Subject: Re: [PATCHv6 3/3] edac: altera: Add EDAC support for SDRAM Ctlr
From: Dinh Nguyen <dinguyen@altera.com>
To: Thor Thayer <tthayer@altera.com>
CC: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>, <bp@alien8.de>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>
Date: Mon, 23 Jun 2014 14:13:18 -0500
In-Reply-To: <1403306523-4174-4-git-send-email-tthayer@altera.com>
References: <1403306523-4174-2-git-send-email-tthayer@altera.com>
	 <1403306523-4174-4-git-send-email-tthayer@altera.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(377424004)(199002)(189002)(51704005)(22564002)(50466002)(44976005)(19580395003)(68736004)(83322001)(19580405001)(77096002)(103116003)(102836001)(81542001)(85306003)(74502001)(31966008)(80022001)(104166001)(74662001)(6806004)(21056001)(99396002)(88136002)(86362001)(50226001)(93916002)(62966002)(64706001)(76176999)(77982001)(50986999)(84676001)(46102001)(105596002)(4396001)(20776003)(79102001)(106466001)(77156001)(76482001)(81342001)(95666004)(87286001)(87936001)(33716001)(92726001)(83072002)(89996001)(97736001)(33646001)(23676002)(92566001)(85852003)(2004002);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB017;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 025100C802
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=dinguyen@altera.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thor,

On Fri, 2014-06-20 at 18:22 -0500, Thor Thayer wrote:
> From: Thor Thayer <tthayer@altera.com>
> 
> Addition of the driver to support the Altera SDRAM Controller. 
> This patch adds support for the CycloneV and ArriaV SDRAM controllers. 
> Correction and reporting of SBEs, Panic on DBEs.
> 
> v2: Use the SDRAM controller registers to calculate memory size
>     instead of the Device Tree. Update To & Cc list. Add maintainer
>     information.
> 
> v3: EDAC driver cleanup based on comments from Mailing list.
> 
> v4: Panic on DBE. Add macro around inject-error reads to prevent
>     them from being optimized out. Remove of_match_ptr since this
>     will always use Device Tree.
> 
> v5: Addition of printk to trigger function to ensure read vars
>     are not optimized out.
> 
> v6: Changes to split out shared SDRAM controller reg (offset 0x00)
>     as a syscon device and allocate ECC specific SDRAM registers
>     to EDAC.
> 
> Signed-off-by: Thor Thayer <tthayer@altera.com>
> ---

For future patch submissions, please add your version history after the
"---".

>  drivers/edac/Kconfig       |    9 +
>  drivers/edac/Makefile      |    2 +
>  drivers/edac/altera_edac.c |  448 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 459 insertions(+)
>  create mode 100644 drivers/edac/altera_edac.c
> 
> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
> index 878f090..4f4d379 100644
> --- a/drivers/edac/Kconfig
> +++ b/drivers/edac/Kconfig
> @@ -368,4 +368,13 @@ config EDAC_OCTEON_PCI
>  	  Support for error detection and correction on the
>  	  Cavium Octeon family of SOCs.
>  
> +config EDAC_ALTERA_MC
> +	bool "Altera SDRAM Memory Controller EDAC"
> +	depends on EDAC_MM_EDAC && ARCH_SOCFPGA
> +	help
> +	  Support for error detection and correction on the
> +	  Altera SDRAM memory controller. Note that the
> +	  preloader must initialize the SDRAM before loading
> +	  the kernel.
> +
>  endif # EDAC
> diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
> index 4154ed6..9741336 100644
> --- a/drivers/edac/Makefile
> +++ b/drivers/edac/Makefile
> @@ -64,3 +64,5 @@ obj-$(CONFIG_EDAC_OCTEON_PC)		+= octeon_edac-pc.o
>  obj-$(CONFIG_EDAC_OCTEON_L2C)		+= octeon_edac-l2c.o
>  obj-$(CONFIG_EDAC_OCTEON_LMC)		+= octeon_edac-lmc.o
>  obj-$(CONFIG_EDAC_OCTEON_PCI)		+= octeon_edac-pci.o
> +
> +obj-$(CONFIG_EDAC_ALTERA_MC)	        += altera_edac.o
> diff --git a/drivers/edac/altera_edac.c b/drivers/edac/altera_edac.c
> new file mode 100644
> index 0000000..e3fcd27
> --- /dev/null
> +++ b/drivers/edac/altera_edac.c
> @@ -0,0 +1,448 @@
> +/*
> + *  Copyright Altera Corporation (C) 2014. All rights reserved.
> + *  Copyright 2011-2012 Calxeda, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file "COPYING" in the main directory of this archive
> + * for more details.
> +
> + *
> + * Adapted from the highbank_mc_edac driver
> + *
> + */
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/ctype.h>
> +#include <linux/edac.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/of_platform.h>
> +#include <linux/uaccess.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/regmap.h>

Can you alphabetize these headers please?

Dinh


