Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaA2Ju4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:50:56 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:55846 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386AbaA2Jux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:50:53 -0500
Date: Wed, 29 Jan 2014 15:20:31 +0530
From: Pratyush Anand <pratyush.anand@st.com>
To: Kishon Vijay Abraham I <kishon@ti.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Mohit KUMAR DCG <Mohit.KUMAR@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <spear-devel@list.st.com>
Subject: Re: Query: Phy: How to find consumer device on dt platform
Message-ID: <20140129095031.GA2287@pratyush-vbox>
References: <20140128141356.GC3519@pratyush-vbox>
 <52E7BE91.8030209@ti.com>
 <201401282226.24197.arnd@arndb.de>
 <52E894A4.8050303@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <52E894A4.8050303@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd / Kishon,

Thanks for your inputs.

On Wed, Jan 29, 2014 at 01:41:56PM +0800, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Wednesday 29 January 2014 02:56 AM, Arnd Bergmann wrote:
> > On Tuesday 28 January 2014, Kishon Vijay Abraham I wrote:
> >>> I have a common set of registers, which need to be programmed
> >>> differently for PCIe and SATA during phy init/exit.
> >>
> >> One way is differentiate using different compatible strings fro pcie and sata
> >> and use of_device_is_compatible to select a particular path.
> > 
> > But if the IP block is the same, the compatible string should be
> > identical.
> 
> Actually we define the compatible for 'device' no?. Here the same IP is
> configured differently as different devices in SoCs.
> > 
> >>> Therefore, in the init/exit routine of phy_ops, I need some way of
> >>> identifying that phy_init/exit has been called from PCIe driver or
> >>> SATA driver.
> >>
> >> In this case you'll be actually registering two different PHYs (each for pcie
> >> and sata), so your phy_get should give you the only the appropriate phy.
> > 
> > I would instead recommend making the mode of the PHY device the
> > argument to the phy handle in DT, so that the sata node uses
> > 
> > 	phys = <&phyA 0>;
> > 
> > and the PCIe node uses
> > 
> > 	phys = <&phyB 1>;
> > 
> > Then the binding for the phy defines that an argument of '0' means sata mode,
> > while '1' means pcie mode, plus you should define all other valid modes.

Probably, it may  not help in this case. How would *phys* defining as
above with PCIe/SATA node help phy driver to decide whether current
phy instance is associated with PCIe or SATA. Actually, there is no
way to pass information from phy consumer driver(pcie/sata driver in
this case) to phy driver.

> 
> Anyway phyA and phyB points to different nodes and just from phyA and phyB we
> should be able to tell whether it is sata or pcie.

We have multiple instances (say 3) of same phy, which can be
programmed either for pcie or for sata. We have multiple instances of
ahci and pcie controller. phy_n will be connected to either ahci_n or
pcie_n.

What Kishon has suggested here is exactly what I was thinking.
I think, we should go with this.

> 
> We can just have a property in phyA to specify it is SATA and phyB to specify
> it is PCIE.
> phyA {
> 	compatible="phy-pipe3";
> 	.
> 	.
> 	type=<SATA>;
> }
> phyB {
> 	compatible="phy-pipe3";
> 	.
> 	.
> 	type=<PCIE>;
> }
> Then in probe
> 	of_property_read_u32(node, "type", &pipe3->type);
> 
> In phy_init function we can follow different path for SATA and PCIE using the type
> 
> static int pipe3_init(struct phy *x) {
> 	struct pipe3 *phy = phy_get_drvdata(x);
> 
> 	switch (phy->type) {
> 	case SATA:
> 		/* do sata phy initialization here*/
> 		break;
> 	case PCIE:
> 		/* do pcie phy initialization here*/
> 		break;
> 	default:
> 		dev_err(phy->dev, "phy type not supported\n");
> 	}
> 
> 	return 0;
> }
> 
> Cheers
> Kishon

Regards
Pratyush
