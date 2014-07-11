Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbaGKVVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 17:21:09 -0400
Received: from netrider.rowland.org ([192.131.102.5]:58760 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751861AbaGKVVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 17:21:07 -0400
Date: Fri, 11 Jul 2014 17:21:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Peter Griffin <peter.griffin@linaro.org>
cc: linux-arm-kernel@lists.infradead.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <maxime.coquelin@st.com>, <patrice.chotard@st.com>,
        <gregkh@linuxfoundation.org>, <srinivas.kandagatla@gmail.com>,
        USB list <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lee.jones@linaro.org>
Subject: Re: [PATCH 1/3] usb: host: st-hcd: Add USB HCD support for STi SoCs
In-Reply-To: <20140711074417.GA8233@griffinp-ThinkPad-X1-Carbon-2nd>
Message-ID: <Pine.LNX.4.44L0.1407111656170.17043-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014, Peter Griffin wrote:

> Hi Alan,
> 
> Thanks for reviewing.
> 
> On Thu, 10 Jul 2014, Alan Stern wrote:
> 
> > On Thu, 10 Jul 2014, Peter Griffin wrote:
> > 
> > > This driver adds support for the USB HCD present in STi
> > > SoC's from STMicroelectronics. It has been tested on the
> > > stih416-b2020 board.
> > 
> > This driver file, along with the Kconfig changes, belongs in the
> > arch/platform-specific source directory.  Not in drivers/usb/host/.  
> > It is, after all, a platform driver that registers two platform
> > devices.
> 
> Why do think that?

Because it is true.  One can easily see that st-hcd.c is a platform
driver: It contains a module_platform_driver() line and a struct
platform_driver definition near the end.  And it registers a platform
device by calling platform_device_add() in st_hcd_device_create(),
which is called twice by st_hcd_probe().

> AFAIK certainly for ARM we are trying NOT to add code
> under the arch/platform directorys and get the code into the relevant subsystems.

This does not agree with my experiences.

> In order to prove the above if you look in drivers/usb/host/ there are many other 
> similar platform drivers for other SoC families: -
> bcma-hcd.c
> ehci-atmel.c
> ssb-hcd.c
> ehci-exynos.c
> ehci-fsl.c
> ehci-mxc.c 
> ehci-omap.c
> ehci-orion.c
> ohci-nxp.c
> and more, but you get the idea. In short I believe this to be the
> correct directory :-)

No.  bcma-hcd.c and ssb-hcd.c are similar to your st-hcd.c, but the
others aren't.

Take ehci-atmel.c as a typical example.  It does not define any
ehci_pdata structure and does not call platform_device_add(); instead
it calls usb_add_hcd().  The others work the same way.  I would suggest
that bcma-hcd.c and ssb-hcd.c don't belong in drivers/usb/host either.

For examples of drivers that _do_ resemble st-hcd.c, look in:

arch/arm/mach-cns3xxx/cns3420vb.c
arch/arm/mach-cns3xxx/core.c
arch/arm/mach-shmobile/setup-r8a7778.c
arch/arm/mach-shmobile/setup-r8a7779.c
arch/arm/mach-omap2/board-cm-t3517.c
arch/mips/netlogic/xlr/platform.c
arch/mips/ath79/dev-usb.c
arch/mips/loongson1/common/platform.c
arch/mips/alchemy/common/platform.c

These files all define ehci_pdata structures and register platform 
devices.  And they obviously are all located in arch/platform-specific 
directories.

> > > +++ b/drivers/usb/host/Kconfig
> > > @@ -753,6 +753,23 @@ config USB_HCD_SSB
> > >  
> > >  	  If unsure, say N.
> > >  
> > > +config USB_HCD_ST
> > > +	tristate "STMicroelectronics STi family HCD support"
> > 
> > Why does this need to be tristate?  Why not always build it into the 
> > kernel?  Or at least make it boolean rather than tristate.
> 
> Building as a module is useful on these embedded SoCs usually as a mechanism for speeding up boot time.
> Anything which isn't critical to getting the core functionality of the device going (in this case decoding
> TV and outputting on HDMI), can be deffered to a later point. Things like USB drivers, can then be loaded in
> after that point (deffered module loading), to give the appearence of 'instant on' (which in consumer electronics
> is what everyone wishes to achieve).

But st-hcd.c takes very little time to run.  ehci-platform will cause a 
delay, so it makes sense for ehci-platform to be a module.  But there's 
no reason for st-hcd to be a module.

> Going back to my examples above, most of these platforms are also defined as tristate.

Probably for historical reasons.  They don't need to be tristate now.

> > > + 	  consumer electronics SoCs.
> > > +
> > > + 	  It converts the ST driver into two platform device drivers
> > 
> > It converts the ST driver?  That doesn't sound right at all.  You could 
> > eliminate this paragraph completely and nobody would miss it.
> 
> I agree the wording is a little off there, I can remove or re-phrase it. What it is trying to express
> is that it is slightly different to some other platform drivers, in that it creates two platform drivers one

It creates two platform _devices_, not two platform _drivers_.

> for the ehci controller and the other for the OHCI controller.

In that respect it is very similar to the drivers I listed above.

>  From looking at other drivers in this directory 
> this driver is quite similar to USB_HCD_BCMA, which also deemed it noteworthy to mention in the help, although
> phrased somewhat more succinctly.

People reading the Kconfig help text don't care what other drivers are 
similar to yours.  All they want to know is whether or not they should 
enable your driver.

Alan Stern

