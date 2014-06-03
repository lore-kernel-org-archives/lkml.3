Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaFCK1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 06:27:03 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64043 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaFCK1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:27:00 -0400
Message-ID: <538DA2E0.6070103@linaro.org>
Date: Tue, 03 Jun 2014 11:26:40 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: mathieu.poirier@linaro.org, linus.walleij@linaro.org, will.deacon@arm.com
CC: arve@android.com, john.stultz@linaro.org, pratikp@codeaurora.org,
        varshney@ti.com, Al.Grant@arm.com, jonas.svennebring@avagotech.com,
        james.king@linaro.org, panchaxari.prasannamurthy@linaro.org,
        arnd@linaro.org, marcin.jabrzyk@gmail.com, r.sengupta@samsung.com,
        robbelibobban@gmail.com, patches@linaro.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 07/11] coresight: add CoreSight ETM driver
References: <1401457391-12242-1-git-send-email-mathieu.poirier@linaro.org> <1401457391-12242-8-git-send-email-mathieu.poirier@linaro.org>
In-Reply-To: <1401457391-12242-8-git-send-email-mathieu.poirier@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/05/14 14:43, mathieu.poirier@linaro.org wrote:
> diff --git a/drivers/coresight/coresight-etm-cp14.c b/drivers/coresight/coresight-etm-cp14.c
> new file mode 100644
> index 0000000..0088bbb
> --- /dev/null
> +++ b/drivers/coresight/coresight-etm-cp14.c
> @@ -0,0 +1,511 @@
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
> +#include <linux/types.h>
> +#include <linux/bug.h>
> +#include <asm/hardware/cp14.h>
> +
> +static unsigned int etm_read_reg(uint32_t reg)
> +{
> +	switch (reg) {
> +	case 0x0:

Shouldn't this be:

case ETMCR/4:

Or an equivalent macro? Given the memory mappings are already spelt out
in another file it seems a shame to restate them again.

> +		return etm_read(ETMCR);

Maybe we could even condense the mapping with something like:

#define CASE_MAP_MM_READ_TO_CPIO(x) case (x)/4: return etm_read(x)

CASE_MAP_MM_READ_TO_CPIO(ETMCR);
CASE_MAP_MM_READ_TO_CPIO(ETMCCR);
CASE_MAP_MM_READ_TO_CPIO(ETMTRIGGER);
...

Note that the macro may not be perfect since it untested and I can't
remember how it will interact with the token pasting in etm_read(x).
Howevver but a macro with this interface can definitely be written.

> +	case 0x1:
> +		return etm_read(ETMCCR);
> +	case 0x2:
> +		return etm_read(ETMTRIGGER);
> +	case 0x4:
> +		return etm_read(ETMSR);
> +	case 0x5:
> +		return etm_read(ETMSCR);
> +	case 0x6:
> +		return etm_read(ETMTSSCR);
> +	case 0x8:
> +		return etm_read(ETMTEEVR);
> +	case 0x9:
> +		return etm_read(ETMTECR1);
> +	case 0xB:
> +		return etm_read(ETMFFLR);
> +	case 0x10:
> +		return etm_read(ETMACVR0);
> +	case 0x11:
> +		return etm_read(ETMACVR1);
> +	case 0x12:
> +		return etm_read(ETMACVR2);
> +	case 0x13:
> +		return etm_read(ETMACVR3);
> +	case 0x14:
> +		return etm_read(ETMACVR4);
> +	case 0x15:
> +		return etm_read(ETMACVR5);
> +	case 0x16:
> +		return etm_read(ETMACVR6);
> +	case 0x17:
> +		return etm_read(ETMACVR7);
> +	case 0x18:
> +		return etm_read(ETMACVR8);
> +	case 0x19:
> +		return etm_read(ETMACVR9);
> +	case 0x1A:
> +		return etm_read(ETMACVR10);
> +	case 0x1B:
> +		return etm_read(ETMACVR11);
> +	case 0x1C:
> +		return etm_read(ETMACVR12);
> +	case 0x1D:
> +		return etm_read(ETMACVR13);
> +	case 0x1E:
> +		return etm_read(ETMACVR14);
> +	case 0x1F:
> +		return etm_read(ETMACVR15);
> +	case 0x20:
> +		return etm_read(ETMACTR0);
> +	case 0x21:
> +		return etm_read(ETMACTR1);
> +	case 0x22:
> +		return etm_read(ETMACTR2);
> +	case 0x23:
> +		return etm_read(ETMACTR3);
> +	case 0x24:
> +		return etm_read(ETMACTR4);
> +	case 0x25:
> +		return etm_read(ETMACTR5);
> +	case 0x26:
> +		return etm_read(ETMACTR6);
> +	case 0x27:
> +		return etm_read(ETMACTR7);
> +	case 0x28:
> +		return etm_read(ETMACTR8);
> +	case 0x29:
> +		return etm_read(ETMACTR9);
> +	case 0x2A:
> +		return etm_read(ETMACTR10);
> +	case 0x2B:
> +		return etm_read(ETMACTR11);
> +	case 0x2C:
> +		return etm_read(ETMACTR12);
> +	case 0x2D:
> +		return etm_read(ETMACTR13);
> +	case 0x2E:
> +		return etm_read(ETMACTR14);
> +	case 0x2F:
> +		return etm_read(ETMACTR15);
> +	case 0x50:
> +		return etm_read(ETMCNTRLDVR0);
> +	case 0x51:
> +		return etm_read(ETMCNTRLDVR1);
> +	case 0x52:
> +		return etm_read(ETMCNTRLDVR2);
> +	case 0x53:
> +		return etm_read(ETMCNTRLDVR3);
> +	case 0x54:
> +		return etm_read(ETMCNTENR0);
> +	case 0x55:
> +		return etm_read(ETMCNTENR1);
> +	case 0x56:
> +		return etm_read(ETMCNTENR2);
> +	case 0x57:
> +		return etm_read(ETMCNTENR3);
> +	case 0x58:
> +		return etm_read(ETMCNTRLDEVR0);
> +	case 0x59:
> +		return etm_read(ETMCNTRLDEVR1);
> +	case 0x5A:
> +		return etm_read(ETMCNTRLDEVR2);
> +	case 0x5B:
> +		return etm_read(ETMCNTRLDEVR3);
> +	case 0x5C:
> +		return etm_read(ETMCNTVR0);
> +	case 0x5D:
> +		return etm_read(ETMCNTVR1);
> +	case 0x5E:
> +		return etm_read(ETMCNTVR2);
> +	case 0x5F:
> +		return etm_read(ETMCNTVR3);
> +	case 0x60:
> +		return etm_read(ETMSQ12EVR);
> +	case 0x61:
> +		return etm_read(ETMSQ21EVR);
> +	case 0x62:
> +		return etm_read(ETMSQ23EVR);
> +	case 0x63:
> +		return etm_read(ETMSQ31EVR);
> +	case 0x64:
> +		return etm_read(ETMSQ32EVR);
> +	case 0x65:
> +		return etm_read(ETMSQ13EVR);
> +	case 0x67:
> +		return etm_read(ETMSQR);
> +	case 0x68:
> +		return etm_read(ETMEXTOUTEVR0);
> +	case 0x69:
> +		return etm_read(ETMEXTOUTEVR1);
> +	case 0x6A:
> +		return etm_read(ETMEXTOUTEVR2);
> +	case 0x6B:
> +		return etm_read(ETMEXTOUTEVR3);
> +	case 0x6C:
> +		return etm_read(ETMCIDCVR0);
> +	case 0x6D:
> +		return etm_read(ETMCIDCVR1);
> +	case 0x6E:
> +		return etm_read(ETMCIDCVR2);
> +	case 0x6F:
> +		return etm_read(ETMCIDCMR);
> +	case 0x70:
> +		return etm_read(ETMIMPSPEC0);
> +	case 0x71:
> +		return etm_read(ETMIMPSPEC1);
> +	case 0x72:
> +		return etm_read(ETMIMPSPEC2);
> +	case 0x73:
> +		return etm_read(ETMIMPSPEC3);
> +	case 0x74:
> +		return etm_read(ETMIMPSPEC4);
> +	case 0x75:
> +		return etm_read(ETMIMPSPEC5);
> +	case 0x76:
> +		return etm_read(ETMIMPSPEC6);
> +	case 0x77:
> +		return etm_read(ETMIMPSPEC7);
> +	case 0x78:
> +		return etm_read(ETMSYNCFR);
> +	case 0x79:
> +		return etm_read(ETMIDR);
> +	case 0x7A:
> +		return etm_read(ETMCCER);
> +	case 0x7B:
> +		return etm_read(ETMEXTINSELR);
> +	case 0x7C:
> +		return etm_read(ETMTESSEICR);
> +	case 0x7D:
> +		return etm_read(ETMEIBCR);
> +	case 0x7E:
> +		return etm_read(ETMTSEVR);
> +	case 0x7F:
> +		return etm_read(ETMAUXCR);
> +	case 0x80:
> +		return etm_read(ETMTRACEIDR);
> +	case 0x90:
> +		return etm_read(ETMVMIDCVR);
> +	case 0xC1:
> +		return etm_read(ETMOSLSR);
> +	case 0xC2:
> +		return etm_read(ETMOSSRR);
> +	case 0xC4:
> +		return etm_read(ETMPDCR);
> +	case 0xC5:
> +		return etm_read(ETMPDSR);
> +	default:
> +		WARN(1, "invalid CP14 access to ETM reg: %lx",
> +							(unsigned long)reg);
> +		return 0;
> +	}
> +}
> +
> +static void etm_write_reg(uint32_t val, uint32_t reg)
> +{
> +	switch (reg) {
> +	case 0x0:
> +		etm_write(val, ETMCR);

Same comment as etm_read_reg but with a different macro.

> +		return;
> +	case 0x2:
> +		etm_write(val, ETMTRIGGER);
> +		return;
> +	case 0x4:
> +		etm_write(val, ETMSR);
> +		return;
> +	case 0x6:
> +		etm_write(val, ETMTSSCR);
> +		return;
> +	case 0x8:
> +		etm_write(val, ETMTEEVR);
> +		return;
> +	case 0x9:
> +		etm_write(val, ETMTECR1);
> +		return;
> +	case 0xB:
> +		etm_write(val, ETMFFLR);
> +		return;
> +	case 0x10:
> +		etm_write(val, ETMACVR0);
> +		return;
> +	case 0x11:
> +		etm_write(val, ETMACVR1);
> +		return;
> +	case 0x12:
> +		etm_write(val, ETMACVR2);
> +		return;
> +	case 0x13:
> +		etm_write(val, ETMACVR3);
> +		return;
> +	case 0x14:
> +		etm_write(val, ETMACVR4);
> +		return;
> +	case 0x15:
> +		etm_write(val, ETMACVR5);
> +		return;
> +	case 0x16:
> +		etm_write(val, ETMACVR6);
> +		return;
> +	case 0x17:
> +		etm_write(val, ETMACVR7);
> +		return;
> +	case 0x18:
> +		etm_write(val, ETMACVR8);
> +		return;
> +	case 0x19:
> +		etm_write(val, ETMACVR9);
> +		return;
> +	case 0x1A:
> +		etm_write(val, ETMACVR10);
> +		return;
> +	case 0x1B:
> +		etm_write(val, ETMACVR11);
> +		return;
> +	case 0x1C:
> +		etm_write(val, ETMACVR12);
> +		return;
> +	case 0x1D:
> +		etm_write(val, ETMACVR13);
> +		return;
> +	case 0x1E:
> +		etm_write(val, ETMACVR14);
> +		return;
> +	case 0x1F:
> +		etm_write(val, ETMACVR15);
> +		return;
> +	case 0x20:
> +		etm_write(val, ETMACTR0);
> +		return;
> +	case 0x21:
> +		etm_write(val, ETMACTR1);
> +		return;
> +	case 0x22:
> +		etm_write(val, ETMACTR2);
> +		return;
> +	case 0x23:
> +		etm_write(val, ETMACTR3);
> +		return;
> +	case 0x24:
> +		etm_write(val, ETMACTR4);
> +		return;
> +	case 0x25:
> +		etm_write(val, ETMACTR5);
> +		return;
> +	case 0x26:
> +		etm_write(val, ETMACTR6);
> +		return;
> +	case 0x27:
> +		etm_write(val, ETMACTR7);
> +		return;
> +	case 0x28:
> +		etm_write(val, ETMACTR8);
> +		return;
> +	case 0x29:
> +		etm_write(val, ETMACTR9);
> +		return;
> +	case 0x2A:
> +		etm_write(val, ETMACTR10);
> +		return;
> +	case 0x2B:
> +		etm_write(val, ETMACTR11);
> +		return;
> +	case 0x2C:
> +		etm_write(val, ETMACTR12);
> +		return;
> +	case 0x2D:
> +		etm_write(val, ETMACTR13);
> +		return;
> +	case 0x2E:
> +		etm_write(val, ETMACTR14);
> +		return;
> +	case 0x2F:
> +		etm_write(val, ETMACTR15);
> +		return;
> +	case 0x50:
> +		etm_write(val, ETMCNTRLDVR0);
> +		return;
> +	case 0x51:
> +		etm_write(val, ETMCNTRLDVR1);
> +		return;
> +	case 0x52:
> +		etm_write(val, ETMCNTRLDVR2);
> +		return;
> +	case 0x53:
> +		etm_write(val, ETMCNTRLDVR3);
> +		return;
> +	case 0x54:
> +		etm_write(val, ETMCNTENR0);
> +		return;
> +	case 0x55:
> +		etm_write(val, ETMCNTENR1);
> +		return;
> +	case 0x56:
> +		etm_write(val, ETMCNTENR2);
> +		return;
> +	case 0x57:
> +		etm_write(val, ETMCNTENR3);
> +		return;
> +	case 0x58:
> +		etm_write(val, ETMCNTRLDEVR0);
> +		return;
> +	case 0x59:
> +		etm_write(val, ETMCNTRLDEVR1);
> +		return;
> +	case 0x5A:
> +		etm_write(val, ETMCNTRLDEVR2);
> +		return;
> +	case 0x5B:
> +		etm_write(val, ETMCNTRLDEVR3);
> +		return;
> +	case 0x5C:
> +		etm_write(val, ETMCNTVR0);
> +		return;
> +	case 0x5D:
> +		etm_write(val, ETMCNTVR1);
> +		return;
> +	case 0x5E:
> +		etm_write(val, ETMCNTVR2);
> +		return;
> +	case 0x5F:
> +		etm_write(val, ETMCNTVR3);
> +		return;
> +	case 0x60:
> +		etm_write(val, ETMSQ12EVR);
> +		return;
> +	case 0x61:
> +		etm_write(val, ETMSQ21EVR);
> +		return;
> +	case 0x62:
> +		etm_write(val, ETMSQ23EVR);
> +		return;
> +	case 0x63:
> +		etm_write(val, ETMSQ31EVR);
> +		return;
> +	case 0x64:
> +		etm_write(val, ETMSQ32EVR);
> +		return;
> +	case 0x65:
> +		etm_write(val, ETMSQ13EVR);
> +		return;
> +	case 0x67:
> +		etm_write(val, ETMSQR);
> +		return;
> +	case 0x68:
> +		etm_write(val, ETMEXTOUTEVR0);
> +		return;
> +	case 0x69:
> +		etm_write(val, ETMEXTOUTEVR1);
> +		return;
> +	case 0x6A:
> +		etm_write(val, ETMEXTOUTEVR2);
> +		return;
> +	case 0x6B:
> +		etm_write(val, ETMEXTOUTEVR3);
> +		return;
> +	case 0x6C:
> +		etm_write(val, ETMCIDCVR0);
> +		return;
> +	case 0x6D:
> +		etm_write(val, ETMCIDCVR1);
> +		return;
> +	case 0x6E:
> +		etm_write(val, ETMCIDCVR2);
> +		return;
> +	case 0x6F:
> +		etm_write(val, ETMCIDCMR);
> +		return;
> +	case 0x70:
> +		etm_write(val, ETMIMPSPEC0);
> +		return;
> +	case 0x71:
> +		etm_write(val, ETMIMPSPEC1);
> +		return;
> +	case 0x72:
> +		etm_write(val, ETMIMPSPEC2);
> +		return;
> +	case 0x73:
> +		etm_write(val, ETMIMPSPEC3);
> +		return;
> +	case 0x74:
> +		etm_write(val, ETMIMPSPEC4);
> +		return;
> +	case 0x75:
> +		etm_write(val, ETMIMPSPEC5);
> +		return;
> +	case 0x76:
> +		etm_write(val, ETMIMPSPEC6);
> +		return;
> +	case 0x77:
> +		etm_write(val, ETMIMPSPEC7);
> +		return;
> +	case 0x78:
> +		etm_write(val, ETMSYNCFR);
> +		return;
> +	case 0x7B:
> +		etm_write(val, ETMEXTINSELR);
> +		return;
> +	case 0x7C:
> +		etm_write(val, ETMTESSEICR);
> +		return;
> +	case 0x7D:
> +		etm_write(val, ETMEIBCR);
> +		return;
> +	case 0x7E:
> +		etm_write(val, ETMTSEVR);
> +		return;
> +	case 0x7F:
> +		etm_write(val, ETMAUXCR);
> +		return;
> +	case 0x80:
> +		etm_write(val, ETMTRACEIDR);
> +		return;
> +	case 0x90:
> +		etm_write(val, ETMVMIDCVR);
> +		return;
> +	case 0xC0:
> +		etm_write(val, ETMOSLAR);
> +		return;
> +	case 0xC2:
> +		etm_write(val, ETMOSSRR);
> +		return;
> +	case 0xC4:
> +		etm_write(val, ETMPDCR);
> +		return;
> +	case 0xC5:
> +		etm_write(val, ETMPDSR);
> +		return;
> +	default:
> +		WARN(1, "invalid CP14 access to ETM reg: %lx",
> +							(unsigned long)reg);
> +		return;
> +	}
> +}
> +
> +static inline uint32_t offset_to_reg_num(uint32_t off)
> +{
> +	return off >> 2;
> +}
> +
> +unsigned int etm_readl_cp14(uint32_t off)
> +{
> +	uint32_t reg = offset_to_reg_num(off);
> +	return etm_read_reg(reg);
> +}
> +
> +void etm_writel_cp14(uint32_t val, uint32_t off)
> +{
> +	uint32_t reg = offset_to_reg_num(off);
> +	etm_write_reg(val, reg);
> +}

