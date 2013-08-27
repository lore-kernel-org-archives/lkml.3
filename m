Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab3H0HvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 03:51:19 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:51660 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab3H0HvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 03:51:17 -0400
Message-ID: <521C5A8B.2030607@atmel.com>
Date: Tue, 27 Aug 2013 09:51:39 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: boris brezillon <b.brezillon@overkiz.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Jiri Kosina" <jkosina@suse.cz>, Masanari Iida <standby24x7@gmail.com>,
        "Richard Genoud" <richard.genoud@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "James Hogan" <james.hogan@imgtec.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 2/3] pinctrl: at91: add support for generic pinconf
References: <1377379926-11163-1-git-send-email-b.brezillon@overkiz.com> <1377380259-11290-1-git-send-email-b.brezillon@overkiz.com> <20130826175333.GF18627@ns203013.ovh.net> <521BA235.1090104@overkiz.com> <20130826191843.GG18627@ns203013.ovh.net>
In-Reply-To: <20130826191843.GG18627@ns203013.ovh.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/08/2013 21:18, Jean-Christophe PLAGNIOL-VILLARD :
> On 20:45 Mon 26 Aug     , boris brezillon wrote:
>> Hello Jean-Christophe,
>>
>> Le 26/08/2013 19:53, Jean-Christophe PLAGNIOL-VILLARD a écrit :
>>> On 23:37 Sat 24 Aug     , Boris BREZILLON wrote:
>>>> Add support for generic pin configuration to pinctrl-at91 driver.
>>>>
>>>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>>>> ---
>>>>   .../bindings/pinctrl/atmel,at91-pinctrl.txt        |   43 +++-
>>>>   drivers/pinctrl/Kconfig                            |    2 +-
>>>>   drivers/pinctrl/pinctrl-at91.c                     |  265 ++++++++++++++++++--
>>>>   3 files changed, 289 insertions(+), 21 deletions(-)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
>>>> index 7ccae49..7a7c0c4 100644
>>>> --- a/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
>>>> +++ b/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
>>>> @@ -18,7 +18,9 @@ mode) this pin can work on and the 'config' configures various pad settings
>>>>   such as pull-up, multi drive, etc.
>>>>   Required properties for iomux controller:
>>>> -- compatible: "atmel,at91rm9200-pinctrl"
>>>> +- compatible: "atmel,at91rm9200-pinctrl" or "atmel,at91sam9x5-pinctrl".
>>>> +  Add "generic-pinconf" to the compatible string list to use the generic pin
>>>> +  configuration syntax.
>>>>   - atmel,mux-mask: array of mask (periph per bank) to describe if a pin can be
>>>>     configured in this periph mode. All the periph and bank need to be describe.
>>>> @@ -83,6 +85,11 @@ Required properties for pin configuration node:
>>>>     setting. The format is atmel,pins = <PIN_BANK PIN_BANK_NUM PERIPH CONFIG>.
>>>>     The PERIPH 0 means gpio, PERIPH 1 is periph A, PERIPH 2 is periph B...
>>>>     PIN_BANK 0 is pioA, PIN_BANK 1 is pioB...
>>>> +  Dependending on the presence of the "generic-pinconf" string in the
>>>> +  compatible property the 4th cell is:
>>>> +   * a phandle referencing a generic pin config node (refer to
>>>> +     pinctrl-bindings.txt)
>>>> +   * an integer defining the pin config (see the following description)
>>>>   Bits used for CONFIG:
>>>>   PULL_UP		(1 << 0): indicate this pin need a pull up.
>>>> @@ -132,6 +139,40 @@ pinctrl@fffff400 {
>>>>   	};
>>>>   };
>>>> +or
>>>> +
>>>> +pinctrl@fffff400 {
>>>> +	#address-cells = <1>;
>>>> +	#size-cells = <1>;
>>>> +	ranges;
>>>> +	compatible = "atmel,at91rm9200-pinctrl", "generic-pinconf", "simple-bus";
>>> nack your break the backword compatibility
>>>
>>> if we use a old kernel with this new dt nothing will work
>>> as the old kernel will never known the the "generic-pinconf" means anything
>>
>> Your're right, I didn't think of this case (old kernel with new dt).
>>
>>> if we want to use generic-pinconf support you *CAN NOT* use atmel,at91rm9200-pinctrl

One.
I did not spot.

>>> in the compatible
>>
>> What about using "atmel,at91xx-pinconf" instead of
>> "atmel,at91xx-pinctrl" to notify
>> the generic pinconf compatibility (as done by single pinctrl driver) ?
> no as the rm9200 IP and sam9x5 IP are only partially compatible
> you MUST distinguish them

Two? WTF!

Jean-Christophe, YOU MUST NOT SCREAM in emails, okay?!


>>>> +	reg = <0xfffff400 0x600>;
>>>> +
>>>> +	atmel,mux-mask = <
>>>> +	      /*    A         B     */
>>>> +	       0xffffffff 0xffc00c3b  /* pioA */
>>>> +	       0xffffffff 0x7fff3ccf  /* pioB */
>>>> +	       0xffffffff 0x007fffff  /* pioC */
>>>> +	      >;
>>>> +
>>>> +	pcfg_none: pcfg_none {
>>>> +		bias-disable;
>>>> +	};
>>>> +
>>>> +	pcfg_pull_up: pcfg_pull_up {
>>>> +		bias-pullup;
>>>> +	};
>>>> +
>>>> +	/* shared pinctrl settings */
>>>> +	dbgu {
>>>> +		pinctrl_dbgu: dbgu-0 {
>>>> +			atmel,pins =
>>>> +				<1 14 0x1 &pcfg_none		/* PB14 periph A */
>>>> +				 1 15 0x1 &pcfg_pull_up>;	/* PB15 periph A with pullup */
>>>> +		};
>>>> +	};
>>>> +};
>>>> +
>>>>   dbgu: serial@fffff200 {
>>>>   	compatible = "atmel,at91sam9260-usart";
>>>>   	reg = <0xfffff200 0x200>;
>>>> diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
>>>> index bdb1a87..55a4f2c 100644
>>>> --- a/drivers/pinctrl/Kconfig
>>>> +++ b/drivers/pinctrl/Kconfig
>>>> @@ -54,7 +54,7 @@ config PINCTRL_AT91
>>>>   	depends on OF
>>>>   	depends on ARCH_AT91
>>>>   	select PINMUX
>>>> -	select PINCONF
>>>> +	select GENERIC_PINCONF
>>>>   	help
>>>>   	  Say Y here to enable the at91 pinctrl driver
>>>> diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
>>>> index 7cce066..1994dd2 100644
>>>> --- a/drivers/pinctrl/pinctrl-at91.c
>>>> +++ b/drivers/pinctrl/pinctrl-at91.c
>>>> @@ -23,6 +23,7 @@
>>>>   #include <linux/gpio.h>
>>>>   #include <linux/pinctrl/machine.h>
>>>>   #include <linux/pinctrl/pinconf.h>
>>>> +#include <linux/pinctrl/pinconf-generic.h>
>>>>   #include <linux/pinctrl/pinctrl.h>
>>>>   #include <linux/pinctrl/pinmux.h>
>>>>   /* Since we request GPIOs from ourself */
>>>> @@ -32,6 +33,7 @@
>>>>   #include <mach/at91_pio.h>
>>>>   #include "core.h"
>>>> +#include "pinconf.h"
>>>>   #define MAX_NB_GPIO_PER_BANK	32
>>>> @@ -85,6 +87,21 @@ enum at91_mux {
>>>>   	AT91_MUX_PERIPH_D = 4,
>>>>   };
>>>> +struct at91_generic_pinconf {
>>>> +	unsigned long	*configs;
>>>> +	unsigned int	nconfigs;
>>>> +};
>>>> +
>>>> +enum at91_pinconf_type {
>>>> +	AT91_PINCONF_NATIVE,
>>>> +	AT91_PINCONF_GENERIC,
>>>> +};
>>>> +
>>>> +union at91_pinconf {
>>>> +	unsigned long			native;
>>>> +	struct at91_generic_pinconf	generic;
>>>> +};
>>>> +
>>>>   /**
>>>>    * struct at91_pmx_pin - describes an At91 pin mux
>>>>    * @bank: the bank of the pin
>>>> @@ -93,10 +110,11 @@ enum at91_mux {
>>>>    * @conf: the configuration of the pin: PULL_UP, MULTIDRIVE etc...
>>>>    */
>>>>   struct at91_pmx_pin {
>>>> -	uint32_t	bank;
>>>> -	uint32_t	pin;
>>>> -	enum at91_mux	mux;
>>>> -	unsigned long	conf;
>>>> +	uint32_t		bank;
>>>> +	uint32_t		pin;
>>>> +	enum at91_mux		mux;
>>>> +	enum at91_pinconf_type	conftype;
>>>> +	union at91_pinconf	conf;
>>>>   };
>>>>   /**
>>>> @@ -278,8 +296,16 @@ static int at91_dt_node_to_map(struct pinctrl_dev *pctldev,
>>>>   		new_map[i].type = PIN_MAP_TYPE_CONFIGS_PIN;
>>>>   		new_map[i].data.configs.group_or_pin =
>>>>   				pin_get_name(pctldev, grp->pins[i]);
>>>> -		new_map[i].data.configs.configs = &grp->pins_conf[i].conf;
>>>> -		new_map[i].data.configs.num_configs = 1;
>>>> +		if (!pctldev->desc->confops->is_generic) {
>>>> +			new_map[i].data.configs.configs =
>>>> +				&grp->pins_conf[i].conf.native;
>>>> +			new_map[i].data.configs.num_configs = 1;
>>>> +		} else {
>>>> +			new_map[i].data.configs.configs =
>>>> +				grp->pins_conf[i].conf.generic.configs;
>>>> +			new_map[i].data.configs.num_configs =
>>>> +				grp->pins_conf[i].conf.generic.nconfigs;
>>>> +		}
>>>>   	}
>>>>   	dev_dbg(pctldev->dev, "maps: function %s group %s num %d\n",
>>>> @@ -325,7 +351,7 @@ static void at91_mux_disable_interrupt(void __iomem *pio, unsigned mask)
>>>>   static unsigned at91_mux_get_pullup(void __iomem *pio, unsigned pin)
>>>>   {
>>>> -	return (readl_relaxed(pio + PIO_PUSR) >> pin) & 0x1;
>>>> +	return !((readl_relaxed(pio + PIO_PUSR) >> pin) & 0x1);
>>>>   }
>>>>   static void at91_mux_set_pullup(void __iomem *pio, unsigned mask, bool on)
>>>> @@ -407,6 +433,16 @@ static enum at91_mux at91_mux_get_periph(void __iomem *pio, unsigned mask)
>>>>   	return select + 1;
>>>>   }
>>>> +static bool at91_mux_get_output(void __iomem *pio, unsigned pin)
>>>> +{
>>>> +	return (readl_relaxed(pio + PIO_OSR) >> pin) & 0x1;
>>>> +}
>>>> +
>>>> +static void at91_mux_set_output(void __iomem *pio, unsigned mask, bool is_on)
>>>> +{
>>>> +	__raw_writel(mask, pio + (is_on ? PIO_OER : PIO_ODR));
>>>> +}
>>>> +
>>>>   static bool at91_mux_get_deglitch(void __iomem *pio, unsigned pin)
>>>>   {
>>>>   	return (__raw_readl(pio + PIO_IFSR) >> pin) & 0x1;
>>>> @@ -445,7 +481,7 @@ static void at91_mux_pio3_set_debounce(void __iomem *pio, unsigned mask,
>>>>   static bool at91_mux_pio3_get_pulldown(void __iomem *pio, unsigned pin)
>>>>   {
>>>> -	return (__raw_readl(pio + PIO_PPDSR) >> pin) & 0x1;
>>>> +	return !((__raw_readl(pio + PIO_PPDSR) >> pin) & 0x1);
>>>>   }
>>>>   static void at91_mux_pio3_set_pulldown(void __iomem *pio, unsigned mask, bool is_on)
>>>> @@ -492,12 +528,17 @@ static struct at91_pinctrl_mux_ops at91sam9x5_ops = {
>>>>   static void at91_pin_dbg(const struct device *dev, const struct at91_pmx_pin *pin)
>>>>   {
>>>>   	if (pin->mux) {
>>>> -		dev_dbg(dev, "pio%c%d configured as periph%c with conf = 0x%lu\n",
>>>> -			pin->bank + 'A', pin->pin, pin->mux - 1 + 'A', pin->conf);
>>>> +		dev_dbg(dev, "pio%c%d configured as periph%c",
>>>> +			pin->bank + 'A', pin->pin, pin->mux - 1 + 'A');
>>>>   	} else {
>>>> -		dev_dbg(dev, "pio%c%d configured as gpio with conf = 0x%lu\n",
>>>> -			pin->bank + 'A', pin->pin, pin->conf);
>>>> +		dev_dbg(dev, "pio%c%d configured as gpio",
>>>> +			pin->bank + 'A', pin->pin);
>>>>   	}
>>>> +
>>>> +	if (pin->conftype == AT91_PINCONF_NATIVE)
>>>> +		dev_dbg(dev, " with conf = 0x%lu\n", pin->conf.native);
>>>> +	else
>>>> +		dev_dbg(dev, "\n");
>>> do not change debug output
>>
>> I do not change the debug output for the native pinconf binding, but
>> I cannot print the config as
>> a single interger in hex format if the generic pinconf is used.
>> I must translate each config entry to a "property=value" string, or
>> translate the generic config
>> array to a single native config integer.
>>
>> Do you have something easier in mind ?
>
> no but I do not want to brake current automatic test tools
>
> propose something with this in mind
>
> Best Regards,
> J.
>


-- 
Nicolas Ferre
