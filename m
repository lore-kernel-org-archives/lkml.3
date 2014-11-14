Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422755AbaKNW7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 17:59:01 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53022 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754825AbaKNW67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 17:58:59 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH] pinctrl: baytrail: show output gpio state correctly on Intel Baytrail
Date: Sat, 15 Nov 2014 00:19:57 +0100
Message-ID: <3213116.fzuiWWWLrg@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141114095340.GZ1454@lahna.fi.intel.com>
References: <20141103150048.GB27425@saruman> <CACRpkdZg9-h+SVEe1mDHWm2kCfR3wc6uCvaLJsXpJm7xNL=r-w@mail.gmail.com> <20141114095340.GZ1454@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 14, 2014 11:53:40 AM Mika Westerberg wrote:
> +Rafael
> 
> On Fri, Nov 14, 2014 at 10:39:07AM +0100, Linus Walleij wrote:
> > On Tue, Nov 4, 2014 at 7:57 PM, Mika Westerberg
> > <mika.westerberg@linux.intel.com> wrote:
> > > On Tue, Nov 04, 2014 at 10:05:26AM -0800, David Cohen wrote:
> > 
> > >> It looks we have an implicit dependency to GPIO driver in Bay Trail, and
> > >> having this window until load the module is not acceptable to fulfill
> > >> this implicit dependency.
> > >
> > > It is not implicit at all.
> > >
> > > The user of the GPIO in ACPI DSDT table says something like:
> > >
> > >         Name (_DEP, Package () { \_SB.GPO2 })
> > >
> > > or similar. That is *explicit* dependency. Here \_SB.GPO2 is one of the
> > > GPIO banks.
> > 
> > That's very nice for ACPI. But what do you expect the Linux kernel to
> > do with that?
> 
> It should prevent the driver from probing until all the devices listed
> in _DEP have drivers probed.

Not only or not precisely that.

By the spec, _DEP is supposed to indicate an "operation region dependency",
which means that device A is providing an operation region handler that will
be invoked when AML executed for device B accesses certain things.

In other words, the operation region handler provided by A should be functional
when said AML is invoked for device B.  There are ACPI objects that are required
to not depend on any operation regions with such dependencies and those can be
safely evaluated at any time, but currently we evaluate more than that during
device enumeration alone.  So this affects more than just driver probing even
with the restricted spec-compliant interpretation.

> However, it turned out that this is not that straightforward after all
> :-( For one, it looks like _DEP is used also for non-operation region
> dependencies. This is not in the ACPI spec but we have seen this in real
> machines out there.

Yeah.  _DEP is apparently used to indicate any functional dependencies as
in "device B depends on device A somehow" which has much more far reaching
consequences.  In particular, it implies that A needs to be functional
whenever B is in use, so for example A may not be suspended when B is
active and so on.

> Other thing I heard, is that handling all these dependencies in driver
> core might be nightmare to maintain.

That if we can come up with a way to represent those dependencies in a
sensible way, which hasn't happened yet so far.

> > Basically that is just like getting an -EPROBE_DEFER from the
> > gpiochip when the gpiod_get() call is issued, and you have to wait
> > because the gpiochip is not probed yet. We can solve that at runtime
> > right?
> 
> Yes we can if the driver core prevents probing the driver.
> 
> > I had a discussion with Greg the other day that we have no way of
> > expressing inside the kernel that a resource such as a GPIO, a pin,
> > a clk or a regulator is used by some module. It's just a synchronous
> > gpiod_get() or whatever call, then there is a warning if you remove
> > a gpiochip with gpios still in use.
> > 
> > What is needed to make use of such a dependency mechanism is
> > a way to graph the dependencies between kernel drivers and
> > the resources (gpios, clocks, regulators...) they provide to other
> > drivers, so this information can be used when probing, removing,
> > powering up/down the cluster.
> > 
> > That problem needs to be solved in the device core, until then there
> > is not way to actually use that ACPI _DEP property for what I can
> > tell.
> 
> I agree.

Yup.

> > (On a side note: whoever came up with the idea that ACPI props
> > be 4 characters wide and start with an underscore and this
> > backslash obfuscation needs to... think differently.)

That happened 20+ years ago and the goal was to squeeze an object name
into sizeof(int) amount of memory (on a 32-bit system).  That way names
could be represented by ints.  Yes, people were thinking differently at
that time. :-)

Rafael

