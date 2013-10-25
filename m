Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab3JYMpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 08:45:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57319 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853Ab3JYMpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 08:45:34 -0400
Message-ID: <526A680A.8090308@ti.com>
Date: Fri, 25 Oct 2013 15:46:02 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCHv6 1/3] Input: twl4030-pwrbutton - add device tree support
References: <1382626126-12565-1-git-send-email-sre@debian.org> <1382626126-12565-2-git-send-email-sre@debian.org>
In-Reply-To: <1382626126-12565-2-git-send-email-sre@debian.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2013 05:48 PM, Sebastian Reichel wrote:
> Add device tree support for twl4030 power button driver.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> ---
>  .../devicetree/bindings/input/twl4030-pwrbutton.txt | 21 +++++++++++++++++++++
>  drivers/input/misc/twl4030-pwrbutton.c              | 16 ++++++++++++----
>  2 files changed, 33 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/input/twl4030-pwrbutton.txt
> 
> diff --git a/Documentation/devicetree/bindings/input/twl4030-pwrbutton.txt b/Documentation/devicetree/bindings/input/twl4030-pwrbutton.txt
> new file mode 100644
> index 0000000..4375646
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/twl4030-pwrbutton.txt
> @@ -0,0 +1,21 @@
> +Texas Instruments TWL family (twl4030) pwrbutton module
> +
> +This module is part of the TWL4030. For more details about the whole
> +chip see Documentation/devicetree/bindings/mfd/twl-familly.txt.
> +
> +This module provides a simple power button event via an Interrupt.
> +
> +Required properties:
> +- compatible: should be one of the following
> +   - "ti,twl4030-pwrbutton": For controllers compatible with twl4030
> +- interrupt: should be one of the following
> +   - <8>: For controllers compatible with twl4030
> +
> +Example:
> +
> +&twl {
> +	twl_pwrbutton: pwrbutton {
> +		compatible = "ti,twl4030-pwrbutton";
> +		interrupts = <8>;
> +	};
> +};
> diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/twl4030-pwrbutton.c
> index b9a05fd..a3a0fe3 100644
> --- a/drivers/input/misc/twl4030-pwrbutton.c
> +++ b/drivers/input/misc/twl4030-pwrbutton.c
> @@ -52,7 +52,7 @@ static irqreturn_t powerbutton_irq(int irq, void *_pwr)
>  	return IRQ_HANDLED;
>  }
>  
> -static int __init twl4030_pwrbutton_probe(struct platform_device *pdev)
> +static int twl4030_pwrbutton_probe(struct platform_device *pdev)
>  {
>  	struct input_dev *pwr;
>  	int irq = platform_get_irq(pdev, 0);
> @@ -106,16 +106,24 @@ static int __exit twl4030_pwrbutton_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +#if IS_ENABLED(CONFIG_OF)

You don't need to do this.

> +static const struct of_device_id twl4030_pwrbutton_dt_match_table[] = {
> +       { .compatible = "ti,twl4030-pwrbutton" },
> +       {},
> +};
> +MODULE_DEVICE_TABLE(of, twl4030_pwrbutton_dt_match_table);
> +#endif
> +
>  static struct platform_driver twl4030_pwrbutton_driver = {
> +	.probe		= twl4030_pwrbutton_probe,
>  	.remove		= __exit_p(twl4030_pwrbutton_remove),
>  	.driver		= {
>  		.name	= "twl4030_pwrbutton",
>  		.owner	= THIS_MODULE,
> +		.of_match_table = of_match_ptr(twl4030_pwrbutton_dt_match_table),

If you try to compile this driver with config !CONFIG_OF it will not work in
this way.

>  	},
>  };
> -
> -module_platform_driver_probe(twl4030_pwrbutton_driver,
> -			twl4030_pwrbutton_probe);
> +module_platform_driver(twl4030_pwrbutton_driver);
>  
>  MODULE_ALIAS("platform:twl4030_pwrbutton");
>  MODULE_DESCRIPTION("Triton2 Power Button");
> 


-- 
Péter
