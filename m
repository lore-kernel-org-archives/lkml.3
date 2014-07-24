Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261AbaGXNCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:02:40 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:58335 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759219AbaGXNCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:02:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Peter Griffin <peter.griffin@linaro.org>, devicetree@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        patrice.chotard@st.com, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, srinivas.kandagatla@gmail.com,
        lee.jones@linaro.org, maxime.coquelin@st.com
Subject: Re: [PATCH v2 1/3] usb: host: st-hcd: Add USB HCD support for STi SoCs
Date: Thu, 24 Jul 2014 15:01:13 +0200
Message-ID: <5967609.vndF2bDyS1@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140724122254.GA15266@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1406199616-10533-1-git-send-email-peter.griffin@linaro.org> <11018717.Ey5qEJxGNJ@wuerfel> <20140724122254.GA15266@griffinp-ThinkPad-X1-Carbon-2nd>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ZG2NL3ywTs/XxwGEowpUY9T/9E7Coq+CUVqfQGsOI0u
 JC4CvvriXf9IpRMy7Wrs0G4+L6aYdw70hmOKPKa2Rhtbl7nVpo
 XDIB/0sPt5TYDgIwrFMwU+j3mbgM0rcYffOuRGUBHVX/zHjBUp
 /cRCK1GIoYxVriBl2iRS2bibXJn5u4EKMCRL10DyDSKXfs6i7A
 8Gv7DLoPZlsvFKcibxp4CQgdg3VRskw4rT+XV48CXUBwLKrcP4
 nGmr5taB9kEoq0BCiulz/Rv7QhdCHSHA2YrDzKCkkDbYfGP9RV
 /XM29NmCtmusWhg9FBDmKZ6zzdDkxPwIePvb0PjJypSUso7Cfr
 YSJXlCV2Ut/98nmkIxaQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2014 13:22:54 Peter Griffin wrote:
> Thanks for reviewing, see my comments below: -
> 
> > Unfortunately, this seems to be done in a rather strange way,
> > I suspect you'll have to start over, but I'll let Alan and Greg
> > weigh in.
> > 
> > > +
> > > +struct st_hcd_dev {
> > > +   int port_nr;
> > > +   struct platform_device *ehci_device;
> > > +   struct platform_device *ohci_device;
> > > +   struct clk *ic_clk;
> > > +   struct clk *ohci_clk;
> > > +   struct reset_control *pwr;
> > > +   struct reset_control *rst;
> > > +   struct phy *phy;
> > > +};
> > 
> > The way you do this apparently is to create a device that encapsulates
> > the OHCI and the EHCI and then goes on to create child devices that
> > are bound to the real drivers.
> 
> Yes, although this isn't the first driver to take that approach USB_HCD_BCMA
> (bcma-hcd.c) and USB_HCD_SSB (ssb-hcd.c) do much the same thing.

I just had a look at them, and I think the case is different here:

For the two bcma driver, there is a discoverable bus (bcma) rather than
the platform bus, and it only exposes one device, so the bcma-hcd driver
is actually needed so we get two device that can be bound to the regular
drivers.

For the ssb-hcd driver, it's less clear and that one could be
reworked into two separate drivers.

> > The way it should be done however is to put the two host controllers
> > into DT directly and describe their resources (phy, clock, reset, ...)
> > using the DT bindings for those.
> 
> I'm of course happy to change it if required. I see looking through that a lot 
> of other platforms do it the way you describe with a
> 
> ehci-<platname>.c and ohci-<platname>.c

Right. We are trying to  gradually move some of them over to use the
generic *hci-platform.c drivers though.

> > Depending on what kind of special requirements the ST version has,
> > this can be done either by using the generic ohci/ehci bindings
> > with extensions where necessary, or by creating a new binding and
> > new driver files that use 'ohci_init_driver'/'ehci_init_driver'
> > to inherit from the common code.
> > 
> > The first of the two approaches is preferred.
> 
> We don't have anything particularly special, just a couple of reset lines,
> clock, phy, etc.

Ok, good. Please see Documentation/devicetree/bindings/usb/usb-?hci.txt
then. You might actually be able to just use the existing drivers
without new code by just adding the proper DT nodes that follow these
bindings.

> > > +   pdev->dev.parent = &parent->dev;
> > > +   pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
> > > +   pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> > 
> > This is something we shouldn't ever do these days, the DMA settings
> > should come directly from DT without driver interaction.
> 
> Ok, I'll wait to hear the outcome of Greg/Alans views before either fixing
> it or starting over.

Ok.

	Arnd
