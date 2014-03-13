Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaCMOcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 10:32:07 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43731 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaCMOcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 10:32:02 -0400
MIME-Version: 1.0
In-Reply-To: <1394456094-21671-6-git-send-email-mika.westerberg@linux.intel.com>
References: <1394456094-21671-1-git-send-email-mika.westerberg@linux.intel.com>
	<1394456094-21671-6-git-send-email-mika.westerberg@linux.intel.com>
Date: Thu, 13 Mar 2014 15:32:01 +0100
Message-ID: <CACRpkdY3z-XGHwn5sQKM-8cKYHzr3_40h53032ETN6PaDW779w@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] gpio / ACPI: Add support for ACPI GPIO operation regions
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alexandre Courbot <gnurou@gmail.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        Alan Cox <alan.cox@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 1:54 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

Here:

> +static acpi_status
> +acpi_gpio_adr_space_handler(u32 function, acpi_physical_address address,
> +                           u32 bits, u64 *value, void *handler_context,
> +                           void *region_context)
> +{
> +       struct acpi_gpio_chip *achip = region_context;
> +       struct gpio_chip *chip = achip->chip;
> +       struct acpi_resource_gpio *agpio;
> +       struct acpi_resource *ares;
> +       acpi_status status;
> +       bool pull;

Should be named pull_up, right?

> +       int i;
> +
> +       status = acpi_buffer_to_resource(achip->conn_info.connection,
> +                                        achip->conn_info.length, &ares);
> +       if (ACPI_FAILURE(status))
> +               return status;
> +
> +       if (WARN_ON(ares->type != ACPI_RESOURCE_TYPE_GPIO)) {
> +               ACPI_FREE(ares);
> +               return AE_BAD_PARAMETER;
> +       }
> +
> +       agpio = &ares->data.gpio;
> +       pull = agpio->pin_config == ACPI_PIN_CONFIG_PULLUP;

So here ACPI tells us that the pin is pulled up.

And I am suspicious since this is strictly speaking pin control business
and not GPIO, and I won't let pin control stuff sneak into the GPIO
subsystem under the radar just because I'm not paying close enough
attention.

I have been told that these things are not dynamic (i.e. we only get
informed that a pin is pulled up/down, we cannot actively change the
config) is this correct?

If any sort of advanced pin control business is going to come into
ACPI a sibling driver in drivers/pinctrl/pinctrl-acpi.c needs to be
created that can select CONFIG_PINCONF properly reflect this
stuff in debugfs etc. (Maybe also give proper names on the pins
since I hear this is coming to ACPI!)

> +       if (WARN_ON(agpio->io_restriction == ACPI_IO_RESTRICT_INPUT &&
> +           function == ACPI_WRITE)) {
> +               ACPI_FREE(ares);
> +               return AE_BAD_PARAMETER;
> +       }
> +
> +       for (i = 0; i < agpio->pin_table_length; i++) {
> +               unsigned pin = agpio->pin_table[i];
> +               struct acpi_gpio_connection *conn;
> +               struct gpio_desc *desc;
> +               bool found;
> +
> +               desc = gpiochip_get_desc(chip, pin);
> +               if (IS_ERR(desc)) {
> +                       status = AE_ERROR;
> +                       goto out;
> +               }
> +
> +               mutex_lock(&achip->conn_lock);
> +
> +               found = false;
> +               list_for_each_entry(conn, &achip->conns, node) {
> +                       if (conn->desc == desc) {
> +                               found = true;
> +                               break;
> +                       }
> +               }
> +               if (!found) {
> +                       int ret;
> +
> +                       ret = gpiochip_request_own_desc(desc, "ACPI:OpRegion");
> +                       if (ret) {
> +                               status = AE_ERROR;
> +                               mutex_unlock(&achip->conn_lock);
> +                               goto out;
> +                       }
> +
> +                       switch (agpio->io_restriction) {
> +                       case ACPI_IO_RESTRICT_INPUT:
> +                               gpiod_direction_input(desc);
> +                               break;
> +                       case ACPI_IO_RESTRICT_OUTPUT:
> +                               gpiod_direction_output(desc, pull);

Can you explain why the fact that the line is pulled down affects the
default output value like this? I don't get it.

A comment in the code would be needed I think.

This looks more like a typical piece of code for open collector/drain
(which is already handled by gpiolib) not pull up/down.

> +                               break;
> +                       default:
> +                               /*
> +                                * Assume that the BIOS has configured the
> +                                * direction and pull accordingly.
> +                                */
> +                               break;
> +                       }
> +
> +                       conn = kzalloc(sizeof(*conn), GFP_KERNEL);
> +                       if (!conn) {
> +                               status = AE_NO_MEMORY;
> +                               mutex_unlock(&achip->conn_lock);
> +                               goto out;
> +                       }
> +
> +                       conn->desc = desc;
> +
> +                       list_add_tail(&conn->node, &achip->conns);
> +               }
> +
> +               mutex_unlock(&achip->conn_lock);
> +
> +
> +               if (function == ACPI_WRITE)
> +                       gpiod_set_raw_value(desc, !!((1 << i) & *value));

What is this? How can the expression !!((1 << i) possibly evaluate to
anything else than "true"? I don't get it. Just (desc, *value) seem more
apropriate.

Yours,
Linus Walleij
