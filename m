Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab3IWJrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:47:12 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:53302 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab3IWJrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:47:09 -0400
Date: Mon, 23 Sep 2013 11:45:48 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Johannes Thumshirn <morbidrsa@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-rpi-kernel@lists.infradead.org
Subject: Re: [RFC] PWM: Add support for pwm-bcm2835
Message-ID: <20130923094546.GD11881@ulmo>
References: <1379758142-7302-1-git-send-email-morbidrsa@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n/aVsWSeQ4JHkrmm"
Content-Disposition: inline
In-Reply-To: <1379758142-7302-1-git-send-email-morbidrsa@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n/aVsWSeQ4JHkrmm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 21, 2013 at 12:09:02PM +0200, Johannes Thumshirn wrote:

The subject prefix should be "pwm: ". Also something like this might be
better as a subject:

	pwm: Add BCM2835 SoC PWM driver

Then go on to describe that the BCM2835 is used in the Raspberry Pi.

> Add support for the PWM controller of the BCM2835 SoC found on Raspberry =
PI
>=20
> The driver isn't as much tested as I wanted it to be and devicetree
> support is still missing, but I thought it would be nice to have some
> comments if I'm in the right direction.
>=20
> Signed-off-by: Johannes Thumshirn <morbidrsa@gmail.com>
> ---
>  drivers/pwm/Kconfig       |   8 ++
>  drivers/pwm/Makefile      |   1 +
>  drivers/pwm/pwm-bcm2835.c | 275 ++++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 284 insertions(+)
>  create mode 100644 drivers/pwm/pwm-bcm2835.c
>=20
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 75840b5..5417159 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -224,4 +224,12 @@ config PWM_VT8500
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-vt8500.
> =20
> +config PWM_BCM2835
> +       tristate "BCM2835 PWM support"
> +       help
> +        Generic PWM framework driver for bcm2835 found on the Rasperry PI
> +
> +	To compile this driver as a module, choose M here: the module will be
> +	called pwm-bcm2835

This uses a mixture of spaces and tabs for indentation. It should use
tabs to indent, plus another 2 spaces for the help description like all
the other entries.

Also, please keep the list sorted alphabetically.

> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
[...]
> @@ -20,3 +20,4 @@ obj-$(CONFIG_PWM_TIPWMSS)	+=3D pwm-tipwmss.o
>  obj-$(CONFIG_PWM_TWL)		+=3D pwm-twl.o
>  obj-$(CONFIG_PWM_TWL_LED)	+=3D pwm-twl-led.o
>  obj-$(CONFIG_PWM_VT8500)	+=3D pwm-vt8500.o
> +obj-$(CONFIG_PWM_BCM2835)	+=3D pwm-bcm2835.o

That list should also be ordered alphabetically.

> diff --git a/drivers/pwm/pwm-bcm2835.c b/drivers/pwm/pwm-bcm2835.c
[...]
> new file mode 100644
> index 0000000..8a64666
> --- /dev/null
> +++ b/drivers/pwm/pwm-bcm2835.c
> @@ -0,0 +1,275 @@
> +/*
> + * BCM2835 PWM driver
> + *
> + * Derived from the Tegra PWM driver by NVIDIA Corporation.

I don't think you necessarily need to credit here. The general structure
of PWM drivers is dictated by the subsystem, and besides that there's
nothing in here that borrows from the Tegra PWM driver.

> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/of.h>
> +#include <linux/pwm.h>

These are almost sorted alphabetically. =3D)

> +
> +#define NPWM 2

You only use this once and the context leaves no room for interpretation
so you might just as well hard-code it.

> +
> +/* Address Mappings (offsets) from Broadcom BCM2835 ARM Periperals Manual
> + * Section 9.6 Page 141ff
> + */
> +#define BCM2835_PWM_CTL		0x00 /* Control register */
> +#define BCM2835_PWM_STA		0x04 /* Status register */
> +#define BCM2835_PWM_DMAC	0x08 /* PWM DMA Configuration */
> +#define BCM2835_PWM_RNG1	0x10 /* PWM Channel 1 Range */
> +#define BCM2835_PWM_DAT1	0x14 /* PWM Channel 1 Data */
> +#define BCM2835_PWM_FIF1	0x18 /* PWM FIFO Input */
> +#define BCM2835_PWM_RNG2	0x20 /* PWM Channel 2 Range */
> +#define BCM2835_PWM_DAT2	0x24 /* PWM Channel 2 Data */
> +
> +/* Control registers 0 and 1 are mirrored on a distance of 4 bits */
> +#define HWPWM(x) ((x) << 4)

