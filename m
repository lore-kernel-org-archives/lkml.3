Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbbARMVH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 07:21:07 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:40021 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbbARMVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 07:21:01 -0500
Date: Sun, 18 Jan 2015 12:20:55 +0000
From: Lee Jones <lee.jones@linaro.org>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rogerable@realtek.com, wei_wang@realsil.com.cn
Subject: Re: [PATCH 08/10] mfd: rtsx: add support for rts524A
Message-ID: <20150118122055.GK3574@x1>
References: <cover.1421320541.git.micky_ching@realsil.com.cn>
 <007fcaa1986088c968cd4d1627c294a55df73e9f.1421320541.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <007fcaa1986088c968cd4d1627c294a55df73e9f.1421320541.git.micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015, micky_ching@realsil.com.cn wrote:

> From: Micky Ching <micky_ching@realsil.com.cn>
> 
> add support for new chip rts524A.
> 
> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> ---
>  drivers/mfd/rts5249.c        | 112 +++++++++++++++++++++++++++++++++++++++----
>  drivers/mfd/rtsx_pcr.c       |   5 ++
>  drivers/mfd/rtsx_pcr.h       |   4 ++
>  include/linux/mfd/rtsx_pci.h |  87 ++++++++++++++++++++++++++++++++-
>  4 files changed, 198 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
> index 5eb9819..1ce03a6 100644
> --- a/drivers/mfd/rts5249.c
> +++ b/drivers/mfd/rts5249.c
> @@ -72,8 +72,10 @@ static void rts5249_fetch_vendor_settings(struct rtsx_pcr *pcr)
>  	rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG1, &reg);
>  	dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG1, reg);
>  
> -	if (!rtsx_vendor_setting_valid(reg))
> +	if (!rtsx_vendor_setting_valid(reg)) {
> +		pcr_dbg(pcr, "skip fetch vendor setting\n");
>  		return;
> +	}

This doesn't have anything to do with adding the new chip.

And I'm not sure it's even required.

>  	pcr->aspm_en = rtsx_reg_to_aspm(reg);
>  	pcr->sd30_drive_sel_1v8 = rtsx_reg_to_sd30_drive_sel_1v8(reg);
> @@ -94,8 +96,14 @@ static void rts5249_force_power_down(struct rtsx_pcr *pcr, u8 pm_state)
>  	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 2, 0xFF, 0);
>  	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 3, 0x01, 0);
>  
> -	if (pm_state == HOST_ENTER_S3)
> -		rtsx_pci_write_register(pcr, PM_CTRL3, 0x10, 0x10);
> +	if (pm_state == HOST_ENTER_S3) {
> +		if (PCI_PID(pcr) == 0x524A)
> +			rtsx_pci_write_register(pcr, RTS524A_PM_CTRL3,
> +				D3_DELINK_MODE_EN, D3_DELINK_MODE_EN);
> +		else if (PCI_PID(pcr) == 0x5249)
> +			rtsx_pci_write_register(pcr, PM_CTRL3,
> +				D3_DELINK_MODE_EN, D3_DELINK_MODE_EN);
> +	}
>  
>  	rtsx_pci_write_register(pcr, FPDCTL, 0x03, 0x03);
>  }
> @@ -104,6 +112,8 @@ static int rts5249_extra_init_hw(struct rtsx_pcr *pcr)
>  {
>  	rtsx_pci_init_cmd(pcr);
>  
> +	/* Rest L1SUB Config */
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, L1SUB_CONFIG3, 0xFF, 0x00);
>  	/* Configure GPIO as output */
>  	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, GPIO_CTL, 0x02, 0x02);
>  	/* Reset ASPM state to default value */
> @@ -228,14 +238,20 @@ static int rts5249_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
>  	int err;

This function name is now misleading.

Please change it, or at least add a comment saying that it doesn't
only support the 5249.