Revisiting previous comments... maybe we don't have to divide the MM
constants by four either? We could just not divide them by four here.


> diff --git a/drivers/coresight/coresight-etm.c b/drivers/coresight/coresight-etm.c
> new file mode 100644
> index 0000000..59589be
> --- /dev/null
> +++ b/drivers/coresight/coresight-etm.c
> @@ -0,0 +1,2360 @@
> +/* Copyright (c) 2011-2012, The Linux Foundation. All rights reserved.
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
> +#include <linux/platform_device.h>
> +#include <linux/io.h>
> +#include <linux/err.h>
> +#include <linux/fs.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +#include <linux/smp.h>
> +#include <linux/sysfs.h>
> +#include <linux/stat.h>
> +#include <linux/spinlock.h>
> +#include <linux/clk.h>
> +#include <linux/cpu.h>
> +#include <linux/of.h>
> +#include <linux/of_coresight.h>
> +#include <linux/coresight.h>
> +#include <asm/sections.h>
> +
> +#include "coresight-priv.h"
> +
> +#define etm_writel_mm(drvdata, val, off)  \
> +			__raw_writel((val), drvdata->base + off)
> +#define etm_readl_mm(drvdata, off)        \
> +			__raw_readl(drvdata->base + off)
> +
> +#define etm_writel(drvdata, val, off)					\
> +({									\
> +	if (drvdata->use_cp14)						\
> +		etm_writel_cp14(val, off);				\
> +	else								\
> +		etm_writel_mm(drvdata, val, off);			\
> +})
> +#define etm_readl(drvdata, off)						\
> +({									\
> +	uint32_t val;							\
> +	if (drvdata->use_cp14)						\
> +		val = etm_readl_cp14(off);				\
> +	else								\
> +		val = etm_readl_mm(drvdata, off);			\
> +	val;								\
> +})

Why macros rather than inlines?


> +
> +#define ETM_LOCK(drvdata)						\
> +do {									\
> +	/* Recommended by spec to ensure ETM writes are committed */	\
> +	/* prior to resuming execution */				\
> +	mb();								\
> +	isb();								\
> +	etm_writel_mm(drvdata, 0x0, CORESIGHT_LAR);			\
> +} while (0)
> +#define ETM_UNLOCK(drvdata)						\
> +do {									\
> +	etm_writel_mm(drvdata, CORESIGHT_UNLOCK, CORESIGHT_LAR);	\
> +	/* Ensure unlock and any pending writes are committed prior */	\
> +	/* to programming ETM registers */				\
> +	mb();								\
> +	isb();								\
> +} while (0)

