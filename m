Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbaLARiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:38:54 -0500
Received: from sauhun.de ([89.238.76.85]:34211 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099AbaLARiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:38:52 -0500
Date: Mon, 1 Dec 2014 18:38:48 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Corey Minyard <cminyard@mvista.com>
Cc: minyard@acm.org, linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: Add parameters to sysfs-added i2c devices
Message-ID: <20141201173848.GF3212@katana>
References: <1415976117-27755-1-git-send-email-minyard@acm.org>
 <547335FB.4020002@mvista.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wb5NtZlyOqqy58h0"
Content-Disposition: inline
In-Reply-To: <547335FB.4020002@mvista.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Wb5NtZlyOqqy58h0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2014 at 07:43:23AM -0600, Corey Minyard wrote:
> Ping, I haven't heard anything on this.

Use cases please :) What client drivers would need that and what params
do they need?

>=20
> -corey
>=20
> On 11/14/2014 08:41 AM, minyard@acm.org wrote:
> > From: Corey Minyard <cminyard@mvista.com>
> >
> > Some devices might need parameters to control their operation,
> > add the ability to pass these parameters to the client.
> >
> > This also makes the parsing of sysfs-added I2C devices a little
> > more flexible, allowing tabs and arbitrary numbers of spaces.
> >
> > Signed-off-by: Corey Minyard <cminyard@mvista.com>
> > ---
> >  drivers/i2c/i2c-core.c | 46 ++++++++++++++++++++++++++++++++++--------=
----
> >  include/linux/i2c.h    |  3 +++
> >  2 files changed, 37 insertions(+), 12 deletions(-)
> >
> > I'm adding an SMBus IPMI driver, and it needs to be able to have
> > the IPMI bus address specified in case it's not the default.
> >
> > Also, this seems like it would be useful for other devices that
> > need some sort of configuration.
> >
> > diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> > index f43b4e1..9a2ab13 100644
> > --- a/drivers/i2c/i2c-core.c
> > +++ b/drivers/i2c/i2c-core.c
> > @@ -781,7 +781,10 @@ static int i2c_device_pm_restore(struct device *de=
v)
> > =20
> >  static void i2c_client_dev_release(struct device *dev)
> >  {
> > -	kfree(to_i2c_client(dev));
> > +	struct i2c_client *client =3D to_i2c_client(dev);
> > +
> > +	kfree(client->parms);
> > +	kfree(client);
> >  }
> > =20
> >  static ssize_t
> > @@ -1059,6 +1062,13 @@ i2c_new_device(struct i2c_adapter *adap, struct =
i2c_board_info const *info)
> >  	client->flags =3D info->flags;
> >  	client->addr =3D info->addr;
> >  	client->irq =3D info->irq;
> > +	if (info->parms) {
> > +		client->parms =3D kstrdup(info->parms, GFP_KERNEL);
> > +		if (!client->parms) {
> > +			dev_err(&adap->dev, "Out of memory allocating parms\n");
> > +			goto out_err_silent;
> > +		}
> > +	}
> > =20
> >  	strlcpy(client->name, info->type, sizeof(client->name));
> > =20
> > @@ -1207,31 +1217,43 @@ i2c_sysfs_new_device(struct device *dev, struct=
 device_attribute *attr,
> >  	struct i2c_adapter *adap =3D to_i2c_adapter(dev);
> >  	struct i2c_board_info info;
> >  	struct i2c_client *client;
> > -	char *blank, end;
> > +	char *pos, end;
> >  	int res;
> > =20
> >  	memset(&info, 0, sizeof(struct i2c_board_info));
> > =20
> > -	blank =3D strchr(buf, ' ');
> > -	if (!blank) {
> > +	pos =3D strpbrk(buf, " \t");
> > +	if (!pos) {
> >  		dev_err(dev, "%s: Missing parameters\n", "new_device");
> >  		return -EINVAL;
> >  	}
> > -	if (blank - buf > I2C_NAME_SIZE - 1) {
> > +	if (pos - buf > I2C_NAME_SIZE - 1) {
> >  		dev_err(dev, "%s: Invalid device name\n", "new_device");
> >  		return -EINVAL;
> >  	}
> > -	memcpy(info.type, buf, blank - buf);
> > +	memcpy(info.type, buf, pos - buf);
> > =20
> > -	/* Parse remaining parameters, reject extra parameters */
> > -	res =3D sscanf(++blank, "%hi%c", &info.addr, &end);
> > -	if (res < 1) {
> > +	while (isspace(*pos))
> > +		pos++;
> > +
> > +	/* Parse address, saving remaining parameters. */
> > +	res =3D sscanf(pos, "%hi%c", &info.addr, &end);
> > +	if (res < 1 || !isspace(end)) {
> >  		dev_err(dev, "%s: Can't parse I2C address\n", "new_device");
> >  		return -EINVAL;
> >  	}
> > -	if (res > 1  && end !=3D '\n') {
> > -		dev_err(dev, "%s: Extra parameters\n", "new_device");
> > -		return -EINVAL;
> > +	if (res > 1 && end !=3D '\n') {
> > +		if (isspace(end)) {
> > +			/* Extra parms, skip the address and space. */
> > +			while (!isspace(*pos))
> > +				pos++;
> > +			while (isspace(*pos))
> > +				pos++;
> > +			info.parms =3D pos;
> > +		} else {
> > +			dev_err(dev, "%s: Extra parameters\n", "new_device");
> > +			return -EINVAL;
> > +		}
> >  	}
> > =20
> >  	client =3D i2c_new_device(adap, &info);
> > diff --git a/include/linux/i2c.h b/include/linux/i2c.h
> > index b556e0a..e40fc56 100644
> > --- a/include/linux/i2c.h
> > +++ b/include/linux/i2c.h
> > @@ -222,6 +222,7 @@ struct i2c_client {
> >  	char name[I2C_NAME_SIZE];
> >  	struct i2c_adapter *adapter;	/* the adapter we sit on	*/
> >  	struct device dev;		/* the device structure		*/
> > +	char *parms;			/* sysfs extra parms		*/
> >  	int irq;			/* irq issued by device		*/
> >  	struct list_head detected;
> >  };
> > @@ -255,6 +256,7 @@ static inline void i2c_set_clientdata(struct i2c_cl=
ient *dev, void *data)
> >   * @archdata: copied into i2c_client.dev.archdata
> >   * @of_node: pointer to OpenFirmware device node
> >   * @acpi_node: ACPI device node
> > + * @parms: Parameters supplied on the sysfs command line
> >   * @irq: stored in i2c_client.irq
> >   *
> >   * I2C doesn't actually support hardware probing, although controllers=
 and
> > @@ -276,6 +278,7 @@ struct i2c_board_info {
> >  	struct dev_archdata	*archdata;
> >  	struct device_node *of_node;
> >  	struct acpi_dev_node acpi_node;
> > +	char            *parms;
> >  	int		irq;
> >  };
> > =20
>=20

--Wb5NtZlyOqqy58h0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUfKeoAAoJEBQN5MwUoCm2eDMP/36UDlPBHbf0vnnDB+dgCH9o
8TebXBkOtRV/IFyFTeVdlwbI1d71DZEowQU2Wta7+9pop9YouoiPq1m+dRUgbtsO
LX579tUCh8ZMVzTvE8QL8T3BD5WDwdmGSo5tvyBia1HS0OG/axa8cNeK3n/5XLYl
AmJBTR4dGZBGBifLRvaP4QtzRw0ezx4WFDnxPSvc6rKlZsyHcOCGts+2Q7W0S/Og
Het9oJrUwZkgcOClWpp74IJUkETz7kCp9B8R2/285r5Q4L4CM5rzOjovsWwQij5B
9uxmRgJcRt2UOMoIi2+iL/RGijalUgXAYnb/JFK3xT/QwnzBvoI94cRbj0kbgtsK
EzlEMuwSnOmPDDgxFPi41jid269GMkFMCzZp/GziNdby8m8tzr/Pdk4brpy60nuf
hPBEhEOrcEO7m7STu1QF4eoZe+Ildw9izG2Jnu71oEiTwdJc5GdlflGaKDTGKjY5
NmsnnXNT0HHcRjmpvsS5fI9+odFq8YwnjmDDpbeXkY4bfCEXM50sBulAd2f2vvRx
1FBl8nAv4+fT8v7sF7wPgUwwEq5tmMSdHiKDPjKsEe+USmDkFQMtG6lpKBbUQax2
+WjFcYlNoE/ieuGTjbh7lgNyVpITsf3q9NAsPnL6Gt6NvEjPO2G9dscQ+8QedEtp
SWjoseI1q86o/VvHgK3k
=1SkI
-----END PGP SIGNATURE-----

--Wb5NtZlyOqqy58h0--
