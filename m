Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbaIINkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:40:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57552 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752419AbaIINkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:40:05 -0400
Date: Tue, 9 Sep 2014 15:37:04 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: IIO <linux-iio@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Hartmut Knaack <knaack.h@gmx.de>, Fugang Duan <B38611@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Philippe Reynes <tremyfr@yahoo.fr>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH 2/4] mfd/axp2xx: extend axp20x to support axp288 pmic
Message-ID: <20140909133704.GO3804@lukather>
References: <1410215046-31751-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1410215046-31751-3-git-send-email-jacob.jun.pan@linux.intel.com>
 <20140909073747.GI3804@lukather>
 <20140909054517.5bd4e8b6@ultegra>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oJAv8lSwuaQsYd0G"
Content-Disposition: inline
In-Reply-To: <20140909054517.5bd4e8b6@ultegra>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oJAv8lSwuaQsYd0G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 09, 2014 at 05:45:17AM -0700, Jacob Pan wrote:
> > > -static int axp20x_i2c_probe(struct i2c_client *i2c,
> > > -			 const struct i2c_device_id *id)
> > > +static int axp2xx_match_device(struct axp2xx_dev *axp2xx, struct
> > > device *dev) {
> > > -	struct axp20x_dev *axp20x;
> > > +	const struct acpi_device_id *acpi_id;
> > >  	const struct of_device_id *of_id;
> > > -	int ret;
> > > =20
> > > -	axp20x =3D devm_kzalloc(&i2c->dev, sizeof(*axp20x),
> > > GFP_KERNEL);
> > > -	if (!axp20x)
> > > -		return -ENOMEM;
> > > +	of_id =3D of_match_device(axp2xx_of_match, dev);
> > > +	if (of_id) {
> > > +		axp2xx->variant =3D (long) of_id->data;
> > > +		goto found_match;
> > > +	}
> > > =20
> > > -	of_id =3D of_match_device(axp20x_of_match, &i2c->dev);
> > > -	if (!of_id) {
> > > -		dev_err(&i2c->dev, "Unable to setup AXP20X
> > > data\n");
> > > +	acpi_id =3D acpi_match_device(dev->driver->acpi_match_table,
> > > dev);
> > > +	if (!acpi_id || !acpi_id->driver_data) {
> > > +		dev_err(dev, "Unable to setup AXP2XX ACPI data\n");
> > >  		return -ENODEV;
> > >  	}
> > > -	axp20x->variant =3D (long) of_id->data;
> > > +	axp2xx->variant =3D (long) acpi_id->driver_data;
> >=20
> > Shouldn't that be in the if statement above? I guess acpi_id will be
> > null on a DT-based system.
> >=20
> I am not sure what you mean. if acpi_id =3D=3D NULL, then it will return
> -ENODEV since of_match_device() already found no match. If acpi_id !=3D
> NULL, then id must contain variant info.

Hmm, never mind. I read it backward and thought you were still in this
code path. I guess I need more coffee.

That goto isn't very intuitive though.

Maybe something like

if (of_id) {
   /* DT case */
} else if (acpi_id) {
  /* ACPI case */
} else {
  return;
}

would be better?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--oJAv8lSwuaQsYd0G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUDwKAAAoJEBx+YmzsjxAgEnYP/0Hzi9Djt972iel2iLbXdSCW
1b3bQf2LRVNhOJ3kDHgGQcMzxd5SlJquHTXTsEoRZnF4NMRPiPIDo34yT1cgagLR
+E3T10fdSFJf1veZ4rW4r19njFNYhe5bChEVSq6w1hsYrz0PtsrNcN9gTfqIyLOK
I0NVoyy4jbzC0NLkikNHHcsLzaciGbCdpUkWATyJz0m3UuYPFHBHT3U3cWd6ZvRz
0Dlr/nNx+1w50STODT47WTj2iB0VX2bsXoVQVzS3Vuz4rsJk/ixes15eW1qolizU
CdkEKjFSspz3LfI4UVSQZ1UrlohzZI0jmUBembYM5AhU5a8eBca7ObgoZE0eIP5k
ZYuBwvsDL2yp6mVIihZ/zWX9kSeJtiW6EEZDDromHMvadEZo/YkkpQO51waRUrwH
Rqh3luRr85wNyrzeMPvFYrGH2CCo9pgWBuKQ21CPHYz3JVbMszX04cXg7kD8Koau
qv2OqHsqZ9DQIvKV416iLZvVuumtcDpY40goUbc6lTyTWDBGCCPo3QrXUT0GS1zX
mKuLS9bAmjvwfVlhAQSdRUUA8QpqcpzzOSzcja0CEPw9pjZjiM8EP2xCjSgTQ/Xo
pDCQIbQEnRbL9+YqkFba0jN3qrp0Rf/obu224cDilT/IomC4MtJm/IVKSpVZg1+E
5ia5N08VuANhKzlBYsVA
=R500
-----END PGP SIGNATURE-----

--oJAv8lSwuaQsYd0G--
