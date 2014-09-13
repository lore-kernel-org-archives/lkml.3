Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbaIMGqv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 02:46:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50466 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbaIMGqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 02:46:49 -0400
Message-ID: <5413E829.8020804@ti.com>
Date: Sat, 13 Sep 2014 12:16:01 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andy Gross <agross@codeaurora.org>, Felipe Balbi <balbi@ti.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Jack Pham <jackp@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: Re: [Patch v9 3/3] phy: Add Qualcomm DWC3 HS/SS PHY driver
References: <1410550088-8754-1-git-send-email-agross@codeaurora.org> <1410550088-8754-4-git-send-email-agross@codeaurora.org>
In-Reply-To: <1410550088-8754-4-git-send-email-agross@codeaurora.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday 13 September 2014 12:58 AM, Andy Gross wrote:
> This patch adds a new driver for the Qualcomm USB 3.0 PHY that exists on some
> Qualcomm platforms.  This driver uses the generic PHY framework and will
> interact with the DWC3 controller.

Do you have dt documentation for this driver?
> 
> Signed-off-by: Andy Gross <agross@codeaurora.org>
> ---
>  drivers/phy/Kconfig         |   11 +
>  drivers/phy/Makefile        |    1 +
>  drivers/phy/phy-qcom-dwc3.c |  483 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 495 insertions(+)
>  create mode 100644 drivers/phy/phy-qcom-dwc3.c
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 0dd7427..5d56161 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -230,4 +230,15 @@ config PHY_XGENE
>  	help
>  	  This option enables support for APM X-Gene SoC multi-purpose PHY.
>  
> +config PHY_QCOM_DWC3
> +	tristate "QCOM DWC3 USB PHY support"
> +	depends on ARCH_QCOM
> +	depends on HAS_IOMEM
> +	depends on OF
> +	select GENERIC_PHY
> +	help
> +	  This option enables support for the Synopsis PHYs present inside the
> +	  Qualcomm USB3.0 DWC3 controller.  This driver supports both HS and SS
> +	  PHY controllers.
> +
>  endmenu
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index 95c69ed..aa16f30 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -28,3 +28,4 @@ obj-$(CONFIG_PHY_QCOM_IPQ806X_SATA)	+= phy-qcom-ipq806x-sata.o
>  obj-$(CONFIG_PHY_ST_SPEAR1310_MIPHY)	+= phy-spear1310-miphy.o
>  obj-$(CONFIG_PHY_ST_SPEAR1340_MIPHY)	+= phy-spear1340-miphy.o
>  obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
> +obj-$(CONFIG_PHY_QCOM_DWC3)		+= phy-qcom-dwc3.o
> diff --git a/drivers/phy/phy-qcom-dwc3.c b/drivers/phy/phy-qcom-dwc3.c
> new file mode 100644
> index 0000000..2c7b316
> --- /dev/null
> +++ b/drivers/phy/phy-qcom-dwc3.c
> @@ -0,0 +1,483 @@
> +/* Copyright (c) 2013-2014, Code Aurora Forum. All rights reserved.
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
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/phy/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/delay.h>
> +
> +/**
> + *  USB QSCRATCH Hardware registers
> + */
> +#define QSCRATCH_GENERAL_CFG		(0x08)
> +#define HSUSB_PHY_CTRL_REG		(0x10)
> +
> +/* PHY_CTRL_REG */
> +#define HSUSB_CTRL_DMSEHV_CLAMP			BIT(24)
> +#define HSUSB_CTRL_USB2_SUSPEND			BIT(23)
> +#define HSUSB_CTRL_UTMI_CLK_EN			BIT(21)
> +#define	HSUSB_CTRL_UTMI_OTG_VBUS_VALID		BIT(20)
	  ^^^^
alignment went wrong here..

