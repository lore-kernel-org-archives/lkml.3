Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164Ab3E1GtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 02:49:00 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:45531 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702Ab3E1Gs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 02:48:58 -0400
MIME-Version: 1.0
In-Reply-To: <1369412476-14245-7-git-send-email-james.hogan@imgtec.com>
References: <1369412476-14245-1-git-send-email-james.hogan@imgtec.com>
	<1369412476-14245-7-git-send-email-james.hogan@imgtec.com>
Date: Tue, 28 May 2013 08:48:57 +0200
Message-ID: <CACRpkdYaHbX0ixU=ZEbeK6MYnBL3poPwCBkW6O88cBL+LxpdDw@mail.gmail.com>
Subject: Re: [PATCH v2 6/9] pinctrl-tz1090: add TZ1090 pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: James Hogan <james.hogan@imgtec.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James, I want to route this patch by Laurent Pinchart, as he's also
adding device tree support for a SoC using generic pinconf.

Creating new bindings for every pin controller defining the same thing
and implementing the same OF parsers is not sane.

We need to:

- Define generic pinconf bindings
- Implement a common parser for these in drivers/pinctrl/pinconf-generic.c

I'll merge your patches to <linux/pinctrl/pinctrl-generic.h> as a
baseline.

On Fri, May 24, 2013 at 6:21 PM, James Hogan <james.hogan@imgtec.com> wrote:

(...)

> +Optional subnode-properties:
> +- function: A string containing the name of the function to mux to the pin or
> +  group. Valid values for function names are listed below, including which
> +  pingroups can be muxed to them.
> +- tristate: Flag, put pin into high impedance state.
> +- pull-up: Flag, pull pin high.
> +- pull-down: Flag, pull pin low.
> +- bus-hold: Flag, weak latch last value on tristate bus.
> +- schmitt: Integer, enable or disable Schmitt trigger mode for the pins.
> +    0: no hysteresis
> +    1: schmitt trigger
> +- slew-rate: Integer, control slew rate of pins.
> +    0: slow (half frequency)
> +    1: fast
> +- drive-strength: Integer, control drive strength of pins in mA.
> +    2: 2mA
> +    4: 4mA
> +    8: 8mA
> +    12: 12mA

So if you want to use these names they shall be made generic.

Else you have to prefix everything with "tz1090,<property>"

> +/* Describes pinconf properties/flags available from device tree */
> +static const struct cfg_param {
> +       const char *property;
> +       enum pin_config_param param;
> +       bool flag;
> +} cfg_params[] = {
> +       {"tristate",            PIN_CONFIG_BIAS_HIGH_IMPEDANCE,         true},
> +       {"pull-up",             PIN_CONFIG_BIAS_PULL_UP,                true},
> +       {"pull-down",           PIN_CONFIG_BIAS_PULL_DOWN,              true},
> +       {"bus-hold",            PIN_CONFIG_BIAS_BUS_HOLD,               true},
> +       {"schmitt",             PIN_CONFIG_INPUT_SCHMITT_ENABLE,        true},
> +       {"slew-rate",           PIN_CONFIG_SLEW_RATE,                   false},
> +       {"drive-strength",      PIN_CONFIG_DRIVE_STRENGTH,              false},
> +};
> +
> +int tz1090_pinctrl_dt_subnode_to_map(struct device *dev,
> +                                    struct device_node *np,
> +                                    struct pinctrl_map **map,
> +                                    unsigned *reserved_maps,
> +                                    unsigned *num_maps)
> +{
> +       int ret, i;
> +       const char *function;
> +       u32 val;
> +       unsigned long config;
> +       unsigned long *configs = NULL;
> +       unsigned num_configs = 0;
> +       unsigned reserve;
> +       struct property *prop;
> +       const char *group;
> +
> +       ret = of_property_read_string(np, "function", &function);
> +       if (ret < 0) {
> +               /* EINVAL=missing, which is fine since it's optional */
> +               if (ret != -EINVAL)
> +                       dev_err(dev, "could not parse property function\n");
> +               function = NULL;
> +       }
> +
> +       for (i = 0; i < ARRAY_SIZE(cfg_params); i++) {
> +               ret = of_property_read_u32(np, cfg_params[i].property, &val);
> +               /* flags don't have to have a value */
> +               if (ret == -EOVERFLOW && cfg_params[i].flag) {
> +                       val = 1;
> +                       ret = 0;
> +               }
> +               if (!ret) {
> +                       config = pinconf_to_config_packed(cfg_params[i].param,
> +                                                         val);
> +                       ret = add_config(dev, &configs, &num_configs, config);
> +                       if (ret < 0)
> +                               goto exit;
> +               /* EINVAL=missing, which is fine since it's optional */
> +               } else if (ret != -EINVAL) {
> +                       dev_err(dev, "could not parse property %s (%d)\n",
> +                               cfg_params[i].property, ret);
> +               }
> +       }
> +
> +       reserve = 0;
> +       if (function != NULL)
> +               reserve++;
> +       if (num_configs)
> +               reserve++;
> +       ret = of_property_count_strings(np, "pins");
> +       if (ret < 0) {
> +               dev_err(dev, "could not parse property pins\n");
> +               goto exit;
> +       }
> +       reserve *= ret;
> +
> +       ret = reserve_map(dev, map, reserved_maps, num_maps, reserve);
> +       if (ret < 0)
> +               goto exit;
> +
> +       of_property_for_each_string(np, "pins", prop, group) {
> +               if (function) {
> +                       ret = add_map_mux(map, reserved_maps, num_maps,
> +                                         group, function);
> +                       if (ret < 0)
> +                               goto exit;
> +               }
> +
> +               if (num_configs) {
> +                       ret = add_map_configs(dev, map, reserved_maps,
> +                                             num_maps, group, configs,
> +                                             num_configs);
> +                       if (ret < 0)
> +                               goto exit;
> +               }
> +       }
> +
> +       ret = 0;
> +
> +exit:
> +       kfree(configs);
> +       return ret;
> +}

This is looking good. Can you split out the pin config mapping in
some way and put that into pinconf-generic.c?

Yours,
Linus Walleij
