Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936918Ab3DJKbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:31:38 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55337 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936898Ab3DJKbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:31:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, grant.likely@secretlab.ca,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio / ACPI: Handle ACPI events in accordance with the spec
Date: Wed, 10 Apr 2013 12:39:21 +0200
Message-ID: <7616728.CEZnGS3Ki9@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130410091747.GO21818@intel.com>
References: <3043137.BtEKcMiXSu@vostro.rjw.lan> <51652035.5000802@linux.intel.com> <20130410091747.GO21818@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 10, 2013 12:17:47 PM Mika Westerberg wrote:
> On Wed, Apr 10, 2013 at 11:17:57AM +0300, Mathias Nyman wrote:
> > On 04/10/2013 10:53 AM, Mika Westerberg wrote:
> > >On Tue, Apr 09, 2013 at 03:57:25PM +0200, Rafael J. Wysocki wrote:
> > >>+void acpi_gpiochip_free_interrupts(struct gpio_chip *chip)
> > >>+{
> > >>+	acpi_handle handle;
> > >>+	acpi_status status;
> > >>+	struct list_head *evt_pins;
> > >>+	struct acpi_gpio_evt_pin *evt_pin, *ep;
> > >>+
> > >>+	if (!chip->dev || !chip->to_irq)
> > >>+		return;
> > >>+
> > >>+	handle = ACPI_HANDLE(chip->dev);
> > >>+	if (!handle)
> > >>+		return;
> > >>+
> > >>+	status = acpi_get_data(handle, acpi_gpio_evt_dh, (void **)&evt_pins);
> > >>+	if (ACPI_FAILURE(status))
> > >>+		return;
> > >>+
> > >>+	list_for_each_entry_safe_reverse(evt_pin, ep, evt_pins, node) {
> > >>+		devm_free_irq(chip->dev, evt_pin->irq, evt_pin);
> > >
> > >How about using normal request/free_irq() functions for both _EVT and
> > >non-_EVT events? Since we now need to call acpi_gpiochip_free_interrupts()
> > >anyway, I don't see the point using devm_* functions here.
> > >
> > 
> > Then we need to create a list of non-_EVT events, or add them to the
> > evt_pins list.
> 
> Good point. Maybe we can add them to the evt_pins list and handle the same
> way as _EVT (except that we need to call _Exx and _Lxx methods instead of
> _EVT)?

The difference is that the evt_pins data is only needed for _EVT execution,
because _EVT takes the pin argument.  _Lxx/_Exx don't take arguments and
there's no need to add extra data structures for them, as devm_ does what's
needed.

Of course, plain request/free_irq may be used for the _EVT events only
at the expense of a little more complexity in acpi_gpiochip_request_interrupts().

Thanks,
Rafael

