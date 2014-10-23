Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaJWH0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 03:26:08 -0400
Received: from mga03.intel.com ([134.134.136.65]:61838 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbaJWH0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 03:26:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,774,1406617200"; 
   d="scan'208";a="623793352"
From: "Chang, Rebecca Swee Fun" <rebecca.swee.fun.chang@intel.com>
To: "'Alexandre Courbot'" <gnurou@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Denis Turischev <denis.turischev@compulab.co.il>
Subject: RE: [PATCHv3 1/3] gpio: sch: Consolidate similar algorithms
Thread-Topic: [PATCHv3 1/3] gpio: sch: Consolidate similar algorithms
Thread-Index: AQHP6eZ7JeEtgf7yJkGiy9DuNcKC1Zw9TTGA
Date: Thu, 23 Oct 2014 07:23:25 +0000
Message-ID: <50B33AC5ED75F74F991980326F1C438D0FC00913@PGSMSX108.gar.corp.intel.com>
References: <1413431475-12799-1-git-send-email-rebecca.swee.fun.chang@intel.com>
 <1413431475-12799-2-git-send-email-rebecca.swee.fun.chang@intel.com>
 <CAAVeFuKVH4R0r1mdxgNRJY=D9hVSyO7NQ5eCOn4qcYMz6+vR3w@mail.gmail.com>
In-Reply-To: <CAAVeFuKVH4R0r1mdxgNRJY=D9hVSyO7NQ5eCOn4qcYMz6+vR3w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9N7QEr2013650

Thanks for the review comments. Please check my reply below.

> -----Original Message-----
> From: Alexandre Courbot [mailto:gnurou@gmail.com]
> Sent: 17 October, 2014 4:44 PM
> To: Chang, Rebecca Swee Fun
> Cc: Linus Walleij; Westerberg, Mika; GPIO Subsystem Mailing List; Linux Kernel
> Mailing List; Denis Turischev
> Subject: Re: [PATCHv3 1/3] gpio: sch: Consolidate similar algorithms
> 
> On Thu, Oct 16, 2014 at 12:51 PM, Chang Rebecca Swee Fun
> <rebecca.swee.fun.chang@intel.com> wrote:
> > Consolidating similar algorithms into common functions to make GPIO
> > SCH simpler and manageable.
> >
> > Signed-off-by: Chang Rebecca Swee Fun
> > <rebecca.swee.fun.chang@intel.com>
> > ---
> >  drivers/gpio/gpio-sch.c |   95 ++++++++++++++++++++++++++--------------------
> -
> >  1 file changed, 53 insertions(+), 42 deletions(-)
> >
> > diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c index
> > 99720c8..6e89be9 100644
> > --- a/drivers/gpio/gpio-sch.c
> > +++ b/drivers/gpio/gpio-sch.c
> > @@ -63,94 +63,105 @@ static unsigned sch_gpio_bit(struct sch_gpio *sch,
> unsigned gpio)
> >         return gpio % 8;
> >  }
> >
> > -static void sch_gpio_enable(struct sch_gpio *sch, unsigned gpio)
> > +static void sch_gpio_register_set(struct sch_gpio *sch, unsigned gpio,
> > +                                 unsigned reg)
> >  {
> >         unsigned short offset, bit;
> >         u8 enable;
> >
> >         spin_lock(&sch->lock);
> 
> ...
> 
> >
> > -       offset = sch_gpio_offset(sch, gpio, GEN);
> > +       offset = sch_gpio_offset(sch, gpio, reg);
> >         bit = sch_gpio_bit(sch, gpio);
> >
> >         enable = inb(sch->iobase + offset);
> 
> I see identical blocks of code in sch_gpio_register_clear(),
> sch_gpio_reg_get() and sch_gpio_reg_set() (and possibly other functions?).
> Maybe this could be factorized into an inline function that would return the
> "enable" variable?
> 
> Also, "enable" looks like the wrong name here. The exact same result is later
> called "disable" and "curr_dirs" later.

Referring to your comments below, this will be get rid of after the sch_gpio_register_set() and sch_gpio_register_clear() being replaced by sch_gpio_reg_set(gc, gpio, reg, 1) and sch_gpio_reg_set(gc, gpio, reg, 0).
There will be less identical block of "offset", "bit", and "enable" nor "disable". So there is no need to factorize the identical blocks into inline function.

> 
> > -       if (!(enable & (1 << bit)))
> > -               outb(enable | (1 << bit), sch->iobase + offset);
> > +       if (!(enable & BIT(bit)))
> > +               outb(enable | BIT(bit), sch->iobase + offset);
> >
> >         spin_unlock(&sch->lock);
> >  }
> >
> > -static int sch_gpio_direction_in(struct gpio_chip *gc, unsigned
> > gpio_num)
> > +static void sch_gpio_register_clear(struct sch_gpio *sch, unsigned gpio,
> > +                                   unsigned reg)
> >  {
> > -       struct sch_gpio *sch = to_sch_gpio(gc);
> > -       u8 curr_dirs;
> >         unsigned short offset, bit;
> > +       u8 disable;
> >
> >         spin_lock(&sch->lock);
> >
> > -       offset = sch_gpio_offset(sch, gpio_num, GIO);
> > -       bit = sch_gpio_bit(sch, gpio_num);
> > -
> > -       curr_dirs = inb(sch->iobase + offset);
> > +       offset = sch_gpio_offset(sch, gpio, reg);
> > +       bit = sch_gpio_bit(sch, gpio);
> >
> > -       if (!(curr_dirs & (1 << bit)))
> > -               outb(curr_dirs | (1 << bit), sch->iobase + offset);
> > +       disable = inb(sch->iobase + offset);
> > +       if (disable & BIT(bit))
> > +               outb(disable & ~BIT(bit), sch->iobase + offset);
> >
> >         spin_unlock(&sch->lock);
> > -       return 0;
> >  }
> >
> > -static int sch_gpio_get(struct gpio_chip *gc, unsigned gpio_num)
> > +static int sch_gpio_reg_get(struct gpio_chip *gc, unsigned gpio,
> > +unsigned reg)
> >  {
> >         struct sch_gpio *sch = to_sch_gpio(gc);
> > -       int res;
> >         unsigned short offset, bit;
> > +       u8 curr_dirs;
> >
> > -       offset = sch_gpio_offset(sch, gpio_num, GLV);
> > -       bit = sch_gpio_bit(sch, gpio_num);
> > +       offset = sch_gpio_offset(sch, gpio, reg);
> > +       bit = sch_gpio_bit(sch, gpio);
> >
> > -       res = !!(inb(sch->iobase + offset) & (1 << bit));
> > +       curr_dirs = !!(inb(sch->iobase + offset) & BIT(bit));
> >
> > -       return res;
> > +       return curr_dirs;
> >  }
> >
> > -static void sch_gpio_set(struct gpio_chip *gc, unsigned gpio_num, int
> > val)
> > +static void sch_gpio_reg_set(struct gpio_chip *gc, unsigned gpio, unsigned
> reg,
> > +                            int val)
> >  {
> >         struct sch_gpio *sch = to_sch_gpio(gc);
> > -       u8 curr_vals;
> >         unsigned short offset, bit;
> > +       u8 curr_dirs;
> >
> > -       spin_lock(&sch->lock);
> > -
> > -       offset = sch_gpio_offset(sch, gpio_num, GLV);
> > -       bit = sch_gpio_bit(sch, gpio_num);
> > +       offset = sch_gpio_offset(sch, gpio, reg);
> > +       bit = sch_gpio_bit(sch, gpio);
> >
> > -       curr_vals = inb(sch->iobase + offset);
> > +       curr_dirs = inb(sch->iobase + offset);
> >
> >         if (val)
> > -               outb(curr_vals | (1 << bit), sch->iobase + offset);
> > +               outb(curr_dirs | BIT(bit), sch->iobase + offset);
> >         else
> > -               outb((curr_vals & ~(1 << bit)), sch->iobase + offset);
> > +               outb((curr_dirs & ~BIT(bit)), sch->iobase + offset); }
> 
> Mmmm this really looks like sch_gpio_register_set() and
> sch_gpio_register_clear() could just call sch_gpio_reg_set() right after
> acquiring the spinlock. Also the names are very similar and it is not clear why
> you need two different functions here. Couldn't you call sch_gpio_reg_set(gc,
> gpio, reg, 1) in place of
> sch_gpio_register_set() and sch_gpio_reg_set(gc, gpio, reg, 0) for
> sch_gpio_register_clear()? You may need to acquire the spinlock before some
> call sites, but that's preferable to having very similar functions bearing a very
> similar name IMHO.

