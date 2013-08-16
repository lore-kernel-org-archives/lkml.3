Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab3HPGXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 02:23:20 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46387 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab3HPGXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 02:23:17 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkda2EQTfVmuBVunLY4kWiNFK52Wy94u4ZoJ4GUVwWRsvwg@mail.gmail.com>
References: <1373972146-12133-1-git-send-email-sonic.adi@gmail.com>
	<CACRpkda2EQTfVmuBVunLY4kWiNFK52Wy94u4ZoJ4GUVwWRsvwg@mail.gmail.com>
Date: Fri, 16 Aug 2013 14:23:16 +0800
Message-ID: <CAJxxZ0OXWaiWQ4Fmpj34x=g1D4khr9Z1P6DO75Vp6-Q6FiHqeQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: ADI PIN control driver for the GPIO
 controller on bf54x and bf60x.
From: Sonic Zhang <sonic.adi@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Steven Miao <realmz6@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        "buildroot-devel@blackfin.uclinux.org" 
	<buildroot-devel@blackfin.uclinux.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

()Hi Linus,



On Wed, Aug 14, 2013 at 9:47 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> i Sonic,
>
> sorry for taking so long before reviewing this, I was on vacation and
> had various urgent things to take care of.

Thank you for your time.

>
> On Tue, Jul 16, 2013 at 12:55 PM, Sonic Zhang <sonic.adi@gmail.com> wrote:
>
>> From: Sonic Zhang <sonic.zhang@analog.com>
>>
>> The new ADI GPIO2 controller was introduced since the BF548 and BF60x
>> processors. It differs a lot from the old one on BF5xx processors. So,
>> create a pinctrl driver under pinctrl framework.
>>
>> - Define gpio ports and gpio interrupt controllers as individual platform
>> devices.
>> - Register a pinctrl driver for the whole GPIO ports and GPIO interrupt
>> devices.
>> - Probe pint devices before port devices. Put device instances into
>> respective gpio and pint lists.
>> - Define peripheral, irq and gpio reservation bit masks for each gpio
>> port as runtime resources.
>> - Save and restore gpio port and pint status MMRs in syscore PM functions.
>> - Add peripheral device groups and function data into machine portmux.h.
>> - Handle peripheral and gpio requests in pinctrl operation functions.
>> - Demux gpio IRQs via the irq_domain created by each GPIO port.
>>
>> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>
> OK...
>
>> +++ b/drivers/pinctrl/pinctrl-adi2.c
>> @@ -0,0 +1,1545 @@
>> +/*
>> + * Pinctrl Driver for ADI GPIO2 controller
>> + *
>> + * Copyright 2007-2013 Analog Devices Inc.
>> + *
>> + * Licensed under the GPLv2 or later
>> + */
>> +
>> +#include <linux/delay.h>
>> +#include <linux/module.h>
>> +#include <linux/err.h>
>> +#include <linux/proc_fs.h>
>> +#include <linux/seq_file.h>
>> +#include <linux/irq.h>
>> +#include <linux/platform_data/pinctrl-adi2.h>
>> +#include <linux/irqdomain.h>
>> +#include <linux/irqchip/chained_irq.h>
>> +#include <linux/pinctrl/pinctrl.h>
>> +#include <linux/pinctrl/pinmux.h>
>> +#include <linux/pinctrl/consumer.h>
>> +#include <linux/pinctrl/machine.h>
>> +#include <linux/syscore_ops.h>
>> +#include <linux/gpio.h>
>> +#include <asm/portmux.h>
>> +#include "core.h"
>> +
>> +static LIST_HEAD(adi_pint_list);
>> +static LIST_HEAD(adi_pinctrl_list);
>
> No locks? It seems you getting this all wrong, defining
> locks inside the per-instance structs for these lists. That is
> not going to protect anything from concurrent use.
>
> Use static local locks right here for the lists instead.

These 2 lists are only increased in the device probe stage. There is
no concurrent use issue in this stage. And because they are not
changed any more after the probe stage, it is not necessary to lock
the list finding operation as well.


>
>> +
>> +#define PERIPHERAL_USAGE 1
>> +#define GPIO_USAGE 0
>> +
>> +#define DRIVER_NAME "pinctrl-adi2"
>> +
>> +#define RESOURCE_LABEL_SIZE    16
>> +#define PINT_HI_OFFSET         16
>> +
>> +#define RSV_NONE       0
>> +#define RSV_GPIO       1
>> +#define RSV_INT                2
>> +#define RSV_PERI       3
>> +
>> +/**
>> + * struct gpio_reserve_map - a GPIO map structure containing the
>> + * reservation status of each PIN.
>> + *
>> + * @owner: who request the reservation
>> + * @rsv_gpio: if this pin is reserved as GPIO
>> + * @rsv_int: if this pin is reserved as interrupt
>> + * @rsv_peri: if this pin is reserved as part of a peripheral device
>> + */
>> +struct gpio_reserve_map {
>> +       unsigned char owner[RESOURCE_LABEL_SIZE];
>> +       bool rsv_gpio;
>> +       bool rsv_int;
>> +       bool rsv_peri;
>> +};
>
> Hm if a pin is us used for interrupts is it not also used
> for GPIO at the same time?
>

The interrupt pin is requested and reserved in irq_chip operation
irq_set_type() other than gpio_request(). In Blackfin, one gpio pin is
allowed to be set up as both gpio interrupt and gpio input. So, we
need bits to differentiate them.

