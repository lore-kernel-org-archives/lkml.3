Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab3FNIJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 04:09:41 -0400
Received: from gloria.sntech.de ([95.129.55.99]:58786 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab3FNIJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 04:09:33 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 1/2] pinctrl: add function to parse generic pinconfig properties from a dt node
Date: Fri, 14 Jun 2013 09:34:14 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patrice Chotard <patrice.chotard.st@gmail.com>
References: <201306102139.32444.heiko@sntech.de> <201306102140.29918.heiko@sntech.de> <2477455.I6AxjaGPuJ@avalon>
In-Reply-To: <2477455.I6AxjaGPuJ@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201306140934.15052.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Am Freitag, 14. Juni 2013, 02:27:01 schrieb Laurent Pinchart:
> Hi Heiko,
> 
> Thank you for the patch. I've tested it on an sh73a0 KZM9G board with the
> sh- pfc driver and it seems to work fine. Please see the code below for
> comments.
> 
> On Monday 10 June 2013 21:40:29 Heiko Stübner wrote:
> > pinconf_generic_parse_dt_config() takes a node as input and generates an
> > array of generic pinconfig values from the properties of this node.
> > 
> > As I couldn't find a mechanism to count the number of properties of a
> > node the function uses internally an array to accept one of parameter
> > and copies the real present options to a smaller variable at its end.
> > 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> > ---
> > 
> >  .../bindings/pinctrl/pinctrl-bindings.txt          |   38 +++++++++
> >  drivers/pinctrl/pinconf-generic.c                  |   81
> >  +++++++++++++++++ drivers/pinctrl/pinconf.h                          | 
> >    6 ++
> >  3 files changed, 125 insertions(+), 0 deletions(-)
> > 
> > diff --git
> > a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> > b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt index
> > c95ea82..ef7cd57 100644
> > --- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> > +++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> > @@ -126,3 +126,41 @@ device; they may be grandchildren, for example.
> > Whether this is legal, and whether there is any interaction between the
> > child and intermediate parent nodes, is again defined entirely by the
> > binding for the individual pin controller device.
> > +
> > +== Using generic pinconfig options ==
> > +
> > +Generic pinconfig parameters can be used by defining a separate node
> > containing +the applicable parameters (and optional values), like:
> > +
> > +pcfg_pull_up: pcfg_pull_up {
> > +	bias-pull-up;
> > +	drive-strength = <20>;
> > +};
> > +
> > +This node should then be referenced in the appropriate pinctrl node as a
> > phandle +and parsed in the driver using the
> > pinconf_generic_parse_dt_config function. +
> > +Supported configuration parameters are:
> > +
> > +bias-disable		- disable any pin bias
> > +bias-high-impedance	- high impedance mode ("third-state", "floating")
> > +bias-bus-hold		- latch weakly
> > +bias-pull-up		- pull up the pin
> > +bias-pull-down		- pull down the pin
> > +bias-pull-pin-default	- use pin-default pull state
> > +drive-push-pull		- drive actively high and low
> > +drive-open-drain	- drive with open drain
> > +drive-open-source	- drive with open source
> > +drive-strength		- sink or source at most X mA
> > +input-schmitt-enable	- enable schmitt-trigger mode
> > +input-schmitt-disable	- disable schmitt-trigger mode
> > +input-schmitt		- run in schmitt-trigger mode with hysteresis X
> > +input-debounce		- debounce mode with debound time X
> > +power-source		- select power source X
> > +slew-rate		- use slew-rate X
> > +low-power-mode		- low power mode
> > +output-low		- set the pin to output mode with low level
> > +output-high		- set the pin to output mode with high level
> > +
> > +More in-depth documentation on these parameters can be found in
> > +<include/linux/pinctrl/pinconfig-generic.h>
> > diff --git a/drivers/pinctrl/pinconf-generic.c
> > b/drivers/pinctrl/pinconf-generic.c index 9a6812b..3610e7b 100644
> > --- a/drivers/pinctrl/pinconf-generic.c
> > +++ b/drivers/pinctrl/pinconf-generic.c
> > @@ -21,6 +21,7 @@
> > 
> >  #include <linux/pinctrl/pinctrl.h>
> >  #include <linux/pinctrl/pinconf.h>
> >  #include <linux/pinctrl/pinconf-generic.h>
> > 
> > +#include <linux/of.h>
> > 
> >  #include "core.h"
> >  #include "pinconf.h"
> > 
> > @@ -139,3 +140,83 @@ void pinconf_generic_dump_config(struct pinctrl_dev
> > *pctldev, }
> > 
> >  EXPORT_SYMBOL_GPL(pinconf_generic_dump_config);
> >  #endif
> > 
> > +
> > +#ifdef CONFIG_OF
> > +struct pinconf_generic_dt_params {
> > +	const char * const property;
> > +	enum pin_config_param param;
> > +	u32 default_value;
> > +};
> > +
> > +static struct pinconf_generic_dt_params dt_params[] = {
> > +	{ "bias-disable", PIN_CONFIG_BIAS_DISABLE, 0 },
> > +	{ "bias-high-impedance", PIN_CONFIG_BIAS_HIGH_IMPEDANCE, 0 },
> > +	{ "bias-bus-hold", PIN_CONFIG_BIAS_BUS_HOLD, 0 },
> > +	{ "bias-pull-up", PIN_CONFIG_BIAS_PULL_UP, 0 },
> > +	{ "bias-pull-down", PIN_CONFIG_BIAS_PULL_DOWN, 0 },
> > +	{ "bias-pull-pin-default", PIN_CONFIG_BIAS_PULL_PIN_DEFAULT, 0 },
> > +	{ "drive-push-pull", PIN_CONFIG_DRIVE_PUSH_PULL, 0 },
> > +	{ "drive-open-drain", PIN_CONFIG_DRIVE_OPEN_DRAIN, 0 },
> > +	{ "drive-open-source", PIN_CONFIG_DRIVE_OPEN_SOURCE, 0 },
> > +	{ "drive-strength", PIN_CONFIG_DRIVE_STRENGTH, 0 },
> > +	{ "input-schmitt-enable", PIN_CONFIG_INPUT_SCHMITT_ENABLE, 1 },
> > +	{ "input-schmitt-disable", PIN_CONFIG_INPUT_SCHMITT_ENABLE, 0 },
> > +	{ "input-schmitt", PIN_CONFIG_INPUT_SCHMITT, 0 },
> > +	{ "input-debounce", PIN_CONFIG_INPUT_DEBOUNCE, 0 },
> > +	{ "power-source", PIN_CONFIG_POWER_SOURCE, 0 },
> > +	{ "slew-rate", PIN_CONFIG_SLEW_RATE, 0 },
> > +	{ "low-power-mode", PIN_CONFIG_LOW_POWER_MODE, 0 },
> > +	{ "output-low", PIN_CONFIG_OUTPUT, 0, },
> > +	{ "output-high", PIN_CONFIG_OUTPUT, 1, },
> > +};
> > +
> > +/**
> > + * pinconf_generic_parse_dt_config()
> > + * parse the config properties into generic pinconfig values.
> > + * @np: node containing the pinconfig properties
> > + * @configs: array with nconfigs entries containing the generic pinconf
> > values + * @nconfigs: umber of configurations
> > + */
> > +int pinconf_generic_parse_dt_config(struct device_node *np,
> > +				    unsigned long **configs,
> > +				    unsigned int *nconfigs)
> > +{
> > +	unsigned long cfg[ARRAY_SIZE(dt_params)];
> 
> I'm a bit uneasy about allocating large arrays on the stack. Would it be
> better to dynamically allocate cfg ? I've used kzrealloc in my
> implementation to grow the config array every time a config was found, but
> that might not be the most efficient implementation, although I wonder how
> many configuration options we will see in practice in a single node.

Personally I'm not sure ... using kzrealloc once for each found property like 
I saw it in your patch feels somehow slow, while my big array might cause 
other problems.

If there was a way to count properties in a dt node this would solve the 
problem, aka alloc an array of the number of properties, parse props and then 
move to correct sized array when we know the exact number of found ones.

But I hadn't found  a way to get the number of properties and trying to write 
my own iterating over the properties did result in strange numbers, probably 
thru inheritance of properties.


> > +	unsigned int ncfg = 0;
> > +	int ret;
> > +	int i;
> > +	u32 val;
> > +
> > +	if (!np)
> > +		return -EINVAL;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
> > +		struct pinconf_generic_dt_params *par = &dt_params[i];
> > +		ret = of_property_read_u32(np, par->property, &val);
> > +
> > +		/* property not found */
> > +		if (ret == -EINVAL)
> > +			continue;
> > +
> > +		/* use default value, when no value is specified */
> > +		if (ret)
> > +			val = par->default_value;
> > +
> > +		pr_debug("found %s with value %u\n", par->property, val);
> > +		cfg[ncfg] = pinconf_to_config_packed(par->param, val);
> > +		ncfg++;
> > +	}
> 
> You could add
> 
> 	if (ncfg == 0) {
> 		*configs = NULL;
> 		*nconfigs = 0;
> 		return 0;
> 	}
> 
> here.
> 
> Most of the issues I wanted to raise have already been addressed by
> comments sent to the list. Do you plan to send a v2 in the near future ?

According to Linus this is already in his tree, so I'm currently working on 
fixup patches for the issues. Should be done hopefully today.


Heiko
