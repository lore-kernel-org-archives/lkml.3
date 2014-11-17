Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaKQMX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 07:23:28 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:42552 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaKQMX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 07:23:26 -0500
Date: Mon, 17 Nov 2014 13:23:21 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Simon <longsleep@gmail.com>, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv9 1/2] pwm: Add Allwinner SoC support
Message-ID: <20141117122319.GI25699@ulmo>
References: <1415200545-26238-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1415200545-26238-2-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CNK/L7dwKXQ4Ub8J"
Content-Disposition: inline
In-Reply-To: <1415200545-26238-2-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CNK/L7dwKXQ4Ub8J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 05, 2014 at 04:15:44PM +0100, Alexandre Belloni wrote:
> This adds a generic PWM framework driver for the PWM controller
> found on Allwinner SoCs.
>=20
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/pwm/Kconfig     |   9 ++
>  drivers/pwm/Makefile    |   1 +
>  drivers/pwm/pwm-sun4i.c | 366 ++++++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 376 insertions(+)
>  create mode 100644 drivers/pwm/pwm-sun4i.c
>=20
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 3865dfb9ed08..424359d3cbb1 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -262,6 +262,15 @@ config PWM_STI
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-sti.
> =20
> +config PWM_SUN4I
> +	tristate "Allwinner PWM support"
> +	depends on ARCH_SUNXI || COMPILE_TEST

I think you're going to need a bunch of other dependencies here, too.
HAS_IOMEM and COMMON_CLK at least, I'd expect.

> +	help
> +	  Generic PWM framework driver for Allwinner SoCs.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called pwm-sunxi.

According to the Makefile extract below it'll be called pwm-sun4i.

> +
>  config PWM_TEGRA
>  	tristate "NVIDIA Tegra PWM support"
>  	depends on ARCH_TEGRA
> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
> index c458606c3755..d607804deea1 100644
> --- a/drivers/pwm/Makefile
> +++ b/drivers/pwm/Makefile
> @@ -24,6 +24,7 @@ obj-$(CONFIG_PWM_ROCKCHIP)	+=3D pwm-rockchip.o
>  obj-$(CONFIG_PWM_SAMSUNG)	+=3D pwm-samsung.o
>  obj-$(CONFIG_PWM_SPEAR)		+=3D pwm-spear.o
>  obj-$(CONFIG_PWM_STI)		+=3D pwm-sti.o
> +obj-$(CONFIG_PWM_SUN4I)		+=3D pwm-sun4i.o
>  obj-$(CONFIG_PWM_TEGRA)		+=3D pwm-tegra.o
>  obj-$(CONFIG_PWM_TIECAP)	+=3D pwm-tiecap.o
>  obj-$(CONFIG_PWM_TIEHRPWM)	+=3D pwm-tiehrpwm.o
> diff --git a/drivers/pwm/pwm-sun4i.c b/drivers/pwm/pwm-sun4i.c
[...]
> +static int sun4i_pwm_config(struct pwm_chip *chip, struct pwm_device *pw=
m,
> +			    int duty_ns, int period_ns)
[...]
> +{
> +	struct sun4i_pwm_chip *sun4i_pwm =3D to_sun4i_pwm_chip(chip);
> +	u32 clk_rate, prd, dty, val, clk_gate;
> +	u64 div =3D 0;
> +	unsigned int prescaler =3D 0;
> +	int err;
> +
> +	clk_rate =3D clk_get_rate(sun4i_pwm->clk);
> +
> +	if (sun4i_pwm->data->has_prescaler_bypass) {
> +		/* First, test without any prescaler when available */
> +		prescaler =3D PWM_PRESCAL_MASK;
> +		/*
> +		 * When not using any prescaler, the clock period in nanoseconds
> +		 * is not an integer so round it half up instead of
> +		 * truncating to get less surprising values.
> +		 */
> +		div =3D clk_rate * (u64)period_ns + NSEC_PER_SEC/2;

The cast here looks odd. Perhaps a better way would be to make clk_rate
a u64 so that type promotion rules will automatically cast here for you.

> +		do_div(div, NSEC_PER_SEC);
> +		if (div - 1 > PWM_PRD_MASK)
> +			prescaler =3D 0;
> +	}
> +
> +	if (prescaler =3D=3D 0) {
> +		/* Go up from the first divider */
> +		for (prescaler =3D 0; prescaler < PWM_PRESCAL_MASK; prescaler++) {
> +			if (!prescaler_table[prescaler])
> +				continue;
> +			div =3D clk_rate / prescaler_table[prescaler];
> +			div =3D div * (u64)period_ns;

Type promotion rules should make the explicit cast unnecessary.

> +	val =3D sun4i_pwm_readl(pwm, PWM_CTRL_REG);
> +	for (i =3D 0; i < pwm->chip.npwm; i++) {
> +		if (!(val & BIT_CH(PWM_ACT_STATE, i)))
> +			pwm->chip.pwms[i].polarity =3D PWM_POLARITY_INVERSED;
> +	}

There's no need for the braces here.

Thierry

--CNK/L7dwKXQ4Ub8J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUaei3AAoJEN0jrNd/PrOh7BEQAIz0eUZEyy1q/tB1LvbABNHf
QZJqDTITfGB6TYlfjIUVL7V/6WKcrgW3zT1CNktTVP2FRGX7om+XUzasjcmbWsOc
8azWNNZSIq3Z90CCU0uspNHhVonX88BZ2dy6TTMVwuUWPJMG7O4di6mIxAdNy2q1
/xyh96JUG6dEiQqxgtiGspJ0dbzkblpK91ni2tceeDm+DBbI7MHV4neOu98nG7q2
jfjW3C7UW6Ap9Ypi6rDQpTBe23V9zbeBsrlxfvN4TUHUzWAHP5Y1MTvgig5roWWs
liVRbh4TAKM1NFK3WjJxS7wznkci2QzllJ6jPZAApCQpOIg8Kg19w/r0KpeEGvxw
vtzNduJGMOHCpraS/pDh3zAguAXaINuQNT2jsGWpHpqrV8bJiffT0vaBjtHSIfEE
cWSIw2ik6Wj3D3anaSWAEWzdyWf73QKOPhMw7fYsJEINFlteoC9AaV2mm9UkmvVV
zqPE1/8Y5yUR89H/S1Wfi2k94kRxxwi1/9p7EkboWj9WfVwVtldHX8KPIUSoohgW
d+CwoTsv583tY/4JMCX2PVU8MPGNzjXSIihTGJXl92zgcwShwpS71GN3RVf3bQJw
Ir3yz6fCGUzMNVmuWWVOPzDPbPcKAT1B8iihKXuva+fjC3cEnBI6sBx0dbDguafy
82hYg9nu/eEENSJWRs8O
=A9ca
-----END PGP SIGNATURE-----

--CNK/L7dwKXQ4Ub8J--
