Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab3A2SNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 13:13:16 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:35577 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab3A2SNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 13:13:13 -0500
X-Greylist: delayed 828 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jan 2013 13:13:13 EST
Date: Tue, 29 Jan 2013 11:13:06 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Florian Fainelli <florian@openwrt.org>
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linuxppc-dev@lists.ozlabs.org,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH 5/5] mv643xx_eth: convert to use the Marvell Orion MDIO
 driver
Message-ID: <20130129181306.GF25646@obsidianresearch.com>
References: <1359473048-26551-1-git-send-email-florian@openwrt.org>
 <1359473048-26551-6-git-send-email-florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359473048-26551-6-git-send-email-florian@openwrt.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 04:24:08PM +0100, Florian Fainelli wrote:
> This patch converts the Marvell MV643XX ethernet driver to use the
> Marvell Orion MDIO driver. As a result, PowerPC and ARM platforms
> registering the Marvell MV643XX ethernet driver are also updated to
> register a Marvell Orion MDIO driver. This driver voluntarily overlaps
> with the Marvell Ethernet shared registers because it will use a subset
> of this shared register (shared_base + 0x4 - shared_base + 0x84). The
> Ethernet driver is also updated to look up for a PHY device using the
> Orion MDIO bus driver.

Can you finish off this job by making the mv643xx_eth driver accept
the standard phy-handle OF property instead of using a phy address?

Ie the end result should be something like:

                smi0: mdio@72000 {
                        device_type = "mdio";
                        compatible = "marvell,orion-mdio";
                        reg = <0x72004 0x4>;

                        #address-cells = <1>;
                        #size-cells = <0>;
                        PHY1: ethernet-phy@1 {
                                reg = <1>;
                                device_type = "ethernet-phy";
                                phy-id = <0x01410e90>;
                        };
                };

                egiga0 {
                        device_type = "network";
                        compatible = "marvell,mv643xx-eth";
                        reg = <0x72000 0x4000>;
                        port_number = <0>;
                        phy-handle = <&PHY1>;
                        interrupts = <11>;
                        local-mac-address = [000000000002];  /* Filled by boot loader */
                };

Regards,
Jason
