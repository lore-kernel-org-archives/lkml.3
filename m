Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965167Ab3FTJPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:15:09 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:59595 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964817Ab3FTJPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:15:04 -0400
MIME-Version: 1.0
In-Reply-To: <1371712781-20040-1-git-send-email-sonic.adi@gmail.com>
References: <1371712781-20040-1-git-send-email-sonic.adi@gmail.com>
Date: Thu, 20 Jun 2013 11:15:03 +0200
Message-ID: <CACRpkdb5ns5TjN8hLyG2n-TcJb=xLr-2eMHrgtW3b=D6pERXwQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: ADI GPIO2 driver for BF54x and BF60x.
From: Linus Walleij <linus.walleij@linaro.org>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        buildroot-devel@blackfin.uclinux.org,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 9:19 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:

> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> +obj-$(CONFIG_GPIO_ADI2)                += gpio-adi2.o

Where is CONFIG_GPIO_ADI2 defines?

You didn't include any change to Kconfig.

(...)
> +++ b/drivers/gpio/gpio-adi2.c
> @@ -0,0 +1,1287 @@
> +/*
> + * GPIO Driver for ADI GPIO2 controller
> + *
> + * Copyright 2007-2013 Analog Devices Inc.
> + *
> + * Licensed under the GPL-2 or later

Nitpick: we usually write "GPLv2"

> +struct gpio_reserve_map {
> +       unsigned char owner[RESOURCE_LABEL_SIZE];
> +       unsigned char irq_enabled:1;
> +       unsigned char rsv_gpio:1;
> +       unsigned char rsv_int:1;
> +       unsigned char rsv_peri:1;

All these should be bool instead.

> +};

Write some piece of kerneldoc describing what this struct is for.

> +struct gpio_port_saved {
> +       unsigned short fer;
> +       unsigned short data;
> +       unsigned short dir;
> +       unsigned short inen;

Switch all to type u16.

> +       unsigned int mux;

Switch to u32?

> +};

Kerneldoc this thing. Is it a sleep register state container?

> +struct gpio_pint {
> +       struct list_head node;
> +       void __iomem *base;     /* Port interrupt controller MMR base */
> +       int irq;                /* Port interrupt controller demux IRQ */

What is a "demux IRQ"? Don't you mean it is a parent IRQ for
the entire port, that need to be demuxed to figure out which
line fired?

> +       int gpio_irq_base[2];   /* [0] is gpio irq base in low 16 bit pint.
> +                                * [1] is gpio irq base in high 16 bit pint.
> +                                */
> +       struct gpio_pint_regs *regs;

This struct gpio_pint_regs is not part of the patch!

Plus it seems to use the RTOS common style of mapping a struct
over a register range and assigning members in the code.
Get rid of the struct altogether and use read[l|w|b] and
write[l|w|b] from <linux/io.h> or possibly the _relaxed variants to
hammer the registers directly.

> +       struct adi_pm_pint_save saved_data;
> +       int map_count;

This looks like it should be unsigned.

> +       spinlock_t lock;

Define what this is locking. The list?

> +
> +       int (*pint_map_port)(struct gpio_pint *pint, u8 assign,
> +                               u8 map, int irq_base);

This looks like some attempt to reimplement irqdomains.

> +};

Write proper kerneldoc instead of inline comments.

> +struct gpio_port {
> +       struct list_head node;
> +       void __iomem *base;
> +       int pin_base;

If you're referencing pins to GPIOs this driver should be
in drivers/pinctrl, read Documentation/pinctrl.txt

> +       int irq_base;

This is an indication that you should be using irqdomain.

> +       int width;

Are these three unsigned?

> +       struct gpio_port_t *regs;
> +       struct gpio_port_saved saved_data;
> +       struct device *dev;
> +
> +       struct gpio_pint *pint;
> +       u8 pint_map;            /* port mapping mask in pint */

Masking exactly what? Details here.

> +       u8 pint_assign;         /* 0 - assgin to pint 1ow 16 bits
> +                                * 1 - assign to pint high 16 bits
> +                                */

Speling is strange, I don't understand anything of this comment.
Suspect this is part of the irqdomain reimplementation.

> +
> +       spinlock_t lock;
> +       struct gpio_chip chip;
> +
> +       struct gpio_reserve_map rsvmap[];
> +};

