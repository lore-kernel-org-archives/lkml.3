Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbaENPbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:31:37 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:58140 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaENPbf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:31:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Antoine =?ISO-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, linux-ide@vger.kernel.org,
        alexandre.belloni@free-electrons.com, jszhang@marvell.com,
        tj@kernel.org, sebastian.hesselbarth@gmail.com
Subject: Re: [PATCH v3 1/6] phy: add a driver for the Berlin SATA PHY
Date: Wed, 14 May 2014 17:31:24 +0200
Message-ID: <31922167.uMVzxsQNIT@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140514145002.GA18392@kwain>
References: <1400060942-10588-1-git-send-email-antoine.tenart@free-electrons.com> <16480004.aaDhzlOZgi@wuerfel> <20140514145002.GA18392@kwain>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:ldrVTMuOMbbY6yxNqoVO1cb9iEEtRnT1oWx+DOPJBHq
 8fp7aImIaSZU3GJCQUDh6l6GrCNDjMwX7kInTY+MijZwhUOMTE
 LK9As8uzwk6f1/uH7niLttLsGtdTF9dFasfi32yDwSgfU3Dvmn
 pBv8Hn1OIH+MD591opM3LAE+t2fSl5quUjuIxcFbETYleQAVhJ
 FB52l8IfgaMfnHk3LGZG/G5w0NUgndOSW3CrpB7uV5iY2EZjtH
 iFA6MIdKFhlHL///sjogqH0ycXEsOZBJHzYKgFiv7HclAkJ5xL
 yxSZ921VhTivwIi/0ExJxihWKSObFnoyBQ1/kHumkGONBj65YC
 dUWzHsAh2i6PcZldOYLM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 May 2014 16:50:02 Antoine Ténart wrote:
> On Wed, May 14, 2014 at 03:02:34PM +0200, Arnd Bergmann wrote:
> > On Wednesday 14 May 2014 11:48:57 Antoine Ténart wrote:
> > > +static int phy_berlin_sata_power_on(struct phy *phy)
> > > +{
> > > +       struct phy_berlin_desc *desc = phy_get_drvdata(phy);
> > > +       struct phy_berlin_priv *priv = to_berlin_sata_phy_priv(desc);
> > > +       u32 regval;
> > > +
> > > +       spin_lock(&priv->lock);
> > > +
> > > +       /* Power up PHY */
> > > +       writel(CONTROL_REGISTER, priv->base + HOST_VSA_ADDR);
> > > +       regval = readl(priv->base + HOST_VSA_DATA);
> > > +       regval &= ~(desc->val);
> > > +       writel(regval, priv->base + HOST_VSA_DATA);
> > > +
> > > +       /* Configure MBus */
> > > +       writel(MBUS_SIZE_CONTROL, priv->base + HOST_VSA_ADDR);
> > > +       regval = readl(priv->base + HOST_VSA_DATA);
> > > +       regval |= MBUS_WRITE_REQUEST_SIZE_128 | MBUS_READ_REQUEST_SIZE_128;
> > > +       writel(regval, priv->base + HOST_VSA_DATA);
> > > +
> > > +       spin_unlock(&priv->lock);
> > > +
> > > +       return 0;
> > > +}
> > > +
> > > +static int phy_berlin_sata_power_off(struct phy *phy)
> > > +{
> > > +       struct phy_berlin_desc *desc = phy_get_drvdata(phy);
> > > +       struct phy_berlin_priv *priv = to_berlin_sata_phy_priv(desc);
> > > +       u32 regval;
> > > +
> > > +       spin_lock(&priv->lock);
> > > +
> > > +       /* Power down PHY */
> > > +       writel(CONTROL_REGISTER, priv->base + HOST_VSA_ADDR);
> > > +       regval = readl(priv->base + HOST_VSA_DATA);
> > > +       regval |= desc->val;
> > > +       writel(regval, priv->base + HOST_VSA_DATA);
> > > +
> > > +       spin_unlock(&priv->lock);
> > > +
> > > +       return 0;
> > 
> > I don't get this part: you have a reference to the phy here,
> > but then you go poking the phy registers from the SATA driver
> > rather than calling a PHY API function.
> 
> The v1 only introduced an AHCI driver. I somewhat agree the PHY
> operations done in the AHCI driver could be in there.
> 
> I can move the initialization done in the AHCI driver here, but I'll
> still need the driver: the Berlin AHCI needs to call the framework
> generic functions with a custom mask and has custom pm_ops. So I'll
> end up with a nearly empty AHCI driver, not able to control the port
> parameters.
> 
> Or I can put all this in the AHCI driver, but then we'll need to
> describe the PHYs there (to be able to enable each PHY independently)
> and add bindings to the SATA ones.
> 
> What do you think? I prefer the first solution, but we'll have SATA
> port related configuration in the PHY and a very tiny AHCI driver
> because I can't really use the default behaviour of the ahci_platform.

I just noticed I quoted the wrong driver with my comment, but I think
you got what I meant.

Why do you need a custom mask? Is that something you could pass
as the argument in the phy descriptor using #phy-cells=<1>?

> > > +                * By default the PHY node is used to request and match a PHY.
> > > +                * We describe one PHY per sub-node here. Use the right node.
> > > +                */
> > > +               phy->dev.of_node = child;
> > > +
> > > +               priv->phys[phy_id].phy = phy;
> > > +               priv->phys[phy_id].val = desc[phy_id].val;
> > > +               priv->phys[phy_id].index = phy_id;
> > > +               phy_set_drvdata(phy, &priv->phys[phy_id]);
> > 
> > And here, you set a driver specific value into a structure used by the
> > PHY.
> 
> Values in priv->phys[] are related to the PHYs. phy_set_drvdata() allows
> to store PHY related data, which is what I'm doing there. Nearly all PHY
> drivers are doing this.
> 
> Or am I missing something?

This part is really ok, I got confused when I replied to the wrong email.
Sorry about this.

> > Both of these are layering violations. You should either use the PHY
> > interfaces correctly so the SATA driver doesn't have to know about the
> > specific, or not use a PHY device node at all and do everything in
> > the SATA front-end.
> 
> To be sure: you mean using the PHY init() interface in the AHCI driver?

If this PHY is specific to the ahci-berlin hardware and not shared with
anything else, you don't really need to split out a phy driver. That
would somewhat simplify what you ahve here.

The alternative is to make it as generic as you can. If you can manage
to move all the phy code into phy-berlin-sata driver, it should be
possible to just extend the ahci-platform driver resume function to
reinitialize the phy if there is one.

	Arnd
