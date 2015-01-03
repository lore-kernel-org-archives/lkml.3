Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbbACWCY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 17:02:24 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43789 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbbACWCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 17:02:22 -0500
Date: Sat, 3 Jan 2015 23:02:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Eduardo Valentin <edubezval@gmail.com>, nm@ti.com
Cc: rui.zhang@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, pali.rohar@gmail.com, sre@debian.org,
        sre@ring0.de, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com
Subject: Re: [PATCH] thermal: add omap3 support
Message-ID: <20150103220219.GA26747@amd>
References: <20150103111146.GB7065@amd>
 <20150103123426.GA26069@developer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150103123426.GA26069@developer>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Thanks for sending your code.

You are welcome.

> > Add support for omap3430 sensor. Tested on Nokia N900.
> 
> To my understanding, and as already mentioned by Nishanth Menon
> (currently TIer), TI has intentionally avoided adding this support.

Well, Nokia had similar code in their kernel.

> There is a hardware accuracy limitation in this sensor, and therefore it
> is not advisable to use it, specially in Dynamic Thermal Management,
> such as the thermal framework.

We are talking cellphone here. Yes, sensor may be inacurate (but it
seems to work pretty well; perhaps TI can point us to some docs that
explains the details?), but it provides useful information (mostly
room temperature). I don't think we'll ever run anywhere close to
thermal limits where inacuracy would matter. (Battery can't really
take > 60C. AFAICT CPU limit is 120C. Battery is close to the CPU.)

> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > 
> > diff --git a/drivers/thermal/ti-soc-thermal/Kconfig b/drivers/thermal/ti-soc-thermal/Kconfig
> > index bd4c7be..a49495f 100644
> > --- a/drivers/thermal/ti-soc-thermal/Kconfig
> > +++ b/drivers/thermal/ti-soc-thermal/Kconfig
> > @@ -21,6 +21,15 @@ config TI_THERMAL
> >  	  This includes trip points definitions, extrapolation rules and
> >  	  CPU cooling device bindings.
> >  
> > +config OMAP3_THERMAL
> > +	bool "Texas Instruments OMAP3 thermal support"
> > +	depends on TI_SOC_THERMAL
> > +	depends on ARCH_OMAP3
> > +	help
> > +	  If you say yes here you get thermal support for the Texas Instruments
> > +	  OMAP3 SoC family. The current chip supported are:
> > +	   - OMAP3430
> 
> But if you insist :-), I believe the user deserves at least a fair
> message saying this is on his / her own risk.

Something like this?

          If you say yes here you get thermal support for the Texas Instruments
	  OMAP3 SoC family. The current chip supported are:
	              - OMAP3430

          OMAP3 chips normally don't need thermal management, and sensors in
	  this generation are not very accurate, nor they are very close to
          the important hotspots.

          Say 'N' here.
	  

> > +static struct temp_sensor_registers
> > +omap34xx_mpu_temp_sensor_registers = {
> > +	.temp_sensor_ctrl = 0,
> > +	.bgap_tempsoff_mask = 0, /* Unused, we don't have POWER_SWITCH */
> > +	.bgap_soc_mask = BIT(8),
> > +	.bgap_eocz_mask = BIT(7),
> > +	.bgap_dtemp_mask = 0x7f,
> > +
> > +	.bgap_mode_ctrl = 0,
> > +	.mode_ctrl_mask = BIT(9),
> > +
> > +	.bgap_efuse = 0,
> 
> The 0'ed filed may be removed here.

Ok; I'll keep temp_sensors_ctrl / bgap_mode_ctrl, because it is actually used.


> > diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> > index 634b6ce..3b4e72f 100644
> > --- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> > +++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> > @@ -1509,6 +1531,12 @@ static SIMPLE_DEV_PM_OPS(ti_bandgap_dev_pm_ops, ti_bandgap_suspend,
> >  #endif
> >  
> >  static const struct of_device_id of_ti_bandgap_match[] = {
> > +#ifdef CONFIG_OMAP3_THERMAL
> > +	{
> > +		.compatible = "ti,omap34xx-bandgap",
> 
> This needs to be updated in the binding documentation.
> Documentation/devicetree/bindings/thermal/ti_soc_thermal.txt

Ok.

> > +		.data = (void *)&omap34xx_data,
> 
> 
> Having a run time message intentionally advising users of the risk of
> using this sensor is also required.

Ok, what about?

    if (TI_BANDGAP_HAS(bgp, UNRELIABLE))
              dev_warn(&pdev->dev,
                         "OMAP3 thermal sensor is unreliable and normally unneccessary\n");

Will not fit in 80 columns, but keeping message on one line is more important.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
