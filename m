Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538Ab3GZTJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 15:09:45 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41425 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab3GZTJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 15:09:40 -0400
Message-ID: <51F2C970.7000200@wwwdotorg.org>
Date: Fri, 26 Jul 2013 13:09:36 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: grant.likely@linaro.org, linus.walleij@linaro.org, rob.herring@calxeda.com,
        rob@landley.net, sameo@linux.intel.com, lee.jones@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, gg@slimlogic.co.uk, kishon@ti.com,
        swarren@nvidia.com, devicetree@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH 2/2] pinctrl: palmas: add pincontrol driver
References: <1374833754-19659-1-git-send-email-ldewangan@nvidia.com> <1374833754-19659-3-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1374833754-19659-3-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Also CC'ing in the DT bindings maintainers, hence quoting all of the
binding.)

On 07/26/2013 04:15 AM, Laxman Dewangan wrote:
> TI Palam series Power Management IC have multiple pins which can be

S/Palam/Palmas/ right? This name seems to get typo'd an awful lot, both
in this patch and others... I suggest a thorough search/replace.

> configured for different functionality. This pins can be configured
> for different function. Also their properties like pull up/down,
> open drain enable/disable are configurable.
> 
> Add support for pincontrol driver Palmas series device like TPS65913,
> TPS80036. The driver supports to be register from DT only.

> diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-palmas.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-palmas.txt

> +Palmas Pincontrol bindings
> +
> +The pins of palmas device can be set on different option and provides
> +the configuration for Pull UP/DOWN, open drain etc.
> +
> +Required properties:
> +- compatible: It must be one of following:
> +  - "ti,palams-pinctrl" for palma series of the pincontrol.
> +  - "ti,tps65913-pinctrl" for Palma series device TPS65913.
> +  - "ti,tps80036-pinctrl" for palma series device TPS80036.
> +
> +Please refer to pinctrl-bindings.txt in this directory for details of the
> +common pinctrl bindings used by client devices, including the meaning of the
> +phrase "pin configuration node".
> +
> +Palmas's pin configuration nodes act as a container for an abitrary number of

s/abitrary/arbitrary/

> +subnodes. Each of these subnodes represents some desired configuration for a
> +pin, a group, or a list of pins or groups. This configuration can include the

I think this text was copied from an existing binding that describe HW
that actually does mux pin groups not pins. Given the list of valid
values for this field below, I think this HW muxes per-pin not
per-group, so you may want to simplify this text; replace "a pin, a
group, or a list of pins or groups" with "a pin or list of pins", or
even just "a list of pins".

> +mux function to select on those pin(s)/group(s), and various pin configuration

And similarly, remove all mentions of "groups" elsewhere in the
document, e.g. in the line above.

> +parameters, such as pull-up, open drain.
> +
> +The name of each subnode is not important; all subnodes should be enumerated
> +and processed purely based on their content.
> +
> +Each subnode only affects those parameters that are explicitly listed. In
> +other words, a subnode that lists a mux function but no pin configuration
> +parameters implies no information about any pin configuration parameters.
> +Similarly, a pin subnode that describes a pullup parameter implies no
> +information about e.g. the mux function.
> +
> +Optional properties:
> +- ti,palams-enable-dvfs1: Enable DVFS1. Configure pins for DVFS1 mode.
> +- ti,palams-enable-dvfs2: Enable DVFS2. Configure pins for DVFS2 mode.

What do those options do? I see from the driver that they do directly
control HW, so the options are fine from that perspective. I'm just
wondering how they would impact the pinctrl semantics; does enabling
those options mean that the pinctrl properties won't work for some pins?
If so, it /might/ be worth at least briefly mentioning that here,
although presumably it's already well-covered in the manual for the HW.

> +Required subnode-properties:
> +- ti,pins: An array of strings. Each string contains the name of a pin or
> +    group. Valid values for these names are listed below.

(remove "or group")

> +
> +Optional subnode-properties:
> +- ti,function:  string containing the name of the function to mux to the
> +  pin or group. Valid values for function names are listed below. Please

(remove "or group")

> +  refer the datasheet of the device to determine which are valid for each
> +  pin or group.

(remove "or group")

> +- ti,pull: Integer, representing the pull-down/up to apply to the pin.
> +    0: none, 1: up, 2: down.
> +- ti,open-drain" Integer, representing the open drain to be enable/disable
> +  to the pin.
> +    0: Disable, 1: Enable.

Weren't DT bindings already defined for standard properties? I can't
remember if that patch went through. If so, it might be worth using
standard properties instead.

