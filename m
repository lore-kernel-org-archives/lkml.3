Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbbAMJgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:36:13 -0500
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:52316 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbbAMJgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:36:08 -0500
X-ME-Helo: beldin
X-ME-Date: Tue, 13 Jan 2015 10:36:06 +0100
X-ME-IP: 109.214.23.205
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>, Felipe Balbi <balbi@ti.com>
Cc: Yunzhi Li <lyz@rock-chips.com>,
        "Dinh Nguyen \(dinguyen\@opensource.altera.com\)" 
	<dinguyen@opensource.altera.com>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb\@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "heiko\@sntech.de" <heiko@sntech.de>,
        "jwerner\@chromium.org" <jwerner@chromium.org>,
        "dianders\@chromium.org" <dianders@chromium.org>,
        "olof\@lixom.net" <olof@lixom.net>,
        "huangtao\@rock-chips.com" <huangtao@rock-chips.com>,
        "zyw\@rock-chips.com" <zyw@rock-chips.com>,
        "cf\@rock-chips.com" <cf@rock-chips.com>,
        "linux-rockchip\@lists.infradead.org" 
	<linux-rockchip@lists.infradead.org>,
        "linus.walleij\@linaro.org" <linus.walleij@linaro.org>
Subject: Re: [PATCH v7 3/5] usb: dwc2: add generic PHY framework support for dwc2 usb controler platform driver.
References: <1418396413-27937-1-git-send-email-lyz@rock-chips.com>
	<1418396972-32686-1-git-send-email-lyz@rock-chips.com>
	<A2CA0424C0A6F04399FB9E1CD98E03048450635E@US01WEMBX2.internal.synopsys.com>
	<54B14E0E.4070504@rock-chips.com>
	<A2CA0424C0A6F04399FB9E1CD98E030484506F3B@US01WEMBX2.internal.synopsys.com>
X-URL: http://belgarath.falguerolles.org/
Date: Tue, 13 Jan 2015 10:35:52 +0100
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E030484506F3B@US01WEMBX2.internal.synopsys.com>
	(Paul Zimmerman's message of "Tue, 13 Jan 2015 00:54:45 +0000")
Message-ID: <87ppajxbt3.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Zimmerman <Paul.Zimmerman@synopsys.com> writes:
> The patch below fixes it. And it seems like the right thing to me,
> since GPIOs should be optional for a generic phy, I would think. But
> my device tree foo is very weak, so I'm not sure.
>
> CCing Robert, who touched the generic phy code last. Robert, what do
> you think?
I think your patch in [1] is correct, because
"Documentation/devicetree/bindings/usb/usb-nop-xceiv.txt" states that
reset-gpios is optional, and because Felipe told me gpios for phy_generic are
optional.

Now the original code was written by Felipe, so better ask him first. The
original code was :
af9f51c55 phy-generic.c nop->gpio_reset = of_get_named_gpio_flags(node, "reset-gpios",
af9f51c55 phy-generic.c                                                 0, &flags);
af9f51c55 phy-generic.c if (nop->gpio_reset == -EPROBE_DEFER)
af9f51c55 phy-generic.c         return -EPROBE_DEFER;

Cheers.

--
Robert

[1]
> diff --git a/drivers/usb/phy/phy-generic.c b/drivers/usb/phy/phy-generic.c
> index dd05254..9a826ff 100644
> --- a/drivers/usb/phy/phy-generic.c
> +++ b/drivers/usb/phy/phy-generic.c
> @@ -218,10 +218,10 @@ int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_generic *nop,
>  			clk_rate = 0;
>  
>  		needs_vcc = of_property_read_bool(node, "vcc-supply");
> -		nop->gpiod_reset = devm_gpiod_get(dev, "reset-gpios");
> +		nop->gpiod_reset = devm_gpiod_get_optional(dev, "reset-gpios");
>  		err = PTR_ERR(nop->gpiod_reset);
>  		if (!err) {
> -			nop->gpiod_vbus = devm_gpiod_get(dev,
> +			nop->gpiod_vbus = devm_gpiod_get_optional(dev,
>  							 "vbus-detect-gpio");
>  			err = PTR_ERR(nop->gpiod_vbus);
>  		}
