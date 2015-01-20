Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbbATLfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:35:19 -0500
Received: from sauhun.de ([89.238.76.85]:33465 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbbATLfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:35:17 -0500
Date: Tue, 20 Jan 2015 12:35:08 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lars-Peter Clausen <lars@metafoo.de>, linux-mips@linux-mips.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH] i2c: drop ancient protection against sysfs refcounting
 issues
Message-ID: <20150120113508.GA1067@katana>
References: <1421693756-12917-1-git-send-email-wsa@the-dreams.de>
 <20150119190142.GA9451@kroah.com>
 <20150119230427.GH26493@n2100.arm.linux.org.uk>
 <20150120014159.GA3349@kroah.com>
 <54BDFE30.5090303@metafoo.de>
 <20150120071256.GA18983@kroah.com>
 <20150120101752.GI26493@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <20150120101752.GI26493@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > Right, and I'm not saying it should be, just move the existing logic
> > into the release callback, and the code flow should be the same and we
> > don't end up with an "empty" release callback.

But as Russell says, even if we don't have the empty callback, we still
create the problem shown by DEBUG_KOBJECT_RELEASE which wasn't there
before?

> IMHO there are two possibilities here:
>=20
> 1. leave it as-is, where we ensure that the remainder of i2c_del_adapter
>    does not complete until the release callback has been called.
>=20
> 2. fix it properly by taking (eg) the netdev approach to i2c_adapter,
>    or an alternative solution which results in decoupling the lifetime
>    of the struct device from the i2c_adapter.
>=20
> Either of these would be much better than removing the completion and
> then moving a chunk of code to make it "look" safer than it actually is
> and thereby introducing potential use-after-free bugs.

I agree. As much as I'd love option 2) I don't see that on the horizon.
So, let's keep things as they are. What probably makes sense is to
update the comment with something like this? I took the liberty and used
some wording from Russell:

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index e227dff62a85..1c89a08fae2a 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1778,11 +1778,14 @@ void i2c_del_adapter(struct i2c_adapter *adap)
 	/* device name is gone after device_unregister */
 	dev_dbg(&adap->dev, "adapter [%s] unregistered\n", adap->name);
=20
-	/* clean up the sysfs representation */
+	/* wait until all references to the device are gone
+	 *
+	 * FIXME: This is old code and should ideally be replaced by an
+	 * alternative which results in decoupling the lifetime of the struct
+	 * device from the i2c_adapter, like spi or netdev do.
+	 */
 	init_completion(&adap->dev_released);
 	device_unregister(&adap->dev);
-
-	/* wait for sysfs to drop all references */
 	wait_for_completion(&adap->dev_released);
=20
 	/* free bus id */


Thanks for all the input, it is very much appreciated!

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUvj1sAAoJEBQN5MwUoCm21voP/RGyoF9auSnOpttw4wFjoBJw
n9t+N6mAo6eO5zpgZ748HRmP99HXZKCEnz7danIfgYddMRl4GAQe0JQdGh9lYbzM
vbQ+tzJaWjFgyHrMpeVIRpEVs9C705Vwh1hnYA1omxTfJnhkQ4DpzePFvTsEC8R/
CLrDCdoRLemD3Dq1Zey9lfYNuHyysbzRN+Z5ztYIrlIPQ9Jj1crPFBPR2euipsLH
v986DrvPPCJ0vU3FjeR7DVAiWi+3ap885zNs30xiRSMYuekUeFQJUMlPAj3WvXQF
7tIeGsvL7Cv7gckS8yq61Yf2ZyjC2zjga0/HeTKRp/bvTacF/hvKeLUyPlazJxxm
oGWLIZYGSGau+/auJz+Af2cld3eiKjAq6nMHbQOu5cbuB5soyK/FlK1GfeFCP0AX
84EV5UmrFdo/LkaCvvTUIJy15kIRxUjU2r/Fdlr2WLeTnAECIqFuVBlAuc4UwAi2
B7Waf/pX7phVyuJdALXvzMiDtziMKchSyg3A1iuWnCFqicMBSJaXLVj9TONoPfYA
MOiy4Y7a2fnvkapxu9YH8xV3Sj4TN2XCsoB9EYfYIK7kf9SA/r4/xAPGSKB1nQ41
ZJKvC4M3dnAAsZ3VwqesFKC8oKTy/gicr+dTFSbpFPlp2314dC86Fcqxnq+AIqco
GaRpIu/Gy9u1+9zEPxPN
=z8hT
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
