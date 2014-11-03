Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaKCSAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:00:52 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33827 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaKCSAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:00:49 -0500
Date: Mon, 3 Nov 2014 11:59:54 -0600
From: Felipe Balbi <balbi@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Guenter Roeck <linux@roeck-us.net>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 09/47] mfd: palmas: Register with kernel power-off
 handler
Message-ID: <20141103175954.GT27425@saruman>
Reply-To: <balbi@ti.com>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
 <1414425354-10359-10-git-send-email-linux@roeck-us.net>
 <20141103175645.GT12011@x1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WQ40utMgiyDduspJ"
Content-Disposition: inline
In-Reply-To: <20141103175645.GT12011@x1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--WQ40utMgiyDduspJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 03, 2014 at 05:56:45PM +0000, Lee Jones wrote:
> On Mon, 27 Oct 2014, Guenter Roeck wrote:
>=20
> > Register with kernel power-off handler instead of setting pm_power_off
> > directly. Register with low priority to reflect that the original code
> > only sets pm_power_off if it was not already set.
> >=20
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Cc: Lee Jones <lee.jones@linaro.org>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> > v3:
> > - Replace poweroff in all newly introduced variables and in text
> >   with power_off or power-off as appropriate
> > - Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
> > v2:
> > - Use define to specify poweroff handler priority
> > - Use devm_register_power_off_handler
> > - Use dev_warn instead of dev_err
> >=20
> >  drivers/mfd/palmas.c       | 31 +++++++++++++++++--------------
> >  include/linux/mfd/palmas.h |  3 +++
> >  2 files changed, 20 insertions(+), 14 deletions(-)
>=20
> Acked-by: Lee Jones <lee.jones@linaro.org>

missed lakml and linux-omap.

