Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaJJSZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 14:25:24 -0400
Received: from sauhun.de ([89.238.76.85]:49536 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbaJJSZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 14:25:23 -0400
Date: Fri, 10 Oct 2014 20:26:05 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org, cocci@systeme.lip6.fr,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] drop owner assignment from platform_drivers
Message-ID: <20141010182604.GC6075@katana>
References: <20141010072439.GA1741@katana>
 <20141010083627.GL5182@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+nBD6E3TurpgldQp"
Content-Disposition: inline
In-Reply-To: <20141010083627.GL5182@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+nBD6E3TurpgldQp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 10, 2014 at 09:36:27AM +0100, Russell King - ARM Linux wrote:
> On Fri, Oct 10, 2014 at 09:24:39AM +0200, Wolfram Sang wrote:
> > people found out that for platform_driver, we don't need to set the
> > .owner field because this is done by the platform driver core. So far,
> > so good. However, now I got patches removing the .owner field for this
> > single i2c driver or for that one. To prevent getting thousands of
> > patches fixing single drivers, I used coccinelle to remove all instances
> > from the kernel. The SmPL looks like this, it doesn't blindly remove all
> > THIS_MODULE, but checks if the platform_driver struct was really used by
> > a call actually setting the .owner field:
>=20
> Is this correct?
>=20
> #define platform_driver_register(drv) \
>         __platform_driver_register(drv, THIS_MODULE)
> extern int __platform_driver_register(struct platform_driver *,
>                                         struct module *);
>=20
> Fine for those which use platform_driver_register(), but:
>=20
> /* non-hotpluggable platform devices may use this so that probe() and
>  * its support may live in __init sections, conserving runtime memory.
>  */
> extern int platform_driver_probe(struct platform_driver *driver,
>                 int (*probe)(struct platform_device *));
>=20
> platform_driver_probe() doesn't seem to know which module called it.
> This is also true of platform_create_bundle:
>=20
> extern struct platform_device *platform_create_bundle(
>         struct platform_driver *driver, int (*probe)(struct platform_devi=
ce *),
>         struct resource *res, unsigned int n_res,
>         const void *data, size_t size);
>=20
> So, it's not as trivial as just "all platform driver's should not have a
> .owner field" - the real answer is far more complex than that.

platform_create_bundle() calls platform_driver_probe().
platform_driver_probe() calls platform_driver_register().
platform_driver_register() modifies driver.owner.

So, it is correct from the point of view that it doesn't make sense to
set the .owner field if it gets overwritten anyhow.

You got me wondering, though, that it could not be correct to call
platform_driver_register() from the platform core instead of module
init. I will check tomorrow. Still, this would be a bug independent of
my series. Although I'd need to respin it if platform_driver_probe()
needed a fix.

Thanks,

   Wolfram


--+nBD6E3TurpgldQp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUOCS8AAoJEBQN5MwUoCm2lwIP/jzWKs2TLozBIKj77Uuusj7y
BU9EfbVBVbSNsG7iC5ZXh+ik2GzvgjNXzjNClD8ipDKFdp24lZ+Lsmfm70EdWLpe
+Chq9ozkUnscArlCe7Q1N5/F6fagsmGstbNe8yKWxI1pUdXWt4K+VcKjuqv510HY
f5XX3z2pDXGHolFt5NyDXEfzKgNI2UK+LDAMWimhjruCBrKKS80OG7HP9TX5k/+f
veDdP1mqEMPW64v79KRkcOsoXX6wQQ9x3bs8MWXaE1hk0gIwJ/L76SmJbOjUzbaY
WaMkV0XyJaO2so85CQWc/5tkOjLXnwOYyZNczJMk7ORvw7vP8wsLhKCtrPATyN15
Mq7yHlgyKQfn+ewne28tQ3mkkCekiu/kZShERjHkdKXng4p3ZuyMDeIVyfMZydLT
tvpxaGTesvm1b9FHBsPJvTgx5xIBUlfyZBJWkledsQadqB4WTFyzRHzX1dSrawoS
jNfFikNFmBWqkfQadtW8J6kV2dPoOoR9G38h8/34PW0weWJ9g3ZnUqIo7GM73b0w
HNh8/vDmLzD6b7VSiABKXqNNFdso4uQNEjD36azEoJ2G93ClUPjvROfl/ssw/jzJ
0v/rt7RiqvnjRJIwd7yReB3ynE6DVVv/ZXce7u3uiSuSSGkBvrU5lR1vb2VZJ/9r
LSCJ887vhplRtmEJeO5L
=vJvQ
-----END PGP SIGNATURE-----

--+nBD6E3TurpgldQp--
