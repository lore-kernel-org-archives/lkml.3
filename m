Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab3KFXJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 18:09:36 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:45422 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab3KFXJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 18:09:33 -0500
MIME-Version: 1.0
In-Reply-To: <1383778182-16941-2-git-send-email-delicious.quinoa@gmail.com>
References: <1383778182-16941-1-git-send-email-delicious.quinoa@gmail.com>
	<1383778182-16941-2-git-send-email-delicious.quinoa@gmail.com>
Date: Wed, 6 Nov 2013 21:09:32 -0200
Message-ID: <CAOMZO5BarpUGOExmDR8c2e0YOL41MmNkMii2ZU+jKrmEVtcmig@mail.gmail.com>
Subject: Re: [PATCH 1/1] gpio: add a driver for the Synopsys DesignWare APB
 GPIO block
From: Fabio Estevam <festevam@gmail.com>
To: Alan Tull <delicious.quinoa@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-gpio@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Heiko Stuebner <heiko@sntech.de>,
        Alan Tull <atull@altera.com>, Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 6, 2013 at 8:49 PM, Alan Tull <delicious.quinoa@gmail.com> wrote:

> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       gpio->regs = devm_ioremap_resource(&pdev->dev, res);
> +       if (!gpio->regs) {
> +               err = -ENOMEM;
> +               goto out_free_ports;

The correct way to handle the error here would be:

if (IS_ERR(gpio->regs) {
     err = PTR_ERR(gpio->regs)
     goto out_free_ports;


> +out_unregister:
> +       dwapb_gpio_unregister(gpio);
> +
> +       if (gpio->domain) {
> +               irq_dispose_mapping(gpio->hwirq);
> +               irq_domain_remove(gpio->domain);
> +       }
> +
> +out_free_ports:
> +       devm_kfree(&pdev->dev, gpio->ports);

No need to call devm_kfree

> +
> +out_err:
> +       devm_kfree(&pdev->dev, gpio);

Same here.

> +       return err;
> +}
> +
> +static int dwapb_gpio_remove(struct platform_device *pdev)
> +{
> +       struct dwapb_gpio *gpio = platform_get_drvdata(pdev);
> +
> +       dwapb_gpio_unregister(gpio);
> +       if (gpio->domain) {
> +               irq_dispose_mapping(gpio->hwirq);
> +               irq_domain_remove(gpio->domain);
> +       }
> +       devm_kfree(&pdev->dev, gpio->ports);
> +       devm_kfree(&pdev->dev, gpio);

No need to call devm_kfree

Regards,

Fabio Estevam