>=20
> > diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
> > index 28cb048..99c488e 100644
> > --- a/drivers/mfd/palmas.c
> > +++ b/drivers/mfd/palmas.c
> > @@ -19,6 +19,7 @@
> >  #include <linux/i2c.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/irq.h>
> > +#include <linux/pm.h>
> >  #include <linux/regmap.h>
> >  #include <linux/err.h>
> >  #include <linux/mfd/core.h>
> > @@ -425,20 +426,18 @@ static void palmas_dt_to_pdata(struct i2c_client =
*i2c,
> >  			"ti,system-power-controller");
> >  }
> > =20
> > -static struct palmas *palmas_dev;
> > -static void palmas_power_off(void)
> > +static int palmas_power_off(struct notifier_block *this, unsigned long=
 unused1,
> > +			    void *unused2)
> >  {
> > +	struct palmas *palmas =3D container_of(this, struct palmas, power_off=
_nb);
> >  	unsigned int addr;
> >  	int ret, slave;
> > =20
> > -	if (!palmas_dev)
> > -		return;
> > -
> >  	slave =3D PALMAS_BASE_TO_SLAVE(PALMAS_PMU_CONTROL_BASE);
> >  	addr =3D PALMAS_BASE_TO_REG(PALMAS_PMU_CONTROL_BASE, PALMAS_DEV_CTRL);
> > =20
> >  	ret =3D regmap_update_bits(
> > -			palmas_dev->regmap[slave],
> > +			palmas->regmap[slave],
> >  			addr,
> >  			PALMAS_DEV_CTRL_DEV_ON,
> >  			0);
> > @@ -446,6 +445,8 @@ static void palmas_power_off(void)
> >  	if (ret)
> >  		pr_err("%s: Unable to write to DEV_CTRL_DEV_ON: %d\n",
> >  				__func__, ret);
> > +
> > +	return NOTIFY_DONE;
> >  }
> > =20
> >  static unsigned int palmas_features =3D PALMAS_PMIC_FEATURE_SMPS10_BOO=
ST;
> > @@ -668,9 +669,16 @@ no_irq:
> >  		ret =3D of_platform_populate(node, NULL, NULL, &i2c->dev);
> >  		if (ret < 0) {
> >  			goto err_irq;
> > -		} else if (pdata->pm_off && !pm_power_off) {
> > -			palmas_dev =3D palmas;
> > -			pm_power_off =3D palmas_power_off;
> > +		} else if (pdata->pm_off) {
> > +			int ret2;
> > +
> > +			palmas->power_off_nb.notifier_call =3D palmas_power_off;
> > +			palmas->power_off_nb.priority =3D POWER_OFF_PRIORITY_LOW;
> > +			ret2 =3D devm_register_power_off_handler(palmas->dev,
> > +							&palmas->power_off_nb);
> > +			if (ret2)
> > +				dev_warn(palmas->dev,
> > +					 "Failed to register power-off handler");
> >  		}
> >  	}
> > =20
> > @@ -698,11 +706,6 @@ static int palmas_i2c_remove(struct i2c_client *i2=
c)
> >  			i2c_unregister_device(palmas->i2c_clients[i]);
> >  	}
> > =20
> > -	if (palmas =3D=3D palmas_dev) {
> > -		pm_power_off =3D NULL;
> > -		palmas_dev =3D NULL;
> > -	}
> > -
> >  	return 0;
> >  }
> > =20
> > diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
> > index fb0390a..7dbfe24 100644
> > --- a/include/linux/mfd/palmas.h
> > +++ b/include/linux/mfd/palmas.h
> > @@ -18,6 +18,7 @@
> > =20
> >  #include <linux/usb/otg.h>
> >  #include <linux/leds.h>
> > +#include <linux/notifier.h>
> >  #include <linux/regmap.h>
> >  #include <linux/regulator/driver.h>
> >  #include <linux/extcon.h>
> > @@ -68,6 +69,8 @@ struct palmas {
> >  	struct i2c_client *i2c_clients[PALMAS_NUM_CLIENTS];
> >  	struct regmap *regmap[PALMAS_NUM_CLIENTS];
> > =20
> > +	struct notifier_block power_off_nb;
> > +
> >  	/* Stored chip id */
> >  	int id;
> > =20
>=20
> --=20
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org =E2=94=82 Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--WQ40utMgiyDduspJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUV8KaAAoJEIaOsuA1yqREokIP/3BhF4T/PM7eCzEL3kiQjIJN
r0+KfCcUI7NgMTGudPVopJy/w9aaQFeVQc7oVe9/+3JhobYNN86TTfvNUThdZcYu
NtGxNxfViZ82VgJt8FaIzjNbv5icwV+66IOca0EjJcHKAJPZT1cCi9vykNJJRyFb
3SkL2cOw+eQlzObCCocdv5YVvSU2FSQs2lBetEH8aw8cudvvG9a2Tsma6aXRrbOA
krAqlD9exf2Oy/r/Zialz31oQZWOLZ50sZPUYPzo2fjOQMVP3EeEHVGPPbvI2MpW
vITjLFZJLOdFL7g1KQ4slkqzFmo6BHFKxDmZ8DajuiEhY6+UVWzddUBuJsI56i8G
i6sX3xrslQ2b2x0pZKLz+z7etWNVZWAaf0z0Uqx9ZsP7LN0t1X1ImLdaKxmZsP4z
za7vnmYuTk3W0MaDd8ClhOPEdMoFH5AuShEbzMP+t+VOWyRZhF2BFGHfnSVNlw6J
MaSVZZllfO5yAaRBLNqz90BRasLm1+RLhmABcfBvF/TVDYIt6R2FAWicY/MZhHWX
NjwqVHPeRr8JpjUF4kJF1bSq/U2hva8dmEjcrq2uGceGxL+TqCIyMS2T1JQyL9Xt
eqEYQcKPx4wEInZVMcCj7trgSjZucRx5ah2GVFrW0z0HINQITgcn1eXvmzLmnEoy
Kle+b7WMutx51RErhHED
=2cIN
-----END PGP SIGNATURE-----

--WQ40utMgiyDduspJ--
