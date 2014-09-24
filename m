Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaIXTlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:41:36 -0400
Received: from mail-by2on0077.outbound.protection.outlook.com ([207.46.100.77]:61182
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751271AbaIXTle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:41:34 -0400
Message-ID: <54231E64.8030707@opensource.altera.com>
Date: Wed, 24 Sep 2014 14:41:24 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <atull@opensource.altera.com>, <linux@roeck-us.net>, <jdelvare@suse.de>
CC: <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <delicious.quinoa@gmail.com>,
        <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v3 2/3] pmbus: add regulator support
References: <1411581476-12222-1-git-send-email-atull@opensource.altera.com> <1411581476-12222-3-git-send-email-atull@opensource.altera.com>
In-Reply-To: <1411581476-12222-3-git-send-email-atull@opensource.altera.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [99.103.66.154]
X-ClientProxiedBy: DM2PR04CA035.namprd04.prod.outlook.com (10.141.154.153) To
 CY1PR0301MB1193.namprd03.prod.outlook.com (25.160.165.24)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03449D5DD1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(51704005)(189002)(377454003)(479174003)(199003)(24454002)(77982003)(83322001)(19580395003)(81542003)(87266999)(86362001)(74662003)(59896002)(80316001)(87976001)(74502003)(54356999)(10300001)(79102003)(83506001)(19580405001)(46102003)(99396003)(76482002)(80022003)(64706001)(81342003)(65956001)(50466002)(120916001)(107046002)(95666004)(102836001)(97736003)(92726001)(47776003)(76176999)(50986999)(85306004)(42186005)(85852003)(90102001)(83072002)(33656002)(64126003)(65806001)(31966008)(2201001)(23756003)(21056001)(65816999)(105586002)(106356001)(92566001)(77096002)(101416001)(66066001)(20776003)(4396001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0301MB1193;H:Dinhs-MacBook-Pro.local;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On 9/24/14, 12:57 PM, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
> 
> Add support for simple on/off control of each channel.
> 
> To add regulator support, the pmbus part driver needs to add
> regulator_desc information, of_regulator_match information,
> and number of regulators to its pmbus_driver_info struct.
> 
> regulator_desc can be declared using default macro for a
> regulator (PMBUS_REGULATOR) that is in pmbus.h
> 
> The regulator_init_data can be intialized from either
> platform data or the device tree.
> 
> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> 
> v2: Remove '#include <linux/regulator/machine.h>'
>     Only one regulator per pmbus device
>     Get regulator_init_data from pdata or device tree
> 
> v3: Support multiple regulators for each chip
>     Move most code to pmbus_core.c
>     fixed values for on/off
> ---
>  drivers/hwmon/pmbus/pmbus.h      |   27 ++++++++
>  drivers/hwmon/pmbus/pmbus_core.c |  133 ++++++++++++++++++++++++++++++++++++++
>  include/linux/i2c/pmbus.h        |    4 ++
>  3 files changed, 164 insertions(+)
> 
> diff --git a/drivers/hwmon/pmbus/pmbus.h b/drivers/hwmon/pmbus/pmbus.h
> index fa9beb3..74aa382 100644
> --- a/drivers/hwmon/pmbus/pmbus.h
> +++ b/drivers/hwmon/pmbus/pmbus.h
> @@ -19,6 +19,9 @@
>   * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
>  
> +#include <linux/regulator/driver.h>
> +#include <linux/regulator/of_regulator.h>
> +
>  #ifndef PMBUS_H
>  #define PMBUS_H
>  
> @@ -186,6 +189,12 @@
>  #define PMBUS_VIRT_STATUS_VMON		(PMBUS_VIRT_BASE + 35)
>  
>  /*
> + * OPERATION
> + */
> +#define PB_OPERATION_CONTROL_ON		(1<<7)
> +#define PB_OPERATION_CONTROL_SEQ_OFF	(1<<6)
> +
> +/*
>   * CAPABILITY
>   */
>  #define PB_CAPABILITY_SMBALERT		(1<<4)
> @@ -365,8 +374,26 @@ struct pmbus_driver_info {
>  	 */
>  	int (*identify)(struct i2c_client *client,
>  			struct pmbus_driver_info *info);
> +
> +	/* Regulator functionality, if supported by this chip driver. */
> +	int num_regulators;
> +	const struct regulator_desc *reg_desc;
> +	struct of_regulator_match *reg_matches;
>  };
>  
> +/* Regulator ops */
> +
> +extern struct regulator_ops pmbus_regulator_regulator_ops;
> +
> +/* Macro for filling in array of struct regulator_desc */
> +#define PMBUS_REGULATOR(_name, _id)				\
> +	[_id] = {						\
> +		.name = (_name # _id),				\
> +		.id = (_id),					\
> +		.ops = &pmbus_regulator_regulator_ops,		\
> +		.owner = THIS_MODULE,				\
> +	}
> +
>  /* Function declarations */
>  
>  void pmbus_clear_cache(struct i2c_client *client);
> diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
> index d6c3701..9ab8bd4 100644
> --- a/drivers/hwmon/pmbus/pmbus_core.c
> +++ b/drivers/hwmon/pmbus/pmbus_core.c
> @@ -29,6 +29,9 @@
>  #include <linux/hwmon-sysfs.h>
>  #include <linux/jiffies.h>
>  #include <linux/i2c/pmbus.h>
> +#include <linux/regulator/of_regulator.h>
> +#include <linux/regulator/driver.h>
> +#include <linux/regulator/machine.h>
>  #include "pmbus.h"
>  
>  /*
> @@ -1758,6 +1761,125 @@ static int pmbus_init_common(struct i2c_client *client, struct pmbus_data *data,
>  	return 0;
>  }
>  
> +#if IS_ENABLED(CONFIG_REGULATOR)
> +static int pmbus_regulator_is_enabled(struct regulator_dev *rdev)
> +{
> +	struct device *dev = rdev_get_dev(rdev);
> +	struct i2c_client *client = to_i2c_client(dev->parent);
> +	u8 page = rdev_get_id(rdev);
> +	int ret;
> +
> +	ret = pmbus_read_byte_data(client, page, PMBUS_OPERATION);
> +	if (ret < 0)
> +		return ret;
> +
> +	return !!(ret & PB_OPERATION_CONTROL_ON);
> +}
> +
> +static int _pmbus_regulator_enable(struct regulator_dev *rdev, bool enable)
> +{
> +	struct device *dev = rdev_get_dev(rdev);
> +	struct i2c_client *client = to_i2c_client(dev->parent);
> +	u8 val, page = rdev_get_id(rdev);
> +
> +	if (enable)
> +		val = PB_OPERATION_CONTROL_ON;
> +	else
> +		val = 0;
> +
> +	return pmbus_update_byte_data(client, page, PMBUS_OPERATION,
> +				      PB_OPERATION_CONTROL_ON, val);
> +}
> +
> +static int pmbus_regulator_enable(struct regulator_dev *rdev)
> +{
> +	return _pmbus_regulator_enable(rdev, 1);
> +}
> +
> +static int pmbus_regulator_disable(struct regulator_dev *rdev)
> +{
> +	return _pmbus_regulator_enable(rdev, 0);
> +}
> +
> +struct regulator_ops pmbus_regulator_regulator_ops = {
> +	.enable = pmbus_regulator_enable,
> +	.disable = pmbus_regulator_disable,
> +	.is_enabled = pmbus_regulator_is_enabled,
> +};
> +EXPORT_SYMBOL_GPL(pmbus_regulator_regulator_ops);
> +
> +#if IS_ENABLED(CONFIG_OF)
> +static int pmbus_regulator_parse_dt(struct device *dev,
> +				    const struct pmbus_driver_info *info)
> +{
> +	struct device_node *np_regulators;
> +	int ret;
> +
> +	if (!info->num_regulators)
> +		return 0;
> +
> +	if (!info->reg_matches || !info->reg_desc)
> +		return -EINVAL;
> +
> +	np_regulators = of_get_child_by_name(dev->of_node, "regulators");
> +	if (!np_regulators)
> +		return 0;
> +
> +	ret = of_regulator_match(dev, np_regulators, info->reg_matches,
> +				 info->num_regulators);
> +	of_node_put(np_regulators);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +#else
> +static int pmbus_regulator_parse_dt(struct device *dev,
> +				    const struct pmbus_driver_info *info)
> +{
> +	return 0;
> +}
> +#endif

This breaks the build if CONFIG_REGULATOR is not enabled:

drivers/hwmon/pmbus/pmbus_core.c: In function âpmbus_do_probeâ:
drivers/hwmon/pmbus/pmbus_core.c:1894:2: error: implicit declaration of
function âpmbus_regulator_parse_dtâ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

Dinh
