Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaDYPSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:18:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57194 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbaDYPS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:18:29 -0400
Date: Fri, 25 Apr 2014 10:18:11 -0500
From: Felipe Balbi <balbi@ti.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <myungjoo.ham@samsung.com>, <balbi@ti.com>,
        <gg@slimlogic.co.uk>, <kishon@ti.com>,
        <ckeepax@opensource.wolfsonmicro.com>, <broonie@kernel.org>,
        <k.kozlowski@samsung.com>, <kyungmin.park@samsung.com>
Subject: Re: [PATCHv4 8/9] extcon: gpio: Use devm_extcon_dev_allocate for
 extcon_dev
Message-ID: <20140425151811.GL29632@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398386544-16295-1-git-send-email-cw00.choi@samsung.com>
 <1398386544-16295-9-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eMP3JyRexyk9c0Bv"
Content-Disposition: inline
In-Reply-To: <1398386544-16295-9-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--eMP3JyRexyk9c0Bv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 25, 2014 at 09:42:23AM +0900, Chanwoo Choi wrote:
> This patch use devm_extcon_dev_allocate() to simplify the memory control
> of extcon device.
>=20
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/extcon/extcon-gpio.c | 23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
> index 43af34c..645b283 100644
> --- a/drivers/extcon/extcon-gpio.c
> +++ b/drivers/extcon/extcon-gpio.c
> @@ -32,7 +32,7 @@
>  #include <linux/extcon/extcon-gpio.h>
> =20
>  struct gpio_extcon_data {
> -	struct extcon_dev edev;
> +	struct extcon_dev *edev;
>  	unsigned gpio;
>  	bool gpio_active_low;
>  	const char *state_on;
> @@ -53,7 +53,7 @@ static void gpio_extcon_work(struct work_struct *work)
>  	state =3D gpio_get_value(data->gpio);
>  	if (data->gpio_active_low)
>  		state =3D !state;
> -	extcon_set_state(&data->edev, state);
> +	extcon_set_state(data->edev, state);
>  }
> =20
>  static irqreturn_t gpio_irq_handler(int irq, void *dev_id)
> @@ -67,9 +67,10 @@ static irqreturn_t gpio_irq_handler(int irq, void *dev=
_id)
> =20
>  static ssize_t extcon_gpio_print_state(struct extcon_dev *edev, char *bu=
f)
>  {
> -	struct gpio_extcon_data	*extcon_data =3D
> -		container_of(edev, struct gpio_extcon_data, edev);
> +	struct device *dev =3D edev->dev.parent;
> +	struct gpio_extcon_data *extcon_data =3D dev_get_drvdata(dev);
>  	const char *state;
> +
>  	if (extcon_get_state(edev))
>  		state =3D extcon_data->state_on;
>  	else
> @@ -98,15 +99,21 @@ static int gpio_extcon_probe(struct platform_device *=
pdev)
>  	if (!extcon_data)
>  		return -ENOMEM;
> =20
> -	extcon_data->edev.name =3D pdata->name;
> -	extcon_data->edev.dev.parent =3D &pdev->dev;
> +	extcon_data->edev =3D devm_extcon_dev_allocate(&pdev->dev, NULL);
> +	if (IS_ERR(extcon_data->edev)) {
> +		dev_err(&pdev->dev, "failed to allocate extcon device\n");
> +		return -ENOMEM;
> +	}
> +	extcon_data->edev->name =3D pdata->name;
> +	extcon_data->edev->dev.parent =3D &pdev->dev;
> +
>  	extcon_data->gpio =3D pdata->gpio;
>  	extcon_data->gpio_active_low =3D pdata->gpio_active_low;
>  	extcon_data->state_on =3D pdata->state_on;
>  	extcon_data->state_off =3D pdata->state_off;
>  	extcon_data->check_on_resume =3D pdata->check_on_resume;
>  	if (pdata->state_on && pdata->state_off)
> -		extcon_data->edev.print_state =3D extcon_gpio_print_state;
> +		extcon_data->edev->print_state =3D extcon_gpio_print_state;
> =20
>  	ret =3D devm_gpio_request_one(&pdev->dev, extcon_data->gpio, GPIOF_DIR_=
IN,
>  				    pdev->name);
> @@ -121,7 +128,7 @@ static int gpio_extcon_probe(struct platform_device *=
pdev)
>  				msecs_to_jiffies(pdata->debounce);
>  	}
> =20
> -	ret =3D devm_extcon_dev_register(&pdev->dev, &extcon_data->edev);
> +	ret =3D devm_extcon_dev_register(&pdev->dev, extcon_data->edev);
>  	if (ret < 0)
>  		return ret;
> =20
> --=20
> 1.8.0
>=20

--=20
balbi

--eMP3JyRexyk9c0Bv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWnyzAAoJEIaOsuA1yqREvBwQALAngMq8eL/+54/0yhtZKEbC
FLfFFNM6iRCRxGkmK5/Rpwk7ffZ/tww3DSUguXheegVpL76SumWj91FDqpbjPRR9
PvbYsUhB99C/TWWRK0GyRrgtQpdCPBykas4kVvZWlOWPQ2yCaW87T++a3MOQT9MK
8lFEW4mAIzBKFKfiNepMO9xLhFm4enp+UXmWLpplVv5e0m/4wBBQsN8zn73H5HXp
BcJ1QpR5/Be2JYjx0/8NvLHT9vw8pQalT7OVkR8j8lcXjYTKkKNc0rKQM/K9W8iI
/D18Uvzv6BZb7iQJ7VuuZpWS4gZNSO9y7paVSOHly5N8NgbGYGfT1YTq6clZ5bek
kE+PE9dGv0O7tlCM0+ju5jV2Kn7N3ER5Z5ZjS3OEt91kCDDVcMKx/iy4UMmCpdwf
UpBLP58YjAbCnvQlpC4c9hat4uozgOd0EkJaHN3trgBQ6j77xzIUak6niPEk1TgK
R1ImWaijOzo1aYxhFfvqJH/EfhLZv61UTvcyM6Hx02mgFhaRMpEoQ8kncWIZLFEb
x4Qo2CppCmwzNY+IimJcFHYRozihXLo+XWpZE0cOLFus/F3cu4e69WcmLfdqYCJw
JkNl85VpTmCUR1znvkyFKv8t4N1bNlReJacWlYPNaTSv62gvzYmHacTv7rAh3GOp
kZRRj4rRodwTyJx8as0S
=2XqL
-----END PGP SIGNATURE-----

--eMP3JyRexyk9c0Bv--