Why macros rather than inlines?


> +
> +#define PORT_SIZE_MASK		(BM(21, 21) | BM(4, 6))
> +
> +/*
> + * Device registers:
> + * 0x000 - 0x2FC: Trace		registers
> + * 0x300 - 0x314: Management	registers
> + * 0x318 - 0xEFC: Trace		registers
> + *
> + * Coresight registers
> + * 0xF00 - 0xF9C: Management	registers
> + * 0xFA0 - 0xFA4: Management	registers in PFTv1.0
> + *		  Trace		registers in PFTv1.1
> + * 0xFA8 - 0xFFC: Management	registers
> + */
> +
> +/* Trace registers (0x000-0x2FC) */
> +#define ETMCR			(0x000)
> +#define ETMCCR			(0x004)
> +#define ETMTRIGGER		(0x008)
> +#define ETMSR			(0x010)
> +#define ETMSCR			(0x014)
> +#define ETMTSSCR		(0x018)
> +#define ETMTECR2		(0x01c)
> +#define ETMTEEVR		(0x020)
> +#define ETMTECR1		(0x024)
> +#define ETMFFLR			(0x02C)
> +#define ETMACVRn(n)		(0x040 + (n * 4))
> +#define ETMACTRn(n)		(0x080 + (n * 4))
> +#define ETMCNTRLDVRn(n)		(0x140 + (n * 4))
> +#define ETMCNTENRn(n)		(0x150 + (n * 4))
> +#define ETMCNTRLDEVRn(n)	(0x160 + (n * 4))
> +#define ETMCNTVRn(n)		(0x170 + (n * 4))
> +#define ETMSQ12EVR		(0x180)
> +#define ETMSQ21EVR		(0x184)
> +#define ETMSQ23EVR		(0x188)
> +#define ETMSQ31EVR		(0x18C)
> +#define ETMSQ32EVR		(0x190)
> +#define ETMSQ13EVR		(0x194)
> +#define ETMSQR			(0x19C)
> +#define ETMEXTOUTEVRn(n)	(0x1A0 + (n * 4))
> +#define ETMCIDCVRn(n)		(0x1B0 + (n * 4))
> +#define ETMCIDCMR		(0x1BC)
> +#define ETMIMPSPEC0		(0x1C0)
> +#define ETMIMPSPEC1		(0x1C4)
> +#define ETMIMPSPEC2		(0x1C8)
> +#define ETMIMPSPEC3		(0x1CC)
> +#define ETMIMPSPEC4		(0x1D0)
> +#define ETMIMPSPEC5		(0x1D4)
> +#define ETMIMPSPEC6		(0x1D8)
> +#define ETMIMPSPEC7		(0x1DC)
> +#define ETMSYNCFR		(0x1E0)
> +#define ETMIDR			(0x1E4)
> +#define ETMCCER			(0x1E8)
> +#define ETMEXTINSELR		(0x1EC)
> +#define ETMTESSEICR		(0x1F0)
> +#define ETMEIBCR		(0x1F4)
> +#define ETMTSEVR		(0x1F8)
> +#define ETMAUXCR		(0x1FC)
> +#define ETMTRACEIDR		(0x200)
> +#define ETMVMIDCVR		(0x240)
> +/* Management registers (0x300-0x314) */
> +#define ETMOSLAR		(0x300)
> +#define ETMOSLSR		(0x304)
> +#define ETMOSSRR		(0x308)
> +#define ETMPDCR			(0x310)
> +#define ETMPDSR			(0x314)

Move to a header file so the CP14 code can use them ;-)

> +
> +#define ETM_MAX_ADDR_CMP	(16)
> +#define ETM_MAX_CNTR		(4)
> +#define ETM_MAX_CTXID_CMP	(3)
> +
> +#define ETM_MODE_EXCLUDE	BIT(0)
> +#define ETM_MODE_CYCACC		BIT(1)
> +#define ETM_MODE_STALL		BIT(2)
> +#define ETM_MODE_TIMESTAMP	BIT(3)
> +#define ETM_MODE_CTXID		BIT(4)
> +#define ETM_MODE_ALL		(0x1F)
> +
> +#define ETM_EVENT_MASK		(0x1FFFF)
> +#define ETM_SYNC_MASK		(0xFFF)
> +#define ETM_ALL_MASK		(0xFFFFFFFF)
> +
> +#define ETM_SEQ_STATE_MAX_VAL	(0x2)
> +
> +enum etm_addr_type {
> +	ETM_ADDR_TYPE_NONE,
> +	ETM_ADDR_TYPE_SINGLE,
> +	ETM_ADDR_TYPE_RANGE,
> +	ETM_ADDR_TYPE_START,
> +	ETM_ADDR_TYPE_STOP,
> +};
> +
> +#ifdef CONFIG_CORESIGHT_SOURCE_ETM_DEFAULT_ENABLE
> +static int boot_enable = 1;
> +#else
> +static int boot_enable;
> +#endif
> +module_param_named(
> +	boot_enable, boot_enable, int, S_IRUGO
> +);
> +
> +struct etm_drvdata {
> +	void __iomem			*base;
> +	struct device			*dev;
> +	struct coresight_device		*csdev;
> +	struct clk			*clk;
> +	spinlock_t			spinlock;
> +	int				cpu;
> +	int				port_size;
> +	uint8_t				arch;
> +	bool				use_cp14;
> +	bool				enable;
> +	bool				sticky_enable;
> +	bool				boot_enable;
> +	bool				os_unlock;
> +	uint8_t				nr_addr_cmp;
> +	uint8_t				nr_cntr;
> +	uint8_t				nr_ext_inp;
> +	uint8_t				nr_ext_out;
> +	uint8_t				nr_ctxid_cmp;
> +	uint8_t				reset;
> +	uint32_t			mode;
> +	uint32_t			ctrl;
> +	uint32_t			trigger_event;
> +	uint32_t			startstop_ctrl;
> +	uint32_t			enable_event;
> +	uint32_t			enable_ctrl1;
> +	uint32_t			fifofull_level;
> +	uint8_t				addr_idx;
> +	uint32_t			addr_val[ETM_MAX_ADDR_CMP];
> +	uint32_t			addr_acctype[ETM_MAX_ADDR_CMP];
> +	uint32_t			addr_type[ETM_MAX_ADDR_CMP];
> +	uint8_t				cntr_idx;
> +	uint32_t			cntr_rld_val[ETM_MAX_CNTR];
> +	uint32_t			cntr_event[ETM_MAX_CNTR];
> +	uint32_t			cntr_rld_event[ETM_MAX_CNTR];
> +	uint32_t			cntr_val[ETM_MAX_CNTR];
> +	uint32_t			seq_12_event;
> +	uint32_t			seq_21_event;
> +	uint32_t			seq_23_event;
> +	uint32_t			seq_31_event;
> +	uint32_t			seq_32_event;
> +	uint32_t			seq_13_event;
> +	uint32_t			seq_curr_state;
> +	uint8_t				ctxid_idx;
> +	uint32_t			ctxid_val[ETM_MAX_CTXID_CMP];
> +	uint32_t			ctxid_mask;
> +	uint32_t			sync_freq;
> +	uint32_t			timestamp_event;
> +};
> +
> +static struct etm_drvdata *etmdrvdata[NR_CPUS];
> +
> +/*
> + * Memory mapped writes to clear os lock are not supported on some processors
> + * and OS lock must be unlocked before any memory mapped access on such
> + * processors, otherwise memory mapped reads/writes will be invalid.
> + */
> +static void etm_os_unlock(void *info)
> +{
> +	struct etm_drvdata *drvdata = (struct etm_drvdata *)info;
> +	etm_writel(drvdata, 0x0, ETMOSLAR);
> +	isb();
> +}
> +
> +static void etm_set_pwrdwn(struct etm_drvdata *drvdata)
> +{
> +	uint32_t etmcr;
> +
> +	/* Ensure pending cp14 accesses complete before setting pwrdwn */
> +	mb();
> +	isb();
> +	etmcr = etm_readl(drvdata, ETMCR);
> +	etmcr |= BIT(0);
> +	etm_writel(drvdata, etmcr, ETMCR);
> +}
> +
> +static void etm_clr_pwrdwn(struct etm_drvdata *drvdata)
> +{
> +	uint32_t etmcr;
> +
> +	etmcr = etm_readl(drvdata, ETMCR);
> +	etmcr &= ~BIT(0);
> +	etm_writel(drvdata, etmcr, ETMCR);
> +	/* Ensure pwrup completes before subsequent cp14 accesses */
> +	mb();
> +	isb();
> +}
> +
> +static void etm_set_pwrup(struct etm_drvdata *drvdata)
> +{
> +	uint32_t etmpdcr;
> +
> +	etmpdcr = etm_readl_mm(drvdata, ETMPDCR);
> +	etmpdcr |= BIT(3);
> +	etm_writel_mm(drvdata, etmpdcr, ETMPDCR);

Why are register accesses _mm here? They are not in pwrdown.


> +	/* Ensure pwrup completes before subsequent cp14 accesses */
> +	mb();
> +	isb();
> +}
> +
> +static void etm_clr_pwrup(struct etm_drvdata *drvdata)
> +{
> +	uint32_t etmpdcr;
> +
> +	/* Ensure pending cp14 accesses complete before clearing pwrup */
> +	mb();
> +	isb();
> +	etmpdcr = etm_readl_mm(drvdata, ETMPDCR);
> +	etmpdcr &= ~BIT(3);
> +	etm_writel_mm(drvdata, etmpdcr, ETMPDCR);
> +}

