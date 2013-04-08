Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934841Ab3DHIT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 04:19:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64400 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934378Ab3DHIR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 04:17:58 -0400
Date: Mon, 8 Apr 2013 10:17:45 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Lars Poeschel <larsi@wh2.tu-dresden.de>
Cc: poeschel@lemonage.de, rob@landley.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v1] pwm: add sysfs interface
Message-ID: <20130408081745.GA21392@avionic-0098.mockup.avionic-design.de>
References: <1364997536-9246-1-git-send-email-larsi@wh2.tu-dresden.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <1364997536-9246-1-git-send-email-larsi@wh2.tu-dresden.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:3BXi7cIz5ivzwCmM27nfjn1WYdhSpuboL6icnhwv9rX
 LgFD5u6bndeiOV08lfdGN2/xKVnDr2JRP0O6D1rGq1sNQSpIJK
 zKFWaafmm9ymmS36T5lcuq+L8AqBqEIOilqThAK4IUCJhmExy0
 S2LkBf+1Z2v/klYOuADCtJIZB2LxjMFQ/TEvybF2rUBs6W9ya0
 oHEGOlp1jqhBYXInVeDk2fML7KzgGvOktKotG9Jft7+aj5Vt2E
 tuxEMtE1jZQs7Tv4E8ZfgGrEATyyr/P2x3mx5q1nHcQ86dZuWS
 nBRbx1mvS+xn90yt/wgNR5ybL9FIsoI3uGdDq21ZzrGxith4jQ
 w7h9fv37ZgP1uQ7tBk3nTeY2sK0tiBahS9lF/eOQLT2QFblLB7
 rRZI5/Zho/IrN20nXmea9ZO9xRqtrJP/Mg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 03, 2013 at 03:58:55PM +0200, Lars Poeschel wrote:
> From: Lars Poeschel <poeschel@lemonage.de>
>=20
> This adds a simple sysfs interface to the pwm subsystem. It is
> heavily inspired by the gpio sysfs interface.
>=20
>         /sys/class/pwm
>                 /export ... asks the kernel to export a PWM to userspace
>                 /unexport ... to return a PWM to the kernel
>             /pwmN ... for each exported PWM #N
>             /duty_ns ... r/w, length of duty portion
>             /period_ns ... r/w, length of the pwm period

"pwm" -> "PWM". There are other occurrences of this in the remainder of
the patch. I haven't explicitly pointed them out, but please check those
too. The rule of thumb is to use all uppercase PWM in prose because it
is an abbreviation. The lowercase variant is okay for variable names and
such.

>             /polarity ... r/w, normal(0) or inverse(1) polarity
>                                only created if driver supports it
>             /run ... r/w, write 1 to start and 0 to stop the pwm
>         /pwmchipN ... for each pwmchip; #N is its first PWM

I think I'd prefer "for each PWM chip", or "for each pwm_chip". No data
structure named pwmchip exists in the kernel.

>             /base ... (r/o) same as N
>             /ngpio ... (r/o) number of PWM; numbered N .. MAX_PWMS

"npwm"? "number of PWM devices"? MAX_PWMS -> N + (npwm - 1)?

> diff --git a/Documentation/ABI/testing/sysfs-class-pwm b/Documentation/AB=
I/testing/sysfs-class-pwm
> new file mode 100644
> index 0000000..e9be1a3
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-pwm
> @@ -0,0 +1,37 @@
> +What:		/sys/class/pwm/
> +Date:		March 2013
> +KernelVersion:	3.11
> +Contact:	Lars Poeschel <poeschel@lemonage.de>
> +Description:
> +
> +  The sysfs interface for PWM is selectable as a Kconfig option.
> +  If a driver successfully probed a pwm chip, it appears at

"PWM chip" please.

> +  /sys/class/pwm/pwmchipN/ where N is the number of it's first PWM chann=
el. A

"it's" -> "its"

Also this highlights a fundamental problem with this patch. I know
people like to handle PWMs the same as GPIOs, but the problem here is
that the PWM subsystem was designed to do per-chip indexing. The global
namespace was introduced only for backwards compatibility. An explicit
goal was to get rid of the global namespace once all uses of the legacy
API have been removed.

This whole sysfs interface relies on the fact that there is some global
namespace, so if we expose the global namespace to userspace via sysfs
we make it much harder to get rid of it. So instead of using pwmchipN as
the name I think it'd be better to use the device name for the directory
entry in sysfs (much like the backlight, power or other classes).