> I don't understand why you want to keep track of this stuff,
> basically the kernel frameworks are already abstracting
> this but I guess there is some good reason for this.
>
>> +/**
>> + * struct gpio_port_saved - GPIO port registers that should be saved between
>> + * power suspend and resume operations.
>> + *
>> + * @fer: PORTx_FER register
>> + * @data: PORTx_DATA register
>> + * @dir: PORTx_DIR register
>> + * @inen: PORTx_INEN register
>> + * @mux: PORTx_MUX register
>> + */
>> +struct gpio_port_saved {
>> +       u16 fer;
>> +       u16 data;
>> +       u16 dir;
>> +       u16 inen;
>> +       u32 mux;
>> +};
>
> Seem straight-forward.
>
>> +/**
>> + * struct gpio_pint - GPIO interrupt controller device. Multiple ADI GPIO
>> + * banks can be mapped into one GPIO interrupt controller.
>> + *
>> + * @node: All gpio_pint instances are added to a global list.
>
> Why? Usually we make drivers self-contained per instance, no need
> for one driver instance to know about all the others.

Because the pint device is independent from the GPIO port device. The
GPIO port device finds out which pint device it should route to in its
probe stage. So, the pint devices should be probed and added to the
pint list before the GPIO port devices are probed. Yes, after the
probe stage, GPIO port device knows nothing of the other pint device.

>
>> + * @base: GPIO PINT device register base address
>> + * @irq: IRQ of the GPIO PINT device, it is the parent IRQ of all
>> + *       GPIO IRQs mapping to this device.
>> + * @domain: [0] irq domain of the gpio port, whose hardware interrupts are
>> + *             mapping to the low 16-bit of the pint registers.
>> + *          [1] irq domain of the gpio port, whose hardware interrupts are
>> + *             mapping to the high 16-bit of the pint registers.
>> + * @regs: address pointer to the GPIO PINT device> +
>
>
> What is this struct gpio_pint_regs? I tried to grep the kernel for it:
> zero hits. Is this some way to pass the physical address or something?
> Anyway you need to merge the code introducing this struct *first*
> since it is not before this patch I guess this patch set is not based
> on the mainline Linux kernel...

struct gpio_pint_regs can be found in [patch 3/3] blackfin:
pinctrl-adi2: Add pin control device groups and function data.

>
> What is a "pint"? It doesn't seem to be a "port interrupt" or anything
> like that....
>
> This is what it means to most:
> http://en.wikipedia.org/wiki/Pint

According to the BF54x HRM, pint means "pin interrupt".
http://www.analog.com/static/imported-files/processor_manuals/ADSP-BF54x_hwr_rev1.2.pdf

ADSP-BF54x processor Blackfin processors have four SIC interrupt chan-
nels dedicated to pin interrupt purposes. These channels are managed by
four hardware blocks, called PINT0, PINT1, PINT2, and PINT3. Every PINTx
block can sense to up to 32 pins. While PINT0 and PINT1 can sense the
pins of port A and port B, PINT2 and PINT3 manage all the pins from port
C to port J as shown in Figure 9-2.



>
>> + * @map_count: No more than 2 GPIO banks can be mapped to this PINT device.
>
> Why? Explain here what it means to "map a GPIO bank to a  PINT device".

In BF54x HRM:
The ten GPIO ports are subdivided into 8-bit half ports, resulting in lower and
upper half 8-bit units. The PINTx_ASSIGN registers control the 8-bit multi-
plexers shown in Figure 9-3. Lower half units of eight pins can be
forwarded to either byte 0 or byte 2 of either associated PINTx block.
Upper half units can be forwarded to either byte 1 or byte 3 of the pin
interrupt blocks, without further restrictions.

All MMR registers in the pin interrupt module are 32 bits wide. To
simply the mapping logic, this driver only maps a 16-bit gpio port to
the upper or lower 16 bits of a PINTx block. You can find the Figure
9-3 on page 583.


>
>> + * @lock: This lock make sure the irq_chip operations to one GPIO PINT device
>> + *        for different GPIO interrrupts are atomic.
>> + * @pint_map_port: Set up the mapping between one GPIO PINT device and
>> + *                 multiple GPIO banks.
>
> I don't realize why you need a function pointer for this, and why it needs to be
> in this local state container, but I'll read on...
>
>> + */
>> +struct gpio_pint {
>> +       struct list_head node;
>> +       void __iomem *base;
>> +       int irq;
>> +       struct irq_domain *domain[2];
>> +       struct gpio_pint_regs *regs;
>> +       struct adi_pm_pint_save saved_data;
>> +       int map_count;
>> +       spinlock_t lock;
>> +
>> +       int (*pint_map_port)(struct gpio_pint *pint, u8 assign,
>> +                               u8 map, struct irq_domain *domain);
>> +};
>> +
>> +/**
>> + * ADI pin controller
>
>
>> + *
>> + * @node: All adi_pmx instances are added to a global list.
>> + * @dev: a pointer back to containing device
>> + * @pctl: the pinctrl device
>> + * @gpio_list: the list of gpio banks owned by this pin controller.
>> + * @gpio_base: the base gpio number of this pin controller.
>
> This looks like you are re-implementing the GPIO ranges that we
> already have in the pinctrl subsystem. Please look at the other
> drivers and try to use the same style and common infrastructure.
> The GPIO ranges are also well documented in Documentation/pinctrl.txt
>

In order to keep GPIO number consistent with BF5xx driver, the
gpio_base is used to initialize the GPIO ranges according to the
predefined GPIO numbers in platform data struct. This is for backward
compatibility in Blackfin architecture.

>> + */
>> +struct adi_pmx {
>
> If it is a pin controller... then rename it adi_pinctrl.

OK

>
>> +       struct list_head node;
>> +       struct device *dev;
>> +       struct pinctrl_dev *pctl;
>> +       struct list_head gpio_list;
>> +       unsigned long gpio_base;
>> +};
>> +
>> +/**
>> + * struct gpio_pint - GPIO bank device. Multiple ADI GPIO banks can be mapped
>
> pint? Port? The struct is named port...
>
> Please check this in the entire file.
>

OK

>> + * into one GPIO interrupt controller.
>> + *
>> + * @node: All gpio_pint instances are added to a list.
>> + * @base: GPIO bank device register base address
>> + * @pin_base: base global GPIO pin index of the GPIO bank device
>
> I think this is another aspect of reimplementing GPIO ranges.

No, this pin_base variable is not used after move to GPIO ranges. I
will remove it.

>
>> + * @irq_base: base IRQ of the GPIO bank device
>> + * @width: PIN number of the GPIO bank device
>> + * @range: The range space of the GPIO bank handled by the pin controller.
>> + * @regs: address pointer to the GPIO bank device
>> + * @saved_data: registers that should be saved between PM operations.
>> + * @dev: device structure of this GPIO bank
>> + * @pmx: the pinctrl device
>> + * @pint: GPIO PINT device that this GPIO bank mapped to
>> + * @pint_map: GIOP bank mapping code in PINT device
>> + * @pint_assign: The 32-bit GPIO PINT registers can be divided into 2 parts. A
>> + *               GPIO bank can be mapped into either low 16 bits[0] or high 16
>> + *               bits[1] of each PINT register.
>
> Is this always 0 or 1? Then you should instead have a bool
> named bool is_high; or something.

OK

>
>> + * @lock: This lock make sure the irq_chip operations to one GPIO PINT device
>> + *        for different GPIO interrrupts are atomic.
>> + * @chip: abstract a GPIO controller
>> + * @domain: The irq domain owned by the GPIO port.
>
> Here seems to be many IRQ domains, this this really necessary?
>
> Two in "struct gpio_pint" and one more here? Why?

Each IRQ domain is binding to a GPIO bank device. 2 GPIO bank devices
can map to one PINT device. Two in "struct gpio_pint" are used to ease
the PINT interrupt handler.

The GPIO bank mapping to the lower 16 bits of the PINT device set its
IRQ domain pointer in domain[0]. The IRQ domain pointer of the other
bank is set to domain[1]. PINT interrupt handler
adi_gpio_handle_pint_irq() finds out the current domain pointer
according to whether the interrupt request mask is in lower 16 bits
(domain[0]) or upper 16bits (domain[1]).

>
> This seems very complex.
>
> I think you basically need to structure the code and add comments to
> the driver header so that it is chrystal clear why we have two abstractions
> named "pint" and "port" and how they relate to each other.

OK.

>
>> + * @rsvmap: Reservation map array for each pin in the GPIO bank
>> + */
>> +struct gpio_port {
>> +       struct list_head node;
>> +       void __iomem *base;
>> +       unsigned int pin_base;
>> +       unsigned int irq_base;
>> +       unsigned int width;
>> +       struct pinctrl_gpio_range range;
>
> Here you're finally using the GPIO ranges.
>
>> +       struct gpio_port_t *regs;
>
> Suffuxing things with _t, like it's a type, is hungarian notation
> and is not encouraged in the kernel... anyway I see this is
> already in the kernel so not your fault I guess.
>
>> +       struct gpio_port_saved saved_data;
>> +       struct device *dev;
>> +       struct adi_pmx *pmx;
>
> Can't you just make the members of this struct (adi_pmx)
> member of this struct and cut down on unnecessary structs?
>
>> +
>> +       struct gpio_pint *pint;
>> +       u8 pint_map;
>> +       u8 pint_assign;
>> +
>> +       spinlock_t lock;
>> +       struct gpio_chip chip;
>> +       struct irq_domain *domain;
>> +
>> +       struct gpio_reserve_map rsvmap[];
>
> And this reserve map.
>
>> +};
>
> What I do not understand is why you need gpio_pint?
>
> Usually this struct is all you need.

As I explained above, A PINT device is not part of a GPIO port device
in Blackfin. Multiple GPIO port devices can be mapped to the same PINT
device.

>
>> +static inline u8 pin_to_offset(struct pinctrl_gpio_range *range, unsigned pin)
>> +{
>> +       return pin - range->pin_base;
>> +}
>> +
>> +static inline unsigned offset_to_gpio(struct gpio_port *port, u8 offset)
>> +{
>> +       return offset + port->chip.base;
>> +}
>> +
>> +static inline u8 gpio_to_offset(struct gpio_port *port, unsigned gpio)
>> +{
>> +       return gpio - port->chip.base;
>> +}
>
> Hmmmm we need this kind of stuff to be done in the pinctrl core. Usually
> this should not be needed. Why do you need to do this?
>
>> +static inline unsigned hwirq_to_pintbit(struct gpio_port *port, int hwirq)
>
> Why is this unsigned? Isn't it really u32 or u16?

Should be u32.

