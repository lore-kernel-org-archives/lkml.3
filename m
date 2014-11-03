Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbaKCR60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:58:26 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:47405 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbaKCR6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:58:22 -0500
Date: Mon, 3 Nov 2014 11:57:27 -0600
From: Felipe Balbi <balbi@ti.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 17/47] mfd: tps65910: Register with kernel power-off
 handler
Message-ID: <20141103175727.GR27425@saruman>
Reply-To: <balbi@ti.com>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
 <1414425354-10359-18-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="19HmC3QOnaNVzKTI"
Content-Disposition: inline
In-Reply-To: <1414425354-10359-18-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--19HmC3QOnaNVzKTI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2014 at 08:55:24AM -0700, Guenter Roeck wrote:
> Register with kernel power-off handler instead of setting pm_power_off
> directly. Register with low priority to reflect that the original code
> only sets pm_power_off if it was not already set.
>=20
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

missed lakml and linux-omap here too

> ---
> v3:
> - Replace poweroff in all newly introduced variables and in text
>   with power_off or power-off as appropriate
> - Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
> v2:
> - Use define to specify poweroff handler priority
> - Use dev_warn instead of dev_err
>=20
>  drivers/mfd/tps65910.c       | 27 ++++++++++++++++++---------
>  include/linux/mfd/tps65910.h |  3 +++
>  2 files changed, 21 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
> index 7612d89..3c94dbf 100644
> --- a/drivers/mfd/tps65910.c
> +++ b/drivers/mfd/tps65910.c
> @@ -23,6 +23,8 @@
>  #include <linux/irq.h>
>  #include <linux/irqdomain.h>
>  #include <linux/mfd/core.h>
> +#include <linux/notifier.h>
> +#include <linux/pm.h>
>  #include <linux/regmap.h>
>  #include <linux/mfd/tps65910.h>
>  #include <linux/of.h>
> @@ -437,19 +439,20 @@ struct tps65910_board *tps65910_parse_dt(struct i2c=
_client *client,
>  }
>  #endif
> =20
> -static struct i2c_client *tps65910_i2c_client;
> -static void tps65910_power_off(void)
> +static int tps65910_power_off(struct notifier_block *this,
> +			      unsigned long unused1, void *unused2)
>  {
> -	struct tps65910 *tps65910;
> -
> -	tps65910 =3D dev_get_drvdata(&tps65910_i2c_client->dev);
> +	struct tps65910 *tps65910 =3D container_of(this, struct tps65910,
> +						 power_off_nb);
> =20
>  	if (tps65910_reg_set_bits(tps65910, TPS65910_DEVCTRL,
>  			DEVCTRL_PWR_OFF_MASK) < 0)
> -		return;
> +		return NOTIFY_DONE;
> =20
>  	tps65910_reg_clear_bits(tps65910, TPS65910_DEVCTRL,
>  			DEVCTRL_DEV_ON_MASK);
> +
> +	return NOTIFY_DONE;
>  }
> =20
>  static int tps65910_i2c_probe(struct i2c_client *i2c,
> @@ -505,9 +508,13 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
>  	tps65910_ck32k_init(tps65910, pmic_plat_data);
>  	tps65910_sleepinit(tps65910, pmic_plat_data);
> =20
> -	if (pmic_plat_data->pm_off && !pm_power_off) {
> -		tps65910_i2c_client =3D i2c;
> -		pm_power_off =3D tps65910_power_off;
> +	if (pmic_plat_data->pm_off) {
> +		tps65910->power_off_nb.notifier_call =3D tps65910_power_off;
> +		tps65910->power_off_nb.priority =3D POWER_OFF_PRIORITY_LOW;
> +		ret =3D register_power_off_handler(&tps65910->power_off_nb);
> +		if (ret)
> +			dev_warn(&i2c->dev,
> +				 "failed to register power-off handler\n");
>  	}
> =20
>  	ret =3D mfd_add_devices(tps65910->dev, -1,
> @@ -527,6 +534,8 @@ static int tps65910_i2c_remove(struct i2c_client *i2c)
>  {
>  	struct tps65910 *tps65910 =3D i2c_get_clientdata(i2c);
> =20
> +	unregister_power_off_handler(&tps65910->power_off_nb);
> +
>  	tps65910_irq_exit(tps65910);
>  	mfd_remove_devices(tps65910->dev);
> =20
> diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
> index 6483a6f..94876c4 100644
> --- a/include/linux/mfd/tps65910.h
> +++ b/include/linux/mfd/tps65910.h
> @@ -905,6 +905,9 @@ struct tps65910 {
>  	/* IRQ Handling */
>  	int chip_irq;
>  	struct regmap_irq_chip_data *irq_data;
> +
> +	/* Power-off handling */
> +	struct notifier_block power_off_nb;
>  };
> =20
>  struct tps65910_platform_data {
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

--19HmC3QOnaNVzKTI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUV8IHAAoJEIaOsuA1yqRE6DQQAJfZmeYQX2oBzWdgs4gDi19r
3kdBZ8+HFTeszmKLZvlSe0rcWw+/UM6YmZAq/hXWFgw4vW90DffqpjsmvRXtU/XA
8/V/Pauh5Os83nLY4AITjiFyWykqplepDn5c9daiSPmijTIPyxr461pckJBYx2Zl
G9NKI/3X86Bc9ELEZG2dHnJohrpbcauJNkfmBZwyFlmcRsjsXo8mG7ptJkXaIpbZ
dFij/RtHoDoL2TV57Nqqs1V041c6FAOjcZK1j+ayCtjkk4RcDbfQbYEFhNhFFtg7
gXxKzFavxIW/xaMLeuJ4mWnJLniDIZK2frrm10yXBzDb70WmAR87qQS/URZxDmYi
mDSyPbWU4/T3YvMGtFDRwdOAip4k1DCxSOcTTqV1xfl00YdIO5a+/jI7S1iEDW20
RSSq5nzZ8/HRUkz1Wa6o3bIfEuOe1bDCYAEsP2XHKsSe0nSAooXM3T07tHKQT4Fd
kyPIq1VDekTiE3XBX3bdbfXKw4DsPbsMnacZ3Pzq+T8RZ53bPEdCAEWbnb0cjhVO
jvzvtGDzTHWzM+svqXdDIbnkJQ4NGMcYViiXQURJZp5qq2hbq8QJWr95wVGK2YSi
wTl+3wFOsi1H+t+ykiLn+fMdw61d86mGWUTcxCPIbCkkEQopRA0el5RZ7fhSqLV+
gCP6f5S8sw0a3toAPxdy
=TyJs
-----END PGP SIGNATURE-----

--19HmC3QOnaNVzKTI--
