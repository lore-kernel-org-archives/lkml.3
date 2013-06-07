Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab3FGTDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 15:03:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50690 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298Ab3FGTDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 15:03:13 -0400
Date: Fri, 7 Jun 2013 22:02:06 +0300
From: Felipe Balbi <balbi@ti.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 2/5] i2c: omap: add runtime check in isr to be sure that
 i2c is enabled
Message-ID: <20130607190206.GC15295@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1370630768-4077-1-git-send-email-grygorii.strashko@ti.com>
 <1370630768-4077-3-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TiqCXmo5T1hvSQQg"
Content-Disposition: inline
In-Reply-To: <1370630768-4077-3-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TiqCXmo5T1hvSQQg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jun 07, 2013 at 09:46:05PM +0300, Grygorii Strashko wrote:
> Add runtime check at the beginning of omap_i2c_isr/omap_i2c_isr_thread
> to be sure that i2c is enabled, before performing IRQ handling and access=
ing
> I2C IP registers:
> 	if (pm_runtime_suspended(dev->dev)) {
> 		WARN_ONCE(true, "We should never be here!\n");
> 		return IRQ_NONE;
> 	}
>=20
> Produce warning in case if ISR called when i2c is disabled
>=20
> CC: Kevin Hilman <khilman@linaro.org>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  drivers/i2c/busses/i2c-omap.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index 97844ff..2dac598 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -885,6 +885,11 @@ omap_i2c_isr(int irq, void *dev_id)
>  	u16 stat;
> =20
>  	spin_lock(&dev->lock);
> +	if (pm_runtime_suspended(dev->dev)) {
> +		WARN_ONCE(true, "We should never be here!\n");
> +		return IRQ_NONE;
> +	}

returning IRQ_NONE is not what you want to do in this case. You want to
setup a flag so that your runtime_resume() knows that there are pending
events to be handled and you handle those in runtime_resume time.

But to be frank, I don't see how this can trigger since we're calling
pm_runtime_get_sync() from omap_i2c_xfer() which means by the time
pm_runtime_get_sync() returns, assuming no errors, i2c module should be
fully resumed and ready to go. Perhaps you have found a bug somewhere
else ?

Also, your 'We should never be here' message isn't helpfull at all.

> @@ -905,6 +910,11 @@ omap_i2c_isr_thread(int this_irq, void *dev_id)
>  	u16 stat;
>  	int err =3D 0, count =3D 0;
> =20
> +	if (pm_runtime_suspended(dev->dev)) {
> +		WARN_ONCE(true, "We should never be here!\n");
> +		return IRQ_NONE;
> +	}

because of IRQF_ONESHOT I can't see how this would *ever* be a valid
check.

--=20
balbi

--TiqCXmo5T1hvSQQg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRsi4uAAoJEIaOsuA1yqREkG4P/1lsB5sJ3cYWwxz7Mt5gO5D1
mCs4MjEdUAgO3WSVeRJlHPe0qFuJivy7CPAQ/F53HqwoCEt+E44IXFnRJtNQPoBt
qsF0eVqRlhcLzlGbHTmv7TW+RbAC/aCNDmjyMj2HoZCrYAX7k7EZ/DKd4rlqLwAV
Vp+rVjwdUNWlQYCQPYlCMDN7d6cU4ZhOtxcKrHrOGalBjkK049lZMahFcRS2yE4H
FIcpdFZyNNZgZkAct2C8awdrXePm+l2Y1QnPI0DPuEGOiTZZmQgIQHV2Mq6fUudq
igjP1Gile8K+H7fqUzVafuMRyE+RzRrTZsFzjHO4tsUBl8ZzUg4rgaynF221viVI
kgA7k3yg7IDF//55ZCFn8W48bn6kY06YuTnIdDqDap4u4JoP8fgPAPTe8mXxTPO4
nDicXXRE9jujFq088eoC/vZg8CMNICQ9ohcsLG1fyKcnXdgIKdxZbO7BjDQ8z9A9
XMG8pqSyg5BbzpnUX9j5cW5n2L9hh0Qcyu3vK8juvRNbLnTGLMxlsV/HrN41N+Yd
m6/Xd2pjDKMZ7zXXMDmeBEfoMxxYZca3weWIesU0kDie3v+UG3sYgiY6LO9DcX6F
dlWNdaB3xWKdHejctGwZgKT6HW53ReZkNkpHfONaHwePHw/dKCSaTXZ8RdP11bUn
i50n15ZMTr7L09I6R14r
=lPoP
-----END PGP SIGNATURE-----

--TiqCXmo5T1hvSQQg--
