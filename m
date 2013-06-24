Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab3FXOgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 10:36:32 -0400
Received: from 10.mo5.mail-out.ovh.net ([46.105.52.148]:56459 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750936Ab3FXOga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 10:36:30 -0400
Date: Mon, 24 Jun 2013 16:26:45 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: linux-fbdev@vger.kernel.org, jimwall@q.com, brian@crystalfontz.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH 1/2] fb: backlight: HX8357: Make IM pins optionnal
Message-ID: <20130624142645.GG305@game.jcrosoft.org>
References: <1371839259-543-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371839259-543-1-git-send-email-alexandre.belloni@free-electrons.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 6341631226039217043
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrkeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrkeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20:27 Fri 21 Jun     , Alexandre Belloni wrote:
> From: Maxime Ripard <maxime.ripard@free-electrons.com>
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/video/backlight/hx8357.c | 53 +++++++++++++++++++++++-----------------
>  1 file changed, 31 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/video/backlight/hx8357.c b/drivers/video/backlight/hx8357.c
> index a0482b5..69f5672 100644
> --- a/drivers/video/backlight/hx8357.c
> +++ b/drivers/video/backlight/hx8357.c
> @@ -76,6 +76,7 @@ struct hx8357_data {
>  	unsigned		reset;
>  	struct spi_device	*spi;
>  	int			state;
> +	u8			use_im_pins;
boolean please
>  };
>  
>  static u8 hx8357_seq_power[] = {
> @@ -250,9 +251,11 @@ static int hx8357_lcd_init(struct lcd_device *lcdev)
>  	 * Set the interface selection pins to SPI mode, with three
>  	 * wires
>  	 */
> -	gpio_set_value_cansleep(lcd->im_pins[0], 1);
> -	gpio_set_value_cansleep(lcd->im_pins[1], 0);
> -	gpio_set_value_cansleep(lcd->im_pins[2], 1);
> +	if (lcd->use_im_pins) {
> +		gpio_set_value_cansleep(lcd->im_pins[0], 1);
> +		gpio_set_value_cansleep(lcd->im_pins[1], 0);
> +		gpio_set_value_cansleep(lcd->im_pins[2], 1);
> +	}

base on the dt probe you may have gpios betwee 0 to HX8357_NUM_IM_PINS

so this look wrong
>  
>  	/* Reset the screen */
>  	gpio_set_value(lcd->reset, 1);
> @@ -424,26 +427,32 @@ static int hx8357_probe(struct spi_device *spi)
>  		return -EINVAL;
>  	}
>  
> -	for (i = 0; i < HX8357_NUM_IM_PINS; i++) {
> -		lcd->im_pins[i] = of_get_named_gpio(spi->dev.of_node,
> -						"im-gpios", i);
> -		if (lcd->im_pins[i] == -EPROBE_DEFER) {
> -			dev_info(&spi->dev, "GPIO requested is not here yet, deferring the probe\n");
> -			return -EPROBE_DEFER;
> -		}
> -		if (!gpio_is_valid(lcd->im_pins[i])) {
> -			dev_err(&spi->dev, "Missing dt property: im-gpios\n");
> -			return -EINVAL;
> +	if (of_find_property(spi->dev.of_node, "im-gpios", NULL)) {
> +		lcd->use_im_pins = 1;
> +
> +		for (i = 0; i < HX8357_NUM_IM_PINS; i++) {
> +			lcd->im_pins[i] = of_get_named_gpio(spi->dev.of_node,
> +							    "im-gpios", i);
> +			if (lcd->im_pins[i] == -EPROBE_DEFER) {
> +				dev_info(&spi->dev, "GPIO requested is not here yet, deferring the probe\n");
> +				return -EPROBE_DEFER;
> +			}
> +			if (!gpio_is_valid(lcd->im_pins[i])) {
> +				dev_err(&spi->dev, "Missing dt property: im-gpios\n");
> +				return -EINVAL;
> +			}
> +
> +			ret = devm_gpio_request_one(&spi->dev, lcd->im_pins[i],
> +						    GPIOF_OUT_INIT_LOW,
> +						    "im_pins");
> +			if (ret) {
> +				dev_err(&spi->dev, "failed to request gpio %d: %d\n",
> +					lcd->im_pins[i], ret);
> +				return -EINVAL;
> +			}
>  		}
> -
> -		ret = devm_gpio_request_one(&spi->dev, lcd->im_pins[i],
> -					GPIOF_OUT_INIT_LOW, "im_pins");
> -		if (ret) {
> -			dev_err(&spi->dev, "failed to request gpio %d: %d\n",
> -				lcd->im_pins[i], ret);
> -			return -EINVAL;
> -		}
> -	}
> +	} else
> +		lcd->use_im_pins = 0;
>  
>  	lcdev = lcd_device_register("mxsfb", &spi->dev, lcd, &hx8357_ops);
>  	if (IS_ERR(lcdev)) {
> -- 
> 1.8.1.2
> 
