Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaIYGwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 02:52:34 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:64323 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaIYGwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 02:52:33 -0400
Date: Thu, 25 Sep 2014 08:52:30 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Nikolaus Voss <n.voss@weinmann-emt.de>
Cc: Bo Shen <voice.shen@atmel.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm: atmel-pwm: fix calculation of prescale value
Message-ID: <20140925065229.GD12423@ulmo>
References: <20140924055851.CE51140656@mail.steuer-voss.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x4pBfXISqBoDm8sr"
Content-Disposition: inline
In-Reply-To: <20140924055851.CE51140656@mail.steuer-voss.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x4pBfXISqBoDm8sr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2014 at 03:30:21PM +0200, Nikolaus Voss wrote:
> The prescale value used for calculating the period was incremented
> afterwards, thus the resulting prescale value is by one too high.
> This resulted in a pwm frequency only half as high as requested.
>=20
> This patch moves the 64 bit division out of the prescale loop to
> correct the above issue and make the calculation more efficient.
>=20
> Signed-off-by: Nikolaus Voss <n.voss@weinmann-emt.de>
> ---
>  drivers/pwm/pwm-atmel.c | 24 +++++++++++-------------
>  1 file changed, 11 insertions(+), 13 deletions(-)

Hi Nikolaus,

Please Cc the linux-pwm@vger.kernel.org mailing list for PWM-related
patches in the future.

Also a couple more comments:

In the patch description: "pwm frequency" should be "PWM frequency".

> diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
> index 6e700a5..ff17b5d 100644
> --- a/drivers/pwm/pwm-atmel.c
> +++ b/drivers/pwm/pwm-atmel.c
> @@ -102,7 +102,7 @@ static int atmel_pwm_config(struct pwm_chip *chip, st=
ruct pwm_device *pwm,
>  			    int duty_ns, int period_ns)
>  {
>  	struct atmel_pwm_chip *atmel_pwm =3D to_atmel_pwm_chip(chip);
> -	unsigned long clk_rate, prd, dty;
> +	unsigned long prd, dty;
>  	unsigned long long div;
>  	unsigned int pres =3D 0;
>  	u32 val;
> @@ -113,20 +113,18 @@ static int atmel_pwm_config(struct pwm_chip *chip, =
struct pwm_device *pwm,
>  		return -EBUSY;
>  	}
> =20
> -	clk_rate =3D clk_get_rate(atmel_pwm->clk);
> -	div =3D clk_rate;
> +	/* Calculate the period cycles and prescale value */
> +	div =3D (unsigned long long)clk_get_rate(atmel_pwm->clk) * period_ns;
> +	do_div(div, (int)1e9);

1e9 should be NSEC_PER_SEC.

> -	/* Calculate the period cycles */
>  	while (div > PWM_MAX_PRD) {
> -		div =3D clk_rate / (1 << pres);
> -		div =3D div * period_ns;
> -		/* 1/Hz =3D 100000000 ns */
> -		do_div(div, 1000000000);
> -
> -		if (pres++ > PRD_MAX_PRES) {
> -			dev_err(chip->dev, "pres exceeds the maximum value\n");
> -			return -EINVAL;
> -		}
> +		div >>=3D 1;
> +		++pres;

Unless you really need the prefix increment behaviour (you don't in this
case) I prefer using the postfix operator because it is slightly more
idiomatic.

No need for you to respin the patch, I've fixed up the above when
applying.

Thierry

--x4pBfXISqBoDm8sr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUI7utAAoJEN0jrNd/PrOhM5gP/AxLEF2BEW6MdsikrgHkACXA
zvwI1QaSOFdDbvRXhncEa0yRCoAdIhq5ttQ6ieHmn+W/u6LkB6Ts/hYHOtUUt0Qm
Tbbwh6v+wfmlECFBNqqQz9+qWBhFirVqVNWqy51OBIitLRc+qr8jX44VhXXTKpWB
OOFSw4/BBJkn0kkbZgHHGa5P322zazPnPSizxU2V7iBg7w/r3OgZLiK7gwKA7HpD
lCKA5/7r9f7IYKRwI6ONDrWMan12J9t41NS7OGzGWzsdWsmKi5e7/jPzAPWyUCkb
yAwH5Y0tafYSeAuwC3SEit0Nl3vL8b0rbMM9f7EjSqWLt6ZVrulzzZUzAijue1jv
Ycn4jrs7RvcrA9cz3l3SNRtvtNTRa3Zb+1nyKq+SedsTYBl+JGHgGxP90ErxyVqI
VrSFsfdnRRNvKKdx68lBnE4IxJ3PnH0mv2vxVZ7hkdSJo4z3QTi8dcNYWize2Ui0
+3cUDMKVgaUJnTNrtgzJ0nHzP4uICAfthhrQdHNu+s24llWEQbqzRA8CXoQ4FicY
MrQ3DKsAfTTcAYc0XBIb1maN8e8fpQ4zx+FVwtMIsM/YE+A30IyuIsb792kfiDR1
JN34crjNFz0DKRz+TB7WxvhO5aliAEF9GxLarPyGwR2KAX+vP1XYuHVD8jHO5BQH
d+joTJjtMiNaYw/YTbO0
=Af0/
-----END PGP SIGNATURE-----

--x4pBfXISqBoDm8sr--
