Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaIXUys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:54:48 -0400
Received: from mail-bn1on0078.outbound.protection.outlook.com ([157.56.110.78]:9628
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750725AbaIXUyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:54:47 -0400
Date: Wed, 24 Sep 2014 15:48:40 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Guenter Roeck <linux@roeck-us.net>
CC: <jdelvare@suse.de>, <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v3 3/3] pmbus: ltc2978: add regulator support
In-Reply-To: <20140924201934.GB25362@roeck-us.net>
Message-ID: <alpine.DEB.2.02.1409241536530.9901@atx-linux-37>
References: <1411581476-12222-1-git-send-email-atull@opensource.altera.com> <1411581476-12222-4-git-send-email-atull@opensource.altera.com> <20140924201934.GB25362@roeck-us.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0013.namprd02.prod.outlook.com (10.141.56.13) To
 DM2PR03MB318.namprd03.prod.outlook.com (10.141.54.17)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB318;
X-Forefront-PRVS: 03449D5DD1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(51704005)(164054003)(189002)(199003)(51914003)(24454002)(107046002)(74662003)(53416004)(106356001)(46102003)(50466002)(4396001)(90102001)(92726001)(79102003)(92566001)(64706001)(42186005)(86152002)(105586002)(10300001)(66066001)(110136001)(50986999)(54356999)(86362001)(83506001)(85852003)(19580405001)(33716001)(83322001)(21056001)(69596002)(80022003)(20776003)(81542003)(76176999)(120916001)(19580395003)(74502003)(101416001)(23726002)(77982003)(81156004)(81342003)(83072002)(76482002)(95666004)(87976001)(47776003)(77096002)(85306004)(46406003)(102836001)(99396003)(31966008)(97736003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB318;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014, Guenter Roeck wrote:

Hi Guenter,

> On Wed, Sep 24, 2014 at 12:57:56PM -0500, atull@opensource.altera.com wrote:
> > From: Alan Tull <atull@opensource.altera.com>
> > 
> > Add simple on/off regulator support for ltc2978 and
> > other pmbus parts supported by ltc2978.c
> > 
> > Signed-off-by: Alan Tull <atull@opensource.altera.com>
> > 
> > v2: Remove '#include <linux/regulator/machine.h>'
> >     Only one regulator per pmbus device
> >     Get regulator_init_data from pdata or device tree
> > 
> > v3: Support multiple regulators for each chip
> >     Move most code to pmbus_core.c
> >     fixed values for on/off
> > ---
> >  drivers/hwmon/pmbus/Kconfig   |    7 ++++++
> >  drivers/hwmon/pmbus/ltc2978.c |   51 +++++++++++++++++++++++++++++++++++++++++
> 
> This will also require devicetree documentation describing the device nodes.

Yes, I'll add that as a separate patch to v4.  It will be a new file since
there currently isn't any pmbus or ltc2978 bindings documentation that I
could find.

> 
> >  2 files changed, 58 insertions(+)
> > 
> > diff --git a/drivers/hwmon/pmbus/Kconfig b/drivers/hwmon/pmbus/Kconfig
> > index 6e1e493..79117b7 100644
> > --- a/drivers/hwmon/pmbus/Kconfig
> > +++ b/drivers/hwmon/pmbus/Kconfig
> > @@ -56,6 +56,13 @@ config SENSORS_LTC2978
> >  	  This driver can also be built as a module. If so, the module will
> >  	  be called ltc2978.
> >  
> > +config SENSORS_LTC2978_REGULATOR
> > +	boolean "Regulator support for LTC2974, LTC2978, LTC3880, and LTC3883"
> > +	depends on SENSORS_LTC2978 && REGULATOR
> > +	help
> > +	  If you say yes here you get regulator support for Linear
> > +	  Technology LTC2974, LTC2978, LTC3880, and LTC3883.
> > +
> >  config SENSORS_MAX16064
> >  	tristate "Maxim MAX16064"
> >  	default n
> > diff --git a/drivers/hwmon/pmbus/ltc2978.c b/drivers/hwmon/pmbus/ltc2978.c
> > index e24ed52..7d4dcd7 100644
> > --- a/drivers/hwmon/pmbus/ltc2978.c
> > +++ b/drivers/hwmon/pmbus/ltc2978.c
> > @@ -22,6 +22,8 @@
> >  #include <linux/err.h>
> >  #include <linux/slab.h>
> >  #include <linux/i2c.h>
> > +#include <linux/regulator/driver.h>
> > +#include <linux/regulator/of_regulator.h>
> >  #include "pmbus.h"
> >  
> >  enum chips { ltc2974, ltc2977, ltc2978, ltc3880, ltc3883, ltm4676 };
> > @@ -374,6 +376,30 @@ static const struct i2c_device_id ltc2978_id[] = {
> >  };
> >  MODULE_DEVICE_TABLE(i2c, ltc2978_id);
> >  
> > +#if IS_ENABLED(CONFIG_SENSORS_LTC2978_REGULATOR)
> > +static const struct regulator_desc ltc2978_reg_desc[] = {
> > +	PMBUS_REGULATOR("vout_en", 0),
> > +	PMBUS_REGULATOR("vout_en", 1),
> > +	PMBUS_REGULATOR("vout_en", 2),
> > +	PMBUS_REGULATOR("vout_en", 3),
> > +	PMBUS_REGULATOR("vout_en", 4),
> > +	PMBUS_REGULATOR("vout_en", 5),
> > +	PMBUS_REGULATOR("vout_en", 6),
> > +	PMBUS_REGULATOR("vout_en", 7),
> 
> How about just vout[0-7] ? I don't see a value in "_en".

That's cool.  I'll do it.

> 
> > +};
> > +
> > +static struct of_regulator_match ltc2978_reg_matches[] = {
> > +	{ .name = "vout_en0" },
> > +	{ .name = "vout_en1" },
> > +	{ .name = "vout_en2" },
> > +	{ .name = "vout_en3" },
> > +	{ .name = "vout_en4" },
> > +	{ .name = "vout_en5" },
> > +	{ .name = "vout_en6" },
> > +	{ .name = "vout_en7" },
> 
> If there are multiple LTC chips in the system, this will result in duplicate
> regulator names. Does that matter ? Any ideas how other regulators handle this ?
> 
> Example on my test system:
> 
> root@localhost:/sys/class/regulator# grep vout_en0 */name
> regulator.15/name:vout_en0
> regulator.2/name:vout_en0
> regulator.23/name:vout_en0
> regulator.31/name:vout_en0
> regulator.39/name:vout_en0
> regulator.47/name:vout_en0

These are just default names, but I think I could make the name better.
How about <part #>-<i2c address>-vout<#> such as "ltc2978-5c-vout0"

If the board has regulator_init_data, then these default names get overwritten.
In my case, I'm just using 3 supplies so those 3 get overwritten:

root@socfpga_cyclone5:/sys/class/regulator# cat */name
regulator-dummy
FPGA-2.5V
vout_en1
FPGA-1.5V
vout_en3
FPGA-1.1V
vout_en5
vout_en6
vout_en7

> 
> > +};
> > +#endif /* CONFIG_REGULATOR */
> 
> Nitpick, but
> 
> 	CONFIG_SENSORS_LTC2978_REGULATOR

I'll change it.

> > +
> >  static int ltc2978_probe(struct i2c_client *client,
> >  			 const struct i2c_device_id *id)
> >  {
> > @@ -487,6 +513,31 @@ static int ltc2978_probe(struct i2c_client *client,
> >  	default:
> >  		return -ENODEV;
> >  	}
> > +
> > +#if IS_ENABLED(CONFIG_SENSORS_LTC2978_REGULATOR)
> > +	info->reg_desc = ltc2978_reg_desc;
> > +	info->reg_matches = ltc2978_reg_matches;
> > +
> > +	switch (data->id) {
> > +	case ltc2974:
> > +		info->num_regulators = LTC2974_NUM_PAGES;
> > +		break;
> > +	case ltc2977:
> > +	case ltc2978:
> > +		info->num_regulators = LTC2978_NUM_PAGES;
> > +		break;
> > +	case ltc3880:
> > +	case ltm4676:
> > +		info->num_regulators = LTC3880_NUM_PAGES;
> > +		break;
> > +	case ltc3883:
> > +		info->num_regulators = LTC3883_NUM_PAGES;
> > +		break;
> > +	default:
> > +		return -ENODEV;
> > +	}
> > +	BUG_ON(info->num_regulators > ARRAY_SIZE(ltc2978_reg_desc));
> 
> How about an error message and reducing info->num_regulators to
> ARRAY_SIZE(ltc2978_reg_desc) if that happens ? I am not really a friend
> of BUG_ON() as it seems a bit drastic. Sure, one can argue that the programmer
> doesn't deserve better, but the idea behind BUG_ON is that the kernel can not
> continue to operate, and that is not really the case here.

That sounds right to me.  I'll do that.

> 
> Also, please drop the ifdef here, and merge the initialization into
> the first switch statement. The few saved bytes of code are not really
> worth it. You can use defines for ltc2978_reg_desc and ltc2978_reg_matches
> and initialize with NULL if CONFIG_SENSORS_LTC2978_REGULATOR is not defined.

OK, that will be cleaner.

> 
> Thanks,
> Guenter
> 

Thanks for the feedback,
Alan
