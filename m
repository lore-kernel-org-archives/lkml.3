Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaIXVMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:12:19 -0400
Received: from mail-bn1bon0055.outbound.protection.outlook.com ([157.56.111.55]:60544
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751122AbaIXVMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:12:18 -0400
Date: Wed, 24 Sep 2014 16:06:11 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Guenter Roeck <linux@roeck-us.net>
CC: <jdelvare@suse.de>, <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v3 2/3] pmbus: add regulator support
In-Reply-To: <20140924195849.GA25362@roeck-us.net>
Message-ID: <alpine.DEB.2.02.1409241553370.9901@atx-linux-37>
References: <1411581476-12222-1-git-send-email-atull@opensource.altera.com> <1411581476-12222-3-git-send-email-atull@opensource.altera.com> <20140924195849.GA25362@roeck-us.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR04CA040.namprd04.prod.outlook.com (10.141.154.158) To
 BL2PR03MB305.namprd03.prod.outlook.com (10.141.68.13)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB305;
X-Forefront-PRVS: 03449D5DD1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(24454002)(51704005)(199003)(189002)(51914003)(76104003)(52314003)(19580395003)(107046002)(31966008)(120916001)(86152002)(53416004)(74502003)(81156004)(33716001)(50986999)(66066001)(97736003)(81542003)(10300001)(90102001)(83322001)(95666004)(74662003)(80022003)(85306004)(50466002)(110136001)(76482002)(79102003)(46102003)(81342003)(46406003)(77982003)(101416001)(54356999)(102836001)(23726002)(76176999)(87976001)(92726001)(83072002)(42186005)(77096002)(64706001)(4396001)(47776003)(19580405001)(92566001)(20776003)(105586002)(106356001)(85852003)(83506001)(99396003)(86362001)(21056001)(69596002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB305;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014, Guenter Roeck wrote:

> On Wed, Sep 24, 2014 at 12:57:55PM -0500, atull@opensource.altera.com wrote:
> > From: Alan Tull <atull@opensource.altera.com>
> > 
> > Add support for simple on/off control of each channel.
> > 
> > To add regulator support, the pmbus part driver needs to add
> > regulator_desc information, of_regulator_match information,
> > and number of regulators to its pmbus_driver_info struct.
> > 
> > regulator_desc can be declared using default macro for a
> > regulator (PMBUS_REGULATOR) that is in pmbus.h
> > 
> > The regulator_init_data can be intialized from either
> > platform data or the device tree.
> > 
> > Signed-off-by: Alan Tull <atull@opensource.altera.com>
> > 
> 
> Hi Alan,
> 
> Overall looks pretty good. Couple of comments inline.
> 

Hi Guenter,

> > v2: Remove '#include <linux/regulator/machine.h>'
> >     Only one regulator per pmbus device
> >     Get regulator_init_data from pdata or device tree
> > 
> > v3: Support multiple regulators for each chip
> >     Move most code to pmbus_core.c
> >     fixed values for on/off
> > ---
> >  drivers/hwmon/pmbus/pmbus.h      |   27 ++++++++
> >  drivers/hwmon/pmbus/pmbus_core.c |  133 ++++++++++++++++++++++++++++++++++++++
> >  include/linux/i2c/pmbus.h        |    4 ++
> >  3 files changed, 164 insertions(+)
> > 
> > diff --git a/drivers/hwmon/pmbus/pmbus.h b/drivers/hwmon/pmbus/pmbus.h
> > index fa9beb3..74aa382 100644
> > --- a/drivers/hwmon/pmbus/pmbus.h
> > +++ b/drivers/hwmon/pmbus/pmbus.h
> > @@ -19,6 +19,9 @@
> >   * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> >   */
> >  
> > +#include <linux/regulator/driver.h>
> > +#include <linux/regulator/of_regulator.h>
> > +
> >  #ifndef PMBUS_H
> >  #define PMBUS_H
> >  
> > @@ -186,6 +189,12 @@
> >  #define PMBUS_VIRT_STATUS_VMON		(PMBUS_VIRT_BASE + 35)
> >  
> >  /*
> > + * OPERATION
> > + */
> > +#define PB_OPERATION_CONTROL_ON		(1<<7)
> > +#define PB_OPERATION_CONTROL_SEQ_OFF	(1<<6)
> 
> Can those defines be more consistent ? Does it really need SEQ_OFF or can it
> just be OFF ?

PB_OPERATION_CONTROL_SEQ_OFF is not used, so I will eliminate it.

> 
> > +
> > +/*
> >   * CAPABILITY
> >   */
> >  #define PB_CAPABILITY_SMBALERT		(1<<4)
> > @@ -365,8 +374,26 @@ struct pmbus_driver_info {
> >  	 */
> >  	int (*identify)(struct i2c_client *client,
> >  			struct pmbus_driver_info *info);
> > +
> > +	/* Regulator functionality, if supported by this chip driver. */
> > +	int num_regulators;
> > +	const struct regulator_desc *reg_desc;
> > +	struct of_regulator_match *reg_matches;
> >  };
> >  
> > +/* Regulator ops */
> > +
> > +extern struct regulator_ops pmbus_regulator_regulator_ops;
> > +
> How about just pmbus_regulator_ops ? I don't see a double regulator_
> variable name anywhere else in the code, and I don't really see the
> benefit of it.

That was a mistake.  No need for double regulators here.

> 
> > +/* Macro for filling in array of struct regulator_desc */
> > +#define PMBUS_REGULATOR(_name, _id)				\
> > +	[_id] = {						\
> > +		.name = (_name # _id),				\
> > +		.id = (_id),					\
> > +		.ops = &pmbus_regulator_regulator_ops,		\
> > +		.owner = THIS_MODULE,				\
> > +	}
> > +
> 
> Any idea how/if we can get rid of the resulting checkpatch error ?

I banged my head on that for a while.  I'll try some more.

> 
> >  /* Function declarations */
> >  
> >  void pmbus_clear_cache(struct i2c_client *client);
> > diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
> > index d6c3701..9ab8bd4 100644
> > --- a/drivers/hwmon/pmbus/pmbus_core.c
> > +++ b/drivers/hwmon/pmbus/pmbus_core.c
> > @@ -29,6 +29,9 @@
> >  #include <linux/hwmon-sysfs.h>
> >  #include <linux/jiffies.h>
> >  #include <linux/i2c/pmbus.h>
> > +#include <linux/regulator/of_regulator.h>
> > +#include <linux/regulator/driver.h>
> > +#include <linux/regulator/machine.h>
> >  #include "pmbus.h"
> >  
> >  /*
> > @@ -1758,6 +1761,125 @@ static int pmbus_init_common(struct i2c_client *client, struct pmbus_data *data,
> >  	return 0;
> >  }
> >  
> > +#if IS_ENABLED(CONFIG_REGULATOR)
> > +static int pmbus_regulator_is_enabled(struct regulator_dev *rdev)
> > +{
> > +	struct device *dev = rdev_get_dev(rdev);
> > +	struct i2c_client *client = to_i2c_client(dev->parent);
> > +	u8 page = rdev_get_id(rdev);
> > +	int ret;
> > +
> > +	ret = pmbus_read_byte_data(client, page, PMBUS_OPERATION);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	return !!(ret & PB_OPERATION_CONTROL_ON);
> > +}
> > +
> > +static int _pmbus_regulator_enable(struct regulator_dev *rdev, bool enable)
> > +{
> 
> Can you find a better name for this function ? After all,
> it doesn't just enable the regulator, it also disables it.

_pmbus_regulator_on_off?

> 
> > +	struct device *dev = rdev_get_dev(rdev);
> > +	struct i2c_client *client = to_i2c_client(dev->parent);
> > +	u8 val, page = rdev_get_id(rdev);
> > +
> > +	if (enable)
> > +		val = PB_OPERATION_CONTROL_ON;
> > +	else
> > +		val = 0;
> > +
> > +	return pmbus_update_byte_data(client, page, PMBUS_OPERATION,
> > +				      PB_OPERATION_CONTROL_ON, val);
> 
> 					enable ? PB_OPERATION_CONTROL_ON : 0
> 
> would be much simpler here.

OK

> 
> > +}
> > +
> > +static int pmbus_regulator_enable(struct regulator_dev *rdev)
> > +{
> > +	return _pmbus_regulator_enable(rdev, 1);
> > +}
> > +
> > +static int pmbus_regulator_disable(struct regulator_dev *rdev)
> > +{
> > +	return _pmbus_regulator_enable(rdev, 0);
> > +}
> > +
> > +struct regulator_ops pmbus_regulator_regulator_ops = {
> > +	.enable = pmbus_regulator_enable,
> > +	.disable = pmbus_regulator_disable,
> > +	.is_enabled = pmbus_regulator_is_enabled,
> 
> No get_voltage support ?
> 
> [ Guess it isn't mandatory. We can add it later to get this going. ]

Yep, no voltage support for now.  But it will be straightforward for
someone to insert here and probably won't require rewriting any of
this.

> 
> > +};
> > +EXPORT_SYMBOL_GPL(pmbus_regulator_regulator_ops);
> > +
> > +#if IS_ENABLED(CONFIG_OF)
> > +static int pmbus_regulator_parse_dt(struct device *dev,
> > +				    const struct pmbus_driver_info *info)
> > +{
> > +	struct device_node *np_regulators;
> > +	int ret;
> > +
> > +	if (!info->num_regulators)
> > +		return 0;
> > +
> > +	if (!info->reg_matches || !info->reg_desc)
> > +		return -EINVAL;
> > +
> > +	np_regulators = of_get_child_by_name(dev->of_node, "regulators");
> > +	if (!np_regulators)
> > +		return 0;
> > +
> > +	ret = of_regulator_match(dev, np_regulators, info->reg_matches,
> > +				 info->num_regulators);
> > +	of_node_put(np_regulators);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	return 0;
> > +}
> > +#else
> > +static int pmbus_regulator_parse_dt(struct device *dev,
> > +				    const struct pmbus_driver_info *info)
> > +{
> > +	return 0;
> > +}
> > +#endif
> > +
> > +static int pmbus_regulator_register(struct pmbus_data *data)
> > +{
> > +	struct device *dev = data->dev;
> > +	const struct pmbus_driver_info *info = data->info;
> > +	const struct pmbus_platform_data *pdata = dev_get_platdata(dev);
> > +	struct regulator_dev *rdev;
> > +	int i;
> > +
> > +	for (i = 0; i < info->num_regulators; i++) {
> > +		struct regulator_config config = { };
> > +
> > +		config.dev = dev;
> > +		config.driver_data = data;
> > +
> > +		if (pdata && pdata->reg_init_data) {
> > +			config.init_data = &pdata->reg_init_data[i];
> > +		} else {
> > +			config.init_data = info->reg_matches[i].init_data;
> > +			config.of_node = info->reg_matches[i].of_node;
> > +		}
> > +
> > +		rdev = devm_regulator_register(dev, &info->reg_desc[i],
> > +					       &config);
> > +		if (IS_ERR(rdev)) {
> > +			dev_err(dev, "Failed to register %s regulator\n",
> > +				info->reg_desc[i].name);
> > +			return PTR_ERR(rdev);
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +#else
> > +static int pmbus_regulator_register(struct pmbus_data *data)
> > +{
> > +	return 0;
> > +}
> > +#endif
> > +
> >  int pmbus_do_probe(struct i2c_client *client, const struct i2c_device_id *id,
> >  		   struct pmbus_driver_info *info)
> >  {
> > @@ -1769,6 +1891,10 @@ int pmbus_do_probe(struct i2c_client *client, const struct i2c_device_id *id,
> >  	if (!info)
> >  		return -ENODEV;
> >  
> > +	ret = pmbus_regulator_parse_dt(dev, info);
> > +	if (ret)
> > +		return ret;
> > +
> 
> You have the conditions wrong above.
> 
> If CONFIG_REGULATOR is not enabled, this will fail to build,
> since pmbus_regulator_parse_dt is not declared at all in this case.
> 
> I can understand that you want to parse the dt early, but it would be
> simpler to just parse it from pmbus_regulator_register(). It is only
> relevant if regulators are configured anyway, and we don't really need
> to optimize the code for the error case.

I was thinking of adding the flags to the device tree parsing code.  That
is the only other thing this driver is taking from the platform data. If I
do that, this driver will be completely done for device tree. I could do
that by adding a 'pmbus-skip-status-check' device tree property.   That
would be a small change, but I would still need to parse the dt early. 
Otherwise I can redo the code as you are recommending above.

What do you think? 

Thanks for the review,

Alan

> 
> >  	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_WRITE_BYTE
> >  				     | I2C_FUNC_SMBUS_BYTE_DATA
> >  				     | I2C_FUNC_SMBUS_WORD_DATA))
> > @@ -1812,8 +1938,15 @@ int pmbus_do_probe(struct i2c_client *client, const struct i2c_device_id *id,
> >  		dev_err(dev, "Failed to register hwmon device\n");
> >  		goto out_kfree;
> >  	}
> > +
> > +	ret = pmbus_regulator_register(data);
> > +	if (ret)
> > +		goto out_unregister;
> > +
> >  	return 0;
> >  
> > +out_unregister:
> > +	hwmon_device_unregister(data->hwmon_dev);
> >  out_kfree:
> >  	kfree(data->group.attrs);
> >  	return ret;
> > diff --git a/include/linux/i2c/pmbus.h b/include/linux/i2c/pmbus.h
> > index 69280db..ee3c2ab 100644
> > --- a/include/linux/i2c/pmbus.h
> > +++ b/include/linux/i2c/pmbus.h
> > @@ -40,6 +40,10 @@
> >  
> >  struct pmbus_platform_data {
> >  	u32 flags;		/* Device specific flags */
> > +
> > +	/* regulator support */
> > +	int num_regulators;
> > +	struct regulator_init_data *reg_init_data;
> >  };
> >  
> >  #endif /* _PMBUS_H_ */
> > -- 
> > 1.7.9.5
> > 
> 
