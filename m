Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbaEGIUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:20:48 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:56875 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbaEGIUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:20:45 -0400
Date: Wed, 7 May 2014 10:18:51 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-pwm@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] pwm-backlight: switch to gpiod interface
Message-ID: <20140507081850.GB6362@ulmo>
References: <1393480414-19473-1-git-send-email-acourbot@nvidia.com>
 <1393480414-19473-3-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4bRzO86E/ozDv8r1"
Content-Disposition: inline
In-Reply-To: <1393480414-19473-3-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4bRzO86E/ozDv8r1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 27, 2014 at 02:53:34PM +0900, Alexandre Courbot wrote:
> Switch to the new gpiod interface, which allows to handle GPIO
> properties such as active low transparently and removes a whole bunch of
> code.
>=20
> There are still a couple of users of this driver that rely on passing
> the enable GPIO number through platform data, so a fallback mechanism
> using a GPIO number is still available to avoid breaking them. It will
> be removed once current users have switched to the GPIO lookup tables
> provided by the gpiod interface.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/video/backlight/pwm_bl.c | 72 +++++++++++++++++-----------------=
------
>  include/linux/pwm_backlight.h    |  5 +--
>  2 files changed, 32 insertions(+), 45 deletions(-)

I've applied this with two tiny changes, see below. Please shout if you
think that's a bad idea.

> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/p=
wm_bl.c
[...]
> @@ -256,8 +238,6 @@ static int pwm_backlight_probe(struct platform_device=
 *pdev)
[...]
> +	pb->enable_gpio =3D devm_gpiod_get(&pdev->dev, "enable");
> +	if (IS_ERR(pb->enable_gpio)) {
> +		ret =3D PTR_ERR(pb->enable_gpio);
> +		if (ret =3D=3D -ENOENT) {
> +			pb->enable_gpio =3D NULL;
> +			ret =3D 0;
> +		} else {
> +			goto err_alloc;
> +		}

I dropped the ret =3D 0 here because all error paths set it explicitly and
the non-error path never uses it. Now all branches have a single
statement and therefore the braces can be dropped.

> +	/*
> +	 * Compatibility fallback for drivers still using the integer GPIO
> +	 * platform data. Must go away soon.
> +	 */
> +	if (pb->enable_gpio =3D=3D NULL && gpio_is_valid(data->enable_gpio)) {

Changed the first condition to !pb->enable_gpio for consistency.

Thierry

--4bRzO86E/ozDv8r1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTaexqAAoJEN0jrNd/PrOhCYIP/RMj0qdQSZvWYyXu/EO1bmNB
C1a6HAAsGe5dqTg5CcRzvkgqUUcZ0pjJ3EMuhZqOCYVguBSkJp+V9xGhVCRRMmm/
xGM7l3VPfMmzYPHIvZpdR28DgVJtEJYv2GWIfqwTOsuvRPm6WkRDMX7g0hhhuiis
i14u/4bKKRKnr6RMH7lk6C02o2OqdVYoRM+6DlpMvASwt5ZWfplL619raqODZ04K
vOp5zAJ5EIr11hl5ofJiGxOS4VgIQcBZlnq1zb24I45/kio4Z5eIQMdx/OPWiHQP
FfwCBp2O3YAv1+sPEgxLC//KGW9bu2aDAWTiNGR1aWRuRpQ5fonGkbfBbdgFFanL
41kURPdMWf1/+K5jlUyhNGDvImP/ZyzQybISR9qb2Xqh00nzKSlDpxClwv+/6Kzu
Grb9ZMZo6xfQ0EbhTu+WuhLJaXu9yaDieTU/8GbUaOzVkFnIFdQqxYBK+xCEo6mh
6QmHbj+5/i84x/6f8Xbuwhi4aSRB+GbTJUkiy8n7DmtDlxSx8zj/uzacZokrmgJz
41CyWH65PgglXzNCRhpf/8e8BMJzF/sLBUGZC1crRX8AZ/85pu7ijigDMvkb0EJt
1ccQxx/NPDJu5xGlHdPQYi0AkIYLZFVDysKI+f3OUKxRDTYm/gs6bVO93DEQ4WeK
a6td/zWBu7204uQN8IGW
=J83N
-----END PGP SIGNATURE-----

--4bRzO86E/ozDv8r1--
