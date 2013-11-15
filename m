Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab3KOO7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 09:59:06 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:34041 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab3KOO6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 09:58:48 -0500
Date: Fri, 15 Nov 2013 14:58:40 +0000
From: Lee Jones <lee.jones@linaro.org>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        wei_wang@realsil.com.cn, rogerable@realtek.com
Subject: Re: [PATCH 1/3] mfd: rtsx: reduce code duplication in rtl8411
Message-ID: <20131115145840.GC4996@lee--X1>
References: <cover.1384503048.git.micky_ching@realsil.com.cn>
 <8ce8175c28355c0d69c3ac4825d3dce6c00fc2ba.1384503048.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8ce8175c28355c0d69c3ac4825d3dce6c00fc2ba.1384503048.git.micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Lee Jones <lee.jones@linaro.org>
> 
> in order to remove duplicated code in rtl8411, we make 8411 as the base
> init params, and other like-8411 chips will just change the different
> value with 8411, this can save some source code.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>

It's not good etiquette to send patches 'From:' and 'Signed-off-by:' a
person when they are neither from or signed-off by that person.

It's much better practice to reply to the original patches with
comments placed directly under the code you wish to reference.

<snip>

> -void rtl8411b_init_params(struct rtsx_pcr *pcr)
> +void rtl8411_init_params(struct rtsx_pcr *pcr)
>  {
> -	pcr->extra_caps = EXTRA_CAPS_SD_SDR50 | EXTRA_CAPS_SD_SDR104;
> -	pcr->num_slots = 2;
> -	pcr->ops = &rtl8411b_pcr_ops;
> -
> -	pcr->flags = 0;
> -	pcr->card_drive_sel = RTL8411_CARD_DRIVE_DEFAULT;
> -	pcr->sd30_drive_sel_1v8 = DRIVER_TYPE_B;
> -	pcr->sd30_drive_sel_3v3 = DRIVER_TYPE_D;
> -	pcr->aspm_en = ASPM_L1_EN;

> -	pcr->tx_initial_phase = SET_CLOCK_PHASE(23, 7, 14);
> -	pcr->rx_initial_phase = SET_CLOCK_PHASE(4, 3, 10);

So what happened to these?

> -	pcr->ic_version = rtl8411_get_ic_version(pcr);
> +	/* rtl8411 params */
> +	rtl8411_init_base_params(pcr);
> +	set_pull_ctrl_tables(rtl8411);
> +
> +	/* different with rtl8411 */
> +	switch (PCI_PID(pcr)) {
> +	case 0x5287:
> +		rtl8411_pcr_ops.fetch_vendor_settings =
> +			rtl8411b_fetch_vendor_settings;
> +		rtl8411_pcr_ops.extra_init_hw = rtl8411b_extra_init_hw;
> +
> +		if (rtl8411b_is_qfn48(pcr))
> +			set_pull_ctrl_tables(rtl8411b_qfn48);
> +		else
> +			set_pull_ctrl_tables(rtl8411b_qfn64);

I'm not a big fan of this.

<snip>

> diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
> index 11e20af..ecc6852 100644
> --- a/drivers/mfd/rtsx_pcr.c
> +++ b/drivers/mfd/rtsx_pcr.c
> @@ -1046,10 +1046,6 @@ static int rtsx_pci_init_chip(struct rtsx_pcr *pcr)
>  		rts5229_init_params(pcr);
>  		break;
>  
> -	case 0x5289:
> -		rtl8411_init_params(pcr);
> -		break;
> -
>  	case 0x5227:
>  		rts5227_init_params(pcr);
>  		break;
> @@ -1059,7 +1055,8 @@ static int rtsx_pci_init_chip(struct rtsx_pcr *pcr)
>  		break;
>  
>  	case 0x5287:
> -		rtl8411b_init_params(pcr);
> +	case 0x5289:
> +		rtl8411_init_params(pcr);
>  		break;
>  	}

I see where you're going with this, but my personal opinion is that it
looks neater and more readable set out as two separate init functions.

> diff --git a/drivers/mfd/rtsx_pcr.h b/drivers/mfd/rtsx_pcr.h
> index 947e79b..dd435d7 100644
> --- a/drivers/mfd/rtsx_pcr.h
> +++ b/drivers/mfd/rtsx_pcr.h
> @@ -32,7 +32,6 @@ void rts5229_init_params(struct rtsx_pcr *pcr);
>  void rtl8411_init_params(struct rtsx_pcr *pcr);
>  void rts5227_init_params(struct rtsx_pcr *pcr);
>  void rts5249_init_params(struct rtsx_pcr *pcr);
> -void rtl8411b_init_params(struct rtsx_pcr *pcr);
>  
>  static inline u8 map_sd_drive(int idx)
>  {
> @@ -63,4 +62,12 @@ static inline u8 map_sd_drive(int idx)
>  #define rtl8411_reg_to_sd30_drive_sel_3v3(reg)	(((reg) >> 5) & 0x07)
>  #define rtl8411b_reg_to_sd30_drive_sel_3v3(reg)	((reg) & 0x03)
>  
> +#define set_pull_ctrl_tables(__device)				\
> +do {								\
> +	pcr->sd_pull_ctl_enable_tbl  = __device##_sd_pull_ctl_enable_tbl;  \
> +	pcr->sd_pull_ctl_disable_tbl = __device##_sd_pull_ctl_disable_tbl; \
> +	pcr->ms_pull_ctl_enable_tbl  = __device##_ms_pull_ctl_enable_tbl;  \
> +	pcr->ms_pull_ctl_disable_tbl = __device##_ms_pull_ctl_disable_tbl; \
> +} while (0)

Great spot Micky. I'll fix this up and resend.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
