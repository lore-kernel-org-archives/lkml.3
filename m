Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbaDWIVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:21:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55102 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751745AbaDWIVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:21:03 -0400
Date: Wed, 23 Apr 2014 10:21:00 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: tj@kernel.org, alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] ata: ahci: add AHCI support for Berlin SoCs
Message-ID: <20140423082100.GB24355@kwain>
References: <1398181105-19714-1-git-send-email-antoine.tenart@free-electrons.com>
 <1398181105-19714-2-git-send-email-antoine.tenart@free-electrons.com>
 <5356A4F4.6090107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5356A4F4.6090107@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On Tue, Apr 22, 2014 at 07:20:52PM +0200, Sebastian Hesselbarth wrote:
> On 04/22/2014 05:38 PM, Antoine Ténart wrote:

[…]

> > +static inline void ahci_berlin_reg_set(void __iomem *reg, u32 val)
> > +{
> > +	writel(val, reg);
> > +}
> 
> Antoine,
> 
> if you really need to rename writel, the above function name should
> end with _write.

I renamed writel for consistency with ahci_berlin_reg_clear_set() and
ahci_berlin_reg_setbits() but I can definitively drop it.

> 
> > +static inline void ahci_berlin_reg_clear_set(void __iomem *reg, u32 clear_val,
> > +					     u32 set_val)
> > +{
> > +	u32 regval;
> > +
> > +	regval = readl(reg);
> > +	regval &= ~(clear_val);
> > +	regval |= set_val;
> > +	writel(regval, reg);
> > +}
> 
> ahci_berlin_reg_setbits(reg, val) == ahci_berlin_reg_clear_set(reg, 0, val);
> 
> Maybe get rid of the latter?

Sure.

> 
> > +static void ahci_berlin_init(void __iomem *mmio)
> > +{
> > +	/* interface select */
> > +	ahci_berlin_reg_set(mmio + HOST_VSA_ADDR, BIT(2));
> > +	ahci_berlin_reg_set(mmio + HOST_VSA_ADDR,
> > +			    BIT(21) | BIT(18) | BIT(5) | BIT(4) | BIT(2));
> 
> Any chance we get named #defines for the BIT()s above and below?

I'm afraid I can't. I'd love to do so if someone has a clue on this matter.

> > +	/* force_map is modified only if the property is found */
> > +	of_property_read_u32(np, "marvell,force-port-map", &force_map);
> > +	if (force_map)
> > +		nports = force_map;
> 
> marvell,force-port-map is undocumented and its name does not reflect
> what it is about. Before you just rename it to marvell,nr-ports or
> something, how about having one sub-node per port:
> 
> sata_phy0: sata-phy@e90100 {
> 	compatible = "marvell,berlin-sata-phy";
> 	reg = <0xe90100 0x80>;
> 	status = "disabled";
> };
> 
> sata_phy1: sata-phy@e90180 {
> 	compatible = "marvell,berlin-sata-phy";
> 	reg = <0xe90180 0x80>;
> 	status = "disabled";
> };
> 
> ahci: sata@e90000 {
> 	compatible = "marvell,berlin-ahci";
> 	reg = <0xe90000 0x100>;
> 	interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
> 	#address-cells = <1>;
> 	#size-cells = <0>;
> 	status = "disabled";
> 
> 	sata-port@0 {
> 		reg = <0>;
> 		sata-phy = <&sata_phy0>;
> 		status = "disabled";
> 	};
> 
> 	sata-port@1 {
> 		reg = <1>;
> 		sata-phy = <&sata_phy1>;
> 		status = "okay";
> 	};
> };
> 
> That way you can
> (a) separate a PHY driver that has little code but is able to power-down
>     the PHY even if there is no AHCI driver loaded.
> (b) enable/disable each port individually.
> (c) enable port1 while port0 is disabled.
> (d) disable the PLL if there is no port enabled at all.

That would be better, but as of now I'm not sure I have enough information on
the PHY to do (a).

I guess (b), (c) and (d) can still be done.

Thanks for the review!

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
