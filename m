Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbaKDS5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 13:57:34 -0500
Received: from mga01.intel.com ([192.55.52.88]:20355 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbaKDS5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:57:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,314,1413270000"; 
   d="scan'208";a="626455349"
Date: Tue, 4 Nov 2014 20:57:02 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        stable <stable@vger.kernel.org>, mathias.nyman@linux.intel.com
Subject: Re: [PATCH] pinctrl: baytrail: show output gpio state correctly on
 Intel Baytrail
Message-ID: <20141104185702.GR1618@lahna.fi.intel.com>
References: <20141031184509.GA2224@psi-dev26.jf.intel.com>
 <20141103092402.GA1304@lahna.fi.intel.com>
 <20141103150048.GB27425@saruman>
 <20141103152743.GB1618@lahna.fi.intel.com>
 <20141103154207.GC1618@lahna.fi.intel.com>
 <20141103155011.GH27425@saruman>
 <20141103184247.GD1618@lahna.fi.intel.com>
 <20141103221903.GA20305@psi-dev26.jf.intel.com>
 <20141104075936.GF1618@lahna.fi.intel.com>
 <20141104180526.GB2224@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104180526.GB2224@psi-dev26.jf.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 10:05:26AM -0800, David Cohen wrote:
> On Tue, Nov 04, 2014 at 09:59:36AM +0200, Mika Westerberg wrote:
> > On Mon, Nov 03, 2014 at 02:19:03PM -0800, David Cohen wrote:
> > > Hi Mika,
> > > 
> > > Thanks for your feedbacks :)
> > > 
> > > On Mon, Nov 03, 2014 at 08:42:47PM +0200, Mika Westerberg wrote:
> > > > On Mon, Nov 03, 2014 at 09:50:11AM -0600, Felipe Balbi wrote:
> > > > > Hi,
> > > > > 
> > > > > On Mon, Nov 03, 2014 at 05:42:07PM +0200, Mika Westerberg wrote:
> > > > > > On Mon, Nov 03, 2014 at 05:27:43PM +0200, Mika Westerberg wrote:
> > > > > > > On Mon, Nov 03, 2014 at 09:00:48AM -0600, Felipe Balbi wrote:
> > > > > > > > On Mon, Nov 03, 2014 at 11:24:02AM +0200, Mika Westerberg wrote:
> > > > > > > > > On Fri, Oct 31, 2014 at 11:45:09AM -0700, David Cohen wrote:
> > > > > > > > > > > I think adding the module exit + allowing this driver to be a module
> > > > > > > > > > > would be a good approach. Then we don't need to force generic x86 kernel
> > > > > > > > > > > binaries to always have this driver. Unless Mathias or Mika knows a
> > > > > > > > > > > constraint to force this driver to be builtin only.
> > > > > > > > > > 
> > > > > > > > > > It helps if I CC them when asking for feedback :)
> > > > > > > > > > 
> > > > > > > > > > Mathias, Mika, do you know any constraint that forces pinctrl-baytrail
> > > > > > > > > > to be bool?
> > > > > > > > > 
> > > > > > > > > The only constraint that has been keeping this driver as bool is that
> > > > > > > > > some machines like, Asus T100, uses ACPI GPIO operation regions for
> > > > > > > > > toggling GPIOs to get things like sensor hub powered on. The GPIO
> > > > > > > > > operation region code does not yet handle -EPROBE_DEFER so only way to
> > > > > > > > > ensure that the operation region is there is to have the driver compiled
> > > > > > > > > in to the kernel.
> > > > > > > > 
> > > > > > > > But that's not enough excuse to have every single x86 in the market
> > > > > > > > shipping with this driver. Think about a distro kernel, most likely this
> > > > > > > > gets enabled and it's wrong in 80% of the cases.
> > > > > > > 
> > > > > > > True, but see below.
> > > > > > > 
> > > > > > > > It would be nicer to add EPROBE_DEFER support, convert this into
> > > > > > > > tristate and have default = M if BAYTRAIL, or something.
> > > > > > > 
> > > > > > > If it were simple as that we would have done that already. Please check
> > > > > > > drivers/gpio/gpiolib-acpi.c:acpi_gpio_adr_space_handler() and tell me
> > > > > > > how we can do that.
> > > > > > 
> > > > > > Actually the above is not the problem because we already have registered
> > > > > > the GPIO chip and hence we have the GPIO available to the firmware code.
> > > > > 
> > > > > what happens before you registered the gpio chip ? It takes some time
> > > > > from head.S to gpiochip_irqchip_add(). Anywhere between that time,
> > > > > firmware could try to access gpios and the same problem would occur.
> > > > 
> > > > The operation region is not ready and the firmware does not try to use
> > > > it. However, the subsys_initcall() is there just to be sure that the
> > > > GPIO driver gets loaded before anything that is going to use GPIOs from
> > > > firmware.
> > > 
> > > That sounds hackish and dangerous. There are shared registers between
> > > different GPIOs.
> > 
> > For one it certainly is not hackish and dangerous. It is well defined
> > in the ACPI specification as interfaces between firmware and OS.
> 
> It looks we have an implicit dependency to GPIO driver in Bay Trail, and
> having this window until load the module is not acceptable to fulfill
> this implicit dependency.

