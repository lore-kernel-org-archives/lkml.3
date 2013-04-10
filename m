Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937217Ab3DJKuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:50:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:52682 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570Ab3DJKue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:50:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,445,1363158000"; 
   d="scan'208";a="225471811"
Date: Wed, 10 Apr 2013 13:54:26 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, grant.likely@secretlab.ca,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio / ACPI: Handle ACPI events in accordance with the
 spec
Message-ID: <20130410105426.GB1283@intel.com>
References: <3043137.BtEKcMiXSu@vostro.rjw.lan>
 <51652035.5000802@linux.intel.com>
 <20130410091747.GO21818@intel.com>
 <7616728.CEZnGS3Ki9@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7616728.CEZnGS3Ki9@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 12:39:21PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, April 10, 2013 12:17:47 PM Mika Westerberg wrote:
> > On Wed, Apr 10, 2013 at 11:17:57AM +0300, Mathias Nyman wrote:
> > > On 04/10/2013 10:53 AM, Mika Westerberg wrote:
> > > >On Tue, Apr 09, 2013 at 03:57:25PM +0200, Rafael J. Wysocki wrote:
> > > >>+void acpi_gpiochip_free_interrupts(struct gpio_chip *chip)
> > > >>+{
> > > >>+	acpi_handle handle;
> > > >>+	acpi_status status;
> > > >>+	struct list_head *evt_pins;
> > > >>+	struct acpi_gpio_evt_pin *evt_pin, *ep;
> > > >>+
> > > >>+	if (!chip->dev || !chip->to_irq)
> > > >>+		return;
> > > >>+
> > > >>+	handle = ACPI_HANDLE(chip->dev);
> > > >>+	if (!handle)
> > > >>+		return;
> > > >>+
> > > >>+	status = acpi_get_data(handle, acpi_gpio_evt_dh, (void **)&evt_pins);
> > > >>+	if (ACPI_FAILURE(status))
> > > >>+		return;
> > > >>+
> > > >>+	list_for_each_entry_safe_reverse(evt_pin, ep, evt_pins, node) {
> > > >>+		devm_free_irq(chip->dev, evt_pin->irq, evt_pin);
> > > >
> > > >How about using normal request/free_irq() functions for both _EVT and
> > > >non-_EVT events? Since we now need to call acpi_gpiochip_free_interrupts()
> > > >anyway, I don't see the point using devm_* functions here.
> > > >
> > > 
> > > Then we need to create a list of non-_EVT events, or add them to the
> > > evt_pins list.
> > 
> > Good point. Maybe we can add them to the evt_pins list and handle the same
> > way as _EVT (except that we need to call _Exx and _Lxx methods instead of
> > _EVT)?
> 
> The difference is that the evt_pins data is only needed for _EVT execution,
> because _EVT takes the pin argument.  _Lxx/_Exx don't take arguments and
> there's no need to add extra data structures for them, as devm_ does what's
> needed.

OK, thanks for the explanation.

> Of course, plain request/free_irq may be used for the _EVT events only
> at the expense of a little more complexity in acpi_gpiochip_request_interrupts().

I'm not sure whether it is a good thing to mix devm_ and plain request/free
here. And more complexity is always bad so I guess we can stay with this
implementation now.

Feel free to add my

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