Thanks for pointing that out. I think I can replaced all sch_gpio_register_set() and sch_gpio_register_clear() with sch_gpio_reg_set(gc, gpio, reg, 0/1).
Regarding the spinlock, in fact, I have tested using the GPIO driver through sysfs. I didn't encounter any deadlock issue, but the double locking is really an issue.
This double lock problem can also be fix by calling sch_gpio_reg_set(gc, gpio, reg, 0/1) in place of sch_gpio_register_set() and sch_gpio_register_clear().

> 
> >
> > +static int sch_gpio_direction_in(struct gpio_chip *gc, unsigned
> > +gpio_num) {
> > +       struct sch_gpio *sch = to_sch_gpio(gc);
> > +
> > +       spin_lock(&sch->lock);
> > +       sch_gpio_register_set(sch, gpio_num, GIO);
> 
> So here you are acquiring sch->lock, then calling
> sch_gpio_register_set() which will try to acquire the same spinlock first thing.
> Wouldn't that deadlock? Have you tested changing the direction of a GPIO? This
> again speaks in favor or reducing the number of similar functions in this file.
> 
> Unless I misunderstood something there are still some issues that make this file
> harder to understand than it should, and which can sometimes bork the system
> altogether. It is a good idea to cleanup this file, but please try to go one step
> further - this should simplify locking and ultimately get rid of the locking issues.
> 
> And hopefully I will also take less time to review v4. :P

Thanks for the review. I will take note on the locking part and resend later or next week. Appreciate your review comments. Thank you!

Rebecca
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
