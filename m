Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbaCEBth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:49:37 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:65366 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649AbaCEBtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:49:25 -0500
MIME-Version: 1.0
In-Reply-To: <1393378800-7220-1-git-send-email-acourbot@nvidia.com>
References: <1393378800-7220-1-git-send-email-acourbot@nvidia.com>
Date: Wed, 5 Mar 2014 09:49:24 +0800
Message-ID: <CACRpkdY-oBdxxWhsGraEU31qyu+RWJAiRA+KEip6QNW3jRwGUA@mail.gmail.com>
Subject: Re: [PATCH] gpio: clamp returned values to the boolean range
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 9:40 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Nothing prevents GPIO drivers from returning values outside the
> boolean range, and as it turns out a few drivers are actually doing so.
> These values were passed as-is to unsuspecting consumers and created
> confusion.
>
> This patch makes the internal _gpiod_get_raw_value() function return a
> bool, effectively clamping the GPIO value to the boolean range no
> matter what the driver does.

No, that will not be the semantic effect of this patch, bool is just
another name for an int, maybe some static checkers will be able
to use it however.

If you really want the desired semantic effect, do this:

static int _gpiod_get_raw_value(const struct gpio_desc *desc)
{
        struct gpio_chip        *chip;
-        int value;
+       bool value;
        int offset;

        chip = desc->chip;
        offset = gpio_chip_hwgpio(desc);
-        value = chip->get ? chip->get(chip, offset) : 0;
+        value = chip->get ? !!(chip->get(chip, offset)) : false;
        trace_gpio_value(desc_to_gpio(desc), 1, value);
        return value;
}

Can you please update the patch accordingly, maybe also the
commit message.

Yours,
Linus Walleij
