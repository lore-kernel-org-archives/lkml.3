Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbaENOuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:50:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47593 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751253AbaENOuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:50:07 -0400
Date: Wed, 14 May 2014 16:50:02 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, tj@kernel.org, kishon@ti.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com
Subject: Re: [PATCH v3 1/6] phy: add a driver for the Berlin SATA PHY
Message-ID: <20140514145002.GA18392@kwain>
References: <1400060942-10588-1-git-send-email-antoine.tenart@free-electrons.com>
 <1400060942-10588-2-git-send-email-antoine.tenart@free-electrons.com>
 <16480004.aaDhzlOZgi@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <16480004.aaDhzlOZgi@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On Wed, May 14, 2014 at 03:02:34PM +0200, Arnd Bergmann wrote:
> On Wednesday 14 May 2014 11:48:57 Antoine Ténart wrote:
> > +static int phy_berlin_sata_power_on(struct phy *phy)
> > +{
> > +       struct phy_berlin_desc *desc = phy_get_drvdata(phy);
> > +       struct phy_berlin_priv *priv = to_berlin_sata_phy_priv(desc);
> > +       u32 regval;
> > +
> > +       spin_lock(&priv->lock);
> > +
> > +       /* Power up PHY */
> > +       writel(CONTROL_REGISTER, priv->base + HOST_VSA_ADDR);
> > +       regval = readl(priv->base + HOST_VSA_DATA);
> > +       regval &= ~(desc->val);
> > +       writel(regval, priv->base + HOST_VSA_DATA);
> > +
> > +       /* Configure MBus */
> > +       writel(MBUS_SIZE_CONTROL, priv->base + HOST_VSA_ADDR);
> > +       regval = readl(priv->base + HOST_VSA_DATA);
> > +       regval |= MBUS_WRITE_REQUEST_SIZE_128 | MBUS_READ_REQUEST_SIZE_128;
> > +       writel(regval, priv->base + HOST_VSA_DATA);
> > +
> > +       spin_unlock(&priv->lock);
> > +
> > +       return 0;
> > +}
> > +
> > +static int phy_berlin_sata_power_off(struct phy *phy)
> > +{
> > +       struct phy_berlin_desc *desc = phy_get_drvdata(phy);
> > +       struct phy_berlin_priv *priv = to_berlin_sata_phy_priv(desc);
> > +       u32 regval;
> > +
> > +       spin_lock(&priv->lock);
> > +
> > +       /* Power down PHY */
> > +       writel(CONTROL_REGISTER, priv->base + HOST_VSA_ADDR);
> > +       regval = readl(priv->base + HOST_VSA_DATA);
> > +       regval |= desc->val;
> > +       writel(regval, priv->base + HOST_VSA_DATA);
> > +
> > +       spin_unlock(&priv->lock);
> > +
> > +       return 0;
> 
> I don't get this part: you have a reference to the phy here,
> but then you go poking the phy registers from the SATA driver
> rather than calling a PHY API function.

The v1 only introduced an AHCI driver. I somewhat agree the PHY
operations done in the AHCI driver could be in there.

I can move the initialization done in the AHCI driver here, but I'll
still need the driver: the Berlin AHCI needs to call the framework
generic functions with a custom mask and has custom pm_ops. So I'll
end up with a nearly empty AHCI driver, not able to control the port
parameters.

Or I can put all this in the AHCI driver, but then we'll need to
describe the PHYs there (to be able to enable each PHY independently)
and add bindings to the SATA ones.

What do you think? I prefer the first solution, but we'll have SATA
port related configuration in the PHY and a very tiny AHCI driver
because I can't really use the default behaviour of the ahci_platform.

> > +                * By default the PHY node is used to request and match a PHY.
> > +                * We describe one PHY per sub-node here. Use the right node.
> > +                */
> > +               phy->dev.of_node = child;
> > +
> > +               priv->phys[phy_id].phy = phy;
> > +               priv->phys[phy_id].val = desc[phy_id].val;
> > +               priv->phys[phy_id].index = phy_id;
> > +               phy_set_drvdata(phy, &priv->phys[phy_id]);
> 
> And here, you set a driver specific value into a structure used by the
> PHY.

Values in priv->phys[] are related to the PHYs. phy_set_drvdata() allows
to store PHY related data, which is what I'm doing there. Nearly all PHY
drivers are doing this.

Or am I missing something?

> 
> Both of these are layering violations. You should either use the PHY
> interfaces correctly so the SATA driver doesn't have to know about the
> specific, or not use a PHY device node at all and do everything in
> the SATA front-end.

To be sure: you mean using the PHY init() interface in the AHCI driver?

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
