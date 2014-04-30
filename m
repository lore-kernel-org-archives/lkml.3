Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422713AbaD3P22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 11:28:28 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:60347 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422675AbaD3P2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 11:28:25 -0400
Date: Wed, 30 Apr 2014 08:27:54 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>, Jean Delvare <jdelvare@suse.de>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 10/10] hwmon: vexpress: Use devm helper for hwmon device
 registration
Message-ID: <20140430152754.GA30924@roeck-us.net>
References: <1398707877-22596-1-git-send-email-pawel.moll@arm.com>
 <1398707877-22596-11-git-send-email-pawel.moll@arm.com>
 <535EDD49.8050107@roeck-us.net>
 <1398870979.24255.37.camel@hornet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398870979.24255.37.camel@hornet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 04:16:19PM +0100, Pawel Moll wrote:
> On Mon, 2014-04-28 at 23:59 +0100, Guenter Roeck wrote:
> > On 04/28/2014 10:uct attribute_group **attr_groups;
> > > @@ -114,10 +95,13 @@ struct vexpress_hwmon_type {
> > >   static DEVICE_ATTR(in1_label, S_IRUGO, vexpress_hwmon_label_show, NULL);
> > >   static SENSOR_DEVICE_ATTR(in1_input, S_IRUGO, vexpress_hwmon_u32_show,
> > >   		NULL, 1000);
> > > -static VEXPRESS_HWMON_ATTRS(volt, in1_label, in1_input);
> > >   static struct attribute_group vexpress_hwmon_group_volt = {
> > >   	.is_visible = vexpress_hwmon_attr_is_visible,
> > > -	.attrs = vexpress_hwmon_attrs_volt,
> > > +	.attrs = (struct attribute *[]) {
> > 
> > Is this typecast necessary ?
> 
> Yes, it's the gcc extension that allows compound literals to be used for
> static structure members initialization. I like it, because it makes
> them easier to understand (in my opinion, that is), but if you prefer
> the classic approach, I'll unroll VEXPRESS_HWMON_ATTRS into:
> 
> static struct attribute vexpress_hwmon_attrs_volt = {
> 	&dev_attr_in1_label.attr,
> 	&sensor_dev_attr_in1_input.dev_attr.attr,
> 	NULL
> };
> 
> And keep
> 
> static struct attribute_group vexpress_hwmon_group_volt = {
>   	.is_visible = vexpress_hwmon_attr_is_visible,
> 	.attrs = vexpress_hwmon_attrs_volt,
> };
> 
Yes, would be great if you can do that.

> > > @@ -232,45 +227,19 @@ static int vexpress_hwmon_probe(struct platform_device *pdev)
> > >   	if (!match)
> > >   		return -ENODEV;
> > >   	type = match->data;
> > > -	data->name = type->name;
> > >
> > >   	data->reg = devm_regmap_init_vexpress_config(&pdev->dev);
> > > -	if (!data->reg)
> > > -		return -ENODEV;
> > > -
> > > -	err = sysfs_create_groups(&pdev->dev.kobj, type->attr_groups);
> > > -	if (err)
> > > -		goto error;
> > > -
> > > -	data->hwmon_dev = hwmon_device_register(&pdev->dev);
> > > -	if (IS_ERR(data->hwmon_dev)) {
> > > -		err = PTR_ERR(data->hwmon_dev);
> > > -		goto error;
> > > -	}
> > > +	if (IS_ERR(data->reg))
> > > +		return PTR_ERR(data->reg);
> > 
> > Did the API for devm_regmap_init_vexpress_config change ?
> > If so, it might make sense to separate this out into a separate patch,
> > together with the API change (it is a logically different change).
> 
> I'm not sure I understand the question. The other patch from the series

The code above seems to change from

   	data->reg = devm_regmap_init_vexpress_config(&pdev->dev);
	if (!data->reg)
		return -ENODEV;

to

   	data->reg = devm_regmap_init_vexpress_config(&pdev->dev);
	if (IS_ERR(data->reg))
		return PTR_ERR(data->reg);

as part of this patch. This suggests that the return value from
devm_regmap_init_vexpress_config may have changed from NULL to 
ERR_PTR. Is my understanding wrong ?

> I've copied you on
> (http://article.gmane.org/gmane.linux.ports.arm.kernel/320577 "[PATCH
> 02/10] mfd: vexpress: Convert custom func API to regmap") changes
> 
> -       data->func = vexpress_config_func_get_by_dev(&pdev->dev);
> 
> into
> 
> +       data->reg = devm_regmap_init_vexpress_config(&pdev->dev);
> 
> Your ack there, by the way, will be really appreciated :-)
> 
I'll have a look.

> > One question - I seem to be unable to apply the patch. What is your
> > baseline branch / repository ?
> 
> The whole series, based on v3.15-rc3 lives here:
> 
> 	git://git.linaro.org/people/pawel.moll/linux.git vexpress/sysreg
> 
Great, thanks.

Guenter
