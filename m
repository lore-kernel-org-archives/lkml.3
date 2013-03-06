Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab3CFCl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 21:41:56 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18235 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab3CFClw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 21:41:52 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 05 Mar 2013 18:41:47 -0800
From: Andrew Chew <AChew@nvidia.com>
To: Alex Courbot <acourbot@nvidia.com>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 5 Mar 2013 18:41:46 -0800
Subject: RE: [PATCH 1/1 v3] pwm_bl: Add support for backlight enable
 regulator
Thread-Topic: [PATCH 1/1 v3] pwm_bl: Add support for backlight enable
 regulator
Thread-Index: Ac4aEO2uCAT9fIxRQOScI2NSJkIDjAAAkFUg
Message-ID: <643E69AA4436674C8F39DCC2C05F7638629BFE1DB7@HQMAIL03.nvidia.com>
References: <1362527485-8611-1-git-send-email-achew@nvidia.com>
 <5136A781.2050303@nvidia.com>
In-Reply-To: <5136A781.2050303@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Alex!  Makes sense to me.  There's one comment I'm not sure about,
though, described inline.

> On 03/06/2013 08:51 AM, Andrew Chew wrote:
> > The backlight enable regulator is specified in the device tree node
> > for backlight.
> >
> > Signed-off-by: Andrew Chew <achew@nvidia.com>
> > ---
> > Applied all recommendations from Thierry Reding and Alex Courbot,
> > including making pwm_bl take an optional regulator instead of a GPIO,
> > which solves the platform data issue (platform data will default the
> > regulator to NULL, which is the right thing).
> >
> >   .../bindings/video/backlight/pwm-backlight.txt     |    1 +
> >   drivers/video/backlight/pwm_bl.c                   |   53 +++++++++++++++++---
> >   include/linux/pwm_backlight.h                      |    1 +
> >   3 files changed, 48 insertions(+), 7 deletions(-)
> >
> > diff --git
> > a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> > b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> > index 1e4fc72..e0bccd30 100644
> > ---
> > a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> > +++ b/Documentation/devicetree/bindings/video/backlight/pwm-
> backlight.
> > +++ txt
> > @@ -14,6 +14,7 @@ Required properties:
> >   Optional properties:
> >     - pwm-names: a list of names for the PWM devices specified in the
> >                  "pwms" property (see PWM binding[0])
> > +  - en-supply: phandle to the regulator device tree node
> 
> You may want to specify what this regulator does - namely, that is enables
> the BL. May I also suggest to rename it to "enable-supply" since the other
> properties do not use abbreviations.
> 
> >   [0]: Documentation/devicetree/bindings/pwm/pwm.txt
> >
> > diff --git a/drivers/video/backlight/pwm_bl.c
> > b/drivers/video/backlight/pwm_bl.c
> > index 069983c..c4da5e2 100644
> > --- a/drivers/video/backlight/pwm_bl.c
> > +++ b/drivers/video/backlight/pwm_bl.c
> > @@ -20,10 +20,13 @@
> >   #include <linux/pwm.h>
> >   #include <linux/pwm_backlight.h>
> >   #include <linux/slab.h>
> > +#include <linux/regulator/consumer.h>
> >
> >   struct pwm_bl_data {
> >   	struct pwm_device	*pwm;
> >   	struct device		*dev;
> > +	struct regulator	*en_supply;
> > +	bool			en_supply_enabled;
> 
> Couldn't you use regulator_is_enabled() and get rid of en_supply_enabled?
> It would also ensure the driver performs correctly no matter what the initial
> state of the regulator is.

Are you sure this works?  I'm concerned about the (bizarre and unlikely) case
where this supply is shared with another driver, so I use en_supply_enabled
to track the state of the supply such that I can ignore that case.

> >   	unsigned int		period;
> >   	unsigned int		lth_brightness;
> >   	unsigned int		*levels;
> > @@ -35,6 +38,34 @@ struct pwm_bl_data {
> >   	void			(*exit)(struct device *);
> >   };
> >
> > +static void pwm_backlight_enable(struct backlight_device *bl) {
> > +	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
> > +
> > +	pwm_enable(pb->pwm);
> > +
> > +	if (pb->en_supply && !pb->en_supply_enabled) {
> > +		if (regulator_enable(pb->en_supply) != 0)
> > +			dev_warn(&bl->dev, "Failed to enable regulator");
> > +		else
> > +			pb->en_supply_enabled = true;
> > +	}
> > +}
> > +
> > +static void pwm_backlight_disable(struct backlight_device *bl) {
> > +	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
> > +
> > +	if (pb->en_supply && pb->en_supply_enabled) {
> > +		if (regulator_disable(pb->en_supply) != 0)
> > +			dev_warn(&bl->dev, "Failed to disable regulator");
> > +		else
> > +			pb->en_supply_enabled = false;
> > +	}
> > +
> > +	pwm_disable(pb->pwm);
> > +}
> > +
> >   static int pwm_backlight_update_status(struct backlight_device *bl)
> >   {
> >   	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev); @@ -52,7
> +83,7
> > @@ static int pwm_backlight_update_status(struct backlight_device *bl)
> >
> >   	if (brightness == 0) {
> >   		pwm_config(pb->pwm, 0, pb->period);
> > -		pwm_disable(pb->pwm);
> > +		pwm_backlight_disable(bl);
> >   	} else {
> >   		int duty_cycle;
> >
> > @@ -66,7 +97,7 @@ static int pwm_backlight_update_status(struct
> backlight_device *bl)
> >   		duty_cycle = pb->lth_brightness +
> >   		     (duty_cycle * (pb->period - pb->lth_brightness) / max);
> >   		pwm_config(pb->pwm, duty_cycle, pb->period);
> > -		pwm_enable(pb->pwm);
> > +		pwm_backlight_enable(bl);
> >   	}
> >
> >   	if (pb->notify_after)
> > @@ -146,10 +177,17 @@ static int pwm_backlight_parse_dt(struct device
> *dev,
> >   	}
> >
> >   	/*
> > -	 * TODO: Most users of this driver use a number of GPIOs to control
> > -	 *       backlight power. Support for specifying these needs to be
> > -	 *       added.
> > +	 * If "en-supply" is present, use that regulator to enable the
> > +	 * backlight.  If a GPIO is used to enable the backlight, make
> > +	 * a fixed regulator with that particular GPIO and use that
> > +	 * regulator for "en-supply".
> >   	 */
> > +	data->en_supply = devm_regulator_get(dev, "en");
> > +	if (IS_ERR_OR_NULL(data->en_supply)) {
> 
> devm_regulator_get() is performed at the wrong place, but I will come back
> to this later. As a sidenote though: you should use IS_ERR here.
> regulator_get() will never return NULL - also using IS_ERR_OR_NULL is
> strongly discouraged and it will probably disappear soon anyway:
> 
> https://patchwork.kernel.org/patch/1953211/
> 
> > +		ret = PTR_ERR(data->en_supply);
> 
> ... and this is the reason why you should use IS_ERR: because in the
> (impossible anyway) error case where regulator_get() returns NULL, you will
> return 0 (success).
> 
> > +		data->en_supply = NULL;
> > +		return ret;
> > +	}
> >
> >   	return 0;
> >   }
> > @@ -207,6 +245,7 @@ static int pwm_backlight_probe(struct
> platform_device *pdev)
> >   	} else
> >   		max = data->max_brightness;
> >
> > +	pb->en_supply = data->en_supply;
> >   	pb->notify = data->notify;
> >   	pb->notify_after = data->notify_after;
> >   	pb->check_fb = data->check_fb;
> > @@ -268,7 +307,7 @@ static int pwm_backlight_remove(struct
> > platform_device *pdev)
> >
> >   	backlight_device_unregister(bl);
> >   	pwm_config(pb->pwm, 0, pb->period);
> > -	pwm_disable(pb->pwm);
> > +	pwm_backlight_disable(bl);
> >   	if (pb->exit)
> >   		pb->exit(&pdev->dev);
> >   	return 0;
> > @@ -283,7 +322,7 @@ static int pwm_backlight_suspend(struct device
> *dev)
> >   	if (pb->notify)
> >   		pb->notify(pb->dev, 0);
> >   	pwm_config(pb->pwm, 0, pb->period);
> > -	pwm_disable(pb->pwm);
> > +	pwm_backlight_disable(bl);
> >   	if (pb->notify_after)
> >   		pb->notify_after(pb->dev, 0);
> >   	return 0;
> > diff --git a/include/linux/pwm_backlight.h
> > b/include/linux/pwm_backlight.h index 56f4a86..330512b 100644
> > --- a/include/linux/pwm_backlight.h
> > +++ b/include/linux/pwm_backlight.h
> > @@ -8,6 +8,7 @@
> >
> >   struct platform_pwm_backlight_data {
> >   	int pwm_id;
> > +	struct regulator *en_supply;
> 
> You should not have this here. Platform data is supposed to provide the
> necessary information for the driver to resolve the resource - not the
> resource itself.
> 
> Instead machines that rely on platform data will associate the right regulator
> to the backlight device in their board code, through an instance of the
> regulator_consumer_supply structure (see
> include/linux/regulator/machine.h), and submit it to the regulator
> framework. Thus it is enough for you to just perform a call to
> devm_regulator_get() in the probe function, and the regulator framework
> will resolve the right regulator through the device tree or the provided
> platform data. I.e. you don't have to worry about whether you are using the
> DT or platform data here.
> 
> There is one catch though: in case you don't want to use a regulator, and thus
> have none defined, regulator_get() will return -EPROBE_DEFER, so you
> cannot distinguish between "no regulator needed" and "supplier not ready
> yet" and your driver will always *require* a regulator. So at the end of the
> day you might still need a "use_enable_regulator" in the platform data to
> explicitly ask for probe() to look for it. This variable would also be set by
> parse_dt() if the "enable-supply" property exists.
> 
> But this somehow kills the purpose of using a regulator here, since part of
> the motivation was to avoid this boolean variable. Maybe Thierry has a better
> idea.
> 
> I like the general idea of this patch however - with this and a couple of
> always-on regulators we should be able to enable the panels of some Tegra
> boards until the CDF gets merged. It won't be optimal from a power point of
> view, but at least we will finally see something. :)
> 
> Alex.

