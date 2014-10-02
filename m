Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbaJBMqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:46:43 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:64707 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaJBMql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:46:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
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
Date: Thu, 02 Oct 2014 14:46:30 +0200
Message-ID: <15893883.nvuW3ndylz@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141002121508.GM1786@lahna.fi.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <2466832.0XJezjdvYs@wuerfel> <20141002121508.GM1786@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:s0q4W33CCoxE0WNT1sRnmhmo0XvoU2yJyYHR/mnOTax
 o4d1Ob2iMEBIeENGeNs3IuiuqehNPQQZFABYZHB+L5aOSxLBmT
 LuN3h4hRi4R5ToPvmaGdoY6hIBCavV9C7z/5WXBJ3ew7BsWI3J
 SPnzFUcbn3aazylI59scwQE4a8d49scJnoSI/OlN7obV8L6XRh
 beGzqE+19PSX0fYTcOSvNR/AdSjp5J+jflmw9p0qn4wUizNxI/
 NjaXaJMp1MO7x22SSEP2PGM+7JmOP+sDj/A9ekELi4jH/AUUJ6
 Qj1T++OYVuvHjijtvxOBZaakOGyevvxsxZ33u76+DAkvHKXkwU
 zLyaKEvC8yTQfLUywMM0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 October 2014 15:15:08 Mika Westerberg wrote:
> > I thought when we had discussed the subsystem specific bindings, the
> > consensus there was to have subsystem specific accessors and
> > properties/tables.
> > 
> > I would argue that for everything that ACPI already has (interrupts,
> > registers, gpio, dmaengine, ...) the native method should be used,
> > possibly using _DSD to provide naming for otherwise anonymous references.
> 
> Absolutely. That's precisely what we do in the GPIO patch of this
> series. E.g we use ACPI GpioIo/GpioInt _CRS resources but give name to
> the GPIOs with the help of _DSD.

Ok, I've looked at the example again:

+       Device (DEV0)
+       {
+               Name (_CRS, ResourceTemplate () {
+                       GpioIo (Exclusive, PullUp, 0, 0, IoRestrictionInputOnly,
+                               "\\_SB.PCI0.LPC", 0, ResourceConsumer) {0}
+                       GpioIo (Exclusive, PullUp, 0, 0, IoRestrictionInputOnly,
+                               "\\_SB.PCI0.LPC", 0, ResourceConsumer) {1}
+                       ...
+               })
+
+               Name (_DSD, Package () {
+                       ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+                       Package () {
+                               Package () {"reset-gpio", {^DEV0, 0, 0, 0}},
+                               Package () {"shutdown-gpio", {^DEV0, 1, 0, 0}},
+                       }
+               })
+       }

tell me if I'm interpreting this right: you use _CRS to define a reference
to the actual GPIO controller here, but then in your _DSD you have something
that is a bit like the DT gpio binding, except that it doesn't refer to
a GPIO controller but to the GPIO using device itself.

When a driver calls dev_get_named_gpiod_from_child, you then lookup the
"reset-gpio" (or other) properties to find the reference to the _CRS.

Why can't you instead have a "gpio-names" property in _DSD that just
links from a string to an index as we do in all the other bindings?
It sounds to me like that would be simpler and more consistent with
the way things are done in ACPI, and have no effect that would be visible
to the driver.
 
> For things that don't have correspondence in ACPI but have well defined
> existing DT schema, like PWMs, we should follow that.

Only for stuff that is visible to drivers. I think it's important
that a driver calling pwm_get() today should keep working with
ACPI when the pwm subsystem is extended to support that.

However, that does not necessarily mean using #pwm-cells and pwm-names
properties when there is a better way to express the same in ACPI
syntax. AFAICT, the #foo-names is completely redundant for ACPI
as the length of a property in a list of similar elements is part
of the binary data (if not, please correct me), and I already commented
that I think the foo-names stuff could be encoded in the package
directly in a way we can't do in DT.

Even if you want to do automatic translation between DT and ACPI,
I think it would be possible to treat these two the same:

(forgive any syntax errors)

	Name (_DSD, Package () {
		ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
		Package () {
			Package () { "pwms" { "led-red", ^PWM0, 0, 10 },
					    { "led-green", ^PWM0, 1, 20 }},
	}

vs.

	pwm-slave {
		pwms = <&pwm0 0 10>, <&pwm1 1 20>;
		pwm-names = "led-red", "led-green";
	};


	Arnd
