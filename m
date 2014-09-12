Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaILS5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:57:16 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34604 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaILS5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:57:14 -0400
Date: Fri, 12 Sep 2014 13:57:12 -0500
From: Andy Gross <agross@codeaurora.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Felipe Balbi <balbi@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Jack Pham <jackp@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-usb@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: Re: [PATCH v8 3/3] phy: Add Qualcomm DWC3 HS/SS PHY driver
Message-ID: <20140912185712.GB8756@qualcomm.com>
References: <1410542986-24419-1-git-send-email-agross@codeaurora.org>
 <1410542986-24419-4-git-send-email-agross@codeaurora.org>
 <20140912175023.GR3749@joshc.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140912175023.GR3749@joshc.qualcomm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 12:50:23PM -0500, Josh Cartwright wrote:
> Hey Andy-
> 
> Mostly cosmetic things below:
> 
> On Fri, Sep 12, 2014 at 12:29:46PM -0500, Andy Gross wrote:
> > This patch adds a new driver for the Qualcomm USB 3.0 PHY that exists on some
> > Qualcomm platforms.  This driver uses the generic PHY framework and will
> > interact with the DWC3 controller.
> > 
> > Signed-off-by: Andy Gross <agross@codeaurora.org>
> > ---
> >  drivers/phy/Kconfig         |   11 +
> >  drivers/phy/Makefile        |    1 +
> >  drivers/phy/phy-qcom-dwc3.c |  500 +++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 512 insertions(+)
> >  create mode 100644 drivers/phy/phy-qcom-dwc3.c
> > 
> > diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> > index 0dd7427..5d56161 100644
> > --- a/drivers/phy/Kconfig
> > +++ b/drivers/phy/Kconfig
> > @@ -230,4 +230,15 @@ config PHY_XGENE
> >  	help
> >  	  This option enables support for APM X-Gene SoC multi-purpose PHY.
> >  
> > +config PHY_QCOM_DWC3
> > +	tristate "QCOM DWC3 USB PHY support"
> > +	depends on ARCH_QCOM
> > +	depends on HAS_IOMEM
> > +	depends on OF
> > +	select GENERIC_PHY
> > +	help
> > +	  This option enables support for the Synopsis PHYs present inside the
> > +	  Qualcomm USB3.0 DWC3 controller.  This driver supports both HS and SS
> > +	  PHY controllers.
> > +
> >  endmenu
> > diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> > index 95c69ed..aa16f30 100644
> > --- a/drivers/phy/Makefile
> > +++ b/drivers/phy/Makefile
> > @@ -28,3 +28,4 @@ obj-$(CONFIG_PHY_QCOM_IPQ806X_SATA)	+= phy-qcom-ipq806x-sata.o
> >  obj-$(CONFIG_PHY_ST_SPEAR1310_MIPHY)	+= phy-spear1310-miphy.o
> >  obj-$(CONFIG_PHY_ST_SPEAR1340_MIPHY)	+= phy-spear1340-miphy.o
> >  obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
> > +obj-$(CONFIG_PHY_QCOM_DWC3)		+= phy-qcom-dwc3.o
> > diff --git a/drivers/phy/phy-qcom-dwc3.c b/drivers/phy/phy-qcom-dwc3.c
> > new file mode 100644
> > index 0000000..05b8e1d
> > --- /dev/null
> > +++ b/drivers/phy/phy-qcom-dwc3.c
> [..]
> > +/* TX OVRD DRV LO register bits */
> > +#define TX_OVRD_DRV_LO_AMPLITUDE_MASK	0x007F
> > +#define TX_OVRD_DRV_LO_PREEMPH_MASK	0x3F80
> > +#define TX_OVRD_DRV_LO_PREEMPH_SHIFT	7
> > +#define TX_OVRD_DRV_LO_EN		BIT(14)
> > +
> > +struct qcom_dwc3_usb_phy;
> 
> Do you need this?

No, this was a set of interim changes that should have been squashed.
Incidently, this was used when I had a separate ops table for the phys.

