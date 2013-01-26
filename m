Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751086Ab3AZFkh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 00:40:37 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56487 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab3AZFkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 00:40:36 -0500
Date: Sat, 26 Jan 2013 06:40:24 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] pwm: Add pwm_cansleep() as exported API to users
Message-ID: <20130126054024.GB29243@avionic-0098.adnet.avionic-design.de>
References: <1359121471-21457-1-git-send-email-florian.vaussard@epfl.ch>
 <1359121471-21457-2-git-send-email-florian.vaussard@epfl.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jq0ap7NbKX2Kqbes"
Content-Disposition: inline
In-Reply-To: <1359121471-21457-2-git-send-email-florian.vaussard@epfl.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:7rwqJtoK11o1HQ5sdiqYN2lDvA2Y7gNZ7CcLMlv02JB
 7RaE5SHGeB9onqMUkP0wDvEaU4k2Jmq9cNEeUVj/JzusapsKtk
 tqS1ZxpPiLVrE1ufzG3WuHJfOVJkfDLjQMTG0A8QzqsFKWxvVu
 xbzQTeQmPMfN2KeLKXZI+oz34dCYlrFhk4yk9jGgFGFxUQdwwn
 G9LFUNSkANif+woZpXCL55JQ20VauiQm/8Ooa+HGZVTeIzLXR3
 0dxKbxr05YNjRzXQd14Pwy+vGiT6wWHz8Zq93etadEK79BxlJT
 3BO94G4MYvLM0YRScSlsIrwKJnzTPzC0mBoyi0ooW1VpLp/NZN
 /yP8mUrG/0jCtXMo1M5pTxLCEKDZrhgLxbzBmd/FPb5kTgH4aU
 8vD3V/OF83odkRo91LpFzO+Ame7Qg9yrmKBttqN7uPxg8YDkeX
 FaNdv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jq0ap7NbKX2Kqbes
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 25, 2013 at 02:44:29PM +0100, Florian Vaussard wrote:
> Calls to some external PWM chips can sleep. To help users,
> add pwm_cansleep() API.
>=20
> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
> ---
>  drivers/pwm/core.c  |   12 ++++++++++++
>  include/linux/pwm.h |   10 ++++++++++
>  2 files changed, 22 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
> index 4a13da4..e737f5f 100644
> --- a/drivers/pwm/core.c
> +++ b/drivers/pwm/core.c
> @@ -763,6 +763,18 @@ void devm_pwm_put(struct device *dev, struct pwm_dev=
ice *pwm)
>  }
>  EXPORT_SYMBOL_GPL(devm_pwm_put);
> =20
> +/**
> +  * pwm_cansleep() - report whether pwm access will sleep

"... whether PWM access..." please.

> +  * @pwm: PWM device
> +  *
> +  * It returns nonzero if accessing the PWM can sleep.
> +  */
> +int pwm_cansleep(struct pwm_device *pwm)

I actually liked pwm_can_sleep() better. I find it to be more consistent
with the naming of other function names. It would furthermore match the
field name.

> +{
> +	return pwm->chip->can_sleep;
> +}
> +EXPORT_SYMBOL_GPL(pwm_cansleep);

Would it make sense to check for NULL pointers here? I guess that
passing NULL into the function could be considered a programming error
and an oops would be okay, but in that case there's no point in making
the function return an int. Also see my next comment.

> +
>  #ifdef CONFIG_DEBUG_FS
>  static void pwm_dbg_show(struct pwm_chip *chip, struct seq_file *s)
>  {
> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
> index 70655a2..e2cb5c7 100644
> --- a/include/linux/pwm.h
> +++ b/include/linux/pwm.h
> @@ -146,6 +146,8 @@ struct pwm_ops {
>   * @base: number of first PWM controlled by this chip
>   * @npwm: number of PWMs controlled by this chip
>   * @pwms: array of PWM devices allocated by the framework
> + * @can_sleep: flag must be set iff config()/enable()/disable() methods =
sleep,
> + *      as they must while accessing PWM chips over I2C or SPI
>   */
>  struct pwm_chip {
>  	struct device		*dev;
> @@ -159,6 +161,7 @@ struct pwm_chip {
>  	struct pwm_device *	(*of_xlate)(struct pwm_chip *pc,
>  					    const struct of_phandle_args *args);
>  	unsigned int		of_pwm_n_cells;
> +	unsigned int		can_sleep:1;

What's the reason for making this a bitfield? Couldn't we just use a
bool instead?

Thierry

--jq0ap7NbKX2Kqbes
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRA2xIAAoJEN0jrNd/PrOh6YoP/2puxWApmEkemmh3rRsdxT5Y
BSp6L6Y34y+mkTzVYsfR9HeUrpu9GjBAnYHXL08S7a9sY6/+HnQohOK5k7gO/NGy
ep23iexpAhTr7PsQh/CxBRDHgUg45+39mbFkLiWWXVQsuI9bz8rnwqQoFI5waFa6
joLLGRdlvj9v0WT5R5kq7E/FF/7NbRMM8oaOUgRm2LAaSoq8aj66E9M6bNwP4lCd
hVKNADdF48Uh5WhjqpCzTlI+0eIccGGHv0GbbX21G8/5yLRWLcvMIdfJV1ceOdck
YUjTxPRBBwkuLhHGBrWuFIZhFATHkyGzcAs1IX0zFI3y537uiccuFNBNeqhLfKXM
I2yumIwISRma1Zh3QufoUWNrMHicbyOtw/pcIzCQjTbkM45aBKj4Ul4kR+W7Zwpk
seZbUs5lxsJ9fRiWfsCmrZFpmA+yKZEvEh1/BmoJ0iq/sEnHlNptOOfsRnkhwozC
B3tnBhBYbx0oqNKncyylwiK0lrGfB4Xh6X3wb2AjicIlzCA/OBl0G1WpJZCTLCYQ
1D+d4R8tLYhS/3tcSi0C87YbRLyYO/FE7bXH/40Wzc4Eav+Mu6OG1WA6wPcYOu0j
d2io1WRhU7qMIS8ZTgNAnBIhbCejyT5ow3wdQERVcy8KjRl4/Wfn5AUgqjxKK6xA
K6YHPKOSy9J9197+hdOX
=eIln
-----END PGP SIGNATURE-----

--jq0ap7NbKX2Kqbes--
