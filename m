Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbaKCR5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:57:13 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:34410 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687AbaKCR4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:56:53 -0500
Date: Mon, 3 Nov 2014 11:56:19 -0600
From: Felipe Balbi <balbi@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Guenter Roeck <linux@roeck-us.net>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v3 18/47] mfd: twl4030-power: Register with kernel
 power-off handler
Message-ID: <20141103175619.GP27425@saruman>
Reply-To: <balbi@ti.com>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
 <1414425354-10359-19-git-send-email-linux@roeck-us.net>
 <20141103175427.GK12011@x1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cmVHo2jXx4bdYlgS"
Content-Disposition: inline
In-Reply-To: <20141103175427.GK12011@x1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cmVHo2jXx4bdYlgS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 03, 2014 at 05:54:27PM +0000, Lee Jones wrote:
> On Mon, 27 Oct 2014, Guenter Roeck wrote:
>=20
> > Register with kernel power-off handler instead of setting pm_power_off
> > directly. Register with low priority to reflect that the original code
> > only sets pm_power_off if it was not already set.
> >=20
> > Make twl4030_power_off static as it is only called from the twl4030-pow=
er
> > driver. Drop remove function as it is no longer needed.
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
> > - Use dev_warn instead of dev_err
> > - Use devm_register_power_off_handler
> > - Drop remove function as it is no longer needed.
> >=20
> >  drivers/mfd/twl4030-power.c | 29 +++++++++++++++++++----------
> >  include/linux/i2c/twl.h     |  1 -
> >  2 files changed, 19 insertions(+), 11 deletions(-)
>=20
> Acked-by: Lee Jones <lee.jones@linaro.org>

this was not sent to lakml or linux-omap. Care to resend ?

> > diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
> > index cf92a6d..e36eea9 100644
> > --- a/drivers/mfd/twl4030-power.c
> > +++ b/drivers/mfd/twl4030-power.c
> > @@ -25,9 +25,10 @@
> >   */
> > =20
> >  #include <linux/module.h>
> > -#include <linux/pm.h>
> > +#include <linux/notifier.h>
> >  #include <linux/i2c/twl.h>
> >  #include <linux/platform_device.h>
> > +#include <linux/pm.h>
> >  #include <linux/of.h>
> >  #include <linux/of_device.h>
> > =20
> > @@ -611,7 +612,8 @@ twl4030_power_configure_resources(const struct twl4=
030_power_data *pdata)
> >   * After a successful execution, TWL shuts down the power to the SoC
> >   * and all peripherals connected to it.
> >   */
> > -void twl4030_power_off(void)
> > +static int twl4030_power_off(struct notifier_block *this, unsigned lon=
g unused1,
> > +			     void *unused2)
> >  {
> >  	int err;
> > =20
> > @@ -619,8 +621,15 @@ void twl4030_power_off(void)
> >  			       TWL4030_PM_MASTER_P1_SW_EVENTS);
> >  	if (err)
> >  		pr_err("TWL4030 Unable to power off\n");
> > +
> > +	return NOTIFY_DONE;
> >  }
> > =20
> > +static struct notifier_block twl4030_power_off_nb =3D {
> > +	.notifier_call =3D twl4030_power_off,
> > +	.priority =3D POWER_OFF_PRIORITY_LOW,
> > +};
> > +
> >  static bool twl4030_power_use_poweroff(const struct twl4030_power_data=
 *pdata,
> >  					struct device_node *node)
> >  {
> > @@ -839,7 +848,9 @@ static int twl4030_power_probe(struct platform_devi=
ce *pdev)
> >  	}
> > =20
> >  	/* Board has to be wired properly to use this feature */
> > -	if (twl4030_power_use_poweroff(pdata, node) && !pm_power_off) {
> > +	if (twl4030_power_use_poweroff(pdata, node)) {
> > +		int ret;
> > +
> >  		/* Default for SEQ_OFFSYNC is set, lets ensure this */
> >  		err =3D twl_i2c_read_u8(TWL_MODULE_PM_MASTER, &val,
> >  				      TWL4030_PM_MASTER_CFG_P123_TRANSITION);
> > @@ -856,7 +867,11 @@ static int twl4030_power_probe(struct platform_dev=
ice *pdev)
> >  			}
> >  		}
> > =20
> > -		pm_power_off =3D twl4030_power_off;
> > +		ret =3D devm_register_power_off_handler(&pdev->dev,
> > +						      &twl4030_power_off_nb);
> > +		if (ret)
> > +			dev_warn(&pdev->dev,
> > +				 "Failed to register power-off handler\n");
> >  	}
> > =20
> >  relock:
> > @@ -870,11 +885,6 @@ relock:
> >  	return err;
> >  }
> > =20
> > -static int twl4030_power_remove(struct platform_device *pdev)
> > -{
> > -	return 0;
> > -}
> > -
> >  static struct platform_driver twl4030_power_driver =3D {
> >  	.driver =3D {
> >  		.name	=3D "twl4030_power",
> > @@ -882,7 +892,6 @@ static struct platform_driver twl4030_power_driver =
=3D {
> >  		.of_match_table =3D of_match_ptr(twl4030_power_of_match),
> >  	},
> >  	.probe		=3D twl4030_power_probe,
> > -	.remove		=3D twl4030_power_remove,
> >  };
> > =20
> >  module_platform_driver(twl4030_power_driver);
> > diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
> > index 8cfb50f..f8544f1 100644
> > --- a/include/linux/i2c/twl.h
> > +++ b/include/linux/i2c/twl.h
> > @@ -680,7 +680,6 @@ struct twl4030_power_data {
> >  };
> > =20
> >  extern int twl4030_remove_script(u8 flags);
> > -extern void twl4030_power_off(void);
> > =20
> >  struct twl4030_codec_data {
> >  	unsigned int digimic_delay; /* in ms */
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

--cmVHo2jXx4bdYlgS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUV8HDAAoJEIaOsuA1yqREgYsP+wUfij7prQeEL+OjYLZMqjgV
RX8pfOZ3PEIUaDQjfzCwKofANVoH1F/Q9RVk5BUU/8apOkmtajEsM615d23nTdqg
TRB17QKWBRmyxrWelGAe7Y9+Qm/2TzYRrlKOja8mOpJFmL03QzXPDnj3rIZT+bRm
Gi70Ql8Gv6nSC0l3XecnhF8AsTTEm+DLRRVAEiSR5IYgIXDX5gIzuQ8g8zQdubao
VyuyNiJ3DXEQmpR36qqs6XUVf7F5I3uCi+2m4bTHlngb7WCw+Rbd/Xh4LZhAs/Y5
SGDCnpQ/CsIlv/sWDLSh0fEwoIB085gef6o1FU0osKujYOdxyQB00Q3M7DJDqU3e
2fs2CWyDfkS9tu45kmOfibRtgV+SyjHNiQadf4biz278GaCuaF26QoVJ8lIEUUhn
4LzFpY9XUIrb4HjanfmjjjKP/diPyUadfhvIvGjCnZba0fY6XEiocqIsVdfmHeLz
hExAWVGk+LJ6eN3x2ohjmuzAR/xZFlk/X5SOZgZD3whZ1oPVnC76134k6uIl9Hd+
y5u1Y2ikvfGloi7Knx9hlDf0NBGUFa0pm87Dtrok7qi9tJOeVRyli0MN2+28DK2P
bDkJH6QjIQlgFkUp4NSpHE2vo9NbhChj9jJ08YQx/XOF5g/vMZXACbgl+fLjYl1h
yCgicG+vhrpJguwIdw5k
=I+KJ
-----END PGP SIGNATURE-----

--cmVHo2jXx4bdYlgS--
