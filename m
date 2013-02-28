Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751127Ab3B1GZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 01:25:58 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:53218 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3B1GZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 01:25:56 -0500
Message-ID: <1362032757.32211.10.camel@gitbox>
Subject: Re: [PATCH] pinctrl: gpio: vt8500: Add pin control driver for
 Wondermedia SoCs
From: Tony Prisk <linux@prisktech.co.nz>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org
Date: Thu, 28 Feb 2013 19:25:57 +1300
In-Reply-To: <512E86F4.6000909@wwwdotorg.org>
References: <1360896534-20637-1-git-send-email-linux@prisktech.co.nz>
	 <1360896534-20637-2-git-send-email-linux@prisktech.co.nz>
	 <512E86F4.6000909@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review Stephen,

I have posted replies to most of your points/questions inline.

The review was slightly more in-depth than I expected and as you
noticed, the patch is poor in quality. I was more 'testing the water'
that people were happy with the basic design of the code, rather than
the specifics as I have 4 SoC's worth of data to add, and didn't want to
have to redo it all if I had to make a data format change.

It seems that on the whole the design is ok, so I will post a proper
patch series for this to be reviewed (after addressing the issues you
pointed out).

Regards
Tony Prisk


On Wed, 2013-02-27 at 15:21 -0700, Stephen Warren wrote:
> On 02/14/2013 07:48 PM, Tony Prisk wrote:
> 
> Sorry for the slow review.
> 
> No patch description?
This was never supposed to be a proper patch - I was more looking for a
consensus from 'the world' that this was an acceptable approach before I
populated 4 soc's worth of data.
> 
> >  arch/arm/Kconfig                   |    4 +-
> >  arch/arm/boot/dts/wm8850-w70v2.dts |   15 +
> >  arch/arm/boot/dts/wm8850.dtsi      |    7 +-
> >  arch/arm/mach-vt8500/Kconfig       |    1 +
> >  drivers/pinctrl/Kconfig            |   10 +
> >  drivers/pinctrl/Makefile           |    2 +
> >  drivers/pinctrl/pinctrl-wm8850.c   |  166 +++++++++++
> >  drivers/pinctrl/pinctrl-wmt.c      |  565 ++++++++++++++++++++++++++++++++++++
> >  drivers/pinctrl/pinctrl-wmt.h      |   73 +++++
> 
> No DT binding documentation?
> 
> It doesnt' seem a good idea to add the pinctrl driver and touch the
> various DT files in a single patch.
Again - this is not a proper patch.
> 
> 
> > diff --git a/arch/arm/boot/dts/wm8850.dtsi b/arch/arm/boot/dts/wm8850.dtsi
> 
> > +/*
> >  		gpio: gpio-controller@d8110000 {
> >  			compatible = "wm,wm8650-gpio";
> >  			gpio-controller;
> >  			reg = <0xd8110000 0x10000>;
> >  			#gpio-cells = <3>;
> >  		};
> > +*/
> > +		pinmux: pinmux@d8110000 {
> > +			compatible = "wm,wm8850-gpio";
> > +			reg = <0xd8110000 0x10000>;
> > +		};
> 
> If the old code is wrong, why not delete it? but the main change is just
> removing the GPIO-related properties - is the new driver no longer a
> GPIO provider, why?
New driver is a gpio provider - but wasn't when I pushed this 'preview'.
Old code needs to be removed - is done in a seperate patch so as not to
break current support all in one go.
> 
> > diff --git a/arch/arm/mach-vt8500/Kconfig b/arch/arm/mach-vt8500/Kconfig
> 
> > @@ -29,5 +29,6 @@ config ARCH_WM8850
> >  	depends on ARCH_MULTI_V7
> >  	select ARCH_VT8500
> >  	select CPU_V7
> > +	select PINCTRL
> 
> Don't you want to select the specific pinctrl driver here too; is it
> actually useful for it to be optional?
Its not 'required' so to speak, so I didn't want to force it on anyone
who doesn't particularly want it - Also, there are 4 SoCs to support, so
it would mean selecting them all.
> 
> > diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
> 
> > +config PINCTRL_WM8850
> > +	bool "Wondermedia WM8850 pin controller driver"
> > +	depends on ARCH_VT8500
> > +	select PINCTRL_WMT
> 
> If this is user-visible, there should be a description.
Fixed in the proper patch.

