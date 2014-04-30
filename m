Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934031AbaD3SHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 14:07:00 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:34407 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759034AbaD3SG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 14:06:58 -0400
Date: Wed, 30 Apr 2014 11:06:53 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Boris BREZILLON <b.brezillon.dev@gmail.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robherring2@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        dev@linux-sunxi.org
Subject: Re: [PATCH v3 2/9] mtd: nand: add ONFI timing mode to nand_timings
 converter
Message-ID: <20140430180653.GC2497@norris-Latitude-E6410>
References: <1394647664-8258-1-git-send-email-b.brezillon.dev@gmail.com>
 <1394647664-8258-3-git-send-email-b.brezillon.dev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394647664-8258-3-git-send-email-b.brezillon.dev@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 12, 2014 at 07:07:37PM +0100, Boris BREZILLON wrote:
> Add a converter to retrieve NAND timings from an ONFI NAND timing mode.
> This only support SDR NAND timings for now.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
> ---
>  drivers/mtd/nand/Makefile       |    2 +-
>  drivers/mtd/nand/nand_timings.c |  248 +++++++++++++++++++++++++++++++++++++++
>  include/linux/mtd/nand.h        |    4 +
>  3 files changed, 253 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/mtd/nand/nand_timings.c
> 
> diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
> index c970ce7..0b8a822 100644
> --- a/drivers/mtd/nand/Makefile
> +++ b/drivers/mtd/nand/Makefile
> @@ -2,7 +2,7 @@
>  # linux/drivers/nand/Makefile
>  #
>  
> -obj-$(CONFIG_MTD_NAND)			+= nand.o
> +obj-$(CONFIG_MTD_NAND)			+= nand.o nand_timings.o
>  obj-$(CONFIG_MTD_NAND_ECC)		+= nand_ecc.o
>  obj-$(CONFIG_MTD_NAND_BCH)		+= nand_bch.o
>  obj-$(CONFIG_MTD_NAND_IDS)		+= nand_ids.o nand_hynix.o

This patch doesn't apply to l2-mtd.git. Are you basing this on your
Hynix patches? I thought some (all?) of them were determined
unnecessary. Anyway, please rebase on l2-mtd.git, since there are a
couple of other bits that don't apply properly.