Same here. Why _mm?


> +static void etm_set_prog(struct etm_drvdata *drvdata)
> +{
> +	uint32_t etmcr;
> +	int count;
> +
> +	etmcr = etm_readl(drvdata, ETMCR);
> +	etmcr |= BIT(10);
> +	etm_writel(drvdata, etmcr, ETMCR);
> +	/*
> +	 * Recommended by spec for cp14 accesses to ensure etmcr write is
> +	 * complete before polling etmsr
> +	 */
> +	isb();
> +	for (count = TIMEOUT_US; BVAL(etm_readl(drvdata, ETMSR), 1) != 1
> +				&& count > 0; count--)
> +		udelay(1);
> +	WARN(count == 0, "timeout while setting prog bit, ETMSR: %#x\n",
> +	     etm_readl(drvdata, ETMSR));
> +}
> +
> +static void etm_clr_prog(struct etm_drvdata *drvdata)
> +{
> +	uint32_t etmcr;
> +	int count;
> +
> +	etmcr = etm_readl(drvdata, ETMCR);
> +	etmcr &= ~BIT(10);
> +	etm_writel(drvdata, etmcr, ETMCR);
> +	/*
> +	 * Recommended by spec for cp14 accesses to ensure etmcr write is
> +	 * complete before polling etmsr
> +	 */
> +	isb();
> +	for (count = TIMEOUT_US; BVAL(etm_readl(drvdata, ETMSR), 1) != 0
> +				&& count > 0; count--)
> +		udelay(1);
> +	WARN(count == 0, "timeout while clearing prog bit, ETMSR: %#x\n",
> +	     etm_readl(drvdata, ETMSR));
> +}
> +
> +static void __etm_enable(void *info)
> +{
> +	int i;
> +	uint32_t etmcr;
> +	struct etm_drvdata *drvdata = info;
> +
> +	ETM_UNLOCK(drvdata);
> +
> +	/* turn engine on */
> +	etm_clr_pwrdwn(drvdata);
> +	/* apply power to trace registers */
> +	etm_set_pwrup(drvdata);
> +	/* make sure all registers are accessible */
> +	etm_os_unlock(drvdata);
> +
> +	etm_set_prog(drvdata);
> +
> +	etmcr = etm_readl(drvdata, ETMCR);
> +	etmcr &= (BIT(10) | BIT(0));
> +	etmcr |= drvdata->port_size;
> +	etm_writel(drvdata, drvdata->ctrl | etmcr, ETMCR);
> +	etm_writel(drvdata, drvdata->trigger_event, ETMTRIGGER);
> +	etm_writel(drvdata, drvdata->startstop_ctrl, ETMTSSCR);
> +	etm_writel(drvdata, drvdata->enable_event, ETMTEEVR);
> +	etm_writel(drvdata, drvdata->enable_ctrl1, ETMTECR1);
> +	etm_writel(drvdata, drvdata->fifofull_level, ETMFFLR);
> +	for (i = 0; i < drvdata->nr_addr_cmp; i++) {
> +		etm_writel(drvdata, drvdata->addr_val[i], ETMACVRn(i));
> +		etm_writel(drvdata, drvdata->addr_acctype[i], ETMACTRn(i));
> +	}
> +	for (i = 0; i < drvdata->nr_cntr; i++) {
> +		etm_writel(drvdata, drvdata->cntr_rld_val[i], ETMCNTRLDVRn(i));
> +		etm_writel(drvdata, drvdata->cntr_event[i], ETMCNTENRn(i));
> +		etm_writel(drvdata, drvdata->cntr_rld_event[i],
> +			   ETMCNTRLDEVRn(i));
> +		etm_writel(drvdata, drvdata->cntr_val[i], ETMCNTVRn(i));
> +	}
> +	etm_writel(drvdata, drvdata->seq_12_event, ETMSQ12EVR);
> +	etm_writel(drvdata, drvdata->seq_21_event, ETMSQ21EVR);
> +	etm_writel(drvdata, drvdata->seq_23_event, ETMSQ23EVR);
> +	etm_writel(drvdata, drvdata->seq_31_event, ETMSQ31EVR);
> +	etm_writel(drvdata, drvdata->seq_32_event, ETMSQ32EVR);
> +	etm_writel(drvdata, drvdata->seq_13_event, ETMSQ13EVR);
> +	etm_writel(drvdata, drvdata->seq_curr_state, ETMSQR);
> +	for (i = 0; i < drvdata->nr_ext_out; i++)
> +		etm_writel(drvdata, 0x0000406F, ETMEXTOUTEVRn(i));
> +	for (i = 0; i < drvdata->nr_ctxid_cmp; i++)
> +		etm_writel(drvdata, drvdata->ctxid_val[i], ETMCIDCVRn(i));
> +	etm_writel(drvdata, drvdata->ctxid_mask, ETMCIDCMR);
> +	etm_writel(drvdata, drvdata->sync_freq, ETMSYNCFR);
> +	etm_writel(drvdata, 0x00000000, ETMEXTINSELR);
> +	etm_writel(drvdata, drvdata->timestamp_event, ETMTSEVR);
> +	etm_writel(drvdata, 0x00000000, ETMAUXCR);
> +	etm_writel(drvdata, drvdata->cpu + 1, ETMTRACEIDR);
> +	etm_writel(drvdata, 0x00000000, ETMVMIDCVR);
> +
> +	/* ensures trace output is enabled from this ETM */
> +	etm_writel(drvdata, drvdata->ctrl | BIT(11) | etmcr, ETMCR);
> +
> +	etm_clr_prog(drvdata);
> +	ETM_LOCK(drvdata);
> +
> +	dev_dbg(drvdata->dev, "cpu: %d enable smp call done\n", drvdata->cpu);
> +}
> +
> +static int etm_enable(struct coresight_device *csdev)
> +{
> +	struct etm_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
> +	int ret;
> +
> +	ret = clk_prepare_enable(drvdata->clk);
> +	if (ret)
> +		goto err_clk;
> +
> +	spin_lock(&drvdata->spinlock);
> +
> +	/*
> +	 * Executing __etm_enable on the cpu whose ETM is being enabled
> +	 * ensures that register writes occur when cpu is powered.
> +	 */
> +	ret = smp_call_function_single(drvdata->cpu, __etm_enable, drvdata, 1);
> +	if (ret)
> +		goto err;
> +	drvdata->enable = true;
> +	drvdata->sticky_enable = true;
> +
> +	spin_unlock(&drvdata->spinlock);
> +
> +	dev_info(drvdata->dev, "ETM tracing enabled\n");
> +	return 0;
> +err:
> +	spin_unlock(&drvdata->spinlock);
> +	clk_disable_unprepare(drvdata->clk);
> +err_clk:
> +	return ret;
> +}
> +
> +static void __etm_disable(void *info)
> +{
> +	struct etm_drvdata *drvdata = info;
> +
> +	ETM_UNLOCK(drvdata);
> +	etm_set_prog(drvdata);
> +
> +	/* Program trace enable to low by using always false event */
> +	etm_writel(drvdata, 0x6F | BIT(14), ETMTEEVR);
> +
> +	etm_set_pwrdwn(drvdata);
> +	ETM_LOCK(drvdata);
> +
> +	dev_dbg(drvdata->dev, "cpu: %d disable smp call done\n", drvdata->cpu);
> +}
> +
> +static void etm_disable(struct coresight_device *csdev)
> +{
> +	struct etm_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
> +
> +	/*
> +	 * Taking hotplug lock here protects from clocks getting disabled
> +	 * with tracing being left on (crash scenario) if user disable occurs
> +	 * after cpu online mask indicates the cpu is offline but before the
> +	 * DYING hotplug callback is serviced by the ETM driver.
> +	 */
> +	get_online_cpus();
> +	spin_lock(&drvdata->spinlock);
> +
> +	/*
> +	 * Executing __etm_disable on the cpu whose ETM is being disabled
> +	 * ensures that register writes occur when cpu is powered.
> +	 */
> +	smp_call_function_single(drvdata->cpu, __etm_disable, drvdata, 1);
> +	drvdata->enable = false;
> +
> +	spin_unlock(&drvdata->spinlock);
> +	put_online_cpus();
> +
> +	clk_disable_unprepare(drvdata->clk);
> +
> +	dev_info(drvdata->dev, "ETM tracing disabled\n");
> +}
> +
> +static const struct coresight_ops_source etm_source_ops = {
> +	.enable		= etm_enable,
> +	.disable	= etm_disable,
> +};
> +
> +static const struct coresight_ops etm_cs_ops = {
> +	.source_ops	= &etm_source_ops,
> +};
> +
> +static ssize_t debugfs_show_nr_addr_cmp(struct file *file,
> +					char __user *user_buf,
> +					size_t count, loff_t *ppos)
> +{
> +	int ret;
> +	unsigned long val;
> +	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	struct etm_drvdata *drvdata = file->private_data;
> +
> +	val = drvdata->nr_addr_cmp;
> +	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
> +	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
> +
> +	kfree(buf);
> +	return ret;
> +}
> +
> +static const struct file_operations debugfs_nr_addr_cmp_ops = {
> +	.open = simple_open,
> +	.read = debugfs_show_nr_addr_cmp,
> +};