Use kerneldoc again.

> +static inline unsigned offset_to_gpio(struct gpio_port *port, unsigned offset)
> +{
> +       return offset + port->chip.base;
> +}
> +
> +static inline unsigned gpio_to_offset(struct gpio_port *port, unsigned gpio)
> +{
> +       return gpio - port->chip.base;
> +}
> +
> +static inline unsigned irq_to_offset(struct gpio_port *port, int irq)
> +{
> +       int offset;
> +
> +       offset = irq - port->irq_base;
> +       if (offset >= 0 && offset < port->width)
> +               return offset;
> +       else
> +               return 0;
> +}
Switch all to type u8.

Use irqdomain instead. Check other GPIO drivers for examples.

> +static inline unsigned irq_to_pintbit(struct gpio_port *port, int irq)
> +{
> +       return (1 << irq_to_offset(port, irq)) << (port->pint_assign * 16);
> +}

Dito, needs refactoring.

> +static void gpio_error(struct gpio_port *port, unsigned offset)
> +{
> +       dev_err(port->dev, "gpio-adi2: GPIO %d wasn't requested!\n",
> +               offset_to_gpio(port, offset));
> +}

No need for a simple helper like that, inline this into the code wherever
it's needed.

> +static void set_label(struct gpio_port *port, unsigned offset,
> +       const char *label)
> +{
> +       char *pch = port->rsvmap[offset].owner;
> +
> +       if (label) {
> +               strncpy(pch, label, RESOURCE_LABEL_SIZE);
> +               pch[RESOURCE_LABEL_SIZE - 1] = 0;
> +       }
> +}

Dito.

> +static char *get_label(struct gpio_port *port, unsigned offset)
> +{
> +       char *pch = port->rsvmap[offset].owner;
> +
> +       return *pch ? pch : "UNKNOWN";
> +}

Dito.

> +static int cmp_label(struct gpio_port *port, unsigned offset, const char *label)
> +{
> +       if (label == NULL) {
> +               dump_stack();
> +               dev_err(port->dev, "Please provide none-null label\n");
> +       }
> +
> +       if (label)
> +               return strcmp(port->rsvmap[offset].owner, label);
> +       else
> +               return -EINVAL;
> +}

Dito.

Just too simple helpers.

> +static inline unsigned int is_gpio_irq_enabled(struct gpio_port *port,
> +       unsigned offset)
> +{
> +       return port->rsvmap[offset].irq_enabled;
> +}
> +
> +static inline void enable_gpio_irq(struct gpio_port *port, unsigned offset)
> +{
> +       port->rsvmap[offset].irq_enabled = 1;
> +}
> +
> +static inline void disable_gpio_irq(struct gpio_port *port, unsigned offset)
> +{
> +       port->rsvmap[offset].irq_enabled = 0;
> +}

SInce you're only reading/writing to the memory cache of these registers
these functions are not really doing what they say they are doing.

Why are you not reading/writing the real registers?

> +static inline unsigned int is_reserved(struct gpio_port *port, char type,
> +       unsigned offset)
> +{
> +       switch (type) {
> +       case RSV_GPIO:
> +               return port->rsvmap[offset].rsv_gpio == 1;
> +       case RSV_INT:
> +               return port->rsvmap[offset].rsv_int == 1;
> +       case RSV_PERI:
> +               return port->rsvmap[offset].rsv_peri == 1;
> +       }
> +
> +       return 0;
> +}

After switching to bool use = true assignment instead.

> +static inline void reserve(struct gpio_port *port, char type, unsigned offset)
> +{
> +       switch (type) {
> +       case RSV_GPIO:
> +               port->rsvmap[offset].rsv_gpio = 1;
> +               break;
> +       case RSV_INT:
> +               port->rsvmap[offset].rsv_int = 1;
> +               break;
> +       case RSV_PERI:
> +               port->rsvmap[offset].rsv_peri = 1;
> +               break;
> +       }
> +}

Dito.