> +Note that many of these properties are only valid for certain specific pins
> +or groups. See the Palma device datasheet for complete details regarding which

(remove "or groups")

> +groups support which functionality.

s/groups/pins/

> +
> +Valid values for pin and group names are:

(remove "and groups")

> +pins: gpio0_id, gpio1_vbus_det_led1_pwm1, gpio2_regen_led2_pwm2, gpio3_chrg_det,
> +	gpio4_sysen1, gpio5_clk32kgaudio_usb_psel, gpio6_sysen2,
> +	gpio7_msecure_pwrhold, gpio8_sim1rsti, gpio9_low_vbat,
> +	gpio10_wireless_chrg1, gpio11_rcm, gpio12_sim2rsto, gpio13, gpio14,
> +	gpio15_sim2rsti, vac, powergood_usb_psel, nreswarm, pwrdown,
> +	gpadc_start, reset_in, nsleep, enable1, enable2, int.
> +
> +function: gpio, led, pwm, regen, sysen, clk32kgaudio, id, vbus_det, chrg_det,
> +	vac, vacok, powergood, usb_psel, msecure, pwrhold, int, nreswarm,
> +	simrsto, simrsti, low_vbat, wireless_chrg1, rcm, pwrdown, gpadc_start,
> +	reset_in, nsleep, enable.
> +
> +Example:
> +	palmas: tps65913@58 {
> +		:::::::::::
> +

Nit: Just deleting those two lines might easier. ... is more common than
::::: I think.

> +		pinctrl {
> +			compatible = "ti,tps65913-pinctrl";

Don't you need to add "ti,palams-pinctrl" to the end of that list?

> +			ti,palams-enable-dvfs1;
> +			pinctrl-names = "default";
> +			pinctrl-0 = <&palmas_pins_state>;
> +
> +			palmas_pins_state: pinmux {
> +				gpio0_id {
> +					ti,pins = "gpio0_id";
> +					ti,function = "id";
> +				};
> +
> +				vac {
> +					ti,pins = "vac";
> +					ti,function = "vacok";
> +				};
> +			};
> +		};
> +		:::::::::::
> +	};

> diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
> index 5a8ad51..b62c331 100644
> --- a/drivers/pinctrl/Kconfig
> +++ b/drivers/pinctrl/Kconfig
> @@ -261,6 +261,16 @@ config PINCTRL_EXYNOS5440
>  	select PINMUX
>  	select PINCONF
>  
> +config PINCTRL_PALMAS
> +	bool "Pinctrl driver for the PALMA Series MFD devices"
> +	depends on OF && MFD_PALMAS
> +	select GENERIC_PINCONF
> +	help
> +	  Palma device suppots the configuration of pins  for different

s/suppots/supports/. There are also two spaces there.

> +	  functionality. This driver supports the pinmux, pushpull and

Usually push-pull not pushpull.

> +	  open drain configuration for the palmas series devices like

I assume Palmas should be capitalized since it's a name.

> diff --git a/drivers/pinctrl/pinctrl-palmas.c b/drivers/pinctrl/pinctrl-palmas.c

> +#define PALMAS_PINCONF_PACK(p, a)		(((p) << 16) | (a))
> +#define PALMAS_PINCONF_UNPACK_PARAM(c)		(((c) >> 16) & 0xFFFFUL)
> +#define PALMAS_PINCONF_UNPACK_ARG(c)		((c) & 0xFFFFUL)
> +
> +enum palmas_pinconf_param {
> +	PALMAS_PINCONF_PARAM_PULL,
> +	PALMAS_PINCONF_PARAM_OPEN_DRAIN,
> +};

If you're relying on CONFIG_GENERIC_PINCONF, I think there's a generic
version of those macros/enums you could use.

