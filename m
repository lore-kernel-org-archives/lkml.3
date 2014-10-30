Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbaJ3AYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 20:24:37 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61046 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756592AbaJ3AYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 20:24:35 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] ACPI / GPIO: Driver GPIO mappings for ACPI GPIOs
Date: Thu, 30 Oct 2014 01:45:09 +0100
Message-ID: <13007048.sH0aJYjMUX@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAAVeFuKStrzzwW7s37y7-a8y+j1gD-EzAYfc1h2KTo8uyd+dSA@mail.gmail.com>
References: <CAAVeFuLW6fucvDxQvY5DDfnhPrgYM+1pi7WoHfBQa_BgYnc_Cw@mail.gmail.com> <3242497.urQmuvpeyA@vostro.rjw.lan> <CAAVeFuKStrzzwW7s37y7-a8y+j1gD-EzAYfc1h2KTo8uyd+dSA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 28, 2014 01:11:50 PM Alexandre Courbot wrote:
> On Tue, Oct 28, 2014 at 7:34 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Monday, October 27, 2014 02:21:23 PM Alexandre Courbot wrote:

[cut]

> > Yes, I'm going to provide documentation.
> >
> > One question, though.  We're already adding gpio-properties.txt under
> > Documentation/acpi/ containing analogous information for _DSD-based
> > mappings.  I thought I'd add a section to that file and a short paragraph
> > pointing to it into consumer.txt, would that work?
> 
> Definitely yes, since this is ACPI-specific. Thanks!

OK, so what about this (on top of the device-properties branch at
http://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/log/?h=device-properties):

---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / GPIO: Document ACPI GPIO mappings API

Document the previously introduced method that can be used by device
drivers to provide the GPIO subsystem with mappings between GPIO names
(connection IDs) and GpioIo()/GpioInt() resources in _CRS.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 Documentation/acpi/gpio-properties.txt |   44 +++++++++++++++++++++++++++++++++
 Documentation/gpio/consumer.txt        |   18 +++++++++++++
 2 files changed, 62 insertions(+)

Index: linux-pm/Documentation/acpi/gpio-properties.txt
===================================================================
--- linux-pm.orig/Documentation/acpi/gpio-properties.txt
+++ linux-pm/Documentation/acpi/gpio-properties.txt
@@ -50,3 +50,47 @@ it to 1 marks the GPIO as active low.
 
 In our Bluetooth example the "reset-gpio" refers to the second GpioIo()
 resource, second pin in that resource with the GPIO number of 31.
+
+ACPI GPIO Mappings Provided by Drivers
+--------------------------------------
+
+There are systems in which the ACPI tables do not contain _DSD but provide _CRS
+with GpioIo()/GpioInt() resources and device drivers still need to work with
+them.
+
+In those cases ACPI device identification objects, _HID, _CID, _CLS, _SUB, _HRV,
+available to the driver can be used to identify the device and that is supposed
+to be sufficient to determine the meaning and purpose of all of the GPIO pins
+listed by the GpioIo()/GpioInt() resources returned by _CRS.  In other words,
+the driver is supposed to know what to use the GpioIo()/GpioInt() resources for
+once it has identified the device.  Having done that, it can simply assign names
+to the GPIO pins it is going to use and provide the GPIO subsystem with a
+mapping between those names and the ACPI GPIO resources corresponding to them.
+
+To do that, the driver needs to define a mapping table as a NULL-terminated
+array of struct acpi_gpio_mapping objects that each contain a name, a pointer
+to an array of pin data (struct acpi_gpio_params) objects and the size of that
+array.  Each struct acpi_gpio_params object consists of three fields,
+crs_entry_index, pin_index, active_low, representing the index of the target
+GpioIo()/GpioInt() resource in _CRS starting from zero, the index of the target
+pin in that resource starting from zero, and the active-low flag for that pin,
+respectively, in analogy with the _DSD GPIO property format specified above.
+
+For the example Bluetooth device discussed previously the data structures in
+question would look like this:
+
+static const struct acpi_gpio_params reset_gpio = { 1, 1, false };
+static const struct acpi_gpio_params shutdown_gpio = { 0, 0, false };
+
+static const struct acpi_gpio_mapping bluetooth_acpi_gpios[] = {
+  { "reset-gpio", &reset_gpio, 1 },
+  { "shutdown-gpio", &shutdown_gpio, 1 },
+  { },
+};
+
+Next, the mapping table needs to be passed as the second argument to
+acpi_dev_add_driver_gpios() that will register it with the ACPI device object
+pointed to by its first argument.  That should be done in the driver's .probe()
+routine.  On removal, the driver should unregister its GPIO mapping table by
+calling acpi_dev_remove_driver_gpios() on the ACPI device object where that
+table was previously registered.
Index: linux-pm/Documentation/gpio/consumer.txt
===================================================================
--- linux-pm.orig/Documentation/gpio/consumer.txt
+++ linux-pm/Documentation/gpio/consumer.txt
@@ -219,6 +219,24 @@ part of the IRQ interface, e.g. IRQF_TRI
 capabilities.
 
 
+GPIOs and ACPI
+==============
+
+On ACPI systems, GPIOs are described by GpioIo()/GpioInt() resources listed by
+the _CRS configuration objects of devices.  Those resources do not provide
+connection IDs (names) for GPIOs, so it is necessary to use an additional
+mechanism for this purpose.
+
+Systems compliant with ACPI 5.1 or newer may provide a _DSD configuration object
+which, among other things, may be used to provide connection IDs for specific
+GPIOs described by the GpioIo()/GpioInt() resources in _CRS.  If that is the
+case, it will be handled by the GPIO subsystem automatically.  However, if the
+_DSD is not present, the mappings between GpioIo()/GpioInt() resources and GPIO
+connection IDs need to be provided by device drivers.
+
+For details refer to Documentation/acpi/gpio-properties.txt
+
+
 Interacting With the Legacy GPIO Subsystem
 ==========================================
 Many kernel subsystems still handle GPIOs using the legacy integer-based