> +static inline void unreserve(struct gpio_port *port, char type, unsigned offset)
> +{
> +       switch (type) {
> +       case RSV_GPIO:
> +               port->rsvmap[offset].rsv_gpio = 0;
> +               break;
> +       case RSV_INT:
> +               port->rsvmap[offset].rsv_int = 0;
> +               break;
> +       case RSV_PERI:
> +               port->rsvmap[offset].rsv_peri = 0;
> +               break;
> +       }
> +}

= false;

> +static struct gpio_port *find_gpio_port(unsigned gpio)

The parameter should be named "offset" because this
cannot be a global Linux GPIO number.

> +{
> +       struct gpio_port *port;
> +
> +       list_for_each_entry(port, &adi_gpio_list, node)
> +               if (gpio >= port->chip.base &&
> +                       gpio < port->chip.base + port->width)
> +                       break;
> +
> +       if (&port->node != &adi_gpio_list)
> +               return port;
> +       else
> +               return NULL;
> +}
> +
> +static struct gpio_pint *find_gpio_pint(unsigned pint_id)
> +{
> +       struct gpio_pint *pint;
> +       int i = 0;
> +
> +       list_for_each_entry(pint, &adi_pint_list, node) {
> +               if (pint_id == i)
> +                       break;
> +               i++;
> +       }
> +
> +       if (&pint->node != &adi_pint_list)
> +               return pint;
> +       else
> +               return NULL;
> +}
> +
> +
> +static void __adi_gpio_irq_prepare(struct gpio_port *port, unsigned offset);
> +static int __adi_gpio_irq_request(struct gpio_port *port, unsigned offset,
> +       const char *label);
> +static void __adi_gpio_irq_free(struct gpio_port *port, unsigned offset);

Can you rearrange the code to avoid forward-declarations like these?

