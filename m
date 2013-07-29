Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab3G2SEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:04:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57820 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929Ab3G2SEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:04:51 -0400
Date: Mon, 29 Jul 2013 21:04:41 +0300
From: Felipe Balbi <balbi@ti.com>
To: Illia Smyrnov <illia.smyrnov@ti.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v3 1/3] Input: omap-keypad: Enable wakeup capability for
 keypad.
Message-ID: <20130729180441.GF4964@radagast>
Reply-To: <balbi@ti.com>
References: <1375116311-13999-1-git-send-email-illia.smyrnov@ti.com>
 <1375116311-13999-2-git-send-email-illia.smyrnov@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DNUSDXU7R7AVVM8C"
Content-Disposition: inline
In-Reply-To: <1375116311-13999-2-git-send-email-illia.smyrnov@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DNUSDXU7R7AVVM8C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 29, 2013 at 07:45:09PM +0300, Illia Smyrnov wrote:
> Enable/disable IRQ wake in suspend/resume handlers
> to make the keypad wakeup capable.
>=20
> Signed-off-by: Illia Smyrnov <illia.smyrnov@ti.com>
> ---
>  drivers/input/keyboard/omap4-keypad.c |   43 +++++++++++++++++++++++++++=
++++++
>  1 file changed, 43 insertions(+)
>=20
> diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboa=
rd/omap4-keypad.c
> index 0244262..feab00f 100644
> --- a/drivers/input/keyboard/omap4-keypad.c
> +++ b/drivers/input/keyboard/omap4-keypad.c
> @@ -74,6 +74,7 @@ struct omap4_keypad {
>  	struct input_dev *input;
> =20
>  	void __iomem *base;
> +	bool irq_wake_enabled;

this flag is a bit weird... but I can't find a better way to handle this
situation. In one way, you shouldn't prevent system suspend, so you can
error out in case enable_irq_wake() fails, otoh if enable_irq_wake()
fails and you return 0, on resume disable_irq_wake() will throw
unbalanced calls warning. Maybe someone else has a better idea.

> @@ -439,12 +444,50 @@ static const struct of_device_id omap_keypad_dt_mat=
ch[] =3D {
>  MODULE_DEVICE_TABLE(of, omap_keypad_dt_match);
>  #endif
> =20
> +#ifdef CONFIG_PM_SLEEP
> +static int omap4_keypad_suspend(struct device *dev)
> +{
> +	struct platform_device *pdev =3D to_platform_device(dev);

you don't need to access the platform_device...

> +	struct omap4_keypad *keypad_data =3D platform_get_drvdata(pdev);

=2E.. since this can become:

	struct omap4_keypad *keypad_data =3D dev_get_drvdata(dev);

> +	int error;
> +
> +	if (device_may_wakeup(&pdev->dev)) {
> +		error =3D enable_irq_wake(keypad_data->irq);
> +		if (!error)
> +			keypad_data->irq_wake_enabled =3D true;
> +	}
> +
> +	return 0;
> +}
> +
> +static int omap4_keypad_resume(struct device *dev)
> +{
> +	struct platform_device *pdev =3D to_platform_device(dev);
> +	struct omap4_keypad *keypad_data =3D platform_get_drvdata(pdev);

ditto, use dev_get_drvdata() instead.

--=20
balbi

--DNUSDXU7R7AVVM8C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR9q65AAoJEIaOsuA1yqREeHsQAItblV3kfd1BZpuKxbk6AJgP
+kOEAXOjbAArm1HnXemOt2v+fo8IcrlTCuHfWpSVTAgChJkD3YwewNyeY5/FwscD
lruGSyWOqp9DevdtLBf30SPQiHq/rMO87V8JJwL57ge7/L5m/5KFhK+jXNvFhJji
5mdadiSMSADoJxFv/TwhZDdNLD5P5cbxT9JFxaNVA55OA/VAzF0C9Ec4UcZ6VeHr
JRitvuCKKBoBNwrrnLZNM/zRhafBz2B7jpd/CS1RiQnFhbsUjDdfs4qXEsoEStXe
Qs5XAX8AfjnM6VDZQ7uyiThCA814y4IXHOy59DmA35BMiTBIoYjnaYTvZ9zWHWhq
5+vzlxsL81iIV8aqtZJLrJXQwyx8ZLgKb1ZvLTAHrwdfbcgqicNo6pyF1WFJ+Key
0U8RjbvH1HcdmXkufP2/eakPVihK/dmDF3taVT97a1oTFtpJnzcIrasQESYiafwb
aU6wsG25WSZAeCWDogUxxz3yNPRfte+f1xNMCXsz8KuPvOxsr5x+A7AQH7PrfylL
4NLU6wbTC3VecpDSkny0A+klf8nXO7yE8s28fMWmQ5wjOszSG0uGpxF7IVlUptZr
sGVvXo5ni1C/hi3Rs+hc1aUS1idpdnqwiNi9VpELelRQl2X6rZZ3sUIthHpzaDBp
HciCukc3ilh7EZY/nDTg
=F9E5
-----END PGP SIGNATURE-----

--DNUSDXU7R7AVVM8C--
