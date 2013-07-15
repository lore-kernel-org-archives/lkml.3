Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab3GOOVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:21:13 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21327 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287Ab3GOOVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:21:12 -0400
Date: Mon, 15 Jul 2013 17:20:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: wei_wang@realsil.com.cn
Cc: sameo@linux.intel.com, gregkh@linuxfoundation.org, adam.lee@canonical.com,
        linux-kernel@vger.kernel.org, rogerable@realtek.com,
        devel@linuxdriverproject.org
Subject: Re: [PATCH 1/5] mfd:rtsx: Read vendor setting from config space
Message-ID: <20130715142046.GD5100@mwanda>
References: <cover.1373871135.git.wei_wang@realsil.com.cn>
 <d0a47d6128605ecd9888657ce36b81ad51116876.1373871136.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0a47d6128605ecd9888657ce36b81ad51116876.1373871136.git.wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code has a lot of undocumented magic flags and terrible naming
in it.

> +static void rtl8411_init_settings(struct rtsx_pcr *pcr)
> +{
> +	u32 val1;
> +	u8 val2;

These names are 100% useless.  "val" means nothing.  "1" means
nothing.  "2" means nothing.  In fact, val1 is REG1 and val2 is
REG3 as opposed to REG2 as one would expect from the name so it is
misleading.

> +
> +	rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG1, &val1);
> +	dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG1, val1);
> +
> +	if (!(val1 & 0x1000000)) {

What is 0x1000000?  We do this test over and over so it should be
an inline function.

> +		pcr->aspm_val = (u8)((val1 >> 28) & 0x03);

The "_val" in "apsm_val" is useless.
What does "aspm" stand for?
No need to cast.  0-3 is less than 255 so casting to u8 is just
noise.
These shift masks are used over and over so they should be defined
as macros or inline functions in a header file:

#define rtl8411_reg_to_XXX(reg)		((reg >> 25) & 0x01)
#define rtl8411_reg_to_sdXXX(reg)	((reg >> 26) & 0x03)
#define rtl8411_reg_to_aspm(reg)	((reg >> 28) & 0x03)

(Choose your own names which make sense).

> +		pcr->sd30_drive_sel_1v8 = map_sd_drive((val1 >> 26) & 0x03);
> +		pcr->card_drive_sel &= 0x3F;
> +		pcr->card_drive_sel |= (u8)((val1 >> 25) & 0x01) << 6;

Again, no need to cast.  This should be a macro or an inline
function.

Pretty much the same comments apply throughout.  I'm not going to
comment on it line by line.

regards,
dan carpenter

