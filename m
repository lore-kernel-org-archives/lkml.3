Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaA2Njo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 08:39:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:65130 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaA2Njn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 08:39:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: Query: Phy: How to find consumer device on dt platform
Date: Wed, 29 Jan 2014 14:39:37 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Pratyush Anand <pratyush.anand@st.com>, Mohit Kumar <mohit.kumar@st.com>,
        linux-kernel@vger.kernel.org
References: <20140128141356.GC3519@pratyush-vbox> <201401282226.24197.arnd@arndb.de> <52E894A4.8050303@ti.com>
In-Reply-To: <52E894A4.8050303@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401291439.37578.arnd@arndb.de>
X-Provags-ID: V02:K0:OO07VDbf5Lbzx1NNkzKS7iKDNUOt0z/NoaW9xGjlkEp
 B4iBT4X9rqLPxf/mEKJjNf3t2ffX3ZwpWcmw8tPkl0kRBVa6Ig
 fqO99uh2DY9ZNdLrijma31s/sUCc+WkEGuDFvD69NdCtDMYd1R
 o1Pqpq4Fq5/YYrLg4q5+NgSQQrMcl3YEHRF0ga+bNdh5mZnoau
 STzAm0SyPW0KVSHli9poc9GykShF/QYLzdrz4hva2w/IL47n8a
 +qy/lTmiQvrfOeraAme2X9UOZEMZBS+E+GJtPsViyzXmqNTb4p
 rUe//RPb/BcBAhBETUEvN1CJi2PW8HYybWh9XVCcJqaenjTufJ
 /2C23SeDCDUKLokuxJcTz9K2r0/fpIDzUQvfKS7Gj
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 January 2014, Kishon Vijay Abraham I wrote:
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
> 
> Anyway phyA and phyB points to different nodes and just from phyA and phyB we
> should be able to tell whether it is sata or pcie.
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

But this would be contrary to how we handle all other such devices.

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

I understand that it can be done, but that doesn't make it a good idea.
Take interrupt controllers as another example: the irqchip node provides
a set of identical resources (interrupt lines) that are connected to
various other parts of the SoC and external sources. You have to somehow
configure each line (edge/level, polarity, ...), but we intentionally
keep the configuration out of the node that describes the irq chip and
instead put it into the nodes that use it.

	Arnd