DEFINE_SIMPLE_ATTRIBUTE() would acheive the above with smaller code size
and no bugs.


> +static const struct coresight_ops_entry debugfs_nr_addr_cmp_entry = {
> +	.name = "nr_addr_cmp",
> +	.mode =  S_IRUGO,
> +	.ops = &debugfs_nr_addr_cmp_ops,
> +};

This (and its friends futher down) look samey enough to merit a
DEFINE_CORESIGHT_ENTRY() macro.


> +static ssize_t debugfs_show_nr_cntr(struct file *file,
> +				    char __user *user_buf,
> +				    size_t count, loff_t *ppos)
> +{
> +	int ret;
> +	unsigned long val;
> +	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	struct etm_drvdata *drvdata = file->private_data;
> +
> +	val = drvdata->nr_cntr;
> +	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
> +	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
> +
> +	kfree(buf);
> +	return ret;
> +}
> +
> +static const struct file_operations debugfs_nr_cntr_ops = {
> +	.open = simple_open,
> +	.read = debugfs_show_nr_cntr,
> +};
> +
> +static const struct coresight_ops_entry debugfs_nr_cntr_entry = {
> +	.name = "nr_cntr",
> +	.mode =  S_IRUGO,
> +	.ops = &debugfs_nr_cntr_ops,
> +};

DEFINE_SIMPLE_ATTRIBITE() and DEFINE_CORESIGHT_ENTRY()

> +
> +static ssize_t debugfs_show_nr_ctxid_cmp(struct file *file,
> +					 char __user *user_buf,
> +					 size_t count, loff_t *ppos)
> +{
> +	int ret;
> +	unsigned long val;
> +	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	struct etm_drvdata *drvdata = file->private_data;
> +
> +	val = drvdata->nr_ctxid_cmp;
> +	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
> +	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
> +
> +	kfree(buf);
> +	return ret;
> +}
> +
> +static const struct file_operations debugfs_nr_ctxid_cmp_ops = {
> +	.open = simple_open,
> +	.read = debugfs_show_nr_ctxid_cmp,
> +};
> +
> +static const struct coresight_ops_entry debugfs_nr_ctxid_cmp_entry = {
> +	.name = "nr_ctxid_cmp",
> +	.mode =  S_IRUGO,
> +	.ops = &debugfs_nr_ctxid_cmp_ops,
> +};

DEFINE_SIMPLE_ATTRIBITE() and DEFINE_CORESIGHT_ENTRY()

> +static ssize_t debugfs_show_reset(struct file *file,
> +				  char __user *user_buf,
> +				  size_t count, loff_t *ppos)
> +{
> +	int ret;
> +	unsigned long val;
> +	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	struct etm_drvdata *drvdata = file->private_data;
> +
> +	val = drvdata->reset;
> +	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
> +	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
> +
> +	kfree(buf);
> +	return ret;
> +}
> +
> +/* Reset to trace everything i.e. exclude nothing. */
> +static ssize_t debugfs_store_reset(struct file *file,
> +				   const char __user *user_buf,
> +				   size_t count, loff_t *ppos)
> +{
> +	int i;
> +	unsigned long val;
> +	struct etm_drvdata *drvdata = file->private_data;
> +
> +	if (sscanf(user_buf, "%lx", &val) != 1)
> +		return -EINVAL;
> +
> +	spin_lock(&drvdata->spinlock);
> +	if (val) {
> +		drvdata->mode = ETM_MODE_EXCLUDE;
> +		drvdata->ctrl = 0x0;
> +		drvdata->trigger_event = 0x406F;
> +		drvdata->startstop_ctrl = 0x0;
> +		drvdata->enable_event = 0x6F;
> +		drvdata->enable_ctrl1 = 0x1000000;
> +		drvdata->fifofull_level = 0x28;
> +		drvdata->addr_idx = 0x0;
> +		for (i = 0; i < drvdata->nr_addr_cmp; i++) {
> +			drvdata->addr_val[i] = 0x0;
> +			drvdata->addr_acctype[i] = 0x0;
> +			drvdata->addr_type[i] = ETM_ADDR_TYPE_NONE;
> +		}
> +		drvdata->cntr_idx = 0x0;
> +		for (i = 0; i < drvdata->nr_cntr; i++) {
> +			drvdata->cntr_rld_val[i] = 0x0;
> +			drvdata->cntr_event[i] = 0x406F;
> +			drvdata->cntr_rld_event[i] = 0x406F;
> +			drvdata->cntr_val[i] = 0x0;
> +		}
> +		drvdata->seq_12_event = 0x406F;
> +		drvdata->seq_21_event = 0x406F;
> +		drvdata->seq_23_event = 0x406F;
> +		drvdata->seq_31_event = 0x406F;
> +		drvdata->seq_32_event = 0x406F;
> +		drvdata->seq_13_event = 0x406F;
> +		drvdata->seq_curr_state = 0x0;
> +		drvdata->ctxid_idx = 0x0;
> +		for (i = 0; i < drvdata->nr_ctxid_cmp; i++)
> +			drvdata->ctxid_val[i] = 0x0;
> +		drvdata->ctxid_mask = 0x0;
> +		drvdata->sync_freq = 0x100;
> +		drvdata->timestamp_event = 0x406F;
> +	}
> +	spin_unlock(&drvdata->spinlock);
> +	return count;
> +}

This smells like it shared lots of code with __etm_enable(). Not sure
though with all those 0x406F.

Whatever the case, this code should probably be hoisted out of the
debugfs code and into a named function.

> +
> +static const struct file_operations debugfs_reset_ops = {
> +	.open = simple_open,
> +	.read = debugfs_show_reset,
> +	.write = debugfs_store_reset,
> +};
> +
> +static const struct coresight_ops_entry debugfs_reset_entry = {
> +	.name = "reset",
> +	.mode =  S_IRUGO | S_IWUSR,
> +	.ops = &debugfs_reset_ops,
> +};
> +
> +static ssize_t debugfs_show_mode(struct file *file,
> +				 char __user *user_buf,
> +				 size_t count, loff_t *ppos)
> +{
> +	int ret;
> +	unsigned long val;
> +	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	struct etm_drvdata *drvdata = file->private_data;
> +
> +	val = drvdata->mode;
> +	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
> +	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
> +
> +	kfree(buf);
> +	return ret;
> +}
> +
> +static ssize_t debugfs_store_mode(struct file *file,
> +				  const char __user *user_buf,
> +				  size_t count, loff_t *ppos)
> +{
> +	unsigned long val;
> +	struct etm_drvdata *drvdata = file->private_data;
> +
> +	if (sscanf(user_buf, "%lx", &val) != 1)
> +		return -EINVAL;
> +
> +	spin_lock(&drvdata->spinlock);
> +	drvdata->mode = val & ETM_MODE_ALL;
> +
> +	if (drvdata->mode & ETM_MODE_EXCLUDE)
> +		drvdata->enable_ctrl1 |= BIT(24);
> +	else
> +		drvdata->enable_ctrl1 &= ~BIT(24);
> +
> +	if (drvdata->mode & ETM_MODE_CYCACC)
> +		drvdata->ctrl |= BIT(12);
> +	else
> +		drvdata->ctrl &= ~BIT(12);
> +
> +	if (drvdata->mode & ETM_MODE_STALL)
> +		drvdata->ctrl |= BIT(7);
> +	else
> +		drvdata->ctrl &= ~BIT(7);
> +
> +	if (drvdata->mode & ETM_MODE_TIMESTAMP)
> +		drvdata->ctrl |= BIT(28);
> +	else
> +		drvdata->ctrl &= ~BIT(28);
> +
> +	if (drvdata->mode & ETM_MODE_CTXID)
> +		drvdata->ctrl |= (BIT(14) | BIT(15));
> +	else
> +		drvdata->ctrl &= ~(BIT(14) | BIT(15));
> +	spin_unlock(&drvdata->spinlock);
> +
> +	return count;
> +}
> +
> +static const struct file_operations debugfs_mode_ops = {
> +	.open = simple_open,
> +	.read = debugfs_show_mode,
> +	.write = debugfs_store_mode,
> +};
> +
> +static const struct coresight_ops_entry debugfs_mode_entry = {
> +	.name = "mode",
> +	.mode =  S_IRUGO | S_IWUSR,
> +	.ops = &debugfs_mode_ops,
> +};

