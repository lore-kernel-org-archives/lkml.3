Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbbANCcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 21:32:33 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:35429 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751389AbbANCca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 21:32:30 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v4 4/5] ARM: mediatek: Add EINT support to MTK pinctrl
 driver.
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        <maoguang.meng@mediatek.com>, Russell King <linux@arm.linux.org.uk>,
        <srv_heupstream@mediatek.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hongzhou Yang <hongzhou.yang@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, <alan.cheng@mediatek.com>,
        <toby.liu@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, <dandan.he@mediatek.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <CACRpkdb2KJbjzFgTmDvHSw7jNAExxVtU3y4_fgyn6J8hcW5OrQ@mail.gmail.com>
References: <1418772873-19747-1-git-send-email-hongzhou.yang@mediatek.com>
	 <1418772873-19747-5-git-send-email-hongzhou.yang@mediatek.com>
	 <1418807365.6443.17.camel@mtksdaap41>
	 <1420535817.17567.10.camel@mtksdaap41>
	 <CACRpkdb2KJbjzFgTmDvHSw7jNAExxVtU3y4_fgyn6J8hcW5OrQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Jan 2015 10:32:25 +0800
Message-ID: <1421202745.27675.148.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-13 at 14:24 +0100, Linus Walleij wrote:
> On Tue, Jan 6, 2015 at 10:16 AM, Yingjoe Chen <yingjoe.chen@mediatek.com> wrote:
> > On Wed, 2014-12-17 at 17:09 +0800, Yingjoe Chen wrote:
> >> On Wed, 2014-12-17 at 07:34 +0800, Hongzhou Yang wrote:
> >> > From: Maoguang Meng <maoguang.meng@mediatek.com>
> >> >
> >> > MTK SoC support external interrupt(EINT) from most SoC pins.
> >> > Add EINT support to pinctrl driver.
> >> >
> >> > Signed-off-by: Maoguang Meng <maoguang.meng@mediatek.com>
> >> > Signed-off-by: Hongzhou Yang <hongzhou.yang@mediatek.com>
> >>
> >> Hi Linus,
> >>
> >> This patch add EINT support to the pinctrl driver. We've surveyed
> >> GPIOLIB_IRQCHIP, but we didn't use it because:
> >>
> >> - Not every GPIO pin support interrupt.
> >> - EINT use a different numbering to GPIO. eg, from the mt8135 table,
> >> GPIO29 is EINT158. It is more nature & efficient to use EINT number as
> >> hwirq.
> >>
> >> +               MTK_EINT_FUNCTION(2, 158),
> >> +               MTK_FUNCTION(0, "GPIO29"),
> >
> > After further looking into this, we could use GPIOLIB_IRQCHIP if we add
> > an extension gpiochip_irqchip_add() to accept interrupt numbers and
> > custom .to_irq function for our SoC. We could still reuse other code
> > GPIOLIB_IRQCHIP provide.
> 
> I see, and I still want to see all possibilities to centralize code
> surveyed.
> 
> If I understand correctly what you actually need is a linear
> irqdomain with "holes" (invalid offsets) in it.
> So this is what we should design for.
> 
> The .to_irq() function should not really perform anything but a
> simple lookup in the domain.
> 
> What you do here:
> 
> +static int mtk_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
> +{
> +       const struct mtk_desc_pin *pin;
> +       struct mtk_pinctrl *pctl = dev_get_drvdata(chip->dev);
> +       int irq;
> +
> +       pin = pctl->devdata->pins + offset;
> +       if (pin->eint.eintnum == NO_EINT_SUPPORT)
> +               return -EINVAL;
> +
> +       irq = irq_find_mapping(pctl->domain, pin->eint.eintnum);
> +       if (!irq)
> +               return -EINVAL;
> +
> +       return irq;
> +}
> 
> Is *avoiding* to translate some IRQs from a certain offset using
> the domain, I think that is the wrong way to go.

