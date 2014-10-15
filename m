Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbaJOJU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 05:20:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:20823 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbaJOJUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 05:20:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="400531595"
From: "Chang, Rebecca Swee Fun" <rebecca.swee.fun.chang@intel.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>,
        Denis Turischev <denis.turischev@compulab.co.il>
CC: "Westerberg, Mika" <mika.westerberg@intel.com>,
        "GPIO Subsystem Mailing List" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv2 3/3] gpio: sch: Enable IRQ support for Quark X1000
Thread-Topic: [PATCHv2 3/3] gpio: sch: Enable IRQ support for Quark X1000
Thread-Index: AQHP6EfUu265f8mqsEmKslg9rc0e7Zww3z0w
Date: Wed, 15 Oct 2014 09:20:06 +0000
Message-ID: <50B33AC5ED75F74F991980326F1C438D0FBEE12A@PGSMSX108.gar.corp.intel.com>
References: <1411726047-3224-1-git-send-email-rebecca.swee.fun.chang@intel.com>
	<1411726047-3224-4-git-send-email-rebecca.swee.fun.chang@intel.com>
 <CACRpkdY=FmMR2Gg-yaasMxMkjmVz2TOWDAVb8DJak9CXWtnk7A@mail.gmail.com>
In-Reply-To: <CACRpkdY=FmMR2Gg-yaasMxMkjmVz2TOWDAVb8DJak9CXWtnk7A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9F9L1Gb030204



> -----Original Message-----
> From: Linus Walleij [mailto:linus.walleij@linaro.org]
> Sent: 15 October, 2014 3:13 PM
> To: Chang, Rebecca Swee Fun; Denis Turischev
> Cc: Westerberg, Mika; GPIO Subsystem Mailing List; Linux Kernel Mailing List
> Subject: Re: [PATCHv2 3/3] gpio: sch: Enable IRQ support for Quark X1000
> 
> On Fri, Sep 26, 2014 at 12:07 PM, Chang Rebecca Swee Fun
> <rebecca.swee.fun.chang@intel.com> wrote:
> 
> > Intel Quark X1000 GPIO controller supports interrupt handling for both
> > core power well and resume power well. This patch is to enable the IRQ
> > support and provide IRQ handling for Intel Quark X1000 GPIO-SCH device
> > driver.
> >
> > This piece of work is derived from Dan O'Donovan's initial work for
> > Quark X1000 enabling.
> >
> > Signed-off-by: Chang Rebecca Swee Fun
> > <rebecca.swee.fun.chang@intel.com>
> (...)
> 
> This patch needs to be rebased on the gpio git "devel" branch or Torvalds'
> HEAD before I can apply it.

I will rebase and resend with the fixes below.

> 
> >  #define GEN    0x00
> >  #define GIO    0x04
> >  #define GLV    0x08
> > +#define GTPE   0x0C
> > +#define GTNE   0x10
> > +#define GGPE   0x14
> > +#define GSMI   0x18
> > +#define GTS    0x1C
> > +#define CGNMIEN        0x40
> > +#define RGNMIEN        0x44
> 
> So the initial SCH driver for the Intel Poulsbo was submitted by Denis Turischev
> in 2010.
> 
> Does these registers exist and work on the Poulsbo as well?
> 
> Is it really enough to distinguish between these variants by checking if we're
> getting an IRQ resource on the device or not?
> Is there some version register or so?

The register values defined here are offset value, they are not the exact register address. 
They are not version register as it just carries a register offset value.

> >  struct sch_gpio {
> >         struct gpio_chip chip;
> > +       struct irq_data data;
> >         spinlock_t lock;
> >         unsigned short iobase;
> >         unsigned short core_base;
> >         unsigned short resume_base;
> > +       int irq_base;
> > +       int irq_num;
> > +       int irq_support;
> 
> Isn't that a bool?
> 
> > +       irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> > +       sch->irq_support = !!irq;
> 
> Yeah, it's a bool....

I will change it to bool.

> 
> > +       if (sch->irq_support) {
> > +               sch->irq_num = irq->start;
> > +               if (sch->irq_num < 0) {
> > +                       dev_warn(&pdev->dev,
> > +                                "failed to obtain irq number for device\n");
> > +                       sch->irq_support = 0;
> 
> = false;

Noted
> 
> > +       if (sch->irq_support) {
> > +               sch->irq_base = irq_alloc_descs(-1, 0, sch->chip.ngpio,
> > +                                               NUMA_NO_NODE);
> > +               if (sch->irq_base < 0) {
> > +                       dev_err(&pdev->dev,
> > +                               "failed to add GPIO IRQ descs\n");
> 
> Failed to *allocate* actually...
> 
> > +                       sch->irq_base = -1;
> 
> This is overzealous. Drop it.
> 
> > +                       goto err_sch_intr_chip;
> 
> You're bailing out anyway, see.

Noted. I will change the phrase accordingly and remove the expression on next submission.

> 
> >  static int sch_gpio_remove(struct platform_device *pdev)  {
> >         struct sch_gpio *sch = platform_get_drvdata(pdev);
> > +       int err;
> >
> > -       gpiochip_remove(&sch->chip);
> > -       return 0;
> > +       if (sch->irq_support) {
> > +               sch_gpio_irqs_deinit(sch, sch->chip.ngpio);
> > +
> > +               if (sch->irq_num >= 0)
> > +                       free_irq(sch->irq_num, sch);
> > +
> > +               irq_free_descs(sch->irq_base, sch->chip.ngpio);
> > +       }
> > +
> > +       err = gpiochip_remove(&sch->chip);
> > +       if (err)
> > +               dev_err(&pdev->dev,
> > +                       "%s gpiochip_remove() failed\n", __func__);
> 
> So gpiochip_remove() does *NOT* return an error in the current
> kernel. We just removed that return value from the SCH driver in the
> previous cycle for the reason that we were killing off the return type.
> commit 9f5132ae82fdbb047cc187bf689a81c8cc0de7fa
> "gpio: remove all usage of gpio_remove retval in driver/gpio"
> 
> So don't reintroduce stuff we're actively trying to get rid of.
> 
> Apart from this is looks OK, Mika can you ACK the end result?

Noted with thanks. I will do the changes required and resend the series.
Thanks.

Regards
Rebecca
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
