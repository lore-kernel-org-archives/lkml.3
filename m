Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbaHFXSK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 19:18:10 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:56829 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbaHFXSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 19:18:08 -0400
Date: Wed, 6 Aug 2014 16:18:03 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>, Jean Delvare <jdelvare@suse.de>,
        Goffredo Baroncelli <kreijack@iniwnd.it>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 5/5] Export the temperatures via hwmon
Message-ID: <20140806231803.GA5643@roeck-us.net>
References: <1407359103-6012-1-git-send-email-kreijack@inwind.it>
 <1407359103-6012-6-git-send-email-kreijack@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407359103-6012-6-git-send-email-kreijack@inwind.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 09:05:03PM +0000, Goffredo Baroncelli wrote:
> From: Goffredo Baroncelli <kreijack@iniwnd.it>
> 
> Export the temperature via the hwmon subsystem.
> See the list below for the sensors exported:
> 
> $ cd /sys/devices/temperature/hwmon/hwmon0
> $ echo "name: $(cat name)"; for i in temp*; do echo "$i: $(cat $i)"; done
> name: therm_windtunnel
> temp1_input: 59312
> temp1_label: CPU
> temp2_input: 36750
> temp2_label: Case
> temp3_input: 37750
> temp3_label: Case2
> 
Makes me wonder why you don't report the fan speed through hwmon.

> The Case2 temperature is the sensor temperature inside the adm1030.
> 
There are standard hwmon drivers for lm75, ds1775, and adm1030.
Personally I think it would make more sense to use those directly.
But I guess that would be for another day.

> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
> ---
>  drivers/macintosh/therm_windtunnel.c | 103 +++++++++++++++++++++++++++++++++--
>  1 file changed, 99 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
> index b6cba98..a6757d7 100644
> --- a/drivers/macintosh/therm_windtunnel.c
> +++ b/drivers/macintosh/therm_windtunnel.c
> @@ -37,6 +37,8 @@
>  #include <linux/init.h>
>  #include <linux/kthread.h>
>  #include <linux/of_platform.h>
> +#include <linux/hwmon.h>
> +#include <linux/hwmon-sysfs.h>
>  
>  #include <asm/prom.h>
>  #include <asm/machdep.h>
> @@ -58,9 +60,12 @@ static struct {
>  	struct i2c_client	*thermostat;
>  	struct i2c_client	*fan;
>  
> +	struct device		*hwmon;
> +
>  	int			overheat_temp;		/* 100% fan at this temp */
>  	int			overheat_hyst;
>  	int			temp;
> +	int			casetemp2;
>  	int			casetemp;
>  	int			fan_level;		/* active fan_table setting */
>  
> @@ -120,6 +125,75 @@ static DEVICE_ATTR(case_temperature, S_IRUGO, show_case_temperature, NULL );
>  static DEVICE_ATTR(fan_level, S_IRUGO, show_fan_level, NULL);
>  
>  
> +static ssize_t
> +show_temp1(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "%d%03d\n", x.temp>>8, (x.temp & 0xff)*1000>>8);

I personally prefer if code follows coding style, with spaces around operands,
and if calculations are less cryptic.

> +}
> +
> +static ssize_t
> +show_temp1_label(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "CPU\n");
> +}
> +
> +static ssize_t
> +show_temp2(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "%d%03d\n", x.casetemp>>8,
> +				(x.casetemp & 0xff)*1000>>8);
> +}
> +
> +static ssize_t
> +show_temp2_label(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "Case\n");
> +}
> +
> +
> +static ssize_t
> +show_temp3(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "%d%03d\n", x.casetemp2>>8,
> +				(x.casetemp2 & 0xff)*1000>>8);

... and aligned second lines.

