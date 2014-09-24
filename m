Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaIXUTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:19:40 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:40513 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaIXUTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:19:39 -0400
Date: Wed, 24 Sep 2014 13:19:34 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: atull@opensource.altera.com
Cc: jdelvare@suse.de, lm-sensors@lm-sensors.org, lgirdwood@gmail.com,
        broonie@kernel.org, linux-kernel@vger.kernel.org,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Subject: Re: [PATCH v3 3/3] pmbus: ltc2978: add regulator support
Message-ID: <20140924201934.GB25362@roeck-us.net>
References: <1411581476-12222-1-git-send-email-atull@opensource.altera.com>
 <1411581476-12222-4-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411581476-12222-4-git-send-email-atull@opensource.altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 12:57:56PM -0500, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
> 
> Add simple on/off regulator support for ltc2978 and
> other pmbus parts supported by ltc2978.c
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
>  drivers/hwmon/pmbus/Kconfig   |    7 ++++++
>  drivers/hwmon/pmbus/ltc2978.c |   51 +++++++++++++++++++++++++++++++++++++++++

This will also require devicetree documentation describing the device nodes.

>  2 files changed, 58 insertions(+)
> 
> diff --git a/drivers/hwmon/pmbus/Kconfig b/drivers/hwmon/pmbus/Kconfig
> index 6e1e493..79117b7 100644
> --- a/drivers/hwmon/pmbus/Kconfig
> +++ b/drivers/hwmon/pmbus/Kconfig
> @@ -56,6 +56,13 @@ config SENSORS_LTC2978
>  	  This driver can also be built as a module. If so, the module will
>  	  be called ltc2978.
>  
> +config SENSORS_LTC2978_REGULATOR
> +	boolean "Regulator support for LTC2974, LTC2978, LTC3880, and LTC3883"
> +	depends on SENSORS_LTC2978 && REGULATOR
> +	help
> +	  If you say yes here you get regulator support for Linear
> +	  Technology LTC2974, LTC2978, LTC3880, and LTC3883.
> +
>  config SENSORS_MAX16064
>  	tristate "Maxim MAX16064"
>  	default n
> diff --git a/drivers/hwmon/pmbus/ltc2978.c b/drivers/hwmon/pmbus/ltc2978.c
> index e24ed52..7d4dcd7 100644
> --- a/drivers/hwmon/pmbus/ltc2978.c
> +++ b/drivers/hwmon/pmbus/ltc2978.c
> @@ -22,6 +22,8 @@
>  #include <linux/err.h>
>  #include <linux/slab.h>
>  #include <linux/i2c.h>
> +#include <linux/regulator/driver.h>
> +#include <linux/regulator/of_regulator.h>
>  #include "pmbus.h"
>  
>  enum chips { ltc2974, ltc2977, ltc2978, ltc3880, ltc3883, ltm4676 };
> @@ -374,6 +376,30 @@ static const struct i2c_device_id ltc2978_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, ltc2978_id);
>  
> +#if IS_ENABLED(CONFIG_SENSORS_LTC2978_REGULATOR)
> +static const struct regulator_desc ltc2978_reg_desc[] = {
> +	PMBUS_REGULATOR("vout_en", 0),
> +	PMBUS_REGULATOR("vout_en", 1),
> +	PMBUS_REGULATOR("vout_en", 2),
> +	PMBUS_REGULATOR("vout_en", 3),
> +	PMBUS_REGULATOR("vout_en", 4),
> +	PMBUS_REGULATOR("vout_en", 5),
> +	PMBUS_REGULATOR("vout_en", 6),
> +	PMBUS_REGULATOR("vout_en", 7),

How about just vout[0-7] ? I don't see a value in "_en".

> +};
> +
> +static struct of_regulator_match ltc2978_reg_matches[] = {
> +	{ .name = "vout_en0" },
> +	{ .name = "vout_en1" },
> +	{ .name = "vout_en2" },
> +	{ .name = "vout_en3" },
> +	{ .name = "vout_en4" },
> +	{ .name = "vout_en5" },
> +	{ .name = "vout_en6" },
> +	{ .name = "vout_en7" },

If there are multiple LTC chips in the system, this will result in duplicate
regulator names. Does that matter ? Any ideas how other regulators handle this ?

Example on my test system:

root@localhost:/sys/class/regulator# grep vout_en0 */name
regulator.15/name:vout_en0
regulator.2/name:vout_en0
regulator.23/name:vout_en0
regulator.31/name:vout_en0
regulator.39/name:vout_en0
regulator.47/name:vout_en0

> +};
> +#endif /* CONFIG_REGULATOR */

Nitpick, but

	CONFIG_SENSORS_LTC2978_REGULATOR
> +
>  static int ltc2978_probe(struct i2c_client *client,
>  			 const struct i2c_device_id *id)
>  {
> @@ -487,6 +513,31 @@ static int ltc2978_probe(struct i2c_client *client,
>  	default:
>  		return -ENODEV;
>  	}
> +
> +#if IS_ENABLED(CONFIG_SENSORS_LTC2978_REGULATOR)
> +	info->reg_desc = ltc2978_reg_desc;
> +	info->reg_matches = ltc2978_reg_matches;
> +
> +	switch (data->id) {
> +	case ltc2974:
> +		info->num_regulators = LTC2974_NUM_PAGES;
> +		break;
> +	case ltc2977:
> +	case ltc2978:
> +		info->num_regulators = LTC2978_NUM_PAGES;
> +		break;
> +	case ltc3880:
> +	case ltm4676:
> +		info->num_regulators = LTC3880_NUM_PAGES;
> +		break;
> +	case ltc3883:
> +		info->num_regulators = LTC3883_NUM_PAGES;
> +		break;
> +	default:
> +		return -ENODEV;
> +	}
> +	BUG_ON(info->num_regulators > ARRAY_SIZE(ltc2978_reg_desc));

How about an error message and reducing info->num_regulators to
ARRAY_SIZE(ltc2978_reg_desc) if that happens ? I am not really a friend
of BUG_ON() as it seems a bit drastic. Sure, one can argue that the programmer
doesn't deserve better, but the idea behind BUG_ON is that the kernel can not
continue to operate, and that is not really the case here.

Also, please drop the ifdef here, and merge the initialization into
the first switch statement. The few saved bytes of code are not really
worth it. You can use defines for ltc2978_reg_desc and ltc2978_reg_matches
and initialize with NULL if CONFIG_SENSORS_LTC2978_REGULATOR is not defined.

Thanks,
Guenter