> diff --git a/drivers/mtd/nand/nand_timings.c b/drivers/mtd/nand/nand_timings.c
> new file mode 100644
> index 0000000..f66fe95
> --- /dev/null
> +++ b/drivers/mtd/nand/nand_timings.c
> @@ -0,0 +1,248 @@
> +/*
> + *  Copyright (C) 2014 Boris BREZILLON <b.brezillon.dev@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +#include <linux/mtd/nand.h>
> +
> +static const struct nand_sdr_timings onfi_sdr_timings[] = {
> +	/* Mode 0 */
> +	{
> +		.tADL_min = 200000,
> +		.tALH_min = 20000,
> +		.tALS_min = 50000,
> +		.tAR_min = 25000,
> +		.tCEA_max = 100000,
> +		.tCEH_min = 20000,
> +		.tCH_min = 20000,
> +		.tCHZ_max = 100000,
> +		.tCLH_min = 20000,
> +		.tCLR_min = 20000,
> +		.tCLS_min = 50000,
> +		.tCOH_min = 0,
> +		.tCS_min = 70000,
> +		.tDH_min = 20000,
> +		.tDS_min = 40000,
> +		.tFEAT_max = 1000000,
> +		.tIR_min = 10000,
> +		.tITC_max = 1000000,
> +		.tRC_min = 100000,
> +		.tREA_max = 40000,
> +		.tREH_min = 30000,
> +		.tRHOH_min = 0,
> +		.tRHW_min = 200000,
> +		.tRHZ_max = 200000,
> +		.tRLOH_min = 0,
> +		.tRP_min = 50000,
> +		.tRST_max = 250000000000,

I was initially wary of potential overflow here, but apparently the C
standard (section 6.4.4.1) ensures that literal constants like this will
be promoted to a sufficiently-large type.

> +		.tWB_max = 200000,
> +		.tRR_min = 40000,
> +		.tWC_min = 100000,
> +		.tWH_min = 30000,
> +		.tWHR_min = 120000,
> +		.tWP_min = 50000,
> +		.tWW_min = 100000,
> +	},
> +	/* Mode 1 */
> +	{
> +		.tADL_min = 100000,
> +		.tALH_min = 10000,
> +		.tALS_min = 25000,
> +		.tAR_min = 10000,
> +		.tCEA_max = 45000,
> +		.tCEH_min = 20000,
> +		.tCH_min = 10000,
> +		.tCHZ_max = 50000,
> +		.tCLH_min = 10000,
> +		.tCLR_min = 10000,
> +		.tCLS_min = 25000,
> +		.tCOH_min = 15000,
> +		.tCS_min = 35000,
> +		.tDH_min = 10000,
> +		.tDS_min = 20000,
> +		.tFEAT_max = 1000000,
> +		.tIR_min = 0,
> +		.tITC_max = 1000000,
> +		.tRC_min = 50000,
> +		.tREA_max = 30000,
> +		.tREH_min = 15000,
> +		.tRHOH_min = 15000,
> +		.tRHW_min = 100000,
> +		.tRHZ_max = 100000,
> +		.tRLOH_min = 0,
> +		.tRP_min = 25000,
> +		.tRR_min = 20000,
> +		.tRST_max = 500000000,
> +		.tWB_max = 100000,
> +		.tWC_min = 45000,
> +		.tWH_min = 15000,
> +		.tWHR_min = 80000,
> +		.tWP_min = 25000,
> +		.tWW_min = 100000,
> +	},
> +	/* Mode 2 */
> +	{
> +		.tADL_min = 100000,
> +		.tALH_min = 10000,
> +		.tALS_min = 15000,
> +		.tAR_min = 10000,
> +		.tCEA_max = 30000,
> +		.tCEH_min = 20000,
> +		.tCH_min = 10000,
> +		.tCHZ_max = 50000,
> +		.tCLH_min = 10000,
> +		.tCLR_min = 10000,
> +		.tCLS_min = 15000,
> +		.tCOH_min = 15000,
> +		.tCS_min = 25000,
> +		.tDH_min = 5000,
> +		.tDS_min = 15000,
> +		.tFEAT_max = 1000000,
> +		.tIR_min = 0,
> +		.tITC_max = 1000000,
> +		.tRC_min = 35000,
> +		.tREA_max = 25000,
> +		.tREH_min = 15000,
> +		.tRHOH_min = 15000,
> +		.tRHW_min = 100000,
> +		.tRHZ_max = 100000,
> +		.tRLOH_min = 0,
> +		.tRR_min = 20000,
> +		.tRST_max = 500000000,
> +		.tWB_max = 100000,
> +		.tRP_min = 17000,
> +		.tWC_min = 35000,
> +		.tWH_min = 15000,
> +		.tWHR_min = 80000,
> +		.tWP_min = 17000,
> +		.tWW_min = 100000,
> +	},
> +	/* Mode 3 */
> +	{
> +		.tADL_min = 100000,
> +		.tALH_min = 5000,
> +		.tALS_min = 10000,
> +		.tAR_min = 10000,
> +		.tCEA_max = 25000,
> +		.tCEH_min = 20000,
> +		.tCH_min = 5000,
> +		.tCHZ_max = 50000,
> +		.tCLH_min = 5000,
> +		.tCLR_min = 10000,
> +		.tCLS_min = 10000,
> +		.tCOH_min = 15000,
> +		.tCS_min = 25000,
> +		.tDH_min = 5000,
> +		.tDS_min = 10000,
> +		.tFEAT_max = 1000000,
> +		.tIR_min = 0,
> +		.tITC_max = 1000000,
> +		.tRC_min = 30000,
> +		.tREA_max = 20000,
> +		.tREH_min = 10000,
> +		.tRHOH_min = 15000,
> +		.tRHW_min = 100000,
> +		.tRHZ_max = 100000,
> +		.tRLOH_min = 0,
> +		.tRP_min = 15000,
> +		.tRR_min = 20000,
> +		.tRST_max = 500000000,
> +		.tWB_max = 100000,
> +		.tWC_min = 30000,
> +		.tWH_min = 10000,
> +		.tWHR_min = 80000,
> +		.tWP_min = 15000,
> +		.tWW_min = 100000,
> +	},
> +	/* Mode 4 */
> +	{
> +		.tADL_min = 70000,
> +		.tALH_min = 5000,
> +		.tALS_min = 10000,
> +		.tAR_min = 10000,
> +		.tCEA_max = 25000,
> +		.tCEH_min = 20000,
> +		.tCH_min = 5000,
> +		.tCHZ_max = 30000,
> +		.tCLH_min = 5000,
> +		.tCLR_min = 10000,
> +		.tCLS_min = 10000,
> +		.tCOH_min = 15000,
> +		.tCS_min = 20000,
> +		.tDH_min = 5000,
> +		.tDS_min = 10000,
> +		.tFEAT_max = 1000000,
> +		.tIR_min = 0,
> +		.tITC_max = 1000000,
> +		.tRC_min = 25000,
> +		.tREA_max = 20000,
> +		.tREH_min = 10000,
> +		.tRHOH_min = 15000,
> +		.tRHW_min = 100000,
> +		.tRHZ_max = 100000,
> +		.tRLOH_min = 5000,
> +		.tRP_min = 12000,
> +		.tRR_min = 20000,
> +		.tRST_max = 500000000,
> +		.tWB_max = 100000,
> +		.tWC_min = 25000,
> +		.tWH_min = 10000,
> +		.tWHR_min = 80000,
> +		.tWP_min = 12000,
> +		.tWW_min = 100000,
> +	},
> +	/* Mode 5 */
> +	{
> +		.tADL_min = 70000,
> +		.tALH_min = 5000,
> +		.tALS_min = 10000,
> +		.tAR_min = 10000,
> +		.tCEA_max = 25000,
> +		.tCEH_min = 20000,
> +		.tCH_min = 5000,
> +		.tCHZ_max = 30000,
> +		.tCLH_min = 5000,
> +		.tCLR_min = 10000,
> +		.tCLS_min = 10000,
> +		.tCOH_min = 15000,
> +		.tCS_min = 15000,
> +		.tDH_min = 5000,
> +		.tDS_min = 7000,
> +		.tFEAT_max = 1000000,
> +		.tIR_min = 0,
> +		.tITC_max = 1000000,
> +		.tRC_min = 20000,
> +		.tREA_max = 16000,
> +		.tREH_min = 7000,
> +		.tRHOH_min = 15000,
> +		.tRHW_min = 100000,
> +		.tRHZ_max = 100000,
> +		.tRLOH_min = 5000,
> +		.tRP_min = 10000,
> +		.tRR_min = 20000,
> +		.tRST_max = 500000000,
> +		.tWB_max = 100000,
> +		.tWC_min = 20000,
> +		.tWH_min = 7000,
> +		.tWHR_min = 80000,
> +		.tWP_min = 10000,
> +		.tWW_min = 100000,
> +	},
> +};
> +
> +/**
> + * onfi_async_timing_mode_to_sdr_timings - [NAND Interface] Retrieve NAND
> + * timings according to the given ONFI timing mode
> + * @mode: ONFI timing mode
> + */
> +const struct nand_sdr_timings *onfi_async_timing_mode_to_sdr_timings(int mode)
> +{
> +	if (mode < 0 || mode > ARRAY_SIZE(onfi_sdr_timings))

Should be ">=".

	if (mode < 0 || mode >= ARRAY_SIZE(onfi_sdr_timings))

> +		return ERR_PTR(-EINVAL);
> +
> +	return &onfi_sdr_timings[mode];
> +}
> +EXPORT_SYMBOL(onfi_async_timing_mode_to_sdr_timings);
> diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
> index f3ff3a3..b8e3c2b 100644
> --- a/include/linux/mtd/nand.h
> +++ b/include/linux/mtd/nand.h
> @@ -847,6 +847,7 @@ static inline bool nand_is_slc(struct nand_chip *chip)
>  	return chip->bits_per_cell == 1;
>  }
>  
> +

Unnecessary whitespace change.

>  /**
>   * struct nand_sdr_timings - SDR NAND chip timings
>   *
> @@ -895,4 +896,7 @@ struct nand_sdr_timings {
>  	u32 tWW_min;
>  };
>  
> +/* convert an ONFI timing mode to its timing characteristics. */
> +const struct nand_sdr_timings *onfi_async_timing_mode_to_sdr_timings(int mode);
> +
>  #endif /* __LINUX_MTD_NAND_H */

Brian