On a side-note, there's really no need to encode the base in the name,
since you can much more easily obtain it from the base attribute.

> +  single driver may probe multiple chips.

That sentence is superfluous. I think it's a generally accepted fact
that one driver can probe multiple devices.

>                                              PWMs are identified as they =
are
> +  inside the kernel, using integers in the range 0..MAX_PWMS. To use an
> +  individual PWM, you have to explicitly export it by writing it's kernel
> +  global number into the /sys/class/pwm/export file. Write it's number to
> +  /sys/class/pwm/unexport to make the pwm available for other uses.

For reasons explained above I think we should make each PWM channel
exportable via its chip. That would expose the per-chip indexing in the
sysfs interface. In other words the export/unexport attributes should be
moved within the pwm_chip nodes.

> +  After a PWM channel is exported, it is available under
> +  /sys/class/pwm/pwmN/. Under this directory you can set the parameters =
for
> +  this PWM channel and at least let it start running.

I don't understand the last part of this sentence. "at least let it
start running"?

> +  See below for the parameters.
> +  It is recommended to set the period_ns at first and the duty_ns after =
that.

Why is it recommended to set the period_ns first and then duty_ns? Both
typically need to be set atomically, which is why the in-kernel function
that configures a PWM channel takes both as parameters. Can we not post-
pone setting these until we actually enable the PWM?

I think further the it might be safer to disable the PWM as soon as any
of the attributes is written and require the user to explicitly enable
it again when they have finished configuration.

> +Directory structure:
> +
> +	/sys/class/pwm
> +		/export ... asks the kernel to export a PWM to userspace
> +		/unexport ... to return a PWM to the kernel
> +		/pwmN ... for each exported PWM #N
> +			/duty_ns ... r/w, length of duty portion
> +			/period_ns ... r/w, length of the pwm period
> +			/polarity ... r/w, normal(0) or inverse(1) polarity
> +					only created if driver supports it

This is ambiguous. Do you need to write "normal" or "0" to the file to
set normal polarity?

> +			/run ... r/w, write 1 to start and 0 to stop the pwm

I'd prefer this to be named "enable" to match the in-kernel function
names.

> +		/pwmchipN ... for each pwmchip; #N is its first PWM
> +			/base ... (r/o) same as N
> +			/ngpio ... (r/o) number of PWM; numbered N .. MAX_PWMS

I've already commented on these in the patch description.

> diff --git a/Documentation/pwm.txt b/Documentation/pwm.txt
> index 7d2b4c9..b349d16 100644
> --- a/Documentation/pwm.txt
> +++ b/Documentation/pwm.txt
> @@ -45,6 +45,52 @@ int pwm_config(struct pwm_device *pwm, int duty_ns, in=
t period_ns);
> =20
>  To start/stop toggling the PWM output use pwm_enable()/pwm_disable().
> =20
> +Using PWMs with the sysfs interface
> +-----------------------------------
> +
> +You have to enable CONFIG_PWM_SYSFS in your kernel configuration to use
> +the sysfs interface. It is exposed at /sys/class/pwm/. If there are pwm
> +drivers loaded and these drivers successfully probed a chip, this chip
> +is exported as pwmchipX . Note that a single driver can probe multiple c=
hips.

There's a gratuitous space between "pwmchipX" and ".". And again I don't
think it's necessary to mention that one driver can probe multiple
chips.

> +Inside the directory you can read these properties:
> +
> +base - This is the linux global start where the chips pwm channels get
> +exposed.

As I've explained above, this should be dropped.

> +
> +npwm - This is the number of pwm channels this chip supports.
> +
> +If you want to start using a pwm channel with sysfs first you have to
> +export it. If you are finished with it and want to free the pwm for other
> +uses, you can unexport it:
> +
> +export - Write the global pwm channel number to this file to start using
> +the channel with sysfs.
> +
> +unexport - Write the global pwm channel number of the channel you are fi=
nshed
> +with to this file to make the channel available for other uses.
>=20
> +Once a pwm is exported a pwmX (X ranging from 0 to MAX_PWMS) directory a=
ppears
> +with the following read/write properties inside to control the pwm:

These need to be updated to use per-chip indexing.

