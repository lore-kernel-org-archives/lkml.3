Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaGNIgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:36:03 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:64610 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbaGNIf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:35:56 -0400
Date: Mon, 14 Jul 2014 09:35:49 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Peter Griffin <peter.griffin@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        gregkh@linuxfoundation.org, srinivas.kandagatla@gmail.com,
        USB list <linux-usb@vger.kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/3] usb: host: st-hcd: Add USB HCD support for STi SoCs
Message-ID: <20140714083549.GK2954@lee--X1>
References: <20140711074417.GA8233@griffinp-ThinkPad-X1-Carbon-2nd>
 <Pine.LNX.4.44L0.1407111656170.17043-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.1407111656170.17043-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014, Alan Stern wrote:
> On Fri, 11 Jul 2014, Peter Griffin wrote:
> > On Thu, 10 Jul 2014, Alan Stern wrote:
> > 
> > > On Thu, 10 Jul 2014, Peter Griffin wrote:
> > > 
> > > > This driver adds support for the USB HCD present in STi
> > > > SoC's from STMicroelectronics. It has been tested on the
> > > > stih416-b2020 board.
> > > 
> > > This driver file, along with the Kconfig changes, belongs in the
> > > arch/platform-specific source directory.  Not in drivers/usb/host/.  
> > > It is, after all, a platform driver that registers two platform
> > > devices.
> > 
> > Why do think that?
> 
> Because it is true.  One can easily see that st-hcd.c is a platform
> driver: It contains a module_platform_driver() line and a struct
> platform_driver definition near the end.  And it registers a platform
> device by calling platform_device_add() in st_hcd_device_create(),
> which is called twice by st_hcd_probe().

You are correct that this is indeed a platform driver and in the 'old
days' these would have been stuffed into the ARM sub-architecture
directories.  However, these became far too bloated and created too
much churn which angered Linus.  A great deal has changed since his
ARM rant [1].  All drivers (platform or otherwise) are now to live in
'drivers', which makes a great deal of sense really, doesn't it?

Did you grep kernel wide for module_platform_driver()?

$ git grep module_platform_driver -- arch/ | wc -l
12

$ git grep module_platform_driver -- drivers/ | wc -l
1138

Most platform drivers have already been moved.

> > AFAIK certainly for ARM we are trying NOT to add code
> > under the arch/platform directorys and get the code into the relevant subsystems.
> 
> This does not agree with my experiences.

Then you haven't been following what's been going on for the past 3
years or so.  The majority of platform drivers have been moved out to
drivers.  Hence the creation of some fantastic new subsystems, such as
clk and pinctrl, to name but two.  These (and others) were realised as
part of a push to consolidate and remove all driver code out of the
arch directories.

> > In order to prove the above if you look in drivers/usb/host/ there are many other 
> > similar platform drivers for other SoC families: -
> > bcma-hcd.c
> > ehci-atmel.c
> > ssb-hcd.c
> > ehci-exynos.c
> > ehci-fsl.c
> > ehci-mxc.c 
> > ehci-omap.c
> > ehci-orion.c
> > ohci-nxp.c
> > and more, but you get the idea. In short I believe this to be the
> > correct directory :-)
> 
> No.  bcma-hcd.c and ssb-hcd.c are similar to your st-hcd.c, but the
> others aren't.
> 
> Take ehci-atmel.c as a typical example.  It does not define any
> ehci_pdata structure and does not call platform_device_add(); instead
> it calls usb_add_hcd().  The others work the same way.  I would suggest
> that bcma-hcd.c and ssb-hcd.c don't belong in drivers/usb/host either.
> 
> For examples of drivers that _do_ resemble st-hcd.c, look in:
> 
> arch/arm/mach-cns3xxx/cns3420vb.c
> arch/arm/mach-cns3xxx/core.c
> arch/arm/mach-shmobile/setup-r8a7778.c
> arch/arm/mach-shmobile/setup-r8a7779.c
> arch/arm/mach-omap2/board-cm-t3517.c
> arch/mips/netlogic/xlr/platform.c
> arch/mips/ath79/dev-usb.c
> arch/mips/loongson1/common/platform.c
> arch/mips/alchemy/common/platform.c
> 
> These files all define ehci_pdata structures and register platform 
> devices.  And they obviously are all located in arch/platform-specific 
> directories.

Right, these are all 'old' platforms.  There is no way these drivers
would be accepted into the architecture directories now days.

Drivers live in 'drivers'.

New platforms also have to have Device Tree support, so even platform
data (which I agree should live in arch/arm) doesn't live in
arch/arm/{mach,plat}-* anymore.  For many of the more modern
architectures the aforementioned directories are bare.

> > > > +++ b/drivers/usb/host/Kconfig
> > > > @@ -753,6 +753,23 @@ config USB_HCD_SSB
> > > >  
> > > >  	  If unsure, say N.
> > > >  
> > > > +config USB_HCD_ST
> > > > +	tristate "STMicroelectronics STi family HCD support"
> > > 
> > > Why does this need to be tristate?  Why not always build it into the 
> > > kernel?  Or at least make it boolean rather than tristate.
> > 
> > Building as a module is useful on these embedded SoCs usually as a mechanism for speeding up boot time.
> > Anything which isn't critical to getting the core functionality of the device going (in this case decoding
> > TV and outputting on HDMI), can be deffered to a later point. Things like USB drivers, can then be loaded in
> > after that point (deffered module loading), to give the appearence of 'instant on' (which in consumer electronics
> > is what everyone wishes to achieve).
> 
> But st-hcd.c takes very little time to run.  ehci-platform will cause a 
> delay, so it makes sense for ehci-platform to be a module.  But there's 
> no reason for st-hcd to be a module.
> 
> > Going back to my examples above, most of these platforms are also defined as tristate.
> 
> Probably for historical reasons.  They don't need to be tristate now.

I'm not going to get into this too much, but it is _my oppinion_ that
if a driver can be a module, the option for it to be a module should
exist.

[...]

[1] https://lkml.org/lkml/2011/3/17/492

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
