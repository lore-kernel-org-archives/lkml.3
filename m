Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab3GUPNM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 11:13:12 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:52554 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab3GUPNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 11:13:10 -0400
MIME-Version: 1.0
In-Reply-To: <51D56D70.3000700@compulab.co.il>
References: <51D56D70.3000700@compulab.co.il>
Date: Sun, 21 Jul 2013 17:13:09 +0200
Message-ID: <CACRpkdYJk=8kVsMjJxuj102-TSuW90pM66LvYS3xtvO7O69E-A@mail.gmail.com>
Subject: Re: gpio: introduce gpio-fch driver for AMD A45/A50M/A55E Fusion
 Controller Hub
From: Linus Walleij <linus.walleij@linaro.org>
To: Denis Turischev <denis.turischev@compulab.co.il>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 4, 2013 at 2:41 PM, Denis Turischev
<denis.turischev@compulab.co.il> wrote:

> Signed-off-by: Denis Turischev <denis.turischev@compulab.co.il>

Insert some commit message above describing what this is all about.
What kind of hardware this is, which arch/machine it is found in, etc.

> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/errno.h>
> +#include <linux/pci.h>
> +#include <linux/gpio.h>

#include <linux/bitops.h>

> +static void __iomem *gpio_ba;

Just call this "base" per convention.

> +u32 acpimmioaddr;
> +
> +#define GPIO_SPACE_OFFSET              0x100
> +#define GPIO_SPACE_SIZE                        0x100
> +
> +static DEFINE_SPINLOCK(gpio_lock);

So gpio_ba, acpimmioaddr and gpio_lock are static locals.

What happens if a user has two such PCI devices in their machine?
Even if this does not appear in practice, the code is more readable
if you assume that.

I think you need to move these into a devm_kzalloc():ed struct
that get instantiated for every device in probe().

Follow the pattern found in many other drivers such as
gpio-pch.c