> +duty_ns - Write the number of nanoseconds the active portion of the pwm =
period
> +should last to this file. This can not be longer than the period_ns.
> +
> +period_ns - Write the length of the pwm period in nanoseconds to this fi=
le.
> +This includes the active and inactive portion of the pwm period and can =
not
> +be smaller than duty_ns.

I don't think these need to be as verbose. People using a PWM should
know what the period and duty-cycle are.

> +polarity - The normal behaviour is to put out a high for the active port=
ion of
> +the pwm period. Write a 1 to this file to inverse the signal and output =
a low
> +on the active portion. Write a 0 to switch back to the normal behaviour.=
 The
> +polarity can only be changed if the pwm is not running. This file is only

"running" -> "enabled".

> +visible if the underlying driver/device supports changing the polarity.

Allowing the attributes to change only while a PWM is enabled is a good
alternative to disabling it automatically when an attribute is changed.
I rather like it too. You could return -EBUSY in this case to report the
reason to the user.

> +run - Write a 1 to this file to start the pwm signal generation, write a=
 0 to
> +stop it. Set your desired period_ns, duty_ns and polarity before startin=
g the
> +pwm.

"run" -> "enabled" as I mentioned before.

> +It is recommend to set the period_ns at first and duty_ns after that.

And this can be dropped if we handle things atomically.

> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index e513cd9..2f4200a 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -28,6 +28,18 @@ menuconfig PWM
> =20
>  if PWM
> =20
> +config PWM_SYSFS
> +	bool "/sys/class/pwm/... (sysfs interface)"
> +	depends on SYSFS
> +	help
> +	  Say Y here to use a sysfs interface to control PWMs.

Maybe "provide a sysfs interface"?

> +
> +	  For every instance of an PWM capable device there is a pwmchipX
> +	  directory exported to /sys/class/pwm. If you want to use a PWM, you
> +	  have to export it to sysfs, which is done by writing the number into
> +	  /sys/class/pwm/export. After that /sys/class/pwm/pwmX is ready to be
> +	  used.

And this needs an update too.

> diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
> index 903138b..0f2e40c 100644
> --- a/drivers/pwm/core.c
> +++ b/drivers/pwm/core.c
> @@ -30,8 +30,6 @@
>  #include <linux/debugfs.h>
>  #include <linux/seq_file.h>
> =20
> -#define MAX_PWMS 1024
> -

This shouldn't be moved to the global header for reasons that I already
explained.

>  /* flags in the third cell of the DT PWM specifier */
>  #define PWM_SPEC_POLARITY	(1 << 0)
> =20
> @@ -42,6 +40,465 @@ static LIST_HEAD(pwm_chips);
>  static DECLARE_BITMAP(allocated_pwms, MAX_PWMS);
>  static RADIX_TREE(pwm_tree, GFP_KERNEL);
> =20
> +

Adds a gratuitous newline.

> +#ifdef CONFIG_PWM_SYSFS

I'd rather see this moved to a different file. Although if that turns
out to make the implementation more difficult I may be persuaded
otherwise.

> +/* lock protects against unexport_pwm() being called while
> + * sysfs files are active.
> + */
> +static DEFINE_MUTEX(sysfs_lock);

I don't think this lock is necessary.

> +static struct class pwm_class;
> +static struct pwm_device *pwm_table[MAX_PWMS];

And we shouldn't introduce this either since it adds one more dependency
on the global namespace.

> +/*
> + * /sys/class/pwm/pwm... only for PWMs that are exported
> + *   /polarity
> + *      * only visible if the underlying driver has registered a
> + *        set_polarity function
> + *      * always readable
> + *      * may be written as "1" for inverted polarity or "0" for
> + *        normal polarity
> + *      * can only be written if PWM is not running
> + *   /period_ns
> + *      * always readable
> + *      * write with desired pwm period in nanoseconds
> + *      * may return with error depending on duty_ns
> + *   /duty_ns
> + *      * always readable
> + *      * write with desired duty portion in nanoseconds
> + *      * may return with error depending on period_ns
> + *   /run
> + *      * always readable
> + *      * write with "1" to start generating pwm signal, "0" to stop it
> + */

This is a copy of the sysfs ABI documentation and can be dropped.

> +static ssize_t pwm_polarity_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)

Please align arguments on subsequent lines with the first argument like
so:

static ssize_t pwm_polarity_show(struct device *dev, struct
				 device_attribute *attr, char *buf)

