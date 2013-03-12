Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3CLNp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 09:45:29 -0400
Received: from mail.active-venture.com ([67.228.131.205]:65210 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab3CLNp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 09:45:28 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 12 Mar 2013 06:45:28 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        devicetree-discuss@lists.ozlabs.org, khali@linux-fr.org,
        dianders@chromium.org, naveenkrishna.ch@gmail.com
Subject: Re: [PATCH v2] hwmon: ntc: Add DT with IIO support to NTC thermistor
 driver
Message-ID: <20130312134528.GA28019@roeck-us.net>
References: <1363077566-6254-1-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363077566-6254-1-git-send-email-ch.naveen@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 02:09:26PM +0530, Naveen Krishna Chatradhi wrote:
> This patch adds DT support to NTC driver to parse the
> platform data.
> 
> Also adds the support to work as an iio device.
> 
> During the probe ntc driver gets the respective channels of ADC
> and uses iio_raw_read calls to get the ADC converted value.
> 
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>

Much better, but I still have a couple of comments.

> ---
> Changes since v1:
> 1. Combimed all the IIO and OF/device tree changes under CONFIG_OF
> 2. parse_dt function now checks for of_node and iio_channels sanity
> 3. merged both the patches to single, as they cant build independently
> 4. used pdev_id for proper logging and support of DT and non DT based probing
> 5. Rebased on linux git tree
> 6. Added documentation for device tree bindings
> 
> Sorry, for posting a patch rebased on local working branch.
> Thanks Doug, for pointing out.
>  .../devicetree/bindings/hwmon/ntc_thermistor.txt   |   29 +++++
>  drivers/hwmon/ntc_thermistor.c                     |  133 +++++++++++++++++---
>  include/linux/platform_data/ntc_thermistor.h       |    6 +-

You'll still need the conditional dependency on IIO in Kconfig. 
Something like
	depends on IIO if OF
if that works, or alternatively
	select IIO if OF
if that is acceptable.

>  3 files changed, 148 insertions(+), 20 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
> 
> diff --git a/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt b/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
> new file mode 100644
> index 0000000..731a78f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
> @@ -0,0 +1,29 @@
> +NTC Thermistor hwmon sensors
> +-------------------------------
> +
> +Requires node properties:
> +- "compatible" value : one of
> +	"ntc,ncp15wb473"
> +	"ntc,ncp18wb473"
> +	"ntc,ncp21wb473"
> +	"ntc,ncp03wb473"
> +	"ntc,ncp15wl333"
> +- "pullup-uV"	Pull up voltage in micro volts
> +- "pullup-ohm"	Pull up resistor value in ohms
> +- "pulldown-ohm" Pull down resistor value in ohms
> +- "connected-positive" Always ON, If not specified.
> +		Status change is possible, value (1) is assigned.
> +- "io-channels"	Channel node of ADC to be used for
> +		conversion.
> +
> +Read more about iio bindings at
> +	Documentation/devicetree/bindings/iio/iio-bindings.txt
> +	
> +Example:
> +	ncp15wb473@0 {
> +		compatible = "ntc,ncp15wb473";
> +		pullup-uV = <1800000>;

	Is uV (uppercase) acceptable in dt bindings ?

> +		pullup-ohm = <47000>;
> +		pulldown-ohm = <0>;
> +		io-channels = <&adc 3>;
> +	};
> diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
> index b5f63f9..81d5bdc 100644
> --- a/drivers/hwmon/ntc_thermistor.c
> +++ b/drivers/hwmon/ntc_thermistor.c
> @@ -26,9 +26,16 @@
>  #include <linux/math64.h>
>  #include <linux/platform_device.h>
>  #include <linux/err.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
>  
>  #include <linux/platform_data/ntc_thermistor.h>
>  
> +#include <linux/iio/iio.h>
> +#include <linux/iio/machine.h>
> +#include <linux/iio/driver.h>
> +#include <linux/iio/consumer.h>
> +
>  #include <linux/hwmon.h>
>  #include <linux/hwmon-sysfs.h>
>  
> @@ -37,6 +44,15 @@ struct ntc_compensation {
>  	unsigned int	ohm;
>  };
>  
> +static const struct platform_device_id ntc_thermistor_id[] = {
> +	{ "ncp15wb473", TYPE_NCPXXWB473 },
> +	{ "ncp18wb473", TYPE_NCPXXWB473 },
> +	{ "ncp21wb473", TYPE_NCPXXWB473 },
> +	{ "ncp03wb473", TYPE_NCPXXWB473 },
> +	{ "ncp15wl333", TYPE_NCPXXWL333 },
> +	{ },
> +};
> +
>  /*
>   * A compensation table should be sorted by the values of .ohm
>   * in descending order.
> @@ -125,6 +141,76 @@ struct ntc_data {
>  	char name[PLATFORM_NAME_SIZE];
>  };
>  
> +#ifdef CONFIG_OF
> +static int ntc_adc_iio_read(struct ntc_thermistor_platform_data *pdata)
> +{
> +	struct iio_channel *channel = pdata->chan;
> +	unsigned int result;
> +	int val, ret;
> +
> +	ret = iio_read_channel_raw(channel, &val);
> +	if (ret < 0) {
> +		pr_err("read channel() error: %d\n", ret);
> +		return ret;
> +	}
> +
> +	/* unit: mV */
> +	result = pdata->pullup_uV * (s64) val;

	result is int, so the s64 typecast does not provide any value.
	Should result be s64 to avoid overflow errors ?

> +	result >>= 12;
> +
> +	return result;
> +}
> +
> +static const struct of_device_id ntc_match[] = {
> +	{ .compatible = "ntc,ncp15wb473",
> +		.data = &ntc_thermistor_id[TYPE_NCPXXWB473] },
> +	{ .compatible = "ntc,ncp18wb473",
> +		.data = &ntc_thermistor_id[TYPE_NCPXXWB473] },
> +	{ .compatible = "ntc,ncp21wb473",
> +		.data = &ntc_thermistor_id[TYPE_NCPXXWB473] },
> +	{ .compatible = "ntc,ncp03wb473",
> +		.data = &ntc_thermistor_id[TYPE_NCPXXWB473] },
> +	{ .compatible = "ntc,ncp15wl333",
> +		.data = &ntc_thermistor_id[TYPE_NCPXXWL333] },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, ntc_match);
> +
> +static int ntc_thermistor_parse_dt(struct ntc_thermistor_platform_data *pdata,
> +						struct platform_device *pdev)

