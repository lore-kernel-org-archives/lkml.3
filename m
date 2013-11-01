Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab3KAA7B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 20:59:01 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42764 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978Ab3KAA67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 20:58:59 -0400
Date: Thu, 31 Oct 2013 17:58:40 -0700
From: Mark Rutland <mark.rutland@arm.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 4/5] input: tc3589x-keypad: support probing from device
 tree
Message-ID: <20131101005840.GB8413@kartoffel>
References: <1381872071-23455-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1381872071-23455-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 10:21:11PM +0100, Linus Walleij wrote:
> Implement device tree probing for the tc3589x keypad driver.
> This is modeled on the STMPE keypad driver and tested on the
> Ux500 TVK1281618 UIB.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/input/keyboard/tc3589x-keypad.c | 63 +++++++++++++++++++++++++++++++--
>  1 file changed, 61 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/keyboard/tc3589x-keypad.c b/drivers/input/keyboard/tc3589x-keypad.c
> index 208de7c..f6ec0d7 100644
> --- a/drivers/input/keyboard/tc3589x-keypad.c
> +++ b/drivers/input/keyboard/tc3589x-keypad.c
> @@ -297,6 +297,62 @@ static void tc3589x_keypad_close(struct input_dev *input)
>  	tc3589x_keypad_disable(keypad);
>  }
>  
> +#ifdef CONFIG_OF
> +static const struct tc3589x_keypad_platform_data *
> +tc3589x_keypad_of_probe(struct device *dev)
> +{
> +	struct device_node *np = dev->of_node;
> +	struct tc3589x_keypad_platform_data *plat;
> +	u32 debounce_ms;
> +	int proplen;
> +
> +	if (!np)
> +		return ERR_PTR(-ENODEV);
> +
> +	plat = devm_kzalloc(dev, sizeof(*plat), GFP_KERNEL);
> +	if (!plat)
> +		return ERR_PTR(-ENOMEM);
> +
> +	of_property_read_u8(np, "keypad,num-columns", &plat->kcol);
> +	of_property_read_u8(np, "keypad,num-rows", &plat->krow);

These look wrong to me, as almost every single use of of_property_read_u8 (or
of_property_read_u16) do. They read _packed_ values out of the dt, and do not
read (u32) cells as u8s or u16s.

The matrix-keymap binding doesn't define these as 8-bit, and the example
binding they are u32 cells. Either the binding document or this code is wrong.

I'm confused as to how this can work. Are you using /bits/ 8 in your dts?

Thanks,
Mark.