> +{
> +	const struct pwm_device *pwm =3D dev_get_drvdata(dev);
> +	ssize_t	status;

My editor shows that there's a tab between "ssize_t" and "status".
Should be a space.

> +
> +	mutex_lock(&sysfs_lock);
> +
> +	if (!test_bit(PWMF_EXPORT, &pwm->flags))
> +		status =3D -EIO;
> +	else
> +		status =3D sprintf(buf, "%d\n", pwm->polarity);
> +
> +	mutex_unlock(&sysfs_lock);
> +
> +	return status;
> +}

Since we don't need the lock, this can more easily be written as:

	if (!test_bit(PWMF_EXPORT, &pwm->flags))
		return -EIO;

	return sprintf(buf, "%d\n", pwm->polarity);

The same comments apply to the other attribute functions below.

> +static ssize_t pwm_polarity_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t size)
> +{
> +	struct pwm_device *pwm =3D dev_get_drvdata(dev);
> +	ssize_t status;
> +
> +	mutex_lock(&sysfs_lock);
> +
> +	if (!test_bit(PWMF_EXPORT, &pwm->flags))
> +		status =3D -EIO;
> +	else {
> +		long value;

This can be int.

> +
> +		status =3D kstrtol(buf, 0, &value);

And kstrtoint().

> +		if (status =3D=3D 0) {
> +			if (value =3D=3D 0) {
> +				if (pwm->polarity =3D=3D PWM_POLARITY_NORMAL)
> +					goto fail_unlock;
> +				status =3D pwm_set_polarity(pwm,
> +							PWM_POLARITY_NORMAL);
> +			} else {
> +				if (pwm->polarity =3D=3D PWM_POLARITY_INVERSED)
> +					goto fail_unlock;
> +				status =3D pwm_set_polarity(pwm,
> +							PWM_POLARITY_INVERSED);
> +			}
> +		}
> +	}
> +
> +fail_unlock:
> +	mutex_unlock(&sysfs_lock);
> +	return status ? : size;
> +}

I think it might be more useful to allow "normal" and "inverse" to be
written to (and read from) this attribute.

> +static ssize_t pwm_period_ns_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	const struct pwm_device *pwm =3D dev_get_drvdata(dev);
> +	ssize_t	status;
> +
> +	mutex_lock(&sysfs_lock);
> +
> +	if (!test_bit(PWMF_EXPORT, &pwm->flags))
> +		status =3D -EIO;
> +	else
> +		status =3D sprintf(buf, "%d\n", pwm->period);

This should be %u, since period is unsigned.

> +static ssize_t pwm_period_ns_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t size)
> +{
> +	struct pwm_device *pwm =3D dev_get_drvdata(dev);
> +	ssize_t status;
> +
> +	mutex_lock(&sysfs_lock);
> +
> +	if (!test_bit(PWMF_EXPORT, &pwm->flags))
> +		status =3D -EIO;
> +	else {
> +		long value;

unsigned int

> +
> +		status =3D kstrtol(buf, 0, &value);

And this should be kstrtouint().

> +		if (status =3D=3D 0) {
> +			if (pwm->duty < 0)
> +				pwm->period =3D value;
> +			else
> +				status =3D pwm_config(pwm, pwm->duty, value);

As I explained before we shouldn't be calling pwm_config() at this
point.

> +static ssize_t pwm_duty_ns_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
[...]
> +}
> +
> +static ssize_t pwm_duty_ns_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t size)
> +{
[...]
> +}

Same comments as above.

> +static ssize_t pwm_run_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)

pwm_enable_show(...)

> +{
> +	const struct pwm_device *pwm =3D dev_get_drvdata(dev);
> +	ssize_t	status;
> +
> +	mutex_lock(&sysfs_lock);
> +
> +	if (!test_bit(PWMF_EXPORT, &pwm->flags))
> +		status =3D -EIO;
> +	else
> +		status =3D sprintf(buf, "%d\n",
> +				!!test_bit(PWMF_ENABLED, &pwm->flags));

I'm not a huge fan of these compacted forms. I think something like:

	unsigned int value =3D !!test_bit(PWMF_ENABLED, &pwm->flags);

	sprintf(buf, "%u\n", value);

looks much more readable.

> +static ssize_t pwm_run_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t size)

pwm_enable_store(...)

