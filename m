Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaBMKaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:30:06 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:44677 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaBMKaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:30:02 -0500
Date: Thu, 13 Feb 2014 10:29:55 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexandre.torgue@st.com
Subject: Re: [PATCH 4/4] phy: miphy365x: Provide support for the MiPHY356x
 Generic PHY
Message-ID: <20140213102955.GF32508@lee--X1>
References: <1392220985-28189-1-git-send-email-lee.jones@linaro.org>
 <1392220985-28189-4-git-send-email-lee.jones@linaro.org>
 <52FC6BF5.9030900@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52FC6BF5.9030900@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
> > devices. It has 2 ports which it can use for either; both SATA, both
> 
> various SATA or PCIe devices in STMicroelectronics STiH41x SoC series?

To tell you the truth, I'm not sure if it is limited to ST's h/w, but
I think it can only be found there, so I'm happy to fixup.

<snip>

> > +config PHY_MIPHY365X
> > +	tristate "STMicroelectronics MIPHY365X PHY driver for STiH41x series"
> > +	depends on ARCH_STI
> > +	depends on GENERIC_PHY
> depends on CONFIG_OF and HAS_IOMEM?

Sure, I'll fix.

<snip>

> > + * Copyright (C) 2014 STMicroelectronics
> > + *
> > + * STMicroelectronics PHY driver MiPHY365 (for SoC STiH416).
> > + *
> > + * Author: Alexandre Torgue <alexandre.torgue@st.com>
> 
> The author of this patch is not Alexandre Torgue?

The history of this driver is long and the authors are many. Alex
did the last internal over-haul and converted it to use Generic PHY. I
took Alex's driver and made significant changes in order to upstream.

<snip>

> > +#define HFC_TIMEOUT		50
> > +
> > +#define SYSCFG_2521		0x824
> > +#define SYSCFG_2522		0x828
> > +#define SYSCFG_PCIE_SATA_MASK	BIT(1)
> > +#define SYSCFG_PCIE_SATA_POS	1
> > +
> > +/* MiPHY365x register definitiona */
> > +#define RESET_REG		0x00
> > +#define RST_PLL			BIT(1)
> 
> There are quite a few alignment problems with these macros. It needs
> to be fixed.

This is just Git playing up.

In reality everything is perfectly aligned and all using tabs.

<snip>

> > +/*
> > + * This function selects the system configuration,
> > + * either two SATA, one SATA and one PCIe, or two PCIe lanes.
> > + */
> > +static int miphy365x_set_path(struct miphy365x_phy *miphy_phy,
> > +			      struct miphy365x_dev *miphy_dev)
> > +{
> > +	u8 config = miphy_phy->type | miphy_phy->port;
> > +	u32 mask  = SYSCFG_PCIE_SATA_MASK;
> > +	u32 reg;
> > +	bool sata;
> > +
> > +	switch (config) {
> > +	case MIPHY_SATA_PORT0:
> > +		reg = SYSCFG_2521;
> > +		sata = true;
> 
> How do we configure PORT1 for SATA here? Do we really support all the system
> configuration?

Good spot eagle-eye!

Actually in the current version there is a h/w bug which only allows
the SATA_PORT0 and PCIE_PORT1 configuration. When a new version fixing
this is released I will add version detection to the driver and we can
support full intended configuration options. 

<snip>

> > +static inline int miphy365x_phy_hfc_not_rdy(struct miphy365x_phy *miphy_phy,
> > +					    struct miphy365x_dev *miphy_dev)
> > +{
> > +	int timeout = HFC_TIMEOUT;
> > +	u8 mask = IDLL_RDY | PLL_RDY;
> > +	u8 regval;
> > +
> > +	do {
> > +		regval = readb_relaxed(miphy_phy->base + STATUS_REG);
> > +		usleep_range(2000, 2500);
> 
> Any comment on how this delay value is obtained?

I don't have any specific comments, I believe the 2000us it taken from
the datasheet and the 2500 is us playing nice with the scheduler.

<snip>

> > +static inline int miphy365x_phy_rdy(struct miphy365x_phy *miphy_phy,
> > +				    struct miphy365x_dev *miphy_dev)
> > +{
> > +	int timeout = HFC_TIMEOUT;
> > +	u8 mask = mask = IDLL_RDY | PLL_RDY;
> 
> just u8 mask = IDLL_RDY | PLL_RDY; would suffice.

Hmm... not sure how this slipped through - will fix.

> > +	u8 regval;
> > +
> > +	do {
> > +		regval = readb_relaxed(miphy_phy->base + STATUS_REG);
> > +		usleep_range(2000, 2500);
> 
> same here.

As above.

<snip>

> > +	mask = DES_BIT_LOCK | DES_SYMBOL_LOCK;
> > +	while ((readb_relaxed(miphy_phy->base + COMP_CTRL1_REG) & mask)	!= mask)
> > +		cpu_relax();
> 
> Don't we need to break from here at some point if the LOCK's are never set?

I'm sure sure that's possible, but I will invesigate and fixup if req'd.

<snip>

> > +static int miphy365x_phy_power_on(struct phy *phy)
> > +{
> > +	return 0;
> > +}
> > +
> > +static int miphy365x_phy_power_off(struct phy *phy)
> > +{
> > +	return 0;
> > +}
> 
> Both these empty functions can be removed.

You're right, I see the NULL checks, thanks.

<snip>

> > +static int miphy365x_phy_get_base_addr(struct platform_device *pdev,
> > +				       struct miphy365x_phy *phy, u8 port)
> > +{
> > +	struct resource *res;
> > +	char sata[16];
> > +	char pcie[16];
> 
> It can be done with a single variable ;-)

Right. :)

<snip>

> Phy provider register should be the last step in registering the PHY.

Okay, will fix, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
