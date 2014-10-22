Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbaJVJZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:25:38 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:51238 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbaJVJZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:25:36 -0400
Date: Wed, 22 Oct 2014 10:25:29 +0100
From: Lee Jones <lee.jones@linaro.org>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rogerable@realtek.com, wei_wang@realsil.com.cn
Subject: Re: [PATCH v2] mfd: rtsx: fix PM suspend for 5227 & 5249
Message-ID: <20141022092529.GH4939@x1>
References: <1412920724-27945-1-git-send-email-micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1412920724-27945-1-git-send-email-micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2014, micky_ching@realsil.com.cn wrote:

> From: Micky Ching <micky_ching@realsil.com.cn>
> 
> Fix rts5227&5249 failed send buffer cmd after suspend,
> PM_CTRL3 should reset before send any buffer cmd after suspend.
> Otherwise, buffer cmd will failed, this will lead resume fail.
> 
> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> ---
>  drivers/mfd/Makefile         |  2 +-
>  drivers/mfd/rts5227.c        |  6 ++++++
>  drivers/mfd/rts5249.c        |  4 ++++
>  drivers/mfd/rtsx_gops.c      | 37 +++++++++++++++++++++++++++++++++++++
>  drivers/mfd/rtsx_pcr.h       |  3 +++
>  include/linux/mfd/rtsx_pci.h | 28 ++++++++++++++++++++++++++++
>  6 files changed, 79 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/mfd/rtsx_gops.c

Applied, thanks.

> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index f001487..7f45c06 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -13,7 +13,7 @@ obj-$(CONFIG_MFD_CROS_EC)	+= cros_ec.o
>  obj-$(CONFIG_MFD_CROS_EC_I2C)	+= cros_ec_i2c.o
>  obj-$(CONFIG_MFD_CROS_EC_SPI)	+= cros_ec_spi.o
>  
> -rtsx_pci-objs			:= rtsx_pcr.o rts5209.o rts5229.o rtl8411.o rts5227.o rts5249.o
> +rtsx_pci-objs			:= rtsx_pcr.o rtsx_gops.o rts5209.o rts5229.o rtl8411.o rts5227.o rts5249.o
>  obj-$(CONFIG_MFD_RTSX_PCI)	+= rtsx_pci.o
>  obj-$(CONFIG_MFD_RTSX_USB)	+= rtsx_usb.o
>  
> diff --git a/drivers/mfd/rts5227.c b/drivers/mfd/rts5227.c
> index 9c8eec8..3240740 100644
> --- a/drivers/mfd/rts5227.c
> +++ b/drivers/mfd/rts5227.c
> @@ -130,6 +130,12 @@ static int rts5227_extra_init_hw(struct rtsx_pcr *pcr)
>  
>  static int rts5227_optimize_phy(struct rtsx_pcr *pcr)
>  {
> +	int err;
> +
> +	err = rtsx_gops_pm_reset(pcr);
> +	if (err < 0)
> +		return err;
> +
>  	/* Optimize RX sensitivity */
>  	return rtsx_pci_write_phy_register(pcr, 0x00, 0xBA42);
>  }
> diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
> index 573de7b..cf425cc 100644
> --- a/drivers/mfd/rts5249.c
> +++ b/drivers/mfd/rts5249.c
> @@ -130,6 +130,10 @@ static int rts5249_optimize_phy(struct rtsx_pcr *pcr)
>  {
>  	int err;
>  
> +	err = rtsx_gops_pm_reset(pcr);
> +	if (err < 0)
> +		return err;
> +
>  	err = rtsx_pci_write_phy_register(pcr, PHY_REG_REV,
>  			PHY_REG_REV_RESV | PHY_REG_REV_RXIDLE_LATCHED |
>  			PHY_REG_REV_P1_EN | PHY_REG_REV_RXIDLE_EN |
> diff --git a/drivers/mfd/rtsx_gops.c b/drivers/mfd/rtsx_gops.c
> new file mode 100644
> index 0000000..b1a98c6
> --- /dev/null
> +++ b/drivers/mfd/rtsx_gops.c
> @@ -0,0 +1,37 @@
> +/* Driver for Realtek PCI-Express card reader
> + *
> + * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
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
> + *   Micky Ching <micky_ching@realsil.com.cn>
> + */
> +
> +#include <linux/mfd/rtsx_pci.h>
> +#include "rtsx_pcr.h"
> +
> +int rtsx_gops_pm_reset(struct rtsx_pcr *pcr)
> +{
> +	int err;
> +
> +	/* init aspm */
> +	rtsx_pci_write_register(pcr, ASPM_FORCE_CTL, 0xFF, 0x00);
> +	err = rtsx_pci_update_cfg_byte(pcr, LCTLR, ~LCTLR_ASPM_CTL_MASK, 0x00);
> +	if (err < 0)
> +		return err;
> +
> +	/* reset PM_CTRL3 before send buffer cmd */
> +	return rtsx_pci_write_register(pcr, PM_CTRL3, D3_DELINK_MODE_EN, 0x00);
> +}
> diff --git a/drivers/mfd/rtsx_pcr.h b/drivers/mfd/rtsx_pcr.h
> index 07e4c2e..fe2bbb6 100644
> --- a/drivers/mfd/rtsx_pcr.h
> +++ b/drivers/mfd/rtsx_pcr.h
> @@ -72,4 +72,7 @@ do {									\
>  	pcr->ms_pull_ctl_disable_tbl = __device##_ms_pull_ctl_disable_tbl; \
>  } while (0)
>  
> +/* generic operations */
> +int rtsx_gops_pm_reset(struct rtsx_pcr *pcr);
> +
>  #endif
> diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
> index 74346d5..1604dda 100644
> --- a/include/linux/mfd/rtsx_pci.h
> +++ b/include/linux/mfd/rtsx_pci.h
> @@ -707,6 +707,14 @@
>  #define PM_CTRL1			0xFF44
>  #define PM_CTRL2			0xFF45
>  #define PM_CTRL3			0xFF46
> +#define   SDIO_SEND_PME_EN		0x80
> +#define   FORCE_RC_MODE_ON		0x40
> +#define   FORCE_RX50_LINK_ON		0x20
> +#define   D3_DELINK_MODE_EN		0x10
> +#define   USE_PESRTB_CTL_DELINK		0x08
> +#define   DELAY_PIN_WAKE		0x04
> +#define   RESET_PIN_WAKE		0x02
> +#define   PM_WAKE_EN			0x01
>  #define PM_CTRL4			0xFF47
>  
>  /* Memory mapping */
> @@ -752,6 +760,14 @@
>  #define PHY_DUM_REG			0x1F
>  
>  #define LCTLR				0x80
> +#define   LCTLR_EXT_SYNC		0x80
> +#define   LCTLR_COMMON_CLOCK_CFG	0x40
> +#define   LCTLR_RETRAIN_LINK		0x20
> +#define   LCTLR_LINK_DISABLE		0x10
> +#define   LCTLR_RCB			0x08
> +#define   LCTLR_RESERVED		0x04
> +#define   LCTLR_ASPM_CTL_MASK		0x03
> +
>  #define PCR_SETTING_REG1		0x724
>  #define PCR_SETTING_REG2		0x814
>  #define PCR_SETTING_REG3		0x747
> @@ -967,4 +983,16 @@ static inline u8 *rtsx_pci_get_cmd_data(struct rtsx_pcr *pcr)
>  	return (u8 *)(pcr->host_cmds_ptr);
>  }
>  
> +static inline int rtsx_pci_update_cfg_byte(struct rtsx_pcr *pcr, int addr,
> +		u8 mask, u8 append)
> +{
> +	int err;
> +	u8 val;
> +
> +	err = pci_read_config_byte(pcr->pci, addr, &val);
> +	if (err < 0)
> +		return err;
> +	return pci_write_config_byte(pcr->pci, addr, (val & mask) | append);
> +}
> +
>  #endif

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
