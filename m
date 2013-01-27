Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab3A0GA2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 01:00:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51529 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755816Ab3A0GAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 01:00:25 -0500
Date: Sun, 27 Jan 2013 14:00:15 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Axel Lin <axel.lin@ingics.com>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] regulator-core: support shared enable GPIO concept
Message-ID: <20130127060012.GA8952@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E12B2D@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E12B2D@DQHE02.ent.ti.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 15, 2013 at 04:35:41AM +0000, Kim, Milo wrote:
>  A Regulator can be enabled by external GPIO pin.
>  This is configurable in the regulator_config.

Please use subject lines matching the subsystem - not doing this makes
it more likely that patches will be missed or responses delayed.  For
example, when looking at my patch queue for regulator patches I search
for "regulator:" in my review pending queue, patches that don't have
that won't turn up.  This should be "regulator: core: ...".

Anyway, this series looks pretty close now...

> +/* Manage enable GPIO list. Same GPIO pin can be shared among regulators */
> +static int regulator_ena_gpio_request(struct regulator_dev *rdev,
> +				const struct regulator_config *config)
> +{
> +	struct regulator_enable_gpio *pin;
> +	int ret;
> +
> +	list_for_each_entry(pin, &regulator_ena_gpio_list, list) {
> +		if (pin->gpio == config->ena_gpio) {
> +			rdev_info(rdev, "GPIO %d is already used\n",
> +				config->ena_gpio);
> +			return 0;

This log is going to get noisy once the GPIOs are shared.  A _dbg()
would be OK though.

> +	ret = gpio_request_one(config->ena_gpio,
> +				GPIOF_DIR_OUT | config->ena_gpio_flags,
> +				rdev_get_name(rdev));
> +	if (ret)
> +		return ret;
> +
> +	pin = kzalloc(sizeof(struct regulator_enable_gpio), GFP_KERNEL);
> +	if (pin == NULL)
> +		return -ENOMEM;

Should free the GPIO if there's an error here.

> +	pin->regulator = rdev;

Do we really want to keep track of the regulator here, again once we
start sharing pins...

We also need some matching code in the release path to free the GPIO and
struct when the regulator is removed.

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRBMJgAAoJELSic+t+oim9QUUP/iSlrEfIJ1svasPSudCKtMmb
iC+LeERREpgAc/uizd8O34ceR+5LGcHPpFz0Jg6LMMZV39REPE+Q12DwvwnK9Fvb
v8nJ3d9/QevdBKYmRcpyovzyvEUPT61ryi5hydFYkN2GrTNp9HqS3LucaGvb7t59
C3PbHmDTh8d/Ovhs6crBCFcvaiKCJMq7+KqzyieyEav6gxXwlV1MM/2thjM47lwr
kyVn6tykCqSYunlHsHHQtOdc9wORkmdEi0RdTQRwgvHJYzKHZSD+ofg8EYjDz/zs
SF6nyqfApXiC7j4lEDeIyTvsqGCKN7EvNRclZaKbzAPQI+BoVXhwGr+AL4jl+F79
n0WvmZqvnEG+iXUsm1rs3omCtJWLbhyPj7LMaZ0yFDFdgpITQMFMdlMgNYMu/FB4
5UlE53BkIwbIG8QAwC2ctf0Qn3M+DaEbcBin5wfygkyogVa+LYGozb1GiPE1OIrw
3FdO4Rzo5ji7D3mGmpZuFOycSvEW+guZZ3Gl7TwptAL+WxTxru8dg1LR3rVh/Wfz
5MPlgIcFQTt3XM+y+Gl5Vy+oVyVy+jT7o3csp9Mgvm7J82XuU/HGnDQkgzxazuQB
h9njoThWW1FcxHc/ZUihfYZWaWdnXo3VNmSI4dX7lQ3Q4NcxqBmMkiQ0oBCNWsQU
mW9xilpBs+4RgBL40il5
=qUgd
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
