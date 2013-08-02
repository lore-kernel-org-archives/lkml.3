Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab3HBO40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:56:26 -0400
Received: from vps.mortis.eu ([79.99.135.181]:57688 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab3HBO4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:56:24 -0400
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Aug 2013 10:56:24 EDT
X-Greylist: delayed 742 seconds by postgrey-1.32 at vps;
	Fri, 02 Aug 2013 16:30:37 CEST
X-SMTPRelay-Internal: on
X-SMTPRelay-Data: addr=172.17.1.212, from=bruno.ferreira@efacec.com
X-SMTPRelay-Id: 130802151747924000000 @ MAILOUT
Message-ID: <51FBBF84.2050109@efacec.com>
Date: Fri, 2 Aug 2013 15:17:40 +0100
From: BrunoFerreira <bruno.ferreira@efacec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64;
	rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: Giel van Schijndel <me@mortis.eu>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
Subject: Re: Fintek F81865 chip (Wdog support)
References: <51409586.4030204@efacec.com>
	<07936d3ec21c2de67a97b2664c7bf484@mortis.eu>
	<20130526164410.GA8274@spo001.leaseweb.com>
In-Reply-To: <20130526164410.GA8274@spo001.leaseweb.com>
Content-Type: multipart/mixed; boundary="------------040004090809050000040309"
X-Originating-IP: [172.18.208.190]
X-Spambayes-Classification: ham; 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------040004090809050000040309
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

Hi All.

Sorry about the delay.
Please find in attach the driver source code with support for this chip.

Kind regards,
Bruno Ferreira

On 05/26/2013 05:44 PM, Wim Van Sebroeck wrote:
> Hi All,
>
>> On Wed, 13 Mar 2013 15:04:38 +0000, BrunoFerreira wrote:
>>> I'm currently working with a new board iEi NOVA-PV-D5251 [1] that
>>> have the Fintek F81865 chip for Super I/O support and I will need to
>>> develop the watchdog driver and another to access to the IO that this
>>> board supports (gpio). I made a search and I see that already exists
>>> a
>>> driver for F71808E chip, I use this driver as an example an I made a
>>> new driver for F81865 chip. My driver is working pretty well, but
>>> I've
>>> a question that I can't find the answer on datasheet of this chip
>>> that
>>> may be Wim or Giel could know.
>>> On both chips, we need to configure a pin that can work as a normal
>>> GPIO (F81865: Set pin 70 the function of WDTRST#/GPIO15 is WDTRST# |
>>> F71808E: Set pin 21 to GPIO23/WDTRST#, then to WDTRST#), this is here
>>> where I get myself confused, this WDTRST will be mapped in any GPIO
>>> output on my board? I mean, if the watchdog is enable I will get any
>>> output pin set to 1 (i.e. the GPIO15, output 5?) and when the
>>> watchdog
>>> goes down this output goes to 0?
>> Sorry, I can't give you a definite answer on that. All Fintek
>> datasheets I've seen are very poorly written. At one point I actually
>> stopped trusting the datasheet enough to go through the hassle of
>> hooking up a scope to the pins of the chip.
>>
>> Hazarding a guess however, I'd say that when the watchdog is enabled
>> you cannot use the WDTRST pin as a GPIO pin.
>>
>>> The other question is to Wim, can you tell me if there is interest in
>>> add this chip support to kernel?
>> This would be a yes, unless there are good reasons not to include it in
>> mainline.
> The answer is indeed yes. Has a patch been created since this message?
>
> Kind regards,
> Wim.
>
>


--------------040004090809050000040309
Content-Type: text/x-csrc; name="f81865_gpio.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="f81865_gpio.c"

/***************************************************************************
* Copyright (C) 2013 Bruno Ferreira <bruno.ferreira@efacec.com>            *
*                                                                          *
* This program is free software; you can redistribute it and/or modify     *
* it under the terms of the GNU General Public License as published by     *
* the Free Software Foundation; either version 2 of the License, or        *
* (at your option) any later version.                                      *
*                                                                          *
* This program is distributed in the hope that it will be useful,          *
* but WITHOUT ANY WARRANTY; without even the implied warranty of           *
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the             *
* GNU General Public License for more details.                             *
*                                                                          *
* You should have received a copy of the GNU General Public License        *
* along with this program; if not, write to the                            *
* Free Software Foundation, Inc.,                                          *
* 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.                 *
***************************************************************************/

#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/io.h>
#include <linux/errno.h>
#include <linux/ioport.h>

#include <linux/gpio.h>

#define DRVNAME                 "f81865_gpio"

/* Global Control Registers */
#define SIO_F81865_LD_WDT	0x07	/* Watchdog Logic Number Register (LDN) */
#define SIO_F81865_LD_GPIO	0x06	/* GPIO Logic Number Register (LDN) */
#define SIO_UNLOCK_KEY		0x87	/* Key to enable Super-I/O */
#define SIO_LOCK_KEY		0xAA	/* Key to diasble Super-I/O */

#define SIO_REG_DEVID		0x20	/* Device ID (2 bytes) */
#define SIO_REG_DEVREV		0x22	/* Device revision */
#define SIO_REG_MANID		0x23	/* Fintek ID (2 bytes) */

/* Manufacture and Chip Information */
#define SIO_FINTEK_ID		0x1934	/* Manufacturers ID */
#define SIO_F81865_ID           0x0704  /* Chipset ID*/

static DEFINE_SPINLOCK(gpio_lock);

/* GPIO internal data information */
struct gpio_data {
    unsigned short      sioaddr;        /* default index port */
    unsigned long       opened;         /* driver open state */
};

static struct gpio_data gpio = {};

/* Super-I/O Function prototypes */
static inline int superio_enter(int base);
static inline void superio_exit(int base);
static inline int superio_inb(int base, int reg);
static inline void superio_outb(int base, int reg, u8 val);
static inline int superio_inw(int base, int reg);

static inline void superio_set_bit(int base, int reg, int bit);
static inline void superio_clear_bit(int base, int reg, int bit);


/* Super I/O functions */
static inline int superio_enter(int base)
{
    /* don't step on other drivers' I/O space by accident */
    if (!request_muxed_region(base, 2, DRVNAME)) {
        printk(KERN_ERR DRVNAME ": I/O address 0x%04x already in use\n", (int)base);
        return -EBUSY;
    }

    /* according to the datasheet the key must be send twice! */
    outb(SIO_UNLOCK_KEY, base);
    outb(SIO_UNLOCK_KEY, base);

    return 0;
}

static inline void superio_exit(int base)
{
    outb(SIO_LOCK_KEY, base);
    release_region(base, 2);
}

static inline int superio_inb(int base, int reg)
{
    outb(reg, base);
    return inb(base + 1);
}

static inline void superio_outb(int base, int reg, u8 val)
{
    outb(reg, base);
    outb(val, base + 1);
}

static int superio_inw(int base, int reg)
{
    int val;
    val  = superio_inb(base, reg) << 8;
    val |= superio_inb(base, reg + 1);
    return val;
}

static inline void superio_set_bit(int base, int reg, int bit)
{
    unsigned long val = superio_inb(base, reg);
    __set_bit(bit, &val);
    superio_outb(base, reg, val);
}

static inline void superio_clear_bit(int base, int reg, int bit)
{
    unsigned long val = superio_inb(base, reg);
    __clear_bit(bit, &val);
    superio_outb(base, reg, val);
}

/* GPIO api */
static int f81865_gpio_direction_in(struct gpio_chip *gc, unsigned _gpio_num)
{
    return 0;
}

static int f81865_gpio_direction_out(struct gpio_chip *gc, unsigned _gpio_num, int val)
{
    return 0;
}

static int f81865_gpio_get(struct gpio_chip *gc, unsigned _gpio_num)
{
    return 0;
}

static void f81865_gpio_set(struct gpio_chip *gc, unsigned _gpio_num, int val)
{

}

static struct gpio_chip f81865_gpio_chip =
{
    .label              = DRVNAME,
    .owner              = THIS_MODULE,
    .get                = f81865_gpio_get,
    .direction_input    = f81865_gpio_direction_in,
    .set                = f81865_gpio_set,
    .direction_output   = f81865_gpio_direction_out,
};

/* Driver useful functions */
static int __init f81865_configure(void)
{
    int err = 0;
    /* temporary */
    //u8 io_reg, curr_vals;
    
    /* Enable all pins with GPIO capability */
    /* By default we enable all possible GPIOs on the chip */
    spin_lock(&gpio_lock);
    err = superio_enter(gpio.sioaddr);
    if (err) goto exit_unlock;
    
    /* Enable GPIO... */

    //io_reg = 0x27; /* Enable Rom Address Register */
    //curr_vals = superio_inb(gpio.sioaddr, io_reg);
    //printk(KERN_INFO DRVNAME ": Rom Address Register: (%d) \n", curr_vals);
    //superio_set_bit(gpio.sioaddr, io_reg, 4); /* PORT_4E_EN to 1*/

    /* Enable GPIO[10-17], GPIO1 | WARNING the GPIO15 could be the WDTRST# */
    /* GPIO1 Enable Register - Index 2Bh */
    superio_outb(gpio.sioaddr, 0x2b, 0xff);

    /* Enable GPIO[20-27], GPIO1 */
    /* GPIO2 Enable Register - Index 2Ch */
    superio_outb(gpio.sioaddr, 0x2c, 0xff);

    /* Enable GPIO[30-37], GPIO1 */
    /* GPIO3 Enable Register - Index 29h */
    superio_outb(gpio.sioaddr, 0x29, 0xff);

    /* Enable GPIO[40-47], GPIO1 */
    /* GPIO4 Enable Register - Index 28h */
    superio_outb(gpio.sioaddr, 0x28, 0xff);

    superio_exit(gpio.sioaddr);
    
exit_unlock:
    spin_unlock(&gpio_lock);

    printk(KERN_INFO DRVNAME ": configured(%d)...\n", err);
    return err;
}

static int __init f81865_find(int sio_addr)
{
    u16 devid;
    int err = superio_enter(sio_addr);
    if (err) return err;

    devid = superio_inw(sio_addr, SIO_REG_MANID);
    if (devid != SIO_FINTEK_ID) {
        pr_debug(DRVNAME ": Not a Fintek device\n");
        err = -ENODEV;
        goto exit;
    }

    devid = superio_inw(sio_addr, SIO_REG_DEVID);
    if (devid != SIO_F81865_ID) {
        printk(KERN_INFO DRVNAME ": Unrecognized Fintek device: %04x\n", (unsigned int) devid);
        err = -ENODEV;
        goto exit;
    }

    printk(KERN_INFO DRVNAME ": Found F81865 Super I/O chip, revision %d\n", (int) superio_inb(sio_addr, SIO_REG_DEVREV));

exit:
    superio_exit(sio_addr);

    return err;
}

static int __init f81865_gpio_init(void)
{
    static const unsigned short addrs[] = { 0x2e, 0x4e };
    int err = -ENODEV, i;

    for (i=0; i < ARRAY_SIZE(addrs); i++) {
        err = f81865_find(addrs[i]);
        if (err == 0) break;
    }
    if (i == ARRAY_SIZE(addrs)) return err;

    /* set GPIO base address */
    gpio.sioaddr = addrs[i];

    /* configure GPIO pins capability */
    err = f81865_configure();
    if (err)
    {
        printk(KERN_ERR DRVNAME ": configuring the GPIO...\n");
        return EAGAIN;
    }

    f81865_gpio_chip.base = -1;
    f81865_gpio_chip.ngpio = 26; /* !!! FIX THIS !!! */

    err = gpiochip_add(&f81865_gpio_chip);
    
    return (err < 0) ? err : 0;
}

static void __exit f81865_gpio_exit(void)
{
    gpiochip_remove(&f81865_gpio_chip);
    printk(KERN_INFO DRVNAME ": unloaded...\n");   
}

MODULE_AUTHOR("Bruno Ferreira");
MODULE_DESCRIPTION("GPIO interface for F81865 Super I/O chip");
MODULE_LICENSE("GPL");

module_init(f81865_gpio_init);
module_exit(f81865_gpio_exit);

--------------040004090809050000040309--

