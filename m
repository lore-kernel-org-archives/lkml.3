Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab3AWJAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:00:41 -0500
Received: from co202.xi-lite.net ([149.6.83.202]:40483 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454Ab3AWJAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:00:39 -0500
Message-ID: <50FFA692.2060907@parrot.com>
Date: Wed, 23 Jan 2013 10:00:02 +0100
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "vt8500-wm8505-linux-kernel@googlegroups.com" 
	<vt8500-wm8505-linux-kernel@googlegroups.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/2] mtd: Add a common JEDEC flash device table
References: <1358928068-12417-1-git-send-email-linux@prisktech.co.nz> <1358928068-12417-2-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1358928068-12417-2-git-send-email-linux@prisktech.co.nz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Prisk a écrit :
> This patch adds a common JEDEC flash device table which can be
> expanded on as more features are required.
> 
> A simple match function is also included to query the table for
> a match based on the JEDEC id.

Why don't you use id from include/linux/mtd/cfi.h that is used by flash driver
like drivers/mtd/devices/m25p80.c ?


#define CFI_MFR_AMD     0x0001
#define CFI_MFR_AMIC        0x0037
#define CFI_MFR_ATMEL       0x001F
#define CFI_MFR_EON     0x001C
#define CFI_MFR_FUJITSU     0x0004
#define CFI_MFR_HYUNDAI     0x00AD
#define CFI_MFR_INTEL       0x0089
#define CFI_MFR_MACRONIX    0x00C2
#define CFI_MFR_NEC     0x0010
#define CFI_MFR_PMC     0x009D
#define CFI_MFR_SAMSUNG     0x00EC
#define CFI_MFR_SHARP       0x00B0
#define CFI_MFR_SST     0x00BF
#define CFI_MFR_ST      0x0020 /* STMicroelectronics */
#define CFI_MFR_TOSHIBA     0x0098
#define CFI_MFR_WINBOND     0x00DA