> +}
> +
> +static ssize_t
> +show_temp3_label(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "Case2\n");
> +}
> +
> +#define TWT_ATTRIB(name, func) \
> +	static SENSOR_DEVICE_ATTR(name##_input, S_IRUGO, func, NULL, 0); \
> +	static SENSOR_DEVICE_ATTR(name##_label, S_IRUGO, func##_label, \
> +					NULL, 0)
> +
> +TWT_ATTRIB(temp1, show_temp1);
> +TWT_ATTRIB(temp2, show_temp2);
> +TWT_ATTRIB(temp3, show_temp3);
> +
> +
A single empty line should be sufficient. Personally I am also not
a fan of such macros (and neither is checkpatch), and prefer the use
of direct macros as less confusing.

Also, using three different functions for three different attributes
where the only difference is the variable name defeats the purpose
of using SENSOR_DEVICE_ATTR, which has an index variable for exactly 
that reason. I would suggest to either use an indexed array to access
the temperatures, or use DEVICE_ATTR.

> +static struct attribute  *therm_windtunnel_attributes[] = {
> +	&sensor_dev_attr_temp1_input.dev_attr.attr,
> +	&sensor_dev_attr_temp1_label.dev_attr.attr,
> +	&sensor_dev_attr_temp2_input.dev_attr.attr,
> +	&sensor_dev_attr_temp2_label.dev_attr.attr,
> +	&sensor_dev_attr_temp3_input.dev_attr.attr,
> +	&sensor_dev_attr_temp3_label.dev_attr.attr,
> +
> +	NULL,
> +};
> +
> +static const struct attribute_group therm_windtunnel_attr_group = {
> +	.attrs  = therm_windtunnel_attributes,
> +};
> +
> +static const struct attribute_group *therm_windtunnel_attr_groups[] = {
> +	&therm_windtunnel_attr_group,
> +	NULL,
> +};

ATTRIBUTE_GROUPS() is a nice and useful macro.

> +
>  /************************************************************************/
>  /*	controller thread						*/
>  /************************************************************************/
> @@ -172,16 +246,23 @@ tune_fan( int fan_setting )
>  static void
>  poll_temp( void )
>  {
> -	int temp, i, level, casetemp, tempchanged;
> +	int temp, i, level, casetemp, tempchanged, casetemp2, reg06;
>  
> +	/* temperature read from ds1775 */
>  	temp = read_reg( x.thermostat, 0, 2 );
>  
>  	/* this actually occurs when the computer is loaded */
>  	if( temp < 0 )
>  		return;
>  
> -	casetemp = read_reg(x.fan, 0x0b, 1) << 8;
> -	casetemp |= (read_reg(x.fan, 0x06, 1) & 0x7) << 5;
> +	/*
> +	 * temperatures read from the adm1030
> +	 * casetemp is the external temperature sensor
> +	 * casetemp2 is the internal temperature sensor
> +	 */

What if there is no adm1030 ? Or is that always there ?
Just wondering.

> +	reg06 = read_reg(x.fan, 0x06, 1);
> +	casetemp = (read_reg(x.fan, 0x0b, 1) << 8) | (reg06 & 0x07 << 5);
> +	casetemp2 = (read_reg(x.fan, 0x0a, 1) << 8) | (reg06 & 0xc0);
>  
>  	level = -1;
>  	for( i=0; (temp & 0xffff) > fan_table[i].temp ; i++ )
> @@ -200,13 +281,16 @@ poll_temp( void )
>  	 * if verbose >0 log each fan tuning
>  	 * if verbose >1 log each cpu temperature change
>  	 */
> -	tempchanged = x.temp != temp || x.casetemp != casetemp;
> +	tempchanged = x.temp != temp || x.casetemp != casetemp ||
> +		x.casetemp2 != casetemp2;
>  	if ((verbose > 1 && tempchanged) ||
>  	    (verbose > 0 && level >= 0)) {
>  		printk(KERN_INFO);
>  		print_temp("CPU-temp: ", temp);
>  		if (casetemp)
>  			print_temp(", Case: ", casetemp);
> +		if (casetemp2)
> +			print_temp(", Case2: ", casetemp2);
>  		if (level >= 0)
>  			printk(", Fan: %d (tuned %+d)\n", 11-level,
>  				x.fan_level-level);

Wow, this logging must clutter the kernel log quite substantially
if enabled.

> @@ -216,6 +300,7 @@ poll_temp( void )
>  
>  	x.temp = temp;
>  	x.casetemp = casetemp;
> +	x.casetemp2 = casetemp2;
>  
>  	if( level >= 0 )
>  		tune_fan( level );
> @@ -275,11 +360,21 @@ setup_hardware( void )
>  	if (err)
>  		printk(KERN_WARNING
>  			"Failed to create temperature attribute file(s).\n");
> +
> +	x.hwmon = hwmon_device_register_with_groups(&x.of_dev->dev,
> +			"therm_windtunnel", NULL,
> +			therm_windtunnel_attr_groups);
> +	if (!x.hwmon)
> +		dev_warn(&x.of_dev->dev, "Failed to create the hwmon device\n");
>  }
>  
>  static void
>  restore_regs( void )
>  {
> +	if (x.hwmon)
> +		hwmon_device_unregister(x.hwmon);
> +	x.hwmon = NULL;
> +
>  	device_remove_file( &x.of_dev->dev, &dev_attr_cpu_temperature );
>  	device_remove_file( &x.of_dev->dev, &dev_attr_case_temperature );
>  	device_remove_file(&x.of_dev->dev, &dev_attr_fan_level);
> -- 
> 2.0.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