Hi Linus,

Yes, it have holes and avoiding translate some gpio to irq, but it also
using a different hwirq number to do the translate.

Let's me describe my problem more clearly. On our SoC, if a pin support
interrupt it will have 2 different numbers for it. For examples, here's
a partial list for the gpio and EINT number mappings on mt8135:

   gpio  EINT
     0     49
     1     48
    ...........
    36     97
    37     19      
    ...........

To control interrupt related function, we'll need EINT number to locate
corresponding register bits. When interrupt occurs, the interrupt
handler will know which EINT interrupt occurs. In irq_chip functions,
only .irq_request_resources and .irq_release_resources use gpio number
to set pinmux to EINT mode and all the others need EINT number.

Because EINT number is used more frequently in interrupt related
functions, it make sense to use EINT number as hwirq instead of gpio
number. That means irq_domain will translate EINT number to virq.
So what mtk_gpio_to_irq actually do is translate gpio number to EINT
number and use irq domain to translate it to virq.

Below is a draft of what I have in mind. For SoC that can use gpio
number to control irq they still use gpiochip_irqchip_add(). For SoC
that need to use another number to control irq, like us, can use
gpiochip_irqchip_add_with_map. We can't reuse gpiochip_to_irq or
gpiochip_irq_reqres/relres in GPIOLIB_IRQCHIP, but we can still reuse
others code.

Let me know if this is the direction you want.
Thanks

Joe.C

=======================
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -567,11 +567,14 @@ static void gpiochip_irqchip_remove(struct
gpio_chip *gpiochip)
  * the pins on the gpiochip can generate a unique IRQ. Everything else
  * need to be open coded.
  */
-int gpiochip_irqchip_add(struct gpio_chip *gpiochip,
-                        struct irq_chip *irqchip,
-                        unsigned int first_irq,
-                        irq_flow_handler_t handler,
-                        unsigned int type)
+int gpiochip_irqchip_add_with_map(struct gpio_chip *gpiochip,
+                                 struct irq_chip *irqchip,
+                                 unsigned int first_irq,
+                                 irq_flow_handler_t handler,
+                                 unsigned int type,
+                                 unsigned int size,
+                                 int (*to_irq_func)(struct gpio_chip *chip,
+                                                    unsigned offset))
 {
        struct device_node *of_node;
        unsigned int offset;
@@ -604,15 +607,17 @@ int gpiochip_irqchip_add(struct gpio_chip *gpiochip,
                gpiochip->irqchip = NULL;
                return -EINVAL;
        }
-       irqchip->irq_request_resources = gpiochip_irq_reqres;
-       irqchip->irq_release_resources = gpiochip_irq_relres;
+       if (!irqchip->irq_request_resources) {
+               irqchip->irq_request_resources = gpiochip_irq_reqres;
+               irqchip->irq_release_resources = gpiochip_irq_relres;
+       }

        /*
         * Prepare the mapping since the irqchip shall be orthogonal to
         * any gpiochip calls. If the first_irq was zero, this is
         * necessary to allocate descriptors for all IRQs.
         */
-       for (offset = 0; offset < gpiochip->ngpio; offset++) {
+       for (offset = 0; offset < size; offset++) {
                irq_base = irq_create_mapping(gpiochip->irqdomain, offset);
                if (offset == 0)
                        /*
@@ -626,6 +631,18 @@ int gpiochip_irqchip_add(struct gpio_chip *gpiochip,

        return 0;
 }
+
+int gpiochip_irqchip_add(struct gpio_chip *gpiochip,
+                        struct irq_chip *irqchip,
+                        unsigned int first_irq,
+                        irq_flow_handler_t handler,
+                        unsigned int type)
+{
+       return gpiochip_irqchip_add_with_map(gpiochip, irqchip, first_irq,
+                                            handler, type,
+                                            gpiochip->ngpiog, piochip_to_irq);
+}