DEFINE_SIMPLE_ATTRIBITE() and DEFINE_CORESIGHT_ENTRY()

> +
> +static ssize_t debugfs_show_trigger_event(struct file *file,
> +					  char __user *user_buf,
> +					  size_t count, loff_t *ppos)
> +{
> +	int ret;
> +	unsigned long val;
> +	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	struct etm_drvdata *drvdata = file->private_data;
> +
> +	val = drvdata->trigger_event;
> +	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
> +	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
> +
> +	kfree(buf);
> +	return ret;
> +}
> +
> +static ssize_t debugfs_store_trigger_event(struct file *file,
> +					   const char __user *user_buf,
> +					   size_t count, loff_t *ppos)
> +{
> +	unsigned long val;
> +	struct etm_drvdata *drvdata = file->private_data;
> +
> +	if (sscanf(user_buf, "%lx", &val) != 1)
> +		return -EINVAL;
> +
> +	drvdata->trigger_event = val & ETM_EVENT_MASK;
> +	return count;
> +}
> +
> +static const struct file_operations debugfs_trigger_event_ops = {
> +	.open = simple_open,
> +	.read = debugfs_show_trigger_event,
> +	.write = debugfs_store_trigger_event,
> +};
> +
> +static const struct coresight_ops_entry debugfs_trigger_events_entry = {
> +	.name = "trigger_event",
> +	.mode =  S_IRUGO | S_IWUSR,
> +	.ops = &debugfs_trigger_event_ops,
> +};

DEFINE_SIMPLE_ATTRIBITE() and DEFINE_CORESIGHT_ENTRY()

> +
> +static ssize_t debugfs_show_enable_event(struct file *file,
> +					 char __user *user_buf,
> +					 size_t count, loff_t *ppos)
> +{
> +	int ret;
> +	unsigned long val;
> +	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	struct etm_drvdata *drvdata = file->private_data;
> +
> +	val = drvdata->enable_event;
> +	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
> +	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
> +
> +	kfree(buf);
> +	return ret;
> +}
> +
> +static ssize_t debugfs_store_enable_event(struct file *file,
> +					  const char __user *user_buf,
> +					  size_t count, loff_t *ppos)
> +{
> +	unsigned long val;
> +	struct etm_drvdata *drvdata = file->private_data;
> +
> +	if (sscanf(user_buf, "%lx", &val) != 1)
> +		return -EINVAL;
> +
> +	drvdata->enable_event = val & ETM_EVENT_MASK;
> +	return count;
> +}
> +
> +static const struct file_operations debugfs_enable_event_ops = {
> +	.open = simple_open,
> +	.read = debugfs_show_enable_event,
> +	.write = debugfs_store_enable_event,
> +};
> +
> +static const struct coresight_ops_entry debugfs_enable_events_entry = {
> +	.name = "enable_event",
> +	.mode =  S_IRUGO | S_IWUSR,
> +	.ops = &debugfs_enable_event_ops,
> +};
> +

DEFINE_SIMPLE_ATTRIBITE() and DEFINE_CORESIGHT_ENTRY()

> +static ssize_t debugfs_show_fifofull_level(struct file *file,
> +					   char __user *user_buf,
> +					   size_t count, loff_t *ppos)
> +{
> +	int ret;
> +	unsigned long val;
> +	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	struct etm_drvdata *drvdata = file->private_data;
> +
> +	val = drvdata->fifofull_level;
> +	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
> +	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
> +
> +	kfree(buf);
> +	return ret;
> +}
> +
> +static ssize_t debugfs_store_fifofull_level(struct file *file,
> +					    const char __user *user_buf,
> +					    size_t count, loff_t *ppos)
> +{
> +	unsigned long val;
> +	struct etm_drvdata *drvdata = file->private_data;
> +
> +	if (sscanf(user_buf, "%lx", &val) != 1)
> +		return -EINVAL;
> +
> +	drvdata->fifofull_level = val;
> +	return count;
> +}
> +
> +static const struct file_operations debugfs_fifofull_level_ops = {
> +	.open = simple_open,
> +	.read = debugfs_show_fifofull_level,
> +	.write = debugfs_store_fifofull_level,
> +};
> +
> +static const struct coresight_ops_entry debugfs_fifofull_level_entry = {
> +	.name = "fifofull_level",
> +	.mode =  S_IRUGO | S_IWUSR,
> +	.ops = &debugfs_fifofull_level_ops,
> +};
> +

DEFINE_SIMPLE_ATTRIBITE() and DEFINE_CORESIGHT_ENTRY()

> +static ssize_t debugfs_show_addr_idx(struct file *file,
> +				     char __user *user_buf,
> +				     size_t count, loff_t *ppos)
> +{
> +	int ret;
> +	unsigned long val;
> +	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	struct etm_drvdata *drvdata = file->private_data;
> +
> +	val = drvdata->addr_idx;
> +	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
> +	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
> +
> +	kfree(buf);
> +	return ret;
> +}
> +
> +static ssize_t debugfs_store_addr_idx(struct file *file,
> +				      const char __user *user_buf,
> +				      size_t count, loff_t *ppos)
> +{
> +	unsigned long val;
> +	struct etm_drvdata *drvdata = file->private_data;
> +
> +	if (sscanf(user_buf, "%lx", &val) != 1)
> +		return -EINVAL;
> +	if (val >= drvdata->nr_addr_cmp)
> +		return -EINVAL;
> +
> +	/*
> +	 * Use spinlock to ensure index doesn't change while it gets
> +	 * dereferenced multiple times within a spinlock block elsewhere.
> +	 */
> +	spin_lock(&drvdata->spinlock);
> +	drvdata->addr_idx = val;
> +	spin_unlock(&drvdata->spinlock);
> +	return count;
> +}
> +
> +static const struct file_operations debugfs_addr_idx_ops = {
> +	.open = simple_open,
> +	.read = debugfs_show_addr_idx,
> +	.write = debugfs_store_addr_idx,
> +};
> +
> +static const struct coresight_ops_entry debugfs_addr_idx_entry = {
> +	.name = "addr_idx",
> +	.mode =  S_IRUGO | S_IWUSR,
> +	.ops = &debugfs_addr_idx_ops,
> +};
> +

DEFINE_SIMPLE_ATTRIBITE() and DEFINE_CORESIGHT_ENTRY()

> +static ssize_t debugfs_show_addr_single(struct file *file,
> +					char __user *user_buf,
> +					size_t count, loff_t *ppos)
> +{
> +	int ret;
> +	uint8_t idx;
> +	unsigned long val;
> +	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	struct etm_drvdata *drvdata = file->private_data;
> +
> +	spin_lock(&drvdata->spinlock);
> +	idx = drvdata->addr_idx;
> +	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
> +	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_SINGLE)) {
> +		spin_unlock(&drvdata->spinlock);
> +		return -EPERM;

-EPERM?

Is this really a permissions check.

> +	}
> +
> +	val = drvdata->addr_val[idx];
> +	spin_unlock(&drvdata->spinlock);
> +	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
> +	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
> +
> +	kfree(buf);
> +	return ret;
> +}
> +
> +static ssize_t debugfs_store_addr_single(struct file *file,
> +					 const char __user *user_buf,
> +					 size_t count, loff_t *ppos)
> +{
> +	uint8_t idx;
> +	unsigned long val;
> +	struct etm_drvdata *drvdata = file->private_data;
> +
> +	if (sscanf(user_buf, "%lx", &val) != 1)
> +		return -EINVAL;
> +
> +	spin_lock(&drvdata->spinlock);
> +	idx = drvdata->addr_idx;
> +	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
> +	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_SINGLE)) {
> +		spin_unlock(&drvdata->spinlock);
> +		return -EPERM;

-EPERM?

> +	}
> +
> +	drvdata->addr_val[idx] = val;
> +	drvdata->addr_type[idx] = ETM_ADDR_TYPE_SINGLE;
> +	spin_unlock(&drvdata->spinlock);
> +	return count;
> +}
> +
> +static const struct file_operations debugfs_addr_single_ops = {
> +	.open = simple_open,
> +	.read = debugfs_show_addr_single,
> +	.write = debugfs_store_addr_single,
> +};
> +
> +static const struct coresight_ops_entry debugfs_addr_single_entry = {
> +	.name = "addr_single",
> +	.mode =  S_IRUGO | S_IWUSR,
> +	.ops = &debugfs_addr_single_ops,
> +};

