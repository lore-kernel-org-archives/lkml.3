Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbaGKHo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:44:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39861 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbaGKHoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:44:23 -0400
Date: Fri, 11 Jul 2014 08:44:17 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-arm-kernel@lists.infradead.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        gregkh@linuxfoundation.org, srinivas.kandagatla@gmail.com,
        USB list <linux-usb@vger.kernel.org>, devicetree@vger.kernel.org,
        lee.jones@linaro.org
Subject: Re: [PATCH 1/3] usb: host: st-hcd: Add USB HCD support for STi SoCs
Message-ID: <20140711074417.GA8233@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1405005486-26355-2-git-send-email-peter.griffin@linaro.org>
 <Pine.LNX.4.44L0.1407101154070.1492-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1407101154070.1492-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Thanks for reviewing.

On Thu, 10 Jul 2014, Alan Stern wrote:

> On Thu, 10 Jul 2014, Peter Griffin wrote:
> 
> > This driver adds support for the USB HCD present in STi
> > SoC's from STMicroelectronics. It has been tested on the
> > stih416-b2020 board.
> 
> This driver file, along with the Kconfig changes, belongs in the
> arch/platform-specific source directory.  Not in drivers/usb/host/.  
> It is, after all, a platform driver that registers two platform
> devices.

Why do think that?

AFAIK certainly for ARM we are trying NOT to add code
under the arch/platform directorys and get the code into the relevant subsystems.

In order to prove the above if you look in drivers/usb/host/ there are many other 
similar platform drivers for other SoC families: -
bcma-hcd.c
ehci-atmel.c
ssb-hcd.c
ehci-exynos.c
ehci-fsl.c
ehci-mxc.c 
ehci-omap.c
ehci-orion.c
ohci-nxp.c
and more, but you get the idea. In short I believe this to be the correct directory :-)

> 
> > +++ b/drivers/usb/host/Kconfig
> > @@ -753,6 +753,23 @@ config USB_HCD_SSB
> >  
> >  	  If unsure, say N.
> >  
> > +config USB_HCD_ST
> > +	tristate "STMicroelectronics STi family HCD support"
> 
> Why does this need to be tristate?  Why not always build it into the 
> kernel?  Or at least make it boolean rather than tristate.

Building as a module is useful on these embedded SoCs usually as a mechanism for speeding up boot time.
Anything which isn't critical to getting the core functionality of the device going (in this case decoding
TV and outputting on HDMI), can be deffered to a later point. Things like USB drivers, can then be loaded in
after that point (deffered module loading), to give the appearence of 'instant on' (which in consumer electronics
is what everyone wishes to achieve).

Going back to my examples above, most of these platforms are also defined as tristate.

> 
> > +	depends on ARCH_STI
> > +	select USB_OHCI_HCD_PLATFORM if USB_OHCI_HCD
> > +	select USB_EHCI_HCD_PLATFORM if USB_EHCI_HCD
> > +	select MFD_SYSCON
> > +	select GENERIC_PHY
> > +	help
> > +	  Enable support for the EHCI and OCHI host controller on ST
> 
> s/OCHI/OHCI/

Good spot, will fix in V2

> 
> > + 	  consumer electronics SoCs.
> > +
> > + 	  It converts the ST driver into two platform device drivers
> 
> It converts the ST driver?  That doesn't sound right at all.  You could 
> eliminate this paragraph completely and nobody would miss it.

I agree the wording is a little off there, I can remove or re-phrase it. What it is trying to express
is that it is slightly different to some other platform drivers, in that it creates two platform drivers one
for the ehci controller and the other for the OHCI controller. From looking at other drivers in this directory 
this driver is quite similar to USB_HCD_BCMA, which also deemed it noteworthy to mention in the help, although
phrased somewhat more succinctly.

regards,

Peter.
