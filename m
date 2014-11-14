Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbaKNJxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 04:53:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:9410 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902AbaKNJxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 04:53:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,384,1413270000"; 
   d="scan'208";a="622296141"
Date: Fri, 14 Nov 2014 11:53:40 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH] pinctrl: baytrail: show output gpio state correctly on
 Intel Baytrail
Message-ID: <20141114095340.GZ1454@lahna.fi.intel.com>
References: <20141103150048.GB27425@saruman>
 <20141103152743.GB1618@lahna.fi.intel.com>
 <20141103154207.GC1618@lahna.fi.intel.com>
 <20141103155011.GH27425@saruman>
 <20141103184247.GD1618@lahna.fi.intel.com>
 <20141103221903.GA20305@psi-dev26.jf.intel.com>
 <20141104075936.GF1618@lahna.fi.intel.com>
 <20141104180526.GB2224@psi-dev26.jf.intel.com>
 <20141104185702.GR1618@lahna.fi.intel.com>
 <CACRpkdZg9-h+SVEe1mDHWm2kCfR3wc6uCvaLJsXpJm7xNL=r-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZg9-h+SVEe1mDHWm2kCfR3wc6uCvaLJsXpJm7xNL=r-w@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Rafael

On Fri, Nov 14, 2014 at 10:39:07AM +0100, Linus Walleij wrote:
> On Tue, Nov 4, 2014 at 7:57 PM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > On Tue, Nov 04, 2014 at 10:05:26AM -0800, David Cohen wrote:
> 
> >> It looks we have an implicit dependency to GPIO driver in Bay Trail, and
> >> having this window until load the module is not acceptable to fulfill
> >> this implicit dependency.
> >
> > It is not implicit at all.
> >
> > The user of the GPIO in ACPI DSDT table says something like:
> >
> >         Name (_DEP, Package () { \_SB.GPO2 })
> >
> > or similar. That is *explicit* dependency. Here \_SB.GPO2 is one of the
> > GPIO banks.
> 
> That's very nice for ACPI. But what do you expect the Linux kernel to
> do with that?

It should prevent the driver from probing until all the devices listed
in _DEP have drivers probed.

However, it turned out that this is not that straightforward after all
:-( For one, it looks like _DEP is used also for non-operation region
dependencies. This is not in the ACPI spec but we have seen this in real
machines out there.

Other thing I heard, is that handling all these dependencies in driver
core might be nightmare to maintain.

> Basically that is just like getting an -EPROBE_DEFER from the
> gpiochip when the gpiod_get() call is issued, and you have to wait
> because the gpiochip is not probed yet. We can solve that at runtime
> right?

Yes we can if the driver core prevents probing the driver.

> I had a discussion with Greg the other day that we have no way of
> expressing inside the kernel that a resource such as a GPIO, a pin,
> a clk or a regulator is used by some module. It's just a synchronous
> gpiod_get() or whatever call, then there is a warning if you remove
> a gpiochip with gpios still in use.
> 
> What is needed to make use of such a dependency mechanism is
> a way to graph the dependencies between kernel drivers and
> the resources (gpios, clocks, regulators...) they provide to other
> drivers, so this information can be used when probing, removing,
> powering up/down the cluster.
> 
> That problem needs to be solved in the device core, until then there
> is not way to actually use that ACPI _DEP property for what I can
> tell.

I agree.

> (On a side note: whoever came up with the idea that ACPI props
> be 4 characters wide and start with an underscore and this
> backslash obfuscation needs to... think differently.)
> 
> Yours,
> Linus Walleij
