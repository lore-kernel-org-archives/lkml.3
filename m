Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab3KFLgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:36:18 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46069 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088Ab3KFLgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:36:08 -0500
Message-ID: <527A28EF.9070601@ti.com>
Date: Wed, 6 Nov 2013 13:33:03 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>, Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Alex Elder <alex.elder@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 1/6] gpio: davinci: Fixed a check for unbanked gpio
References: <1383406775-14902-1-git-send-email-prabhakar.csenng@gmail.com> <1383406775-14902-2-git-send-email-prabhakar.csenng@gmail.com> <CACRpkdZ7pwGQnK0NN4tybLUNdMxu5WVaGX8Dqu+kMgVBuyF16w@mail.gmail.com> <CA+V-a8tE3bxsHMSh2i3Xeq=kJUjmxTjcU25Kuka5e_iXeB--pQ@mail.gmail.com> <CACRpkdbLTopHMaog7FDW7O4-yLyv+mmnvgkNuXgeQR-pEtbz6Q@mail.gmail.com> <CA+V-a8tZTm9bh+arQ+uFyTVHxfdf07bWaM_Sdqo08TO=UCMMUg@mail.gmail.com> <527A1EC7.20400@ti.com>
In-Reply-To: <527A1EC7.20400@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.75]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar, Linus,

On 11/06/2013 12:49 PM, Sekhar Nori wrote:
> On Wednesday 06 November 2013 03:45 PM, Prabhakar Lad wrote:
>> Hi Linus,
>>
>> On Wed, Nov 6, 2013 at 3:26 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>>> On Wed, Nov 6, 2013 at 10:33 AM, Prabhakar Lad
>>> <prabhakar.csengg@gmail.com> wrote:
>>>> On Tue, Nov 5, 2013 at 6:09 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>>>>> On Sat, Nov 2, 2013 at 4:39 PM, Lad, Prabhakar
>>>>> <prabhakar.csengg@gmail.com> wrote:
>>>>>
>>>>>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>>>>>
>>>>>> This patch fixes the check for the offset in
>>>>>> gpio_to_irq_unbanked() function.
>>>>>>
>>>>>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>>>
>>>>> Is this a regression that should go in right now?
>>>>>
>>>> Yes it needs too.
>>>
>>> But on top of *what* exactly?
>>>
>>> This does not apply to my gpio tree devel branch and
>>> not even on the mainline kernel.
>>>
>> Looks like this needs to go via ARM tree as the earlier
>> patches have  gone via ARM tree itself [1].
>> If you can ACK it Sekhar can get it in via ARM tree.
>
> The dependent patches are all in linux-next through ARM SoC queued for
> v3.13 merge. This fix can either be sent late in merge cycle once Linus
> has pulled ARM SoC or after v3.13-rc1 comes out.

Pls, wait a bit - this fix is incomplete :( The below changes have to be 
done too:

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 6c90cfb..05dbadb 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -328,7 +328,7 @@ static int gpio_to_irq_unbanked(struct gpio_chip 
*chip, unsigned offset)
          * can provide direct-mapped IRQs to AINTC (up to 32 GPIOs).
          */
         if (offset < d->gpio_unbanked)
-               return d->gpio_irq + offset;
+               return d->irq_base + offset;
         else
                 return -ENODEV;
  }
@@ -341,7 +341,7 @@ static int gpio_irq_type_unbanked(struct irq_data 
*data, unsigned trigger)

         d = (struct davinci_gpio_controller *)data->handler_data;
         g = (struct davinci_gpio_regs __iomem *)d->regs;
-       mask = __gpio_mask(data->irq - d->gpio_irq);
+       mask = __gpio_mask(data->irq - d->irq_base);

         if (trigger & ~(IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
                 return -EINVAL;
@@ -419,6 +419,8 @@ static int davinci_gpio_irq_setup(struct 
platform_device *pdev)

                 /* pass "bank 0" GPIO IRQs to AINTC */
                 chips[0].chip.to_irq = gpio_to_irq_unbanked;
+               chips[0].irq_base = bank_irq;
+               chips[0].gpio_unbanked = pdata->gpio_unbanked;
                 binten = BIT(0);

                 /* AINTC handles mask/unmask; GPIO handles triggering */
diff --git a/include/linux/platform_data/gpio-davinci.h 
b/include/linux/platform_data/gpio-davinci.h
index 6efd202..711a002 100644
--- a/include/linux/platform_data/gpio-davinci.h
+++ b/include/linux/platform_data/gpio-davinci.h
@@ -42,7 +42,6 @@ struct davinci_gpio_controller {
         void __iomem            *clr_data;
         void __iomem            *in_data;
         int                     gpio_unbanked;
-       unsigned                gpio_irq;
  };

==================================================================
Also all places where davinci_gpio_register() is called need to be 
updated to use instead of "sizeof". Like:

diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index ef9ff1f..10334a4 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -906,8 +906,8 @@ static struct davinci_gpio_platform_data 
dm355_gpio_platform_data = {
  int __init dm355_gpio_register(void)
  {
         return davinci_gpio_register(dm355_gpio_resources,
-                                    sizeof(dm355_gpio_resources),
-                                    &dm355_gpio_platform_data);
+                                     ARRAY_SIZE(dm355_gpio_resources),
+                                     &dm355_gpio_platform_data);
  }


Regards,
- grygorii
