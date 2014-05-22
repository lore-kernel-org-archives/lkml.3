Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbaEVJYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:24:38 -0400
Received: from ozlabs.org ([103.22.144.67]:55849 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260AbaEVJYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:24:34 -0400
Date: Thu, 22 May 2014 19:24:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Bryan Wu <cooloney@gmail.com>
Subject: linux-next: manual merge of the pwm tree with the leds tree
Message-ID: <20140522192423.1d9899dd@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_//l8BYbU/oPfwDxupm8HRbf1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//l8BYbU/oPfwDxupm8HRbf1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Thierry,

Today's linux-next merge of the pwm tree got a conflict in
drivers/leds/leds-pwm.c between commit 5f7b03dc2ab5 ("leds: leds-pwm:
provide a common function to setup a single led-pwm device") from the
leds tree and commit 81225bed3273 ("leds: leds-pwm: retrieve configured
PWM period") from the pwm tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/leds/leds-pwm.c
index f5cf1b0f2748,aa770ec1e892..000000000000
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@@ -96,75 -92,55 +96,75 @@@ static void led_pwm_cleanup(struct led_
  	}
  }
 =20
 -static int led_pwm_create_of(struct platform_device *pdev,
 -			     struct led_pwm_priv *priv)
 +static int led_pwm_add(struct device *dev, struct led_pwm_priv *priv,
 +		       struct led_pwm *led, struct device_node *child)
  {
 -	struct device_node *child;
 +	struct led_pwm_data *led_data =3D &priv->leds[priv->num_leds];
  	int ret;
 =20
 -	for_each_child_of_node(pdev->dev.of_node, child) {
 -		struct led_pwm_data *led_dat =3D &priv->leds[priv->num_leds];
 +	led_data->active_low =3D led->active_low;
- 	led_data->period =3D led->pwm_period_ns;
 +	led_data->cdev.name =3D led->name;
 +	led_data->cdev.default_trigger =3D led->default_trigger;
 +	led_data->cdev.brightness_set =3D led_pwm_set;
 +	led_data->cdev.brightness =3D LED_OFF;
 +	led_data->cdev.max_brightness =3D led->max_brightness;
 +	led_data->cdev.flags =3D LED_CORE_SUSPENDRESUME;
 =20
 -		led_dat->cdev.name =3D of_get_property(child, "label",
 -						     NULL) ? : child->name;
 +	if (child)
 +		led_data->pwm =3D devm_of_pwm_get(dev, child, NULL);
 +	else
 +		led_data->pwm =3D devm_pwm_get(dev, led->name);
 +	if (IS_ERR(led_data->pwm)) {
 +		ret =3D PTR_ERR(led_data->pwm);
 +		dev_err(dev, "unable to request PWM for %s: %d\n",
 +			led->name, ret);
 +		return ret;
 +	}
 =20
- 	if (child)
- 		led_data->period =3D pwm_get_period(led_data->pwm);
 -		led_dat->pwm =3D devm_of_pwm_get(&pdev->dev, child, NULL);
 -		if (IS_ERR(led_dat->pwm)) {
 -			dev_err(&pdev->dev, "unable to request PWM for %s\n",
 -				led_dat->cdev.name);
 -			ret =3D PTR_ERR(led_dat->pwm);
 -			goto err;
 -		}
 -		/* Get the period from PWM core when n*/
 -		led_dat->period =3D pwm_get_period(led_dat->pwm);
++	led_data->period =3D pwm_get_period(led_data->pwm);
++	if (!led_data->period && (led->pwm_period_ns > 0))
++		led_data->period =3D led->pwm_period_ns;
 =20
 -		led_dat->cdev.default_trigger =3D of_get_property(child,
 -						"linux,default-trigger", NULL);
 -		of_property_read_u32(child, "max-brightness",
 -				     &led_dat->cdev.max_brightness);
 +	led_data->can_sleep =3D pwm_can_sleep(led_data->pwm);
 +	if (led_data->can_sleep)
 +		INIT_WORK(&led_data->work, led_pwm_work);
 +
 +	ret =3D led_classdev_register(dev, &led_data->cdev);
 +	if (ret =3D=3D 0) {
 +		priv->num_leds++;
 +	} else {
 +		dev_err(dev, "failed to register PWM led for %s: %d\n",
 +			led->name, ret);
 +	}
 +
 +	return ret;
 +}
 +
 +static int led_pwm_create_of(struct device *dev, struct led_pwm_priv *pri=
v)
 +{
 +	struct device_node *child;
 +	struct led_pwm led;
 +	int ret =3D 0;
 +
 +	memset(&led, 0, sizeof(led));
 =20
 -		led_dat->cdev.brightness_set =3D led_pwm_set;
 -		led_dat->cdev.brightness =3D LED_OFF;
 -		led_dat->cdev.flags |=3D LED_CORE_SUSPENDRESUME;
 +	for_each_child_of_node(dev->of_node, child) {
 +		led.name =3D of_get_property(child, "label", NULL) ? :
 +			   child->name;
 =20
 -		led_dat->can_sleep =3D pwm_can_sleep(led_dat->pwm);
 -		if (led_dat->can_sleep)
 -			INIT_WORK(&led_dat->work, led_pwm_work);
 +		led.default_trigger =3D of_get_property(child,
 +						"linux,default-trigger", NULL);
 +		led.active_low =3D of_property_read_bool(child, "active-low");
 +		of_property_read_u32(child, "max-brightness",
 +				     &led.max_brightness);
 =20
 -		ret =3D led_classdev_register(&pdev->dev, &led_dat->cdev);
 -		if (ret < 0) {
 -			dev_err(&pdev->dev, "failed to register for %s\n",
 -				led_dat->cdev.name);
 +		ret =3D led_pwm_add(dev, priv, &led, child);
 +		if (ret) {
  			of_node_put(child);
 -			goto err;
 +			break;
  		}
 -		priv->num_leds++;
  	}
 =20
 -	return 0;
 -err:
 -	led_pwm_cleanup(priv);
 -
  	return ret;
  }
 =20

--Sig_//l8BYbU/oPfwDxupm8HRbf1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTfcJNAAoJEMDTa8Ir7ZwVuY4P/jhZK/hwEYvjd4+v0tjhDqJm
9a3Mxr51sJCWJd6/Ic7nWSJMXTyP2XOKAP6WYqYWbE2OF1gTMr5C4GaS0w/FlRlq
q6kr1TneM6cIjRqTEFEiTGeSTJ8tkom3wW7ZScJCvKvyTBRMUxaeEZVS1lbUqNde
PZq6wdYylocTT6hpmkc3yyXhojC0W9uGaQJep4amaaF2kZQerwZ7aOtbiOTHPK2E
0e848LlwFI8zEo2KOGWdX04yUkiq3V8PncklGlo7vOg8b+FDruAboUkgPOinRqVC
Xu4hr+J/9qBtclubGW82PB9+WzDhID/kF1mHiQT3JJbs0/xuTOkrAqEo0wuMeTY/
2m/Fyh+CdHTcmjvkIR9pRxWCFpLlVfZCBX2dfIuLT/0Ne1sDm2wfzjQTqe6Wje+j
7Pg1jWDt6xq3xGXdqHABZfIakZQVX+1JcfLlg1pN24TpgkAGvEgAl/1sjx9Cxsw/
HzEApffGiGoqjvMSoDrmu6m9Gmw+yofI4pcJn1+enuYfZEe+WUO/pM/b2Sij/atY
r1KjEPSjbE1BxClSuk0iDYbVtZMrhht0guN8rWRlJfFrg74WwvTv3JLlguhlO4LD
UdynvwVSkNGU/0O/smVsqlrbuFOP3XwJ/2QHfA2zAWuPNNbeXqDHxhIMSAcxAF7H
adQkkIa78cBf/T5O70ti
=jEyP
-----END PGP SIGNATURE-----

--Sig_//l8BYbU/oPfwDxupm8HRbf1--