> +static void adi_gpio_ack_irq(struct irq_data *d)
> +{
> +       unsigned long flags;
> +       struct gpio_port *port = irq_data_get_irq_chip_data(d);
> +       struct gpio_pint_regs *regs = port->pint->regs;
> +       unsigned pintbit = irq_to_pintbit(port, d->irq);
> +
> +       spin_lock_irqsave(&port->lock, flags);
> +       spin_lock_irqsave(&port->pint->lock, flags);

Two locks to ACK an IRQ? Seems overengineered.

> +       if (irqd_get_trigger_type(d) == IRQ_TYPE_EDGE_BOTH) {
> +               if (regs->invert_set & pintbit)
> +                       regs->invert_clear = pintbit;
> +               else
> +                       regs->invert_set = pintbit;
> +       }
> +
> +       regs->request = pintbit;
> +
> +       spin_unlock_irqrestore(&port->pint->lock, flags);
> +       spin_unlock_irqrestore(&port->lock, flags);
> +}
> +
> +static void adi_gpio_mask_ack_irq(struct irq_data *d)
> +{
> +       unsigned long flags;
> +       struct gpio_port *port = irq_data_get_irq_chip_data(d);
> +       struct gpio_pint_regs *regs = port->pint->regs;
> +       unsigned pintbit = irq_to_pintbit(port, d->irq);
> +
> +       spin_lock_irqsave(&port->lock, flags);
> +       spin_lock_irqsave(&port->pint->lock, flags);

Dito.

Then this stuff:

> +               if (regs->invert_set & pintbit)
> +                       regs->invert_clear = pintbit;
> +               else
> +                       regs->invert_set = pintbit;
(...)
> +static void __adi_gpio_mask_irq(struct gpio_port *port, int irq)
> +       regs->mask_clear = pintbit;
(...)
> +static void __adi_gpio_unmask_irq(struct gpio_port *port, int irq)
> +       regs->mask_set = pintbit;

This as mentioned shall be replaced with proper IO accessor
macros (read[lwb]/write[lwb]).

(..)
> +/***********************************************************
> +*
> +* FUNCTIONS:   ADI Processor Peripheral Resource Allocation
> +*              and PortMux Setup
> +*
> +* INPUTS/OUTPUTS:
> +* per  Peripheral Identifier
> +* label        String
> +*
> +* DESCRIPTION: ADI Processor Peripheral Resource Allocation and Setup API
> +**************************************************************/

Skip this large boilerplate stuff. Looks like some extract from
$RTOS codebase. We are short and concise in Linux.

> +int peripheral_request(unsigned short per, const char *label)
> +{
> +       unsigned long flags;
> +       unsigned short ident = P_IDENT(per);
> +       struct gpio_port *port;
> +       unsigned offset;
> +
> +       /*
> +        * Don't cares are pins with only one dedicated function
> +        */
> +
> +       if (per & P_DONTCARE)
> +               return 0;
> +
> +       if (!(per & P_DEFINED))
> +               return -ENODEV;
> +
> +       port = find_gpio_port(ident);
> +       if (port == NULL)
> +               return -ENODEV;
> +
> +       spin_lock_irqsave(&port->lock, flags);
> +
> +       offset = gpio_to_offset(port, ident);
> +
> +       /* If a pin can be muxed as either GPIO or peripheral, make
> +        * sure it is not already a GPIO pin when we request it.
> +        */
> +       if (unlikely(is_reserved(port, RSV_GPIO, offset))) {
> +               if (system_state == SYSTEM_BOOTING)
> +                       dump_stack();
> +               dev_err(port->dev,
> +                      "%s: Peripheral %d is already reserved as GPIO by %s !\n",
> +                      __func__, ident, get_label(port, offset));
> +               spin_unlock_irqrestore(&port->lock, flags);
> +               return -EBUSY;
> +       }
> +
> +       if (unlikely(is_reserved(port, RSV_PERI, offset))) {
> +
> +               /*
> +                * Pin functions like AMC address strobes my
> +                * be requested and used by several drivers
> +                */
> +
> +               if (!((per & P_MAYSHARE) && get_portmux(port, offset) ==
> +                       P_FUNCT2MUX(per))) {
> +                       /*
> +                        * Allow that the identical pin function can
> +                        * be requested from the same driver twice
> +                        */
> +
> +                       if (cmp_label(port, offset, label) == 0)
> +                               goto anyway;
> +
> +                       if (system_state == SYSTEM_BOOTING)
> +                               dump_stack();
> +                       dev_err(port->dev,
> +                               "%s: Peripheral %d function %d is already reserved by %s !\n",
> +                               __func__, ident, P_FUNCT2MUX(per),
> +                               get_label(port, offset));
> +                       spin_unlock_irqrestore(&port->lock, flags);
> +                       return -EBUSY;
> +               }
> +       }
> +
> + anyway:
> +       reserve(port, RSV_PERI, offset);
> +
> +       portmux_setup(port, offset, P_FUNCT2MUX(per));
> +       port_setup(port, offset, PERIPHERAL_USAGE);
> +
> +       set_label(port, offset, label);
> +
> +       spin_unlock_irqrestore(&port->lock, flags);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(peripheral_request);

This entire functionality shall be rewritten to use the pinctrl subsystem.

Don't bother to send anything resembling this again, custom accessor
functions for muxing pins is a thing of the past.

(...)
 +++ b/include/linux/platform_data/gpio-adi2.h
(...)
> +struct adi_gpio_platform_data {
> +       int port_pin_base;      /* optional, 0 - driver decides */

Use pinctrl subsystem.

> +       int port_width;

unsigned.

> +       u8 pint_id;             /* which pint to map the gpio port */
> +       u8 pint_assign;         /* 0 - assgin to 1ow 16 bits
> +                                * 1 - assign to high 16 bits
> +                                */

Still not getting this.

> +       u8 pint_map;            /* port mapping mask in pint */

Use irqdomain.

Overall this code has very many issues, even if you actually
manage to get it through checkpatch it doesn't mean the code
is in good shape.

Please do atleast the following before the next iteration:

- Put driver in drivers/pinctrl, implement a proper muxing
  interface instead of the custom stuff. Create a combined
  pinctrl+GPIO driver, look at other drivers for guidance.

- Make sure the code can compile! This is missing critical
  structs etc, and cannot possibly build.

- Get rid of the horrid struct gpio_pint_regs and replace with
  proper IO accessors.

- Use irqdomain for IRQ demuxing.

- Remove overengineering like needlessly splitting simple
  oneliners into helper functions.

Yours,
Linus Walleij
