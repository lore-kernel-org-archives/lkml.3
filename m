Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab3FLOha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 10:37:30 -0400
Received: from multi.imgtec.com ([194.200.65.239]:43020 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606Ab3FLOh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 10:37:27 -0400
Message-ID: <51B8878B.5090705@imgtec.com>
Date: Wed, 12 Jun 2013 15:36:59 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Linus Walleij <linus.walleij@linaro.org>, <linux-sh@vger.kernel.org>
Subject: Re: [RFC] pinctrl: generic: Add DT bindings
References: <1370988237-30593-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1370988237-30593-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_06_12_15_37_24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/13 23:03, Laurent Pinchart wrote:
> Document DT properties for the generic pinctrl parameters and add a
> parser function.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  .../bindings/pinctrl/pinctrl-bindings.txt          | 29 +++++++
>  drivers/pinctrl/pinconf-generic.c                  | 94 ++++++++++++++++++++++
>  drivers/pinctrl/pinconf.h                          | 17 ++++
>  3 files changed, 140 insertions(+)
> 
> I've successfully tested this patch (or more accurately only the pull-up and
> pull-down properties) with the Renesas sh-pfc pinctrl device driver. I will
> resent the sh-pfc DT bindings patch series rebased on the generic pinconf
> bindings.
> 
> Not all generic pinconf properties are currently implemented, but I don't
> think that should be a showstopper. We can add them later as needed.
> 
> The code is based on both the sh-pfc pinconf DT parser and James Hogan's
> tz1090 DT parser ("[PATCH v2 6/9] pinctrl-tz1090: add TZ1090 pinctrl driver").

Thanks for this patch. I haven't tested it (yet), but have a few
comments below.

> 
> diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> index c95ea82..e499ff0 100644
> --- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> +++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> @@ -126,3 +126,32 @@ device; they may be grandchildren, for example. Whether this is legal, and
>  whether there is any interaction between the child and intermediate parent
>  nodes, is again defined entirely by the binding for the individual pin
>  controller device.
> +
> +== Generic pinconf parameters ==
> +
> +Pin configuration parameters are expressed by DT properties in the pin
> +controller device state nodes and child nodes. For devices that use the generic
> +pinconf parameters the following properties are defined.
> +
> +- tristate: A boolean, put the pin into high impedance state when set.
> +
> +- pull-up: An integer representing the pull-up strength. 0 disables the pull-up,
> +  non-zero values enable it.
> +
> +- pull-down: An integer representing the pull-down strength. 0 disables the
> +  pull-down, non-zero values enables it.
> +
> +- schmitt: An integer, enable or disable Schmitt trigger mode for the pins.
> +  Valid values are
> +    0: Schmitt trigger disabled (no hysteresis)
> +    1: Schmitt trigger enabled

this is set as a flag, so I think it should be described like tristate,
"A boolean, ... when set."? Same for pull-up and pull-down (see comment
below).

<snip>

> +	{ "pull-up",		PIN_CONFIG_BIAS_PULL_UP,		false },
> +	{ "pull-down",		PIN_CONFIG_BIAS_PULL_DOWN,		false },

pinconf-generic.h says "If the argument is != 0 pull-up is enabled, if
it is 0, pull-up is disabled", so I think these should be flags unless
it's changed there first.

Any chance of adding the new "bus-hold" entry too
(PIN_CONFIG_BIAS_BUS_HOLD, and flag=true I suppose)? see
aa69352252a7a952e6e77734cb87135143a377d2 in LinuxW's pinctrl for-next
branch.

<snip>

> +EXPORT_SYMBOL_GPL(pinconf_generic_parse_params);
> diff --git a/drivers/pinctrl/pinconf.h b/drivers/pinctrl/pinconf.h
> index 92c7267..eb8550b 100644
> --- a/drivers/pinctrl/pinconf.h
> +++ b/drivers/pinctrl/pinconf.h
> @@ -90,6 +90,23 @@ static inline void pinconf_init_device_debugfs(struct dentry *devroot,
>   * pin config.
>   */
>  
> +#if defined(CONFIG_GENERIC_PINCONF)
> +
> +int pinconf_generic_parse_params(struct device *dev, struct device_node *np,
> +				 unsigned long **cfgs);
> +
> +#else
> +
> +static inline int pinconf_generic_parse_params(struct device *dev,
> +					       struct device_node *np,
> +					       unsigned long **cfgs)
> +{
> +	*cfgs = NULL;
> +	return 0;
> +}

Should this ever be necessary? Sounds like if the driver wanted to use
this it should already have selected GENERIC_PINCONF anyway.

Cheers
James

