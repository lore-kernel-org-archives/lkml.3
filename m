Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaF0MWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:22:03 -0400
Received: from sauhun.de ([89.238.76.85]:51996 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878AbaF0MV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:21:59 -0400
Date: Fri, 27 Jun 2014 14:21:48 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Jingoo Han <jg1.han@samsung.com>, Leilei Shang <shangll@marvell.com>,
        Daniel Drake <dsd@laptop.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] i2c: busses: i2c-pxa.c:  Fix for possible null pointer
 dereferenc
Message-ID: <20140627122147.GF2641@katana>
References: <1401831034-30255-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cz6wLo+OExbGG7q/"
Content-Disposition: inline
In-Reply-To: <1401831034-30255-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cz6wLo+OExbGG7q/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 11:30:34PM +0200, Rickard Strandqvist wrote:
> Fix for possible null pointer dereferenc, and there is a risk
> for memory leak in when something unexpected happens and the
> function returns.
>=20
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.s=
e>
> ---
>  drivers/i2c/busses/i2c-pxa.c |   19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
> index bbe6dfb..948a3c7 100644
> --- a/drivers/i2c/busses/i2c-pxa.c
> +++ b/drivers/i2c/busses/i2c-pxa.c
> @@ -1142,10 +1142,8 @@ static int i2c_pxa_probe(struct platform_device *d=
ev)
>  	int ret, irq;
> =20
>  	i2c =3D kzalloc(sizeof(struct pxa_i2c), GFP_KERNEL);
> -	if (!i2c) {
> -		ret =3D -ENOMEM;
> -		goto emalloc;
> -	}
> +	if (!i2c)
> +		return -ENOMEM;
> =20
>  	/* Default adapter num to device id; i2c_pxa_probe_dt can override. */
>  	i2c->adap.nr =3D dev->id;
> @@ -1154,11 +1152,16 @@ static int i2c_pxa_probe(struct platform_device *=
dev)
>  	if (ret > 0)
>  		ret =3D i2c_pxa_probe_pdata(dev, i2c, &i2c_type);
>  	if (ret < 0)
> -		goto eclk;
> +		goto emalloc;
> =20
>  	res =3D platform_get_resource(dev, IORESOURCE_MEM, 0);
> +	if (res =3D=3D NULL) {
> +		ret =3D -ENODEV;
> +		goto emalloc;
> +	}
> +
>  	irq =3D platform_get_irq(dev, 0);
> -	if (res =3D=3D NULL || irq < 0) {
> +	if (irq < 0) {
>  		ret =3D -ENODEV;
>  		goto eclk;

Nope, those should be emalloc as well since the region was not requested
here. May I ask you to just convert this driver to managed devices (devm_*
functions)? They are made to exactly avoid this hazzle and cleanup the
driver.

Thanks,

   Wolfram


--cz6wLo+OExbGG7q/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTrWHbAAoJEBQN5MwUoCm2ZSwP/2qAclUPmuYRl9LRNSqOFKV1
OApDTwxBFwIC1EUsg0zZ5/lpj5ZSZkkLLPGu3Of0oyHJbeXS4+dnw9+1NdmdwVyH
bBUBNCu7T5yhRQgolWPjVMKOnGRqjxJmp1A03BF960lMc+LaSijD9sqJrWQnCemP
UbJXFXEC7xk8u2QRX8uxmKRdnSAb/d7f8FUC6n4SXZc1eDivljc2cWgpE1Qtn1av
LTB3Iw21m8076qUitVBXIo1+rVj6zxmZiKgL/Bg1bEJBIQhu2TU5D8xTJf3TQKgC
FHUHXFEdhZYy6lGRnQBYFULPsbviYp153HJaEa7zY5xEMWOq08E1TMMPGTU72Mwd
/DOInBIjirzdLnWOQVovOtmZ9KRux/jXJwigjxy2NSEuEncKXgF1Xc3TEiP75ybP
BAwRAesucL9b/xYKlsET7OpVjOaRzS4DfjYKAZjYFi8mpMFjSgk/ruHpahwwAIUX
RKpoNLGZyeyHeziXp1T4S4l7EnThzvpzwkcSjQsFNxtbo9kLnkZbKlhg0GI/lYrl
I/Tkbfd1OHY5N2g3bDnJKHx5bOvB+RIHQoACNmcTqZE1IawOApEI8yy5qFMrjjmd
y65qwlBf7aynHryrTOTLFttH7aNLrWXiC0AGzGdexSbhQ7SSnuhanvE/dNKwHxpd
z2Wb18VoVffZluRrjGVn
=it/c
-----END PGP SIGNATURE-----

--cz6wLo+OExbGG7q/--