>  	if (voltage == OUTPUT_3V3) {
> -		err = rtsx_pci_write_phy_register(pcr, PHY_TUNE, 0x4FC0 | 0x24);
> +		err = rtsx_pci_update_phy(pcr, PHY_TUNE, 0xFC3F, 0x03C0);
>  		if (err < 0)
>  			return err;
>  	} else if (voltage == OUTPUT_1V8) {
> -		err = rtsx_pci_write_phy_register(pcr, PHY_BACR, 0x3C02);
> -		if (err < 0)
> -			return err;
> -		err = rtsx_pci_write_phy_register(pcr, PHY_TUNE, 0x4C40 | 0x24);
> +		u16 append = 0x0100;
> +
> +		if (PCI_PID(pcr) == 0x5249) {
> +			err = rtsx_pci_update_phy(pcr, PHY_BACR, 0xFFF3, 0);
> +			if (err < 0)
> +				return err;
> +			append = 0x0080;
> +		}
> +
> +		err = rtsx_pci_update_phy(pcr, PHY_TUNE, 0xFC3F, append);
>  		if (err < 0)
>  			return err;
>  	} else {
> @@ -334,3 +350,83 @@ void rts5249_init_params(struct rtsx_pcr *pcr)
>  	pcr->ms_pull_ctl_enable_tbl = rts5249_ms_pull_ctl_enable_tbl;
>  	pcr->ms_pull_ctl_disable_tbl = rts5249_ms_pull_ctl_disable_tbl;
>  }
> +
> +static inline int rts524a_write_phy(struct rtsx_pcr *pcr, u8 addr, u16 val)
> +{
> +	addr = addr & 0x80 ? (addr & 0x7F) | 0x40 : addr;
> +	return rtsx_pci_write_phy_register(pcr, addr, val);
> +}
> +
> +static int rts524a_optimize_phy(struct rtsx_pcr *pcr)
> +{
> +	int err;
> +
> +	err = rtsx_pci_write_register(pcr, RTS524A_PM_CTRL3,
> +		D3_DELINK_MODE_EN, 0x00);
> +	if (err < 0)
> +		return err;

if (err)

> +	rts524a_write_phy(pcr, 0x00, 0xBA42);
> +	rts524a_write_phy(pcr, 0x03, 0x2748);
> +
> +	if (is_version(pcr, 0x524A, IC_VER_A)) {
> +		rts524a_write_phy(pcr, 0x03, 0x2748);
> +		rts524a_write_phy(pcr, 0x02, 0x0A1F);
> +		rts524a_write_phy(pcr, 0x1A, 0x2546);
> +		rts524a_write_phy(pcr, 0x1D, 0x0004);
> +		rts524a_write_phy(pcr, 0x1E, 0x5C7F);

I have no idea what this is doing!

Please humanise this nonsense.

> +	}
> +
> +	rts524a_write_phy(pcr, 0x08, 0x57E4);
> +
> +	return 0;
> +}
> +
> +static int rts524a_extra_init_hw(struct rtsx_pcr *pcr)
> +{
> +	rts5249_extra_init_hw(pcr);
> +
> +	rtsx_pci_write_register(pcr, FUNC_FORCE_CTL, 0x02, 0x02);

?

> +	rtsx_pci_write_register(pcr, PM_EVENT_DEBUG, PME_DEBUG_0, PME_DEBUG_0);
> +	rtsx_pci_write_register(pcr, LDO_VCC_CFG1, LDO_VCC_LMT_EN,
> +		LDO_VCC_LMT_EN);
> +	rtsx_pci_write_register(pcr, PCLK_CTL, PCLK_MODE_SEL, PCLK_MODE_SEL);
> +	if (is_version(pcr, 0x524A, IC_VER_A)) {
> +		rtsx_pci_write_register(pcr, LDO_DV18_CFG,
> +			LDO_DV18_SR_MASK, LDO_DV18_SR_DF);
> +		rtsx_pci_write_register(pcr, LDO_VCC_CFG1,
> +			LDO_VCC_REF_TUNE_MASK, LDO_VCC_REF_1V2);
> +		rtsx_pci_write_register(pcr, LDO_VIO_CFG,
> +			LDO_VIO_REF_TUNE_MASK, LDO_VIO_REF_1V2);
> +		rtsx_pci_write_register(pcr, LDO_VIO_CFG,
> +			LDO_VIO_SR_MASK, LDO_VIO_SR_DF);
> +		rtsx_pci_write_register(pcr, LDO_DV12S_CFG,
> +			LDO_REF12_TUNE_MASK, LDO_REF12_TUNE_DF);
> +		rtsx_pci_write_register(pcr, SD40_LDO_CTL1,
> +			SD40_VIO_TUNE_MASK, SD40_VIO_TUNE_1V7);
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct pcr_ops rts524a_pcr_ops = {
> +	.fetch_vendor_settings = rts5249_fetch_vendor_settings,
> +	.extra_init_hw = rts524a_extra_init_hw,
> +	.optimize_phy = rts524a_optimize_phy,
> +	.turn_on_led = rts5249_turn_on_led,
> +	.turn_off_led = rts5249_turn_off_led,
> +	.enable_auto_blink = rts5249_enable_auto_blink,
> +	.disable_auto_blink = rts5249_disable_auto_blink,
> +	.card_power_on = rts5249_card_power_on,
> +	.card_power_off = rts5249_card_power_off,
> +	.switch_output_voltage = rts5249_switch_output_voltage,
> +	.force_power_down = rts5249_force_power_down,

You might need to change the name of some of these functions (or at
least add comments) if you plan on using them for multiple devices.

> +};
> +
> +void rts524a_init_params(struct rtsx_pcr *pcr)
> +{
> +	rts5249_init_params(pcr);
> +
> +	pcr->ops = &rts524a_pcr_ops;
> +}

I see a couple of these now.  Why don't you make 'ops' a parameter of
*_init_params().

> diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
> index 3065edc..17334ba 100644
> --- a/drivers/mfd/rtsx_pcr.c
> +++ b/drivers/mfd/rtsx_pcr.c
> @@ -58,6 +58,7 @@ static const struct pci_device_id rtsx_pci_ids[] = {
>  	{ PCI_DEVICE(0x10EC, 0x5249), PCI_CLASS_OTHERS << 16, 0xFF0000 },
>  	{ PCI_DEVICE(0x10EC, 0x5287), PCI_CLASS_OTHERS << 16, 0xFF0000 },
>  	{ PCI_DEVICE(0x10EC, 0x5286), PCI_CLASS_OTHERS << 16, 0xFF0000 },
> +	{ PCI_DEVICE(0x10EC, 0x524A), PCI_CLASS_OTHERS << 16, 0xFF0000 },
>  	{ 0, }
>  };
>  
> @@ -1108,6 +1109,10 @@ static int rtsx_pci_init_chip(struct rtsx_pcr *pcr)
>  		rts5249_init_params(pcr);
>  		break;
>  
> +	case 0x524A:
> +		rts524a_init_params(pcr);
> +		break;
> +
>  	case 0x5287:
>  		rtl8411b_init_params(pcr);
>  		break;
> diff --git a/drivers/mfd/rtsx_pcr.h b/drivers/mfd/rtsx_pcr.h
> index fe2bbb6..0535265 100644
> --- a/drivers/mfd/rtsx_pcr.h
> +++ b/drivers/mfd/rtsx_pcr.h
> @@ -27,12 +27,16 @@
>  #define MIN_DIV_N_PCR		80
>  #define MAX_DIV_N_PCR		208
>  
> +#define RTS524A_PME_FORCE_CTL		0xFF78
> +#define RTS524A_PM_CTRL3		0xFF7E
> +
>  void rts5209_init_params(struct rtsx_pcr *pcr);
>  void rts5229_init_params(struct rtsx_pcr *pcr);
>  void rtl8411_init_params(struct rtsx_pcr *pcr);
>  void rtl8402_init_params(struct rtsx_pcr *pcr);
>  void rts5227_init_params(struct rtsx_pcr *pcr);
>  void rts5249_init_params(struct rtsx_pcr *pcr);
> +void rts524a_init_params(struct rtsx_pcr *pcr);
>  void rtl8411b_init_params(struct rtsx_pcr *pcr);
>  
>  static inline u8 map_sd_drive(int idx)
> diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
> index f7cebdb..ab6da29 100644
> --- a/include/linux/mfd/rtsx_pci.h
> +++ b/include/linux/mfd/rtsx_pci.h
> @@ -577,8 +577,13 @@
>  
>  #define CDRESUMECTL			0xFE52
>  #define WAKE_SEL_CTL			0xFE54
> +#define PCLK_CTL			0xFE55
> +#define   PCLK_MODE_SEL			0x20
>  #define PME_FORCE_CTL			0xFE56
> +
>  #define ASPM_FORCE_CTL			0xFE57
> +#define   FORCE_ASPM_CTL0		0x10
> +#define   FORCE_ASPM_VAL_MASK		0x03
>  #define PM_CLK_FORCE_CTL		0xFE58
>  #define FUNC_FORCE_CTL			0xFE59
>  #define PERST_GLITCH_WIDTH		0xFE5C
> @@ -590,7 +595,8 @@
>  #define   HOST_ENTER_S3			2
>  
>  #define SDIO_CFG			0xFE70
> -
> +#define PM_EVENT_DEBUG			0xFE71
> +#define   PME_DEBUG_0			0x08
>  #define NFTS_TX_CTRL			0xFE72
>  
>  #define PWR_GATE_CTRL			0xFE75
> @@ -602,12 +608,19 @@
>  #define PWD_SUSPEND_EN			0xFE76
>  #define LDO_PWR_SEL			0xFE78
>  
> +#define L1SUB_CONFIG1			0xFE8D
> +#define L1SUB_CONFIG2			0xFE8E
> +#define   L1SUB_AUTO_CFG		0x02
> +#define L1SUB_CONFIG3			0xFE8F
> +
>  #define DUMMY_REG_RESET_0		0xFE90
>  
>  #define AUTOLOAD_CFG_BASE		0xFF00
>  #define PETXCFG				0xFF03
>  
>  #define PM_CTRL1			0xFF44
> +#define   CD_RESUME_EN_MASK		0xF0
> +
>  #define PM_CTRL2			0xFF45
>  #define PM_CTRL3			0xFF46
>  #define   SDIO_SEND_PME_EN		0x80
> @@ -628,6 +641,61 @@
>  #define IMAGE_FLAG_ADDR0		0xCE80
>  #define IMAGE_FLAG_ADDR1		0xCE81
>  
> +#define RREF_CFG			0xFF6C
> +#define   RREF_VBGSEL_MASK		0x38
> +#define   RREF_VBGSEL_1V25		0x28
> +
> +#define OOBS_CONFIG			0xFF6E
> +#define   OOBS_AUTOK_DIS		0x80
> +#define   OOBS_VAL_MASK			0x1F
> +
> +#define LDO_DV18_CFG			0xFF70
> +#define   LDO_DV18_SR_MASK		0xC0
> +#define   LDO_DV18_SR_DF		0x40
> +
> +#define LDO_CONFIG2			0xFF71
> +#define   LDO_D3318_MASK		0x07
> +#define   LDO_D3318_33V			0x07
> +#define   LDO_D3318_18V			0x02
> +
> +#define LDO_VCC_CFG0			0xFF72
> +#define   LDO_VCC_LMTVTH_MASK		0x30
> +#define   LDO_VCC_LMTVTH_2A		0x10
> +
> +#define LDO_VCC_CFG1			0xFF73
> +#define   LDO_VCC_REF_TUNE_MASK		0x30
> +#define   LDO_VCC_REF_1V2		0x20
> +#define   LDO_VCC_TUNE_MASK		0x07
> +#define   LDO_VCC_1V8			0x04
> +#define   LDO_VCC_3V3			0x07
> +#define   LDO_VCC_LMT_EN		0x08
> +
> +#define LDO_VIO_CFG			0xFF75
> +#define   LDO_VIO_SR_MASK		0xC0
> +#define   LDO_VIO_SR_DF			0x40
> +#define   LDO_VIO_REF_TUNE_MASK		0x30
> +#define   LDO_VIO_REF_1V2		0x20
> +#define   LDO_VIO_TUNE_MASK		0x07
> +#define   LDO_VIO_1V7			0x03
> +#define   LDO_VIO_1V8			0x04
> +#define   LDO_VIO_3V3			0x07
> +
> +#define LDO_DV12S_CFG			0xFF76
> +#define   LDO_REF12_TUNE_MASK		0x18
> +#define   LDO_REF12_TUNE_DF		0x10
> +#define   LDO_D12_TUNE_MASK		0x07
> +#define   LDO_D12_TUNE_DF		0x04
> +
> +#define LDO_AV12S_CFG			0xFF77
> +#define   LDO_AV12S_TUNE_MASK		0x07
> +#define   LDO_AV12S_TUNE_DF		0x04
> +
> +#define SD40_LDO_CTL1			0xFE7D
> +#define   SD40_VIO_TUNE_MASK		0x70
> +#define   SD40_VIO_TUNE_1V7		0x30
> +#define   SD_VIO_LDO_1V8		0x40
> +#define   SD_VIO_LDO_3V3		0x70
> +
>  /* Phy register */
>  #define PHY_PCR				0x00
>  #define PHY_RCR0			0x01
> @@ -828,7 +896,8 @@ struct rtsx_pcr {
>  #define CHK_PCI_PID(pcr, pid)		((pcr)->pci->device == (pid))
>  #define PCI_VID(pcr)			((pcr)->pci->vendor)
>  #define PCI_PID(pcr)			((pcr)->pci->device)
> -
> +#define is_version(pcr, pid, ver)				\
> +	(CHK_PCI_PID(pcr, pid) && (pcr)->ic_version == (ver))
>  #define pcr_dbg(pcr, fmt, arg...)			\
>  	dev_dbg(&(pcr)->pci->dev, fmt, ##arg)
>  #define SDR104_PHASE(val)		((val) & 0xFF)
> @@ -899,4 +968,18 @@ static inline void rtsx_pci_write_be32(struct rtsx_pcr *pcr, u16 reg, u32 val)
>  	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 3, 0xFF, val);
>  }
>  
> +static inline int rtsx_pci_update_phy(struct rtsx_pcr *pcr, u8 addr,
> +	u16 mask, u16 append)
> +{
> +	int err = 0;
> +	u16 val = 0;

Not sure why you've pre-initialised these?

> +	err = rtsx_pci_read_phy_register(pcr, addr, &val);
> +	if (err < 0)

if (err)

> +		return err;
> +
> +	err = rtsx_pci_write_phy_register(pcr, addr, (val & mask) | append);
> +	return err;

Just return right away.  No need to load 'err'.

> +}
> +
>  #endif

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
