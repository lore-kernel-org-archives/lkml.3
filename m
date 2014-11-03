Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750887AbaKCWSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 17:18:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:8360 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbaKCWSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 17:18:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,309,1413270000"; 
   d="scan'208";a="601529124"
Date: Mon, 3 Nov 2014 14:19:03 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        stable <stable@vger.kernel.org>, mathias.nyman@linux.intel.com
Subject: Re: [PATCH] pinctrl: baytrail: show output gpio state correctly on
 Intel Baytrail
Message-ID: <20141103221903.GA20305@psi-dev26.jf.intel.com>
References: <CACRpkdaN5hNWFUOFbHLm8HgZEKVSETUgVF4Cn4UbMQxNEg46Vw@mail.gmail.com>
 <20141031132005.GB1273@saruman>
 <20141031162339.GA7136@psi-dev26.jf.intel.com>
 <20141031184509.GA2224@psi-dev26.jf.intel.com>
 <20141103092402.GA1304@lahna.fi.intel.com>
 <20141103150048.GB27425@saruman>
 <20141103152743.GB1618@lahna.fi.intel.com>
 <20141103154207.GC1618@lahna.fi.intel.com>
 <20141103155011.GH27425@saruman>
 <20141103184247.GD1618@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141103184247.GD1618@lahna.fi.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mika,

Thanks for your feedbacks :)

On Mon, Nov 03, 2014 at 08:42:47PM +0200, Mika Westerberg wrote:
> On Mon, Nov 03, 2014 at 09:50:11AM -0600, Felipe Balbi wrote:
> > Hi,
> > 
> > On Mon, Nov 03, 2014 at 05:42:07PM +0200, Mika Westerberg wrote:
> > > On Mon, Nov 03, 2014 at 05:27:43PM +0200, Mika Westerberg wrote:
> > > > On Mon, Nov 03, 2014 at 09:00:48AM -0600, Felipe Balbi wrote:
> > > > > On Mon, Nov 03, 2014 at 11:24:02AM +0200, Mika Westerberg wrote:
> > > > > > On Fri, Oct 31, 2014 at 11:45:09AM -0700, David Cohen wrote:
> > > > > > > > I think adding the module exit + allowing this driver to be a module
> > > > > > > > would be a good approach. Then we don't need to force generic x86 kernel
> > > > > > > > binaries to always have this driver. Unless Mathias or Mika knows a
> > > > > > > > constraint to force this driver to be builtin only.
> > > > > > > 
> > > > > > > It helps if I CC them when asking for feedback :)
> > > > > > > 
> > > > > > > Mathias, Mika, do you know any constraint that forces pinctrl-baytrail
> > > > > > > to be bool?
> > > > > > 
> > > > > > The only constraint that has been keeping this driver as bool is that
> > > > > > some machines like, Asus T100, uses ACPI GPIO operation regions for
> > > > > > toggling GPIOs to get things like sensor hub powered on. The GPIO
> > > > > > operation region code does not yet handle -EPROBE_DEFER so only way to
> > > > > > ensure that the operation region is there is to have the driver compiled
> > > > > > in to the kernel.
> > > > > 
> > > > > But that's not enough excuse to have every single x86 in the market
> > > > > shipping with this driver. Think about a distro kernel, most likely this
> > > > > gets enabled and it's wrong in 80% of the cases.
> > > > 
> > > > True, but see below.
> > > > 
> > > > > It would be nicer to add EPROBE_DEFER support, convert this into
> > > > > tristate and have default = M if BAYTRAIL, or something.
> > > > 
> > > > If it were simple as that we would have done that already. Please check
> > > > drivers/gpio/gpiolib-acpi.c:acpi_gpio_adr_space_handler() and tell me
> > > > how we can do that.
> > > 
> > > Actually the above is not the problem because we already have registered
> > > the GPIO chip and hence we have the GPIO available to the firmware code.
> > 
> > what happens before you registered the gpio chip ? It takes some time
> > from head.S to gpiochip_irqchip_add(). Anywhere between that time,
> > firmware could try to access gpios and the same problem would occur.
> 
> The operation region is not ready and the firmware does not try to use
> it. However, the subsys_initcall() is there just to be sure that the
> GPIO driver gets loaded before anything that is going to use GPIOs from
> firmware.

That sounds hackish and dangerous. There are shared registers between
different GPIOs.

> 
> > > The real problem is that if the ACPI GPIO operation handler is not there
> > > at the time firmware decides to do something it will just skip things
> > > that depend on the operation region. So if it has a GPIO that is used to
> > > turn on sensor hub or touch panel or whatever, this will not be done and
> > > it results that the device in question might not work properly.
> > 
> > that's an issue that needs solving, but forcing every x86 kernel to ship
> > with this driver, is not a proper solution.
> 
> I would rather have the driver build in to the kernel now (and btw it
> has been already in mainline quite some time so I suspect many distros
> have already enabled it), than turning it module and render some devices
> that have been working previously, fail suddenly.

Hm.... it sounds like we're saying: we got it working somehow and from
now on we'll avoid change it to not create regression.

Correct if I'm wrong, but there's nothing really preventing this driver
to be a module beside the buggy ACPI interface that allows kernel and fw
to play freely (and silently) with same piece of hw.

IMHO we could allow this driver be M, but default to Y and an
explanation to set to Y in case FW needs to use GPIO before module gets
loaded. Since we've development board (Minnow Max), we should let kernel
more free for other developers as well.

Br, David

> 
> There is a mechanism in ACPI to solve these issues, called _DEP, but it
> is still very much work in progress.
