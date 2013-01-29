Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab3A2UlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 15:41:12 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:57506 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab3A2UlI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 15:41:08 -0500
From: Florian Fainelli <florian@openwrt.org>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 5/5] mv643xx_eth: convert to use the Marvell Orion MDIO driver
Date: Tue, 29 Jan 2013 21:41:03 +0100
User-Agent: KMail/1.13.7 (Linux/3.7-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: davem@davemloft.net,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, linux-doc@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, netdev@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        linux-arm-kernel@lists.infradead.org, Rob Landley <rob@landley.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linuxppc-dev@lists.ozlabs.org,
        Lennert Buytenhek <buytenh@wantstofly.org>
References: <1359473048-26551-1-git-send-email-florian@openwrt.org> <1359473048-26551-6-git-send-email-florian@openwrt.org> <20130129181306.GF25646@obsidianresearch.com>
In-Reply-To: <20130129181306.GF25646@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201301292141.03931.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 29 janvier 2013 19:13:06, Jason Gunthorpe a écrit :
> On Tue, Jan 29, 2013 at 04:24:08PM +0100, Florian Fainelli wrote:
> > This patch converts the Marvell MV643XX ethernet driver to use the
> > Marvell Orion MDIO driver. As a result, PowerPC and ARM platforms
> > registering the Marvell MV643XX ethernet driver are also updated to
> > register a Marvell Orion MDIO driver. This driver voluntarily overlaps
> > with the Marvell Ethernet shared registers because it will use a subset
> > of this shared register (shared_base + 0x4 - shared_base + 0x84). The
> > Ethernet driver is also updated to look up for a PHY device using the
> > Orion MDIO bus driver.
> 
> Can you finish off this job by making the mv643xx_eth driver accept
> the standard phy-handle OF property instead of using a phy address?

I can certainly do that, at the same time we need to continue supporting the 
"old" platform device style registration without breaking them (PowerPC in 
particular, and the hopefully yet to be converted orion5x). So the phy_scan() 
as I modified it will probably still be there.

> 
> Ie the end result should be something like:
> 
>                 smi0: mdio@72000 {
>                         device_type = "mdio";
>                         compatible = "marvell,orion-mdio";
>                         reg = <0x72004 0x4>;
> 
>                         #address-cells = <1>;
>                         #size-cells = <0>;
>                         PHY1: ethernet-phy@1 {
>                                 reg = <1>;
>                                 device_type = "ethernet-phy";
>                                 phy-id = <0x01410e90>;
>                         };
>                 };
> 
>                 egiga0 {
>                         device_type = "network";
>                         compatible = "marvell,mv643xx-eth";
>                         reg = <0x72000 0x4000>;
>                         port_number = <0>;
>                         phy-handle = <&PHY1>;
>                         interrupts = <11>;
>                         local-mac-address = [000000000002];  /* Filled by
> boot loader */ };
> 
> Regards,
> Jason

-- 
Florian
