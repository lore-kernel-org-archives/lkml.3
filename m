Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761078Ab3D3QRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 12:17:30 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:9520 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760893Ab3D3QR0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 12:17:26 -0400
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        LKML <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>
Subject: RE: [NEW DRIVER V6 5/7] drivers/gpio: DA9058 GPIO driver
Thread-Topic: [NEW DRIVER V6 5/7] drivers/gpio: DA9058 GPIO driver
Thread-Index: AQHOPSDq/4x7gVvGBkyIGe0svdDUiJjlUIAAgAmiYXA=
Date: Tue, 30 Apr 2013 16:17:21 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB5141922EEF@NB-EX-MBX02.diasemi.com>
References: <201304191709.r3JH9w0R017814@latitude>
 <CACRpkdaSLGmmvWYG6ez1h90e=OZXq4yqtUFXKnTpUWG916LmjA@mail.gmail.com>
In-Reply-To: <CACRpkdaSLGmmvWYG6ez1h90e=OZXq4yqtUFXKnTpUWG916LmjA@mail.gmail.com>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.27.109]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Linus Walleij [mailto:linus.walleij@linaro.org]
> Sent: 24 April 2013 14:15
> To: Opensource [Anthony Olech]
> Cc: Grant Likely; Linus Walleij; Mark Brown; LKML; David Dajun Chen; Lee Jones
> Subject: Re: [NEW DRIVER V6 5/7] drivers/gpio: DA9058 GPIO driver
> On Fri, Apr 19, 2013 at 6:56 PM, Anthony Olech
> <anthony.olech.opensource@diasemi.com> wrote:
> > This patch is relative to next-20130419 of linux-next
> >
> > This is the GPIO component driver of the Dialog DA9058 PMIC.
> > This driver is just one component of the whole DA9058 PMIC driver.
> > It depends on the CORE component driver of the DA9058 MFD.
> > The meaning of the PMIC register 21 bits 1 and 5 has been documented
> > in the driver source.
> >
> > Changes relative to V5 of this patch:
> > - rebased to next-20130419 in
> > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> > - removed redundant #include <linux/mfd/da9058/version.h>
> > - corrected dates on copyright statements
> >
> > Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> > Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
> 
> Sorry for slow review ...
> 
> > +struct da9058_gpio {
> > +       struct da9058 *da9058;
> > +       struct platform_device *pdev;
> > +       struct gpio_chip gp;
> > +       struct mutex lock;
> > +       int irq_0;
> > +       int irq_1;
> 
> Why are you keeping thes two numbers here? Use the irqdomain to contain irq
> mappings,

this module does not use the irqdomain directly so it gets the numbers from
the platform data, which I thought did not persist past the probe() function.
Is the platform data permanently available? - if that is the case, I can of course
re-get the values on demand from the platform data - please confirm or suggest
an alternative method of extracting the irq number.

> this is just confusion things. (See review commens further below.)
>
> > +       u8 inp_config;
> > +       u8 out_config;
> 
> > +static int da9058_gpio_get(struct gpio_chip *gc, unsigned offset) {
> > +       struct da9058_gpio *gpio = gpio_chip_to_da9058_gpio(gc);
> > +       struct da9058 *da9058 = gpio->da9058;
> > +       unsigned int gpio_level;
> > +       int ret;
> > +
> > +       if (offset > 1)
> > +               return -EINVAL;
> 
> So we have only two pins, OK that's said in Kconfig too...
> 
> (...)
> > +static void da9058_gpio_set(struct gpio_chip *gc, unsigned offset,
> > +int value) {
> > +       struct da9058_gpio *gpio = gpio_chip_to_da9058_gpio(gc);
> > +       struct da9058 *da9058 = gpio->da9058;
> > +       unsigned int gpio_cntrl;
> > +       int ret;
> > +
> > +       if (offset > 1) {
> > +               dev_err(da9058->dev,
> > +                       "Failed to set GPIO%d output=%d because illegal GPIO\n",
> > +                       offset, value);
> > +               return;
> > +       }
> 
> Here you have an error print, pls insert that on the get function too then.

the error print was used here because there is no other way to report an error.
On the get function a negative number can be returned, so therefore there is
no need to report it via the error log. I can put more diagnostics back in, but
is it really necessary to duplicate the error indication in some cases?

> (...)
> > +       if (offset) {
> > +
> 
> I would put a comment here like
> /* pin 1 clause */

yes I will add such comments
 
> Maybe it's more logical to have if (!offset) and handle pin
> 0 first, then pin 1 in the else clause?

why is it logical for one state to be preferred over the other?

> > +               ret = da9058_reg_read(da9058, DA9058_GPIO0001_REG,
> &gpio_cntrl);
> > +               if (ret)
> > +                       goto exit;
> > +               gpio->out_config &= ~0x80;
> > +               gpio->out_config |= value ? 0x80 : 0x00;
> > +
> > +               if (!(gpio_cntrl & 0x20))       /* an INP pin */
> > +                       goto exit;
> 
> Please use #define to define these magic bits.
> Something like this:
> 
> #include <linux/bitops.h>
> 
> #define DA9058_GPIO0_VAL  BIT(3)
> #define DA9058_GPIO0_INOUT  BIT(1)
> #define DA9058_GPIO1_VAL  BIT(7)
> #define DA9058_GPIO1_INOUT  BIT(5)
> 
> (etc, so we see what all bits are for)
> 
> then use these defines in the code...

the meaning of the bits other than the INP/OUT bits are not independent,
but depend on the direction. Thus each nibble contains 3 dependent bits.

> 
> > +
> > +               gpio_cntrl &= ~0xF0;
> > +               gpio_cntrl |= 0xF0 & gpio->out_config;
> > +
> > +               ret = da9058_reg_write(da9058, DA9058_GPIO0001_REG,
> gpio_cntrl);
> > +       } else {
> > +
> 
> I would put a comment here like
> /* pin 0 clause */

yes I will add such comments 

> > +               ret = da9058_reg_read(da9058, DA9058_GPIO0001_REG,
> &gpio_cntrl);
> > +               if (ret)
> > +                       goto exit;
> > +               gpio->out_config &= ~0x08;
> > +               gpio->out_config |= value ? 0x08 : 0x00;
> > +
> > +               if (!(gpio_cntrl & 0x02))       /* an INP pin */
> > +                       goto exit;
> 
> Magic bits, see above.

see end of e-mail

> (...)
> > +/*
> > + *  da9058_gpio_to_irq is an implementation of the GPIO Hook
> > + *  @to_irq: supporting non-static gpio_to_irq() mappings
> > + *  whose implementation may not sleep. This hook is called
> > + *  when setting up the threaded GPIO irq handler.
> > + */
> > +static int da9058_gpio_to_irq(struct gpio_chip *gc, u32 offset) {
> > +       struct da9058_gpio *gpio = gpio_chip_to_da9058_gpio(gc);
> > +       struct da9058 *da9058 = gpio->da9058;
> > +
> > +       if (offset > 1)
> > +               return -EINVAL;
> > +
> > +       if (offset)
> > +               return da9058_to_virt_irq_num(da9058, gpio->irq_1);
> > +       else
> > +               return da9058_to_virt_irq_num(da9058, gpio->irq_0); }
> 
> OK, if the DA9058 core is using irqdomain.

Yes the core is using irqdomain.

> > +       if (offset) {
> > +               u8 debounce_bits = debounce ? 0x80 : 0x00;
> 
> Is this really correct??
> 
> In earlier code you use bit 7 to set the value!

You are confusing input and output operations, the meanings
of each nibble's other 3 bits is depends on the direction. That
is why the INP and OUT configuration needs to be saved in a
control structure.

> This is partly why I ask you to use #defines for the bits:
> less risk to do things wrong by e.g. copy/paste bugs.

The hardware definition is in terms of bit patterns in each nibble,
so introducing a dual name for 3 of the 4 bits means double the
number of points an error can be made.

> > +               gpio->inp_config &= ~0x08;
> > +               gpio->inp_config |= debounce_bits;
> 
> Dito.
> 
> (...)
> > +static int da9058_gpio_probe(struct platform_device *pdev)
> (...)
> > +       /*
> > +        * INP configured pins:
> > +        *     9 == DebounceOn+ActiceLowPullUp
> > +        *
> > +        * OUT configured pins:
> > +        *     7 == PushPull+ExternalPullUpToVDDIO
> > +        *     3 == PushPull+InternalPullUpToVDDIO
> > +        *     2 == OpenDrain+InternalPullUpToVDDIO
> > +        */
> > +
> > +       gpio->inp_config = 0x99;
> > +       gpio->out_config = 0x77;
> 
> Again here you should #define the bits and | or them together instead of using
> comments to clarify it.

I think that in this particular case it will be more confusing trying to name the bits
due to the fact that 3 out of 4 bit in each nibble depend on the 4th bit.

> This is pinctrl basically but since you seem to hardcode it it can be in the GPIO
> subsystem anyway.
> 
> Yours,
> Linus Walleij

Hi Linus,

I failed previously to imagine any naming scheme that would make the meaning
of the magic bits in each nibble clearer. The best I could come up with was the
comment you referred to.

Tony Olech


