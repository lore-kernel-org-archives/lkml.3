Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbaD1W71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 18:59:27 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63908 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbaD1W70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 18:59:26 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <535EDD49.8050107@roeck-us.net>
Date: Mon, 28 Apr 2014 15:59:21 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Pawel Moll <pawel.moll@arm.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Jean Delvare <jdelvare@suse.de>,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH 10/10] hwmon: vexpress: Use devm helper for hwmon device
 registration
References: <1398707877-22596-1-git-send-email-pawel.moll@arm.com> <1398707877-22596-11-git-send-email-pawel.moll@arm.com>
In-Reply-To: <1398707877-22596-11-git-send-email-pawel.moll@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 10:57 AM, Pawel Moll wrote:
> Use devm_hwmon_device_register_with_groups instead of
> the old-style manual attributes and hwmon device registration.
>
> Also, unwind the attribute group macros for better code
> readability.
>
> Cc: Jean Delvare <jdelvare@suse.de>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: lm-sensors@lm-sensors.org
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---
>   drivers/hwmon/vexpress.c | 91 ++++++++++++++++--------------------------------
>   1 file changed, 30 insertions(+), 61 deletions(-)
>
> diff --git a/drivers/hwmon/vexpress.c b/drivers/hwmon/vexpress.c
> index d853332..ed6bf0e 100644
> --- a/drivers/hwmon/vexpress.c
> +++ b/drivers/hwmon/vexpress.c
> @@ -27,17 +27,8 @@
>   struct vexpress_hwmon_data {
>   	struct device *hwmon_dev;
>   	struct regmap *reg;
> -	const char *name;
>   };
>
> -static ssize_t vexpress_hwmon_name_show(struct device *dev,
> -		struct device_attribute *dev_attr, char *buffer)
> -{
> -	struct vexpress_hwmon_data *data = dev_get_drvdata(dev);
> -
> -	return sprintf(buffer, "%s\n", data->name);
> -}
> -
>   static ssize_t vexpress_hwmon_label_show(struct device *dev,
>   		struct device_attribute *dev_attr, char *buffer)
>   {
> @@ -95,16 +86,6 @@ static umode_t vexpress_hwmon_attr_is_visible(struct kobject *kobj,
>   	return attr->mode;
>   }
>
> -static DEVICE_ATTR(name, S_IRUGO, vexpress_hwmon_name_show, NULL);
> -
> -#define VEXPRESS_HWMON_ATTRS(_name, _label_attr, _input_attr)	\
> -struct attribute *vexpress_hwmon_attrs_##_name[] = {		\
> -	&dev_attr_name.attr,					\
> -	&dev_attr_##_label_attr.attr,				\
> -	&sensor_dev_attr_##_input_attr.dev_attr.attr,		\
> -	NULL							\
> -}
> -
>   struct vexpress_hwmon_type {
>   	const char *name;
>   	const struct attribute_group **attr_groups;
> @@ -114,10 +95,13 @@ struct vexpress_hwmon_type {
>   static DEVICE_ATTR(in1_label, S_IRUGO, vexpress_hwmon_label_show, NULL);
>   static SENSOR_DEVICE_ATTR(in1_input, S_IRUGO, vexpress_hwmon_u32_show,
>   		NULL, 1000);
> -static VEXPRESS_HWMON_ATTRS(volt, in1_label, in1_input);
>   static struct attribute_group vexpress_hwmon_group_volt = {
>   	.is_visible = vexpress_hwmon_attr_is_visible,
> -	.attrs = vexpress_hwmon_attrs_volt,
> +	.attrs = (struct attribute *[]) {

Is this typecast necessary ?

> +		&dev_attr_in1_label.attr,
> +		&sensor_dev_attr_in1_input.dev_attr.attr,
> +		NULL
> +	},
>   };
>   static struct vexpress_hwmon_type vexpress_hwmon_volt = {
>   	.name = "vexpress_volt",
> @@ -131,10 +115,13 @@ static struct vexpress_hwmon_type vexpress_hwmon_volt = {
>   static DEVICE_ATTR(curr1_label, S_IRUGO, vexpress_hwmon_label_show, NULL);
>   static SENSOR_DEVICE_ATTR(curr1_input, S_IRUGO, vexpress_hwmon_u32_show,
>   		NULL, 1000);
> -static VEXPRESS_HWMON_ATTRS(amp, curr1_label, curr1_input);
>   static struct attribute_group vexpress_hwmon_group_amp = {
>   	.is_visible = vexpress_hwmon_attr_is_visible,
> -	.attrs = vexpress_hwmon_attrs_amp,
> +	.attrs = (struct attribute *[]) {
> +		&dev_attr_curr1_label.attr,
> +		&sensor_dev_attr_curr1_input.dev_attr.attr,
> +		NULL
> +	},
>   };
>   static struct vexpress_hwmon_type vexpress_hwmon_amp = {
>   	.name = "vexpress_amp",
> @@ -147,10 +134,13 @@ static struct vexpress_hwmon_type vexpress_hwmon_amp = {
>   static DEVICE_ATTR(temp1_label, S_IRUGO, vexpress_hwmon_label_show, NULL);
>   static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, vexpress_hwmon_u32_show,
>   		NULL, 1000);
> -static VEXPRESS_HWMON_ATTRS(temp, temp1_label, temp1_input);
>   static struct attribute_group vexpress_hwmon_group_temp = {
>   	.is_visible = vexpress_hwmon_attr_is_visible,
> -	.attrs = vexpress_hwmon_attrs_temp,
> +	.attrs = (struct attribute *[]) {
> +		&dev_attr_temp1_label.attr,
> +		&sensor_dev_attr_temp1_input.dev_attr.attr,
> +		NULL
> +	},
>   };
>   static struct vexpress_hwmon_type vexpress_hwmon_temp = {
>   	.name = "vexpress_temp",
> @@ -163,10 +153,13 @@ static struct vexpress_hwmon_type vexpress_hwmon_temp = {
>   static DEVICE_ATTR(power1_label, S_IRUGO, vexpress_hwmon_label_show, NULL);
>   static SENSOR_DEVICE_ATTR(power1_input, S_IRUGO, vexpress_hwmon_u32_show,
>   		NULL, 1);
> -static VEXPRESS_HWMON_ATTRS(power, power1_label, power1_input);
>   static struct attribute_group vexpress_hwmon_group_power = {
>   	.is_visible = vexpress_hwmon_attr_is_visible,
> -	.attrs = vexpress_hwmon_attrs_power,
> +	.attrs = (struct attribute *[]) {
> +		&dev_attr_power1_label.attr,
> +		&sensor_dev_attr_power1_input.dev_attr.attr,
> +		NULL
> +	},
>   };
>   static struct vexpress_hwmon_type vexpress_hwmon_power = {
>   	.name = "vexpress_power",
> @@ -179,10 +172,13 @@ static struct vexpress_hwmon_type vexpress_hwmon_power = {
>   static DEVICE_ATTR(energy1_label, S_IRUGO, vexpress_hwmon_label_show, NULL);
>   static SENSOR_DEVICE_ATTR(energy1_input, S_IRUGO, vexpress_hwmon_u64_show,
>   		NULL, 1);
> -static VEXPRESS_HWMON_ATTRS(energy, energy1_label, energy1_input);
>   static struct attribute_group vexpress_hwmon_group_energy = {
>   	.is_visible = vexpress_hwmon_attr_is_visible,
> -	.attrs = vexpress_hwmon_attrs_energy,
> +	.attrs = (struct attribute *[]) {
> +		&dev_attr_energy1_label.attr,
> +		&sensor_dev_attr_energy1_input.dev_attr.attr,
> +		NULL
> +	},
>   };
>   static struct vexpress_hwmon_type vexpress_hwmon_energy = {
>   	.name = "vexpress_energy",
> @@ -218,7 +214,6 @@ MODULE_DEVICE_TABLE(of, vexpress_hwmon_of_match);
>
>   static int vexpress_hwmon_probe(struct platform_device *pdev)
>   {
> -	int err;
>   	const struct of_device_id *match;
>   	struct vexpress_hwmon_data *data;
>   	const struct vexpress_hwmon_type *type;
> @@ -232,45 +227,19 @@ static int vexpress_hwmon_probe(struct platform_device *pdev)
>   	if (!match)
>   		return -ENODEV;
>   	type = match->data;
> -	data->name = type->name;
>
>   	data->reg = devm_regmap_init_vexpress_config(&pdev->dev);
> -	if (!data->reg)
> -		return -ENODEV;
> -
> -	err = sysfs_create_groups(&pdev->dev.kobj, type->attr_groups);
> -	if (err)
> -		goto error;
> -
> -	data->hwmon_dev = hwmon_device_register(&pdev->dev);
> -	if (IS_ERR(data->hwmon_dev)) {
> -		err = PTR_ERR(data->hwmon_dev);
> -		goto error;
> -	}
> +	if (IS_ERR(data->reg))
> +		return PTR_ERR(data->reg);

Did the API for devm_regmap_init_vexpress_config change ?
If so, it might make sense to separate this out into a separate patch,
together with the API change (it is a logically different change).

Otherwise looks good.

One question - I seem to be unable to apply the patch. What is your baseline branch / repository ?

Thanks,
Guenter

