Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbaKCR6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:58:36 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:47433 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbaKCR6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:58:32 -0500
Date: Mon, 3 Nov 2014 11:57:09 -0600
From: Felipe Balbi <balbi@ti.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 16/47] mfd: tps6586x: Register with kernel power-off
 handler
Message-ID: <20141103175709.GQ27425@saruman>
Reply-To: <balbi@ti.com>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
 <1414425354-10359-17-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3wfpuDtTLg8/Vq6g"
Content-Disposition: inline
In-Reply-To: <1414425354-10359-17-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3wfpuDtTLg8/Vq6g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2014 at 08:55:23AM -0700, Guenter Roeck wrote:
> Register with kernel power-off handler instead of setting pm_power_off
> directly. Register with low priority to reflect that the original code
> only sets pm_power_off if it was not already set.
>=20
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

should be sent to linux-omap and lakml too

> ---
> v3:
> - Replace poweroff in all newly introduced variables and in text
>   with power_off or power-off as appropriate
> - Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
> v2:
> - Use define to specify poweroff handler priority
> - Use dev_warn instead of dev_err
>=20
>  drivers/mfd/tps6586x.c | 31 +++++++++++++++++++++++--------
>  1 file changed, 23 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
> index 8e1dbc4..1e97478 100644
> --- a/drivers/mfd/tps6586x.c
> +++ b/drivers/mfd/tps6586x.c
> @@ -21,10 +21,12 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
> +#include <linux/notifier.h>
>  #include <linux/slab.h>
>  #include <linux/err.h>
>  #include <linux/i2c.h>
>  #include <linux/platform_device.h>
> +#include <linux/pm.h>
>  #include <linux/regmap.h>
>  #include <linux/of.h>
> =20
> @@ -133,6 +135,8 @@ struct tps6586x {
>  	u32			irq_en;
>  	u8			mask_reg[5];
>  	struct irq_domain	*irq_domain;
> +
> +	struct notifier_block	power_off_nb;
>  };
> =20
>  static inline struct tps6586x *dev_to_tps6586x(struct device *dev)
> @@ -472,13 +476,18 @@ static const struct regmap_config tps6586x_regmap_c=
onfig =3D {
>  	.cache_type =3D REGCACHE_RBTREE,
>  };
> =20
> -static struct device *tps6586x_dev;
> -static void tps6586x_power_off(void)
> +static int tps6586x_power_off(struct notifier_block *this,
> +			      unsigned long unused1, void *unused2)
>  {
> -	if (tps6586x_clr_bits(tps6586x_dev, TPS6586X_SUPPLYENE, EXITSLREQ_BIT))
> -		return;
> +	struct tps6586x *tps6586x =3D container_of(this, struct tps6586x,
> +						 power_off_nb);
> +
> +	if (tps6586x_clr_bits(tps6586x->dev, TPS6586X_SUPPLYENE, EXITSLREQ_BIT))
> +		return NOTIFY_DONE;
> =20
> -	tps6586x_set_bits(tps6586x_dev, TPS6586X_SUPPLYENE, SLEEP_MODE_BIT);
> +	tps6586x_set_bits(tps6586x->dev, TPS6586X_SUPPLYENE, SLEEP_MODE_BIT);
> +
> +	return NOTIFY_DONE;
>  }
> =20
>  static void tps6586x_print_version(struct i2c_client *client, int versio=
n)
> @@ -575,9 +584,13 @@ static int tps6586x_i2c_probe(struct i2c_client *cli=
ent,
>  		goto err_add_devs;
>  	}
> =20
> -	if (pdata->pm_off && !pm_power_off) {
> -		tps6586x_dev =3D &client->dev;
> -		pm_power_off =3D tps6586x_power_off;
> +	if (pdata->pm_off) {
> +		tps6586x->power_off_nb.notifier_call =3D tps6586x_power_off;
> +		tps6586x->power_off_nb.priority =3D POWER_OFF_PRIORITY_LOW;
> +		ret =3D register_power_off_handler(&tps6586x->power_off_nb);
> +		if (ret)
> +			dev_warn(&client->dev,
> +				 "failed to register power-off handler\n");
>  	}
> =20
>  	return 0;
> @@ -594,6 +607,8 @@ static int tps6586x_i2c_remove(struct i2c_client *cli=
ent)
>  {
>  	struct tps6586x *tps6586x =3D i2c_get_clientdata(client);
> =20
> +	unregister_power_off_handler(&tps6586x->power_off_nb);
> +
>  	tps6586x_remove_subdevs(tps6586x);
>  	mfd_remove_devices(tps6586x->dev);
>  	if (client->irq)
> --=20
> 1.9.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--3wfpuDtTLg8/Vq6g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUV8H1AAoJEIaOsuA1yqREg40P/i2+qmArZQt9UZ+LpyN7XZID
6Q2Gjpg2UmjRQvEN99idDqmlkb1uWSBBl6zsjqt2wJVkv16R/3OIM+shO1+aNMo8
5tciWHIB2VoU4yebPpT8tv4z7TFlNIOScq9IV9fTSZu8vs2hlzSXSJ7pRSw7PsYh
szWhGnG+FlmfAJRztyvr/a3a75Xi2feHA072vTxd5xxBFNsn48pOt3PEZH07l3YN
jNJLoMMESpXEG7w5fysMfVvuOqM7w+ZOxDrG8cU8lUM2POkmCcIxcWJkA7lblji5
bg+0UurmBD9uaFzLC2N+spuvfg8UkVUhnXDOhRQux7d2LK92FGJB+S/ddobTM+Od
2UZXEzv47XXV2DEvvZaF79u7WGdz/cq+jrujr2ilqJTJ76kGmzjwbMYhnHIJ1nCM
34ZJwnApB7h2t5XMEp+zqM++YGMPL8WqkR6eGbhl9rRunf49wwtUO3eK4YmFo9ZG
VR2Euymlr4dHxEniLGbZ7zyYcON1TAorLovXEGyA1BOzpPWqL5MSKucj2onnZwRi
SjZVd9CpF1lKWpxFGxY5dGxcj5Dxod450rNf5CoZV2hlrWQt+ReuWk+lIpBLdBL+
QeHB6/0/OxbF3YNROqJgrQ5hy81PEogrSdsU7g2rKIg07vUnDN+wlGiCkAl99M7Y
RAqyl3aJIx3RiMqepeaB
=nHqS
-----END PGP SIGNATURE-----

--3wfpuDtTLg8/Vq6g--
