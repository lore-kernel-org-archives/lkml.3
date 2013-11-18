Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab3KRLze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 06:55:34 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48972 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751171Ab3KRLz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 06:55:29 -0500
Date: Mon, 18 Nov 2013 11:55:12 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: NeilBrown <neilb@suse.de>
Cc: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/2] LEDS: tca6502: add device-tree support for GPIO
 configuration.
Message-ID: <20131118115512.GF30853@e106331-lin.cambridge.arm.com>
References: <20131101134120.13a44225@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101134120.13a44225@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 02:41:20AM +0000, NeilBrown wrote:
> 
> The 7 lines driven by the TCA6507 can either drive LEDs or act as output-only
> GPIOs.
> 
> To make this distinction in devicetree we use the "compatible" property.
> 
> If the device attached to a line is "compatible" with "gpio", we treat it
> like a GPIO.  If it is "compatible" with "led" (or if no "compatible" value
> is set) we treat it like an LED.

I'm nto sure I understand the purpose of this.

Are these lines all GPIOs, some of which happen to by attached to LEDs?

If so, why is handlnig the device as a gpio-controller and using the
gpio-leds binding not sufficient?

THanksm
Mark.

> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> 
> diff --git a/Documentation/devicetree/bindings/leds/tca6507.txt b/Documentation/devicetree/bindings/leds/tca6507.txt
> index 80ff3dfb1f32..d7221b84987c 100644
> --- a/Documentation/devicetree/bindings/leds/tca6507.txt
> +++ b/Documentation/devicetree/bindings/leds/tca6507.txt
> @@ -2,6 +2,13 @@ LEDs connected to tca6507
>  
>  Required properties:
>  - compatible : should be : "ti,tca6507".
> +- #address-cells: must be 1
> +- #size-cells: must be 0
> +- reg: typically 0x45.
> +
> +Optional properties:
> +- gpio-controller: allows lines to be used as output-only GPIOs.
> +- #gpio-cells: if present, must be 0.
>  
>  Each led is represented as a sub-node of the ti,tca6507 device.
>  
> @@ -10,6 +17,7 @@ LED sub-node properties:
>  - reg : number of LED line (could be from 0 to 6)
>  - linux,default-trigger : (optional)
>     see Documentation/devicetree/bindings/leds/common.txt
> +- compatible: either "led" (the default) or "gpio".
>  
>  Examples:
>  
> @@ -19,6 +27,9 @@ tca6507@45 {
>  	#size-cells = <0>;
>  	reg = <0x45>;
>  
> +	gpio-controller;
> +	#gpio-cells = <2>;
> +
>  	led0: red-aux@0 {
>  		label = "red:aux";
>  		reg = <0x0>;
> @@ -29,5 +40,10 @@ tca6507@45 {
>  		reg = <0x5>;
>  		linux,default-trigger = "default-on";
>  	};
> +
> +	wifi-reset@6 {
> +		reg = <0x6>;
> +		compatible = "gpio";
> +	};
>  };
>  
> diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
> index f5063f447463..93a2b1759054 100644
> --- a/drivers/leds/leds-tca6507.c
> +++ b/drivers/leds/leds-tca6507.c
> @@ -638,6 +638,9 @@ static int tca6507_probe_gpios(struct i2c_client *client,
>  	tca->gpio.direction_output = tca6507_gpio_direction_output;
>  	tca->gpio.set = tca6507_gpio_set_value;
>  	tca->gpio.dev = &client->dev;
> +#ifdef CONFIG_OF_GPIO
> +	tca->gpio.of_node = of_node_get(client->dev.of_node);
> +#endif
>  	err = gpiochip_add(&tca->gpio);
>  	if (err) {
>  		tca->gpio.ngpio = 0;
> @@ -696,6 +699,8 @@ tca6507_led_dt_init(struct i2c_client *client)
>  		led.default_trigger =
>  			of_get_property(child, "linux,default-trigger", NULL);
>  		led.flags = 0;
> +		if (of_property_match_string(child, "compatible", "gpio") >= 0)
> +			led.flags |= TCA6507_MAKE_GPIO;
>  		ret = of_property_read_u32(child, "reg", &reg);
>  		if (ret != 0 || reg < 0 || reg >= NUM_LEDS)
>  			continue;
> @@ -709,6 +714,7 @@ tca6507_led_dt_init(struct i2c_client *client)
>  
>  	pdata->leds.leds = tca_leds;
>  	pdata->leds.num_leds = NUM_LEDS;
> +	pdata->gpio_base = -1;
>  
>  	return pdata;
>  }


