Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257AbaEWHWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 03:22:08 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:34489 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaEWHWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 03:22:05 -0400
Date: Fri, 23 May 2014 09:19:41 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Bryan Wu <cooloney@gmail.com>
Subject: Re: linux-next: manual merge of the pwm tree with the leds tree
Message-ID: <20140523071940.GC6310@ulmo>
References: <20140522192423.1d9899dd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TiqCXmo5T1hvSQQg"
Content-Disposition: inline
In-Reply-To: <20140522192423.1d9899dd@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TiqCXmo5T1hvSQQg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2014 at 07:24:23PM +1000, Stephen Rothwell wrote:
> Hi Thierry,
>=20
> Today's linux-next merge of the pwm tree got a conflict in
> drivers/leds/leds-pwm.c between commit 5f7b03dc2ab5 ("leds: leds-pwm:
> provide a common function to setup a single led-pwm device") from the
> leds tree and commit 81225bed3273 ("leds: leds-pwm: retrieve configured
> PWM period") from the pwm tree.
>=20
> I fixed it up (I think - see below) and can carry the fix as necessary
> (no action is required).

The resolution below looks good to me. Thanks!

Alexandre, Bryan, as far as I can tell there are no dependencies between
this patch and the rest of the series that Alexandre sent, so perhaps it
would be a better idea to take this particular patch via Bryan's leds
tree?

Then again the resolution looks like something that Linus can reasonably
handle, so maybe things are fine as-is.

Thierry

>=20
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>=20
> diff --cc drivers/leds/leds-pwm.c
> index f5cf1b0f2748,aa770ec1e892..000000000000
> --- a/drivers/leds/leds-pwm.c
> +++ b/drivers/leds/leds-pwm.c
> @@@ -96,75 -92,55 +96,75 @@@ static void led_pwm_cleanup(struct led_
>   	}
>   }
>  =20
>  -static int led_pwm_create_of(struct platform_device *pdev,
>  -			     struct led_pwm_priv *priv)
>  +static int led_pwm_add(struct device *dev, struct led_pwm_priv *priv,
>  +		       struct led_pwm *led, struct device_node *child)
>   {
>  -	struct device_node *child;
>  +	struct led_pwm_data *led_data =3D &priv->leds[priv->num_leds];
>   	int ret;
>  =20
>  -	for_each_child_of_node(pdev->dev.of_node, child) {
>  -		struct led_pwm_data *led_dat =3D &priv->leds[priv->num_leds];
>  +	led_data->active_low =3D led->active_low;
> - 	led_data->period =3D led->pwm_period_ns;
>  +	led_data->cdev.name =3D led->name;
>  +	led_data->cdev.default_trigger =3D led->default_trigger;
>  +	led_data->cdev.brightness_set =3D led_pwm_set;
>  +	led_data->cdev.brightness =3D LED_OFF;
>  +	led_data->cdev.max_brightness =3D led->max_brightness;
>  +	led_data->cdev.flags =3D LED_CORE_SUSPENDRESUME;
>  =20
>  -		led_dat->cdev.name =3D of_get_property(child, "label",
>  -						     NULL) ? : child->name;
>  +	if (child)
>  +		led_data->pwm =3D devm_of_pwm_get(dev, child, NULL);
>  +	else
>  +		led_data->pwm =3D devm_pwm_get(dev, led->name);
>  +	if (IS_ERR(led_data->pwm)) {
>  +		ret =3D PTR_ERR(led_data->pwm);
>  +		dev_err(dev, "unable to request PWM for %s: %d\n",
>  +			led->name, ret);
>  +		return ret;
>  +	}
>  =20
> - 	if (child)
> - 		led_data->period =3D pwm_get_period(led_data->pwm);
>  -		led_dat->pwm =3D devm_of_pwm_get(&pdev->dev, child, NULL);
>  -		if (IS_ERR(led_dat->pwm)) {
>  -			dev_err(&pdev->dev, "unable to request PWM for %s\n",
>  -				led_dat->cdev.name);
>  -			ret =3D PTR_ERR(led_dat->pwm);
>  -			goto err;
>  -		}
>  -		/* Get the period from PWM core when n*/
>  -		led_dat->period =3D pwm_get_period(led_dat->pwm);
> ++	led_data->period =3D pwm_get_period(led_data->pwm);
> ++	if (!led_data->period && (led->pwm_period_ns > 0))
> ++		led_data->period =3D led->pwm_period_ns;
>  =20
>  -		led_dat->cdev.default_trigger =3D of_get_property(child,
>  -						"linux,default-trigger", NULL);
>  -		of_property_read_u32(child, "max-brightness",
>  -				     &led_dat->cdev.max_brightness);
>  +	led_data->can_sleep =3D pwm_can_sleep(led_data->pwm);
>  +	if (led_data->can_sleep)
>  +		INIT_WORK(&led_data->work, led_pwm_work);
>  +
>  +	ret =3D led_classdev_register(dev, &led_data->cdev);
>  +	if (ret =3D=3D 0) {
>  +		priv->num_leds++;
>  +	} else {
>  +		dev_err(dev, "failed to register PWM led for %s: %d\n",
>  +			led->name, ret);
>  +	}
>  +
>  +	return ret;
>  +}
>  +
>  +static int led_pwm_create_of(struct device *dev, struct led_pwm_priv *p=
riv)
>  +{
>  +	struct device_node *child;
>  +	struct led_pwm led;
>  +	int ret =3D 0;
>  +
>  +	memset(&led, 0, sizeof(led));
>  =20
>  -		led_dat->cdev.brightness_set =3D led_pwm_set;
>  -		led_dat->cdev.brightness =3D LED_OFF;
>  -		led_dat->cdev.flags |=3D LED_CORE_SUSPENDRESUME;
>  +	for_each_child_of_node(dev->of_node, child) {
>  +		led.name =3D of_get_property(child, "label", NULL) ? :
>  +			   child->name;
>  =20
>  -		led_dat->can_sleep =3D pwm_can_sleep(led_dat->pwm);
>  -		if (led_dat->can_sleep)
>  -			INIT_WORK(&led_dat->work, led_pwm_work);
>  +		led.default_trigger =3D of_get_property(child,
>  +						"linux,default-trigger", NULL);
>  +		led.active_low =3D of_property_read_bool(child, "active-low");
>  +		of_property_read_u32(child, "max-brightness",
>  +				     &led.max_brightness);
>  =20
>  -		ret =3D led_classdev_register(&pdev->dev, &led_dat->cdev);
>  -		if (ret < 0) {
>  -			dev_err(&pdev->dev, "failed to register for %s\n",
>  -				led_dat->cdev.name);
>  +		ret =3D led_pwm_add(dev, priv, &led, child);
>  +		if (ret) {
>   			of_node_put(child);
>  -			goto err;
>  +			break;
>   		}
>  -		priv->num_leds++;
>   	}
>  =20
>  -	return 0;
>  -err:
>  -	led_pwm_cleanup(priv);
>  -
>   	return ret;
>   }
>  =20



--TiqCXmo5T1hvSQQg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTfvaMAAoJEN0jrNd/PrOhFGYQAJhp1cfDuEWe5jPeEGr7ZJkZ
J+Z9Dtf3j6auxRi9Ez/thK9pNThQH+AQLbKzOCB6C5LH+dGVw/2qeZZDAtV12qxV
Hxbq4AOXT7fLR7+b+T3+ybTIls/m4MRiKaGtyhM/IfczxUI+gG111CFkjgZxC7ev
qZYD72RlnN8AJWk8hdSlyqrDIiqOuwEda2BQaxlzk3teQwmkwVkXjizY+dnqI4PE
oLrd0HxvsKKgzBFCWUwdcspBfoUO4fVcActLBCLneqZ2FT5jHe5F3fUVwal6gQ12
LEp1nHmvoHUAMLSWQuKA3pAulB8iN6VY4qf7g3yNSVlkwad/o/eV67cZPPdKn3As
5r4bMx9fZ729GuF0jJW+Xu0fKCpdEf+pJ+BPbF6m2DJ8uauiobUOkPadIr2lpSWG
3xn3qDWHCynhkm1mr1jfL2r4xtr2IfdSgnVUFla+8aaZp2ZLdT8g729PYt9oA5nz
EcTKqfN5zVaWtlEQ5z/ReCfObPKQj7gv/XtIuL8OhNRwp7UNkHdhaUXb3+1PXHrB
VxkTN2p8bY0e3h1MQ74sWb6yLnMbUs5FWzZJ9Ptp3ZOjDj2pq1QPGQ74WK5qezVK
uKvlC4Vwx4YOvPkkHfCsrdCYKWtBwRDso5Hg3UcRDFBYtMvNm0OiG9ebV70GtsI7
lGkZgrhb6IhHA19GLPai
=4poP
-----END PGP SIGNATURE-----

--TiqCXmo5T1hvSQQg--
