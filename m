Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232AbaAGMEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:04:44 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:7777 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaAGMEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:04:38 -0500
Date: Tue, 7 Jan 2014 13:04:01 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frodo Looijaard <frodol@dds.nl>,
        lm-sensors@lm-sensors.org, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, linux-pm@vger.kernel.org
Subject: Re: [PATCH] hwmon/sensors: fix SENSORS_LM75 dependencies
Message-ID: <20140107130401.23bffcd2@endymion.delvare>
In-Reply-To: <52CB65DA.2010103@roeck-us.net>
References: <20140106204020.b47e53cc3ead8f90164ef5b7@canb.auug.org.au>
	<52CB0948.6030702@infradead.org>
	<20140106203209.GA21630@roeck-us.net>
	<52CB53DC.4030901@infradead.org>
	<52CB65DA.2010103@roeck-us.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter, Randy,

On Mon, 06 Jan 2014 18:26:34 -0800, Guenter Roeck wrote:
> On 01/06/2014 05:09 PM, Randy Dunlap wrote:
> > From: Randy Dunlap <rdunlap@infradead.org>
> >
> > Fix SENSORS_LM75 dependencies to eliminate build errors:
> >
> > drivers/built-in.o: In function `lm75_remove':
> > lm75.c:(.text+0x12bd8c): undefined reference to `thermal_zone_of_sensor_unregister'
> > drivers/built-in.o: In function `lm75_probe':
> > lm75.c:(.text+0x12c123): undefined reference to `thermal_zone_of_sensor_register'
> >
> > Add depends on THERMAL_OF since that is what provides the
> > register/unregister functions above.
> >
> > Add depends on THERMAL since THERMAL is a tristate (while THERMAL_OF
> > is a bool) and SENSORS_LM75 (tristate) needs to be limited to modular
> > builds when THERMAL=m.
> >
> > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > ---
> >   drivers/hwmon/Kconfig |    2 ++
> >   1 file changed, 2 insertions(+)
> >
> > --- linux-next-20140106.orig/drivers/hwmon/Kconfig
> > +++ linux-next-20140106/drivers/hwmon/Kconfig
> > @@ -650,6 +650,8 @@ config SENSORS_LM73
> >   config SENSORS_LM75
> >   	tristate "National Semiconductor LM75 and compatibles"
> >   	depends on I2C
> > +	depends on THERMAL
> > +	depends on THERMAL_OF
> >   	help
> >   	  If you say yes here you get support for one common type of
> >   	  temperature sensor chip, with models including:
> >
> >
> NACK. The driver does not and must not depend on THERMAL.

Correct.

> This needs to be addressed
> in the thermal code, for example with dummy declarations if THERMAL=m but
> SENSORS_LM75=y. The functions are already declared as dummies if THERMAL_OF=n.

This won't fly I'm afraid, the number of hwmon drivers affected will
grow in the future and you certainly don't want to have to change the
generic thermal code every time a new driver is added/converted.

I've looked at the problem this morning and I will admit I do not even
understand what the problem is. In Randy's config, CONFIG_THERMAL_OF=y
so both thermal_zone_of_sensor_unregister and
thermal_zone_of_sensor_register are built-in. SENSORS_LM75=y so the
calls to these functions are built-in too. I just can't see how this
can be a problem at link time. Can anyone enlighten me?

-- 
Jean Delvare
