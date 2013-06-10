Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab3FJS76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 14:59:58 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:50316 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab3FJS74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 14:59:56 -0400
Date: Mon, 10 Jun 2013 20:59:51 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-pwm@vger.kernel.org,
        linux-doc@vger.kernel.org, poeschel@lemonage.de,
        Ryan Mallon <rmallon@gmail.com>, rob@landley.net,
        hsweeten@visionengravers.com
Subject: Re: [PATCH v3] pwm: add sysfs interface
Message-ID: <20130610185950.GA25859@mithrandir>
References: <201305301430.39692.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <201305301430.39692.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2013 at 02:30:39PM -0700, H Hartley Sweeten wrote:
> Add a simple sysfs interface to the generic PWM framework.

Sorry for taking so long to review this.

>   /sys/class/pwm/
>   `-- pwmchipN/          for each PWM chip
>       |-- export         (w/o) ask the kernel to export a PWM channel
>       |-- npwn           (r/o) number of PWM channels in this PWM chip

"npwm"?

>       |-- pwmX/          for each exported PWM channel
>       |   |-- duty_ns    (r/w) duty cycle (in nanoseconds)
>       |   |-- enable     (r/w) enable/disable PWM
>       |   |-- period_ns  (r/w) period (in nanoseconds)

I'm not sure if we need the _ns suffix. If the documentation already
specifies that it should be in nanoseconds, shouldn't that be enough?

> diff --git a/Documentation/ABI/testing/sysfs-class-pwm b/Documentation/AB=
I/testing/sysfs-class-pwm
[...]
> +What:		/sys/class/pwm/pwmchipN/pwmX/polarity
> +Date:		May 2013
> +KernelVersion:	3.11
> +Contact:	H Hartley Sweeten <hsweeten@visionengravers.com>
> +Description:
> +		Sets the output polarity of the PWM.
> +		0 is normal polarity
> +		1 is inversed polarity

I think this was discussed before, and I think it makes sense to use the
string representation here. polarity =3D 0 or polarity =3D 1 aren't very
intuitive notations in my opinion.

> diff --git a/Documentation/pwm.txt b/Documentation/pwm.txt
[...]
> +The PWM channels are PWM chip specific from 0 to npwn-1.

"npwm-1". "channels are PWM chip specific" sounds a bit confusing. Maybe
something like "The PWM channels are numbered using a per-chip index
=66rom 0 to npwm-1." is more precise?

> +When a PWM channel is exported a pwmX directory will be created in the
> +pwmchipN directory it is associated with, where X is the channel number
> +that was exported.

"..., where X is the number of the channel that was exported."?

> The following properties will then be available:
> +
> +period_ns - The total period of the PWM (read/write).

"PWM signal"?

> +	Value is in nanoseconds and is the sum of the active and inactive
> +	time of the PWM. If duty_ns is zero when this property is written
> +	it will be automatically set to half the period_ns.

I'm not sure that's the best approach. How about deferring the PWM
configuration until both values have been set? Or only configure the PWM
channel when it has been enabled, and refuse to enable unless both the
period and the duty cycle have been set?

> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
> index 94ba21e..fb92e1d 100644
> --- a/drivers/pwm/Makefile
> +++ b/drivers/pwm/Makefile
> @@ -1,4 +1,5 @@
>  obj-$(CONFIG_PWM)		+=3D core.o
> +obj-$(CONFIG_PWM_SYSFS)		+=3D pwm-sysfs.o

I'd prefer this to simple be named sysfs.[co] in order to differentiate
it from drivers and make it consistent with the naming of core.[co].

> diff --git a/drivers/pwm/pwm-sysfs.c b/drivers/pwm/pwm-sysfs.c
[...]
> +static struct pwm_device *dev_to_pwm_device(struct device *dev)
> +{
> +	struct pwm_export *pwm_export =3D dev_to_pwm_export(dev);

Maybe drop the pwm_ prefix on the variable name?

> +static ssize_t pwm_period_ns_store(struct device *dev,
> +				   struct device_attribute *attr,
> +				   const char *buf, size_t size)
> +{
> +	struct pwm_device *pwm =3D dev_to_pwm_device(dev);
> +	unsigned int duty =3D pwm->duty;
> +	unsigned int val;
> +	int ret;
> +
> +	ret =3D kstrtouint(buf, 0, &val);
> +	if (ret)
> +		return ret;
> +
> +	/* if not set, default to 50% duty cycle */
> +	if (duty =3D=3D 0)
> +		duty =3D val / 2;

How does this differentiate between the case where the user explicitly
sets the duty cycle to 0 to "disable" the PWM?

> +static ssize_t pwm_enable_store(struct device *dev,
> +				struct device_attribute *attr,
> +				const char *buf, size_t size)
> +{
> +	struct pwm_device *pwm =3D dev_to_pwm_device(dev);
> +	int val;
> +	int ret;

These could go on one line.

> +
> +	ret =3D kstrtoint(buf, 0, &val);
> +	if (ret)
> +		return ret;
> +
> +	switch (val) {
> +	case 0:
> +		pwm_disable(pwm);
> +		ret =3D 0;

I don't think ret can be anything other than 0 given the above validity
check.

> +static ssize_t pwm_polarity_show(struct device *dev,
> +				 struct device_attribute *attr,
> +				 char *buf)
> +{
> +	const struct pwm_device *pwm =3D dev_to_pwm_device(dev);
> +
> +	return sprintf(buf, "%d\n", pwm->polarity);
> +}
> +
> +static ssize_t pwm_polarity_store(struct device *dev,
> +				  struct device_attribute *attr,
> +				  const char *buf, size_t size)
> +{
> +	struct pwm_device *pwm =3D dev_to_pwm_device(dev);
> +	enum pwm_polarity polarity;
> +	int val;
> +	int ret;

Could go on a single line.

> +
> +	ret =3D kstrtoint(buf, 0, &val);
> +	if (ret)
> +		return ret;
> +
> +	switch (val) {
> +	case 0:
> +		polarity =3D PWM_POLARITY_NORMAL;
> +		break;
> +	case 1:
> +		polarity =3D PWM_POLARITY_INVERSED;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	ret =3D pwm_set_polarity(pwm, polarity);
> +
> +	return ret ? : size;
> +}
> +
> +static DEVICE_ATTR(period_ns, 0644, pwm_period_ns_show, pwm_period_ns_st=
ore);
> +static DEVICE_ATTR(duty_ns, 0644, pwm_duty_ns_show, pwm_duty_ns_store);
> +static DEVICE_ATTR(enable, 0644, pwm_enable_show, pwm_enable_store);
> +static DEVICE_ATTR(polarity, 0644, pwm_polarity_show, pwm_polarity_store=
);
> +
> +static struct attribute *pwm_attrs[] =3D {
> +	&dev_attr_period_ns.attr,
> +	&dev_attr_duty_ns.attr,
> +	&dev_attr_enable.attr,
> +	&dev_attr_polarity.attr,
> +	NULL
> +};
> +
> +static struct attribute_group pwm_attr_group =3D {
> +	.attrs		=3D pwm_attrs,
> +};

static const?

> +static void pwm_export_release(struct device *dev)
> +{
> +	struct pwm_export *pwm_export =3D dev_to_pwm_export(dev);
> +
> +	kfree(pwm_export);
> +}

Again, the pwm_ prefix for the variable name seems gratuitous here.

> +
> +static int pwm_export(struct device *dev, struct pwm_device *pwm)
> +{
> +	struct pwm_export *pwm_export;

And here as well.

> +static int pwm_unexport_match(struct device *dev, void *data)
> +{
> +	return dev_to_pwm_device(dev) =3D=3D data;
> +}
> +
> +static int pwm_unexport(struct device *dev, struct pwm_device *pwm)

I think the current naming of variables is very confusing. It's hard to
keep track of what's what. Maybe dev --> parent, or dev --> chip?
Then...

> +{
> +	struct device *export_dev;

export_dev --> dev, and...

> +	struct pwm_export *pwm_export;

pwm_export --> export?

> +
> +	if (!test_and_clear_bit(PWMF_EXPORTED, &pwm->flags))
> +		return -ENODEV;
> +
> +	export_dev =3D device_find_child(dev, pwm, pwm_unexport_match);
> +	pwm_export =3D dev_to_pwm_export(export_dev);
> +	put_device(&pwm_export->dev);
> +	device_unregister(&pwm_export->dev);

device_unregister() already calls put_device(), why do you do it again
here?

> +	pwm_put(pwm);
> +
> +	return 0;
> +}
> +

[...]
> +void pwmchip_sysfs_export(struct pwm_chip *chip)
> +{
> +	/*
> +	 * If device_create() fails the pwm_chip is still usable by
> +	 * the kernel its just not exported.
> +	 */
> +	device_create(&pwm_class, chip->dev, MKDEV(0, 0), chip,
> +		      "pwmchip%d", chip->base);
> +}

Maybe a warning message would still be useful in that case?

> +void pwmchip_sysfs_unexport(struct pwm_chip *chip)
> +{
> +	struct device *dev;
> +
> +	dev =3D class_find_device(&pwm_class, NULL, chip, pwmchip_sysfs_match);
> +	if (dev) {
> +		put_device(dev);
> +		device_unregister(dev);

device_unregister() already calls put_device(), why do you do it again
here?

> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
[...]
> +	unsigned int		duty;	/* in nanoseconds */

I'd prefer this to be called duty_cycle.

Thierry

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRtiImAAoJEN0jrNd/PrOhSisP/1ItS3ha7PNizRkL9SpBTYNG
Hu3by3fP6K8DXI6bsVi2qFnM2qx7hWcS2uF70fHc78IFTx/BAZcVADvJPeBjKK1b
P3BIepCrR5U7o7LKneEaQAOyuKQdRQd2KuJ537jFeto3H7GJJz0cVwd+zurvU80N
DRwg3WENY90qsY+x5aERSySTSdgQmsCy3IXK6smRfR3czjb05D7u/Z9wtp7FKn/9
PuX6kIICsZlHEqKD1om8VctB6OchwvJfLBHfV+I9U7Fgn3qus2maKoAVClLvQlNg
Rky9zNItgks9lCJXPzdonSj4hNsJLdoKFL38M/FheoeEKElv73TxvINSirbaxS5W
RhivwlXFxK4CoUzs97mcNmbWam1juu2JrR1IIBJkCRftochO0o4cFNQvPtooJiLM
bMbI1KzA2EyS07vOVkKOahzBt9klELHEg5Ll6RZbpjRndKuH5OphrtNKDaBusP9f
hTiVDmUUvQEgMRXnRLt7fYXhNec4aiwfNaHTIE9Ycc+pPNXv+HcdIGCw7IUOsrWu
UQm72AU0r+8GxvISK9j0S/LZEY0EB5cLI8mO5UnLEcRrOBfZH4RLORfo1sJJ3SAz
OQ6hPdrnI4dGl/qXHcynLYlYKV9cC2r14FVgzsD0I/X1d1EWkV80sSnYU0gf8Mle
Uf6blAhzPH8EmGGH+EY4
=bqEj
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
