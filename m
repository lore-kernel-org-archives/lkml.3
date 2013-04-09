Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937224Ab3DIJtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:49:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:4947 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933110Ab3DIJth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:49:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,438,1363158000"; 
   d="scan'208";a="292251593"
Date: Tue, 9 Apr 2013 11:49:11 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: wei_wang@realsil.com.cn
Cc: cjb@laptop.org, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, gregkh@linuxfoundation.org,
        rogerable@realtek.com
Subject: Re: [PATCH] mfd:rtsx: Support RTS5249
Message-ID: <20130409094911.GN24058@zurbaran>
References: <1364177636-4294-1-git-send-email-wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364177636-4294-1-git-send-email-wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

On Mon, Mar 25, 2013 at 10:13:56AM +0800, wei_wang@realsil.com.cn wrote:
> diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
> new file mode 100644
> index 0000000..24a1861
> --- /dev/null
> +++ b/drivers/mfd/rts5249.c
> @@ -0,0 +1,245 @@
> +/* Driver for Realtek PCI-Express card reader
> + *
> + * Copyright(c) 2009 Realtek Semiconductor Corp. All rights reserved.
2009-2013 ?


> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2, or (at your option) any
> + * later version.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + *
> + * Author:
> + *   Wei WANG <wei_wang@realsil.com.cn>
> + *   No. 450, Shenhu Road, Suzhou Industry Park, Suzhou, China
> + */
> +
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/mfd/rtsx_pci.h>
> +
> +#include "rtsx_pcr.h"
> +
> +static u8 rts5249_get_ic_version(struct rtsx_pcr *pcr)
> +{
> +	u8 val;
> +
> +	rtsx_pci_read_register(pcr, DUMMY_REG_RESET_0, &val);
> +	return val & 0x0F;
> +}
> +
> +static int rts5249_extra_init_hw(struct rtsx_pcr *pcr)
> +{
> +	rtsx_pci_init_cmd(pcr);
> +
> +	/* Configure GPIO as output */
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, GPIO_CTL, 0x02, 0x02);
> +	/* Switch LDO3318 source from DV33 to card_3v3 */
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, LDO_PWR_SEL, 0x03, 0x00);
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, LDO_PWR_SEL, 0x03, 0x01);
> +	/* LED shine disabled, set initial shine cycle period */
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, OLT_LED_CTL, 0x0F, 0x02);
> +	/* Configure force_clock_req
> +	 * Maybe We should define 0xFF03 as some name
> +	 */
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, 0xFF03, 0x08, 0x08);
> +	/* Correct driving */
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
> +			SD30_CLK_DRIVE_SEL, 0xFF, 0x99);
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
> +			SD30_CMD_DRIVE_SEL, 0xFF, 0x99);
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
> +			SD30_DAT_DRIVE_SEL, 0xFF, 0x92);
> +
> +	return rtsx_pci_send_cmd(pcr, 100);
> +}
> +
> +static int rts5249_optimize_phy(struct rtsx_pcr *pcr)
> +{
> +	int err;
> +
> +	err = rtsx_pci_write_phy_register(pcr, 0x19, 0xFE46);
There are a _lot_ of magic values in those drivers. Could we at least define
register names in the header files ?


> +	if (err < 0)
> +		return err;
> +
> +	mdelay(1);
I second Dan here: Why do you need to busy loop ? I understand delays may be
needed, but why wouldn't an msleep be sufficient ? AFAICT, you're calling this
one from the PCI probe routine, where you could sleep.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