That doesn't look right. You use this in the readl() and writel()
functions irrespective of which register is accessed. Given that only
two registers are per-channel, I think the easiest way would be for you
to differentiate between channel 0 and 1 when accessing the registers.
See below.

> +
> +/* TODO: We only need this register set once and use HWPWM macro to
> + * access 2nd output
> + */
> +/* Control Register Bits */
> +#define BCM2835_PWM_CTL_PWEN1	BIT(0)	/* Channel 1 enable (RW) */
> +#define BCM2835_PWM_CTL_MODE1	BIT(1)	/* Channel 1 mode (RW) */
> +#define BCM2835_PWM_CTL_RPTL1	BIT(2)	/* Channel 1 repeat last data (RW) =
*/
> +#define BCM2835_PWM_CTL_SBIT1	BIT(3)	/* Channel 1 silence bit (RW) */
> +#define BCM2835_PWM_CTL_POLA1	BIT(4)	/* Channel 1 polarity (RW) */
> +#define BCM2835_PWM_CTL_USEF1	BIT(5)	/* Channel 1 use FIFO (RW) */
> +#define BCM2835_PWM_CTL_CLRF1	BIT(6)	/* Channel 1 clear FIFO (RO) */
> +#define BCM2835_PWM_CTL_MSEN1	BIT(7)	/* Channel 1 M/S enable (RW) */
> +#define BCM2835_PWM_CTL_PWEN2	BIT(8)	/* Channel 2 enable (RW) */
> +#define BCM2835_PWM_CTL_MODE2	BIT(9)	/* Channel 2 mode (RW) */
> +#define BCM2835_PWM_CTL_RPTL2	BIT(10)	/* Channel 2 repeat last data (RW)=
 */
> +#define BCM2835_PWM_CTL_SBIT2	BIT(11)	/* Channel 2 silence bit (RW) */
> +#define BCM2835_PWM_CTL_POLA2	BIT(12)	/* Channel 2 polarity (RW) */
> +#define BCM2835_PWM_CTL_USEF2	BIT(13)	/* Channel 2 use FIFO (RW) */
> +/* Bit 14 is reserved */
> +#define BCM2835_PWM_MSEN2	BIT(15)	/* Channel 2 M/S enable (RW) */
> +/* Bits 16 - 31 are reserved */
> +
> +/* Status Register Bits */
> +#define BCM2835_PWM_STA_FULL1	BIT(0)	/* FIFO full flag (RW) */
> +#define BCM2835_PWM_STA_EMPT1	BIT(1)	/* FIFO empty flag (RW) */
> +#define BCM2835_PWM_STA_WERR1	BIT(2)	/* FIFO write error flag (RW) */
> +#define BCM2835_PWM_STA_RERR1	BIT(3)	/* FIFO read error flag (RW) */
> +#define BCM2835_PWM_STA_GAPO1	BIT(4)	/* Channel 1 gap occured (RW) */
> +#define BCM2835_PWM_STA_GAPO2	BIT(5)	/* Channel 2 gap occured (RW) */
> +#define BCM2835_PWM_STA_GAPO3	BIT(6)	/* Channel 3 gap occured (RW) */
> +#define BCM2835_PWM_STA_GAPO4	BIT(7)	/* Channel 4 gap occured (RW) */
> +#define BCM2835_PWM_STA_BERR	BIT(8)	/* Bus error flag (RW) */
> +#define BCM2835_PWM_STA_STA1	BIT(9)	/* Channel 1 state (RW) */
> +#define BCM2835_PWM_STA_STA2	BIT(10)	/* Channel 1 state (RW) */
> +#define BCM2835_PWM_STA_STA3	BIT(11)	/* Channel 1 state (RW) */
> +#define BCM2835_PWM_STA_STA4	BIT(12)	/* Channel 1 state (RW) */
> +/* Bits 13 - 31 are reserved */

