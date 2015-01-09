Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbbAIQTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 11:19:32 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56132 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbbAIQTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 11:19:30 -0500
Date: Fri, 9 Jan 2015 17:19:05 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Stefan Agner <stefan@agner.ch>
Cc: davem@davemloft.net, shawn.guo@linaro.org, u.kleine-koenig@pengutronix.de,
        fugang.duan@freescale.com, mark.rutland@arm.com, robh+dt@kernel.org,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, B38611@freescale.com, LW@KARO-electronics.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Subject: Re: [PATCH v2] net: fec: fix MDIO bus assignement for dual fec SoC's
Message-ID: <20150109161905.GL23940@pengutronix.de>
References: <1420812103-5865-1-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420812103-5865-1-git-send-email-stefan@agner.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:15:35 up 86 days,  3:29, 98 users,  load average: 0.00, 0.04,
 0.09
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 03:01:43PM +0100, Stefan Agner wrote:
> On i.MX28, the MDIO bus is shared between the two FEC instances.
> The driver makes sure that the second FEC uses the MDIO bus of the
> first FEC. This is done conditionally if FEC_QUIRK_ENET_MAC is set.
> However, in newer designs, such as Vybrid or i.MX6SX, each FEC MAC
> has its own MDIO bus. Simply removing the quirk FEC_QUIRK_ENET_MAC
> is not an option since other logic, triggered by this quirk, is
> still needed.
> 
> Furthermore, there are board designs which use the same MDIO bus
> for both PHY's even though the second bus would be available on the
> SoC side. Such layout are popular since it saves pins on SoC side.
> Due to the above quirk, those boards currently do work fine. The
> boards in the mainline tree with such a layout are:
> - Freescale Vybrid Tower with TWR-SER2 (vf610-twr.dts)
> - Freescale i.MX6 SoloX SDB Board (imx6sx-sdb.dts)
> 
> This patch adds a new quirk FEC_QUIRK_SINGLE_MDIO for i.MX28, which
> makes sure that the MDIO bus of the first FEC is used in any case.
> 
> However, the boards above do have a SoC with a MDIO bus for each FEC
> instance. But the PHY's are not connected in a 1:1 configuration. A
> proper device tree description is needed to allow the driver to
> figure out where to find its PHY. This patch fixes that shortcoming
> by adding a MDIO bus child node to the first FEC instance, along
> with the two PHY's on that bus, and making use of the phy-handle
> property to add a reference to the PHY's.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
> ---
> Yes, this breaks existing device trees, but it does this because
> those device trees were lacking proper description of the HW...
> IMHO, in this case, this is acceptable. We also do this in other
> cases, e.g. in the gic_arch_extn killing patchset:
> http://archive.arm.linux.org.uk/lurker/message/20150107.174235.3fc3a92f.en.html
> 
> Also, the two boards we are breaking are not very widespread:
> The Vybrid Tower is generally not very widespread and there is only
> the TWR-VF65GS10-PRO variant with TWR-SER2 affected. And the SoloX
> SDB board is not even generally available yet...
> 
> If we don't want to break the board, we could add the
> FEC_QUIRK_SINGLE_MDIO to Vybrid or/and i.MX6SX too. But then, we
> need to make the quirk conditional: If a MDIO node or phy-
> handle is specified, we should rely on the device tree information.
> However, this solution adds new code and complexity. Using the
> quirk for those SoC's just feels wrong. So I strongly advocate
> for the breaking variant.

IMO that's one step into the right direction. Describing the phys in the
device tree is absolutely necessary for the soloX boards since otherwise
it's pure luck when the MACs are connected to the right phys. I share
your opinion that it's best to break these two device trees.

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
