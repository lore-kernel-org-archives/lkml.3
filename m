Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941Ab3KMLu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 06:50:27 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61401 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754386Ab3KMLuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 06:50:24 -0500
Date: Wed, 13 Nov 2013 11:50:18 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 1/4] mfd: max14577: Add max14577 MFD driver core
Message-ID: <20131113115018.GE21713@e106331-lin.cambridge.arm.com>
References: <1384328457-5147-1-git-send-email-k.kozlowski@samsung.com>
 <1384328457-5147-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384328457-5147-2-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 07:40:54AM +0000, Krzysztof Kozlowski wrote:
> From: Chanwoo Choi <cw00.choi@samsung.com>
> 
> This patch adds max14577 core/irq driver to support MUIC(Micro USB IC)
> device and charger device and support irq domain method to control
> internal interrupt of max14577 device. Also, this patch supports DT
> binding with max14577_i2c_parse_dt().
> 
> The MAXIM 14577 chip contains Micro-USB Interface Circuit and Li+ Battery
> Charger. It contains accessory and USB charger detection logic. It supports
> USB 2.0 Hi-Speed, UART and stereo audio signals over Micro-USB connector.
> 
> The battery charger is compliant with the USB Battery Charging Specification
> Revision 1.1. It has also SFOUT LDO output for powering USB devices.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/mfd/Kconfig                  |   13 ++
>  drivers/mfd/Makefile                 |    1 +
>  drivers/mfd/max14577-irq.c           |  283 +++++++++++++++++++++++++++++++++
>  drivers/mfd/max14577.c               |  268 +++++++++++++++++++++++++++++++
>  include/linux/mfd/max14577-private.h |  291 ++++++++++++++++++++++++++++++++++
>  include/linux/mfd/max14577.h         |   76 +++++++++
>  6 files changed, 932 insertions(+)
>  create mode 100644 drivers/mfd/max14577-irq.c
>  create mode 100644 drivers/mfd/max14577.c
>  create mode 100644 include/linux/mfd/max14577-private.h
>  create mode 100644 include/linux/mfd/max14577.h

I see some of_* calls in the code, but no documentation of the binding.
As this has more than just a compatible, interrupts, and reg, it needs
its own binding document.

[...]

> +static struct mfd_cell max14577_devs[] = {
> +       { .name = "max14577-muic",
> +               .of_compatible = "maxim,max14577-muic", },

The compatible string looks fine to me, but should be documented.

[...]

> +#ifdef CONFIG_OF
> +static struct max14577_platform_data *max14577_i2c_parse_dt(struct device *dev)
> +{
> +       struct max14577_platform_data *pdata;
> +       struct device_node *np = dev->of_node;
> +
> +       pdata = devm_kzalloc(dev, sizeof(struct max14577_platform_data),
> +                            GFP_KERNEL);
> +       if (!pdata)
> +               return ERR_PTR(-ENOMEM);
> +
> +       pdata->irq_gpio = of_get_named_gpio(np, "irq_gpio", 0);

In general, '-' is preferred to '_' in property names. This should be
irq-gpio.

What exactly is this used for? I know that others have strong opinions
about how gpio/irq interaction should be handled.

> +       if (!gpio_is_valid(pdata->irq_gpio)) {
> +               dev_err(dev, "Invalid irq_gpio in DT\n");
> +               return ERR_PTR(-EINVAL);
> +       }
> +
> +       if (of_property_read_bool(np, "wakeup"))
> +               pdata->wakeup = true;

What does this mean? It seems like a remarkably generic name for
something that I'd guess is _very_ specific to this particular binding.

It might be worth prefixing it, and is certainly worth having a more
precise name.

Thanks,
Mark.
