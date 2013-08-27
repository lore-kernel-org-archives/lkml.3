Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab3H0PDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 11:03:09 -0400
Received: from 11.mo1.mail-out.ovh.net ([188.165.48.29]:33542 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752881Ab3H0PDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 11:03:07 -0400
Message-ID: <521CBF5B.1050009@overkiz.com>
Date: Tue, 27 Aug 2013 17:01:47 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH] pinctrl: at91: add support for OUTPUT config
References: <1377615082-16808-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1377615082-16808-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 13789177634327918713
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -85
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -85
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was tested on sama5d31ek.

On 27/08/2013 16:51, Boris BREZILLON wrote:
> Add support for pin output control through the pinctrl config:
>   - support enabling/disabling output on a given pin
>   - support output level setting (high or low)
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>   .../bindings/pinctrl/atmel,at91-pinctrl.txt        |    2 ++
>   drivers/pinctrl/pinctrl-at91.c                     |   22 ++++++++++++++++++++
>   include/dt-bindings/pinctrl/at91.h                 |    2 ++
>   3 files changed, 26 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
> index cf7c7bc..5a22e0d 100644
> --- a/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
> +++ b/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
> @@ -90,6 +90,8 @@ MULTIDRIVE	(1 << 1): indicate this pin need to be configured as multidrive.
>   DEGLITCH	(1 << 2): indicate this pin need deglitch.
>   PULL_DOWN	(1 << 3): indicate this pin need a pull down.
>   DIS_SCHMIT	(1 << 4): indicate this pin need to disable schmit trigger.
> +OUTPUT		(1 << 5): indicate this pin need to be configured as an output.
> +OUTPUT_VAL	(0x1 << 6): output val (1 = high, 0 = low)
>   DEBOUNCE	(1 << 16): indicate this pin need debounce.
>   DEBOUNCE_VAL	(0x3fff << 17): debounce val.
>   
> diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
> index 19afb9a..1578a0d 100644
> --- a/drivers/pinctrl/pinctrl-at91.c
> +++ b/drivers/pinctrl/pinctrl-at91.c
> @@ -61,6 +61,9 @@ static int gpio_banks;
>   #define DEGLITCH	(1 << 2)
>   #define PULL_DOWN	(1 << 3)
>   #define DIS_SCHMIT	(1 << 4)
> +#define OUTPUT		(1 << 5)
> +#define OUTPUT_VAL_SHIFT	6
> +#define OUTPUT_VAL	(0x1 << OUTPUT_VAL_SHIFT)
>   #define DEBOUNCE	(1 << 16)
>   #define DEBOUNCE_VAL_SHIFT	17
>   #define DEBOUNCE_VAL	(0x3fff << DEBOUNCE_VAL_SHIFT)
> @@ -333,6 +336,19 @@ static void at91_mux_set_pullup(void __iomem *pio, unsigned mask, bool on)
>   	writel_relaxed(mask, pio + (on ? PIO_PUER : PIO_PUDR));
>   }
>   
> +static bool at91_mux_get_output(void __iomem *pio, unsigned pin, bool *val)
> +{
> +	*val = (readl_relaxed(pio + PIO_ODSR) >> pin) & 0x1;
> +	return (readl_relaxed(pio + PIO_OSR) >> pin) & 0x1;
> +}
> +
> +static void at91_mux_set_output(void __iomem *pio, unsigned mask, bool is_on,
> +				bool val)
> +{
> +	writel_relaxed(mask, pio + (val ? PIO_SODR : PIO_CODR));
> +	writel_relaxed(mask, pio + (is_on ? PIO_OER : PIO_ODR));
> +}
> +
>   static unsigned at91_mux_get_multidrive(void __iomem *pio, unsigned pin)
>   {
>   	return (readl_relaxed(pio + PIO_MDSR) >> pin) & 0x1;
> @@ -712,6 +728,7 @@ static int at91_pinconf_get(struct pinctrl_dev *pctldev,
>   	void __iomem *pio;
>   	unsigned pin;
>   	int div;
> +	bool out;
>   
>   	dev_dbg(info->dev, "%s:%d, pin_id=%d, config=0x%lx", __func__, __LINE__, pin_id, *config);
>   	pio = pin_to_controller(info, pin_to_bank(pin_id));
> @@ -732,6 +749,9 @@ static int at91_pinconf_get(struct pinctrl_dev *pctldev,
>   	if (info->ops->get_schmitt_trig && info->ops->get_schmitt_trig(pio, pin))
>   		*config |= DIS_SCHMIT;
>   
> +	if (at91_mux_get_output(pio, pin, &out))
> +		*config |= OUTPUT | (out << OUTPUT_VAL_SHIFT);
> +
>   	return 0;
>   }
>   
> @@ -749,6 +769,8 @@ static int at91_pinconf_set(struct pinctrl_dev *pctldev,
>   	if (config & PULL_UP && config & PULL_DOWN)
>   		return -EINVAL;
>   
> +	at91_mux_set_output(pio, mask, config & OUTPUT,
> +			    (config & OUTPUT_VAL) >> OUTPUT_VAL_SHIFT);
>   	at91_mux_set_pullup(pio, mask, config & PULL_UP);
>   	at91_mux_set_multidrive(pio, mask, config & MULTI_DRIVE);
>   	if (info->ops->set_deglitch)
> diff --git a/include/dt-bindings/pinctrl/at91.h b/include/dt-bindings/pinctrl/at91.h
> index d7988b4..9fd4d48 100644
> --- a/include/dt-bindings/pinctrl/at91.h
> +++ b/include/dt-bindings/pinctrl/at91.h
> @@ -15,6 +15,8 @@
>   #define AT91_PINCTRL_DEGLITCH		(1 << 2)
>   #define AT91_PINCTRL_PULL_DOWN		(1 << 3)
>   #define AT91_PINCTRL_DIS_SCHMIT		(1 << 4)
> +#define AT91_PINCTRL_OUTPUT		(1 << 5)
> +#define AT91_PINCTRL_OUTPUT_VAL(x)	((x & 0x1) << 6)
>   #define AT91_PINCTRL_DEBOUNCE		(1 << 16)
>   #define AT91_PINCTRL_DEBOUNCE_VA(x)	(x << 17)
>   

