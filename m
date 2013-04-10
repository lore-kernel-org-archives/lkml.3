Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036Ab3DJTZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 15:25:53 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:43123 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762176Ab3DJTZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 15:25:52 -0400
MIME-Version: 1.0
In-Reply-To: <1363355140-28216-4-git-send-email-andreas@gaisler.com>
References: <1363355140-28216-1-git-send-email-andreas@gaisler.com>
	<1363355140-28216-4-git-send-email-andreas@gaisler.com>
Date: Wed, 10 Apr 2013 21:25:51 +0200
Message-ID: <CACRpkdZ4AK=3PGQ-3+ffWsH9B-ywrDkMxnePWat1=P7WoqgJWA@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] gpio: grgpio: Add irq support
From: Linus Walleij <linus.walleij@linaro.org>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        software@gaisler.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 2:45 PM, Andreas Larsson <andreas@gaisler.com> wrote:

> The drivers sets up an irq domain and hands out unique virqs to irq
> capable gpio lines regardless of which underlying irqs maps to which gpio
> line.
>
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
(...)
> +- irqmap : An array with an index for each gpio line. An index is either a valid
> +       index into the interrupts property array, or 0xffffffff that indicates
> +       no irq for that line. Driver provides no interrupt support if not
> +       present.

This looks really complicated.

Can't you just do this with a flag instead?

irq-enabled-mask = <0xf0f0f0f0>;

Like 0xf0f0f0f0 would indicate that lines 0-3, 8-11, 16-19 and 24-27
have no IRQ, lines 4-7, 12-15, 20-23 and 28-31 does have IRQ.

Then supply the resulting 16 IRQs in the interrupts property.

But you should double-check this with some more DT-aware person
I guess, there may be precedents. Did you get this idea from
some other binding?

