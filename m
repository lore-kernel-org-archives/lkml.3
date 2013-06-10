Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab3FJVPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 17:15:18 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.111]:7802 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752518Ab3FJVPP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 17:15:15 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-160.messagelabs.com!1370898902!4856968!18
X-Originating-IP: [216.166.12.32]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "poeschel@lemonage.de" <poeschel@lemonage.de>,
        Ryan Mallon <rmallon@gmail.com>, "rob@landley.net" <rob@landley.net>
Date: Mon, 10 Jun 2013 16:12:34 -0500
Subject: RE: [PATCH v3] pwm: add sysfs interface
Thread-Topic: [PATCH v3] pwm: add sysfs interface
Thread-Index: Ac5mDLUAZizkoD6MSzeifw6wXQAGxAADEjQQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021DA690F4D2@AUSP01VMBX24.collaborationhost.net>
References: <201305301430.39692.hartleys@visionengravers.com>
 <20130610185950.GA25859@mithrandir>
In-Reply-To: <20130610185950.GA25859@mithrandir>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 10, 2013 12:00 PM, Thierry Reding wrote:
> On Thu, May 30, 2013 at 02:30:39PM -0700, H Hartley Sweeten wrote:
>> Add a simple sysfs interface to the generic PWM framework.
>
> Sorry for taking so long to review this.

Not a problem. Thanks for the review.