Common style is to align the second line with '('. Applies everywhere.

> +{
> +	struct iio_channel *chan;
> +	struct device_node *np = pdev->dev.of_node;
> +
> +	if (!np)
> +		return -ENODEV;
> +
> +	chan = iio_channel_get(&pdev->dev, NULL);
> +	if (IS_ERR(chan))
> +		return IS_ERR(chan);

		return PTR_ERR(chann);

> +
> +	of_property_read_u32(np, "pullup-uV", &pdata->pullup_uV);
> +	of_property_read_u32(np, "pullup-ohm", &pdata->pullup_ohm);
> +	of_property_read_u32(np, "pulldown-ohm", &pdata->pulldown_ohm);
> +
The above properties are mandatory, so you should check the return value
of of_property_read_u32() and return an error if a property is not defined.
 
> +	if (of_find_property(np, "connected-positive", NULL))
> +		pdata->connect = NTC_CONNECTED_POSITIVE;
> +	else /* status change should be possible if not always on. */
> +		pdata->connect = NTC_CONNECTED_GROUND;
> +
> +	pdata->chan = chan;
> +	pdata->read_uV = ntc_adc_iio_read;
> +
> +	return 0;
> +}
> +#else
> +static int ntc_thermistor_parse_dt(struct ntc_thermistor_platform_data *pdata,
> +						struct platform_device *pdev)
> +{
> +	return -ENODEV;
> +}
> +#endif
> +
>  static inline u64 div64_u64_safe(u64 dividend, u64 divisor)
>  {
>  	if (divisor == 0 && dividend == 0)
> @@ -259,7 +345,7 @@ static int ntc_thermistor_get_ohm(struct ntc_data *data)
>  		return data->pdata->read_ohm();
>  
>  	if (data->pdata->read_uV) {
> -		read_uV = data->pdata->read_uV();
> +		read_uV = data->pdata->read_uV(data->pdata);
>  		if (read_uV < 0)
>  			return read_uV;
>  		return get_ohm_of_thermistor(data, read_uV);
> @@ -311,9 +397,22 @@ static const struct attribute_group ntc_attr_group = {
>  
>  static int ntc_thermistor_probe(struct platform_device *pdev)
>  {
> +	const struct of_device_id *of_id =
> +			of_match_device(of_match_ptr(ntc_match), &pdev->dev);
> +	const struct platform_device_id *pdev_id;
> +	struct ntc_thermistor_platform_data *pdata;
>  	struct ntc_data *data;
> -	struct ntc_thermistor_platform_data *pdata = pdev->dev.platform_data;
> -	int ret = 0;
> +	int ret;
> +
> +	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		return -ENOMEM;
> +

That allocation should really be in ntc_thermistor_parse_dt, otherwise
it is wasted in the non-OF case. ntc_thermistor_parse_dt can return a
pointer to it or ERR_PTR on failure or NULL in the non-OF case (or if
np is NULL). Then you don't need to check for -EPROBE_DEFER but can
just use

	pdata = ntc_thermistor_parse_dt(pdev);
	if (IS_ERR(pdata))
		return PTR_ERR(pdata);
	if (pdata == NULL)
		pdata = pdev->dev.platform_data;

This way you also catch other errors returned by iio_channel_get().

> +	ret = ntc_thermistor_parse_dt(pdata, pdev);
> +	if (ret == -EPROBE_DEFER)
> +		return ret;
> +	else if (ret < 0)

else is unnecessary here.

> +		pdata = pdev->dev.platform_data;
>  
>  	if (!pdata) {
>  		dev_err(&pdev->dev, "No platform init data supplied.\n");
> @@ -349,11 +448,13 @@ static int ntc_thermistor_probe(struct platform_device *pdev)
>  	if (!data)
>  		return -ENOMEM;
>  
> +	pdev_id = of_id ? of_id->data : platform_get_device_id(pdev);
> +
>  	data->dev = &pdev->dev;
>  	data->pdata = pdata;
> -	strlcpy(data->name, pdev->id_entry->name, sizeof(data->name));
> +	strncpy(data->name, pdev_id->name, sizeof(data->name));

	Why strncpy instead of strlcpy ?
	That means there is no guarantee that data->name is 0 terminated.

	Not that I mind if you have a good reason for not using strlcpy,
	but I just don't see it.

>  
> -	switch (pdev->id_entry->driver_data) {
> +	switch (pdev_id->driver_data) {
>  	case TYPE_NCPXXWB473:
>  		data->comp = ncpXXwb473;
>  		data->n_comp = ARRAY_SIZE(ncpXXwb473);
> @@ -364,8 +465,7 @@ static int ntc_thermistor_probe(struct platform_device *pdev)
>  		break;
>  	default:
>  		dev_err(&pdev->dev, "Unknown device type: %lu(%s)\n",
> -				pdev->id_entry->driver_data,
> -				pdev->id_entry->name);
> +				pdev_id->driver_data, pdev_id->name);
>  		return -EINVAL;
>  	}
>  
> @@ -384,39 +484,34 @@ static int ntc_thermistor_probe(struct platform_device *pdev)
>  		goto err_after_sysfs;
>  	}
>  
> -	dev_info(&pdev->dev, "Thermistor %s:%d (type: %s/%lu) successfully probed.\n",
> -			pdev->name, pdev->id, pdev->id_entry->name,
> -			pdev->id_entry->driver_data);
> +	dev_info(&pdev->dev, "Thermistor type: %s successfully probed.\n",
> +								pdev->name);
> +
>  	return 0;
>  err_after_sysfs:
>  	sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
> +	iio_channel_release(pdata->chan);

With that non-conditional, IIO would be mandatory. Also, iio_channel_release
does not check if the parameter is NULL, so if it is (ie in the non-OF case)
there will be a nice crash.

I would suggest to add a helper function such as 
	ntc_iio_channel_release()
to be defined in the conditional OF code above. It would be an empty function
for the non-OF case and otherwise call iio_channel_release().

To avoid such problems, you should try to build the driver with IIO disabled.

>  	return ret;
>  }
>  
>  static int ntc_thermistor_remove(struct platform_device *pdev)
>  {
>  	struct ntc_data *data = platform_get_drvdata(pdev);
> +	struct ntc_thermistor_platform_data *pdata = data->pdata;
>  
>  	hwmon_device_unregister(data->hwmon_dev);
>  	sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
> +	iio_channel_release(pdata->chan);

Same here.

>  	platform_set_drvdata(pdev, NULL);
>  
>  	return 0;
>  }
>  
> -static const struct platform_device_id ntc_thermistor_id[] = {
> -	{ "ncp15wb473", TYPE_NCPXXWB473 },
> -	{ "ncp18wb473", TYPE_NCPXXWB473 },
> -	{ "ncp21wb473", TYPE_NCPXXWB473 },
> -	{ "ncp03wb473", TYPE_NCPXXWB473 },
> -	{ "ncp15wl333", TYPE_NCPXXWL333 },
> -	{ },
> -};
> -
>  static struct platform_driver ntc_thermistor_driver = {
>  	.driver = {
>  		.name = "ntc-thermistor",
>  		.owner = THIS_MODULE,
> +		.of_match_table = of_match_ptr(ntc_match),
>  	},
>  	.probe = ntc_thermistor_probe,
>  	.remove = ntc_thermistor_remove,
> diff --git a/include/linux/platform_data/ntc_thermistor.h b/include/linux/platform_data/ntc_thermistor.h
> index 88734e8..6cf5081 100644
> --- a/include/linux/platform_data/ntc_thermistor.h
> +++ b/include/linux/platform_data/ntc_thermistor.h
> @@ -39,13 +39,17 @@ struct ntc_thermistor_platform_data {
>  	 * described at Documentation/hwmon/ntc_thermistor
>  	 *
>  	 * pullup/down_ohm: 0 for infinite / not-connected
> +	 *
> +	 * chan: iio_channel pointer to communicate with the ADC which the
> +	 * thermistor is using for conversion of the analog values.
>  	 */
> -	int (*read_uV)(void);
> +	int (*read_uV)(struct ntc_thermistor_platform_data *);
>  	unsigned int pullup_uV;
>  
>  	unsigned int pullup_ohm;
>  	unsigned int pulldown_ohm;
>  	enum { NTC_CONNECTED_POSITIVE, NTC_CONNECTED_GROUND } connect;
> +	struct iio_channel *chan;

Please specify
	struct iio_channel;
at the beginning of the include file.

>  
>  	int (*read_ohm)(void);
>  };
> -- 
> 1.7.9.5
> 
> 