Quite a few of these seem to be unused, so you might want to consider
dropping them.

> +
> +struct bcm2835_pwm_dev {

Please drop the _dev suffix. It doesn't add any value besides possibly
leading to confusion vs. struct pwm_device. It's really the chip that
this implements.

> +	struct pwm_chip chip;
> +	struct device *dev;

This is used but never initialized. But since the same field is already
contained in struct pwm_chip you can probably just use that and drop it
here.

> +	struct clk *clk;
> +	void __iomem *mmio_base;

I'd go with either "base" or "mmio". I know... other drivers use this as
well, including the Tegra one that this was based on. But I don't see
much gain in the additional 5 characters.

> +static inline struct bcm2835_pwm_dev *to_bcm(struct pwm_chip *chip)
> +{
> +	return container_of(chip, struct bcm2835_pwm_dev, chip);
> +}
> +
> +static inline u32 bcm2835_readl(struct bcm2835_pwm_dev *chip,
> +				unsigned int hwpwm, unsigned int num)

"unsigned int num" -> "unsigned long offset"? And drop hwpwm since it
doesn't make sense for most registers.

> +{
> +	num <<=3D HWPWM(hwpwm);
> +	return readl(chip->mmio_base + num);

As already hinted at above, just make this:

	return readl(chip->base + offset);

> +static inline void bcm2835_writel(struct bcm2835_pwm_dev *chip,
> +				  unsigned int hwpwm, unsigned int num,
> +				  unsigned long val)

I think it'd be clearer to keep the arguments in the same order as the
writel() function so that there's less potential for confusion:

	static inline void bcm2835_writel(struct bcm2835_pwm *chip,
					  unsigned long value,
					  unsigned long offset)

> +{
> +	num <<=3D HWPWM(hwpwm);
> +	writel(val, chip->mmio_base + num);
> +}

And:

	writel(value, chip->base + offset);

Perhaps it's not even worth defining these. Note how it's actually
shorter to write:

	writel(value, chip->base + BCM2835_PWM_CTL);

Rather than:

	bcm2835_writel(chip, value, BCM2835_PWM_CTL);

And it's much easier to parse because everyone knows readl()/writel().

> +static int bcm2835_pwm_config(struct pwm_chip *chip, struct pwm_device *=
pwm,
> +			      int duty_ns, int period_ns)
> +{
> +	struct bcm2835_pwm_dev *bcm =3D to_bcm(chip);
> +
> +	if (WARN_ON(!bcm))
> +		return -ENODEV;

That's never going to happen.

> +
> +	if (duty_ns < 1) {
> +		dev_err(bcm->dev, "duty is out of range: %d < 1\n", duty_ns);
> +		return -ERANGE;
> +	}
> +
> +	if (period_ns < 1) {
> +		dev_err(bcm->dev, "period is out of range: %d < 1\n",
> +			period_ns);
> +		return -ERANGE;
> +	}

O.o... So you effectively only allow duty_ns =3D=3D 0 and period_ns =3D 0
here? That can't work.

> +	/* disable PWM */
> +	bcm2835_writel(bcm, pwm->hwpwm, BCM2835_PWM_CTL, 0);

If you've changed the polarity, that change will be lost here. I suggest
something like:

	value =3D bcm2835_readl(bcm, BCM2835_PWM_CTL);
	value &=3D ~BCM2835_PWM_CTL_EN(pwm->hwpwm);
	bcm2835_writel(bcm, value, BCM2835_PWM_CTL);

Where:

	#define BCM2835_PWM_CTL_EN(x)	(BIT((x) * 8))

> +	/* write period */
> +	bcm2835_writel(bcm, pwm->hwpwm, BCM2835_PWM_RNG1, period_ns);
> +
> +	/* write duty */
> +	bcm2835_writel(bcm, pwm->hwpwm, BCM2835_PWM_DAT1, duty_ns);

I'd suggest something like this:

	#define BCM2835_PWM_RNG(x) (0x10 + (x) * 16)
	#define BCM2835_PWM_DAT(x) (0x14 + (x) * 16)

> +	/* start PWM */
> +	bcm2835_writel(bcm, pwm->hwpwm, BCM2835_PWM_CTL, BCM2835_PWM_CTL_PWEN1);

Similar as for disabling the PWM. And you can get rid of the comments in
my opinion, because it is pretty obvious from the code what's happening.

> +static int bcm2835_pwm_enable(struct pwm_chip *chip, struct pwm_device *=
pwm)
> +{
> +	struct bcm2835_pwm_dev *bcm =3D to_bcm(chip);
> +	int rc =3D 0;

No need to initialize here.

> +	u32 val;
> +
> +	if (WARN_ON(!bcm))
> +		return -ENODEV;

Never going to happen.

> +
> +	rc =3D clk_prepare_enable(bcm->clk);
> +	if (rc < 0)
> +		return rc;

I don't think you want to prepare again. This should probably just be

	rc =3D clk_enable(bcm->clk);

Well, it depends. Can the registers be accessed without the clock
running? Or do you need the clock to be running before accessing
registers?

> +	val =3D bcm2835_readl(bcm, pwm->hwpwm, BCM2835_PWM_CTL);
> +	val |=3D BCM2835_PWM_CTL_PWEN1;
> +	bcm2835_writel(bcm, pwm->hwpwm, BCM2835_PWM_CTL, val);

Same comment as for bcm2835_pwm_config().

> +static void bcm2835_pwm_disable(struct pwm_chip *chip, struct pwm_device=
 *pwm)
> +{
> +	struct bcm2835_pwm_dev *bcm =3D to_bcm(chip);
> +	u32 val;
> +
> +	if (WARN_ON(!bcm))
> +		return;

Not needed.

> +	val =3D bcm2835_readl(bcm, pwm->hwpwm, BCM2835_PWM_CTL);
> +	val &=3D ~BCM2835_PWM_CTL_PWEN1;
> +	bcm2835_writel(bcm, pwm->hwpwm, BCM2835_PWM_CTL, val);

Same comment as for bcm2835_pwm_enable().

> +
> +	clk_disable_unprepare(bcm->clk);

You don't want to unprepare the clock here. Just disable.

> +}
> +
> +static int bcm2835_set_polarity(struct pwm_chip *chip, struct pwm_device=
 *pwm,
> +				enum pwm_polarity polarity)
> +{
> +	struct bcm2835_pwm_dev *bcm =3D to_bcm(chip);
> +	u32 val;
> +
> +	if (WARN_ON(!bcm))
> +		return -ENODEV;

Not needed.

> +
> +	val =3D bcm2835_readl(bcm, pwm->hwpwm, BCM2835_PWM_CTL);
> +
> +	if (polarity =3D=3D PWM_POLARITY_NORMAL)
> +		val |=3D BCM2835_PWM_CTL_POLA1;
> +	else
> +		val &=3D ~BCM2835_PWM_CTL_POLA1;

This seems to be the wrong way around.

> +
> +	return 0;

And you never write back the new register value, making this function a
no-op.

> +static const struct pwm_ops bcm2835_pwm_ops =3D {
> +	.config  =3D bcm2835_pwm_config,
> +	.enable  =3D bcm2835_pwm_enable,
> +	.disable =3D bcm2835_pwm_disable,
> +	.set_polarity =3D bcm2835_set_polarity,
> +};

You need to set the .owner field. And no aligning of the =3D, please. It's
inconsistent anyway.

> +
> +static int bcm2835_pwm_probe(struct platform_device *pdev)
> +{
> +	struct bcm2835_pwm_dev *bcm;
> +	struct resource *r;
> +	int ret;
> +
> +	bcm =3D devm_kzalloc(&pdev->dev, sizeof(*bcm), GFP_KERNEL);
> +	if (!bcm)
> +		return -ENOMEM;
> +
> +	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!r) {
> +		dev_err(&pdev->dev, "no memory resource defined\n");
> +		return -ENODEV;
> +	}

devm_ioremap_resource() checks the resource for validity, so you no
longer have to do that yourself.

> +	bcm->mmio_base =3D devm_ioremap_resource(&pdev->dev, r);
> +	if (IS_ERR(bcm->mmio_base))
> +		return PTR_ERR(bcm->mmio_base);
> +
> +	bcm->clk =3D devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(bcm->clk))
> +		return PTR_ERR(bcm->clk);
> +
> +	clk_prepare_enable(bcm->clk);

This can fail, so you should check for errors and propagate them. Also
perhaps this should only be clk_prepare()? It depends: if register
accesses need the clock, then it probably makes sense to enable it here
already so you don't have to worry. If you can access the registers if
the clock isn't running, then just enable it when you enable each PWM
channel (in bcm2835_pwm_enable()).

Even if the register accesses require a clock, there's the possibility
to save some amount of power by only enabling the clock when the
registers are actually accessed. But perhaps that's not necessary.

> +static int bcm2835_pwm_remove(struct platform_device *pdev)
> +{
> +	struct bcm2835_pwm_dev *bcm =3D platform_get_drvdata(pdev);
> +
> +	if (WARN_ON(!bcm))
> +		return -ENODEV;

Don't bother. bcm will never be NULL here.

> +	clk_disable_unprepare(bcm->clk);
> +
> +	return pwmchip_remove(&bcm->chip);
> +}
> +
> +static const struct of_device_id bcm2835_pwm_of_match[] =3D {
> +	{ .compatible =3D "brcm,bcm2835-pwm" },
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(of, bcm2835_pwm_of_match);

I prefer no blank line between these.

> +static struct platform_driver bcm2835_pwm_driver =3D {
> +	.probe		=3D bcm2835_pwm_probe,
> +	.remove		=3D bcm2835_pwm_remove,
> +	.driver	=3D {
> +		.name	=3D "pwm-bcm2835",

This should be "bcm2835-pwm" for consistency with other drivers.

> +		.owner	=3D THIS_MODULE,
> +		.of_match_table =3D bcm2835_pwm_of_match,

Please don't align these since you'll eventually fail anyway. Just a
single space before and after the equal sign is just fine.

> +	},
> +};
> +
> +module_platform_driver(bcm2835_pwm_driver);

I prefer no blank line between these.

> +
> +MODULE_AUTHOR("Johannes Thumshirn <morbidrsa@gmail.com>");
> +MODULE_DESCRIPTION("BCM2835 PWM driver");
> +MODULE_LICENSE("GPL");

According to the header comment, this should actually be "GPL v2".

Thierry

--n/aVsWSeQ4JHkrmm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSQA3KAAoJEN0jrNd/PrOhp/8QAKbmAqEBNyGblaq1ZA5s4S7A
01RrzjSjcE+HSvegfaUwMMGNEgq44HtZfxaTSku55oQhZrltmckcM4ZWoYd/+FDg
3b/pafC8Pf/iVPWskV5Trj+vI8dkPynsN4aQxBi/mImeJPtMZmwTpBKc+hvJD5QG
nYBnVrjF3db7QvBc4un5l5mt9X6oxj0p49GntnsuLR9hHxo++F4P2a/ZKJv2bHfM
HgHnNsIfW77NObC301LWUJrZLU9AlzHRdS9dwLZmgdXKBcxgCqT/rTHNriQxezwN
bLPAGB/LY1YkFE9GTVH+VfsEE5VVQGEomxzrPjdB/52hsNVB1YLQ2jsV57bc123E
Merp6m6oGmDZUaPGlL+z7VLkdayq3Q4eLt2AbRSIp0oOe+sAObiPKErAMqqtWKgR
USNEAbUTwl9j3C1uY/dSngBN5L2yow8jolIclnOhjVvhFK+ocaio7GDcLEw4W4qz
Kw8Tb3H4ovDAGYoc8Hbe0gpBbPuKtHy4WuYjnmhAbDDemkipXD1D20OH+SXAJrBT
rD8YenMNH27enPK/CG+YN0bzLB4syp34Y9ML+aEZ8TlLSj3juKrIKekyIAE532FH
ugf6gdN25BJWu4dosNPiNoVL70ZSSlOBLp+gVNYUHzKhXNpCRjMg+qDxkyg5zv1b
QRZ/MyK7PlqSh1OZm5Rd
=1QCY
-----END PGP SIGNATURE-----

--n/aVsWSeQ4JHkrmm--
