Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab3ISL6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 07:58:10 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:61815 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab3ISL6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 07:58:08 -0400
Date: Thu, 19 Sep 2013 13:56:53 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mike Dunn <mikedunn@newsguy.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] pwm-backlight: allow for non-increasing brightness levels
Message-ID: <20130919115650.GE10852@ulmo>
References: <1379010952-8928-1-git-send-email-mikedunn@newsguy.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n+lFg1Zro7sl44OB"
Content-Disposition: inline
In-Reply-To: <1379010952-8928-1-git-send-email-mikedunn@newsguy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n+lFg1Zro7sl44OB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 12, 2013 at 11:35:52AM -0700, Mike Dunn wrote:
> Currently the driver assumes that the values specified in the brightness-=
levels
> device tree property increase as they are parsed from left to right.  But=
 boards
> that invert the signal between the PWM output and the backlight will need=
 to
> specify decreasing brightness-levels.  This patch removes the assumption =
that
> the last element of the array is the max value, and instead searches the =
array
> for the max value and uses that as the normalizing value when determining=
 the
> duty cycle.

"maximum value", "... and uses that as the scale to normalize the duty
cycle"?

Also please wrap commit messages at 72 characters.

> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/p=
wm_bl.c
> index 1fea627..d66aaa0 100644
> --- a/drivers/video/backlight/pwm_bl.c
> +++ b/drivers/video/backlight/pwm_bl.c
> @@ -27,6 +27,7 @@ struct pwm_bl_data {
>  	unsigned int		period;
>  	unsigned int		lth_brightness;
>  	unsigned int		*levels;
> +	unsigned int		max_level;

Perhaps call this "scale"? Otherwise there some potential to mix it up
with max_brightness.

> @@ -195,7 +196,15 @@ static int pwm_backlight_probe(struct platform_devic=
e *pdev)
>  	}
> =20
>  	if (data->levels) {
> -		max =3D data->levels[data->max_brightness];
> +		int i, max_value =3D 0, max_idx =3D 0;

i should be unsigned int to match the type of data->max_brightness.

> +		for (i =3D 0; i <=3D data->max_brightness; i++) {

There should be a blank line above this one to increase readability.

> +			if (data->levels[i] > max_value) {
> +				max_value =3D data->levels[i];
> +				max_idx =3D i;
> +			}
> +		}
> +		pb->max_level =3D max_idx;

Some here.

Also I suggest to just drop the max_ prefix from the local variables.
Perhaps also simplify all of it to something like:

	for (i =3D 0; i <=3D data->max_brightness; i++)
		if (data->levels[i] > pb->scale)
			pb->scale =3D data->levels[i];

And get rid of the index altogether. That way you can use pb->scale
directly during the computation of the duty cycle and don't have to
index the levels array over and over again.

Thierry

--n+lFg1Zro7sl44OB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOuaCAAoJEN0jrNd/PrOhOt8P/1ofpU8xaJEs8Z21FXkpbEWV
lQREn9ElS3UdCSg4/jV4H3cLmNWvLBdsi9dWphHe7uSXPbsEqmxB72TXp/dXQRh2
CNAaoMvDS1Duy9/GWy01TwsmihEPjpv+fOf+xIrOo13w69yqqVdo/er9JzmlOLLs
RuBpCWK56SycCVggGLWUWqupXZ+HXuv7UJ/oU2Vy8gU1PnNpPea2PmkXtt3+tDpj
frkmjdP9jUHT22uyQPW4/yYTagp8w0TGegVhrNesOSFc9qTGIwrsx4p0/zEB69DP
eAUPRwdtL1DF7iIGhY+pwUgZXQAmZsyTwbVOooSk8OYuFeOm8Bwhd09wfa5NKo4N
7SGQuH+IMmOGBLLbitlQIkLEghnPVRFhctVixBGy1r4qEafAd2O1wvGjJ0lRRU64
AJxLM1qcx19s2xI9Sqo5RMDhaN/mDqiekKx2YihmTA2buFuw9bI5mCmt4m4IVe7Y
auUTKpF7+yZjQ781kAN16tbUsLffYadkxx5WpRA9vuRdh2IdUW6yPPwlEpj2+ERP
gzNO78iLv3QTNvhDwgl2pjwIxCx4X/eBZl1OrJegHCsGfpFppXMSnVz9CxpqiYib
nbAhXpaFTswUIXpjLX8TGREWw0mvbTQcsbmvnm6BtDpRpJhPNaVzR5oAEULaZs12
/a27mzf13OOBi/shHjJd
=XEmC
-----END PGP SIGNATURE-----

--n+lFg1Zro7sl44OB--
