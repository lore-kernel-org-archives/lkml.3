Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaJWHby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 03:31:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:19407 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbaJWHbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 03:31:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,774,1406617200"; 
   d="scan'208";a="623796707"
From: "Chang, Rebecca Swee Fun" <rebecca.swee.fun.chang@intel.com>
To: "'Alexandre Courbot'" <gnurou@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Denis Turischev <denis.turischev@compulab.co.il>
Subject: RE: [PATCHv3 3/3] gpio: sch: Enable IRQ support for Quark X1000
Thread-Topic: [PATCHv3 3/3] gpio: sch: Enable IRQ support for Quark X1000
Thread-Index: AQHP6ef1Ka3j/RcXxUq5NEUuAjnRK5w9ULSg
Date: Thu, 23 Oct 2014 07:29:38 +0000
Message-ID: <50B33AC5ED75F74F991980326F1C438D0FC00922@PGSMSX108.gar.corp.intel.com>
References: <1413431475-12799-1-git-send-email-rebecca.swee.fun.chang@intel.com>
 <1413431475-12799-4-git-send-email-rebecca.swee.fun.chang@intel.com>
 <CAAVeFuJe_52V3bWJ9AzvXMNedwJ5m67xC-L3b-d0LH+q4ogH=A@mail.gmail.com>
In-Reply-To: <CAAVeFuJe_52V3bWJ9AzvXMNedwJ5m67xC-L3b-d0LH+q4ogH=A@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9N7Vxvi013683

> > +
> > +static int sch_gpio_irq_type(struct irq_data *d, unsigned type)
> > +{
> > +       struct sch_gpio *sch = container_of(d, struct sch_gpio, data);
> > +       unsigned long flags;
> > +       u32 gpio_num;
> > +
> > +       if (d == NULL)
> > +               return -EINVAL;
> > +
> > +       gpio_num = d->irq - sch->irq_base;
> > +
> > +       spin_lock_irqsave(&sch->lock, flags);
> > +
> > +       switch (type) {
> > +       case IRQ_TYPE_EDGE_RISING:
> > +               sch_gpio_register_set(sch, gpio_num, GTPE);
> > +               sch_gpio_register_clear(sch, gpio_num, GTNE);
> 
> You will have the same problem as I pointed out in patch 1/3 that
> sch_gpio_register_set/clear() will try to acquire the already-locked
> sch->lock. No way this can ever work, or I am under a serious
> misapprehension.
> 
> > +               break;
> > +
> > +       case IRQ_TYPE_EDGE_FALLING:
> > +               sch_gpio_register_set(sch, gpio_num, GTNE);
> > +               sch_gpio_register_clear(sch, gpio_num, GTPE);
> > +               break;
> > +
> > +       case IRQ_TYPE_EDGE_BOTH:
> > +               sch_gpio_register_set(sch, gpio_num, GTPE);
> > +               sch_gpio_register_set(sch, gpio_num, GTNE);
> > +               break;
> > +
> > +       case IRQ_TYPE_NONE:
> > +               sch_gpio_register_clear(sch, gpio_num, GTPE);
> > +               sch_gpio_register_clear(sch, gpio_num, GTNE);
> > +               break;
> > +
> > +       default:
> > +               spin_unlock_irqrestore(&sch->lock, flags);
> > +               return -EINVAL;
> > +       }
> > +
> > +       spin_unlock_irqrestore(&sch->lock, flags);
> > +
> > +       return 0;
> > +}
> > +
> > +static struct irq_chip sch_irq_chip = {
> > +       .irq_enable     = sch_gpio_irq_enable,
> > +       .irq_disable    = sch_gpio_irq_disable,
> > +       .irq_ack        = sch_gpio_irq_ack,
> > +       .irq_set_type   = sch_gpio_irq_type,
> > +};
> > +
> > +static void sch_gpio_irqs_init(struct sch_gpio *sch, unsigned int num)
> > +{
> > +       unsigned int i;
> > +
> > +       for (i = 0; i < num; i++) {
> > +               irq_set_chip_data(i + sch->irq_base, sch);
> > +               irq_set_chip_and_handler_name(i + sch->irq_base,
> > +                                             &sch_irq_chip,
> > +                                             handle_simple_irq,
> > +                                             "sch_gpio_irq_chip");
> > +       }
> > +}
> > +
> > +static void sch_gpio_irqs_deinit(struct sch_gpio *sch, unsigned int num)
> > +{
> > +       unsigned int i;
> > +
> > +       for (i = 0; i < num; i++) {
> > +               irq_set_chip_data(i + sch->irq_base, 0);
> > +               irq_set_chip_and_handler_name(i + sch->irq_base, 0, 0, 0);
> > +       }
> > +}
> > +
> > +static void sch_gpio_irq_disable_all(struct sch_gpio *sch, unsigned int num)
> > +{
> > +       unsigned long flags;
> > +       unsigned int gpio_num;
> > +
> > +       spin_lock_irqsave(&sch->lock, flags);
> > +
> > +       for (gpio_num = 0; gpio_num < num; gpio_num++) {
> > +               sch_gpio_register_clear(sch, gpio_num, GTPE);
> > +               sch_gpio_register_clear(sch, gpio_num, GTNE);
> > +               sch_gpio_register_clear(sch, gpio_num, GGPE);
> > +               sch_gpio_register_clear(sch, gpio_num, GSMI);
> 
> Same here.


Alright. I should have noticed this double locking issue earlier. Thanks. I think the next version will be much cleaner. Thanks for spending time and effort to review.

Rebecca
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