It is not implicit at all.

The user of the GPIO in ACPI DSDT table says something like:

	Name (_DEP, Package () { \_SB.GPO2 })

or similar. That is *explicit* dependency. Here \_SB.GPO2 is one of the
GPIO banks.

> But IMHO all dependency to a driver should be explicitly described
> (e.g. on Kconfigs, or maybe failing probe). With current situation if we
> do not select pinctrl_baytrail, instead of affecting just the drivers
> that explicitly depend on that, it affects others which we are unable to
> easily identify.

So how do you propose we describe the dependency? It is completely in
firmware. Should we make i2c-hid.c dependent on pinctrl-baytrail.c just
because some underlying firmware method (_PSx for example) needs the
GPIO but the driver itself does not?

> Maybe I don't like or fully agreee/understand ACPI, but I'd call that
> dangerous.
>
> > 
> > > > > > The real problem is that if the ACPI GPIO operation handler is not there
> > > > > > at the time firmware decides to do something it will just skip things
> > > > > > that depend on the operation region. So if it has a GPIO that is used to
> > > > > > turn on sensor hub or touch panel or whatever, this will not be done and
> > > > > > it results that the device in question might not work properly.
> > > > > 
> > > > > that's an issue that needs solving, but forcing every x86 kernel to ship
> > > > > with this driver, is not a proper solution.
> > > > 
> > > > I would rather have the driver build in to the kernel now (and btw it
> > > > has been already in mainline quite some time so I suspect many distros
> > > > have already enabled it), than turning it module and render some devices
> > > > that have been working previously, fail suddenly.
> > > 
> > > Hm.... it sounds like we're saying: we got it working somehow and from
> > > now on we'll avoid change it to not create regression.
> > 
> > That's exactly what I'm saying :-)
> 
> In this case, I think we need to carefully document our concerns about
> the driver to help others not involved in original implementation to
> easily contribute to it.
>
> > 
> > > Correct if I'm wrong, but there's nothing really preventing this driver
> > > to be a module beside the buggy ACPI interface that allows kernel and fw
> > > to play freely (and silently) with same piece of hw.
> > 
> > Not a buggy ACPI interface. Lack of implementation from Linux side.
> > 
> > > IMHO we could allow this driver be M, but default to Y and an
> > > explanation to set to Y in case FW needs to use GPIO before module gets
> > > loaded. Since we've development board (Minnow Max), we should let kernel
> > > more free for other developers as well.
> > 
> > All I'm saying both to you guys that this is the reasoning we have the
> > driver as a bool. Which is what you asked from me in the first place.
> 
> I apology for my frustration :)
> You've been more than helpful clarifying our questions.
> 
> > 
> > Since you both insist to turn it module, please send a patch with the
> > corresponding changelog telling why you think it does not need to build
> > in and let's see if we are getting any regressions. If yes, then we just
> > revert the patch. Does that work for you?
> 
> I'm in favor of not hardcoding kernel features based on possible hidden
> things that may happen on closed source FWs.
> Having the module option does help further development of this driver
> and others that depend on it. A clear explanation on Kconfig why we
> recommend Y for production and why M is still experimental should be
> enough to guide ppl working on distributions and at same time help
> kernel developers involved with the driver.

Like I said, send a patch describing why you think it needs to be module
and make it tristate instead. If it causes problems we can revert it.