> +struct grgpio_uirq {
> +       u8 refcnt; /* Reference counter to manage requesting/freeing of uirq */
> +       u8 uirq; /* Underlying virq of the gpio driver */

This looks very complicated. But well, maybe there are no
other ways...

If you do this you will need some spinlock to protect the refcount,
or make it an atomic type. Another way is to use <linux/kref.h>
if you refactor around that.

> +};
> +
> +struct grgpio_lirq {
> +       s8 index; /* Index into struct grgpio_priv's uirqs, or -1 */
> +       u8 virq; /* virq for the gpio line */

Just call it irq. These are Linux irqs, they are not "virtual".

> +       u32 imask; /* irq mask shadow register */
> +
> +       /* The grgpio core can have multiple irqs. Severeal gpio lines can
> +        * potentially be mapped to the same irq. This driver sets up an
> +        * irq domain and hands out separate virqs to each gpio line
> +        */

This is very common. Most GPIO controller have something like
one IRQ line per 32 GPIO lines. It's a bit odd that it can have
an arbitrary number of non-irq capable GPIOs though.

Note:

/*
 * I really prefer this comment style, where ther is no text on the
 * first line of the comment.
 */

> +       struct irq_domain *domain;
> +
> +       /* This array contains information on each underlying irq, each
> +        * irq of the grgpio core itself.
> +        */
> +       struct grgpio_uirq uirqs[GRGPIO_MAX_NGPIO];

So "u" is for "underlying"?

> +
> +       /* This array contains information for each gpio line on the
> +        * virtual irqs obtains from this driver. An index value of -1 for
> +        * a certain gpio line indicates that the line has no
> +        * irq. Otherwise the index connects the virq to the underlying
> +        * irq by pointing into the uirqs array.
> +        */
> +       struct grgpio_lirq lirqs[GRGPIO_MAX_NGPIO];

Hm, very complex...

> +static void grgpio_set_imask(struct grgpio_priv *priv, unsigned int offset,
> +                            int val)
> +{
> +       struct bgpio_chip *bgc = &priv->bgc;
> +       unsigned long mask = bgc->pin2mask(bgc, offset);
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&bgc->lock, flags);
> +
> +       if (val)
> +               priv->imask |= mask;
> +       else
> +               priv->imask &= ~mask;
> +       bgc->write_reg(&priv->regs->imask, priv->imask);

I prefer:

#define GRGPIO_IMASK 0xnn

bgc->write_reg(priv->base + GRGPIO_IMASK, priv->imask);

(...)

> +       ipol = priv->bgc.read_reg(&priv->regs->ipol) & ~mask;
> +       iedge = priv->bgc.read_reg(&priv->regs->iedge) & ~mask;
> +
> +       priv->bgc.write_reg(&priv->regs->ipol, ipol | pol);
> +       priv->bgc.write_reg(&priv->regs->iedge, iedge | edge);

Dito on all these.

> +static irqreturn_t grgpio_irq_handler(int irq, void *dev)
> +{
> +       struct grgpio_priv *priv = dev;
> +       int ngpio = priv->bgc.gc.ngpio;
> +       int i;
> +
> +       for (i = 0; i < ngpio; i++) {
> +               struct grgpio_lirq *lirq = &priv->lirqs[i];
> +
> +               if (priv->imask & BIT(i) && lirq->index >= 0 &&
> +                   priv->uirqs[lirq->index].uirq == irq) {
> +                       generic_handle_irq(lirq->virq);
> +               }

Should there not be an else clause here handling invalid
interrupts or printing an error or something?

> +       }
> +
> +       return IRQ_HANDLED;
> +}


(...)
> +
> +/* This function will be called as a consequence of the call to
> + * irq_create_mapping in grgpio_to_irq
> + */
> +int grgpio_irq_map(struct irq_domain *d, unsigned int virq,
> +                  irq_hw_number_t hwirq)
> +{
> +       struct grgpio_priv *priv = d->host_data;
> +       struct grgpio_lirq *lirq;
> +       struct grgpio_uirq *uirq;
> +       unsigned long flags;
> +       int offset = hwirq;
> +       int ret = 0;
> +
> +       if (!priv)
> +               return -EINVAL;
> +
> +       lirq = &priv->lirqs[offset];
> +       if (lirq->index < 0)
> +               return -EINVAL;
> +
> +       dev_dbg(priv->dev, "Mapping virq %d for gpio line %d\n",
> +               virq, offset);
> +
> +       spin_lock_irqsave(&priv->bgc.lock, flags);
> +
> +       /* Request underlying irq if not already requested */
> +       lirq->virq = virq;
> +       uirq = &priv->uirqs[lirq->index];
> +       if (uirq->refcnt == 0) {
> +               ret = request_irq(uirq->uirq, grgpio_irq_handler, 0,
> +                                 dev_name(priv->dev), priv);


No, please request all present uirqs in probe() before creating the
irqdomain.

And use devm_request_irq() for that.

> +               if (ret) {
> +                       dev_err(priv->dev,
> +                               "Could not request underlying irq %d\n",
> +                               uirq->uirq);
> +
> +                       spin_unlock_irqrestore(&priv->bgc.lock, flags);
> +
> +                       return ret;
> +               }
> +       }
> +       uirq->refcnt++;
> +
> +       spin_unlock_irqrestore(&priv->bgc.lock, flags);
> +
> +       /* Setup virq  */
> +       irq_set_chip_data(virq, priv);
> +       irq_set_chip_and_handler(virq, &grgpio_irq_chip,
> +                                handle_simple_irq);
> +       irq_clear_status_flags(virq, IRQ_NOREQUEST);
> +#ifdef CONFIG_ARM
> +       set_irq_flags(virq, IRQF_VALID);
> +#else
> +       irq_set_noprobe(virq);
> +#endif
> +
> +       return ret;
> +}
> +
> +void grgpio_irq_unmap(struct irq_domain *d, unsigned int virq)
> +{
> +       struct grgpio_priv *priv = d->host_data;
> +       int index;
> +       struct grgpio_lirq *lirq;
> +       struct grgpio_uirq *uirq;
> +       unsigned long flags;
> +       int ngpio = priv->bgc.gc.ngpio;
> +       int i;
> +
> +#ifdef CONFIG_ARM
> +       set_irq_flags(virq, 0);
> +#endif
> +       irq_set_chip_and_handler(virq, NULL, NULL);
> +       irq_set_chip_data(virq, NULL);
> +
> +       spin_lock_irqsave(&priv->bgc.lock, flags);
> +
> +       /* Free underlying irq if last user unmapped */
> +       index = -1;
> +       for (i = 0; i < ngpio; i++) {
> +               lirq = &priv->lirqs[i];
> +               if (lirq->virq == virq) {
> +                       grgpio_set_imask(priv, i, 0);
> +                       lirq->virq = 0;
> +                       index = lirq->index;
> +                       break;
> +               }
> +       }
> +       WARN_ON(index < 0);
> +
> +       if (index >= 0) {
> +               uirq = &priv->uirqs[lirq->index];
> +               uirq->refcnt--;
> +               if (uirq->refcnt == 0)
> +                       free_irq(uirq->uirq, priv);
> +       }


Don't do that either. devm_request_irq() will free the
IRQ when the driver unloads. No need for messy code
trying to cover it up.

> +       spin_unlock_irqrestore(&priv->bgc.lock, flags);
>  }
>
> +static struct irq_domain_ops grgpio_irq_domain_ops = {
> +       .map    = grgpio_irq_map,
> +       .unmap  = grgpio_irq_unmap,
> +};
> +
> +/* ------------------------------------------------------------ */
> +
>  static int grgpio_probe(struct platform_device *ofdev)
>  {
>         struct device_node *np = ofdev->dev.of_node;
> @@ -75,6 +329,9 @@ static int grgpio_probe(struct platform_device *ofdev)
>         struct resource *res;
>         int err;
>         u32 prop;
> +       s32 *irqmap;
> +       int size;
> +       int i;
>
>         priv = devm_kzalloc(&ofdev->dev, sizeof(*priv), GFP_KERNEL);
>         if (!priv)
> @@ -94,6 +351,7 @@ static int grgpio_probe(struct platform_device *ofdev)
>         }
>
>         priv->regs = regs;
> +       priv->imask = bgc->read_reg(&regs->imask);
>         priv->dev = &ofdev->dev;
>
>         gc = &bgc->gc;
> @@ -119,6 +377,49 @@ static int grgpio_probe(struct platform_device *ofdev)
>                 gc->ngpio = prop;
>         }
>
> +       /* The irqmap contains the index values indicating which underlying irq,
> +        * if anyone, is connected to that line
> +        */
> +       irqmap = (s32 *)of_get_property(np, "irqmap", &size);
> +       if (irqmap) {
> +               if (size < gc->ngpio) {
> +                       dev_err(&ofdev->dev,
> +                               "irqmap shorter than ngpio (%d < %d)\n",
> +                               size, gc->ngpio);
> +                       return -EINVAL;
> +               }


So devm_request all uirqs somehere like here.

> +               priv->domain = irq_domain_add_linear(np, gc->ngpio,
> +                                                    &grgpio_irq_domain_ops,
> +                                                    priv);

Then move this below the loop, so you know you have all uirqs
when you create the domain.

> +               if (!priv->domain) {
> +                       dev_err(&ofdev->dev, "Could not add irq domain\n");
> +                       return -EINVAL;
> +               }
> +
> +               for (i = 0; i < gc->ngpio; i++) {
> +                       struct grgpio_lirq *lirq;
> +                       int ret;
> +
> +                       lirq = &priv->lirqs[i];
> +                       lirq->index = irqmap[i];
> +
> +                       if (lirq->index < 0)
> +                               continue;
> +
> +                       ret = platform_get_irq(ofdev, lirq->index);
> +                       if (ret <= 0) {
> +                               /* Continue without irq functionality for that
> +                                * gpio line
> +                                */
> +                               dev_err(priv->dev,
> +                                       "Failed to get irq for offset %d\n", i);
> +                               continue;
> +                       }
> +                       priv->uirqs[lirq->index].uirq = ret;
> +               }
> +       }
> +
>         platform_set_drvdata(ofdev, priv);
>
>         err = gpiochip_add(gc);
> @@ -127,8 +428,8 @@ static int grgpio_probe(struct platform_device *ofdev)
>                 return err;
>         }
>
> -       dev_info(&ofdev->dev, "regs=0x%p, base=%d, ngpio=%d\n",
> -                priv->regs, gc->base, gc->ngpio);
> +       dev_info(&ofdev->dev, "regs=0x%p, base=%d, ngpio=%d, irqs=%s\n",
> +                priv->regs, gc->base, gc->ngpio, priv->domain ? "on" : "off");
>
>         return 0;
>  }
(...)

Yours,
Linus Walleij
