Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbaHYNTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:19:16 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:49949 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616AbaHYNTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:19:15 -0400
Date: Mon, 25 Aug 2014 15:19:10 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Bart Tanghe <bart.tanghe@thomasmore.be>
Cc: swarren@wwwdotorg.org, tim.kryger@linaro.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-rpi-kernel@lists.infradead.org
Subject: Re: [resend rfc v3] pwm: add BCM2835 PWM driver
Message-ID: <20140825131908.GG4163@ulmo.nvidia.com>
References: <1398689686-30317-1-git-send-email-bart.tanghe@thomasmore.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WkfBGePaEyrk4zXB"
Content-Disposition: inline
In-Reply-To: <1398689686-30317-1-git-send-email-bart.tanghe@thomasmore.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WkfBGePaEyrk4zXB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Sorry for taking so long to reply to this, I had completely forgotten.

On Mon, Apr 28, 2014 at 02:54:46PM +0200, Bart Tanghe wrote:
> 	Add some better error handling and Device table support
> 	Added Documentation/devicetree/bindings/pwm/pwm-bcm2835.txt
> =09
> Signed-off-by: Bart Tanghe <bart.tanghe@thomasmore.be>

There should be a description about this driver in the commit message.
The above reads like a changelog since earlier versions of this patch,
in which case it should go below a --- separator line, like so:

	Commit message goes here...
	...

	Signed-off-by: Bart Tanghe <bart.tanghe@thomasmore.be>
	---
	Changes in v3:
	- add some better error handling
	- add device tree support

I assume that "device table" was meant to be "device tree"? Also it
might be useful to mention Raspberry Pi in the commit message.

> diff --git a/Documentation/devicetree/bindings/pwm/pwm-bcm2835.txt b/Docu=
mentation/devicetree/bindings/pwm/pwm-bcm2835.txt
> new file mode 100644
> index 0000000..44c0b95
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/pwm-bcm2835.txt
> @@ -0,0 +1,13 @@
> +bcm2835 PWM controller

I think this ought to be "BCM2835". Again, maybe this should mention the
Raspberry Pi so that when people search for it they get a match on this
document.

> +Required properties:
> +- compatible: should be "bcrm,pwm-bcm2835"

According to Documentation/devicetree/bindings/vendor-prefixes.txt this
should be "brcm,...". Also I'd suggest putting the SoC first, followed
by the hardware block name:

	"brcm,bcm2835-pwm"

