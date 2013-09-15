Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab3IOGWf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 02:22:35 -0400
Received: from 6.mo1.mail-out.ovh.net ([46.105.43.205]:51901 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752477Ab3IOGWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 02:22:34 -0400
Message-ID: <523551DC.2010708@overkiz.com>
Date: Sun, 15 Sep 2013 08:21:16 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [RFC PATCH alt 4/4] pinctrl: at91: rework debounce configuration
References: <1379058213-3245-1-git-send-email-b.brezillon@overkiz.com> <1379058813-3489-1-git-send-email-b.brezillon@overkiz.com> <20130914163729.GB11420@ns203013.ovh.net>
In-Reply-To: <20130914163729.GB11420@ns203013.ovh.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 5948410684155787436
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrleeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrleeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jean-Christophe,

Le 14/09/2013 18:37, Jean-Christophe PLAGNIOL-VILLARD a écrit :
> On 09:53 Fri 13 Sep     , Boris BREZILLON wrote:
>> AT91 SoCs do not support per pin debounce time configuration.
>> Instead you have to configure a debounce time which will be used for all
>> pins of a given bank (PIOA, PIOB, ...).
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> ---
>>   .../bindings/pinctrl/atmel,at91-pinctrl.txt        |    9 ++-
>>   drivers/pinctrl/pinctrl-at91.c                     |   79 ++++++++++++++++----
>>   include/dt-bindings/pinctrl/at91.h                 |    1 -
>>   3 files changed, 73 insertions(+), 16 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
>> index cf7c7bc..8a4cdeb 100644
>> --- a/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
>> +++ b/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
>> @@ -78,6 +78,14 @@ PA31	TXD4
>>   
>>   => 0xffc00c3b
>>   
>> +Optional properties for iomux controller:
>> +- atmel,default-debounce-div: array of debounce divisors (one divisor per bank)
>> +  which describes the debounce timing in use for all pins of a given bank
>> +  configured with the DEBOUNCE option (see the following description).
>> +  Debounce timing is obtained with this formula:
>> +  Tdebounce = 2 * (debouncediv + 1) / Fslowclk
>> +  with Fslowclk = 32KHz
> I known that I put the div in the original binding
>
> but maybe we should just put the debounce timing in the DT and calculate the
> div in C

Sure, I can do this: retrieve a debounce time (in usec ?) and compute the
according div value.

>> +
>>   Required properties for pin configuration node:
>>   - atmel,pins: 4 integers array, represents a group of pins mux and config
>>     setting. The format is atmel,pins = <PIN_BANK PIN_BANK_NUM PERIPH CONFIG>.
>> @@ -91,7 +99,6 @@ DEGLITCH	(1 << 2): indicate this pin need deglitch.
>>   PULL_DOWN	(1 << 3): indicate this pin need a pull down.
>>   DIS_SCHMIT	(1 << 4): indicate this pin need to disable schmit trigger.
>>   DEBOUNCE	(1 << 16): indicate this pin need debounce.
>> -DEBOUNCE_VAL	(0x3fff << 17): debounce val.
>>   
>>   NOTE:
>>   Some requirements for using atmel,at91rm9200-pinctrl binding:
>> diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
>> index ac9dbea..2903758 100644
>> --- a/drivers/pinctrl/pinctrl-at91.c
>> +++ b/drivers/pinctrl/pinctrl-at91.c
>> @@ -62,8 +62,6 @@ static int gpio_banks;
>>   #define PULL_DOWN	(1 << 3)
>>   #define DIS_SCHMIT	(1 << 4)
>>   #define DEBOUNCE	(1 << 16)
>> -#define DEBOUNCE_VAL_SHIFT	17
>> -#define DEBOUNCE_VAL	(0x3fff << DEBOUNCE_VAL_SHIFT)
>>   
>>   /**
>>    * struct at91_pmx_func - describes AT91 pinmux functions
>> @@ -145,8 +143,10 @@ struct at91_pinctrl_mux_ops {
>>   	void (*mux_D_periph)(void __iomem *pio, unsigned mask);
>>   	bool (*get_deglitch)(void __iomem *pio, unsigned pin);
>>   	void (*set_deglitch)(void __iomem *pio, unsigned mask, bool is_on);
>> -	bool (*get_debounce)(void __iomem *pio, unsigned pin, u32 *div);
>> -	void (*set_debounce)(void __iomem *pio, unsigned mask, bool is_on, u32 div);
>> +	bool (*get_debounce)(void __iomem *pio, unsigned pin);
>> +	void (*set_debounce)(void __iomem *pio, unsigned mask, bool is_on);
>> +	u32 (*get_debounce_div)(void __iomem *pio);
>> +	void (*set_debounce_div)(void __iomem *pio, u32 div);
> why do you split it?
>
> if it's just get if on or not put NULL to div but do not add more function
> pointer

I not sure I got your point.
Are you suggesting we should store the default bank bebounce div values 
in struct at91_pinctrl
(during probe process) and pass these values each time the set_debounce 
function is called ?

IMHO if we split the logic (split debounce activation and debounce time 
definition) we should split
these callbacks:
  - one callback to enable debounce option on a given pin
  - one callback to configure the debounce time for a given bank

If you keep the div parameter in the debounce enable/disable callback 
you will reconfigure the div
register (PIO_SCDR_DIV) each time you enable the debounce option, which 
is kind of useless
because the div value will never change.

>>   	bool (*get_pulldown)(void __iomem *pio, unsigned pin);
>>   	void (*set_pulldown)(void __iomem *pio, unsigned mask, bool is_on);
>>   	bool (*get_schmitt_trig)(void __iomem *pio, unsigned pin);
>> @@ -432,25 +432,32 @@ static void at91_mux_pio3_set_deglitch(void __iomem *pio, unsigned mask, bool is
>>   	at91_mux_set_deglitch(pio, mask, is_on);
>>   }
>>   
>> -static bool at91_mux_pio3_get_debounce(void __iomem *pio, unsigned pin, u32 *div)
>> +static bool at91_mux_pio3_get_debounce(void __iomem *pio, unsigned pin)
>>   {
>> -	*div = __raw_readl(pio + PIO_SCDR);
>> -
>>   	return ((__raw_readl(pio + PIO_IFSR) >> pin) & 0x1) &&
>>   	       ((__raw_readl(pio + PIO_IFSCSR) >> pin) & 0x1);
>>   }
>>   
>>   static void at91_mux_pio3_set_debounce(void __iomem *pio, unsigned mask,
>> -				bool is_on, u32 div)
>> +				bool is_on)
>>   {
>>   	if (is_on) {
>>   		__raw_writel(mask, pio + PIO_IFSCER);
>> -		__raw_writel(div & PIO_SCDR_DIV, pio + PIO_SCDR);
>>   		__raw_writel(mask, pio + PIO_IFER);
>>   	} else
>>   		__raw_writel(mask, pio + PIO_IFSCDR);
>>   }
>>   
>> +static u32 at91_mux_pio3_get_debounce_div(void __iomem *pio)
>> +{
>> +	return __raw_readl(pio + PIO_SCDR) & PIO_SCDR_DIV;
>> +}
>> +
>> +static void at91_mux_pio3_set_debounce_div(void __iomem *pio, u32 div)
>> +{
>> +	__raw_writel(div & PIO_SCDR_DIV, pio + PIO_SCDR);
>> +}
>> +
>>   static bool at91_mux_pio3_get_pulldown(void __iomem *pio, unsigned pin)
>>   {
>>   	return !((__raw_readl(pio + PIO_PPDSR) >> pin) & 0x1);
>> @@ -490,6 +497,8 @@ static struct at91_pinctrl_mux_ops at91sam9x5_ops = {
>>   	.set_deglitch	= at91_mux_pio3_set_deglitch,
>>   	.get_debounce	= at91_mux_pio3_get_debounce,
>>   	.set_debounce	= at91_mux_pio3_set_debounce,
>> +	.get_debounce_div = at91_mux_pio3_get_debounce_div,
>> +	.set_debounce_div = at91_mux_pio3_set_debounce_div,
>>   	.get_pulldown	= at91_mux_pio3_get_pulldown,
>>   	.set_pulldown	= at91_mux_pio3_set_pulldown,
>>   	.get_schmitt_trig = at91_mux_pio3_get_schmitt_trig,
>> @@ -719,7 +728,6 @@ static int at91_pinconf_get(struct pinctrl_dev *pctldev,
>>   	struct at91_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
>>   	void __iomem *pio;
>>   	unsigned pin;
>> -	int div;
>>   
>>   	dev_dbg(info->dev, "%s:%d, pin_id=%d, config=0x%lx", __func__, __LINE__, pin_id, *config);
>>   	pio = pin_to_controller(info, pin_to_bank(pin_id));
>> @@ -734,8 +742,8 @@ static int at91_pinconf_get(struct pinctrl_dev *pctldev,
>>   
>>   	if (info->ops->get_deglitch && info->ops->get_deglitch(pio, pin))
>>   		*config |= DEGLITCH;
>> -	if (info->ops->get_debounce && info->ops->get_debounce(pio, pin, &div))
>> -		*config |= DEBOUNCE | (div << DEBOUNCE_VAL_SHIFT);
>> +	if (info->ops->get_debounce && info->ops->get_debounce(pio, pin))
>> +		*config |= DEBOUNCE;
>>   	if (info->ops->get_pulldown && info->ops->get_pulldown(pio, pin))
>>   		*config |= PULL_DOWN;
>>   	if (info->ops->get_schmitt_trig && info->ops->get_schmitt_trig(pio, pin))
>> @@ -765,8 +773,7 @@ static int at91_pinconf_set(struct pinctrl_dev *pctldev,
>>   		if (!info->ops->set_debounce)
>>   			return -ENOTSUPP;
>>   
>> -		info->ops->set_debounce(pio, mask, config & DEBOUNCE,
>> -				(config & DEBOUNCE_VAL) >> DEBOUNCE_VAL_SHIFT);
>> +		info->ops->set_debounce(pio, mask, config & DEBOUNCE);
>>   	} else if (info->ops->set_deglitch)
>>   		info->ops->set_deglitch(pio, mask, config & DEGLITCH);
>>   
>> @@ -822,6 +829,39 @@ static void at91_pinctrl_child_count(struct at91_pinctrl *info,
>>   	}
>>   }
>>   
>> +static int at91_pinctrl_default_debounce_div(struct at91_pinctrl *info,
>> +					     struct device_node *np)
>> +{
>> +	int size;
>> +	int i;
>> +	int ret;
>> +
>> +	if (!info->ops->set_debounce_div ||
>> +	    !of_get_property(np, "atmel,default-debounce-div", &size))
>> +		return 0;
>> +
>> +	size /= sizeof(u32);
>> +	if (size != info->nbanks) {
>> +		dev_err(info->dev,
>> +			"atmel,default-debounce-div property should contain %d elements\n",
>> +			info->nbanks);
>> +		return -EINVAL;
>> +	}
>> +
>> +	for (i = 0; i < info->nbanks; i++) {
>> +		u32 val;
>> +		ret = of_property_read_u32_index(np,
>> +						 "atmel,default-debounce-div",
>> +						 i, &val);
>> +		if (ret)
>> +			return ret;
>> +
>> +		info->ops->set_debounce_div(gpio_chips[i]->regbase, val);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   static int at91_pinctrl_mux_mask(struct at91_pinctrl *info,
>>   				 struct device_node *np)
>>   {
>> @@ -972,6 +1012,10 @@ static int at91_pinctrl_probe_dt(struct platform_device *pdev,
>>   	if (ret)
>>   		return ret;
>>   
>> +	ret = at91_pinctrl_default_debounce_div(info, np);
>> +	if (ret)
>> +		return ret;
>> +
>>   	dev_dbg(&pdev->dev, "nmux = %d\n", info->nmux);
>>   
>>   	dev_dbg(&pdev->dev, "mux-mask\n");
>> @@ -982,6 +1026,13 @@ static int at91_pinctrl_probe_dt(struct platform_device *pdev,
>>   		}
>>   	}
>>   
>> +	if (info->ops->get_debounce_div) {
>> +		dev_dbg(&pdev->dev, "default-debounce-div\n");
>> +		for (i = 0; i < info->nbanks; i++)
>> +			dev_dbg(&pdev->dev, "bank %d\t%d\n", i,
>> +				info->ops->get_debounce_div(gpio_chips[i]->regbase));
>> +	}
>> +
>>   	dev_dbg(&pdev->dev, "nfunctions = %d\n", info->nfunctions);
>>   	dev_dbg(&pdev->dev, "ngroups = %d\n", info->ngroups);
>>   	info->functions = devm_kzalloc(&pdev->dev, info->nfunctions * sizeof(struct at91_pmx_func),
>> diff --git a/include/dt-bindings/pinctrl/at91.h b/include/dt-bindings/pinctrl/at91.h
>> index 0fee6ff..b478954 100644
>> --- a/include/dt-bindings/pinctrl/at91.h
>> +++ b/include/dt-bindings/pinctrl/at91.h
>> @@ -16,7 +16,6 @@
>>   #define AT91_PINCTRL_PULL_DOWN		(1 << 3)
>>   #define AT91_PINCTRL_DIS_SCHMIT		(1 << 4)
>>   #define AT91_PINCTRL_DEBOUNCE		(1 << 16)
>> -#define AT91_PINCTRL_DEBOUNCE_VAL(x)	(x << 17)
>>   
>>   #define AT91_PINCTRL_PULL_UP_DEGLITCH	(AT91_PINCTRL_PULL_UP | AT91_PINCTRL_DEGLITCH)
>>   
>> -- 
>> 1.7.9.5
>>