>
>> +{
>> +       return (1 << hwirq) << (port->pint_assign * PINT_HI_OFFSET);
>
> Atleast do this:
>
> #include <linux/bitops.h>
>
> return BIT(hwirq) << (port->pint_assign * PINT_HI_OFFSET);
>
> If pin_assign is only 0 or 1 as I suspect, this is  very unelegant
> construction. Then I would prefer:
>
> return port->pint_assign ? BIT(offset) << PINT_HI_OFFSET : BIT(offset);
>
> or something like that where you can see what is going on.

OK

>
>> +static void set_label(struct gpio_port *port, unsigned offset,
>> +       const char *label)
>> +{
>> +       char *pch = port->rsvmap[offset].owner;
>> +
>> +       if (label) {
>> +               strncpy(pch, label, RESOURCE_LABEL_SIZE);
>> +               pch[RESOURCE_LABEL_SIZE - 1] = 0;
>> +       }
>> +}
>> +
>> +static char *get_label(struct gpio_port *port, unsigned offset)
>> +{
>> +       char *pch = port->rsvmap[offset].owner;
>> +
>> +       return *pch ? pch : "UNKNOWN";
>> +}
>
> Hm, OK ...
>
>> +static inline unsigned int is_reserved(struct gpio_port *port, char type,
>> +       unsigned offset)
>
> The return type should be bool should it not?
>
>> +{
>> +       switch (type) {
>> +       case RSV_GPIO:
>> +               return port->rsvmap[offset].rsv_gpio == true;
>> +       case RSV_INT:
>> +               return port->rsvmap[offset].rsv_int == true;
>> +       case RSV_PERI:
>> +               return port->rsvmap[offset].rsv_peri == true;
>> +       }
>
> For each of these just e.g.:
> return port->rsvmap[offset].rsv_gpio
>
> You're making this simple thing look very complicated.

OK

>
>> +
>> +       return 0;
>> +}
>> +
>> +static inline void reserve(struct gpio_port *port, char type, unsigned offset)
>> +{
>> +       switch (type) {
>> +       case RSV_GPIO:
>> +               port->rsvmap[offset].rsv_gpio = true;
>> +               break;
>> +       case RSV_INT:
>> +               port->rsvmap[offset].rsv_int = true;
>> +               break;
>> +       case RSV_PERI:
>> +               port->rsvmap[offset].rsv_peri = true;
>> +               break;
>> +       }
>> +}
>> +
>> +static inline void unreserve(struct gpio_port *port, char type, unsigned offset)
>> +{
>> +       switch (type) {
>> +       case RSV_GPIO:
>> +               port->rsvmap[offset].rsv_gpio = false;
>> +               break;
>> +       case RSV_INT:
>> +               port->rsvmap[offset].rsv_int = false;
>> +               break;
>> +       case RSV_PERI:
>> +               port->rsvmap[offset].rsv_peri = false;
>> +               break;
>> +       }
>> +}
>
> Having helper functions for these things seem a bit overdesigned
> actually. Do you really need them?

OK. I will remove them.

>
>> +static struct gpio_pint *find_gpio_pint(unsigned id)
>> +{
>> +       struct gpio_pint *pint;
>> +       int i = 0;
>> +
>> +       list_for_each_entry(pint, &adi_pint_list, node) {
>> +               if (id == i)
>> +                       break;
>
> Just return pint; here
>
>> +               i++;
>> +       }
>> +
>> +       if (&pint->node != &adi_pint_list)
>> +               return pint;
>
> And skip this super-confusing thing.
>
>> +       else
>> +               return NULL;
>> +}
>
> And just return NULL;

OK

>
>> +
>> +static struct adi_pmx *find_pinctrl(unsigned id)
>> +{
>> +       struct adi_pmx *pmx;
>> +       int i = 0;
>> +
>> +       list_for_each_entry(pmx, &adi_pinctrl_list, node) {
>> +               if (id == i)
>> +                       break;
>> +               i++;
>> +       }
>> +
>> +       if (&pmx->node != &adi_pinctrl_list)
>> +               return pmx;
>> +       else
>> +               return NULL;
>> +}
>
> Same comments.
>
> If you merge the pmx and gpio_port structs into one you
> will at least just need one of these functions.
>
> But I am suspecting that all this is unnecessary and you
> should be using something like container_of() instead.
>
> Do you know and understand the kernel container_of()
> abstraction pattern? Else please look at examples of how
> we use this.
>
>> +static struct gpio_port *find_gpio_port(unsigned pin,
>> +       struct list_head *gpio_list)
>> +{
>> +       struct gpio_port *port;
>> +
>> +       list_for_each_entry(port, gpio_list, node)
>> +               if (pin >= port->range.pin_base &&
>> +                       pin < port->range.pin_base + port->range.npins)
>> +                       break;
>> +
>> +       if (&port->node != gpio_list)
>> +               return port;
>> +       else
>> +               return NULL;
>> +}
>
> Same comments.

OK

>
>> +static inline void port_setup(struct gpio_port *port, unsigned offset,
>> +       unsigned short usage)
>
> Either usage should be an enum or you can replace it with a bool
> like bool use_for_gpio.

OK

>
>> +{
>> +       struct gpio_port_t *regs = port->regs;
>> +
>> +       if (usage == GPIO_USAGE)
>> +               writew(readw(&regs->port_fer) & ~(1 << offset),
>> +                       &regs->port_fer);
>
> Use BIT(offset)
>
> This &regs->ports_fer is really awkward but I guess all
> blackfin stuff is written that way?
>
>> +       else
>> +               writew(readw(&regs->port_fer) | (1 << offset), &regs->port_fer);
>
> Use BIT(offset)

OK

>
>> +}
>> +
>> +static inline void portmux_setup(struct gpio_port *port, unsigned offset,
>> +       unsigned short function)
>> +{
>> +       struct gpio_port_t *regs = port->regs;
>> +       u32 pmux;
>> +
>> +       pmux = readl(&regs->port_mux);
>> +
>> +       pmux &= ~(0x3 << (2 * offset));
>> +       pmux |= (function & 0x3) << (2 * offset);
>
> 0x3? why? 2*offset?
>
> Care to put in a comment on what is happening here?
> Like that we use 2 consecutive bits for setting function?

OK

>
>> +
>> +       writel(pmux, &regs->port_mux);
>> +}
>> +
>> +static inline u16 get_portmux(struct gpio_port *port, unsigned offset)
>> +{
>> +       struct gpio_port_t *regs = port->regs;
>> +       u32 pmux = readl(&regs->port_mux);
>> +
>> +       return pmux >> (2 * offset) & 0x3;
>
> Dito...
>
>> +}
>> +
>> +
>> +static void __adi_gpio_irq_prepare(struct gpio_port *port, unsigned offset)
>> +{
>> +       struct gpio_port_t *regs = port->regs;
>> +
>> +       port_setup(port, offset, GPIO_USAGE);
>> +
>> +       writew(1 << offset, &regs->dir_clear);
>
> BIT(offset)
>
>> +       writew(readw(&regs->inen) | (1 << offset), &regs->inen);
>
> etc.

OK

>
>> +}
>> +
>> +static int __adi_gpio_irq_request(struct gpio_port *port, unsigned offset,
>> +       const char *label)
>> +{
>> +       if (unlikely(is_reserved(port, RSV_PERI, offset))) {
>> +               if (system_state == SYSTEM_BOOTING)
>> +                       dump_stack();
>> +
>> +               dev_err(port->dev,
>> +                      "GPIO %d is already reserved as Peripheral by %s !\n",
>> +                       offset_to_gpio(port, offset), get_label(port, offset));
>> +               return -EBUSY;
>> +       }
>> +       if (unlikely(is_reserved(port, RSV_GPIO, offset)))
>> +               dev_err(port->dev,
>> +                       "GPIO %d is already reserved by %s!\n",
>> +                       offset_to_gpio(port, offset), get_label(port, offset));
>
> As mentioned get rid of unlikely() macros.
>
>> +
>> +       reserve(port, RSV_INT, offset);
>> +       set_label(port, offset, label);
>> +       port_setup(port, offset, GPIO_USAGE);
>> +
>> +       return 0;
>> +}
>> +
>> +static void __adi_gpio_irq_free(struct gpio_port *port, unsigned offset)
>> +{
>> +       if (unlikely(!is_reserved(port, RSV_INT, offset))) {
>> +               if (system_state == SYSTEM_BOOTING)
>> +                       dump_stack();
>> +
>> +               dev_err(port->dev, "GPIO %d wasn't requested!\n",
>> +                       offset_to_gpio(port, offset));
>> +               return;
>> +       }
>> +
>> +       unreserve(port, RSV_INT, offset);
>> +       set_label(port, offset, "free");
>> +}
>> +
>> +static void adi_gpio_ack_irq(struct irq_data *d)
>> +{
>> +       unsigned long flags;
>> +       struct gpio_port *port = irq_data_get_irq_chip_data(d);
>> +       struct gpio_pint_regs *regs = port->pint->regs;
>> +       unsigned pintbit = hwirq_to_pintbit(port, d->hwirq);
>> +
>> +       spin_lock_irqsave(&port->lock, flags);
>> +       spin_lock_irqsave(&port->pint->lock, flags);
>
> Taking two locks to ACK an IRQ is really inconvenient is it not?
>
> It also impacts performance.
>
> This is one reason you should try to get rid of excess
> structs in this driver.

As I explained above, these PINT and GPIO port structs can't be
merged. They are not one by one. And double locks are only required in
irq_chip operations. Portmux and GPIO operations only lock once in
GPIO port.

>
> If any or both locks are really locks for the lists, then make
> the static locals in the driver instead of part of the struct.

NO, these locks are not for the lists.

>
>> +
>> +       if (irqd_get_trigger_type(d) == IRQ_TYPE_EDGE_BOTH) {
>> +               if (readl(&regs->invert_set) & pintbit)
>> +                       writel(pintbit, &regs->invert_clear);
>> +               else
>> +                       writel(pintbit, &regs->invert_set);
>> +       }
>> +
>> +       writel(pintbit, &regs->request);
>> +
>> +       spin_unlock_irqrestore(&port->pint->lock, flags);
>> +       spin_unlock_irqrestore(&port->lock, flags);
>> +}
>> +
>> +static void adi_gpio_mask_ack_irq(struct irq_data *d)
>> +{
>> +       unsigned long flags;
>> +       struct gpio_port *port = irq_data_get_irq_chip_data(d);
>> +       struct gpio_pint_regs *regs = port->pint->regs;
>> +       unsigned pintbit = hwirq_to_pintbit(port, d->hwirq);
>> +
>> +       spin_lock_irqsave(&port->lock, flags);
>> +       spin_lock_irqsave(&port->pint->lock, flags);
>> +
>> +       if (irqd_get_trigger_type(d) == IRQ_TYPE_EDGE_BOTH) {
>> +               if (readl(&regs->invert_set) & pintbit)
>> +                       writel(pintbit, &regs->invert_clear);
>> +               else
>> +                       writel(pintbit, &regs->invert_set);
>> +       }
>> +
>> +       writel(pintbit, &regs->request);
>> +       writel(pintbit, &regs->mask_clear);
>> +
>> +       spin_unlock_irqrestore(&port->pint->lock, flags);
>> +       spin_unlock_irqrestore(&port->lock, flags);
>> +}
>> +
>> +static void adi_gpio_mask_irq(struct irq_data *d)
>> +{
>> +       unsigned long flags;
>> +       struct gpio_port *port = irq_data_get_irq_chip_data(d);
>> +       struct gpio_pint_regs *regs = port->pint->regs;
>> +
>> +       spin_lock_irqsave(&port->lock, flags);
>> +       spin_lock_irqsave(&port->pint->lock, flags);
>> +
>> +       writel(hwirq_to_pintbit(port, d->hwirq), &regs->mask_clear);
>> +
>> +       spin_unlock_irqrestore(&port->pint->lock, flags);
>> +       spin_unlock_irqrestore(&port->lock, flags);
>
> So like in a case like this taking two locks to write a single
> bit in a single register is starting to look a bit silly.
>
>> +}
>> +
>> +static void adi_gpio_unmask_irq(struct irq_data *d)
>> +{
>> +       unsigned long flags;
>> +       struct gpio_port *port = irq_data_get_irq_chip_data(d);
>> +       struct gpio_pint_regs *regs = port->pint->regs;
>> +
>> +       spin_lock_irqsave(&port->lock, flags);
>> +       spin_lock_irqsave(&port->pint->lock, flags);
>> +
>> +       writel(hwirq_to_pintbit(port, d->hwirq), &regs->mask_set);
>> +
>> +       spin_unlock_irqrestore(&port->pint->lock, flags);
>> +       spin_unlock_irqrestore(&port->lock, flags);
>> +}
>
> Dito.
>
>> +static unsigned int adi_gpio_irq_startup(struct irq_data *d)
>> +{
>> +       unsigned long flags;
>> +       struct gpio_port *port = irq_data_get_irq_chip_data(d);
>> +       struct gpio_pint_regs *regs = port->pint->regs;
>> +
>> +       if (!port) {
>> +               dev_err(port->dev, "GPIO IRQ %d :Not exist\n", d->irq);
>> +               return -ENODEV;
>> +       }
>> +
>> +       spin_lock_irqsave(&port->lock, flags);
>> +       spin_lock_irqsave(&port->pint->lock, flags);
>> +
>> +       __adi_gpio_irq_prepare(port, d->hwirq);
>> +       writel(hwirq_to_pintbit(port, d->hwirq), &regs->mask_set);
>> +
>> +       spin_unlock_irqrestore(&port->pint->lock, flags);
>> +       spin_unlock_irqrestore(&port->lock, flags);
>> +
>> +       return 0;
>> +}
>
> Dito.
>
>> +static void adi_gpio_irq_shutdown(struct irq_data *d)
>> +{
>> +       unsigned long flags;
>> +       struct gpio_port *port = irq_data_get_irq_chip_data(d);
>> +       struct gpio_pint_regs *regs = port->pint->regs;
>> +
>> +       spin_lock_irqsave(&port->lock, flags);
>> +       spin_lock_irqsave(&port->pint->lock, flags);
>> +
>> +       writel(hwirq_to_pintbit(port, d->hwirq), &regs->mask_clear);
>> +       __adi_gpio_irq_free(port, d->hwirq);
>> +
>> +       spin_unlock_irqrestore(&port->pint->lock, flags);
>> +       spin_unlock_irqrestore(&port->lock, flags);
>> +}
>
> Dito.
>
>> +static int adi_gpio_irq_type(struct irq_data *d, unsigned int type)
>> +{
>> +       unsigned long flags;
>> +       struct gpio_port *port = irq_data_get_irq_chip_data(d);
>> +       struct gpio_pint_regs *pint_regs = port->pint->regs;
>> +       unsigned pintmask;
>> +       unsigned int irq = d->irq;
>> +       int ret = 0;
>> +       char buf[16];
>> +
>> +       if (!port) {
>> +               dev_err(port->dev, "GPIO IRQ %d :Not exist\n", irq);
>> +               return -ENODEV;
>> +       }
>> +
>> +       pintmask = hwirq_to_pintbit(port, d->hwirq);
>> +
>> +       spin_lock_irqsave(&port->lock, flags);
>> +       spin_lock_irqsave(&port->pint->lock, flags);
>> +
>> +       if (type == IRQ_TYPE_PROBE)
>> +               type = IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING;
>
> What does this mean in practice? Add a comment explaining
> why you do this.

These are from bf5xx legacy gpio driver, I need checking with the
former developer.

>
>> +
>> +       if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
>> +                   IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW)) {
>> +               snprintf(buf, 16, "gpio-irq%d", irq);
>> +               ret = __adi_gpio_irq_request(port, d->hwirq, buf);
>> +               if (ret)
>> +                       goto out;
>> +       } else
>> +               goto out;
>> +
>> +       if ((type & (IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_LEVEL_LOW)))
>> +               /* low or falling edge denoted by one */
>> +               writel(pintmask, &pint_regs->invert_set);
>> +       else
>> +               /* high or rising edge denoted by zero */
>> +               writel(pintmask, &pint_regs->invert_clear);
>
> So one register to set and one to clear the flags, clever...
>
>> +       if ((type & IRQ_TYPE_EDGE_BOTH) == IRQ_TYPE_EDGE_BOTH) {
>> +               if (gpio_get_value(offset_to_gpio(port, d->hwirq)))
>> +                       writel(pintmask, &pint_regs->invert_set);
>> +               else
>> +                       writel(pintmask, &pint_regs->invert_clear);
>> +       }
>
> Care to explain what's happening here? Some comment in the
> code?