> +#define HSUSB_CTRL_USE_CLKCORE			BIT(18)
> +#define HSUSB_CTRL_DPSEHV_CLAMP			BIT(17)
> +#define HSUSB_CTRL_COMMONONN			BIT(11)
> +#define HSUSB_CTRL_ID_HV_CLAMP			BIT(9)
> +#define HSUSB_CTRL_OTGSESSVLD_CLAMP		BIT(8)
> +#define HSUSB_CTRL_CLAMP_EN			BIT(7)
> +#define HSUSB_CTRL_RETENABLEN			BIT(1)
> +#define HSUSB_CTRL_POR				BIT(0)
> +
> +/* QSCRATCH_GENERAL_CFG */
> +#define HSUSB_GCFG_XHCI_REV		BIT(2)
> +
> +/**
> + *  USB QSCRATCH Hardware registers
> + */
> +#define SSUSB_PHY_CTRL_REG		(0x00)
> +#define SSUSB_PHY_PARAM_CTRL_1		(0x04)
> +#define SSUSB_PHY_PARAM_CTRL_2		(0x08)
> +#define CR_PROTOCOL_DATA_IN_REG		(0x0c)
> +#define CR_PROTOCOL_DATA_OUT_REG	(0x10)
> +#define CR_PROTOCOL_CAP_ADDR_REG	(0x14)
> +#define CR_PROTOCOL_CAP_DATA_REG	(0x18)
> +#define CR_PROTOCOL_READ_REG		(0x1c)
> +#define CR_PROTOCOL_WRITE_REG		(0x20)
> +
> +/* PHY_CTRL_REG */
> +#define SSUSB_CTRL_REF_USE_PAD		BIT(28)
> +#define SSUSB_CTRL_TEST_POWERDOWN	BIT(27)
> +#define SSUSB_CTRL_LANE0_PWR_PRESENT	BIT(24)
> +#define SSUSB_CTRL_SS_PHY_EN		BIT(8)
> +#define SSUSB_CTRL_SS_PHY_RESET		BIT(7)
> +
> +/* SSPHY control registers */
> +#define SSPHY_CTRL_RX_OVRD_IN_HI(lane)	(0x1006 + 0x100 * lane)
> +#define SSPHY_CTRL_TX_OVRD_DRV_LO(lane)	(0x1002 + 0x100 * lane)
> +
> +/* RX OVRD IN HI bits */
> +#define RX_OVRD_IN_HI_RX_RESET_OVRD		BIT(13)
> +#define RX_OVRD_IN_HI_RX_RX_RESET		BIT(12)
> +#define RX_OVRD_IN_HI_RX_EQ_OVRD		BIT(11)
> +#define RX_OVRD_IN_HI_RX_EQ_MASK		0x0700
> +#define RX_OVRD_IN_HI_RX_EQ_SHIFT		8
> +#define RX_OVRD_IN_HI_RX_EQ_EN_OVRD		BIT(7)
> +#define RX_OVRD_IN_HI_RX_EQ_EN			BIT(6)
> +#define RX_OVRD_IN_HI_RX_LOS_FILTER_OVRD	BIT(5)
> +#define RX_OVRD_IN_HI_RX_LOS_FILTER_MASK	0x0018
> +#define RX_OVRD_IN_HI_RX_RATE_OVRD		BIT(2)
> +#define RX_OVRD_IN_HI_RX_RATE_MASK		0x0003
> +
> +/* TX OVRD DRV LO register bits */
> +#define TX_OVRD_DRV_LO_AMPLITUDE_MASK	0x007F
> +#define TX_OVRD_DRV_LO_PREEMPH_MASK	0x3F80
> +#define TX_OVRD_DRV_LO_PREEMPH_SHIFT	7
> +#define TX_OVRD_DRV_LO_EN		BIT(14)
> +
> +struct qcom_dwc3_usb_phy {
> +	void __iomem		*base;
> +	struct device		*dev;
> +	struct phy *phy;
		  ^^
Pls keep the alignment same for all the members..
> +
> +	int (*phy_init)(struct qcom_dwc3_usb_phy *phy_dwc3);
> +	int (*phy_exit)(struct qcom_dwc3_usb_phy *phy_dwc3);
> +
> +	struct clk		*xo_clk;
> +	struct clk		*ref_clk;
> +};
> +
> +/**
> + * Write register and read back masked value to confirm it is written
> + *
> + * @base - QCOM DWC3 PHY base virtual address.
> + * @offset - register offset.
> + * @mask - register bitmask specifying what should be updated
> + * @val - value to write.
> + */
> +static inline void qcom_dwc3_phy_write_readback(
> +	struct qcom_dwc3_usb_phy *phy_dwc3, u32 offset,
> +	const u32 mask, u32 val)
> +{
> +	u32 write_val, tmp = readl(phy_dwc3->base + offset);
> +
> +	tmp &= ~mask;		/* retain other bits */
> +	write_val = tmp | val;
> +
> +	writel(write_val, phy_dwc3->base + offset);
> +
> +	/* Read back to see if val was written */

Does it fail sometime? I'm not sure if this should be present in the driver
since this looks more of a debug code.
> +	tmp = readl(phy_dwc3->base + offset);
> +	tmp &= mask;		/* clear other bits */
> +
> +	if (tmp != val)
> +		dev_err(phy_dwc3->dev, "write: %x to QSCRATCH: %x FAILED\n",
> +			val, offset);
> +}
> +
> +static int wait_for_latch(void __iomem *addr)
> +{
> +	u32 retry = 10;
> +
> +	while (true) {
> +		if (!readl(addr))
> +			break;
> +
> +		if (--retry == 0)
> +			return -ETIMEDOUT;
> +
> +		usleep_range(10, 20);
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * Write SSPHY register
> + *
> + * @base - QCOM DWC3 PHY base virtual address.
> + * @addr - SSPHY address to write.
> + * @val - value to write.
> + */
> +static int qcom_dwc3_ss_write_phycreg(void __iomem *base, u32 addr, u32 val)
> +{
> +	int ret;
> +
> +	writel(addr, base + CR_PROTOCOL_DATA_IN_REG);
> +	writel(0x1, base + CR_PROTOCOL_CAP_ADDR_REG);

use macros here and below..
> +
> +	ret = wait_for_latch(base + CR_PROTOCOL_CAP_ADDR_REG);
> +	if (ret)
> +		goto err_wait;

a timed out error message here?
> +
> +	writel(val, base + CR_PROTOCOL_DATA_IN_REG);
> +	writel(0x1, base + CR_PROTOCOL_CAP_DATA_REG);
> +
> +	ret = wait_for_latch(base + CR_PROTOCOL_CAP_DATA_REG);
> +	if (ret)
> +		goto err_wait;
> +
> +	writel(0x1, base + CR_PROTOCOL_WRITE_REG);
> +
> +	ret = wait_for_latch(base + CR_PROTOCOL_WRITE_REG);
> +
> +err_wait:
> +	return ret;
> +}
> +
> +/**
> + * Read SSPHY register.
> + *
> + * @base - QCOM DWC3 PHY base virtual address.
> + * @addr - SSPHY address to read.
> + */
> +static int qcom_dwc3_ss_read_phycreg(void __iomem *base, u32 addr, u32 *val)
> +{
> +	int ret;
> +	bool first_read = true;
> +
> +	writel(addr, base + CR_PROTOCOL_DATA_IN_REG);
> +	writel(0x1, base + CR_PROTOCOL_CAP_ADDR_REG);
> +
> +	ret = wait_for_latch(base + CR_PROTOCOL_CAP_ADDR_REG);
> +	if (ret)
> +		goto err_wait;
> +
> +	/*
> +	 * Due to hardware bug, first read of SSPHY register might be
> +	 * incorrect. Hence as workaround, SW should perform SSPHY register
> +	 * read twice, but use only second read and ignore first read.
> +	 */
> +retry:
> +	writel(0x1, base + CR_PROTOCOL_READ_REG);
> +
> +	ret = wait_for_latch(base + CR_PROTOCOL_READ_REG);
> +	if (ret)
> +		goto err_wait;
> +

_retry_ should be here? since only the read fails..
> +	if (first_read) {
> +		readl(base + CR_PROTOCOL_DATA_OUT_REG);
> +		first_read = false;
> +		goto retry;
> +	}
> +
> +	*val = readl(base + CR_PROTOCOL_DATA_OUT_REG);
> +
> +err_wait:
> +	return ret;
> +}
> +
> +static int qcom_dwc3_phy_power_on(struct phy *phy)
> +{
> +	int ret;
> +	struct qcom_dwc3_usb_phy *phy_dwc3 = phy_get_drvdata(phy);
> +
> +	ret = clk_prepare_enable(phy_dwc3->xo_clk);
> +	if (ret)
> +		return ret;
> +
> +	ret = clk_prepare_enable(phy_dwc3->ref_clk);
> +	if (ret)
> +		clk_disable_unprepare(phy_dwc3->xo_clk);
> +
> +	return ret;
> +}
> +
> +static int qcom_dwc3_phy_power_off(struct phy *phy)
> +{
> +	struct qcom_dwc3_usb_phy *phy_dwc3 = phy_get_drvdata(phy);
> +
> +	clk_disable_unprepare(phy_dwc3->ref_clk);
> +	clk_disable_unprepare(phy_dwc3->xo_clk);
> +
> +	return 0;
> +}
> +
> +static int qcom_dwc3_hs_phy_init(struct qcom_dwc3_usb_phy *phy_dwc3)
> +{
> +	u32 val;
> +
> +	/*
> +	 * HSPHY Initialization: Enable UTMI clock, select 19.2MHz fsel
> +	 * enable clamping, and disable RETENTION (power-on default is ENABLED)
> +	 */
> +	val = HSUSB_CTRL_DPSEHV_CLAMP | HSUSB_CTRL_DMSEHV_CLAMP |
> +		HSUSB_CTRL_RETENABLEN  | HSUSB_CTRL_COMMONONN |
> +		HSUSB_CTRL_OTGSESSVLD_CLAMP | HSUSB_CTRL_ID_HV_CLAMP |
> +		HSUSB_CTRL_DPSEHV_CLAMP | HSUSB_CTRL_UTMI_OTG_VBUS_VALID |
> +		HSUSB_CTRL_UTMI_CLK_EN | HSUSB_CTRL_CLAMP_EN | 0x70;
> +
> +	/* use core clock if external reference is not present */
> +	if (!phy_dwc3->xo_clk)
> +		val |= HSUSB_CTRL_USE_CLKCORE;
> +
> +	writel(val, phy_dwc3->base + HSUSB_PHY_CTRL_REG);
> +	usleep_range(2000, 2200);
> +
> +	/* Disable (bypass) VBUS and ID filters */
> +	writel(HSUSB_GCFG_XHCI_REV, phy_dwc3->base + QSCRATCH_GENERAL_CFG);
> +
> +	return 0;
> +}
> +
> +static int qcom_dwc3_ss_phy_init(struct qcom_dwc3_usb_phy *phy_dwc3)
> +{
> +	int ret;
> +	u32 data = 0;
> +
> +	/* reset phy */
> +	data = readl_relaxed(phy_dwc3->base + SSUSB_PHY_CTRL_REG);

Why readl_relaxed here?
> +	writel_relaxed(data | SSUSB_CTRL_SS_PHY_RESET,
> +		phy_dwc3->base + SSUSB_PHY_CTRL_REG);
> +	usleep_range(2000, 2200);

use msleep here..
> +	writel_relaxed(data, phy_dwc3->base + SSUSB_PHY_CTRL_REG);
> +
> +	/* clear REF_PAD if we don't have XO clk */
> +	if (!phy_dwc3->xo_clk)
> +		data &= ~SSUSB_CTRL_REF_USE_PAD;
> +	else
> +		data |= SSUSB_CTRL_REF_USE_PAD;
> +
> +	writel_relaxed(data, phy_dwc3->base + SSUSB_PHY_CTRL_REG);
> +	msleep(30);

add a comment on why this delay is required. If the hw spec gives this delay,
note it here.
> +
> +	data |= SSUSB_CTRL_SS_PHY_EN | SSUSB_CTRL_LANE0_PWR_PRESENT;
> +	writel_relaxed(data, phy_dwc3->base + SSUSB_PHY_CTRL_REG);
> +
> +	/*
> +	 * Fix RX Equalization setting as follows
> +	 * LANE0.RX_OVRD_IN_HI. RX_EQ_EN set to 0
> +	 * LANE0.RX_OVRD_IN_HI.RX_EQ_EN_OVRD set to 1
> +	 * LANE0.RX_OVRD_IN_HI.RX_EQ set to 3
> +	 * LANE0.RX_OVRD_IN_HI.RX_EQ_OVRD set to 1
> +	 */
> +	ret = qcom_dwc3_ss_read_phycreg(phy_dwc3->base,
> +			SSPHY_CTRL_RX_OVRD_IN_HI(0), &data);
> +	if (ret)
> +		goto err_phy_trans;
> +
> +	data &= ~RX_OVRD_IN_HI_RX_EQ_EN;
> +	data |= RX_OVRD_IN_HI_RX_EQ_EN_OVRD;
> +	data &= ~RX_OVRD_IN_HI_RX_EQ_MASK;
> +	data |= 0x3 << RX_OVRD_IN_HI_RX_EQ_SHIFT;
> +	data |= RX_OVRD_IN_HI_RX_EQ_OVRD;
> +	ret = qcom_dwc3_ss_write_phycreg(phy_dwc3->base,
> +		SSPHY_CTRL_RX_OVRD_IN_HI(0), data);
> +	if (ret)
> +		goto err_phy_trans;
> +
> +	/*
> +	 * Set EQ and TX launch amplitudes as follows
> +	 * LANE0.TX_OVRD_DRV_LO.PREEMPH set to 22
> +	 * LANE0.TX_OVRD_DRV_LO.AMPLITUDE set to 127
> +	 * LANE0.TX_OVRD_DRV_LO.EN set to 1.
> +	 */
> +	ret = qcom_dwc3_ss_read_phycreg(phy_dwc3->base,
> +		SSPHY_CTRL_TX_OVRD_DRV_LO(0), &data);
> +	if (ret)
> +		goto err_phy_trans;
> +
> +	data &= ~TX_OVRD_DRV_LO_PREEMPH_MASK;
> +	data |= 0x16 << TX_OVRD_DRV_LO_PREEMPH_SHIFT;
> +	data &= ~TX_OVRD_DRV_LO_AMPLITUDE_MASK;
> +	data |= 0x7f;
> +	data |= TX_OVRD_DRV_LO_EN;
> +	ret = qcom_dwc3_ss_write_phycreg(phy_dwc3->base,
> +		SSPHY_CTRL_TX_OVRD_DRV_LO(0), data);
> +	if (ret)
> +		goto err_phy_trans;
> +
> +	/*
> +	 * Set the QSCRATCH PHY_PARAM_CTRL1 parameters as follows
> +	 * TX_FULL_SWING [26:20] amplitude to 127
> +	 * TX_DEEMPH_3_5DB [13:8] to 22
> +	 * LOS_BIAS [2:0] to 0x5
> +	 */
> +	qcom_dwc3_phy_write_readback(phy_dwc3, SSUSB_PHY_PARAM_CTRL_1,
> +				   0x07f03f07, 0x07f01605);
> +
> +err_phy_trans:
> +	return ret;
> +}
> +
> +static int qcom_dwc3_ss_phy_exit(struct qcom_dwc3_usb_phy *phy_dwc3)
> +{
> +	/* Sequence to put SSPHY in low power state:
> +	 * 1. Clear REF_PHY_EN in PHY_CTRL_REG
> +	 * 2. Clear REF_USE_PAD in PHY_CTRL_REG
> +	 * 3. Set TEST_POWERED_DOWN in PHY_CTRL_REG to enable PHY retention
> +	 * 4. Disable SSPHY ref clk

The last step is missing below..
> +	 */
> +	qcom_dwc3_phy_write_readback(phy_dwc3, SSUSB_PHY_CTRL_REG,
> +		SSUSB_CTRL_SS_PHY_EN, 0x0);
> +	qcom_dwc3_phy_write_readback(phy_dwc3, SSUSB_PHY_CTRL_REG,
> +		SSUSB_CTRL_REF_USE_PAD, 0x0);
> +	qcom_dwc3_phy_write_readback(phy_dwc3, SSUSB_PHY_CTRL_REG,
> +		0x0, SSUSB_CTRL_TEST_POWERDOWN);
> +
> +	return 0;
> +}
> +
> +static int qcom_dwc3_phy_init(struct phy *phy)
> +{
> +	struct qcom_dwc3_usb_phy *phy_dwc3 = phy_get_drvdata(phy);
> +
> +	if (phy_dwc3->phy_init)
> +		return phy_dwc3->phy_init(phy_dwc3);

This indirection is not needed at all. qcom_dwc3_ss_phy_init can be directly
populated in probe depending on the PHY.
> +
> +	return 0;
> +}
> +
> +static int qcom_dwc3_phy_exit(struct phy *phy)
> +{
> +	struct qcom_dwc3_usb_phy *phy_dwc3 = phy_get_drvdata(phy);
> +
> +	if (phy_dwc3->phy_exit)
> +		return qcom_dwc3_ss_phy_exit(phy_dwc3);

you meant return phy_dwc3->phy_exit(phy_dwc3) here?

Thanks
Kishon
