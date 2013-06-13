Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364Ab3FMWjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:39:25 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:52253 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757849Ab3FMWjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:39:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@linaro.org>,
        James Hogan <james.hogan@imgtec.com>, linux-sh@vger.kernel.org
Subject: Re: [RFC] pinctrl: generic: Add DT bindings
Date: Fri, 14 Jun 2013 00:39:33 +0200
Message-ID: <2555796.PtkImJGaK8@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <20130612124833.A3ADB3E0A56@localhost>
References: <1370988237-30593-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <20130612124833.A3ADB3E0A56@localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Thanks for the review.

On Wednesday 12 June 2013 13:48:33 Grant Likely wrote:
> On Wed, 12 Jun 2013 00:03:57 +0200, Laurent Pinchart wrote:
> > Document DT properties for the generic pinctrl parameters and add a
> > parser function.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  .../bindings/pinctrl/pinctrl-bindings.txt          | 29 +++++++
> >  drivers/pinctrl/pinconf-generic.c                  | 94 +++++++++++++++++
> >  drivers/pinctrl/pinconf.h                          | 17 ++++
> >  3 files changed, 140 insertions(+)
> > 
> > I've successfully tested this patch (or more accurately only the pull-up
> > and pull-down properties) with the Renesas sh-pfc pinctrl device driver.
> > I will resent the sh-pfc DT bindings patch series rebased on the generic
> > pinconf bindings.
> > 
> > Not all generic pinconf properties are currently implemented, but I don't
> > think that should be a showstopper. We can add them later as needed.
> > 
> > The code is based on both the sh-pfc pinconf DT parser and James Hogan's
> > tz1090 DT parser ("[PATCH v2 6/9] pinctrl-tz1090: add TZ1090 pinctrl
> > driver").
> > 
> > diff --git
> > a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> > b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt index
> > c95ea82..e499ff0 100644
> > --- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> > +++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> > @@ -126,3 +126,32 @@ device; they may be grandchildren, for example.
> > Whether this is legal, and> 
> >  whether there is any interaction between the child and intermediate
> >  parent nodes, is again defined entirely by the binding for the individual
> >  pin controller device.
> > 
> > +
> > +== Generic pinconf parameters ==
> > +
> > +Pin configuration parameters are expressed by DT properties in the pin
> > +controller device state nodes and child nodes. For devices that use the
> > generic +pinconf parameters the following properties are defined.
> > +
> > +- tristate: A boolean, put the pin into high impedance state when set.
> > +
> > +- pull-up: An integer representing the pull-up strength. 0 disables the
> > pull-up, +  non-zero values enable it.
> > +
> > +- pull-down: An integer representing the pull-down strength. 0 disables
> > the +  pull-down, non-zero values enables it.
> > +
> > +- schmitt: An integer, enable or disable Schmitt trigger mode for the
> > pins. +  Valid values are
> > +    0: Schmitt trigger disabled (no hysteresis)
> > +    1: Schmitt trigger enabled
> > +
> > +- slew-rate: An integer controlling the pin slew rate. Values are device-
> > +  dependent.
> > +
> > +- drive-strength: An integer representing the drive strength of pins in
> > mA. +  Valid values are device-dependent.
> > +
> > +The pinctrl device DT bindings documentation must list the properties
> > that
> > +apply to the device, and define the valid range for all device-dependent
> > +values.
> 
> I don't see any problem with the above properties, but I would like to
> see an example. How verbose will a pinctrl node using the generic
> properties tend to be?

Here's a real-life example

&pfc {
        pinctrl-0 = <&scifa4_pins>;
        pinctrl-names = "default";

        mmcif_pins: mmcif {
                mux {
                        renesas,groups = "mmc0_data8_0", "mmc0_ctrl_0";
                        renesas,function = "mmc0";
                };
                cfg {
                        renesas,groups = "mmc0_data8_0";
                        renesas,pins = "PORT279";
                        bias-pull-up = <1>;
                };
        };

        scifa4_pins: scifa4 {
                renesas,groups = "scifa4_data", "scifa4_ctrl";
                renesas,function = "scifa4";
        };
};

The mux node selects function mmc0 on two pin groups, and the cfg node 
activates pull-ups on one pin group and one particular pin.

> > diff --git a/drivers/pinctrl/pinconf-generic.c
> > b/drivers/pinctrl/pinconf-generic.c index 2ad5a8d..bd0e41d 100644
> > --- a/drivers/pinctrl/pinconf-generic.c
> > +++ b/drivers/pinctrl/pinconf-generic.c
> > @@ -15,6 +15,7 @@
> > 
> >  #include <linux/module.h>
> >  #include <linux/init.h>
> >  #include <linux/device.h>
> > 
> > +#include <linux/of.h>
> > 
> >  #include <linux/slab.h>
> >  #include <linux/debugfs.h>
> >  #include <linux/seq_file.h>
> > 
> > @@ -135,3 +136,96 @@ void pinconf_generic_dump_config(struct pinctrl_dev
> > *pctldev,> 
> >  }
> >  EXPORT_SYMBOL_GPL(pinconf_generic_dump_config);
> >  #endif
> > 
> > +
> > +struct pinconf_generic_param {
> > +	const char *property;
> > +	enum pin_config_param param;
> > +	bool flag;
> > +};
> > +
> > +static const struct pinconf_generic_param pinconf_generic_params[] = {
> > +	{ "tristate",		PIN_CONFIG_BIAS_HIGH_IMPEDANCE,		true },
> > +	{ "pull-up",		PIN_CONFIG_BIAS_PULL_UP,		false },
> > +	{ "pull-down",		PIN_CONFIG_BIAS_PULL_DOWN,		false },
> > +	{ "schmitt",		PIN_CONFIG_INPUT_SCHMITT_ENABLE,	true },
> > +	{ "slew-rate",		PIN_CONFIG_SLEW_RATE,			false },
> > +	{ "drive-strength",	PIN_CONFIG_DRIVE_STRENGTH,		false },
> > +};
> > +
> > +static int pinconf_generic_add_config(unsigned long **configs,
> > +				      unsigned int *num_configs,
> > +				      unsigned long config)
> > +{
> > +	unsigned int count = *num_configs + 1;
> > +	unsigned long *cfgs;
> > +
> > +	cfgs = krealloc(*configs, sizeof(*cfgs) * count, GFP_KERNEL);
> > +	if (cfgs == NULL)
> > +		return -ENOMEM;
> > +
> > +	cfgs[count - 1] = config;
> > +
> > +	*configs = cfgs;
> > +	*num_configs = count;
> > +
> > +	return 0;
> > +}
> 
> Hmmm. We really need a better method of parsing multiple properties.
> I've been toying around with a few ideas, but haven't been able to draft
> something I'm happy with yeat.
> 
> Regardless, the code in this patch looks fine to me.

Thanks. As other generic pinconf DT bindings proposals have been submitted I 
will resent this patch set with pinconf support stripped out to make sure it 
gets to v3.11 and will then add pinconf back in follow-up patches for v3.11 or 
v3.12, depending on when we can agree on generic pinconf bindings.

-- 
Regards,

Laurent Pinchart

