Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbaGUIuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:50:11 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40790 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbaGUIuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:50:08 -0400
Date: Mon, 21 Jul 2014 10:50:03 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: heiko@sntech.de, b.galvani@gmail.com, cf@rock-chips.com,
        huangtao@rock-chips.com, addy.ke@rock-chips.com, xjq@rock-chips.com,
        linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] pwm: add this patch to support the new pwm of
 Rockchip SoCs
Message-ID: <20140721085001.GG8843@ulmo>
References: <1405774529-26027-1-git-send-email-caesar.wang@rock-chips.com>
 <1405774529-26027-3-git-send-email-caesar.wang@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PyMzGVE0NRonI6bs"
Content-Disposition: inline
In-Reply-To: <1405774529-26027-3-git-send-email-caesar.wang@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PyMzGVE0NRonI6bs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 19, 2014 at 08:55:29PM +0800, Caesar Wang wrote:
> Suggested-by: Beniamino Galvani <b.galvani@gmail.com>
> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> ---
>  drivers/pwm/pwm-rockchip.c | 97 +++++++++++++++++++++++++++++++++++++---=
------
>  1 file changed, 79 insertions(+), 18 deletions(-)

This patch is missing a proper description. Also "pwm" should be spelled
"PWM" in prose.

And the subject is somewhat long and generic. How about:

	pwm: rockchip: Add support for RK3288 SoCs

?

> diff --git a/drivers/pwm/pwm-rockchip.c b/drivers/pwm/pwm-rockchip.c
[...]
> @@ -12,6 +13,7 @@
>  #include <linux/io.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> +#include <linux/of_device.h>
>  #include <linux/platform_device.h>
>  #include <linux/pwm.h>
>  #include <linux/time.h>
> @@ -23,14 +25,36 @@
>  #define PWM_CTRL_TIMER_EN	(1 << 0)
>  #define PWM_CTRL_OUTPUT_EN	(1 << 3)
> =20
> +#define RK_PRESCALER		1
>  #define PRESCALER		2

I don't think there's a need to keep these around now that they're part
of the rockchip_pwm_data structure.

> +#define PWM_CONTINUOUS		(1 << 1)
> +#define PWM_DUTY_POSITIVE	(1 << 3)
> +#define PWM_INACTIVE_NEGATIVE	(0 << 4)
> +#define PWM_OUTPUT_LEFT		(0 << 5)
> +#define PWM_LP_DISABLE		(0 << 8)
> +
> +#define RK_PWM_ENABLE		(1 << 0)

I think you can drop the RK_ prefix here since none of the above have it
either and they're used in the same context.

> +
> +#define VOP_PWM_CTRL		0x00		/* VOP-PWM Control Register */
> +#define VOP_PWM_CNTR		0x0c

Similarly for these.

> +
>  struct rockchip_pwm_chip {
>  	struct pwm_chip chip;
>  	struct clk *clk;
> +	const struct rockchip_pwm_data *data;
>  	void __iomem *base;
>  };
> =20
> +struct rockchip_pwm_data {
> +	u32 duty;
> +	u32 period;
> +	u32 reg_cntr;
> +	u32 reg_ctrl;

duty and period are register offsets, right? Why don't they have the
reg_ prefix? Alternatively you could drop the reg_ prefix altogether.
Yet another alternative would be to introduce a substructure that
contains the registers, to separate the fields logically:

	struct rockchip_pwm_data {
		struct {
			unsigned long duty;
			unsigned long period;
			unsigned long cntr;
			unsigned long ctrl;
		} regs;
		...
	};

As shown, I think it's more natural for register offsets to be unsigned
long rather than a strictly-sized type.

> +	int prescaler;

unsigned int

> +	u32 enable_conf;
> +};

For this I think it would be more readable to provide function pointers
rather than a variable. That is:

	struct rockchip_pwm_data {
		...
		int (*enable)(struct pwm_chip *chip, struct pwm_device *pwm);
		int (*disable)(struct pwm_chip *chip, struct pwm_device *pwm);
	};