> 
> > diff --git a/drivers/pinctrl/pinctrl-wm8850.c b/drivers/pinctrl/pinctrl-wm8850.c
> 
> > +/* Please keep sorted by bank/bit */
> > +#define WMT_PIN_EXTGPIO0	WMT_PIN(0, 0)
> > +#define WMT_PIN_EXTGPIO1	WMT_PIN(0, 1)
> ...
> > +#define WMT_PIN_I2C2_SCL	WMT_PIN(5, 12)
> > +#define WMT_PIN_I2C2_SDA	WMT_PIN(5, 13)
> 
> There are a lot of gaps in that list. Does the HW really not support pin
> muxing on the rest of the bits in the registers?
Nobody who knows is willing to say :). Most of the code for Wondermedia
SoCs is based of the vendor source that has come out, and we therefore
only know what the vendor has included support for.

No doubt there will be other pins which have valid functions, but we
don't know what they are and don't have support for them at the moment.
The reason I went with the bank/pin encoding is so that if/when we add
other pins, it won't affect any pin numbering.
> 
> > diff --git a/drivers/pinctrl/pinctrl-wmt.c b/drivers/pinctrl/pinctrl-wmt.c
> 
> > +static int wmt_pmx_gpio_set_direction(struct pinctrl_dev *pctldev,
> > +				      struct pinctrl_gpio_range *range,
> > +				      unsigned offset,
> > +				      bool input)
> > +{
> > +	struct wmt_pinctrl_data *data = pinctrl_dev_get_drvdata(pctldev);
> > +#include <linux/pinctrl/consumer.h>
> 
> That should be at the top of the file.
Copy-paste error.
> 
> > +	wmt_set_pinmux(data, (input ? WMT_FSEL_GPIO_IN : WMT_FSEL_GPIO_OUT),
> > +		       offset);
> 
> Nit: The inner brackets are redundant.
Ok.
> 
> > +static int wmt_get_groups_count(struct pinctrl_dev *pctldev)
> > +{
> > +	struct wmt_pinctrl_data *data = pinctrl_dev_get_drvdata(pctldev);
> > +
> > +	return data->ngroups;
> > +}
> > +
> > +static const char *wmt_get_group_name(struct pinctrl_dev *pctldev,
> > +					 unsigned selector)
> > +{
> > +	struct wmt_pinctrl_data *data = pinctrl_dev_get_drvdata(pctldev);
> > +
> > +	return data->groups[selector];
> > +}
> 
> Hmmm. Given there's a 1:1 mapping between pin names and group names, I
> wonder if this core driver shouldn't synthesize the array of group names
> from the array of pins instead of requiring the per-SoC driver to
> duplicate all the pin names in a group array.
Could do.
> 
> Of course, we should probably fix the pinctrl core to allow pin muxing
> on pins in addition to groups too. I keep feeling guilty about not
> having done that before.
Would be nice.
> 
> > +static int wmt_pctl_dt_node_to_map_pull(struct wmt_pinctrl_data *data,
> ...
> > +	struct pinctrl_map *map = *maps;
> > +
> > +
> > +	if (pull > 2) {
> 
> Nit: redundant blank line there.
Oops :)
> 
> > +	configs[0] = 0;
> 
> = pull;?
> 
> > +static struct gpio_chip wmt_gpio_chip = {
> ...
> > +	.can_sleep = 0,
> 
> Nit: No need to set that; 0 is the default for any
> not-explicitly-initialized fields.
OK.
> 
> > +int wmt_pinctrl_probe(struct platform_device *pdev,
> ...
> > +	dev_info(&pdev->dev, "Pin controller initialized\n");
> 
> Nit: I'm never really sure that's useful.
Agreed.


