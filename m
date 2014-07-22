Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaGVNzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:55:45 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:39482 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaGVNzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:55:44 -0400
Date: Tue, 22 Jul 2014 14:55:34 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@stlinux.com,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        peter.griffin+familyguy@linaro.org
Subject: Re: [RFC PATCH] usb: dwc3: core: allow vendor drivers to check probe
 status
Message-ID: <20140722135534.GB6817@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1405617213-27360-1-git-send-email-lee.jones@linaro.org>
 <20140717172045.GM10459@saruman.home>
 <20140718071115.GH30888@lee--X1>
 <20140718144044.GJ24914@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140718144044.GJ24914@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

Sorry for the delay in replying. I've been trying to get to the root cause
of this problem so I could reply which took longer than I had hoped.

The problem manifested itself as a hang on register read/write access if dwc3-st 
probed before the usb3 phy. Even though dwc3 core would bail and return 
-EPROBE_DEFER that is not propogated up through of_platform_populate.

<snip>
> 
> yeah, because glue layers are not supposed to know. There should be no
> coupling what so ever between glue layer and core driver, other than the
> fact that glue layer is the one which triggers platform_device creation
> through of_platform_population(). But the glue layer has (or should
> have) no interest in exactly when the core driver finishes probing.

Thanks for this clue :-) As it got me debugging why there was this dependency
between the usb3 phy IP and the ST glue register wrapper around the dwc3 usb core.

The reason for the depedency / hang is that there is a shared reset signal
for the dwc3 core, glue registers and usb3 phy. This reset signal was only
being managed in the USB3 phy driver, which is why if dwc3-st or dwc3 did
any register access it would cause a hang.

So the solution is in addition to taking the devm_reset_control for the powerdown
signal, in V3 of the dwc3-st glue layer, it also gets the softreset signal,
and deasserts this before any register accesses.

This is now working properly without any init ordering hacks etc.

> 
> > commit message, another way of ensuring the PHYs are available is to
> > request them, but this would mean an awful lot of code duplication.
> > 
> > In your opinion, what's the best way to handle this?
> 
> How can I know ? You still haven't fully explained what you need. All
> you said was that you're trying to "configure through the glue-layer".

We can forget about this now. Having dwc3-st take a reference on the usb3 phys was
just another method I was experimenting with to find out whether the usb3 
PHY had probed or not.

> 
> Care to further explain what the problem really is ? I'm assuming below
> is what you're concerned about which I had to go dig in the archives
> because there was no reference to that patch anywhere here.

Hopefully I have now above, and the proposed solution.

> 
> > +static void st_dwc3_init(struct st_dwc3 *dwc3_data)
> > +{
> > +	u32 reg = st_dwc3_readl(dwc3_data->glue_base, USB2_CLKRST_CTRL);
> > +
> > +	reg |= aux_clk_en(1) | ext_cfg_reset_n(1) | xhci_revision(1);
> 
> so you have auxiliary clock, an external config reset, what's this
> xhci_revision ?

xhci_revision is an input signal to the dwc3 core, if it is asserted then
the host controller compiles with the xHCI revision 1.0 spec, if not it
complies with xHCI revision 0.96 spec. This input signal to dwc3 core is 
exposed in the CLKRST_CTRL glue register wrapped around the controller by ST.

Looking through the docs, it was present until 2.40a, then removed as an input signal
to the core from 2.50a onwards.

To make this clearer I have also added a comment above the xhci_revision macro
in V3 of the dwc3-st patches explaining the bitfield and what it does.


> looks like it should be split between a CCF and reset drivers. Or maybe
> a single driver which does both. Do you have a clock/reset control for
> all IPs ?

Yes most IPs which have reset or powerdown signals are already controlled by
a driver in drivers/reset/sti. These reset and powerdown signals are all exposed
in the sysconfig registers of the SoC. Indeed it was a shared reset signal 
which wasn't being properly managed and causing the hang.

However the reset signal and clock gate here is controlling a small piece of
wrapper IP called pipew which sits between the dwc3 core and usb3 phy. 
I believe this pipew protocol wrapper hardware is designed internally 
by ST, and has some special contriants which is why these reset signals
are being exposed here in the glue logic (see below).

>  That might be a good way to hide stuff, driver would simply
> call clk_get()/clk_prepare_enable() and reset_assert()/deassert() when
> necessary (sure, this doesn't solve the 'when has that guy probe' but
> you still haven't explained why you need it).
> 
> > +	reg = st_dwc3_readl(dwc3_data->glue_base, USB2_VBUS_MNGMNT_SEL1);
> > +	reg |= SEL_OVERRIDE_VBUSVALID(1) | SEL_OVERRIDE_POWERPRESENT(1) |
> > +	    SEL_OVERRIDE_BVALID(1);
> 
> this is not correct. You don't know if VBUS is really valid at this
> time. We have used a gpio which gets pull high/low depending on the
> state of VBUS/ID.

This isn't stating that VBUS is valid, it is configuring a mux to select where 
the vbus / bvalid / powerpresent signals will be selected from.

I have added a better comment in V3 which hopefully makes the function of
VBUS_MNGMNT_SEL register clearer.

> 
> > +	st_dwc3_writel(dwc3_data->glue_base, USB2_VBUS_MNGMNT_SEL1, reg);
> > +	udelay(100);
> > +
> > +	reg = st_dwc3_readl(dwc3_data->glue_base, USB2_CLKRST_CTRL);
> > +	reg |= sw_pipew_reset_n(1);
> > +	st_dwc3_writel(dwc3_data->glue_base, USB2_CLKRST_CTRL, reg);
> 
> let me ask you something else. Isn't the DWC3_GUSB3PIPECTL_PHYSOFTRST
> bit functional for you guys ? This sw_pipe2_reset_n looks suspicious.

Your right to be suspicious ;-)

Due to a constriant on the pipew hardware, they have provided two extra
software controlled  resets ext_cfg_reset and sw_pipew_reset in the CLKRST_CTRL
glue reg.

These two software controlled resets are ANDED with the nominal cfg_reset_n
and pipe_reset_n resets to the pipew hardware.

So yes DWC3_GUSB3PIPECTL_PHYSOFTRST is functional, but it will only 
actually issue a reset to pipew and then onto MiPHY if sw_pipew_reset_n
is also set in the glue. The same goes with the global bus_reset_n signal 
which is subsystem wide reset, it will only bepropogated to pipew if 
ext_cfg_reset is also set in CLKRST_CTRL.

Hopefully that makes things clearer and I've answered everything. 
I intend to send a V3 shortly.

kind regards,

Peter.