These are from bf5xx legacy gpio driver, I need checking with the
former developer.


>
>> +       if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING)) {
>> +               writel(pintmask, &pint_regs->edge_set);
>> +               __irq_set_handler_locked(irq, handle_edge_irq);
>> +       } else {
>> +               writel(pintmask, &pint_regs->edge_clear);
>> +               __irq_set_handler_locked(irq, handle_level_irq);
>> +       }
>
> I think I understand this part.
>
>> +
>> +out:
>> +       spin_unlock_irqrestore(&port->pint->lock, flags);
>> +       spin_unlock_irqrestore(&port->lock, flags);
>> +
>> +       return ret;
>> +}
>> +
>> +#ifdef CONFIG_PM
>> +static int adi_gpio_set_wake(struct irq_data *d, unsigned int state)
>> +{
>> +       struct gpio_port *port = irq_data_get_irq_chip_data(d);
>> +
>> +       if (!port && !port->pint && port->pint->irq != d->irq)
>> +               return -EINVAL;
>
> Why are you using the && operator here?
>
> If port is NULL it will go on an dereference port->pint and have
> a NULL reference.
>
> Probably you meant to use ||.

Yes, typo.

>
>> +#ifndef SEC_GCTL
>> +       adi_internal_set_wake(port->pint->irq, state);
>> +#endif
>> +
>> +       return 0;
>> +}
>> +
>> +static int adi_pint_suspend(void)
>> +{
>> +       struct gpio_pint *pint;
>> +
>> +       list_for_each_entry(pint, &adi_pint_list, node) {
>> +               writel(0xffffffff, &pint->regs->mask_clear);
>> +               pint->saved_data.assign = readl(&pint->regs->assign);
>> +               pint->saved_data.edge_set = readl(&pint->regs->edge_set);
>> +               pint->saved_data.invert_set = readl(&pint->regs->invert_set);
>> +       }
>
> Will the wakeups really work if you clear all regs like this?

Yes, it works well on Blackfin.

>
>> +
>> +       return 0;
>> +}
>> +
>> +static void adi_pint_resume(void)
>> +{
>> +       struct gpio_pint *pint;
>> +
>> +       list_for_each_entry(pint, &adi_pint_list, node) {
>> +               writel(pint->saved_data.assign, &pint->regs->assign);
>> +               writel(pint->saved_data.edge_set, &pint->regs->edge_set);
>> +               writel(pint->saved_data.invert_set, &pint->regs->invert_set);
>> +       }
>> +}
>> +
>> +static int adi_gpio_suspend(void)
>> +{
>> +       struct adi_pmx *pmx;
>> +       struct gpio_port *port;
>> +
>> +       list_for_each_entry(pmx, &adi_pinctrl_list, node)
>> +               list_for_each_entry(port, &pmx->gpio_list, node) {
>> +                       port->saved_data.fer = readw(&port->regs->port_fer);
>> +                       port->saved_data.mux = readl(&port->regs->port_mux);
>> +                       port->saved_data.data = readw(&port->regs->data);
>> +                       port->saved_data.inen = readw(&port->regs->inen);
>> +                       port->saved_data.dir = readw(&port->regs->dir_set);
>> +               }
>> +
>> +       return adi_pint_suspend();
>> +}
>> +
>> +static void adi_gpio_resume(void)
>> +{
>> +       struct adi_pmx *pmx;
>> +       struct gpio_port *port;
>> +
>> +       adi_pint_resume();
>> +
>> +       list_for_each_entry(pmx, &adi_pinctrl_list, node)
>> +               list_for_each_entry(port, &pmx->gpio_list, node) {
>> +                       writel(port->saved_data.mux, &port->regs->port_mux);
>> +                       writew(port->saved_data.fer, &port->regs->port_fer);
>> +                       writew(port->saved_data.inen, &port->regs->inen);
>> +                       writew(port->saved_data.data & port->saved_data.dir,
>> +                                               &port->regs->data_set);
>> +                       writew(port->saved_data.dir, &port->regs->dir_set);
>> +               }
>> +
>> +}
>
> The four functions are doing much the same thing, can't you just
> merge the pint and port structs as mentioned elsewhere and make
> things a lot simpler that way?
>
>> +static struct syscore_ops gpio_pm_syscore_ops = {
>> +       .suspend = adi_gpio_suspend,
>> +       .resume = adi_gpio_resume,
>> +};
>> +#else /* CONFIG_PM */
>> +#define adi_gpio_set_wake NULL
>> +#endif /* CONFIG_PM */
>> +
>> +#ifdef CONFIG_IRQ_PREFLOW_FASTEOI
>> +static inline void preflow_handler(struct irq_desc *desc)
>> +{
>> +       if (desc->preflow_handler)
>> +               desc->preflow_handler(&desc->irq_data);
>> +}
>> +#else
>> +static inline void preflow_handler(struct irq_desc *desc) { }
>> +#endif
>> +
>> +static void adi_gpio_handle_pint_irq(unsigned int inta_irq,
>> +                       struct irq_desc *desc)
>> +{
>> +       u32 request;
>> +       u32 level_mask, hwirq;
>> +       int umask = 0;
>
> bool umask = false;

OK

>
>> +       struct gpio_pint *pint = irq_desc_get_handler_data(desc);
>> +       struct irq_chip *chip = irq_desc_get_chip(desc);
>> +       struct gpio_pint_regs *regs = pint->regs;
>> +       struct irq_domain *domain;
>> +
>> +       preflow_handler(desc);
>> +       chained_irq_enter(chip, desc);
>> +
>> +       request = readl(&regs->request);
>> +       level_mask = readl(&regs->edge_set) & request;
>> +
>> +       hwirq = 0;
>> +       domain = pint->domain[0];
>> +       while (request) {
>
> You probably want to re-read request in each iteration.
> What will happen if new bits are lit up as you process
> the IRQs otherwise?

The PINT interrupt PIN is masked when requested gpio interrupts are
under dispatch. New bits lit up will be handled in next PINT
interrupt.

>
>> +               if (hwirq == PINT_HI_OFFSET)
>> +                       domain = pint->domain[1];
>
> Why is that not hwirq >= PINT_HI_OFFSET?
> This will *only* be true for IRQ 16.

Yes, domain pointer needs to be changed only once at IRQ 16 when we go
through IRQ requests from bit 0 to bit 31.

>
>> +
>> +               if (request & 1) {
>> +                       if (level_mask & (1 << hwirq)) {
>
> BIT(hwirq)
>
>> +                               umask = 1;
>
> umask = true;

OK

>
>> +                               chained_irq_exit(chip, desc);
>> +                       }
>> +                       generic_handle_irq(irq_find_mapping(domain,
>> +                                       hwirq % PINT_HI_OFFSET));
>
> This was elegant, and not complicated as in other places.
>
>> +               }
>> +
>> +               hwirq++;
>> +               request >>= 1;
>> +       }
>> +
>> +       if (!umask)
>> +               chained_irq_exit(chip, desc);
>> +}
>> +
>> +static struct irq_chip adi_gpio_irqchip = {
>> +       .name = "GPIO",
>> +       .irq_ack = adi_gpio_ack_irq,
>> +       .irq_mask = adi_gpio_mask_irq,
>> +       .irq_mask_ack = adi_gpio_mask_ack_irq,
>> +       .irq_unmask = adi_gpio_unmask_irq,
>> +       .irq_disable = adi_gpio_mask_irq,
>> +       .irq_enable = adi_gpio_unmask_irq,
>> +       .irq_set_type = adi_gpio_irq_type,
>> +       .irq_startup = adi_gpio_irq_startup,
>> +       .irq_shutdown = adi_gpio_irq_shutdown,
>> +       .irq_set_wake = adi_gpio_set_wake,
>> +};
>> +
>> +
>> +static int adi_get_groups_count(struct pinctrl_dev *pctldev)
>> +{
>> +       return ARRAY_SIZE(adi_pin_groups);
>> +}
>> +
>> +static const char *adi_get_group_name(struct pinctrl_dev *pctldev,
>> +                                      unsigned selector)
>> +{
>> +       return adi_pin_groups[selector].name;
>> +}
>> +
>> +static int adi_get_group_pins(struct pinctrl_dev *pctldev, unsigned selector,
>> +                              const unsigned **pins,
>> +                              unsigned *num_pins)
>> +{
>> +       *pins = adi_pin_groups[selector].pins;
>> +       *num_pins = adi_pin_groups[selector].num;
>> +       return 0;
>> +}
>> +
>> +static void adi_pin_dbg_show(struct pinctrl_dev *pctldev, struct seq_file *s,
>> +                  unsigned offset)
>> +{
>> +       seq_puts(s, DRIVER_NAME);
>
> Can't you output some useful data here instead of just the driver name?
> You know the pin offset and everything, why not print the status of triggers,
> whether it is in GPIO mode, if it is flagged to be used as IRQ etc?

OK

>
>> +}
>> +
>> +static struct pinctrl_ops adi_pctrl_ops = {
>> +       .get_groups_count = adi_get_groups_count,
>> +       .get_group_name = adi_get_group_name,
>> +       .get_group_pins = adi_get_group_pins,
>> +       .pin_dbg_show = adi_pin_dbg_show,
>> +};
>> +
>> +static int adi_pinmux_request(struct pinctrl_dev *pctldev, unsigned pin)
>> +{
>> +       struct adi_pmx *pmx;
>> +       struct gpio_port *port;
>> +       unsigned long flags;
>> +       struct pin_desc *desc;
>> +       u8 offset;
>> +
>> +       pmx = pinctrl_dev_get_drvdata(pctldev);
>> +
>> +       port = find_gpio_port(pin, &pmx->gpio_list);
>> +       if (port == NULL) {
>> +               dev_err(pctldev->dev,
>> +                      "%s: Peripheral PIN %d doesn't exist!\n",
>> +                      __func__, pin);
>> +               return -ENODEV;
>> +       }
>> +
>> +       offset = pin_to_offset(&port->range, pin);
>> +       desc = radix_tree_lookup(&pctldev->pin_desc_tree, pin);
>> +
>> +       spin_lock_irqsave(&port->lock, flags);
>> +
>> +       /* If a pin can be muxed as either GPIO or peripheral, make
>> +        * sure it is not already a GPIO pin when we request it.
>> +        */
>> +       if (unlikely(is_reserved(port, RSV_GPIO, offset))) {
>> +               if (system_state == SYSTEM_BOOTING)
>> +                       dump_stack();
>> +               dev_err(pctldev->dev,
>> +                      "%s: Peripheral PIN %d is already reserved as GPIO by %s!\n",
>> +                      __func__, pin, get_label(port, offset));
>> +               spin_unlock_irqrestore(&port->lock, flags);
>> +               return -EBUSY;
>> +       }
>> +
>> +       if (unlikely(is_reserved(port, RSV_PERI, offset))) {
>> +               if (system_state == SYSTEM_BOOTING)
>> +                       dump_stack();
>> +               dev_err(pctldev->dev,
>> +                       "%s: Peripheral PIN %d is already reserved by %s!\n",
>> +                       __func__, pin, get_label(port, offset));
>> +               spin_unlock_irqrestore(&port->lock, flags);
>> +               return -EBUSY;
>> +       }
>
> Get rid of unlikely().
>
>> +
>> +       reserve(port, RSV_PERI, offset);
>> +       set_label(port, offset, desc->mux_owner);
>> +
>> +       spin_unlock_irqrestore(&port->lock, flags);
>> +
>> +       return 0;
>> +}
>> +
>> +static int adi_pinmux_free(struct pinctrl_dev *pctldev, unsigned pin)
>> +{
>> +       struct adi_pmx *pmx;
>> +       struct gpio_port *port;
>> +       unsigned long flags;
>> +       u8 offset;
>> +
>> +       pmx = pinctrl_dev_get_drvdata(pctldev);
>> +       port = find_gpio_port(pin, &pmx->gpio_list);
>> +       if (port == NULL)
>> +               return 0;
>> +
>> +       offset = pin_to_offset(&port->range, pin);
>> +
>> +       spin_lock_irqsave(&port->lock, flags);
>> +
>> +       if (unlikely(!is_reserved(port, RSV_PERI, offset))) {
>> +               spin_unlock_irqrestore(&port->lock, flags);
>> +               return 0;
>> +       }
>
> get rid of unlikely().
>
>> +
>> +       unreserve(port, RSV_PERI, offset);
>> +       set_label(port, offset, "free");
>> +
>> +       spin_unlock_irqrestore(&port->lock, flags);
>> +
>> +       return 0;
>> +}
>> +
>> +static int adi_pinmux_enable(struct pinctrl_dev *pctldev, unsigned selector,
>> +       unsigned group)
>> +{
>> +       struct adi_pmx *pmx;
>> +       struct gpio_port *port;
>> +       unsigned long flags;
>> +       unsigned short *mux = (unsigned short *)adi_pmx_functions[selector].mux;
>> +       unsigned short gpio;
>> +
>> +       pmx = pinctrl_dev_get_drvdata(pctldev);
>> +
>> +       while (*mux) {
>> +               gpio = P_IDENT(*mux);
>> +
>> +               port = find_gpio_port(gpio - pmx->gpio_base, &pmx->gpio_list);
>> +               if (port == NULL) /* should not happen */
>> +                       continue;
>> +
>> +               spin_lock_irqsave(&port->lock, flags);
>> +
>> +               portmux_setup(port, gpio_to_offset(port, gpio),
>> +                                P_FUNCT2MUX(*mux));
>> +               port_setup(port, gpio_to_offset(port, gpio), PERIPHERAL_USAGE);
>> +               mux++;
>> +
>> +               spin_unlock_irqrestore(&port->lock, flags);
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static void adi_pinmux_disable(struct pinctrl_dev *pctldev, unsigned selector,
>> +       unsigned group)
>> +{
>> +       struct adi_pmx *pmx;
>> +       struct gpio_port *port;
>> +       unsigned long flags;
>> +       unsigned short *mux = (unsigned short *)adi_pmx_functions[selector].mux;
>> +       unsigned short gpio;
>> +
>> +       pmx = pinctrl_dev_get_drvdata(pctldev);
>> +
>> +       while (*mux) {
>> +               gpio = P_IDENT(*mux);
>> +
>> +               port = find_gpio_port(gpio - pmx->gpio_base, &pmx->gpio_list);
>> +               if (port == NULL) /* should not happen */
>> +                       continue;
>> +
>> +               spin_lock_irqsave(&port->lock, flags);
>> +
>> +               port_setup(port, gpio_to_offset(port, gpio), GPIO_USAGE);
>> +               mux++;
>> +
>> +               spin_unlock_irqrestore(&port->lock, flags);
>> +       }
>> +}
>> +
>> +static int adi_pinmux_get_funcs_count(struct pinctrl_dev *pctldev)
>> +{
>> +       return ARRAY_SIZE(adi_pmx_functions);
>> +}
>> +
>> +static const char *adi_pinmux_get_func_name(struct pinctrl_dev *pctldev,
>> +                                         unsigned selector)
>> +{
>> +       return adi_pmx_functions[selector].name;
>> +}
>> +
>> +static int adi_pinmux_get_groups(struct pinctrl_dev *pctldev, unsigned selector,
>> +                              const char * const **groups,
>> +                              unsigned * const num_groups)
>> +{
>> +       *groups = adi_pmx_functions[selector].groups;
>> +       *num_groups = adi_pmx_functions[selector].num_groups;
>> +       return 0;
>> +}
>> +
>> +static int adi_pinmux_request_gpio(struct pinctrl_dev *pctldev,
>> +       struct pinctrl_gpio_range *range, unsigned pin)
>> +{
>> +       struct adi_pmx *pmx;
>> +       struct gpio_port *port;
>> +       unsigned long flags;
>> +       u8 offset;
>> +
>> +       pmx = pinctrl_dev_get_drvdata(pctldev);
>> +       port = find_gpio_port(pin, &pmx->gpio_list);
>> +       if (port == NULL) {
>> +               dev_err(pctldev->dev,
>> +                      "%s: GPIO PIN %d doesn't exist!\n",
>> +                      __func__, pin);
>> +               return -ENODEV;
>> +       }
>> +
>> +       offset = pin_to_offset(&port->range, pin);
>> +
>> +       spin_lock_irqsave(&port->lock, flags);
>> +
>> +       if (unlikely(is_reserved(port, RSV_GPIO, offset))) {
>> +               if (system_state == SYSTEM_BOOTING)
>> +                       dump_stack();
>> +               dev_err(pctldev->dev,
>> +                       "GPIO %d is already reserved by %s !\n",
>> +                       offset_to_gpio(port, offset), get_label(port, offset));
>> +               spin_unlock_irqrestore(&port->lock, flags);
>> +               return -EBUSY;
>> +       }
>> +       if (unlikely(is_reserved(port, RSV_PERI, offset))) {
>> +               if (system_state == SYSTEM_BOOTING)
>> +                       dump_stack();
>> +               dev_err(pctldev->dev,
>> +                       "GPIO %d is already reserved as peripheral by %s !\n",
>> +                       offset_to_gpio(port, offset), get_label(port, offset));
>> +               spin_unlock_irqrestore(&port->lock, flags);
>> +               return -EBUSY;
>> +       }
>> +       if (unlikely(is_reserved(port, RSV_INT, offset))) {
>> +               dev_err(pctldev->dev,
>> +                       "GPIO %d is already reserved as gpio-irq!\n",
>> +                       offset_to_gpio(port, offset));
>> +       }
>
> Get rid of all unlikely().
>
>> +       reserve(port, RSV_GPIO, offset);
>> +       set_label(port, offset, port->chip.label);
>> +       port_setup(port, offset, GPIO_USAGE);
>> +
>> +       spin_unlock_irqrestore(&port->lock, flags);
>> +
>> +       return 0;
>> +}
>> +
>> +static void adi_pinmux_free_gpio(struct pinctrl_dev *pctldev,
>> +       struct pinctrl_gpio_range *range, unsigned pin)
>> +{
>> +       struct adi_pmx *pmx;
>> +       struct gpio_port *port;
>> +       unsigned long flags;
>> +       u8 offset;
>> +
>> +       pmx = pinctrl_dev_get_drvdata(pctldev);
>> +       port = find_gpio_port(pin, &pmx->gpio_list);
>> +       if (port == NULL)
>> +               return;
>> +
>> +       offset = pin_to_offset(&port->range, pin);
>> +
>> +       spin_lock_irqsave(&port->lock, flags);
>> +
>> +       if (unlikely(!is_reserved(port, RSV_GPIO, offset))) {
>> +               if (system_state == SYSTEM_BOOTING)
>> +                       dump_stack();
>> +
>> +               dev_err(pctldev->dev,
>> +                       "GPIO %d wasn't requested!\n",
>> +                       offset_to_gpio(port, offset));
>> +               spin_unlock_irqrestore(&port->lock, flags);
>> +               return;
>> +       }
>
> Dito.
>
>> +       unreserve(port, RSV_GPIO, offset);
>> +       set_label(port, offset, "free");
>> +
>> +       spin_unlock_irqrestore(&port->lock, flags);
>> +
>> +       return;
>> +}
>> +
>> +static struct pinmux_ops adi_pinmux_ops = {
>> +       .request = adi_pinmux_request,
>> +       .free = adi_pinmux_free,
>> +       .enable = adi_pinmux_enable,
>> +       .disable = adi_pinmux_disable,
>> +       .get_functions_count = adi_pinmux_get_funcs_count,
>> +       .get_function_name = adi_pinmux_get_func_name,
>> +       .get_function_groups = adi_pinmux_get_groups,
>> +       .gpio_request_enable = adi_pinmux_request_gpio,
>> +       .gpio_disable_free = adi_pinmux_free_gpio,
>> +};
>> +
>> +
>> +static struct pinctrl_desc adi_pinmux_desc = {
>> +       .name = DRIVER_NAME,
>> +       .pins = adi_pads,
>> +       .npins = ARRAY_SIZE(adi_pads),
>> +       .pctlops = &adi_pctrl_ops,
>> +       .pmxops = &adi_pinmux_ops,
>> +       .owner = THIS_MODULE,
>> +};
>> +
>> +static int adi_gpio_request(struct gpio_chip *chip, unsigned offset)
>> +{
>> +       struct gpio_port *port;
>> +
>> +       port = container_of(chip, struct gpio_port, chip);
>> +
>> +       return pinctrl_request_gpio(offset_to_gpio(port, offset));
>> +}
>> +
>> +static void adi_gpio_free(struct gpio_chip *chip, unsigned offset)
>> +{
>> +       struct gpio_port *port;
>> +
>> +       port = container_of(chip, struct gpio_port, chip);
>> +
>> +       pinctrl_free_gpio(offset_to_gpio(port, offset));
>> +}
>> +
>> +static int adi_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
>> +{
>> +       struct gpio_port *port;
>> +       unsigned long flags;
>> +
>> +       port = container_of(chip, struct gpio_port, chip);
>> +
>> +       spin_lock_irqsave(&port->lock, flags);
>> +
>> +       if (unlikely(!is_reserved(port, RSV_GPIO, offset))) {
>> +               dev_err(port->dev, "GPIO %d wasn't requested!\n",
>> +                       offset_to_gpio(port, offset));
>> +               spin_unlock_irqrestore(&port->lock, flags);
>> +               return -EINVAL;
>> +       }
>> +
>> +       writew(1 << offset, &port->regs->dir_clear);
>> +       writew(readw(&port->regs->inen) | (1 << offset), &port->regs->inen);
>
> BIT(offset) etc.

OK

>
>> +
>> +       spin_unlock_irqrestore(&port->lock, flags);
>> +
>> +       return 0;
>> +}
>> +
>> +static void adi_gpio_set_value(struct gpio_chip *chip, unsigned offset,
>> +       int value)
>> +{
>> +       struct gpio_port *port = container_of(chip, struct gpio_port, chip);
>> +       struct gpio_port_t *regs = port->regs;
>> +       unsigned long flags;
>> +
>> +       spin_lock_irqsave(&port->lock, flags);
>> +
>> +       if (value)
>> +               writew(1 << offset, &regs->data_set);
>> +       else
>> +               writew(1 << offset, &regs->data_clear);
>> +
>> +       spin_unlock_irqrestore(&port->lock, flags);
>> +}
>> +
>> +static int adi_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
>> +       int value)
>> +{
>> +       struct gpio_port *port = container_of(chip, struct gpio_port, chip);
>> +       struct gpio_port_t *regs = port->regs;
>> +       unsigned long flags;
>> +
>> +       spin_lock_irqsave(&port->lock, flags);
>> +
>> +       if (unlikely(!is_reserved(port, RSV_GPIO, offset))) {
>> +               dev_err(port->dev, "GPIO %d wasn't requested!\n",
>> +                       offset_to_gpio(port, offset));
>> +               spin_unlock_irqrestore(&port->lock, flags);
>> +               return -EINVAL;
>> +       }
>> +
>> +       writew(readw(&regs->inen) & ~(1 << offset), &regs->inen);
>> +       adi_gpio_set_value(chip, offset, value);
>> +       writew(1 << offset, &regs->dir_set);
>> +
>> +       spin_unlock_irqrestore(&port->lock, flags);
>> +
>> +       return 0;
>> +}
>> +
>> +static int adi_gpio_get_value(struct gpio_chip *chip, unsigned offset)
>> +{
>> +       struct gpio_port *port = container_of(chip, struct gpio_port, chip);
>> +       struct gpio_port_t *regs = port->regs;
>> +       unsigned long flags;
>> +       int ret;
>> +
>> +       spin_lock_irqsave(&port->lock, flags);
>> +
>> +       ret = 1 & (readw(&regs->data) >> offset);
>
> Use this construct:
>
> ret = !!(readw(&regs->data) & BIT(offset));

OK

>
>> +
>> +       spin_unlock_irqrestore(&port->lock, flags);
>> +
>> +       return ret;
>> +}
>> +
>> +static int adi_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
>> +{
>> +       struct gpio_port *port = container_of(chip, struct gpio_port, chip);
>> +
>> +       if (port->irq_base >= 0)
>> +               return irq_find_mapping(port->domain, offset);
>
> Why? Normally you want to create a mapping for everything
> here, and it doesn't hurt if you do it twice. Just use
>
> return irq_create_mapping(...);

In order to keep bf54x and bf60x gpio to irq mapping consistent with
the bf5xx driver, gpio pins should be mapped to the predefined IRQ in
function adi_gpio_init_int(). The irq_base is defined in platform data
struct.

    if (port->irq_base >= 0) {
        ret = irq_create_strict_mappings(port->domain, port->irq_base,
                    0, port->width);
        if (ret) {
            dev_err(port->dev, "Couldn't associate to domain\n");
            return ret;
        }
    }


>
>> +       else
>> +               return irq_create_mapping(port->domain, offset);
>> +}
>> +
>> +#if defined(CONFIG_PROC_FS)
>> +static inline unsigned short get_gpio_dir(struct gpio_port *port,
>> +       unsigned offset)
>> +{
>> +       struct gpio_port_t *regs = port->regs;
>> +
>> +       return 1 & (readw(&regs->dir_clear) >> offset);
>
> Use:
> return !!(readw(&regs->dir_clear) & BIT(offset));
>

OK

>> +static int gpio_proc_show(struct seq_file *m, void *v)
>> +{
>> +       int offset, irq, gpio;
>> +       struct adi_pmx *pmx;
>> +       struct gpio_port *port;
>> +
>> +       list_for_each_entry(pmx, &adi_pinctrl_list, node)
>> +       list_for_each_entry(port, &pmx->gpio_list, node)
>> +               for (offset = 0; offset < port->width; offset++) {
>> +                       irq = is_reserved(port, RSV_INT, offset);
>> +                       gpio = is_reserved(port, RSV_GPIO, offset);
>> +                       if (gpio || irq)
>> +                               seq_printf(m, "GPIO_%d: \t%s%s \t\tGPIO %s\n",
>> +                                       offset_to_gpio(port, offset),
>> +                                       get_label(port, offset),
>> +                                       (gpio && irq) ? " *" : "",
>> +                                       get_gpio_dir(port, offset) ?
>> +                                       "OUTPUT" : "INPUT");
>> +                       else if (is_reserved(port, RSV_PERI, offset))
>> +                               seq_printf(m, "GPIO_%d: \t%s \t\tPeripheral\n",
>> +                                       offset_to_gpio(port, offset),
>> +                                       get_label(port, offset));
>> +                       else
>> +                               continue;
>> +               }
>
> This double-list traversal is really awkward.
> Can't you just merge pint & port?
>
>> +
>> +       return 0;
>> +}
>> +
>> +static int gpio_proc_open(struct inode *inode, struct file *file)
>> +{
>> +       return single_open(file, gpio_proc_show, NULL);
>> +}
>> +
>> +static const struct file_operations gpio_proc_ops = {
>> +       .open           = gpio_proc_open,
>> +       .read           = seq_read,
>> +       .llseek         = seq_lseek,
>> +       .release        = single_release,
>> +};
>> +
>> +static __init int gpio_register_proc(void)
>> +{
>> +       struct proc_dir_entry *proc_gpio;
>> +
>> +       proc_gpio = proc_create("gpio", 0, NULL, &gpio_proc_ops);
>
> No way are you going to create a procfs file for this.
> Greg would get me for this. Use debugfs for this and make the
> code dependent on #ifdef CONFIG_DEBUG_FS.

OK

>
>> +       return proc_gpio == NULL;
>> +}
>> +device_initcall(gpio_register_proc);
>> +#endif
>> +
>> +static int adi_pint_map_port(struct gpio_pint *pint, u8 assign, u8 map,
>> +       struct irq_domain *domain)
>> +{
>> +       struct gpio_pint_regs *regs = pint->regs;
>> +
>> +       if (pint->map_count > 1)
>> +               return -EINVAL;
>> +
>> +       if (assign > 1)
>> +               return -EINVAL;
>> +
>> +       pint->map_count++;
>> +
>> +       writel((readl(&regs->assign) & (0xFFFF << !assign * PINT_HI_OFFSET)) |
>> +               (((map << 8) | map) << assign * PINT_HI_OFFSET), &regs->assign);
>
> Do you understand what is happening here? I don't.
>
> Care to break it down and explain it?

OK
    /* The map_mask of each gpio port is a 16-bit duplicate
     * of the 8-bit map. It can be set to either high 16 bits or low
     * 16 bits of the pint assignment register.
     */
    map_mask = (map << 8) | map;
    if (assign) {
        map_mask <<= PINT_HI_OFFSET;
        writel((readl(&regs->assign) & 0xFFFF) | map_mask,
            &regs->assign);
    } else
        writel((readl(&regs->assign) & 0xFFFF0000) | map_mask,
            &regs->assign);

>
>> +       pint->domain[assign] = domain;
>> +
>> +       return 0;
>> +}
>> +
>> +static int adi_gpio_pint_probe(struct platform_device *pdev)
>> +{
>> +       struct device *dev = &pdev->dev;
>> +       struct resource *res;
>> +       struct gpio_pint *pint;
>> +
>> +       pint = devm_kzalloc(dev, sizeof(struct gpio_pint), GFP_KERNEL);
>> +       if (!pint) {
>> +               dev_err(dev, "Memory alloc failed\n");
>> +               return -ENOMEM;
>> +       }
>> +
>> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +       if (unlikely(!res)) {
>
> Get rid of all these unlikely() macros in probe().
>
>> +               dev_err(dev, "Invalid mem resource\n");
>> +               return -ENODEV;
>> +       }
>> +
>> +       if (!devm_request_mem_region(dev, res->start, resource_size(res),
>> +                                    pdev->name)) {
>> +               dev_err(dev, "Region already claimed\n");
>> +               return -EBUSY;
>> +       }
>> +
>> +       pint->base = devm_ioremap(dev, res->start, resource_size(res));
>> +       if (!pint->base) {
>> +               dev_err(dev, "Could not ioremap\n");
>> +               return -ENOMEM;
>> +       }
>> +
>> +       pint->regs = (struct gpio_pint_regs *)pint->base;
>> +
>> +       res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>> +       if (unlikely(!res)) {
>> +               dev_err(dev, "Invalid IRQ resource\n");
>> +               return -ENODEV;
>> +       }
>> +
>> +       spin_lock_init(&pint->lock);
>> +
>> +       pint->irq = res->start;
>> +       pint->pint_map_port = adi_pint_map_port;
>> +       platform_set_drvdata(pdev, pint);
>> +
>> +       irq_set_chained_handler(pint->irq, adi_gpio_handle_pint_irq);
>> +       irq_set_handler_data(pint->irq, pint);
>> +
>> +       list_add_tail(&pint->node, &adi_pint_list);
>> +
>> +       return 0;
>> +}
>> +
>> +static int adi_gpio_pint_remove(struct platform_device *pdev)
>> +{
>> +       struct gpio_pint *pint = platform_get_drvdata(pdev);
>> +
>> +       list_del(&pint->node);
>> +       irq_set_handler(pint->irq, handle_simple_irq);
>> +       platform_set_drvdata(pdev, NULL);
>
> There is no need to set drvdata to NULL. This is done by the
> device core, so get rid of this line.

OK

>
>> +
>> +       return 0;
>> +}
>> +
>> +static int adi_gpio_irq_map(struct irq_domain *d, unsigned int irq,
>> +                               irq_hw_number_t hwirq)
>> +{
>> +       struct gpio_port *port = d->host_data;
>> +
>> +       if (!port)
>> +               return -EINVAL;
>> +
>> +       irq_set_chip_data(irq, port);
>> +       irq_set_chip_and_handler(irq, &adi_gpio_irqchip,
>> +                               handle_level_irq);
>> +
>> +       return 0;
>> +}
>> +
>> +const struct irq_domain_ops adi_gpio_irq_domain_ops = {
>> +       .map = adi_gpio_irq_map,
>> +       .xlate = irq_domain_xlate_onecell,
>> +};
>> +
>> +static int adi_gpio_init_int(struct gpio_port *port)
>> +{
>> +       struct device_node *node = port->dev->of_node;
>> +       struct gpio_pint *pint = port->pint;
>> +       int ret;
>> +
>> +       port->domain = irq_domain_add_linear(node, port->width,
>> +                               &adi_gpio_irq_domain_ops, port);
>> +       if (!port->domain) {
>> +               dev_err(port->dev, "Failed to create irqdomain\n");
>> +               return -ENOSYS;
>> +       }
>> +
>> +       ret = pint->pint_map_port(port->pint, port->pint_assign,
>> +                       port->pint_map, port->domain);
>> +       if (ret)
>> +               return ret;
>
> Explain what is happening here and how pints and ports relate.

OK

    /* According to BF54x and BF60x HRM, pin interrupt devices are not
     * part of the GPIO port device. in GPIO interrupt mode, the GPIO
     * pins of multiple port devices can be routed into one pin interrupt
     * devices. The mapping can be configured by setting pint assignment
     * register with the mapping value of different GPIO port. This is
     * done via function pint_map_port().
     */


>
>> +       if (port->irq_base >= 0) {
>> +               ret = irq_create_strict_mappings(port->domain, port->irq_base,
>> +                                       0, port->width);
>> +               if (ret) {
>> +                       dev_err(port->dev, "Couldn't associate to domain\n");
>> +                       return ret;
>> +               }
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static int adi_gpio_probe(struct platform_device *pdev)
>> +{
>> +       struct device *dev = &pdev->dev;
>> +       const struct adi_pinctrl_gpio_platform_data *pdata;
>> +       struct resource *res;
>> +       struct gpio_port *port;
>> +       static int gpio;
>> +       int ret = 0;
>> +
>> +       pdata = dev->platform_data;
>> +       if (!pdata)
>> +               return -EINVAL;
>> +
>> +       port = devm_kzalloc(dev, sizeof(struct gpio_port) +
>> +               sizeof(struct gpio_reserve_map) * pdata->port_width,
>> +               GFP_KERNEL);
>> +       if (!port) {
>> +               dev_err(dev, "Memory alloc failed\n");
>> +               return -ENOMEM;
>> +       }
>> +
>> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +       if (unlikely(!res)) {
>
> Get rid of all unlikely() in probe().
>
>> +               dev_err(dev, "Invalid mem resource\n");
>> +               return -ENODEV;
>> +       }
>> +
>> +       if (!devm_request_mem_region(dev, res->start, resource_size(res),
>> +                                    pdev->name)) {
>> +               dev_err(dev, "Region already claimed\n");
>> +               return -EBUSY;
>> +       }
>> +
>> +       port->base = devm_ioremap(dev, res->start, resource_size(res));
>> +       if (!port->base) {
>> +               dev_err(dev, "Could not ioremap\n");
>> +               return -ENOMEM;
>> +       }
>> +
>> +       res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>> +       if (unlikely(!res))
>> +               port->irq_base = -1;
>> +       else
>> +               port->irq_base = res->start;
>> +
>> +       port->width = pdata->port_width;
>> +       port->dev = dev;
>> +       port->regs = (struct gpio_port_t *)port->base;
>> +       port->pint_assign = !!pdata->pint_assign;
>> +       port->pint_map = pdata->pint_map;
>> +
>> +       port->pint = find_gpio_pint(pdata->pint_id);
>> +       if (port->pint) {
>> +               ret = adi_gpio_init_int(port);
>> +               if (ret)
>> +                       return ret;
>> +       }
>> +
>> +       port->pmx = find_pinctrl(pdata->pinctrl_id);
>
> OK I see what you're trying to do.
>
> Do you *really* need to tie the pinctrl and GPIO parts of the
> driver together this hard? Why can't the GPIO part and the pinctrl
> part probe by itself and then you can cross-reference using only
> the GPIO ranges?
>
> For example check the pinctrl-u300.c and pinctrl-coh901.c drivers.
> They probe for the GPIO and pinctrl side independently.
>
> To cross-reference from the pin controller to the GPIO controller
> it uses pinctrl_find_gpio_range_from_pin() and then the
> gpiochip there to call into the GPIO driver. Nice and clean.
>
> Can you try this approach? Then you can even split the driver
> in two parts (two files) if you like, but that's no requirement.
>
> Another option is to create a single state struct for both GPIO
> and pin control such as is done in the pinctrl-abx500.c driver.

I will try the cross-reference via range APIs.

>
>> +       if (port->pmx == NULL) {
>> +               dev_err(dev, "Could not find pinctrl device\n");
>> +               return -ENODEV;
>> +       }
>> +       if (gpio == 0)
>> +               gpio = port->pmx->gpio_base;
>> +
>> +       spin_lock_init(&port->lock);
>> +
>> +       platform_set_drvdata(pdev, port);
>> +
>> +       port->chip.label                = "adi-gpio";
>> +       port->chip.direction_input      = adi_gpio_direction_input;
>> +       port->chip.get                  = adi_gpio_get_value;
>> +       port->chip.direction_output     = adi_gpio_direction_output;
>> +       port->chip.set                  = adi_gpio_set_value;
>> +       port->chip.request              = adi_gpio_request;
>> +       port->chip.free                 = adi_gpio_free;
>> +       port->chip.to_irq               = adi_gpio_to_irq;
>> +       if (pdata->port_pin_base > 0)
>> +               port->chip.base         = pdata->port_pin_base +
>> +                                               port->pmx->gpio_base;
>> +       else
>> +               port->chip.base         = gpio;
>> +       port->chip.ngpio                = port->width;
>> +       gpio = port->chip.base + port->width;
>> +
>> +       ret = gpiochip_add(&port->chip);
>> +       if (ret)
>> +               return ret;
>> +
>> +       /* Set gpio range to pinctrl driver */
>> +       port->range.name = port->chip.label;
>> +       port->range.id = pdev->id;
>> +       port->range.base = port->chip.base;
>> +       port->range.pin_base = port->chip.base - port->pmx->gpio_base;
>> +       port->range.npins = port->width;
>> +       port->range.gc = &port->chip;
>> +       pinctrl_add_gpio_range(port->pmx->pctl, &port->range);
>
> No, don't do this from the pinctrl interface.
>
> Use
> gpiochip_add_pin_range() from the <linux/gpio.h> interface
> instead. That will make everything simpler and cleaner,
> and will illustrate why you want to get rid of the cross-dependence
> between the pinctrl and GPIO portions of the driver.

OK

>
>> +       list_add_tail(&port->node, &port->pmx->gpio_list);
>> +
>> +       return 0;
>> +}
>> +
>> +static int adi_gpio_remove(struct platform_device *pdev)
>> +{
>> +       struct gpio_port *port = platform_get_drvdata(pdev);
>> +       int ret;
>> +       u8 offset;
>> +
>> +       for (offset = 0; offset < port->width; offset++)
>> +               irq_dispose_mapping(irq_find_mapping(port->domain, offset));
>> +
>> +       irq_domain_remove(port->domain);
>> +       pinctrl_remove_gpio_range(port->pmx->pctl, &port->range);
>
> No, just use:
> gpiochip_remove_pin_ranges()
>
> on the chip.

OK

>
>> +       list_del(&port->node);
>> +       ret = gpiochip_remove(&port->chip);
>> +       platform_set_drvdata(pdev, NULL);
>> +
>> +       return ret;
>> +}
>> +
>> +static int adi_pinctrl_probe(struct platform_device *pdev)
>> +{
>> +       struct adi_pmx *pmx;
>> +       struct resource *res;
>> +
>> +       pmx = devm_kzalloc(&pdev->dev, sizeof(*pmx), GFP_KERNEL);
>> +       if (!pmx)
>> +               return -ENOMEM;
>> +
>> +       pmx->dev = &pdev->dev;
>> +
>> +       /* Now register the pin controller and all pins it handles */
>> +       pmx->pctl = pinctrl_register(&adi_pinmux_desc, &pdev->dev, pmx);
>> +       if (!pmx->pctl) {
>> +               dev_err(&pdev->dev, "could not register pinctrl ADI2 driver\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       res = platform_get_resource(pdev, IORESOURCE_IO, 0);
>> +       if (res)
>> +               pmx->gpio_base = res->start;
>> +
>> +       INIT_LIST_HEAD(&pmx->gpio_list);
>
> And here is where you'r initialized the static local lock for this list.
>
>> +
>> +       list_add_tail(&pmx->node, &adi_pinctrl_list);
>> +
>> +       return 0;
>> +}
>> +
>> +static int adi_pinctrl_remove(struct platform_device *pdev)
>> +{
>> +       struct adi_pmx *pmx = platform_get_drvdata(pdev);
>> +
>> +       list_del(&pmx->node);
>> +       pinctrl_unregister(pmx->pctl);
>> +       platform_set_drvdata(pdev, NULL);
>
> As mentioned, this setting NULL is superfluous.

OK

>
>> +
>> +       return 0;
>> +}
>> +
>> +static struct platform_driver adi_pinctrl_driver = {
>> +       .probe          = adi_pinctrl_probe,
>> +       .remove         = adi_pinctrl_remove,
>> +       .driver         = {
>> +               .name   = DRIVER_NAME,
>> +       },
>> +};
>> +
>> +static struct platform_driver adi_gpio_pint_driver = {
>> +       .probe          = adi_gpio_pint_probe,
>> +       .remove         = adi_gpio_pint_remove,
>> +       .driver         = {
>> +               .name   = "adi-gpio-pint",
>> +       },
>> +};
>> +
>> +static struct platform_driver adi_gpio_driver = {
>> +       .probe          = adi_gpio_probe,
>> +       .remove         = adi_gpio_remove,
>> +       .driver         = {
>> +               .name   = "adi-gpio",
>> +       },
>> +};
>> +
>> +static int __init adi_pinctrl_setup(void)
>> +{
>> +       int ret;
>> +
>> +       ret = platform_driver_register(&adi_pinctrl_driver);
>> +       if (ret)
>> +               return ret;
>> +
>> +       ret = platform_driver_register(&adi_gpio_pint_driver);
>> +       if (ret)
>> +               goto pint_error;
>> +
>> +       ret = platform_driver_register(&adi_gpio_driver);
>> +       if (ret)
>> +               goto gpio_error;
>> +
>> +#ifdef CONFIG_PM
>> +       register_syscore_ops(&gpio_pm_syscore_ops);
>> +#endif
>> +       return ret;
>> +gpio_error:
>> +       platform_driver_unregister(&adi_gpio_pint_driver);
>> +pint_error:
>> +       platform_driver_unregister(&adi_pinctrl_driver);
>> +
>> +       return ret;
>> +}
>> +postcore_initcall(adi_pinctrl_setup);
>
> Why does this need to be postcore?

OK. I will change to arch_initcall().

>
>> +++ b/include/linux/platform_data/pinctrl-adi2.h
>> @@ -0,0 +1,38 @@
>> +/*
>> + * Pinctrl Driver for ADI GPIO2 controller
>> + *
>> + * Copyright 2007-2013 Analog Devices Inc.
>> + *
>> + * Licensed under the GPLv2 or later
>> + */
>> +
>> +
>> +#ifndef PINCTRL_ADI2_H
>> +#define PINCTRL_ADI2_H
>> +
>> +#include <linux/io.h>
>> +#include <linux/platform_device.h>
>> +
>> +/**
>> + * struct adi_pinctrl_gpio_platform_data - Pinctrl gpio platform data
>> + * for ADI GPIO2 device.
>> + *
>> + * @port_pin_base: Optional global GPIO index of the GPIO bank.
>> + *                 0 means driver decides.
>> + * @port_width: PIN number of the GPIO bank device
>> + * @pint_id: GPIO PINT device id that this GPIO bank should map to.
>> + * @pint_assign: The 32-bit GPIO PINT registers can be divided into 2 parts. A
>> + *               GPIO bank can be mapped into either low 16 bits[0] or high 16
>> + *               bits[1] of each PINT register.
>> + * @pint_map: GIOP bank mapping code in PINT device
>> + */
>> +struct adi_pinctrl_gpio_platform_data {
>> +       unsigned int port_pin_base;
>> +       unsigned int port_width;
>> +       u8 pinctrl_id;
>> +       u8 pint_id;
>> +       u8 pint_assign;
>
> Is this always 0 or 1? Then you should instead have a bool
> named bool is_high; or something.

OK

>
>> +       u8 pint_map;
>> +};
>
> I'm sorry that there are many issues with this driver and it takes me time
> to review because it is not very much like other drivers, especially I think
> you need to understand how other drivers cross-reference using ranges
> and how to get rid of the two lists and the strange locking.

I will try to do cross-reference by ranges between pinctrl and gpio
port. But, I am afraid these 2 lists can't be dropped, because the
GPIO power suspend and resume functions have to walk through the
lists. The GPIO PM functions should be called before any other device
drivers on Blackfin. This is ensured by registering to the syscore
operations. Any other options?

In addition, 2 type of locks are owned by 2 different devices. It is
strange to merge into one lock.

Thank you again for your great suggestion.


Sonic Zhang