> +struct palmas_pctrl_chip_info {
> +	struct device *dev;
> +	struct pinctrl_dev *pctl;
> +	struct palmas *palmas;
> +	int pins_current_opt[PALMAS_PIN_NUM];

That field looks odd. From what I can tell in the code, the location of
the pull-up/down/... registers/bits varies depending on which mux
function is selected for a particular pin? That's a very strange HW
design. Are you sure the set of pins/functions this driver exposes is
the correct way to represent the HW?

> +static const char * const gpio_group[] = {

I think all of these arrays should be named something_groups not
something_group; they don't define a "pin group" but rather the list of
pin groups upon which a particular function may be selected.

> +enum palmas_pinmux {
...
> +	PALMAS_PINMUX_INVALID = 0xFFFF,
> +	PALMAS_PINMUX_NA = PALMAS_PINMUX_INVALID,

I don't think you need to define two values for that; only one of them
is used, right?

> +struct palmas_pins_pullup_dn_info {
...
> +struct palmas_pins_od_info {

> +struct palmas_pingroup {
...
> +	unsigned mux_reg_base;
> +	unsigned mux_reg_add;

This isn't an issue with this patch, but more with the way palmas_read()
works. Here, the MFD component is telling the MFD top-level object where
the MFD component exists within the top-level address space. That's
backwards. The top-level MFD is what know how the components are put
together to create the whole particular chip, and it's entirely possible
this could vary chip-to-chip. :-(

> +static int palmas_pinctrl_set_dvfs1(struct palmas_pctrl_chip_info *pci,

> +	val = (enable) ? PALMAS_PRIMARY_SECONDARY_PAD3_DVFS1 : 0;

No need for the ().

> +static int palmas_pinctrl_dt_subnode_to_map(struct device *dev,

> +	ret = of_property_read_string(np, "ti,function", &function);
> +	if (ret < 0) {
> +		/* EINVAL=missing, which is fine since it's optional */
> +		if (ret != -EINVAL)
> +			dev_err(dev,
> +				"could not parse property nvidia,function\n");

nvidia? The same problem exists in other places.

I wonder if most/all of this function couldn't be factored out (just
like your patch 1/2), by passing palams_cfg_params to the common
function, and possibly adding callback functions to that array so the
common code doesn't have to know how to interpret the parameters
themselves, just how to interpret the top-level structure of parsing.

BTW, there's a typo in the name "palams_cfg_params".

> +static int palmas_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,

If the previous function can be shared, this can too.

> +static int palmas_pinctrl_enable(struct pinctrl_dev *pctldev, unsigned function,
> +		unsigned group)

> +	if (g->mux_reg_base == PALMAS_NONE_BASE) {
> +		if (WARN_ON(function != 0))
> +			return -EINVAL;

What does "0" mean here? Perhaps s/0/GPIO/ ?

> +	for (i = 0; i < ARRAY_SIZE(g->opt); i++) {
> +		if (g->opt[i]->mux_opt == function)
> +			break;
> +	}

So, when I create the Tegra bindings, I created the list of mux
functions by looking at the logical meaning of each register value
(0..3) for each pin, and then made the list of functions have a value
for each logical meaning. This requires a mapping table between the
pinctrl subsystem's mux function values and the HW mux function values,
which is what the loop above implements. Instead, if might be simpler to
just have functions named "0", "1", "2", ... and have all pins support
those functions. This simplifies the driver, and the DT bindings.
Whether doing so would make the DT bindings better probably depends on
exactly how the HW's documentation is written...

> +static int palmas_pinconf_get(struct pinctrl_dev *pctldev,
> +			unsigned pin, unsigned long *config)
> +{
> +	dev_err(pctldev->dev, "pin_config_get op not supported\n");
> +	return -ENOTSUPP;
> +}

Are the pin configuration values applied per pin in HW? If so, you
should probably implement palmas_pinconf_get/set() rather than
palmas_pinconf_group_get/set(). You'd also need to change the DT->map
conversion function to use PIN_MAP_TYPE_CONFIGS_PIN rather than
PIN_MAP_TYPE_CONFIGS_GROUP.

> +static int palmas_pinconf_group_get(struct pinctrl_dev *pctldev,
> +				unsigned group, unsigned long *config)

> +	if (param == PALMAS_PINCONF_PARAM_PULL) {
...
> +		valid_param = true;
> +	}
> +
> +	if (param == PALMAS_PINCONF_PARAM_OPEN_DRAIN) {
...
> +		valid_param = true;
> +	}
> +
> +	if (!valid_param) {
> +		dev_err(pci->dev, "Invalid Parameter\n");

Wouldn't that be simpler as a switch?

> +static int __init palmas_pinctrl_init(void)
> +{
> +	return platform_driver_register(&palmas_pinctrl_driver);
> +}
> +subsys_initcall(palmas_pinctrl_init);

I think that should be module_initcall(), ...
> +
> +static void __exit palmas_pinctrl_exit(void)
> +{
> +	platform_driver_unregister(&palmas_pinctrl_driver);
> +}
> +module_exit(palmas_pinctrl_exit);

... If so, both those functions and macros could be replaced with:

module_platform_driver(palmas_pinctrl_driver);
