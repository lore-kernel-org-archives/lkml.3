Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaIXVOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:14:12 -0400
Received: from mail-bn1on0066.outbound.protection.outlook.com ([157.56.110.66]:24304
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750821AbaIXVOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:14:11 -0400
Date: Wed, 24 Sep 2014 16:08:05 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Dinh Nguyen <dinguyen@opensource.altera.com>
CC: <linux@roeck-us.net>, <jdelvare@suse.de>, <lm-sensors@lm-sensors.org>,
        <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <delicious.quinoa@gmail.com>,
        <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v3 2/3] pmbus: add regulator support
In-Reply-To: <54231E64.8030707@opensource.altera.com>
Message-ID: <alpine.DEB.2.02.1409241607010.9901@atx-linux-37>
References: <1411581476-12222-1-git-send-email-atull@opensource.altera.com> <1411581476-12222-3-git-send-email-atull@opensource.altera.com> <54231E64.8030707@opensource.altera.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-93954703-1411592900=:9901"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0024.namprd02.prod.outlook.com (10.141.56.24) To
 BY2PR03MB314.namprd03.prod.outlook.com (10.141.139.19)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB314;
X-Forefront-PRVS: 03449D5DD1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(51704005)(199003)(377454003)(479174003)(24454002)(189002)(164054003)(77982003)(81342003)(110136001)(76176999)(21056001)(69596002)(79102003)(4396001)(19580395003)(74662003)(81542003)(31966008)(85306004)(107046002)(74502003)(80022003)(92726001)(53416004)(90102001)(42186005)(54356999)(10300001)(99396003)(106356001)(83322001)(97736003)(50986999)(84326002)(19580405001)(105586002)(83506001)(86362001)(81156004)(66066001)(76482002)(120916001)(102836001)(71186001)(86152002)(92566001)(77096002)(46102003)(83072002)(85852003)(33716001)(20776003)(95666004)(87976001)(41446005)(64706001)(101416001)(512934002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB314;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8323329-93954703-1411592900=:9901
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT

On Wed, 24 Sep 2014, Dinh Nguyen wrote:

> Hi Alan,
> 
> On 9/24/14, 12:57 PM, atull@opensource.altera.com wrote:
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
> > +/* Macro for filling in array of struct regulator_desc */
> > +#define PMBUS_REGULATOR(_name, _id)				\
> > +	[_id] = {						\
> > +		.name = (_name # _id),				\
> > +		.id = (_id),					\
> > +		.ops = &pmbus_regulator_regulator_ops,		\
> > +		.owner = THIS_MODULE,				\
> > +	}
> > +
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
> 
> This breaks the build if CONFIG_REGULATOR is not enabled:
> 
> drivers/hwmon/pmbus/pmbus_core.c: In function âpmbus_do_probeâ:
> drivers/hwmon/pmbus/pmbus_core.c:1894:2: error: implicit declaration of
> function âpmbus_regulator_parse_dtâ [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> 
> Dinh
> 

Hi Dinh,

Thanks, I will fix it.  I had that working earlier, but obviously broke it again...

Alan
--8323329-93954703-1411592900=:9901--