> +- reg: physical base address and length of the controller's registers
> +
> +Examples:
> +
> +pwm@0x2020C000 {
> +	compatible =3D "bcrm,pwm-bcm2835";
> +	reg =3D <0x2020C000 0x28>;

I think other BCM2835 device tree bindings use lower-case for addresses,
so you might want to follow that for consistency. Also unit-addresses
are always in hexadecimal and shouldn't take a 0x prefix, so the above
would become:

	pwm@2020c000 {
		...
	};

> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 22f2f28..20341a3 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -62,6 +62,18 @@ config PWM_ATMEL_TCB
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-atmel-tcb.
> =20
> +config PWM_BCM2835
> +	tristate "BCM2835 PWM support"
> +	depends on MACH_BCM2835 || MACH_BCM2708
> +	help
> +	  PWM framework driver for BCM2835 controller (raspberry pi)

I think the correct capitalization would be "Raspberry Pi".

> +	  Only 1 channel is implemented.

How many can it take? Why haven't all been implemented?

> +	  The pwm core is tested with a pwm basic frequency of 1Mhz.
> +	  Use period above 1000ns

s/pwm/PWM/ in prose. Why this restriction? Doesn't it work with higher
frequencies? Perhaps this shouldn't be a comment in the Kconfig entry
but rather a runtime check (and error message)?

> diff --git a/drivers/pwm/pwm-bcm2835.c b/drivers/pwm/pwm-bcm2835.c
> new file mode 100644
> index 0000000..ec9829b
> --- /dev/null
> +++ b/drivers/pwm/pwm-bcm2835.c
> @@ -0,0 +1,198 @@
> +/*
> + * pwm-bcm2835 driver
> + * Standard raspberry pi (gpio18 - pwm0)

Just drop these two lines, they don't provide very useful information.

> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/pwm.h>
> +
> +/*mmio regiser mapping*/

s/mmio/MMIO/, s/regiser/register/. Also spaces after /* and before */.

> +
> +#define DUTY		0x14
> +#define PERIOD		0x10
> +#define CHANNEL		0x10

CHANNEL doesn't seem to be used.

> +
> +#define PWM_ENABLE	0x00000001
> +#define PWM_POLARITY	0x00000010
> +
> +#define MASK_CTL_PWM	0x000000FF

I prefer lowercase for hexadecimals. And there's no need to repeat all
the leading zeroes. PWM_ENABLE and PWM_POLARITY seem to be bits, so I'd
prefer:

	#define PWM_ENABLE (1 << 0)
	#define PWM_POLARITY (1 << 4)

> +#define CTL_PWM		0x00000081

What does this value mean? Also even if this register is at offset 0 you
should still add a symbolic name for it.

> +#define DRIVER_AUTHOR "Bart Tanghe <bart.tanghe@thomasmore.be>"
> +#define DRIVER_DESC "A bcm2835 pwm driver - raspberry pi development pla=
tform"

These are only used once, so you don't have to #define them. Use them in
the MODULE_*() macros directly.

Also, perhaps a better and more generic description would be:

	"Broadcom BCM2835 (Raspberry Pi) PWM driver"

And perhaps even drop "(Raspberry Pi)" since presumably the driver will
work on any BCM2835-based board.

> +struct bcm2835_pwm_chip {
> +	struct pwm_chip chip;
> +	struct device *dev;
> +	int channel;

This field seems to be unused.

> +	int scaler;

Perhaps this should be unsigned long instead of int?

> +	void __iomem *mmio_base;

Calling this something like "base" or "regs" will save a lot of
characters when accessing registers.

> +static inline struct bcm2835_pwm_chip *to_bcm2835_pwm_chip(
> +					struct pwm_chip *chip){
> +
> +	return container_of(chip, struct bcm2835_pwm_chip, chip);
> +}

The preferred way to write the above is:

	static inline struct bcm2835_pwm_chip *
	to_bcm2835_pwm_chip(struct pwm_chip *chip)
	{
		...
	}

Perhaps if you make names a little shorter you can even get away without
wrapping it:

static inline struct bcm2835_pwm *to_bcm2835_pwm(struct pwm_chip *chip)
{
	...
}

> +static int bcm2835_pwm_config(struct pwm_chip *chip,
> +			      struct pwm_device *pwm,
> +			      int duty_ns, int period_ns){

The pwm argument still fits on the first line. Also the opening brace
({) should go on a separate line.

> +
> +	struct bcm2835_pwm_chip *pc;
> +
> +	pc =3D container_of(chip, struct bcm2835_pwm_chip, chip);

This should use the to_bcm2835_pwm() function defined earlier.

> +
> +	iowrite32(duty_ns/pc->scaler, pc->mmio_base + DUTY);
> +	iowrite32(period_ns/pc->scaler, pc->mmio_base + PERIOD);

These should use writel() instead of iowrite32() and there need to be
spaces around '/'.

> +static int bcm2835_pwm_enable(struct pwm_chip *chip,
> +			      struct pwm_device *pwm){

Same as above.

> +
> +	struct bcm2835_pwm_chip *pc;
> +
> +	pc =3D container_of(chip, struct bcm2835_pwm_chip, chip);

Should use to_bcm2835_pwm() and can go on a single line:

	struct bcm2835_pwm *pc =3D to_bcm2835_pwm(chip);

> +
> +	iowrite32(ioread32(pc->mmio_base) | PWM_ENABLE, pc->mmio_base);

Please break this up into:

	u32 value;
	...
	value =3D readl(pc->mmio_base + ...);
	value |=3D PWM_ENABLE;
	writel(value, pc->mmio_base + ...);

> +static void bcm2835_pwm_disable(struct pwm_chip *chip,
> +				struct pwm_device *pwm)
> +{
> +	struct bcm2835_pwm_chip *pc;
> +
> +	pc =3D to_bcm2835_pwm_chip(chip);

The above can go on a single line.

> +
> +	iowrite32(ioread32(pc->mmio_base) & ~PWM_ENABLE, pc->mmio_base);
> +}

Same as above and below.

> +static int bcm2835_pwm_probe(struct platform_device *pdev)
> +{
> +	struct bcm2835_pwm_chip *pwm;
> +

Gratuitous blank line.

> +	int ret;
> +	struct resource *r;
> +	u32 start, end;

start and end don't seem to be used.

> +	struct clk *clk;
> +
> +	pwm =3D devm_kzalloc(&pdev->dev, sizeof(*pwm), GFP_KERNEL);
> +	if (!pwm) {
> +		dev_err(&pdev->dev, "failed to allocate memory\n");

No need for this error message.

> +		return -ENOMEM;
> +	}
> +
> +	pwm->dev =3D &pdev->dev;
> +
> +	clk =3D clk_get(&pdev->dev, NULL);

devm_clk_get()? Also, don't you want to keep a reference to the clock in
struct bcm2835_pwm so that you can disable the clock on driver removal?

> +	if (IS_ERR(clk)) {
> +		dev_err(&pdev->dev, "could not find clk: %ld\n", PTR_ERR(clk));

In text I prefer to use "clock" rather than "clk".

> +		devm_kfree(&pdev->dev, pwm);

No need for this. The point of the devm_*() functions is that you don't
have to manually clean up the resources that they manage.

> +		return PTR_ERR(clk);
> +	}
> +
> +	pwm->scaler =3D (int)1000000000/clk_get_rate(clk);

There's NSEC_PER_SEC and you shouldn't cast this if you change the type
of scaler to unsigned long. So this becomes:

	pwm->scaler =3D NSEC_PER_SEC / clk_get_rate(clk);

> +
> +	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	pwm->mmio_base =3D devm_ioremap_resource(&pdev->dev, r);
> +	if (IS_ERR(pwm->mmio_base)) {
> +		devm_kfree(&pdev->dev, pwm);

Again, no need to free the memory here.

> +		return PTR_ERR(pwm->mmio_base);
> +	}
> +
> +	start =3D r->start;
> +	end =3D r->end;
> +
> +	pwm->chip.dev =3D &pdev->dev;
> +	pwm->chip.ops =3D &bcm2835_pwm_ops;
> +	pwm->chip.npwm =3D 2;

The Kconfig entry says that only a single PWM is implemented, so this
should be 1, shouldn't it?

> +
> +	ret =3D pwmchip_add(&pwm->chip);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
> +		devm_kfree(&pdev->dev, pwm);

Drop this.

> +		return -1;

This needs to propagate ret.

> +	}
> +
> +	/*set the pwm0 configuration*/

Spaces after /* and before */.

> +	iowrite32((ioread32(pwm->mmio_base) & ~MASK_CTL_PWM)
> +				| CTL_PWM, pwm->mmio_base);

Should this perhaps be delayed until the PWM is requested? What are the
consequences of configuring the PWM?

Also split this up into an explicit read/modify/write sequence please.

> +
> +	platform_set_drvdata(pdev, pwm);
> +
> +	return 0;
> +}

I notice that you never prepare or enable the clock here. Perhaps this
isn't required because it's always on, but I think you should still call
clk_prepare_enable() here (and clk_disable_unprepare() in .remove()) to
make sure the driver is more portable.

> +
> +static int bcm2835_pwm_remove(struct platform_device *pdev)
> +{
> +

Gratuitous blank line.

> +	struct bcm2835_pwm_chip *pc;
> +	pc  =3D platform_get_drvdata(pdev);

The above can go on a single line.

> +
> +	if (WARN_ON(!pc))
> +		return -ENODEV;

There's no need for this check.

> +
> +	return pwmchip_remove(&pc->chip);
> +}
> +
> +static const struct of_device_id bcm2835_pwm_of_match[] =3D {
> +	{ .compatible =3D "bcrm,pwm-bcm2835", },

s/bcrm/brcm/

> +	{ /* sentinel */ }
> +};
> +

Gratuitous blank line.

> +MODULE_DEVICE_TABLE(of, bcm2835_pwm_of_match);
> +
> +static struct platform_driver bcm2835_pwm_driver =3D {
> +	.driver =3D {
> +		.name =3D "pwm-bcm2835",
> +		.owner =3D THIS_MODULE,

No need to initialize .owner here. module_platform_driver() will do that
for you.

> +		.of_match_table =3D bcm2835_pwm_of_match,
> +	},
> +	.probe =3D bcm2835_pwm_probe,
> +	.remove =3D bcm2835_pwm_remove,
> +};
> +module_platform_driver(bcm2835_pwm_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_DESCRIPTION(DRIVER_DESC);

A more natural ordering would be:

	MODULE_AUTHOR(...);
	MODULE_DESCRIPTION(...);
	MODULE_LICENSE(...);

Thierry

--WkfBGePaEyrk4zXB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT+zfMAAoJEN0jrNd/PrOhev0P/AuWOaooeCxihifMjLhGAHRv
C2DVSdfHOyP6sSRnLjsUDjcftvuZZnZENRugV29gsTDPQ1xg9C66+pc49ClKOqpk
wyNcnOJPOR0rCr/9Z655PJsQ/YCwGYWO5f6NWoJ78fvVGcnkr7DCx4DdeDoF0gE6
kzZzzAa/xDx+rkxYIps/WnAiI0qTBpQFgV73twoC9rBRTpKnpFVswIivItYB4jve
xAvAEUz9ibKdoh4SIKBEpg3vlzd43w/fxm2lWPq0TA2ZMVGvh1YzYW7aqH4FPbDU
wf75AJMjbnTnTQ15ti8bx9Cz9N+uWRqDeBibJ5fKBRZlbnKcvkQxoPKGJbQQihPS
zSvpxf6sU4HQrJhToKHYtJRnzQEkniSn7q9mRwDI3koVyXMYv7u8KBeGfK+k78JQ
yXg6acNR1OpkBFMU9L1S8VJHIzyFtAXbnOkIzB2KDCTC0E80JlWOgGtY8xVfv2RX
hQ4VPZTCVvu8R6isU5GuyW2tFqQuiqeJklS/rdZQbJa3HFsRETQ6zLGkQBCuVU2/
l8N+EZG7Kg0zBz7U5E6f2RbRKqk5I5lJ1jK9If/12qsAwJ02FsA5s9R52OgqqTBR
5425PIONqFsJG1GKyonZVfWFdfGEFeTZqJZEiVSJNCNd0FL6CC0sD1C13y7jArvt
wQt43DfMY/cGA4BliGOR
=sIWS
-----END PGP SIGNATURE-----

--WkfBGePaEyrk4zXB--