DEFINE_SIMPLE_ATTRIBITE() and DEFINE_CORESIGHT_ENTRY()

> +static ssize_t debugfs_show_addr_range(struct file *file,
> +				       char __user *user_buf,
> +				       size_t count, loff_t *ppos)
> +{
> +	int ret;
> +	uint8_t idx;
> +	unsigned long val1, val2;
> +	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	struct etm_drvdata *drvdata = file->private_data;
> +
> +	spin_lock(&drvdata->spinlock);
> +	idx = drvdata->addr_idx;
> +	if (idx % 2 != 0) {
> +		spin_unlock(&drvdata->spinlock);
> +		return -EPERM;

-EPERM?

> +	}
> +	if (!((drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE &&
> +	       drvdata->addr_type[idx + 1] == ETM_ADDR_TYPE_NONE) ||
> +	      (drvdata->addr_type[idx] == ETM_ADDR_TYPE_RANGE &&
> +	       drvdata->addr_type[idx + 1] == ETM_ADDR_TYPE_RANGE))) {
> +		spin_unlock(&drvdata->spinlock);
> +		return -EPERM;

-EPERM?

> +	}
> +
> +	val1 = drvdata->addr_val[idx];
> +	val2 = drvdata->addr_val[idx + 1];
> +	spin_unlock(&drvdata->spinlock);
> +	ret = scnprintf(buf, PAGE_SIZE, "%#lx %#lx\n", val1, val2);
> +	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
> +
> +	kfree(buf);
> +	return ret;
> +}
> +
> +static ssize_t debugfs_store_addr_range(struct file *file,
> +					const char __user *user_buf,
> +					size_t count, loff_t *ppos)
> +{
> +	uint8_t idx;
> +	unsigned long val1, val2;
> +	struct etm_drvdata *drvdata = file->private_data;
> +
> +	if (sscanf(user_buf, "%lx %lx", &val1, &val2) != 2)
> +		return -EINVAL;
> +	/* Lower address comparator cannot have a higher address value */
> +	if (val1 > val2)
> +		return -EINVAL;
> +
> +	spin_lock(&drvdata->spinlock);
> +	idx = drvdata->addr_idx;
> +	if (idx % 2 != 0) {
> +		spin_unlock(&drvdata->spinlock);
> +		return -EPERM;

-EPERM?

> +	}
> +	if (!((drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE &&
> +	       drvdata->addr_type[idx + 1] == ETM_ADDR_TYPE_NONE) ||
> +	      (drvdata->addr_type[idx] == ETM_ADDR_TYPE_RANGE &&
> +	       drvdata->addr_type[idx + 1] == ETM_ADDR_TYPE_RANGE))) {
> +		spin_unlock(&drvdata->spinlock);
> +		return -EPERM;

-EPERM?

> +	}
> +
> +	drvdata->addr_val[idx] = val1;
> +	drvdata->addr_type[idx] = ETM_ADDR_TYPE_RANGE;
> +	drvdata->addr_val[idx + 1] = val2;
> +	drvdata->addr_type[idx + 1] = ETM_ADDR_TYPE_RANGE;
> +	drvdata->enable_ctrl1 |= (1 << (idx/2));
> +	spin_unlock(&drvdata->spinlock);
> +	return count;
> +}
> +
> +static const struct file_operations debugfs_addr_range_ops = {
> +	.open = simple_open,
> +	.read = debugfs_show_addr_range,
> +	.write = debugfs_store_addr_range,
> +};
> +
> +static const struct coresight_ops_entry debugfs_addr_range_entry = {
> +	.name = "addr_range",
> +	.mode =  S_IRUGO | S_IWUSR,
> +	.ops = &debugfs_addr_range_ops,
> +};

DEFINE_SIMPLE_ATTRIBITE() and DEFINE_CORESIGHT_ENTRY()

SNIP!!!

My comments of debugfs get a bit samey from here on down so I've deleted
a big chunk.


> +static ssize_t debugfs_status_read(struct file *file, char __user *user_buf,
> +				   size_t count, loff_t *ppos)
> +{
> +	ssize_t ret;
> +	uint32_t val;
> +	unsigned long flags;
> +	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	struct etm_drvdata *drvdata = file->private_data;
> +
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	ret = clk_prepare_enable(drvdata->clk);
> +	if (ret)
> +		goto out;
> +
> +	spin_lock_irqsave(&drvdata->spinlock, flags);
> +
> +	ETM_UNLOCK(drvdata);
> +	val = etm_readl(drvdata, ETMCCR);
> +	ret += sprintf(buf, "ETMCCR: 0x%08x\n", val);
> +	val = etm_readl(drvdata, ETMCCER);
> +	ret += sprintf(buf + ret, "ETMCCER: 0x%08x\n", val);
> +	val = etm_readl(drvdata, ETMSCR);
> +	ret += sprintf(buf + ret, "ETMSCR: 0x%08x\n", val);
> +	val = etm_readl(drvdata, ETMIDR);
> +	ret += sprintf(buf + ret, "ETMIDR: 0x%08x\n", val);
> +	val = etm_readl(drvdata, ETMCR);
> +	ret += sprintf(buf + ret, "ETMCR: 0x%08x\n", val);
> +	val = etm_readl(drvdata, ETMTEEVR);
> +	ret += sprintf(buf + ret, "Enable event: 0x%08x\n", val);
> +	val = etm_readl(drvdata, ETMTSSCR);
> +	ret += sprintf(buf + ret, "Enable start/stop: 0x%08x\n", val);
> +	ret += sprintf(buf + ret,
> +		       "Enable control: CR1 0x%08x CR2 0x%08x\n",
> +		       etm_readl(drvdata, ETMTECR1),
> +		       etm_readl(drvdata, ETMTECR2));
> +
> +	ETM_LOCK(drvdata);
> +
> +	spin_unlock_irqrestore(&drvdata->spinlock, flags);
> +	clk_disable_unprepare(drvdata->clk);
> +
> +	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
> +out:
> +	kfree(buf);
> +	return ret;
> +}

Really not sure whether this should be in the read method. If we don't
read the file in one go the spin_lock() we'll not get a cohesive set of
registers.


