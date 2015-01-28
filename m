Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbbA1Doc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 22:44:32 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:43210 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996AbbA1Doa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 22:44:30 -0500
MIME-Version: 1.0
In-Reply-To: <1422412229-23640-1-git-send-email-chao.xie@marvell.com>
References: <1422412229-23640-1-git-send-email-chao.xie@marvell.com>
Date: Wed, 28 Jan 2015 09:14:29 +0530
Message-ID: <CAEUmHyaNEO_kZ1+m2JKbWEwMvujkkQRdQqKwbZyad_8eqWvM8Q@mail.gmail.com>
Subject: Re: [PATCH] gpio: mmp: add GPIO driver for Marvell MMP series
From: Varka Bhadram <varkabhadram@gmail.com>
To: Chao Xie <chao.xie@marvell.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xiechao_mail@163.com, haojian.zhuang@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 8:00 AM, Chao Xie <chao.xie@marvell.com> wrote:
> From: Chao Xie <chao.xie@marvell.com>
>
> For some old PXA series, they used PXA GPIO driver.
> The IP of GPIO changes since PXA988 which is Marvell MMP
> series.
> It will use new way to control the GPIO level, direction
> and edge status.
>
> Signed-off-by: Chao Xie <chao.xie@marvell.com>
> ---
>  drivers/gpio/Kconfig    |   7 +
>  drivers/gpio/Makefile   |   1 +
>  drivers/gpio/gpio-mmp.c | 444 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 452 insertions(+)
>  create mode 100644 drivers/gpio/gpio-mmp.c

(...)

> +static int mmp_gpio_probe(struct platform_device *pdev)
> +{
> +       struct device *dev = &pdev->dev;
> +       struct mmp_gpio_platform_data *pdata;
> +       struct device_node *np;
> +       struct mmp_gpio_chip *mmp_chip;
> +       struct mmp_gpio_bank *bank;
> +       struct resource *res;
> +       struct irq_domain *domain;
> +       struct clk *clk;
> +       int irq, i, ret;
> +       void __iomem *base;
> +
> +       pdata = dev_get_platdata(dev);
> +       np = pdev->dev.of_node;
> +       if (!np && !pdata)
> +               return -EINVAL;
> +
> +       mmp_chip = devm_kzalloc(dev, sizeof(*mmp_chip), GFP_KERNEL);
> +       if (mmp_chip == NULL)
> +               return -ENOMEM;
> +

Using ! operator preffred instead of comparing with NULL.

> +       irq = platform_get_irq(pdev, 0);
> +       if (irq < 0)
> +               return irq;
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!res)
> +               return -EINVAL;

This check is not required.. Check on resource happenning with
devm_ioremap_resource.

> +       base = devm_ioremap_resource(dev, res);
> +       if (!base)
> +               return -EINVAL;

I dont think this the correct return value.. return PTR_ERR(base)

> +
> +       mmp_chip->irq = irq;
> +       mmp_chip->reg_base = base;
> +
> +       if (pdata)
> +               ret = mmp_gpio_probe_pdata(pdev, mmp_chip, pdata);
> +       else
> +               ret = mmp_gpio_probe_dt(pdev, mmp_chip);
> +
> +       if (ret) {
> +               dev_err(dev, "Fail to initialize gpio unit, error %d.\n", ret);
> +               return ret;
> +       }
> +
> +       clk = devm_clk_get(dev, NULL);
> +       if (IS_ERR(clk)) {
> +               dev_err(dev, "Fail to get gpio clock, error %ld.\n",
> +                       PTR_ERR(clk));
> +               return PTR_ERR(clk);
> +       }
> +       ret = clk_prepare_enable(clk);
> +       if (ret) {
> +               dev_err(dev, "Fail to enable gpio clock, error %d.\n", ret);
> +               return ret;
> +       }
> +
> +       domain = irq_domain_add_linear(np, mmp_chip->ngpio,
> +                                       &mmp_gpio_irq_domain_ops, mmp_chip);
> +       if (domain == NULL)

Using ! operator preferred instead of comparing with NULL.




-- 
Thanks and Regards,
Varka Bhadram.
