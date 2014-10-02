Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbaJBNhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:37:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:9533 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbaJBNhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:37:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="394622833"
Date: Thu, 2 Oct 2014 16:36:54 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 04/15] ACPI: Document ACPI device specific properties
Message-ID: <20141002133654.GP1786@lahna.fi.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
 <2466832.0XJezjdvYs@wuerfel>
 <20141002121508.GM1786@lahna.fi.intel.com>
 <15893883.nvuW3ndylz@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15893883.nvuW3ndylz@wuerfel>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 02:46:30PM +0200, Arnd Bergmann wrote:
> On Thursday 02 October 2014 15:15:08 Mika Westerberg wrote:
> > > I thought when we had discussed the subsystem specific bindings, the
> > > consensus there was to have subsystem specific accessors and
> > > properties/tables.
> > > 
> > > I would argue that for everything that ACPI already has (interrupts,
> > > registers, gpio, dmaengine, ...) the native method should be used,
> > > possibly using _DSD to provide naming for otherwise anonymous references.
> > 
> > Absolutely. That's precisely what we do in the GPIO patch of this
> > series. E.g we use ACPI GpioIo/GpioInt _CRS resources but give name to
> > the GPIOs with the help of _DSD.
> 
> Ok, I've looked at the example again:
> 
> +       Device (DEV0)
> +       {
> +               Name (_CRS, ResourceTemplate () {
> +                       GpioIo (Exclusive, PullUp, 0, 0, IoRestrictionInputOnly,
> +                               "\\_SB.PCI0.LPC", 0, ResourceConsumer) {0}
> +                       GpioIo (Exclusive, PullUp, 0, 0, IoRestrictionInputOnly,
> +                               "\\_SB.PCI0.LPC", 0, ResourceConsumer) {1}
> +                       ...
> +               })
> +
> +               Name (_DSD, Package () {
> +                       ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +                       Package () {
> +                               Package () {"reset-gpio", {^DEV0, 0, 0, 0}},
> +                               Package () {"shutdown-gpio", {^DEV0, 1, 0, 0}},
> +                       }
> +               })
> +       }
> 
> tell me if I'm interpreting this right: you use _CRS to define a reference
> to the actual GPIO controller here, but then in your _DSD you have something
> that is a bit like the DT gpio binding, except that it doesn't refer to
> a GPIO controller but to the GPIO using device itself.

That's right. However, it is not limited to the device itself, it can be
parent device for example. Typically not the GPIO controller, though.

> When a driver calls dev_get_named_gpiod_from_child, you then lookup the
> "reset-gpio" (or other) properties to find the reference to the _CRS.

That's right.

> Why can't you instead have a "gpio-names" property in _DSD that just
> links from a string to an index as we do in all the other bindings?
> It sounds to me like that would be simpler and more consistent with
> the way things are done in ACPI, and have no effect that would be visible
> to the driver.

The ACPI GpioIo/GpioInt entry can also contain pinlist, for example:


            Name (_CRS, ResourceTemplate () {
                GpioIo (Exclusive, PullUp, 0, 0, IoRestrictionInputOnly,
                        "\\_SB.PCI0.LPC", 0, ResourceConsumer) {10, 21, 50, 13} <-- this is the pinlist
                ...
            })

            Device (BTN0)
            {
                Name (_DSD, Package () {
                    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
                    Package () {
		        ...
                        Package () {"gpios", Package () {^^BTNS, 0, 2, 1}},
                    }
                })
            }

Format of the package is:

  { reference, crs_index, pin_index, active_low },

So {^^BTNS, 0, 2, 1} will select pin 50 and mark it as active_low.

In addition to name we also use it to select correct pin in pinlist and
provide additional active_low information which would not be available
for plain GpioIo() resource.

> > For things that don't have correspondence in ACPI but have well defined
> > existing DT schema, like PWMs, we should follow that.
> 
> Only for stuff that is visible to drivers. I think it's important
> that a driver calling pwm_get() today should keep working with
> ACPI when the pwm subsystem is extended to support that.

Of course.

> However, that does not necessarily mean using #pwm-cells and pwm-names
> properties when there is a better way to express the same in ACPI
> syntax. AFAICT, the #foo-names is completely redundant for ACPI
> as the length of a property in a list of similar elements is part
> of the binary data (if not, please correct me), and I already commented
> that I think the foo-names stuff could be encoded in the package
> directly in a way we can't do in DT.

Yes, it can be included in the package, however see below.

> Even if you want to do automatic translation between DT and ACPI,
> I think it would be possible to treat these two the same:
> 
> (forgive any syntax errors)
> 
> 	Name (_DSD, Package () {
> 		ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> 		Package () {
> 			Package () { "pwms" { "led-red", ^PWM0, 0, 10 },
> 					    { "led-green", ^PWM0, 1, 20 }},

Even though the above would fit better in ACPI, it is not allowed to
have multiple values for a single property. One reason for that is that
we validate each property and check that they match what is expected and
having strict set of possible values makes it easier.

Putting everything to a single package results this:

		Package () { "pwms", Package () {"led-red", ^PWM0, 0, 10, "led-green", ^PWM0, 1, 10 }}

But I think the below looks better:

		Package () { "pwms", Package () {^PWM0, 0, 10, ^PWM0, 1, 10 }}
		Package () { "pwm-names", Package () {"led-red", "led-green"}}

and it is trivial to match with the corresponding DT fragment.

> 	}
> 
> vs.
> 
> 	pwm-slave {
> 		pwms = <&pwm0 0 10>, <&pwm1 1 20>;
> 		pwm-names = "led-red", "led-green";
> 	};
> 

I don't have strong feelings which way it should be. The current
implementation limits references so that you can have only integer
arguments, like {ref0, int, int, ref1, int} but if people think it is
better to allow strings there as well, it can be changed.

I would like to get comments from Darren and Rafael about this, though.
