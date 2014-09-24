Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaIXVNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:13:38 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:41441 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaIXVNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:13:37 -0400
Date: Wed, 24 Sep 2014 14:13:32 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: atull <atull@opensource.altera.com>
Cc: jdelvare@suse.de, lm-sensors@lm-sensors.org, lgirdwood@gmail.com,
        broonie@kernel.org, linux-kernel@vger.kernel.org,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Subject: Re: [PATCH v3 3/3] pmbus: ltc2978: add regulator support
Message-ID: <20140924211332.GA2720@roeck-us.net>
References: <1411581476-12222-1-git-send-email-atull@opensource.altera.com>
 <1411581476-12222-4-git-send-email-atull@opensource.altera.com>
 <20140924201934.GB25362@roeck-us.net>
 <alpine.DEB.2.02.1409241536530.9901@atx-linux-37>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1409241536530.9901@atx-linux-37>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 03:48:40PM -0500, atull wrote:
> On Wed, 24 Sep 2014, Guenter Roeck wrote:
> 
> Hi Guenter,
> 
> > On Wed, Sep 24, 2014 at 12:57:56PM -0500, atull@opensource.altera.com wrote:
> > > From: Alan Tull <atull@opensource.altera.com>
> > > 
> > > Add simple on/off regulator support for ltc2978 and
> > > other pmbus parts supported by ltc2978.c
> > > 
> > > Signed-off-by: Alan Tull <atull@opensource.altera.com>
> > > 
> > > v2: Remove '#include <linux/regulator/machine.h>'
> > >     Only one regulator per pmbus device
> > >     Get regulator_init_data from pdata or device tree
> > > 
> > > v3: Support multiple regulators for each chip
> > >     Move most code to pmbus_core.c
> > >     fixed values for on/off
> > > ---
> > >  drivers/hwmon/pmbus/Kconfig   |    7 ++++++
> > >  drivers/hwmon/pmbus/ltc2978.c |   51 +++++++++++++++++++++++++++++++++++++++++
> > 
> > This will also require devicetree documentation describing the device nodes.
> 
> Yes, I'll add that as a separate patch to v4.  It will be a new file since
> there currently isn't any pmbus or ltc2978 bindings documentation that I
> could find.
> 

Hi Alan,

It wasn't needed so far... just describe the bindings for ltc2978.

> > 
> > >  2 files changed, 58 insertions(+)
> > > 
> > > diff --git a/drivers/hwmon/pmbus/Kconfig b/drivers/hwmon/pmbus/Kconfig
> > > index 6e1e493..79117b7 100644
> > > --- a/drivers/hwmon/pmbus/Kconfig
> > > +++ b/drivers/hwmon/pmbus/Kconfig
> > > @@ -56,6 +56,13 @@ config SENSORS_LTC2978
> > >  	  This driver can also be built as a module. If so, the module will
> > >  	  be called ltc2978.
> > >  
> > > +config SENSORS_LTC2978_REGULATOR
> > > +	boolean "Regulator support for LTC2974, LTC2978, LTC3880, and LTC3883"
> > > +	depends on SENSORS_LTC2978 && REGULATOR
> > > +	help
> > > +	  If you say yes here you get regulator support for Linear
> > > +	  Technology LTC2974, LTC2978, LTC3880, and LTC3883.
> > > +
> > >  config SENSORS_MAX16064
> > >  	tristate "Maxim MAX16064"
> > >  	default n
> > > diff --git a/drivers/hwmon/pmbus/ltc2978.c b/drivers/hwmon/pmbus/ltc2978.c
> > > index e24ed52..7d4dcd7 100644
> > > --- a/drivers/hwmon/pmbus/ltc2978.c
> > > +++ b/drivers/hwmon/pmbus/ltc2978.c
> > > @@ -22,6 +22,8 @@
> > >  #include <linux/err.h>
> > >  #include <linux/slab.h>
> > >  #include <linux/i2c.h>
> > > +#include <linux/regulator/driver.h>
> > > +#include <linux/regulator/of_regulator.h>
> > >  #include "pmbus.h"
> > >  
> > >  enum chips { ltc2974, ltc2977, ltc2978, ltc3880, ltc3883, ltm4676 };
> > > @@ -374,6 +376,30 @@ static const struct i2c_device_id ltc2978_id[] = {
> > >  };
> > >  MODULE_DEVICE_TABLE(i2c, ltc2978_id);
> > >  
> > > +#if IS_ENABLED(CONFIG_SENSORS_LTC2978_REGULATOR)
> > > +static const struct regulator_desc ltc2978_reg_desc[] = {
> > > +	PMBUS_REGULATOR("vout_en", 0),
> > > +	PMBUS_REGULATOR("vout_en", 1),
> > > +	PMBUS_REGULATOR("vout_en", 2),
> > > +	PMBUS_REGULATOR("vout_en", 3),
> > > +	PMBUS_REGULATOR("vout_en", 4),
> > > +	PMBUS_REGULATOR("vout_en", 5),
> > > +	PMBUS_REGULATOR("vout_en", 6),
> > > +	PMBUS_REGULATOR("vout_en", 7),
> > 
> > How about just vout[0-7] ? I don't see a value in "_en".
> 
> That's cool.  I'll do it.
> 
> > 
> > > +};
> > > +
> > > +static struct of_regulator_match ltc2978_reg_matches[] = {
> > > +	{ .name = "vout_en0" },
> > > +	{ .name = "vout_en1" },
> > > +	{ .name = "vout_en2" },
> > > +	{ .name = "vout_en3" },
> > > +	{ .name = "vout_en4" },
> > > +	{ .name = "vout_en5" },
> > > +	{ .name = "vout_en6" },
> > > +	{ .name = "vout_en7" },
> > 
> > If there are multiple LTC chips in the system, this will result in duplicate
> > regulator names. Does that matter ? Any ideas how other regulators handle this ?
> > 
> > Example on my test system:
> > 
> > root@localhost:/sys/class/regulator# grep vout_en0 */name
> > regulator.15/name:vout_en0
> > regulator.2/name:vout_en0
> > regulator.23/name:vout_en0
> > regulator.31/name:vout_en0
> > regulator.39/name:vout_en0
> > regulator.47/name:vout_en0
> 
> These are just default names, but I think I could make the name better.
> How about <part #>-<i2c address>-vout<#> such as "ltc2978-5c-vout0"
> 
Problem with that is that i2c bus numbers are not static, which would
make it quite difficult to describe the regulator in devicetree data.

Any idea what other regulators do in such situations ?

Guenter