(...)
> +static int gpio_fch_direction_in(struct gpio_chip *gc, unsigned  gpio_num)
> +{
> +       u8 curr_state;
> +
> +       spin_lock(&gpio_lock);
> +
> +       curr_state = ioread8(gpio_ba + gpio_num);
> +       if (!(curr_state & (1 << 5)))
> +               iowrite8(curr_state | (1 << 5), gpio_ba + gpio_num);

Use BIT(5) instead of (1 << 5) above, easier for me to read.
Repeat that pattern everywhere applicable.

(Some think I'm picky for this but I really like it.)

> +static void gpio_fch_set(struct gpio_chip *gc, unsigned gpio_num, int val)
> +{
> +       u8 curr_state;
> +
> +       spin_lock(&gpio_lock);
> +
> +       curr_state = ioread8(gpio_ba + gpio_num);
> +       iowrite8((curr_state & ~(1 << 5)), gpio_ba + gpio_num);
> +
> +       if (val)
> +               iowrite8(curr_state | (1 << 6), gpio_ba + gpio_num);
> +       else
> +               iowrite8(curr_state & ~(1 << 6), gpio_ba + gpio_num);
> +
> +       spin_unlock(&gpio_lock);
> +}

Hm this looks a bit familiar. I had a quick look around
but couldn't quite find siblings ... but make sure you are
not reimplementing something now.

> +u32 read_pm_reg(u8 port)
> +{
> +       u32 res;
> +
> +       outb(port + 3, 0xCD6);
> +       res = inb(0xCD7);

#define these magic offsets.

> +       res = res << 8;
> +
> +       outb(port + 2, 0xCD6);
> +       res = res + inb(0xCD7);
> +       res = res << 8;
> +
> +       outb(port + 1, 0xCD6);
> +       res = res + inb(0xCD7);
> +       res = res << 8;
> +
> +       outb(port, 0xCD6);
> +       res = res + inb(0xCD7);
> +
> +       return res;
> +}

On the whole, explain what this function is doing with
some kerneldoc.

> +static int gpio_fch_probe(struct pci_dev *pdev,        const struct pci_device_id *id)
> +{
> +       int ret;
> +
> +       acpimmioaddr = read_pm_reg(0x24) & 0xFFFFF000;

#define these magic things as well. I can see it is reading out the
base address.

What happens on some random system if you start reading
on port 0x24 like this?

But "ACPImmioaddr", what does this really mean? Where is this address
coming from? What does it have to do with ACPI?

This seems like some ISA-style reading around in regs and probing
(that is actually why the probe() function is named probe())
but with ACPI I was under the impression that you were to query
ACPI for things like base addresses?

> +       if (!request_mem_region(acpimmioaddr + GPIO_SPACE_OFFSET,
> +                               GPIO_SPACE_SIZE, fch_gpio_chip0.label))
> +               return -EBUSY;
> +
> +       gpio_ba = ioremap(acpimmioaddr + GPIO_SPACE_OFFSET, GPIO_SPACE_SIZE);
> +       if (!gpio_ba) {
> +               ret = -ENOMEM;
> +               goto err_no_ioremap;
> +       }

Stuff the resulting address into a struct resource and then use
devm_ioremap_resource() to remap.

> +
> +       fch_gpio_chip0.base = 0;
> +       fch_gpio_chip0.ngpio = 68;
> +
> +       fch_gpio_chip128.base = 128;
> +       fch_gpio_chip128.ngpio = 23;
> +
> +       fch_gpio_chip160.base = 160;
> +       fch_gpio_chip160.ngpio = 69;

This is also characteristics that seem like they could vary with the
PCI ID for newer versions. Isn't it better to make this a per-pci-id
table from the beginning? It also simplifies adding these
chips as you have 3x the same code adding these chips.

> +err_no_gpiochip160_add:
> +       ret = gpiochip_remove(&fch_gpio_chip128);
> +       if (ret)
> +               dev_err(&pdev->dev, "%s failed, %d\n",
> +                               "gpiochip_remove()", ret);
> +
> +err_no_gpiochip128_add:
> +       ret = gpiochip_remove(&fch_gpio_chip0);
> +       if (ret)
> +               dev_err(&pdev->dev, "%s failed, %d\n",
> +                               "gpiochip_remove()", ret);
> +
> +err_no_gpiochip0_add:
> +       iounmap(gpio_ba);

Not needed with devm_* managed resources.

> +
> +err_no_ioremap:
> +       release_mem_region(acpimmioaddr + GPIO_SPACE_OFFSET, GPIO_SPACE_SIZE);

Dito.

> +       return ret;
> +}
> +
> +static void gpio_fch_remove(struct pci_dev *pdev)
> +{
> +       int ret;
> +
> +       ret = gpiochip_remove(&fch_gpio_chip160);
> +       if (ret < 0)
> +               dev_err(&pdev->dev, "%s failed, %d\n",
> +                               "gpiochip_remove()", ret);
> +
> +       ret = gpiochip_remove(&fch_gpio_chip128);
> +       if (ret < 0)
> +               dev_err(&pdev->dev, "%s failed, %d\n",
> +                               "gpiochip_remove()", ret);
> +
> +       ret = gpiochip_remove(&fch_gpio_chip0);
> +       if (ret < 0)
> +               dev_err(&pdev->dev, "%s failed, %d\n",
> +                               "gpiochip_remove()", ret);

Here you see the simplification that can be achieved by using
a table. just iterate over it.

> +
> +       iounmap(gpio_ba);
> +       release_mem_region(acpimmioaddr + GPIO_SPACE_OFFSET, GPIO_SPACE_SIZE);

Dito.

> +config GPIO_FCH
> +       tristate "AMD A45/A50M/A55E Fusion Controller Hub GPIO"
> +       depends on PCI && X86
> +       default m
> +       help
> +         GPIO interface for AMD A45/A50M/A55E Fusion Controller Hub.
> +         Available GPIOs are 0-67, 128-150, 160-228.
> +
> +         Part of GPIOs is usually occupied by BIOS for it's internal needs, so
> +         use them with care.

So is it impossible to get that information out of the BIOS
so we can avoid poking them altogether?

Yours,
Linus Walleij
