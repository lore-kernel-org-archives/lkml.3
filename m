Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966365Ab3E2T3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 15:29:51 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:54223 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965341Ab3E2T3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 15:29:44 -0400
MIME-Version: 1.0
In-Reply-To: <1369814513-24967-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1369814513-24967-1-git-send-email-mathias.nyman@linux.intel.com>
Date: Wed, 29 May 2013 22:29:42 +0300
Message-ID: <CAHp75VfFs=VLJ2-Y+s4is9r9vG=kZb263MPzbO82g9YM+HgKBQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: add Intel BayTrail gpio driver
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Linus <linus.walleij@linaro.org>, Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 11:01 AM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:
> Add support for gpio on Intel BayTrail platforms. BayTrail supports 3 banks
> of gpios called SCORE, NCORE ans SUS with 102, 28 and 43 gpio pins.
> Supports gpio interrupts
>
> Pins may be muxed to alternate function instead of gpio by firmware.
> This driver does not touch the pin muxing and expect firmare
> to set pin muxing and pullup/down properties properly.

Few comments below (it looks like you sent previous version of patch
than that we discussed early)

> --- /dev/null
> +++ b/drivers/gpio/gpio-baytrail.c
> @@ -0,0 +1,539 @@

> +static int byt_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct byt_gpio *vg = container_of(chip, struct byt_gpio, chip);
> +       void __iomem *reg = byt_gpio_reg(chip, offset, BYT_VAL_REG);
> +       unsigned long flags;
> +       u32 value;
> +
> +       spin_lock_irqsave(&vg->lock, flags);
> +
> +       value = readl(reg) | BYT_DIR_MASK;
> +       value = value & (~BYT_INPUT_EN); /* active low */

Just value &= ~BYT_INPUT_EN;

> +static void byt_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
> +{
> +       struct byt_gpio *vg = container_of(chip, struct byt_gpio, chip);
> +       int i;
> +       unsigned long flags;
> +       u32 conf0,  val, offs;

Two spaces instead of one.

> +
> +       spin_lock_irqsave(&vg->lock, flags);
> +
> +       for (i = 0; i < vg->chip.ngpio; i++) {
> +

Seems redundant empty line.

> +               offs = vg->gpio_to_pad[i] * 16;
> +               conf0 = readl(vg->reg_base + offs + BYT_CONF0_REG);
> +               val = readl(vg->reg_base + offs + BYT_VAL_REG);
> +
> +               seq_printf(s,
> +                          " gpio-%-3d %s %s %s pad-%-3d offset:0x%03x mux:%d %s %s %s\n",
> +                          i,
> +                          val & BYT_INPUT_EN ? "  " : "in",
> +                          val & BYT_OUTPUT_EN ? "   " : "out",
> +                          val & BYT_LEVEL ? "hi" : "lo",
> +                          vg->gpio_to_pad[i], offs,
> +                          conf0 & 0x7,
> +                          conf0 & BYT_TRIG_NEG ? "fall" : "",
> +                          conf0 & BYT_TRIG_POS ? "rise" : "",
> +                          conf0 & BYT_TRIG_LVL ? "lvl " : "");
> +

Perhaps this one will go after curle brace.

> +       }
> +       spin_unlock_irqrestore(&vg->lock, flags);
> +}

> +static int byt_gpio_probe(struct platform_device *pdev)
> +{
> +       struct byt_gpio *vg;
> +       struct gpio_chip *gc;
> +       struct resource *mem_rc, *irq_rc;
> +       struct device *dev = &pdev->dev;
> +       struct acpi_device *acpi_dev;
> +       struct gpio_bank *bank;
> +       acpi_handle handle = ACPI_HANDLE(dev);
> +       unsigned hwirq;
> +       int ret;
> +

> +       mem_rc = platform_get_resource(pdev, IORESOURCE_MEM, 0);

> +       irq_rc = platform_get_resource(pdev, IORESOURCE_IRQ, 0);

Perhaps this one should go close to place where it is used

> +       if (!mem_rc) {
> +               dev_err(&pdev->dev, "missing MEM resource\n");
> +               return -EINVAL;
> +       }
> +

Just put
      mem_rc = platform_get_resource(pdev, IORESOURCE_MEM, 0);
here and remove above check.

> +       vg->reg_base = devm_ioremap_resource(dev, mem_rc);
> +

No need to have this empty line.

> +       if (IS_ERR(vg->reg_base)) {
> +               dev_err(&pdev->dev, "error mapping resource\n");

No need to have this message.

> +               return PTR_ERR(vg->reg_base);
> +       }

> +       ret = gpiochip_add(gc);
> +       if (ret) {
> +               dev_err(&pdev->dev, "failed adding byt-gpio chip\n");
> +               return ret;
> +       }
> +
> +       /* set up interrupts  */
> +       if (irq_rc && irq_rc->start) {
> +               hwirq = irq_rc->start;
> +               gc->to_irq = byt_gpio_to_irq;
> +
> +               vg->domain = irq_domain_add_linear(NULL, gc->ngpio,
> +                                                  &byt_gpio_irq_ops, vg);
> +               if (!vg->domain)

Have you to call gpiochip_remove() or something like this here?

> +                       return -ENXIO;
> +
> +               byt_gpio_irq_init_hw(vg);
> +
> +               irq_set_handler_data(hwirq, vg);
> +               irq_set_chained_handler(hwirq, byt_gpio_irq_handler);
> +       }
> +
> +       /* Register interrupt handlers for gpio signaled acpi events */
> +       acpi_gpiochip_request_interrupts(gc);
> +
> +       pm_runtime_enable(dev);
> +
> +       return 0;
> +}

> +static int byt_gpio_remove(struct platform_device *pdev)
> +{
> +       struct byt_gpio *vg = platform_get_drvdata(pdev);
> +       int err;

+ empty line here

> +       pm_runtime_disable(&pdev->dev);
> +       err = gpiochip_remove(&vg->chip);
> +       if (err)
> +               dev_warn(&pdev->dev, "failed to remove gpio_chip.\n");
> +
> +       platform_set_drvdata(pdev, NULL);

No need to set this.

--
With Best Regards,
Andy Shevchenko
