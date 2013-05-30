Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899Ab3E3CBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 22:01:52 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:49369 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759846Ab3E3CBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 22:01:45 -0400
Message-ID: <51A6B303.9050203@gmail.com>
Date: Thu, 30 May 2013 12:01:39 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        thierry.reding@avionic-design.de, poeschel@lemonage.de
Subject: Re: [PATCH] pwm: add sysfs interface
References: <201305291408.07000.hartleys@visionengravers.com>
In-Reply-To: <201305291408.07000.hartleys@visionengravers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/05/13 07:08, H Hartley Sweeten wrote:
> Add a simple sysfs interface to the PWM framework.
> 
>   /sys/class/pwm/
>   `-- pwmchipN/          for each PWM chip
>       |-- export         (w/o) ask the kernel to export a PWM to userspace
>       |-- npwm           (r/o) number of PWM in pwmchipN
>       |-- pwmN/          for each exported PWM
>       |   |-- duty_ns    (r/w) duty cycle (in nanoseconds)
>       |   |-- enable     (r/w) enable/disable PWM
>       |   |-- period_ns  (r/w) period (in nanoseconds)
>       |   `-- polarity   (r/w) polarity of PWM
>       `-- unexport       (w/o) return a PWM to the kernel
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Lars Poeschel <poeschel@lemonage.de>
> ---
> This is based on previous work by Lars Poeshel.

Some comments below.

You will also fail to get this past Greg KH unless you add documentation
for the new sysfs interface to Documentation/ABI/stable/.

~Ryan

> 
>  drivers/pwm/Kconfig     |   6 +
>  drivers/pwm/Makefile    |   1 +
>  drivers/pwm/core.c      |  25 +++-
>  drivers/pwm/pwm-sysfs.c | 357 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pwm.h     |  28 ++++
>  5 files changed, 415 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/pwm/pwm-sysfs.c
> 
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 115b644..61a53b5 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -28,6 +28,12 @@ menuconfig PWM
>  
>  if PWM
>  
> +config PWM_SYSFS
> +	bool "/sys/class/pwm/... (sysfs interface)"
> +	depends on SYSFS
> +	help
> +	  Say Y here to provide a sysfs interface to control PWMs.
> +
>  config PWM_AB8500
>  	tristate "AB8500 PWM support"
>  	depends on AB8500_CORE && ARCH_U8500
> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
> index 94ba21e..fb92e1d 100644
> --- a/drivers/pwm/Makefile
> +++ b/drivers/pwm/Makefile
> @@ -1,4 +1,5 @@
>  obj-$(CONFIG_PWM)		+= core.o
> +obj-$(CONFIG_PWM_SYSFS)		+= pwm-sysfs.o
>  obj-$(CONFIG_PWM_AB8500)	+= pwm-ab8500.o
>  obj-$(CONFIG_PWM_ATMEL_TCB)	+= pwm-atmel-tcb.o
>  obj-$(CONFIG_PWM_BFIN)		+= pwm-bfin.o
> diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
> index 32221cb..f67465c 100644
> --- a/drivers/pwm/core.c
> +++ b/drivers/pwm/core.c
> @@ -274,6 +274,8 @@ int pwmchip_add(struct pwm_chip *chip)
>  	if (IS_ENABLED(CONFIG_OF))
>  		of_pwmchip_add(chip);
>  
> +	pwmchip_sysfs_export(chip);
> +
>  out:
>  	mutex_unlock(&pwm_lock);
>  	return ret;
> @@ -310,6 +312,8 @@ int pwmchip_remove(struct pwm_chip *chip)
>  
>  	free_pwms(chip);
>  
> +	pwmchip_sysfs_unexport(chip);
> +
>  out:
>  	mutex_unlock(&pwm_lock);
>  	return ret;
> @@ -402,10 +406,19 @@ EXPORT_SYMBOL_GPL(pwm_free);
>   */
>  int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
>  {
> +	int err;
> +
>  	if (!pwm || duty_ns < 0 || period_ns <= 0 || duty_ns > period_ns)
>  		return -EINVAL;
>  
> -	return pwm->chip->ops->config(pwm->chip, pwm, duty_ns, period_ns);
> +	err = pwm->chip->ops->config(pwm->chip, pwm, duty_ns, period_ns);
> +	if (err)
> +		return err;
> +
> +	pwm->duty = duty_ns;
> +	pwm->period = period_ns;
> +
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(pwm_config);
>  
> @@ -418,6 +431,8 @@ EXPORT_SYMBOL_GPL(pwm_config);
>   */
>  int pwm_set_polarity(struct pwm_device *pwm, enum pwm_polarity polarity)
>  {
> +	int err;
> +
>  	if (!pwm || !pwm->chip->ops)
>  		return -EINVAL;
>  
> @@ -427,7 +442,13 @@ int pwm_set_polarity(struct pwm_device *pwm, enum pwm_polarity polarity)
>  	if (test_bit(PWMF_ENABLED, &pwm->flags))
>  		return -EBUSY;
>  
> -	return pwm->chip->ops->set_polarity(pwm->chip, pwm, polarity);
> +	err = pwm->chip->ops->set_polarity(pwm->chip, pwm, polarity);
> +	if (err)
> +		return err;
> +
> +	pwm->polarity = polarity;
> +
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(pwm_set_polarity);
>  
> diff --git a/drivers/pwm/pwm-sysfs.c b/drivers/pwm/pwm-sysfs.c
> new file mode 100644
> index 0000000..6a2bf76
> --- /dev/null
> +++ b/drivers/pwm/pwm-sysfs.c
> @@ -0,0 +1,357 @@
> +/*
> + * A simple sysfs interface for the generic PWM framework
> + *
> + * Copyright (C) 2013 H Hartley Sweeten <hsweeten@visionengravers.com>
> + *
> + * Based on previous work by Lars Poeschel <poeschel@lemonage.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2, or (at your option)
> + * any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/mutex.h>
> +#include <linux/err.h>
> +#include <linux/slab.h>
> +#include <linux/kdev_t.h>
> +#include <linux/pwm.h>
> +
> +struct pwm_export {
> +	struct device dev;
> +	struct pwm_device *pwm;
> +};
> +
> +static struct pwm_export *dev_to_pwm_export(struct device *dev)
> +{
> +	return container_of(dev, struct pwm_export, dev);
> +}
> +
> +static struct pwm_device *dev_to_pwm_device(struct device *dev)
> +{
> +	struct pwm_export *pwm_export = dev_to_pwm_export(dev);
> +
> +	return pwm_export->pwm;
> +}
> +
> +static ssize_t pwm_period_ns_show(struct device *dev,
> +				  struct device_attribute *attr,
> +				  char *buf)
> +{
> +	const struct pwm_device *pwm = dev_to_pwm_device(dev);
> +
> +	return sprintf(buf, "%u\n", pwm->period);
> +}
> +
> +static ssize_t pwm_period_ns_store(struct device *dev,
> +				   struct device_attribute *attr,
> +				   const char *buf, size_t size)
> +{
> +	struct pwm_device *pwm = dev_to_pwm_device(dev);
> +	unsigned int val;
> +	int ret;
> +
> +	ret = kstrtouint(buf, 0, &val);
> +	if (ret)
> +		return ret;
> +
> +	if (val <= pwm->duty)
> +		return -EINVAL;
> +
> +	pwm->period = val;
> +
> +	if (test_bit(PWMF_ENABLED, &pwm->flags))
> +		ret = pwm_config(pwm, pwm->duty, pwm->period);
> +
> +	return ret ? : size;

There are a few problems with this:

pwm->period gets set even if pwm_config fails. It should instead pass
val in for the period, since pwm_config will set pwm->period if it is
succesful.

If the pwm is not enabled then the return value will be the result of
kstrtouint, which will be 0. You probably want to return -EPERM or
something if the pwm cannot be configured because it is not enabled.

There is no locking for pwm_config, so a call from user-space can race
with a call to pwm_config in the kernel. This is probably non-trivial to
solve, since some pwm's will be mutex lockable, while others might be
calling pwm_config, etc from atomic paths.

Likewise, the pwm could become disabled (by another path in the kernel)
between the test_bit check and the call to pwm_config.

> +}
> +
> +static ssize_t pwm_duty_ns_show(struct device *dev,
> +				struct device_attribute *attr,
> +				char *buf)
> +{
> +	const struct pwm_device *pwm = dev_to_pwm_device(dev);
> +
> +	return sprintf(buf, "%u\n", pwm->duty);
> +}
> +
> +static ssize_t pwm_duty_ns_store(struct device *dev,
> +				 struct device_attribute *attr,
> +				 const char *buf, size_t size)
> +{
> +	struct pwm_device *pwm = dev_to_pwm_device(dev);
> +	unsigned int val;
> +	int ret;
> +
> +	ret = kstrtouint(buf, 0, &val);
> +	if (ret)
> +		return ret;
> +
> +	if (val >= pwm->period)
> +		return -EINVAL;
> +
> +	pwm->duty = val;
> +
> +	if (test_bit(PWMF_ENABLED, &pwm->flags))
> +		ret = pwm_config(pwm, pwm->duty, pwm->period);
> +
> +	return ret ? : size;
> +}
> +
> +static ssize_t pwm_enable_show(struct device *dev,
> +			       struct device_attribute *attr,
> +			       char *buf)
> +{
> +	const struct pwm_device *pwm = dev_to_pwm_device(dev);
> +	int enabled = test_bit(PWMF_ENABLED, &pwm->flags);
> +
> +	return sprintf(buf, "%sabled\n", enabled ? "en" : "dis");
> +}
> +
> +static ssize_t pwm_enable_store(struct device *dev,
> +				struct device_attribute *attr,
> +				const char *buf, size_t size)
> +{
> +	struct pwm_device *pwm = dev_to_pwm_device(dev);
> +	int val;
> +	int ret;
> +
> +	ret = kstrtoint(buf, 0, &val);
> +	if (ret)
> +		return ret;
> +
> +	if (val) {
> +		ret = pwm_config(pwm, pwm->duty, pwm->period);
> +		if (ret)
> +			return ret;
> +		ret = pwm_enable(pwm);
> +	} else {
> +		pwm_disable(pwm);
> +	}
> +
> +	return ret ? : size;
> +}
> +
> +static ssize_t pwm_polarity_show(struct device *dev,
> +				 struct device_attribute *attr,
> +				 char *buf)
> +{
> +	const struct pwm_device *pwm = dev_to_pwm_device(dev);
> +	int polarity = (pwm->polarity == PWM_POLARITY_NORMAL);
> +
> +	return sprintf(buf, "%s\n", polarity ? "normal" : "inversed");
> +}
> +
> +static ssize_t pwm_polarity_store(struct device *dev,
> +				  struct device_attribute *attr,
> +				  const char *buf, size_t size)
> +{
> +	struct pwm_device *pwm = dev_to_pwm_device(dev);
> +	enum pwm_polarity polarity;
> +	int val;
> +	int ret;
> +
> +	ret = kstrtoint(buf, 0, &val);
> +	if (ret)
> +		return ret;
> +
> +	switch (val) {
> +	case 0:
> +		polarity = PWM_POLARITY_NORMAL;
> +		break;
> +	case 1:
> +		polarity = PWM_POLARITY_INVERSED;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}

The show function prints a string form, so the store function should
probably allow a string input value also?

> +
> +	ret = pwm_set_polarity(pwm, polarity);
> +
> +	return ret ? : size;
> +}
> +
> +static DEVICE_ATTR(period_ns, 0644, pwm_period_ns_show, pwm_period_ns_store);
> +static DEVICE_ATTR(duty_ns, 0644, pwm_duty_ns_show, pwm_duty_ns_store);
> +static DEVICE_ATTR(enable, 0644, pwm_enable_show, pwm_enable_store);
> +static DEVICE_ATTR(polarity, 0644, pwm_polarity_show, pwm_polarity_store);
> +
> +static struct attribute *pwm_attrs[] = {
> +	&dev_attr_period_ns.attr,
> +	&dev_attr_duty_ns.attr,
> +	&dev_attr_enable.attr,
> +	NULL
> +};
> +
> +static struct attribute_group pwm_attr_group = {
> +	.attrs		= pwm_attrs,
> +};
> +
> +static void pwm_export_release(struct device *dev)
> +{
> +	struct pwm_export *pwm_export = dev_to_pwm_export(dev);
> +
> +	kfree(pwm_export);
> +}
> +
> +static int pwm_export(struct device *dev, struct pwm_device *pwm)
> +{
> +	struct pwm_export *pwm_export;
> +	struct kobject *kobj;
> +	int ret;
> +
> +	if (test_and_set_bit(PWMF_EXPORTED, &pwm->flags))
> +		return -EBUSY;
> +
> +	pwm_export = kzalloc(sizeof(*pwm_export), GFP_KERNEL);
> +	if (!pwm_export)
> +		return -ENOMEM;

Leaves PWMF_EXPORTED set.

> +
> +	pwm_export->pwm = pwm;
> +
> +	pwm_export->dev.release = pwm_export_release;
> +	pwm_export->dev.parent = dev;
> +	pwm_export->dev.devt = MKDEV(0, 0);
> +	dev_set_name(&pwm_export->dev, "pwm%u", pwm->hwpwm);
> +	ret = device_register(&pwm_export->dev);
> +	if (ret)
> +		return ret;

Leaks pwm_export and leaves the exported bit set. More leaks on the
error paths below.

> +
> +	kobj = &pwm_export->dev.kobj;
> +
> +	ret = sysfs_create_group(kobj, &pwm_attr_group);
> +	if (ret)
> +		return ret;
> +
> +	if (pwm->chip->ops->set_polarity) {
> +		ret = sysfs_create_file(kobj, &dev_attr_polarity.attr);
> +		if (ret) {
> +			sysfs_remove_group(kobj, &pwm_attr_group);
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static int pwm_unexport_match(struct device *dev, void *data)
> +{
> +	return dev_to_pwm_device(dev) == data;
> +}
> +
> +static int pwm_unexport(struct device *dev, struct pwm_device *pwm)
> +{
> +	if (test_and_clear_bit(PWMF_EXPORTED, &pwm->flags)) {
> +		struct device *export_dev;
> +		struct pwm_export *pwm_export;
> +		struct kobject *kobj;
> +
> +		export_dev = device_find_child(dev, pwm, pwm_unexport_match);
> +		pwm_export = dev_to_pwm_export(export_dev);
> +		kobj = &pwm_export->dev.kobj;

Is it worth sanity checking export_dev and pwm_export here?

> +
> +		if (pwm->chip->ops->set_polarity)
> +			sysfs_remove_file(kobj, &dev_attr_polarity.attr);
> +
> +		sysfs_remove_group(kobj, &pwm_attr_group);
> +
> +		put_device(&pwm_export->dev);
> +		device_unregister(&pwm_export->dev);
> +		pwm_put(pwm);
> +	}
> +	return 0;

Why return a value if this function always succeeds?

> +}
> +
> +static ssize_t pwm_export_store(struct device *dev,
> +				struct device_attribute *attr,
> +				const char *buf, size_t len)
> +{
> +	struct pwm_chip *chip = dev_get_drvdata(dev);
> +	struct pwm_device *pwm;
> +	unsigned int hwpwm;
> +	int ret;
> +
> +	ret = kstrtouint(buf, 0, &hwpwm);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (hwpwm >= chip->npwm)
> +		return -ENODEV;
> +
> +	pwm = pwm_request_from_chip(chip, hwpwm, "sysfs");
> +	if (IS_ERR(pwm))
> +		return PTR_ERR(pwm);
> +
> +	ret = pwm_export(dev, pwm);
> +	if (ret < 0)
> +		pwm_put(pwm);
> +
> +	return ret ? : len;
> +}
> +
> +static ssize_t pwm_unexport_store(struct device *dev,
> +				  struct device_attribute *attr,
> +				  const char *buf, size_t len)
> +{
> +	struct pwm_chip *chip = dev_get_drvdata(dev);
> +	unsigned int hwpwm;
> +	int ret;
> +
> +	ret = kstrtouint(buf, 0, &hwpwm);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (hwpwm >= chip->npwm)
> +		return -ENODEV;
> +
> +	ret = pwm_unexport(dev, &chip->pwms[hwpwm]);
> +
> +	return ret ? : len;

This should return an error (e.g. -EPERM or -ENODEV) if the pwm is not
exported.

> +}
> +
> +static ssize_t pwm_npwm_show(struct device *dev,
> +			     struct device_attribute *attr,
> +			     char *buf)
> +{
> +	const struct pwm_chip *chip = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%u\n", chip->npwm);
> +}
> +
> +static struct device_attribute pwm_chip_attrs[] = {
> +	__ATTR(export, 0200, NULL, pwm_export_store),
> +	__ATTR(unexport, 0200, NULL, pwm_unexport_store),
> +	__ATTR(npwm, 0444, pwm_npwm_show, NULL),
> +	__ATTR_NULL,
> +};
> +
> +static struct class pwm_class = {
> +	.name		= "pwm",
> +	.owner		= THIS_MODULE,
> +	.dev_attrs	= pwm_chip_attrs,
> +};
> +
> +void pwmchip_sysfs_export(struct pwm_chip *chip)
> +{
> +	chip->dev = device_create(&pwm_class, chip->dev, MKDEV(0, 0), chip,
> +				  "pwmchip%d", chip->base);

	if (IS_ERR(chip->dev))
		?

> +}
> +
> +void pwmchip_sysfs_unexport(struct pwm_chip *chip)
> +{
> +	if (chip->dev) {
> +		put_device(chip->dev);
> +		device_unregister(chip->dev);
> +	}
> +}
> +
> +static int __init pwm_sysfs_init(void)
> +{
> +	return class_register(&pwm_class);
> +}
> +subsys_initcall(pwm_sysfs_init);
> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
> index a4df204..e734ce6 100644
> --- a/include/linux/pwm.h
> +++ b/include/linux/pwm.h
> @@ -76,6 +76,7 @@ enum pwm_polarity {
>  enum {
>  	PWMF_REQUESTED = 1 << 0,
>  	PWMF_ENABLED = 1 << 1,
> +	PWMF_EXPORTED = 1 << 2,
>  };
>  
>  struct pwm_device {
> @@ -86,7 +87,10 @@ struct pwm_device {
>  	struct pwm_chip		*chip;
>  	void			*chip_data;
>  
> +	struct device		*dev;	/* for sysfs export */
>  	unsigned int		period; /* in nanoseconds */
> +	unsigned int		duty;	/* in nanoseconds */
> +	enum pwm_polarity 	polarity;
>  };
>  
>  static inline void pwm_set_period(struct pwm_device *pwm, unsigned int period)
> @@ -100,6 +104,17 @@ static inline unsigned int pwm_get_period(struct pwm_device *pwm)
>  	return pwm ? pwm->period : 0;
>  }
>  
> +static inline void pwm_set_duty_cycle(struct pwm_device *pwm, unsigned int duty)
> +{
> +	if (pwm)
> +		pwm->duty = duty;
> +}
> +
> +static inline unsigned int pwm_get_duty_cycle(struct pwm_device *pwm)
> +{
> +	return pwm ? pwm->duty : 0;
> +}
> +
>  /*
>   * pwm_set_polarity - configure the polarity of a PWM signal
>   */
> @@ -278,4 +293,17 @@ static inline void pwm_add_table(struct pwm_lookup *table, size_t num)
>  }
>  #endif
>  
> +#ifdef CONFIG_PWM_SYSFS
> +void pwmchip_sysfs_export(struct pwm_chip *chip);
> +void pwmchip_sysfs_unexport(struct pwm_chip *chip);
> +#else
> +static inline void pwmchip_sysfs_export(struct pwm_chip *chip)
> +{
> +}
> +
> +static inline void pwmchip_sysfs_unexport(struct pwm_chip *chip)
> +{
> +}
> +#endif /* CONFIG_PWM_SYSFS */
> +
>  #endif /* __LINUX_PWM_H */
> 

