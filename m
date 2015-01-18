Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbbARLNu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 06:13:50 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:43034 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbbARLNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 06:13:46 -0500
Date: Sun, 18 Jan 2015 11:13:39 +0000
From: Lee Jones <lee.jones@linaro.org>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rogerable@realtek.com, wei_wang@realsil.com.cn
Subject: Re: [PATCH 09/10] mfd: rtsx: add support for rts525A
Message-ID: <20150118111339.GJ3574@x1>
References: <cover.1421320541.git.micky_ching@realsil.com.cn>
 <06f009ff0bdcb1183412cb0172dc687f0b173747.1421320541.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <06f009ff0bdcb1183412cb0172dc687f0b173747.1421320541.git.micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015, micky_ching@realsil.com.cn wrote:

> From: Micky Ching <micky_ching@realsil.com.cn>
> 
> add support for new chip rts525A.
> 
> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> ---
>  drivers/mfd/rts5249.c  | 93 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/mfd/rtsx_pcr.c | 13 +++++--
>  drivers/mfd/rtsx_pcr.h |  1 +
>  3 files changed, 103 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
> index 1ce03a6..46b6522 100644
> --- a/drivers/mfd/rts5249.c
> +++ b/drivers/mfd/rts5249.c
> @@ -97,7 +97,7 @@ static void rts5249_force_power_down(struct rtsx_pcr *pcr, u8 pm_state)
>  	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 3, 0x01, 0);
>  
>  	if (pm_state == HOST_ENTER_S3) {
> -		if (PCI_PID(pcr) == 0x524A)
> +		if (PCI_PID(pcr) == 0x524A || PCI_PID(pcr) == 0x525A)

Shouldn't these be defined somewhere?

I have a particular distaste for magic numbers.

>  			rtsx_pci_write_register(pcr, RTS524A_PM_CTRL3,
>  				D3_DELINK_MODE_EN, D3_DELINK_MODE_EN);
>  		else if (PCI_PID(pcr) == 0x5249)
> @@ -430,3 +430,94 @@ void rts524a_init_params(struct rtsx_pcr *pcr)
>  	pcr->ops = &rts524a_pcr_ops;
>  }
>  
> +static int rts525a_card_power_on(struct rtsx_pcr *pcr, int card)
> +{
> +	rtsx_pci_write_register(pcr, LDO_VCC_CFG1,
> +		LDO_VCC_TUNE_MASK, LDO_VCC_3V3);
> +	return rts5249_card_power_on(pcr, card);
> +}

Small formatting nit: I'd prefer if you'd line up the wrap to the '('
and leave a '\n' before the return line.

