Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbaENQ52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:57:28 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48700 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755588AbaENQ50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:57:26 -0400
Date: Wed, 14 May 2014 18:57:22 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, linux-ide@vger.kernel.org,
        alexandre.belloni@free-electrons.com, jszhang@marvell.com,
        tj@kernel.org, sebastian.hesselbarth@gmail.com
Subject: Re: [PATCH v3 1/6] phy: add a driver for the Berlin SATA PHY
Message-ID: <20140514165722.GA18495@kwain>
References: <1400060942-10588-1-git-send-email-antoine.tenart@free-electrons.com>
 <31922167.uMVzxsQNIT@wuerfel>
 <20140514154929.GA8016@kwain>
 <4414637.rKolGB14Rm@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4414637.rKolGB14Rm@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 06:11:24PM +0200, Arnd Bergmann wrote:
> On Wednesday 14 May 2014 17:49:29 Antoine Ténart wrote:
> > On Wed, May 14, 2014 at 05:31:24PM +0200, Arnd Bergmann wrote:
> > > On Wednesday 14 May 2014 16:50:02 Antoine Ténart wrote:
> > > > On Wed, May 14, 2014 at 03:02:34PM +0200, Arnd Bergmann wrote:
> > > > > On Wednesday 14 May 2014 11:48:57 Antoine Ténart wrote:
> > > > > I don't get this part: you have a reference to the phy here,
> > > > > but then you go poking the phy registers from the SATA driver
> > > > > rather than calling a PHY API function.
> > > > 
> > > > The v1 only introduced an AHCI driver. I somewhat agree the PHY
> > > > operations done in the AHCI driver could be in there.
> > > > 
> > > > I can move the initialization done in the AHCI driver here, but I'll
> > > > still need the driver: the Berlin AHCI needs to call the framework
> > > > generic functions with a custom mask and has custom pm_ops. So I'll
> > > > end up with a nearly empty AHCI driver, not able to control the port
> > > > parameters.
> > > > 
> > > > Or I can put all this in the AHCI driver, but then we'll need to
> > > > describe the PHYs there (to be able to enable each PHY independently)
> > > > and add bindings to the SATA ones.
> > > > 
> > > > What do you think? I prefer the first solution, but we'll have SATA
> > > > port related configuration in the PHY and a very tiny AHCI driver
> > > > because I can't really use the default behaviour of the ahci_platform.
> > > 
> > > I just noticed I quoted the wrong driver with my comment, but I think
> > > you got what I meant.
> > > 
> > > Why do you need a custom mask? Is that something you could pass
> > > as the argument in the phy descriptor using #phy-cells=<1>?
> > 
> > I meant a custom mask in the AHCI driver, when calling the
> > ahci_platform_init_host() function. Otherwise we'll have problems on the
> > BG2Q DMP (it only has one PHY available, and not initializing it is not
> > enough).
> 
> Ah, I see what you mean now. Of course, this could also be an optional
> property in the generic AHCI binding, which would require that you
> specify the available ports in DT for nonstandard masks.
> 
> Just to confirm: The HOST_PORTS_IMPL register on BG2Q DMP has an
> value that we can't use here to determine the available ports, right?

Right. The register is here but saying there are 2 available ports,
which is true for the BG2Q SoC but not true for the BG2Q DMP board. So
the AHCI framework reads the register and performs a misconfiguration of
the SATA.

> 
> > > > > > +                * By default the PHY node is used to request and match a PHY.
> > > > > > +                * We describe one PHY per sub-node here. Use the right node.
> > > > > > +                */
> > > > > > +               phy->dev.of_node = child;
> > > > > > +
> > > > > > +               priv->phys[phy_id].phy = phy;
> > > > > > +               priv->phys[phy_id].val = desc[phy_id].val;
> > > > > > +               priv->phys[phy_id].index = phy_id;
> > > > > > +               phy_set_drvdata(phy, &priv->phys[phy_id]);
> > > > > 
> > > > > And here, you set a driver specific value into a structure used by the
> > > > > PHY.
> > > > 
> > > > Values in priv->phys[] are related to the PHYs. phy_set_drvdata() allows
> > > > to store PHY related data, which is what I'm doing there. Nearly all PHY
> > > > drivers are doing this.
> > > > 
> > > > Or am I missing something?
> > > 
> > > This part is really ok, I got confused when I replied to the wrong email.
> > > Sorry about this.
> > > 
> > > > > Both of these are layering violations. You should either use the PHY
> > > > > interfaces correctly so the SATA driver doesn't have to know about the
> > > > > specific, or not use a PHY device node at all and do everything in
> > > > > the SATA front-end.
> > > > 
> > > > To be sure: you mean using the PHY init() interface in the AHCI driver?
> > > 
> > > If this PHY is specific to the ahci-berlin hardware and not shared with
> > > anything else, you don't really need to split out a phy driver. That
> > > would somewhat simplify what you ahve here.
> > 
> > I don't have lots of info about that, but we set the PHY to
> > PHY_MODE_SATA in the AHCI driver. So I guess there are other modes.
> 
> Ok, good point. This does sound a lot like there are multiple modes.
> 
> This would also imply that the "compatible" string should not have
> "sata" in it either, but describe a generic PHY. You can pass the mode
> as part of the phy descriptor from DT then.

Yes sure, with something like:

	phys = <&foo_phy0 FOO_SATA>;

> 
> > > The alternative is to make it as generic as you can. If you can manage
> > > to move all the phy code into phy-berlin-sata driver, it should be
> > > possible to just extend the ahci-platform driver resume function to
> > > reinitialize the phy if there is one.
> > 
> > It is possible to move all the PHY code the phy-berlin-sata. Then I'll
> > need to hack a bit the AHCI framework so it can handle more than one
> > PHY. But as I said, I'll still need to set a custom mask, and adding a
> > quirk to the AHCI platform or framework does not seem to be a very good
> > idea, imho.
> > 
> > Or I can add a computed mask to the ahci-platform driver, like I did in
> > the Berlin one, but I don't know what would be the consequences. For
> > each PHY I have:
> > 
> > +	mask |= 1 << i;
> 
> It does sound generic enough that the same would be done on other
> ahci-platform variants with a generic phy attached, even though
> currently each one has only one phy.
> 
> We can probably define this as an extension in some form.
> Do you think we need to handle the case where the first port is
> unavailable but some of the other ports should be used?

The Berlin AHCI driver handles the case. I don't know if we'll come
across a use case for this but supporting it should'nt be difficult. So
why not ... :)

I think we can either add a binding enabling an automatic mask computation
in the framework or match the compatible and do this in the ahci-platform
driver. Or we can make this the default behaviour when multiple PHYs are
used in an AHCI node, but I'll have to check if that's possible.

Maybe the SATA subsystem maintainer has an opinion on the matter?


Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
