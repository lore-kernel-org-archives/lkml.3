Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbaCMPLC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:11:02 -0400
Received: from [143.182.124.21] ([143.182.124.21]:21029 "EHLO mga03.intel.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753394AbaCMPK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:10:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,647,1389772800"; 
   d="scan'208";a="491309162"
Date: Thu, 13 Mar 2014 17:18:16 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alexandre Courbot <gnurou@gmail.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        Alan Cox <alan.cox@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] gpio / ACPI: Add support for ACPI GPIO operation
 regions
Message-ID: <20140313151816.GR5018@intel.com>
References: <1394456094-21671-1-git-send-email-mika.westerberg@linux.intel.com>
 <1394456094-21671-6-git-send-email-mika.westerberg@linux.intel.com>
 <CACRpkdY3z-XGHwn5sQKM-8cKYHzr3_40h53032ETN6PaDW779w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdY3z-XGHwn5sQKM-8cKYHzr3_40h53032ETN6PaDW779w@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 03:32:01PM +0100, Linus Walleij wrote:
> On Mon, Mar 10, 2014 at 1:54 PM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> 
> Here:
> 
> > +static acpi_status
> > +acpi_gpio_adr_space_handler(u32 function, acpi_physical_address address,
> > +                           u32 bits, u64 *value, void *handler_context,
> > +                           void *region_context)
> > +{
> > +       struct acpi_gpio_chip *achip = region_context;
> > +       struct gpio_chip *chip = achip->chip;
> > +       struct acpi_resource_gpio *agpio;
> > +       struct acpi_resource *ares;
> > +       acpi_status status;
> > +       bool pull;
> 
> Should be named pull_up, right?

Yes.

> 
> > +       int i;
> > +
> > +       status = acpi_buffer_to_resource(achip->conn_info.connection,
> > +                                        achip->conn_info.length, &ares);
> > +       if (ACPI_FAILURE(status))
> > +               return status;
> > +
> > +       if (WARN_ON(ares->type != ACPI_RESOURCE_TYPE_GPIO)) {
> > +               ACPI_FREE(ares);
> > +               return AE_BAD_PARAMETER;
> > +       }
> > +
> > +       agpio = &ares->data.gpio;
> > +       pull = agpio->pin_config == ACPI_PIN_CONFIG_PULLUP;
> 
> So here ACPI tells us that the pin is pulled up.
> 
> And I am suspicious since this is strictly speaking pin control business
> and not GPIO, and I won't let pin control stuff sneak into the GPIO
> subsystem under the radar just because I'm not paying close enough
> attention.

This has more to do in finding out what will be the initial value of the
GPIO when we set it to output (given that it is output).

> I have been told that these things are not dynamic (i.e. we only get
> informed that a pin is pulled up/down, we cannot actively change the
> config) is this correct?

As far as I can tell, yes.

> If any sort of advanced pin control business is going to come into
> ACPI a sibling driver in drivers/pinctrl/pinctrl-acpi.c needs to be
> created that can select CONFIG_PINCONF properly reflect this
> stuff in debugfs etc. (Maybe also give proper names on the pins
> since I hear this is coming to ACPI!)

No advanced pin control business, just GPIO stuff :)

> > +       if (WARN_ON(agpio->io_restriction == ACPI_IO_RESTRICT_INPUT &&
> > +           function == ACPI_WRITE)) {
> > +               ACPI_FREE(ares);
> > +               return AE_BAD_PARAMETER;
> > +       }
> > +
> > +       for (i = 0; i < agpio->pin_table_length; i++) {
> > +               unsigned pin = agpio->pin_table[i];
> > +               struct acpi_gpio_connection *conn;
> > +               struct gpio_desc *desc;
> > +               bool found;
> > +
> > +               desc = gpiochip_get_desc(chip, pin);
> > +               if (IS_ERR(desc)) {
> > +                       status = AE_ERROR;
> > +                       goto out;
> > +               }
> > +
> > +               mutex_lock(&achip->conn_lock);
> > +
> > +               found = false;
> > +               list_for_each_entry(conn, &achip->conns, node) {
> > +                       if (conn->desc == desc) {
> > +                               found = true;
> > +                               break;
> > +                       }
> > +               }
> > +               if (!found) {
> > +                       int ret;
> > +
> > +                       ret = gpiochip_request_own_desc(desc, "ACPI:OpRegion");
> > +                       if (ret) {
> > +                               status = AE_ERROR;
> > +                               mutex_unlock(&achip->conn_lock);
> > +                               goto out;
> > +                       }
> > +
> > +                       switch (agpio->io_restriction) {
> > +                       case ACPI_IO_RESTRICT_INPUT:
> > +                               gpiod_direction_input(desc);
> > +                               break;
> > +                       case ACPI_IO_RESTRICT_OUTPUT:
> > +                               gpiod_direction_output(desc, pull);
> 
> Can you explain why the fact that the line is pulled down affects the
> default output value like this? I don't get it.

That's the thing - ACPI doesn't tell us what is the initial value of the
pin. There is no such field in GpioIo() resource.

So I'm assuming here that if it says that the pin is pulled up, the default
value will be high.

> A comment in the code would be needed I think.
> 
> This looks more like a typical piece of code for open collector/drain
> (which is already handled by gpiolib) not pull up/down.
>
> 
> > +                               break;
> > +                       default:
> > +                               /*
> > +                                * Assume that the BIOS has configured the
> > +                                * direction and pull accordingly.
> > +                                */
> > +                               break;
> > +                       }
> > +
> > +                       conn = kzalloc(sizeof(*conn), GFP_KERNEL);
> > +                       if (!conn) {
> > +                               status = AE_NO_MEMORY;
> > +                               mutex_unlock(&achip->conn_lock);
> > +                               goto out;
> > +                       }
> > +
> > +                       conn->desc = desc;
> > +
> > +                       list_add_tail(&conn->node, &achip->conns);
> > +               }
> > +
> > +               mutex_unlock(&achip->conn_lock);
> > +
> > +
> > +               if (function == ACPI_WRITE)
> > +                       gpiod_set_raw_value(desc, !!((1 << i) & *value));
> 
> What is this? How can the expression !!((1 << i) possibly evaluate to
> anything else than "true"? I don't get it. Just (desc, *value) seem more
> apropriate.

We are dealing with multiple pins here. So for example if
agpio->pin_table_length == 2 and *value == 0x2 we get:

i == 0: !!((1 << 0) & 0x2) --> false
i == 1: !!((1 << 1) & 0x2) --> true

Maybe

	gpiod_set_raw_value(desc, (*value >> i) & 1);

is cleaner?