> +static int rts525a_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
> +{
> +	if (voltage == OUTPUT_3V3) {
> +		rtsx_pci_write_register(pcr, LDO_CONFIG2,
> +			LDO_D3318_MASK, LDO_D3318_33V);
> +		rtsx_pci_write_register(pcr, SD_PAD_CTL, SD_IO_USING_1V8, 0);
> +	} else if (voltage == OUTPUT_1V8) {
> +		rtsx_pci_write_register(pcr, LDO_CONFIG2,
> +			LDO_D3318_MASK, LDO_D3318_18V);
> +		rtsx_pci_write_register(pcr, SD_PAD_CTL, SD_IO_USING_1V8,
> +			SD_IO_USING_1V8);
> +	} else {
> +		return -EINVAL;
> +	}

This might look nicer as a switch().

> +	rtsx_pci_init_cmd(pcr);
> +	rts5249_fill_driving(pcr, voltage);
> +	return rtsx_pci_send_cmd(pcr, 100);
> +}
> +
> +static int rts525a_optimize_phy(struct rtsx_pcr *pcr)
> +{
> +	int err;
> +
> +	err = rtsx_pci_write_register(pcr, RTS524A_PM_CTRL3,
> +		D3_DELINK_MODE_EN, 0x00);
> +	if (err < 0)
> +		return err;

rtsx_pci_write_register() can't return >0, so just check for (err).

> +	rtsx_pci_write_phy_register(pcr, 0x1D, 0x99FF);
> +	rtsx_pci_write_phy_register(pcr, 0x03, 0x2748);

More magic numbers that I have absolutely no idea what the mean.

Please define them (includes the one below).

> +	if (is_version(pcr, 0x525A, IC_VER_A))
> +		rtsx_pci_write_phy_register(pcr, 0x19, 0x3902);
> +
> +	return 0;
> +}
> +
> +static int rts525a_extra_init_hw(struct rtsx_pcr *pcr)
> +{
> +	rts5249_extra_init_hw(pcr);
> +
> +	rtsx_pci_write_register(pcr, PCLK_CTL, PCLK_MODE_SEL, PCLK_MODE_SEL);
> +	if (is_version(pcr, 0x525A, IC_VER_A)) {
> +		rtsx_pci_write_register(pcr, L1SUB_CONFIG2,
> +			L1SUB_AUTO_CFG, L1SUB_AUTO_CFG);
> +		rtsx_pci_write_register(pcr, RREF_CFG,
> +			RREF_VBGSEL_MASK, RREF_VBGSEL_1V25);
> +		rtsx_pci_write_register(pcr, LDO_VIO_CFG,
> +			LDO_VIO_TUNE_MASK, LDO_VIO_1V7);
> +		rtsx_pci_write_register(pcr, LDO_DV12S_CFG,
> +			LDO_D12_TUNE_MASK, LDO_D12_TUNE_DF);
> +		rtsx_pci_write_register(pcr, LDO_AV12S_CFG,
> +			LDO_AV12S_TUNE_MASK, LDO_AV12S_TUNE_DF);
> +		rtsx_pci_write_register(pcr, LDO_VCC_CFG0,
> +			LDO_VCC_LMTVTH_MASK, LDO_VCC_LMTVTH_2A);
> +		rtsx_pci_write_register(pcr, OOBS_CONFIG,
> +			OOBS_AUTOK_DIS | OOBS_VAL_MASK, 0x89);
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct pcr_ops rts525a_pcr_ops = {
> +	.fetch_vendor_settings = rts5249_fetch_vendor_settings,
> +	.extra_init_hw = rts525a_extra_init_hw,
> +	.optimize_phy = rts525a_optimize_phy,
> +	.turn_on_led = rts5249_turn_on_led,
> +	.turn_off_led = rts5249_turn_off_led,
> +	.enable_auto_blink = rts5249_enable_auto_blink,
> +	.disable_auto_blink = rts5249_disable_auto_blink,
> +	.card_power_on = rts525a_card_power_on,
> +	.card_power_off = rts5249_card_power_off,
> +	.switch_output_voltage = rts525a_switch_output_voltage,
> +	.force_power_down = rts5249_force_power_down,
> +};
> +
> +void rts525a_init_params(struct rtsx_pcr *pcr)
> +{
> +	rts5249_init_params(pcr);
> +
> +	pcr->ops = &rts525a_pcr_ops;
> +}
> +
> diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
> index 17334ba..33aa30b 100644
> --- a/drivers/mfd/rtsx_pcr.c
> +++ b/drivers/mfd/rtsx_pcr.c
> @@ -59,6 +59,7 @@ static const struct pci_device_id rtsx_pci_ids[] = {
>  	{ PCI_DEVICE(0x10EC, 0x5287), PCI_CLASS_OTHERS << 16, 0xFF0000 },
>  	{ PCI_DEVICE(0x10EC, 0x5286), PCI_CLASS_OTHERS << 16, 0xFF0000 },
>  	{ PCI_DEVICE(0x10EC, 0x524A), PCI_CLASS_OTHERS << 16, 0xFF0000 },
> +	{ PCI_DEVICE(0x10EC, 0x525A), PCI_CLASS_OTHERS << 16, 0xFF0000 },
>  	{ 0, }
>  };
>  
> @@ -1113,6 +1114,10 @@ static int rtsx_pci_init_chip(struct rtsx_pcr *pcr)
>  		rts524a_init_params(pcr);
>  		break;
>  
> +	case 0x525A:
> +		rts525a_init_params(pcr);
> +		break;
> +
>  	case 0x5287:
>  		rtl8411b_init_params(pcr);
>  		break;
> @@ -1158,7 +1163,7 @@ static int rtsx_pci_probe(struct pci_dev *pcidev,
>  	struct rtsx_pcr *pcr;
>  	struct pcr_handle *handle;
>  	u32 base, len;
> -	int ret, i;
> +	int ret, i, bar = 0;
>  
>  	dev_dbg(&(pcidev->dev),
>  		": Realtek PCI-E Card Reader found at %s [%04x:%04x] (rev %x)\n",
> @@ -1203,8 +1208,10 @@ static int rtsx_pci_probe(struct pci_dev *pcidev,
>  	pcr->pci = pcidev;
>  	dev_set_drvdata(&pcidev->dev, handle);
>  
> -	len = pci_resource_len(pcidev, 0);
> -	base = pci_resource_start(pcidev, 0);
> +	if (PCI_PID(pcr) == 0x525A)
> +		bar = 1;
> +	len = pci_resource_len(pcidev, bar);
> +	base = pci_resource_start(pcidev, bar);
>  	pcr->remap_addr = ioremap_nocache(base, len);
>  	if (!pcr->remap_addr) {
>  		ret = -ENOMEM;
> diff --git a/drivers/mfd/rtsx_pcr.h b/drivers/mfd/rtsx_pcr.h
> index 0535265..4c00544 100644
> --- a/drivers/mfd/rtsx_pcr.h
> +++ b/drivers/mfd/rtsx_pcr.h
> @@ -37,6 +37,7 @@ void rtl8402_init_params(struct rtsx_pcr *pcr);
>  void rts5227_init_params(struct rtsx_pcr *pcr);
>  void rts5249_init_params(struct rtsx_pcr *pcr);
>  void rts524a_init_params(struct rtsx_pcr *pcr);
> +void rts525a_init_params(struct rtsx_pcr *pcr);
>  void rtl8411b_init_params(struct rtsx_pcr *pcr);
>  
>  static inline u8 map_sd_drive(int idx)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