> +
> +static const struct file_operations debugfs_status_ops = {
> +	.open = simple_open,
> +	.read = debugfs_status_read,
> +};
> +
> +static const struct coresight_ops_entry debugfs_status_entry = {
> +	.name = "status",
> +	.mode =  S_IRUGO,
> +	.ops = &debugfs_status_ops,
> +};
> +
> +static const struct coresight_ops_entry *etm_attr_grps[] = {
> +	&debugfs_nr_addr_cmp_entry,
> +	&debugfs_nr_cntr_entry,
> +	&debugfs_nr_ctxid_cmp_entry,
> +	&debugfs_reset_entry,
> +	&debugfs_mode_entry,
> +	&debugfs_trigger_events_entry,
> +	&debugfs_enable_events_entry,
> +	&debugfs_fifofull_level_entry,
> +	&debugfs_addr_idx_entry,
> +	&debugfs_addr_single_entry,
> +	&debugfs_addr_range_entry,
> +	&debugfs_addr_start_entry,
> +	&debugfs_addr_stop_entry,
> +	&debugfs_addr_acctype_entry,
> +	&debugfs_cntr_idx_entry,
> +	&debugfs_cntr_rld_val_entry,
> +	&debugfs_cntr_event_entry,
> +	&debugfs_cntr_rld_event_entry,
> +	&debugfs_cntr_val_entry,
> +	&debugfs_12_event_entry,
> +	&debugfs_21_event_entry,
> +	&debugfs_23_event_entry,
> +	&debugfs_31_event_entry,
> +	&debugfs_32_event_entry,
> +	&debugfs_13_event_entry,
> +	&debugfs_seq_curr_state_entry,
> +	&debugfs_ctxid_idx_entry,
> +	&debugfs_ctxid_val_entry,
> +	&debugfs_ctxid_mask_entry,
> +	&debugfs_sync_freq_entry,
> +	&debugfs_timestamp_event_entry,
> +	&debugfs_status_entry,
> +	NULL,
> +};
> +
> +static int etm_cpu_callback(struct notifier_block *nfb, unsigned long action,
> +			    void *hcpu)
> +{
> +	unsigned int cpu = (unsigned long)hcpu;
> +
> +	if (!etmdrvdata[cpu])
> +		goto out;
> +
> +	switch (action & (~CPU_TASKS_FROZEN)) {
> +	case CPU_STARTING:
> +		spin_lock(&etmdrvdata[cpu]->spinlock);
> +		if (!etmdrvdata[cpu]->os_unlock) {
> +			etm_os_unlock(etmdrvdata[cpu]);
> +			etmdrvdata[cpu]->os_unlock = true;
> +		}
> +
> +		if (etmdrvdata[cpu]->enable)
> +			__etm_enable(etmdrvdata[cpu]);
> +		spin_unlock(&etmdrvdata[cpu]->spinlock);
> +		break;
> +
> +	case CPU_ONLINE:
> +		if (etmdrvdata[cpu]->boot_enable &&
> +		    !etmdrvdata[cpu]->sticky_enable)
> +			coresight_enable(etmdrvdata[cpu]->csdev);
> +		break;
> +
> +	case CPU_DYING:
> +		spin_lock(&etmdrvdata[cpu]->spinlock);
> +		if (etmdrvdata[cpu]->enable)
> +			__etm_disable(etmdrvdata[cpu]);
> +		spin_unlock(&etmdrvdata[cpu]->spinlock);
> +		break;
> +	}
> +out:
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block etm_cpu_notifier = {
> +	.notifier_call = etm_cpu_callback,
> +};
> +
> +static bool etm_arch_supported(uint8_t arch)
> +{
> +	switch (arch) {
> +	case ETM_ARCH_V3_3:
> +		break;
> +	case ETM_ARCH_V3_5:
> +		break;
> +	case PFT_ARCH_V1_1:
> +		break;
> +	default:
> +		return false;
> +	}
> +	return true;
> +}
> +
> +static void etm_init_arch_data(void *info)
> +{
> +	uint32_t etmidr;
> +	uint32_t etmccr;
> +	struct etm_drvdata *drvdata = info;
> +
> +	ETM_UNLOCK(drvdata);
> +
> +	/* first dummy read */
> +	(void)etm_readl(drvdata, ETMPDSR);
> +	/* Provide power to ETM: ETMPDCR[3] == 1 */
> +	etm_set_pwrup(drvdata);
> +	/*
> +	 * Clear power down bit since when this bit is set writes to
> +	 * certain registers might be ignored.
> +	 */
> +	etm_clr_pwrdwn(drvdata);
> +	/*
> +	 * Set prog bit. It will be set from reset but this is included to
> +	 * ensure it is set
> +	 */
> +	etm_set_prog(drvdata);
> +
> +	/* Find all capabilities */
> +	etmidr = etm_readl(drvdata, ETMIDR);
> +	drvdata->arch = BMVAL(etmidr, 4, 11);
> +	drvdata->port_size = etm_readl(drvdata, ETMCR) & PORT_SIZE_MASK;
> +
> +	etmccr = etm_readl(drvdata, ETMCCR);
> +	drvdata->nr_addr_cmp = BMVAL(etmccr, 0, 3) * 2;
> +	drvdata->nr_cntr = BMVAL(etmccr, 13, 15);
> +	drvdata->nr_ext_inp = BMVAL(etmccr, 17, 19);
> +	drvdata->nr_ext_out = BMVAL(etmccr, 20, 22);
> +	drvdata->nr_ctxid_cmp = BMVAL(etmccr, 24, 25);
> +
> +	etm_set_pwrdwn(drvdata);
> +	etm_clr_pwrup(drvdata);
> +	ETM_LOCK(drvdata);
> +}
> +
> +static void etm_init_default_data(struct etm_drvdata *drvdata)
> +{
> +	int i;
> +
> +	uint32_t flags = (1 << 0 | /* instruction execute*/
> +			  3 << 3 | /* ARM instruction */
> +			  0 << 5 | /* No data value comparison */
> +			  0 << 7 | /* No exact mach */
> +			  0 << 8 | /* Ignore context ID */
> +			  0 << 10); /* Security ignored */
> +
> +	drvdata->ctrl = (BIT(12) | /* cycle accurate */
> +			 BIT(28)); /* timestamp */
> +	drvdata->trigger_event = 0x406F;
> +	drvdata->enable_event = 0x6F;
> +	drvdata->enable_ctrl1 = 0x1;
> +	drvdata->fifofull_level	= 0x28;
> +	if (drvdata->nr_addr_cmp >= 2) {
> +		drvdata->addr_val[0] = (uint32_t) _stext;
> +		drvdata->addr_val[1] = (uint32_t) _etext;
> +		drvdata->addr_acctype[0] = flags;
> +		drvdata->addr_acctype[1] = flags;
> +		drvdata->addr_type[0] = ETM_ADDR_TYPE_RANGE;
> +		drvdata->addr_type[1] = ETM_ADDR_TYPE_RANGE;
> +	}
> +	for (i = 0; i < drvdata->nr_cntr; i++) {
> +		drvdata->cntr_event[i] = 0x406F;
> +		drvdata->cntr_rld_event[i] = 0x406F;
> +	}
> +	drvdata->seq_12_event = 0x406F;
> +	drvdata->seq_21_event = 0x406F;
> +	drvdata->seq_23_event = 0x406F;
> +	drvdata->seq_31_event = 0x406F;
> +	drvdata->seq_32_event = 0x406F;
> +	drvdata->seq_13_event = 0x406F;
> +	drvdata->sync_freq = 0x100;
> +	drvdata->timestamp_event = 0x406F;
> +}

Ah... here's all those 0x406F I thought looked odd in the implementation
of the reset attribute. This code should be commoned up as much as
possible with the reset code.

Also perhaps a #define to explain what 0x406F means?


> +
> +static int etm_probe(struct platform_device *pdev)
> +{
> +	int ret;
> +	struct device *dev = &pdev->dev;
> +	struct coresight_platform_data *pdata = NULL;
> +	struct etm_drvdata *drvdata;
> +	struct resource *res;
> +	static int count;

That "static" is very well concealed. I missed that until I started
studying the error paths.

> +	struct coresight_desc *desc;
> +
> +	drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
> +	if (!drvdata)
> +		return -ENOMEM;
> +
> +	if (pdev->dev.of_node) {
> +		pdata = of_get_coresight_platform_data(dev, pdev->dev.of_node);
> +		if (IS_ERR(pdata))
> +			return PTR_ERR(pdata);
> +		pdev->dev.platform_data = pdata;
> +		drvdata->use_cp14 = of_property_read_bool(pdev->dev.of_node,
> +							  "arm,cp14");
> +	}
> +
> +	drvdata->dev = &pdev->dev;
> +	platform_set_drvdata(pdev, drvdata);
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -ENODEV;
> +
> +	drvdata->base = devm_ioremap(dev, res->start, resource_size(res));

Leak on error paths?

> +	if (!drvdata->base)
> +		return -ENOMEM;
> +
> +	spin_lock_init(&drvdata->spinlock);
> +
> +	if (pdata && pdata->clk) {
> +		drvdata->clk = pdata->clk;
> +		ret = clk_prepare_enable(drvdata->clk);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	drvdata->cpu = pdata ? pdata->cpu : 0;
> +
> +	get_online_cpus();
> +	etmdrvdata[drvdata->cpu] = drvdata;
> +
> +	if (!smp_call_function_single(drvdata->cpu, etm_os_unlock, drvdata, 1))
> +		drvdata->os_unlock = true;
> +
> +	if (smp_call_function_single(drvdata->cpu,
> +				     etm_init_arch_data,  drvdata, 1))
> +		dev_err(dev, "ETM arch init failed\n");
> +
> +	if (!count++)

count is mishandled on the error paths?

> +		register_hotcpu_notifier(&etm_cpu_notifier);

Leak on (some of the) error paths?

> +
> +	put_online_cpus();
> +
> +	if (etm_arch_supported(drvdata->arch) == false) {
> +		clk_disable_unprepare(drvdata->clk);
> +		return -EINVAL;
> +	}
> +	etm_init_default_data(drvdata);
> +
> +	clk_disable_unprepare(drvdata->clk);
> +
> +	desc = devm_kzalloc(dev, sizeof(*desc), GFP_KERNEL);

Leak on error paths?

> +	if (!desc) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +	desc->type = CORESIGHT_DEV_TYPE_SOURCE;
> +	desc->subtype.source_subtype = CORESIGHT_DEV_SUBTYPE_SOURCE_PROC;
> +	desc->ops = &etm_cs_ops;
> +	desc->pdata = pdev->dev.platform_data;
> +	desc->dev = &pdev->dev;
> +	desc->debugfs_ops = etm_attr_grps;
> +	desc->owner = THIS_MODULE;
> +	drvdata->csdev = coresight_register(desc);
> +	if (IS_ERR(drvdata->csdev)) {
> +		ret = PTR_ERR(drvdata->csdev);
> +		goto err;
> +	}
> +
> +	dev_info(dev, "ETM initialized\n");
> +
> +	if (boot_enable) {
> +		coresight_enable(drvdata->csdev);
> +		drvdata->boot_enable = true;
> +	}
> +
> +	return 0;
> +err:
> +	if (drvdata->cpu == 0)
> +		unregister_hotcpu_notifier(&etm_cpu_notifier);
> +	return ret;
> +}
> +
> +static int etm_remove(struct platform_device *pdev)
> +{
> +	struct etm_drvdata *drvdata = platform_get_drvdata(pdev);
> +
> +	coresight_unregister(drvdata->csdev);
> +	if (drvdata->cpu == 0)
> +		unregister_hotcpu_notifier(&etm_cpu_notifier);
> +	return 0;
> +}
> +
> +static struct of_device_id etm_match[] = {
> +	{.compatible = "arm,coresight-etm"},
> +	{}
> +};
> +
> +static struct platform_driver etm_driver = {
> +	.probe          = etm_probe,
> +	.remove         = etm_remove,
> +	.driver         = {
> +		.name   = "coresight-etm",
> +		.owner	= THIS_MODULE,
> +		.of_match_table = etm_match,
> +	},
> +};
> +
> +int __init etm_init(void)
> +{
> +	return platform_driver_register(&etm_driver);
> +}
> +module_init(etm_init);
> +
> +void __exit etm_exit(void)
> +{
> +	platform_driver_unregister(&etm_driver);
> +}
> +module_exit(etm_exit);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("CoreSight Program Flow Trace driver");
> 