Then you can implement these for each variant of the chip and call them
=66rom the common rockchip_pwm_enable(), somewhat like this:

	static int rockchip_pwm_enable(struct pwm_chip *chip, struct pwm_device *p=
wm)
	{
		struct rockchip_pwm_chip *pc =3D to_rockchip_pwm_chip(chip);
		int ret;

		ret =3D clk_enable(pc->clk);
		if (ret)
			return ret;

		ret =3D pc->data->enable(chip, pwm);
		if (ret)
			clk_disable(pc->clk);

		return ret;
	}

And similarly for rockchip_pwm_disable().

> +static struct rockchip_pwm_data pwm_data_v1 =3D {

static const please.

> +static struct rockchip_pwm_data pwm_data_v2 =3D {

Here too.

> +static struct rockchip_pwm_data pwm_data_vop =3D {

And here.

> +	const struct of_device_id *of_id =3D

I don't think the of_ prefix is necessary here.

> +	    of_match_device(rockchip_pwm_dt_ids, &pdev->dev);

And perhaps rather than split this over two lines here you can move this
assignment somewhere below the variable declarations?

>  	struct rockchip_pwm_chip *pc;
>  	struct resource *r;
>  	int ret;
> @@ -119,7 +182,10 @@ static int rockchip_pwm_probe(struct platform_device=
 *pdev)
>  		return -ENOMEM;
> =20
>  	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	pc->base =3D devm_ioremap_resource(&pdev->dev, r);
> +	if (!strcmp(of_id->compatible, "rockchip,vop-pwm"))
> +		pc->base =3D devm_ioremap(&pdev->dev, r->start, resource_size(r));
> +	else
> +		pc->base =3D devm_ioremap_resource(&pdev->dev, r);

Sorry, this still isn't an option. You really shouldn't remap I/O
regions that other drivers may be using. You hinted at a shared register
space during the review of the initial version. Can you provide more
detail about what exactly the memory map looks like of the rk3288? Is
there some kind of technical reference manual that I could look at? Or
do you have a device tree extract that shows what the memory map looks
like?

Thierry

--PyMzGVE0NRonI6bs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTzNQ5AAoJEN0jrNd/PrOhYIgP/AgJfN9Kp928uFt/ImEY0x82
JZMY64DtTQxxXRB3cRQnjsMGslTCzNpP8iV9EYNLb+VvRfaJyGFi+LtJFi8rDYnk
kcLtzJexr1XqqgKzBrLkH1ak9QTuNb2LIjZsnYShU5ljNc2Wp3n0K+5tOSs4uBrI
vAZTdcZ/LX8JSjSq7BCHcMp0lLZo43xKceFXvLYhYDK7sGrfIz9TQ4VL7DILtXFf
k5TZ0gYmiHr6mvG5O8PkoVMEIdy/LO0u1DXWTFi4bsg9MBZIqH2C+2qYfY64hzVD
2JthlvEkKqRfX0viQuZ8aqLANSEnp7089F/HZiJiRf0LDVaupzql+OYbg6923EpS
aOfGcRdgndQ38hfxADzPVdxxV0+tR57yVoPsevrLd/la4+NUJtUTgR1M/WvuZDLl
n5xxI97bhvV+TpV6EAbyh5BA7KwedUQIPhCBy1PY23Nh5DeHhqibLfsJgJU6RKw1
E5jBlsWirt4wZeJUwH8eFdbWRbsjUxX3d2oBBee/Ax4ZQOyw58foiYaBOiz+3KxV
fAf8W/ag8geUh3GgbLFu4vz+PPn6iTzw3E6q9WQ1KBs8HoaUxVzLjFrFm1GMBu7+
tBCGwe1ZQw63NCr/pZnhlLXPLysGpzSe+i16IvSKIuymnq28oy74V++PRrNR6w3x
GLKRP5Oc3ggLNLykhgK3
=rx7n
-----END PGP SIGNATURE-----

--PyMzGVE0NRonI6bs--
