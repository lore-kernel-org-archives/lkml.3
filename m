Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbaHRIUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:20:47 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:49337 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaHRIUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:20:44 -0400
Date: Mon, 18 Aug 2014 10:20:40 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-pwm@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] pwm: Fix period and polarity in pwm_get() for
 non-perfect matches
Message-ID: <20140818082039.GA31171@ulmo>
References: <1407943133-18170-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <1407943133-18170-1-git-send-email-geert+renesas@glider.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 05:18:53PM +0200, Geert Uytterhoeven wrote:
> If pwm_get() finds a look-up entry with a perfect match (both dev_id and
> con_id match), the loop is aborted, and "p" still points to the correct
> struct pwm_lookup.
>=20
> If only an entry with a matching dev_id or con_id is found, the loop
> terminates after traversing the whole list, and "p" now points to
> arbitrary memory, not part of the pwm_lookup list.
> Then pwm_set_period() and pwm_set_polarity() will set random values for
> period resp. polarity.
>=20
> To fix this, save period and polarity when finding a new best match,
> just like is done for chip (for the provider) and index.
>=20
> This fixes the LCD backlight on r8a7740/armadillo-legacy, which was fed
> period 0 and polarity -1068821144 instead of 33333 resp. 1.
>=20
> Fixes: 3796ce1d4d4b330a75005c5eda105603ce9d4071 ("pwm: add period and pol=
arity to struct pwm_lookup")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: stable@vger.kernel.org
> ---
>  drivers/pwm/core.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

Good catch! One comment below.

> diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
> index 4b66bf09ee55..d2c35920ff08 100644
> --- a/drivers/pwm/core.c
> +++ b/drivers/pwm/core.c
> @@ -606,6 +606,8 @@ struct pwm_device *pwm_get(struct device *dev, const =
char *con_id)
>  	unsigned int best =3D 0;
>  	struct pwm_lookup *p;
>  	unsigned int match;
> +	unsigned int period;
> +	enum pwm_polarity polarity;
> =20
>  	/* look up via DT first */
>  	if (IS_ENABLED(CONFIG_OF) && dev && dev->of_node)
> @@ -653,6 +655,8 @@ struct pwm_device *pwm_get(struct device *dev, const =
char *con_id)
>  		if (match > best) {
>  			chip =3D pwmchip_find_by_name(p->provider);
>  			index =3D p->index;
> +			period =3D p->period;
> +			polarity =3D p->polarity;
> =20
>  			if (match !=3D 3)
>  				best =3D match;
> @@ -668,8 +672,8 @@ struct pwm_device *pwm_get(struct device *dev, const =
char *con_id)
>  	if (IS_ERR(pwm))
>  		return pwm;
> =20
> -	pwm_set_period(pwm, p->period);
> -	pwm_set_polarity(pwm, p->polarity);
> +	pwm_set_period(pwm, period);
> +	pwm_set_polarity(pwm, polarity);

Could we achieve the same by storing a pointer to the best match and
then use that instead of p? Perhaps something like this:

	struct pwm_lookup *entry;

	...

		if (match > best) {
			chip =3D pwmchip_find_by_name(p->provider);
			entry =3D p;

			if (match !=3D 3)
				best =3D match;
			else
				break;
		}

	...

	if (chip)
		pwm =3D pwm_request_from_chip(chip, entry->index,
					    con_id ?: dev_id);
	if (IS_ERR(pwm))
		return pwm;

	pwm_set_period(pwm, entry->period);
	pwm_set_polarity(pwm, entry->polarity);

?

Thierry

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT8bdXAAoJEN0jrNd/PrOhqd0P/Rfa61WKYMSxVkX0i7ihg7k5
fyEphp3FSTGZkCtWy51dcIcY2LW58kX/xHF/ha6Jc/qIYeE21XOWIWyk0HtzWI1M
6K18zoUywitDgLibcwc+9myQqGUGWwmiaCSfJ04hasOw6KnlzKul+RMZGwgZPNpA
EfP+InBPlFuiecKZbgArn1YEYiqyusTjILfojB0VGmkVR1cKksWmfooCv6yvGZfI
+vfCpqc1sF3JiIt9KeW1UxgjN0hvL2gW/+1U+QGcsyDUfDMV2+SAXDjqrYsFeBWY
F+NNlLuIwBJba/WspnCs6K2kpJkyDdHKIcxz5yfmKFj4bCOR0BG5m0UHBy/+tlpZ
3v8FcZ+l4T/WRhMlVeD0RHaxpiOZRLl2U1O00TNVfaxsTwzTC+MqWCekNrYmn10u
6OF+eDvMlO/q1OF/OS9qoh/fV/zYZG/aQPW701MuULGj/rDoWFat8slmOAwNguxe
2u234HeIs6jSQn5ioKOoMRJ/BEU8qDRIJp1w4Tqh2IOq4tPEgXoIXZ8t5S8HX2cx
w0YQ5WnRNUun30ndxdKKC3O6Mjg46D8GJX8hRj7VsVNmWw55e0WSdizMtGbuMQDk
2InW8SOi9V72HSTMIVqiXwmOU0CKwWo4psAFntN65OpJo+y/YMZzdpIBAwiSUeVo
1iakqy0F21jvTkiahVlf
=VG9t
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