>>   /sys/class/pwm/
>>   `-- pwmchipN/          for each PWM chip
>>       |-- export         (w/o) ask the kernel to export a PWM channel
>>       |-- npwn           (r/o) number of PWM channels in this PWM chip
>
> "npwm"?

Fat-fingered that. Fixed.

>>       |-- pwmX/          for each exported PWM channel
>>       |   |-- duty_ns    (r/w) duty cycle (in nanoseconds)
>>       |   |-- enable     (r/w) enable/disable PWM
>>       |   |-- period_ns  (r/w) period (in nanoseconds)
>
> I'm not sure if we need the _ns suffix. If the documentation already
> specifies that it should be in nanoseconds, shouldn't that be enough?

In the earlier review of Lars Poeschel's patch I think you said you wanted the
attributes to match the variable names.

But, "duty' and "period" are probably close enough. Fixed.

>> diff --git a/Documentation/ABI/testing/sysfs-class-pwm b/Documentation/ABI/testing/sysfs-class-pwm
> [...]
>> +What:		/sys/class/pwm/pwmchipN/pwmX/polarity
>> +Date:		May 2013
>> +KernelVersion:	3.11
>> +Contact:	H Hartley Sweeten <hsweeten@visionengravers.com>
>> +Description:
>> +		Sets the output polarity of the PWM.
>> +		0 is normal polarity
>> +		1 is inversed polarity
>
>I think this was discussed before, and I think it makes sense to use the
>string representation here. polarity = 0 or polarity = 1 aren't very
>intuitive notations in my opinion.

You did mention that before. I overlooked it.

I'll change this.

>> diff --git a/Documentation/pwm.txt b/Documentation/pwm.txt
> [...]
>> +The PWM channels are PWM chip specific from 0 to npwn-1.
>
>"npwm-1". "channels are PWM chip specific" sounds a bit confusing. Maybe
>something like "The PWM channels are numbered using a per-chip index
>from 0 to npwm-1." is more precise?

Ok.

>> +When a PWM channel is exported a pwmX directory will be created in the
>> +pwmchipN directory it is associated with, where X is the channel number
>> +that was exported.
>
>"..., where X is the number of the channel that was exported."?

Ok.

>> The following properties will then be available:
>> +
>> +period_ns - The total period of the PWM (read/write).
>
> "PWM signal"?

OK.

>> +	Value is in nanoseconds and is the sum of the active and inactive
>> +	time of the PWM. If duty_ns is zero when this property is written
>> +	it will be automatically set to half the period_ns.
>
> I'm not sure that's the best approach. How about deferring the PWM
> configuration until both values have been set? Or only configure the PWM
> channel when it has been enabled, and refuse to enable unless both the
> period and the duty cycle have been set?

See below.

>> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
>> index 94ba21e..fb92e1d 100644
>> --- a/drivers/pwm/Makefile
>> +++ b/drivers/pwm/Makefile
>> @@ -1,4 +1,5 @@
>>  obj-$(CONFIG_PWM)		+= core.o
>> +obj-$(CONFIG_PWM_SYSFS)		+= pwm-sysfs.o
>
> I'd prefer this to simple be named sysfs.[co] in order to differentiate
> it from drivers and make it consistent with the naming of core.[co].

Ok.

>> diff --git a/drivers/pwm/pwm-sysfs.c b/drivers/pwm/pwm-sysfs.c
> [...]
>> +static struct pwm_device *dev_to_pwm_device(struct device *dev)
>> +{
>> +	struct pwm_export *pwm_export = dev_to_pwm_export(dev);
>
> Maybe drop the pwm_ prefix on the variable name?

Ok.

>> +static ssize_t pwm_period_ns_store(struct device *dev,
>> +				   struct device_attribute *attr,
>> +				   const char *buf, size_t size)
>> +{
>> +	struct pwm_device *pwm = dev_to_pwm_device(dev);
>> +	unsigned int duty = pwm->duty;
>> +	unsigned int val;
>> +	int ret;
>> +
>> +	ret = kstrtouint(buf, 0, &val);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* if not set, default to 50% duty cycle */
>> +	if (duty == 0)
>> +		duty = val / 2;
>
> How does this differentiate between the case where the user explicitly
> sets the duty cycle to 0 to "disable" the PWM?

It doesn't.

Actually, looking at pwm_config() a duty_ns value of 0 is allowed so this
check is not necessary.


>> +static ssize_t pwm_enable_store(struct device *dev,
>> +				struct device_attribute *attr,
>> +				const char *buf, size_t size)
>> +{
>> +	struct pwm_device *pwm = dev_to_pwm_device(dev);
>> +	int val;
>> +	int ret;
>
> These could go on one line.

Nitpick... Ok.

>> +
>> +	ret = kstrtoint(buf, 0, &val);
>> +	if (ret)
>> +		return ret;
>> +
>> +	switch (val) {
>> +	case 0:
>> +		pwm_disable(pwm);
>> +		ret = 0;
>
> I don't think ret can be anything other than 0 given the above validity
> check.

Ok.

>> +static ssize_t pwm_polarity_show(struct device *dev,
>> +				 struct device_attribute *attr,
>> +				 char *buf)
>> +{
>> +	const struct pwm_device *pwm = dev_to_pwm_device(dev);
>> +
>> +	return sprintf(buf, "%d\n", pwm->polarity);
>> +}
>> +
>> +static ssize_t pwm_polarity_store(struct device *dev,
>> +				  struct device_attribute *attr,
>> +				  const char *buf, size_t size)
>> +{
>> +	struct pwm_device *pwm = dev_to_pwm_device(dev);
>> +	enum pwm_polarity polarity;
>> +	int val;
>> +	int ret;
>
> Could go on a single line.

Ok.

>> +
>> +	ret = kstrtoint(buf, 0, &val);
>> +	if (ret)
>> +		return ret;
>> +
>> +	switch (val) {
>> +	case 0:
>> +		polarity = PWM_POLARITY_NORMAL;
>> +		break;
>> +	case 1:
>> +		polarity = PWM_POLARITY_INVERSED;
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret = pwm_set_polarity(pwm, polarity);
>> +
>> +	return ret ? : size;
>> +}
>> +
>> +static DEVICE_ATTR(period_ns, 0644, pwm_period_ns_show, pwm_period_ns_store);
>> +static DEVICE_ATTR(duty_ns, 0644, pwm_duty_ns_show, pwm_duty_ns_store);
>> +static DEVICE_ATTR(enable, 0644, pwm_enable_show, pwm_enable_store);
>> +static DEVICE_ATTR(polarity, 0644, pwm_polarity_show, pwm_polarity_store);
>> +
>> +static struct attribute *pwm_attrs[] = {
>> +	&dev_attr_period_ns.attr,
>> +	&dev_attr_duty_ns.attr,
>> +	&dev_attr_enable.attr,
>> +	&dev_attr_polarity.attr,
>> +	NULL
>> +};
>> +
>> +static struct attribute_group pwm_attr_group = {
>> +	.attrs		= pwm_attrs,
>> +};
>
> static const?

Ok.

>> +static void pwm_export_release(struct device *dev)
>> +{
>> +	struct pwm_export *pwm_export = dev_to_pwm_export(dev);
>> +
>> +	kfree(pwm_export);
>> +}
>
> Again, the pwm_ prefix for the variable name seems gratuitous here.

Ok.

>> +
>> +static int pwm_export(struct device *dev, struct pwm_device *pwm)
>> +{
>> +	struct pwm_export *pwm_export;
>
> And here as well.

Ok.

>> +static int pwm_unexport_match(struct device *dev, void *data)
>> +{
>> +	return dev_to_pwm_device(dev) == data;
>> +}
>> +
>> +static int pwm_unexport(struct device *dev, struct pwm_device *pwm)
>
> I think the current naming of variables is very confusing. It's hard to
> keep track of what's what. Maybe dev --> parent, or dev --> chip?
> Then...
>
>> +{
>> +	struct device *export_dev;
>
> export_dev --> dev, and...
>
>> +	struct pwm_export *pwm_export;
>
> pwm_export --> export?

I'll work out a clearer naming for the variables.

>> +
>> +	if (!test_and_clear_bit(PWMF_EXPORTED, &pwm->flags))
>> +		return -ENODEV;
>> +
>> +	export_dev = device_find_child(dev, pwm, pwm_unexport_match);
>> +	pwm_export = dev_to_pwm_export(export_dev);
>> +	put_device(&pwm_export->dev);
>> +	device_unregister(&pwm_export->dev);
>
> device_unregister() already calls put_device(), why do you do it again
> here?

device_find_child() does a get_device().

>> +	pwm_put(pwm);
>> +
>> +	return 0;
>> +}
>> +
>
> [...]
>> +void pwmchip_sysfs_export(struct pwm_chip *chip)
>> +{
>> +	/*
>> +	 * If device_create() fails the pwm_chip is still usable by
>> +	 * the kernel its just not exported.
>> +	 */
>> +	device_create(&pwm_class, chip->dev, MKDEV(0, 0), chip,
>> +		      "pwmchip%d", chip->base);
>> +}
>
> Maybe a warning message would still be useful in that case?

OK.

>> +void pwmchip_sysfs_unexport(struct pwm_chip *chip)
>> +{
>> +	struct device *dev;
>> +
>> +	dev = class_find_device(&pwm_class, NULL, chip, pwmchip_sysfs_match);
>> +	if (dev) {
>> +		put_device(dev);
>> +		device_unregister(dev);
>
>device_unregister() already calls put_device(), why do you do it again
> here?

class_find_device() does a get_device().

>> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
> [...]
>> +	unsigned int		duty;	/* in nanoseconds */
>
> I'd prefer this to be called duty_cycle.

Ok.

I'll clean this all up and post a v4 later.

Thanks,
Hartley

