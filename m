Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965438AbaFQVnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:43:06 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:45909 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964852AbaFQVnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:43:02 -0400
Date: Tue, 17 Jun 2014 23:42:58 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Heiko Stuebner <heiko@sntech.de>, linux-pwm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/3] pwm: add Rockchip SoC PWM support
Message-ID: <20140617214253.GA24743@mithrandir>
References: <1399504115-16257-1-git-send-email-b.galvani@gmail.com>
 <1399504115-16257-2-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <1399504115-16257-2-git-send-email-b.galvani@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 08, 2014 at 01:08:33AM +0200, Beniamino Galvani wrote:
> This commit adds a driver for the PWM controller found on Rockchip
> RK29, RK30 and RK31 SoCs.
>=20
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> ---
>  drivers/pwm/Kconfig        |    8 ++
>  drivers/pwm/Makefile       |    1 +
>  drivers/pwm/pwm-rockchip.c |  180 ++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 189 insertions(+)
>  create mode 100644 drivers/pwm/pwm-rockchip.c
>=20
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 5b34ff2..2e92245 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -197,6 +197,14 @@ config PWM_RENESAS_TPU
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-renesas-tpu.
> =20
> +config PWM_ROCKCHIP
> +	tristate "Rockchip PWM support"
> +	depends on ARCH_ROCKCHIP
> +	depends on OF

It seems like ARCH_ROCKCHIP depends on OF already (via ARCH_MULTI_V7 and
ARCH_MULTIPLATFORM), so having the dependency explicitly here seems
redundant.

> diff --git a/drivers/pwm/pwm-rockchip.c b/drivers/pwm/pwm-rockchip.c
[...]
> +#define PRESCALER		2
> +#define NSECS_PER_SEC		1000000000

You should use NSEC_PER_SEC from include/linux/time.h.

> +struct rockchip_pwm_chip {
> +	struct pwm_chip	chip;
> +	struct clk	*clk;
> +	void __iomem	*base;
> +};

I prefer no artificial padding within structure definitions.

> +static int rockchip_pwm_config(struct pwm_chip *chip, struct pwm_device =
*pwm,
> +			       int duty_ns, int period_ns)
> +{
> +	struct rockchip_pwm_chip *pc =3D to_rockchip_pwm_chip(chip);
> +	unsigned long clk_rate, period, duty;
> +	u64 div;
> +	int ret;
> +
> +	clk_rate =3D clk_get_rate(pc->clk);
> +
> +	/*
> +	 * Since period and duty cycle registers have a width of 32
> +	 * bits, every possible input period can be obtained using the
> +	 * default prescaler value for all practical clock rate values.
> +	 */
> +	div =3D clk_rate;
> +	div *=3D period_ns;

Perhaps shorten this to "div =3D clk_rate * period_ns;"?

> +	do_div(div, PRESCALER * NSECS_PER_SEC);
> +	period =3D div;
> +
> +	div =3D clk_rate;
> +	div *=3D duty_ns;

And this to "div =3D clk_rate * duty_ns;"?

> +	do_div(div, PRESCALER * NSECS_PER_SEC);
> +	duty =3D div;
> +
> +	ret =3D clk_enable(pc->clk);
> +	if (ret)
> +		return ret;
> +
> +	writel(period, pc->base + PWM_LRC);
> +	writel(duty, pc->base + PWM_HRC);
> +	writel(0, pc->base + PWM_CNTR);
> +
> +	clk_disable(pc->clk);
> +
> +	return 0;
> +}
[...]
> +static struct pwm_ops rockchip_pwm_ops =3D {

static const please.

> +	.config	=3D rockchip_pwm_config,

There's a tab between .config and =3D above. It should be a space.

> +static const struct of_device_id rockchip_pwm_dt_ids[] =3D {
> +	{ .compatible =3D "rockchip,rk2928-pwm" },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, rockchip_pwm_id_ids);

The name in the MODULE_DEVICE_TABLE doesn't match the array name above.
Does this even build?

> +static struct platform_driver rockchip_pwm_driver =3D {
> +	.driver =3D {
> +		.name =3D "rockchip-pwm",
> +		.owner =3D THIS_MODULE,

You no longer need to initialize this explicitly, module_platform_driver
does it for you.

> +		.of_match_table =3D rockchip_pwm_dt_ids,
> +	},
> +	.probe	=3D rockchip_pwm_probe,

There's another tab instead of space here.

> +	.remove =3D rockchip_pwm_remove,
> +};
> +module_platform_driver(rockchip_pwm_driver);
> +
> +MODULE_AUTHOR("Beniamino Galvani <b.galvani@gmail.com>");
> +MODULE_DESCRIPTION("Rockchip PWM driver");

Perhaps "Rockchip SoC PWM driver"?

Thierry

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJToLZdAAoJEN0jrNd/PrOhq1AP/3tlStBOsWJeLvDe0FIdvHHL
iXDNQoWeNdgvfafrkbsdYfAYrOMPaREjvmsIAudLS9C7VmXKDobRjQfffYJlBgFG
pAwBFfRiMsclXISmHWLTZygBLRvelH+q2AE/GAlzJ2G4kzXIK+rbU0CPJoVJ3hOr
mctNhJ97SINjkWS6/iwL/pqE97NRTvcgfCctM2eo+6u6lum1ZSN1Ql1u/r24EAEM
F2wH4OQQhkRKGW0Rpiu+sB/+/813Ekt06bU0XII6YgM6GpGgZVHoOA5wj3sOdnMd
DRYPzXGXtpyiiJLBoLB5PKuHENytFEnNVwH1gRnWS6qWjihTZ7PIW/xRzadCccsH
zkDwGEelbDSp4/z2AHlfHj1rhc+WcHDLqyLKYPIXJFQamnQeMC6jXF847Qjah2oh
83iSfcsrRLJ6sKQHY0Fk8YVwzQgDpJtgh+cAkErtBcUTyJ0A+HrMPx4LDeDwACtx
psPPMVArT4EStwx2zGeZKH88yWzn+7qhA6POYXikN16PbRN+u8k4ClFswSfdJ6bc
0++hTYBJQlJrZu3GJ3Rg8GhylcgPyNfjBjlKb1H4yvuy857VZay4iOzirhpnumUW
6NrNO04fpCyHRpDTVFH4inJsaVOgPVcJ99jfX402NPw3h6VIRSO4mMhx5trEQwy5
of/yBVYQqjChhFBHyodW
=Trpz
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
