Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab3JXHyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:54:19 -0400
Received: from smtp0.epfl.ch ([128.178.224.218]:58930 "EHLO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711Ab3JXHyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:54:17 -0400
Message-ID: <5268D095.3060302@epfl.ch>
Date: Thu, 24 Oct 2013 09:47:33 +0200
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv4 1/3] Input: twl4030-pwrbutton - add device tree support
References: <1382550852-11508-1-git-send-email-sre@debian.org> <1382550852-11508-2-git-send-email-sre@debian.org>
In-Reply-To: <1382550852-11508-2-git-send-email-sre@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sebastian,

On 10/23/2013 07:54 PM, Sebastian Reichel wrote:
> Add device tree support for twl4030 power button driver.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> ---
>  .../devicetree/bindings/input/twl4030-pwrbutton.txt      | 13 +++++++++++++
>  drivers/input/misc/twl4030-pwrbutton.c                   | 16 ++++++++++++----
>  2 files changed, 25 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/input/twl4030-pwrbutton.txt
> 
> diff --git a/Documentation/devicetree/bindings/input/twl4030-pwrbutton.txt b/Documentation/devicetree/bindings/input/twl4030-pwrbutton.txt
> new file mode 100644
> index 0000000..945ec74
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/twl4030-pwrbutton.txt
> @@ -0,0 +1,13 @@
> +* TWL4030's pwrbutton device tree bindings
> +
> +Required SoC Specific Properties:
> +- compatible: should be one of the following
> +   - "ti,twl4030-pwrbutton": For controllers compatible with twl4030
> +- interrupt: should be one of the following
> +   - <8>: For controllers compatible with twl4030

This is <8> for your particular case, but it will depend on your SoC,
won't it?
Moreover, this property will be most likely inherited from the root twl
node,
so I do not see the need to document it here. See:

Documentation/devicetree/bindings/mfd/twl-familly.txt

> +
> +Example:
> +	twl_pwrbutton: pwrbutton {
> +		compatible = "ti,twl4030-pwrbutton";
> +		interrupts = <8>;
> +	};

You are missing the root twl node here, no?

> diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/twl4030-pwrbutton.c
> index b9a05fd..a3a0fe3 100644
> --- a/drivers/input/misc/twl4030-pwrbutton.c
> +++ b/drivers/input/misc/twl4030-pwrbutton.c

Missing #include <linux/of.h> ?

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

Best regards,

Florian
