Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbaGBPr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:47:57 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:48065 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaGBPrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:47:55 -0400
Message-ID: <53B42996.1060007@linaro.org>
Date: Wed, 02 Jul 2014 16:47:34 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: mathieu.poirier@linaro.org, linus.walleij@linaro.org, will.deacon@arm.com,
        linux@arm.linux.org.uk, robherring2@gmail.com
CC: arve@android.com, john.stultz@linaro.org, pratikp@codeaurora.org,
        varshney@ti.com, Al.Grant@arm.com, jonas.svennebring@avagotech.com,
        james.king@linaro.org, panchaxari.prasannamurthy@linaro.org,
        arnd@linaro.org, marcin.jabrzyk@gmail.com, r.sengupta@samsung.com,
        robbelibobban@gmail.com, Tony.Armitstead@arm.com, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9 v2] coresight-tmc: add CoreSight TMC driver
References: <1403892261-25026-1-git-send-email-mathieu.poirier@linaro.org> <1403892261-25026-3-git-send-email-mathieu.poirier@linaro.org>
In-Reply-To: <1403892261-25026-3-git-send-email-mathieu.poirier@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/06/14 19:04, mathieu.poirier@linaro.org wrote:
> diff --git a/drivers/coresight/coresight-tmc.c b/drivers/coresight/coresight-tmc.c
> new file mode 100644
> index 0000000..201cdac
> --- /dev/null
> +++ b/drivers/coresight/coresight-tmc.c
> @@ -0,0 +1,791 @@
> +/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/types.h>
> +#include <linux/device.h>
> +#include <linux/io.h>
> +#include <linux/err.h>
> +#include <linux/fs.h>
> +#include <linux/miscdevice.h>
> +#include <linux/uaccess.h>
> +#include <linux/slab.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/delay.h>
> +#include <linux/spinlock.h>
> +#include <linux/clk.h>
> +#include <linux/of.h>
> +#include <linux/of_coresight.h>
> +#include <linux/coresight.h>
> +#include <linux/amba/bus.h>
> +
> +#include "coresight-priv.h"
> +
> +#define TMC_RSZ			(0x004)
> +#define TMC_STS			(0x00C)
> +#define TMC_RRD			(0x010)
> +#define TMC_RRP			(0x014)
> +#define TMC_RWP			(0x018)
> +#define TMC_TRG			(0x01C)
> +#define TMC_CTL			(0x020)
> +#define TMC_RWD			(0x024)
> +#define TMC_MODE		(0x028)
> +#define TMC_LBUFLEVEL		(0x02C)
> +#define TMC_CBUFLEVEL		(0x030)
> +#define TMC_BUFWM		(0x034)
> +#define TMC_RRPHI		(0x038)
> +#define TMC_RWPHI		(0x03C)
> +#define TMC_AXICTL		(0x110)
> +#define TMC_DBALO		(0x118)
> +#define TMC_DBAHI		(0x11C)
> +#define TMC_FFSR		(0x300)
> +#define TMC_FFCR		(0x304)
> +#define TMC_PSCR		(0x308)
> +#define TMC_ITMISCOP0		(0xEE0)
> +#define TMC_ITTRFLIN		(0xEE8)
> +#define TMC_ITATBDATA0		(0xEEC)
> +#define TMC_ITATBCTR2		(0xEF0)
> +#define TMC_ITATBCTR1		(0xEF4)
> +#define TMC_ITATBCTR0		(0xEF8)
> +
> +/** register description **/
> +/* TMC_CTL - 0x020 */
> +#define TMC_CTL_CAPT_EN		BIT(0)
> +/* TMC_STS - 0x00C */
> +#define TMC_STS_TRIGGERED	BIT(1)
> +/* TMC_AXICTL - 0x110 */
> +#define TMC_AXICTL_PROT_CTL_B0	BIT(0)
> +#define TMC_AXICTL_PROT_CTL_B1	BIT(1)
> +#define TMC_AXICTL_SCT_GAT_MODE	BIT(7)
> +#define TMC_AXICTL_WR_BURST_LEN 0xF00
> +/* TMC_FFCR - 0x304 */
> +#define TMC_FFCR_EN_FMT		BIT(0)
> +#define TMC_FFCR_EN_TI		BIT(1)
> +#define TMC_FFCR_FON_FLIN	BIT(4)
> +#define TMC_FFCR_FON_TRIG_EVT	BIT(5)
> +#define TMC_FFCR_FLUSHMAN	BIT(6)
> +#define TMC_FFCR_TRIGON_TRIGIN	BIT(8)
> +#define TMC_FFCR_STOP_ON_FLUSH	BIT(12)
> +
> +#define TMC_STS_TRIGGERED_BIT	2
> +#define TMC_FFCR_FLUSHMAN_BIT	6
> +
> +enum tmc_config_type {
> +	TMC_CONFIG_TYPE_ETB,
> +	TMC_CONFIG_TYPE_ETR,
> +	TMC_CONFIG_TYPE_ETF,
> +};
> +
> +enum tmc_mode {
> +	TMC_MODE_CIRCULAR_BUFFER,
> +	TMC_MODE_SOFTWARE_FIFO,
> +	TMC_MODE_HARDWARE_FIFO,
> +};
> +
> +enum tmc_mem_intf_width {
> +	TMC_MEM_INTF_WIDTH_32BITS	= 0x2,
> +	TMC_MEM_INTF_WIDTH_64BITS	= 0x3,
> +	TMC_MEM_INTF_WIDTH_128BITS	= 0x4,
> +	TMC_MEM_INTF_WIDTH_256BITS	= 0x5,
> +};
> +
> +struct tmc_drvdata {
> +	void __iomem		*base;
> +	struct device		*dev;
> +	struct coresight_device	*csdev;
> +	struct miscdevice	miscdev;
> +	struct clk		*clk;
> +	spinlock_t		spinlock;
> +	int			read_count;
> +	bool			reading;
> +	char			*buf;
> +	dma_addr_t		paddr;
> +	void __iomem		*vaddr;
> +	u32			size;
> +	bool			enable;
> +	enum tmc_config_type	config_type;
> +	u32			trigger_cntr;
> +};
> +
> +static void tmc_wait_for_ready(struct tmc_drvdata *drvdata)
> +{
> +	int i;
> +
> +	/* Ensure formatter, unformatter and hardware fifo are empty */
> +	for (i = TIMEOUT_US;
> +	     BVAL(cs_readl(drvdata->base, TMC_STS), TMC_STS_TRIGGERED_BIT) != 1
> +	     && i > 0; i--)
> +		udelay(1);
> +
> +	WARN(i == 0,
> +	     "timeout while waiting for TMC ready, TMC_STS: %#x\n",
> +	     cs_readl(drvdata->base, TMC_STS));
> +}
> +
> +static void tmc_flush_and_stop(struct tmc_drvdata *drvdata)
> +{
> +	int i;
> +	u32 ffcr;
> +
> +	ffcr = cs_readl(drvdata->base, TMC_FFCR);
> +	ffcr |= TMC_FFCR_STOP_ON_FLUSH;
> +	cs_writel(drvdata->base, ffcr, TMC_FFCR);
> +	ffcr |= TMC_FFCR_FLUSHMAN;
> +	cs_writel(drvdata->base, ffcr, TMC_FFCR);
> +	/* Ensure flush completes */
> +	for (i = TIMEOUT_US;
> +	     BVAL(cs_readl(drvdata->base, TMC_FFCR), TMC_FFCR_FLUSHMAN_BIT) != 0
> +	     && i > 0; i--)
> +		udelay(1);

This wait-for-a-bit-to-set/clear-or-timeout pattern is pretty common in
the various coresight patches. Do you think it should be pulled out into
a function?


... and no more comments!

