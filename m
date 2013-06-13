Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353Ab3FMWqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:46:03 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:52290 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757435Ab3FMWqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:46:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@linaro.org>, linux-sh@vger.kernel.org
Subject: Re: [RFC] pinctrl: generic: Add DT bindings
Date: Fri, 14 Jun 2013 00:46:11 +0200
Message-ID: <1489582.v1309hbNQ9@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <51B8878B.5090705@imgtec.com>
References: <1370988237-30593-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <51B8878B.5090705@imgtec.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On Wednesday 12 June 2013 15:36:59 James Hogan wrote:
> On 11/06/13 23:03, Laurent Pinchart wrote:
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
>
> Thanks for this patch. I haven't tested it (yet), but have a few
> comments below.
> 
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
> 
> this is set as a flag, so I think it should be described like tristate,
> "A boolean, ... when set."? Same for pull-up and pull-down (see comment
> below).

Can't the value be used to control schmitt trigger parameters (same as for the 
pull-up and pull-down values, as explained below) ?

> <snip>
> 
> > +	{ "pull-up",		PIN_CONFIG_BIAS_PULL_UP,		false },
> > +	{ "pull-down",		PIN_CONFIG_BIAS_PULL_DOWN,		false },
> 
> pinconf-generic.h says "If the argument is != 0 pull-up is enabled, if
> it is 0, pull-up is disabled", so I think these should be flags unless
> it's changed there first.

== 0 for disabled and != 0 for enabled doesn't mean that all != 0 values are 
equivalent. As I read it drivers can use the value to control the pull-up/down 
strength without violating the documentation.

> Any chance of adding the new "bus-hold" entry too
> (PIN_CONFIG_BIAS_BUS_HOLD, and flag=true I suppose)? see
> aa69352252a7a952e6e77734cb87135143a377d2 in LinuxW's pinctrl for-next
> branch.

Another generic pinconf DT bindings proposal has been submitted and applied to 
the devel branch in Linus' pinctrl tree. It includes support for 
PIN_CONFIG_BIAS_BUS_HOLD. Linus asked me to review the patch, so this one will 
likely be dropped or at least integrated into the other one.

> <snip>
> 
> > +EXPORT_SYMBOL_GPL(pinconf_generic_parse_params);
> > diff --git a/drivers/pinctrl/pinconf.h b/drivers/pinctrl/pinconf.h
> > index 92c7267..eb8550b 100644
> > --- a/drivers/pinctrl/pinconf.h
> > +++ b/drivers/pinctrl/pinconf.h
> > @@ -90,6 +90,23 @@ static inline void pinconf_init_device_debugfs(struct
> > dentry *devroot,> 
> >   * pin config.
> >   */
> > 
> > +#if defined(CONFIG_GENERIC_PINCONF)
> > +
> > +int pinconf_generic_parse_params(struct device *dev, struct device_node
> > *np, +				 unsigned long **cfgs);
> > +
> > +#else
> > +
> > +static inline int pinconf_generic_parse_params(struct device *dev,
> > +					       struct device_node *np,
> > +					       unsigned long **cfgs)
> > +{
> > +	*cfgs = NULL;
> > +	return 0;
> > +}
> 
> Should this ever be necessary? Sounds like if the driver wanted to use
> this it should already have selected GENERIC_PINCONF anyway.

You're right.

-- 
Regards,

Laurent Pinchart

