Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab3BSCHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 21:07:12 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:64664 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954Ab3BSCHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 21:07:11 -0500
MIME-Version: 1.0
X-Originating-IP: [114.39.104.37]
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F792729F9@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F792729F9@DQHE02.ent.ti.com>
Date: Tue, 19 Feb 2013 10:07:10 +0800
Message-ID: <CAFRkauA60-LgBuPmMuW34cHFcBuH8AZpj3VtKyNabMSVdwYoiA@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] regulator: core: manage enable GPIO list
From: Axel Lin <axel.lin@ingics.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/**
> + * Balance enable_count of each GPIO and actual GPIO pin control.
> + * GPIO is enabled in case of initial use. (enable_count is 0)
> + * GPIO is disabled when it is not shared any more. (enable_count <= 1)
I think you mean "GPIO is disabled when it is not used any more."
"It is not shared" sounds like it can has one user.

> + */
> +static int regulator_ena_gpio_ctrl(struct regulator_dev *rdev, bool enable)
> +{
> +       struct regulator_enable_gpio *pin = rdev->ena_pin;
> +
> +       if (!pin)
> +               return -EINVAL;
> +
> +       if (enable) {
> +               /* Enable GPIO at initial use */
> +               if (pin->enable_count == 0)
> +                       gpio_set_value_cansleep(pin->gpio,
> +                                               !pin->ena_gpio_invert);
> +
> +               pin->enable_count++;
> +       } else {
> +               if (pin->enable_count > 1) {
> +                       pin->enable_count--;
> +                       return 0;
> +               }
> +
> +               /* Disable GPIO if not used */
> +               if (pin->enable_count <= 1) {
> +                       gpio_set_value_cansleep(pin->gpio,
> +                                               pin->ena_gpio_invert);
> +                       pin->enable_count = 0;
> +               }
How about:

/* No action to disable if enable_count is already 0 */
if (pin->enable_count == 0)
        return 0;

/* Disable GPIO if not used */
if (--pin->enable_count == 0)
        gpio_set_value_cansleep(pin->gpio, pin->ena_gpio_invert);
