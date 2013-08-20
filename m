Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596Ab3HTAs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 20:48:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:55399 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162Ab3HTAsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 20:48:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,915,1367996400"; 
   d="scan'208";a="348651409"
Date: Tue, 20 Aug 2013 02:48:20 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: wei_wang@realsil.com.cn
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, rogerable@realtek.com
Subject: Re: [PATCH v2 1/5] mfd:rtsx: Read vendor setting from config space
Message-ID: <20130820004820.GA13324@zurbaran>
References: <cover.1373953200.git.wei_wang@realsil.com.cn>
 <8f0f23e3076558f517aea7851500ca5112f9050d.1373953200.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f0f23e3076558f517aea7851500ca5112f9050d.1373953200.git.wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

On Wed, Jul 17, 2013 at 04:09:51PM +0800, wei_wang@realsil.com.cn wrote:
> diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
> index c436bf2..1fbb978 100644
> --- a/drivers/mfd/rtl8411.c
> +++ b/drivers/mfd/rtl8411.c
> @@ -1,6 +1,6 @@
>  /* Driver for Realtek PCI-Express card reader
>   *
> - * Copyright(c) 2009 Realtek Semiconductor Corp. All rights reserved.
> + * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
>   *
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms of the GNU General Public License as published by the
> @@ -17,7 +17,7 @@
>   *
>   * Author:
>   *   Wei WANG <wei_wang@realsil.com.cn>
> - *   No. 450, Shenhu Road, Suzhou Industry Park, Suzhou, China
> + *   Roger Tseng <rogerable@realtek.com>
>   */
Please do not mix actual code with copyright changes. Remove those
chunks from this patch, and submit a separate patch for them.


>  
>  #include <linux/module.h>
> @@ -47,19 +47,70 @@ static int rtl8411b_is_qfn48(struct rtsx_pcr *pcr)
>  		return 0;
>  }
>  
> +static void rtl8411_init_settings(struct rtsx_pcr *pcr)
> +{
> +	u32 reg1;
> +	u8 reg3;
> +
> +	rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG1, &reg1);
> +	dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG1, reg1);
> +
> +	if (rtsx_vendor_setting_valid(reg1)) {
A more readable construct would be:

if (!rtsx_vendor_setting_valid(reg1))
	return;

pcr->aspm_en = rtsx_reg_to_aspm(reg1);
[...]


> @@ -385,6 +438,12 @@ void rtl8411_init_params(struct rtsx_pcr *pcr)
>  	pcr->num_slots = 2;
>  	pcr->ops = &rtl8411_pcr_ops;
>  
> +	pcr->flags = 0;
> +	pcr->card_drive_sel = 0x55;
> +	pcr->sd30_drive_sel_1v8 = 0x03;
> +	pcr->sd30_drive_sel_3v3 = 0x01;
> +	pcr->aspm_en = 0x02;
Those values seem to be repeated for many SKUs, could we please have a
definition instead of hardcoded values ?


> @@ -747,6 +753,7 @@ struct pcr_ops {
>  						u8 voltage);
>  	unsigned int	(*cd_deglitch)(struct rtsx_pcr *pcr);
>  	int		(*conv_clk_and_div_n)(int clk, int dir);
> +	void		(*init_settings)(struct rtsx_pcr *pcr);
init_settings is a bit too generic I believe. What you're doing is
fetching vendor settings, so what about fetch_vendor_settings instead ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