> > +
> > +enum qcom_dwc3_phy_id {
> > +	QCOM_DWC3_PHY_UTMI = 0,
> > +	QCOM_DWC3_PHY_PIPE,
> > +	QCOM_DWC3_PHYS_NUM,
> > +};
> > +
> > +struct qcom_dwc3_usb_phy {
> > +	void __iomem		*base;
> > +	struct device		*dev;
> > +	struct phy *phy;
> > +	enum qcom_dwc3_phy_id	index;
> > +
> > +	struct clk		*xo_clk;
> > +	struct clk		*ref_clk;
> > +};
> > +
> > +/**
> > + * Write register and read back masked value to confirm it is written
> > + *
> > + * @base - QCOM DWC3 PHY base virtual address.
> > + * @offset - register offset.
> > + * @mask - register bitmask specifying what should be updated
> > + * @val - value to write.
> > + */
> > +static inline void qcom_dwc3_phy_write_readback(
> > +	struct qcom_dwc3_usb_phy *phy_dwc3, u32 offset,
> > +	const u32 mask, u32 val)
> > +{
> > +	u32 write_val, tmp = readl(phy_dwc3->base + offset);
> > +
> > +	tmp &= ~mask;		/* retain other bits */
> > +	write_val = tmp | val;
> > +
> > +	writel(write_val, phy_dwc3->base + offset);
> > +
> > +	/* Read back to see if val was written */
> > +	tmp = readl(phy_dwc3->base + offset);
> > +	tmp &= mask;		/* clear other bits */
> > +
> > +	if (tmp != val)
> > +		dev_err(phy_dwc3->dev, "write: %x to QSCRATCH: %x FAILED\n",
> > +			val, offset);
> > +}
> > +
> > +static int wait_for_latch(void __iomem *addr)
> > +{
> > +	u32 retry = 10;
> > +
> > +	while (true) {
> > +		if (!readl(addr))
> > +			break;
> > +
> > +		if (--retry == 0)
> > +			return -ETIMEDOUT;
> > +
> > +		usleep_range(10, 20);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * Write SSPHY register
> > + *
> > + * @base - QCOM DWC3 PHY base virtual address.
> > + * @addr - SSPHY address to write.
> > + * @val - value to write.
> > + */
> > +static int qcom_dwc3_ss_write_phycreg(void __iomem *base, u32 addr, u32 val)
> > +{
> > +	writel(addr, base + CR_PROTOCOL_DATA_IN_REG);
> > +	writel(0x1, base + CR_PROTOCOL_CAP_ADDR_REG);
> > +
> > +	if (wait_for_latch(base + CR_PROTOCOL_CAP_ADDR_REG))
> > +		return 1;
> 
> I'm not too familiar with the GENERIC_PHY infrastructure, does it
> understand that '1' is an error case?  I'm wondering if you should
> instead propogate the -ETIMEDOUT up.

Actually, yeah I need to return something < 0.  Let me respin to fix that.

 
> > +
> > +	writel(val, base + CR_PROTOCOL_DATA_IN_REG);
> > +	writel(0x1, base + CR_PROTOCOL_CAP_DATA_REG);
> > +
> > +	if (wait_for_latch(base + CR_PROTOCOL_CAP_DATA_REG))
> > +		return 1;
> > +
> > +	writel(0x1, base + CR_PROTOCOL_WRITE_REG);
> > +
> > +	if (wait_for_latch(base + CR_PROTOCOL_WRITE_REG))
> > +		return 1;
> > +
> > +	return 0;
> > +}
> > +
> [..]
> > +
> > +static struct phy_ops qcom_dwc3_phy_ops = {
> > +	.init		= qcom_dwc3_phy_init,
> > +	.exit		= qcom_dwc3_phy_exit,
> > +	.power_on	= qcom_dwc3_phy_power_on,
> > +	.power_off	= qcom_dwc3_phy_power_off,
> > +	.owner		= THIS_MODULE,
> > +};
> > +
> > +static const struct of_device_id qcom_dwc3_phy_table[] = {
> > +	{
> > +		.compatible = "qcom,dwc3-hs-usb-phy",
> > +		.data = (void *)QCOM_DWC3_PHY_UTMI,
> > +	},
> > +	{
> > +		.compatible = "qcom,dwc3-ss-usb-phy",
> > +		.data = (void *)QCOM_DWC3_PHY_PIPE,
> > +	},
> > +	{ /* Sentinel */ }
> > +};
> > +MODULE_DEVICE_TABLE(of, qcom_dwc3_phy_table);
> 
> I'd suggest just creating a separate ops table, and have '.data' point
> to it.  Might cleanup all of the switch() statements above.  You could
> also probably drop the 'index' member of 'struct qcom_dwc3_usb_phy', and
> maybe even 'enum qcom_dwc3_phy_id' altogether.

Or just put in two function handlers that I point to in the probe and key off of
the compat.

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