> 
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---
>  drivers/mtd/devices/flash_jedec.c |   96 +++++++++++++++++++++++++++++++++++++
>  drivers/mtd/devices/flash_jedec.h |   30 ++++++++++++
>  2 files changed, 126 insertions(+)
>  create mode 100644 drivers/mtd/devices/flash_jedec.c
>  create mode 100644 drivers/mtd/devices/flash_jedec.h
> 
> diff --git a/drivers/mtd/devices/flash_jedec.c b/drivers/mtd/devices/flash_jedec.c
> new file mode 100644
> index 0000000..c0b2272
> --- /dev/null
> +++ b/drivers/mtd/devices/flash_jedec.c
> @@ -0,0 +1,96 @@
> +/*
> + * Copyright Tony Prisk <linux@prisktech.co.nz>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + */
> +
> +#include <linux/bug.h>
> +#include <linux/err.h>
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +
> +#include "flash_jedec.h"
> +
> +/*
> + * Device Manufacturer IDs
> + * Please keep sorted by manufacturer ID
> + */
> +#define MFR_SPANSION		0X01
> +#define MFR_EON			0X1C
> +#define MFR_ATMEL		0X1F
> +#define MFR_MICRON		0X20	/* Also Numonyx & STM */
> +#define MFR_INTEL		0x89
> +#define MFR_FUDAN		0XA1
> +#define MFR_SST			0XBF
> +#define MFR_MXIC		0XC2
> +#define MFR_WINBOND		0XEF
> +
> +#define _ID(m, d)	((m << 16) | d)
> +
> +/*
> + * Flash device information
> + * Please keep sorted by manufacturer id, then device id
> + */
> +static struct flash_device_info flash_devices[] = {
> +	/* Spansion */
> +	{ "s25fl016", _ID(MFR_SPANSION, 0x0214), 2048 },
> +	{ "s25fl064", _ID(MFR_SPANSION, 0x0216), 8192 },
> +	/* EON */
> +	{ "en25p16", _ID(MFR_EON, 0x2015), 2048 },
> +	{ "en25p64", _ID(MFR_EON, 0x2017), 8192 },
> +	{ "en25f40", _ID(MFR_EON, 0x3113),  512 },
> +	{ "en25f16", _ID(MFR_EON, 0x3115), 2048 },
> +	/* ATMEL */
> +	{ "at25df041a", _ID(MFR_ATMEL, 0x4401), 512 },
> +	/* Micron, STM & Numonyx */
> +	{ "stm25p16", _ID(MFR_MICRON, 0x2015), 2048 },
> +	{ "stm25p64", _ID(MFR_MICRON, 0x2017), 8192 },
> +	/* Fudan */
> +	{ "fm25f04", _ID(MFR_FUDAN, 0x3113), 512 },
> +	/* SST */
> +	{ "sst25vf016b", _ID(MFR_SST, 0x2541), 2048 },
> +	/* Macronix - MXIC */
> +	{ "mx25l512",   _ID(MFR_MXIC, 0x2010),    64 },
> +	{ "mx25l4005",  _ID(MFR_MXIC, 0x2013),   512 },
> +	{ "mx25l1605",  _ID(MFR_MXIC, 0x2015),  2048 },
> +	{ "mx25l3205",  _ID(MFR_MXIC, 0x2016),  4096 },
> +	{ "mx25l6405",  _ID(MFR_MXIC, 0x2017),  8192 },
> +	{ "mx25l12805", _ID(MFR_MXIC, 0x2018), 16384 },
> +	{ "mx25l1635",  _ID(MFR_MXIC, 0x2415),  2048 },
> +	{ "mx25l3235",  _ID(MFR_MXIC, 0x5E16),  4096 },
> +	/* Winbond */
> +	{ "w25x40", _ID(MFR_WINBOND, 0x3013),   512 },
> +	{ "w25x16", _ID(MFR_WINBOND, 0x3015),  2048 },
> +	{ "w25x32", _ID(MFR_WINBOND, 0x3016),  4096 },
> +	{ "w25x64", _ID(MFR_WINBOND, 0x3017),  8192 },
> +};
> +
> +/*
> + * jedec_match_device - match a jedec id against the flash_devices table
> + * @jedecid: JEDEC formatted id to match
> + *	bits 16..24: manufacturer id
> + *	bits  0..15: device id
> + * Returns a valid flash_device_info* or ERR_PTR(-ENODEV) if an entry is
> + * not found
> + */
> +struct flash_device_info *jedec_match_device(u32 jedec_id)
> +{
> +	int i;
> +	for (i = 0; i < ARRAY_SIZE(flash_devices); i++)
> +		if (flash_devices[i].jedec_id == jedec_id)
> +			return &flash_devices[i];
> +
> +	return ERR_PTR(-ENODEV);
> +}
> diff --git a/drivers/mtd/devices/flash_jedec.h b/drivers/mtd/devices/flash_jedec.h
> new file mode 100644
> index 0000000..27b978a
> --- /dev/null
> +++ b/drivers/mtd/devices/flash_jedec.h
> @@ -0,0 +1,30 @@
> +/*
> + * Copyright Tony Prisk <linux@prisktech.co.nz>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + */
> +
> +#ifndef __MTD_FLASH_JEDEC
> +#define __MTD_FLASH_JEDEC
> +
> +struct flash_device_info {
> +	const char	*name;
> +	u32		jedec_id;
> +	u32		size_kb;
> +};
> +
> +extern struct flash_device_info *jedec_match_device(u32 jedec_id);
> +
> +#endif


-- 
Matthieu Castet
Ingénieur Développement Logiciel
Parrot SA
174 Quai de Jemmapes
75010 Paris, France

Tél: +33 (0) 1 48 03 74 78
Fax: +33 (0) 1 48 03 06 66
Email: matthieu.castet@parrot.fr
http://www.parrot.biz