> +{
> +	struct pwm_device *pwm =3D dev_get_drvdata(dev);
> +	ssize_t	status;

ssize_t and status should be separated by a single space, not a tab.

> +
> +	mutex_lock(&sysfs_lock);
> +
> +	if (!test_bit(PWMF_EXPORT, &pwm->flags))
> +		status =3D -EIO;
> +	else {
> +		long		value;

unsigned int. And please don't use tabs to separate type and variable
name.

> +
> +		status =3D kstrtol(buf, 0, &value);

And kstrtouint() please.

> +/*
> + * /sys/class/pwm/pwmchipN/
> + *   /base ... matching pwm_chip.base (N)
> + *   /ngpio ... matching pwm_chip.npwm
> + */

This comment is redundant.

> +
> +static ssize_t chip_base_show(struct device *dev,
> +			       struct device_attribute *attr, char *buf)
> +{
> +	const struct pwm_chip	*chip =3D dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%d\n", chip->base);
> +}

This function is not needed.

> +
> +static ssize_t chip_npwm_show(struct device *dev,
> +			       struct device_attribute *attr, char *buf)
> +{
> +	const struct pwm_chip	*chip =3D dev_get_drvdata(dev);

Uses tab instead of space again.

> +static int pwm_export(struct pwm_device *pwm)
> +{
> +	struct device *dev;
> +	int status;
> +
> +	mutex_lock(&sysfs_lock);
> +
> +	if (!test_bit(PWMF_REQUESTED, &pwm->flags) ||
> +		test_bit(PWMF_EXPORT, &pwm->flags)) {
> +		pr_debug("pwm %d unavailable (requested=3D%d, exported=3D%d)\n",
> +			pwm->pwm,
> +			test_bit(PWMF_REQUESTED, &pwm->flags),
> +			test_bit(PWMF_EXPORT, &pwm->flags));
> +
> +		status =3D -EPERM;
> +		goto fail_unlock;
> +	}

I'm not sure I understand what this is supposed to do. Literally this
means: If the PWM is not requested by an in-kernel user or if it is
already exported via sysfs, return -EPERM. That doesn't sound right.
Something like:

	if (test_bit(PWMF_REQUESTED, &pwm->flags))
		return -EPERM;

sounds more like what you want. I'm not sure it should be considered an
error to export an already exported PWM. If so it might be advantageous
to use a separate error-code for that:

	if (test_bit(PWMF_EXPORTED, &pwm->flags))
		return -EBUSY;

> +	pwm_class.class_attrs =3D NULL;
> +	pwm_class.dev_attrs =3D pwm_dev_attrs;
> +	dev =3D device_create(&pwm_class, pwm->chip->dev, MKDEV(0, 0),

The above two lines could use a blank line to separate them for
readability.

> +			pwm, "pwm%u", pwm->pwm);
> +	if (IS_ERR(dev)) {
> +		status =3D PTR_ERR(dev);
> +		goto fail_unlock;
> +	}
> +
> +	if (pwm->chip->ops->set_polarity) {
> +		status =3D device_create_file(dev, &dev_attr_polarity);
> +		if (status)
> +			goto fail_unregister_device;
> +	}
> +
> +	set_bit(PWMF_EXPORT, &pwm->flags);
> +	mutex_unlock(&sysfs_lock);
> +	return 0;
> +
> +fail_unregister_device:
> +	device_unregister(dev);
> +fail_unlock:
> +	mutex_unlock(&sysfs_lock);
> +	return status;
> +}
> +
> +static int match_export(struct device *dev, void *data)
> +{
> +	return dev_get_drvdata(dev) =3D=3D data;
> +}
> +
> +/*
> + * /sys/class/pwm/export ... write-only
> + *	integer N ... number of pwm to export (full access)
> + * /sys/class/pwm/unexport ... write-only
> + *	integer N ... number of pwm to unexport
> + */

This is already mentioned in the documentation, no need to duplicate it
here.

> +static ssize_t export_store(struct class *class,
> +				struct class_attribute *attr,
> +				const char *buf, size_t len)
> +{
> +	long pwm;

unsigned int. And for consistency with other code in this file it should
be named hwpwm...

> +	int status;
> +	struct pwm_device *dev;

=2E.. and this should be pwm.

> +	struct pwm_chip *chip;
> +
> +	status =3D kstrtol(buf, 0, &pwm);

kstrtouint()

> +	if (status < 0)
> +		goto done;
> +
> +	if (!pwm_is_valid(pwm) || !pwm_table[pwm]) {

These checks can be reduced to something like:

	if (hwpwm >=3D chip->npwm)
		return -ENODEV;

when you move to per-chip indexing.

> +		status =3D -ENODEV;
> +		goto done;
> +	}
> +	chip =3D pwm_table[pwm]->chip;

The above two lines should be separated by a blank line for readability.

> +	if (!chip) {
> +		status =3D -ENODEV;
> +		goto done;
> +	}
> +	dev =3D pwm_request_from_chip(chip, pwm - chip->base, "sysfs");

Same here.

> +	if (IS_ERR(dev)) {
> +		status =3D -ENODEV;
> +		goto done;
> +	}
> +	status =3D pwm_export(dev);

And here.

> +	if (status < 0)
> +		pwm_free(dev);

This should be pwm_put().

> +static ssize_t unexport_store(struct class *class,
> +				struct class_attribute *attr,
> +				const char *buf, size_t len)
> +{
> +	long pwm;
> +	int status;
> +	struct pwm_device *dev;
> +	struct device *d;
> +
> +	status =3D kstrtol(buf, 0, &pwm);
> +	if (status < 0)
> +		goto done;
> +
> +	status =3D -EINVAL;
> +
> +	/* reject bogus pwms */
> +	if (!pwm_is_valid(pwm))
> +		goto done;
> +
> +	dev =3D pwm_table[pwm];
> +	if (dev && test_and_clear_bit(PWMF_EXPORT, &dev->flags)) {
> +		d =3D class_find_device(&pwm_class, NULL, dev, match_export);
> +		if (d)
> +			device_unregister(d);
> +		status =3D 0;
> +		pwm_put(dev);
> +	}
> +done:
> +	if (status)
> +		pr_debug("%s: status %d\n", __func__, status);
> +	return status ? : len;
> +}

The same comments as for export_store() apply here.

> +static struct class pwm_class =3D {
> +	.name =3D		"pwm",
> +	.owner =3D	THIS_MODULE,
> +	.class_attrs =3D	pwmchip_class_attrs,
> +	.dev_attrs =3D	pwmchip_dev_attrs,

No tabs for alignment please.

> +static int pwmchip_export(struct pwm_chip *chip)
> +{
> +	struct device *dev;
> +
> +	mutex_lock(&sysfs_lock);
> +	pwm_class.class_attrs =3D pwmchip_class_attrs;
> +	pwm_class.dev_attrs =3D pwmchip_dev_attrs;
> +	dev =3D device_create(&pwm_class, chip->dev, MKDEV(0, 0), chip,
> +				"pwmchip%d", chip->base);
> +
> +	chip->exported =3D (!IS_ERR(dev));
> +	mutex_unlock(&sysfs_lock);
> +
> +	if (chip->exported)
> +		return 0;
> +
> +	return PTR_ERR(dev);
> +}

The flow is weird and unintuitive here. I find the following more
readable:

	dev =3D device_create(...);
	if (IS_ERR(dev))
		return PTR_ERR(dev);

	chip->exported =3D true;

Skimming the patch again, I don't think we really need the exported
field of the pwm_chip, though.

> +static void pwmchip_unexport(struct pwm_chip *chip)
> +{
> +	int status, i;
> +	struct device *dev;
> +
> +	mutex_lock(&sysfs_lock);
> +	dev =3D class_find_device(&pwm_class, NULL, chip, match_export);

Can we not store dev within pwm_chip so that it can be retrieved
directly instead of going through the iterator.

> +	if (dev) {
> +		put_device(dev);
> +		device_unregister(dev);
> +		for (i =3D chip->base; i < chip->base + chip->npwm; i++)
> +			pwm_table[i] =3D NULL;
> +		chip->exported =3D 0;
> +		status =3D 0;
> +	} else
> +		status =3D -ENODEV;
> +	mutex_unlock(&sysfs_lock);
> +
> +	if (status)
> +		pr_debug("%s: pwm chip status %d\n", __func__, status);
> +}
> +
> +static int __init pwmlib_sysfs_init(void)

pwm_sysfs_init() would be more consistent.

> +{
> +	int status;
> +
> +	status =3D class_register(&pwm_class);
> +
> +	return status;
> +}

This can be simply:

	return class_register(&pwm_class);

> +postcore_initcall(pwmlib_sysfs_init);

subsys_initcall()?

> +
> +#else
> +static inline int pwmchip_export(struct pwm_chip *chip)
> +{
> +	return 0;
> +}
> +
> +static inline void pwmchip_unexport(struct pwm_chip *chip)
> +{
> +}
> +

Gratuitous newline.

> +#endif /* CONFIG_PWM_SYSFS */
> +
> +

Ditto.

>  static struct pwm_device *pwm_to_device(unsigned int pwm)
>  {
>  	return radix_tree_lookup(&pwm_tree, pwm);
> @@ -77,8 +534,10 @@ static void free_pwms(struct pwm_chip *chip)
>  	for (i =3D 0; i < chip->npwm; i++) {
>  		struct pwm_device *pwm =3D &chip->pwms[i];
>  		radix_tree_delete(&pwm_tree, pwm->pwm);
> +#ifdef CONFIG_PWM_SYSFS
> +		pwm_table[i + chip->base]->chip =3D NULL;
> +#endif
>  	}
> -
>  	bitmap_clear(allocated_pwms, chip->base, chip->npwm);
> =20
>  	kfree(chip->pwms);
> @@ -258,6 +717,9 @@ int pwmchip_add(struct pwm_chip *chip)
>  		pwm->chip =3D chip;
>  		pwm->pwm =3D chip->base + i;
>  		pwm->hwpwm =3D i;
> +#ifdef CONFIG_PWM_SYSFS
> +		pwm_table[i + chip->base] =3D pwm;
> +#endif
> =20
>  		radix_tree_insert(&pwm_tree, pwm->pwm, pwm);
>  	}
> @@ -272,6 +734,8 @@ int pwmchip_add(struct pwm_chip *chip)
>  	if (IS_ENABLED(CONFIG_OF))
>  		of_pwmchip_add(chip);
> =20
> +	ret =3D pwmchip_export(chip);
> +

Maybe these errors shouldn't be fatal. We can still use the chips even
if we weren't able to export them via sysfs. So the pwmchip_export()
could simply return void.

> @@ -400,10 +865,19 @@ EXPORT_SYMBOL_GPL(pwm_free);
>   */
>  int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
>  {
> +	int status;

I'd prefer this to be named "err" for consistency.

> -	return pwm->chip->ops->config(pwm->chip, pwm, duty_ns, period_ns);
> +	status =3D pwm->chip->ops->config(pwm->chip, pwm, duty_ns, period_ns);
> +#ifdef CONFIG_PWM_SYSFS
> +	if (status =3D=3D 0) {
> +		pwm->period =3D period_ns;
> +		pwm->duty =3D duty_ns;
> +	}
> +#endif

And I'd like to get rid of these #ifdef's. We already include the period
field in pwm_device, so we can do the same for duty. Then this can be
written more canonically as:

	err =3D pwm->chip->ops->config(...);
	if (err < 0)
		return err;

	pwm->period =3D period_ns;
	pwm->duty =3D duty_ns;

	return 0;

>  int pwm_set_polarity(struct pwm_device *pwm, enum pwm_polarity polarity)
>  {
> +	int status;
> +
>  	if (!pwm || !pwm->chip->ops)
>  		return -EINVAL;
> =20
> @@ -425,7 +901,12 @@ int pwm_set_polarity(struct pwm_device *pwm, enum pw=
m_polarity polarity)
>  	if (test_bit(PWMF_ENABLED, &pwm->flags))
>  		return -EBUSY;
> =20
> -	return pwm->chip->ops->set_polarity(pwm->chip, pwm, polarity);
> +	status =3D pwm->chip->ops->set_polarity(pwm->chip, pwm, polarity);
> +#ifdef CONFIG_PWM_SYSFS
> +	if (!status)
> +		pwm->polarity =3D polarity;
> +#endif
> +	return status;
>  }
>  EXPORT_SYMBOL_GPL(pwm_set_polarity);

Same comments here.

> @@ -749,6 +1230,9 @@ static void pwm_dbg_show(struct pwm_chip *chip, stru=
ct seq_file *s)
>  		if (test_bit(PWMF_ENABLED, &pwm->flags))
>  			seq_printf(s, " enabled");
> =20
> +		if (test_bit(PWMF_EXPORT, &pwm->flags))
> +			seq_printf(s, " sysfs_exported");

I think "sysfs" or "exported" are good enough.

> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
> index 6d661f3..afc22c6 100644
> --- a/include/linux/pwm.h
> +++ b/include/linux/pwm.h
> @@ -4,10 +4,27 @@
>  #include <linux/err.h>
>  #include <linux/of.h>
> =20
> +#define MAX_PWMS 1024
> +

This doesn't belong here.

>  struct pwm_device;
>  struct seq_file;
> =20
>  #if IS_ENABLED(CONFIG_PWM) || IS_ENABLED(CONFIG_HAVE_PWM)
> +
> +/*
> + * "valid" PWM numbers are nonnegative and may be passed to
> + * setup routines like pwm_get().  only some valid numbers
> + * can successfully be requested and used.
> + *
> + * Invalid PWM numbers are useful for indicating no-such-PWM in
> + * platform data and other tables.
> + */
> +
> +static inline bool pwm_is_valid(int number)
> +{
> +	return number >=3D 0 && number < MAX_PWMS;
> +}
> +

This doesn't either.

>  /*
>   * pwm_request - request a PWM device
>   */
> @@ -75,7 +92,8 @@ enum pwm_polarity {
> =20
>  enum {
>  	PWMF_REQUESTED =3D 1 << 0,
> -	PWMF_ENABLED =3D 1 << 1,
> +	PWMF_ENABLED =3D 1 << 1, /* set running via /sys/class/pwm/pwmX/run */

This comment should be dropped because it is confusing. The PWMF_ENABLED
flag is used by functionality other than sysfs too.

> +	PWMF_EXPORT =3D 1 << 2, /* exported via /sys/class/pwm/export */

This should be renamed PWMF_EXPORTED for consistency with the other
flags.

>  struct pwm_device {
> @@ -87,6 +105,10 @@ struct pwm_device {
>  	void			*chip_data;
> =20
>  	unsigned int		period; /* in nanoseconds */
> +#ifdef CONFIG_PWM_SYSFS
> +	unsigned int		duty; /* in nanoseconds */
> +	enum pwm_polarity	polarity;
> +#endif

As mentioned above, the #ifdef can just be dropped. You might also want
to add an accessor for the duty, similar to pwm_{set,get}_period(). Name
them pwm_{set,get}_duty_cycle(), though, not pwm_{set,get}_duty().

>  };
> =20
>  static inline void pwm_set_period(struct pwm_device *pwm, unsigned int p=
eriod)
> @@ -159,6 +181,9 @@ struct pwm_chip {
>  	struct pwm_device *	(*of_xlate)(struct pwm_chip *pc,
>  					    const struct of_phandle_args *args);
>  	unsigned int		of_pwm_n_cells;
> +#ifdef CONFIG_PWM_SYSFS
> +	unsigned		exported:1;
> +#endif

I said this already, but I don't see a need for this flag.

Thierry

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRYn0pAAoJEN0jrNd/PrOhEeQQAKLLzGShR9ichytpPuF+q3RQ
RaJ6b7YXR5E2CSFnJXs5ATF8pdCWSZKVDSY0GNZSVeUJpFMK+SQm3Z7gLAIpbuUu
mOzy7n+fHuWH12RmTTt7buS5HXcxHuTusMA0SAqibgX6K2LT2Q6uoFzRIA2YN79D
vnjSqLTFTmA+MSqyyoE8Ws3fJF85/Qkj7k+OW3ASoBScN4ccd3ijyJQUqhFyk3Kh
zE5MWw0MzrzDDo0ltyBqVYrgQiy3B0L6u1hYpO64X6O/bk7O9DPVOutLy7r0MaDO
WgEJ+KW3cn2y3bYORxioUCeMrJ03qaAugRDFT9UJ/O5wdaY9JW1Ux3490NMVu+oF
4Z8COw1vcQIrhk68WAFDMLFYTk2mQbwR9lMk+bJQfRTU2ciMtWtK1Yq1MC2i3iyB
Ctrc3EGjiiEP15ucD00JPdNChNmn/2rmTQFOyCQfp8FXNmOvxfECUMjCT0yjZjU4
6ojj8O1YQJsLdZMKkyFRnT7PkfONd6FT8q12iWX0tk38nBJnQe4sn1upquCm/3ri
rjVoWQu7Drd5FMe2QIVGo11nGuSpZ6gMPciWC2FBnT19u1nejyB0wfpAnSoWxg8p
Zf5eD33S4WEqehtWMlErFhbCveBSdp7W/HsGdvqJiGpa3xp7qzT6kKbAlnlPGbg6
Kkf7LUW+ewGvVQVKNY24
=7cky
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
