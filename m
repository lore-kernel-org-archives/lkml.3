Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab3FNHSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 03:18:24 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:41981 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751514Ab3FNHSW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 03:18:22 -0400
From: Patrice CHOTARD <patrice.chotard@st.com>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Date: Fri, 14 Jun 2013 09:17:53 +0200
Subject: Re: [PATCH 1/2] Add pin list based GPIO ranges
Thread-Topic: [PATCH 1/2] Add pin list based GPIO ranges
Thread-Index: Ac5oz0kRbVq3uel0SECN8BMKgqLGdA==
Message-ID: <51BAC3A1.80105@st.com>
References: <CACRpkdY9F0cUaRfGJnHJW=2dYf_yKkr3M8Kh+_e6XQhh1WBoUA@mail.gmail.com>
 <1371128132-18266-1-git-send-email-christian.ruppert@abilis.com>
In-Reply-To: <1371128132-18266-1-git-send-email-christian.ruppert@abilis.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
acceptlanguage: fr-FR, en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2013 02:55 PM, Christian Ruppert wrote:

> Traditionally, GPIO ranges are based on consecutive ranges of both GPIO
> and pin numbers. This patch allows for GPIO ranges with arbitrary lists
> of pin numbers.
> 
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> ---
>  drivers/pinctrl/core.c          |   59 ++++++++++++++++++++++++++++++++------
>  include/linux/pinctrl/pinctrl.h |    4 ++-
>  2 files changed, 52 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> index 5327f35..25bb17e 100644
> --- a/drivers/pinctrl/core.c
> +++ b/drivers/pinctrl/core.c
> @@ -280,6 +280,29 @@ static int pinctrl_register_pins(struct pinctrl_dev *pctldev,
>  }
>  
>  /**
> + * gpio_to_pin() - GPIO range GPIO number to pin number translation
> + * @range: GPIO range used for the translation
> + * @gpio: gpio pin to translate to a pin number
> + *
> + * Finds the pin number for a given GPIO using the specified GPIO range
> + * as a base for translation. The distinction between linear GPIO ranges
> + * and pin list based GPIO ranges is managed correctly by this function.
> + *
> + * This function assumes the gpio is part of the specified GPIO range, use
> + * only after making sure this is the case (e.g. by calling it on the
> + * result of successful pinctrl_get_device_gpio_range calls)!
> + */
> +static inline int gpio_to_pin(struct pinctrl_gpio_range *range,
> +				unsigned int gpio)
> +{
> +	unsigned int offset = gpio - range->base;
> +	if (range->pins)
> +		return range->pins[offset];
> +	else
> +		return range->pin_base + offset;
> +}
> +
> +/**
>   * pinctrl_match_gpio_range() - check if a certain GPIO pin is in range
>   * @pctldev: pin controller device to check
>   * @gpio: gpio pin to check taken from the global GPIO pin space
> @@ -444,8 +467,14 @@ pinctrl_find_gpio_range_from_pin(struct pinctrl_dev *pctldev,
>  	/* Loop over the ranges */
>  	list_for_each_entry(range, &pctldev->gpio_ranges, node) {
>  		/* Check if we're in the valid range */
> -		if (pin >= range->pin_base &&
> -		    pin < range->pin_base + range->npins) {
> +		if (range->pins) {
> +			int a;
> +			for (a = 0; a < range->npins; a++) {
> +				if (range->pins[a] == pin)
> +					return range;
> +			}
> +		} else if (pin >= range->pin_base &&
> +			   pin < range->pin_base + range->npins) {
>  			mutex_unlock(&pctldev->mutex);
>  			return range;
>  		}
> @@ -528,7 +557,7 @@ int pinctrl_request_gpio(unsigned gpio)
>  	}
>  
>  	/* Convert to the pin controllers number space */
> -	pin = gpio - range->base + range->pin_base;
> +	pin = gpio_to_pin(range, gpio);
>  
>  	ret = pinmux_request_gpio(pctldev, range, pin, gpio);
>  
> @@ -562,7 +591,7 @@ void pinctrl_free_gpio(unsigned gpio)
>  	mutex_lock(&pctldev->mutex);
>  
>  	/* Convert to the pin controllers number space */
> -	pin = gpio - range->base + range->pin_base;
> +	pin = gpio_to_pin(range, gpio);
>  
>  	pinmux_free_gpio(pctldev, pin, range);
>  
> @@ -589,7 +618,7 @@ static int pinctrl_gpio_direction(unsigned gpio, bool input)
>  	mutex_lock(&pctldev->mutex);
>  
>  	/* Convert to the pin controllers number space */
> -	pin = gpio - range->base + range->pin_base;
> +	pin = gpio_to_pin(range, gpio);
>  	ret = pinmux_gpio_direction(pctldev, range, pin, input);
>  
>  	mutex_unlock(&pctldev->mutex);
> @@ -1296,11 +1325,21 @@ static int pinctrl_gpioranges_show(struct seq_file *s, void *what)
>  
>  	/* Loop over the ranges */
>  	list_for_each_entry(range, &pctldev->gpio_ranges, node) {
> -		seq_printf(s, "%u: %s GPIOS [%u - %u] PINS [%u - %u]\n",
> -			   range->id, range->name,
> -			   range->base, (range->base + range->npins - 1),
> -			   range->pin_base,
> -			   (range->pin_base + range->npins - 1));
> +		if (range->pins) {
> +			int a;
> +			seq_printf(s, "%u: %s GPIOS [%u - %u] PINS {",
> +				range->id, range->name,
> +				range->base, (range->base + range->npins - 1));
> +			for (a = 0; a < range->npins - 1; a++)
> +				seq_printf(s, "%u, ", range->pins[a]);
> +			seq_printf(s, "%u}\n", range->pins[a]);
> +		}
> +		else
> +			seq_printf(s, "%u: %s GPIOS [%u - %u] PINS [%u - %u]\n",
> +				range->id, range->name,
> +				range->base, (range->base + range->npins - 1),
> +				range->pin_base,
> +				(range->pin_base + range->npins - 1));
>  	}
>  
>  	mutex_unlock(&pctldev->mutex);
> diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
> index 2c2a9e8..176a6c1 100644
> --- a/include/linux/pinctrl/pinctrl.h
> +++ b/include/linux/pinctrl/pinctrl.h
> @@ -49,7 +49,8 @@ struct pinctrl_pin_desc {
>   * @name: a name for the chip in this range
>   * @id: an ID number for the chip in this range
>   * @base: base offset of the GPIO range
> - * @pin_base: base pin number of the GPIO range
> + * @pin_base: base pin number of the GPIO range if pins != NULL



Hi Christian,

It seems that your comment is not correct, it should be :
* @pin_base: base pin number of the GPIO range if pins == NULL

Patrice

> + * @pins: enumeration of pins in GPIO range or NULL
>   * @npins: number of pins in the GPIO range, including the base number
>   * @gc: an optional pointer to a gpio_chip
>   */
> @@ -59,6 +60,7 @@ struct pinctrl_gpio_range {
>  	unsigned int id;
>  	unsigned int base;
>  	unsigned int pin_base;
> +	unsigned const *pins;
>  	unsigned int npins;
>  	struct gpio_chip *gc;
>  };



