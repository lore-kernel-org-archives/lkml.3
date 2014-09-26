Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaIZIGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 04:06:06 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:54542 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785AbaIZIF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 04:05:56 -0400
Date: Fri, 26 Sep 2014 10:05:52 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "chris@zankel.net" <chris@zankel.net>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "deller@gmx.de" <deller@gmx.de>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>,
        "jesper.nilsson@axis.com" <jesper.nilsson@axis.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "monstr@monstr.eu" <monstr@monstr.eu>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "sam@ravnborg.org" <sam@ravnborg.org>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "starvik@axis.com" <starvik@axis.com>,
        "takata@linux-m32r.org" <takata@linux-m32r.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "daniel.thompson@linaro.org" <daniel.thompson@linaro.org>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 00/17] Cross-architecture definitions of relaxed MMIO
 accessors
Message-ID: <20140926080551.GD31106@ulmo>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
 <20140925145538.GN20043@arm.com>
 <3361270.4SkjDs5lox@wuerfel>
 <4240583.SJ4jiIW6Zy@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hf61M2y+wYpnELGG"
Content-Disposition: inline
In-Reply-To: <4240583.SJ4jiIW6Zy@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Hf61M2y+wYpnELGG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 25, 2014 at 05:15:14PM +0200, Arnd Bergmann wrote:
> On Thursday 25 September 2014 17:07:47 Arnd Bergmann wrote:
>=20
> > The current version doesn't let you do that, so I'll keel the #ifdef
> > sections separate. This also means that I won't apply your patch 17:
> > we will keep needing the #ifdef to support all three relevant combinati=
ons:
> >=20
> > a) architectures that provide neither and want to get the defaults
> >    from asm-generic
> > b) architectures that provide the non-relaxed versions and want tog
> >    to get just the relaxed version from asm-generic
> > c) architectures that provide both
> >=20
>=20
> And here is the new version I applied:
>=20
> diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
> index 508a57257de5..3e976be3bdd4 100644
> --- a/include/asm-generic/io.h
> +++ b/include/asm-generic/io.h
> @@ -174,6 +174,43 @@ static inline void writeq(u64 value, void __iomem *a=
ddr)
>  #endif /* CONFIG_64BIT */
> =20
>  /*
> + * {read,write}{b,w,l,q}_relaxed() are like the regular version, but
> + * are not guaranteed to provide ordering against spinlocks or memory
> + * accesses.
> + */
> +#ifndef readb_relaxed
> +#define readb_relaxed readb
> +#endif

My original patch to consolidate the read*/write*() and friends
explicitly avoided the use of macros to do this. The reason was that if
we have static inline functions in asm-generic/io.h it defines the
canonical prototype of these functions, so that architectures that want
to override them can just copy the prototype from there.

So for consistency the above would become:

	#ifndef readb_relaxed
	#define readb_relaxed readb_relaxed
	static inline u8 readb_relaxed(const void __iomem *addr)
	{
		return readb(addr);
	}
	#endif

And analogously for the others. For the *_relaxed variants it's perhaps
not as important because the signature is the same as for the plain
variants, so I'm not objecting very strongly to the plain macros.

Thierry

--Hf61M2y+wYpnELGG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUJR5fAAoJEN0jrNd/PrOhXDEQAJASuQ1ZZOpReq+GOvsG1PVd
g7cPitKlomR1SIi8YZIwg/04kgxegXJDvJarh+Xm4EhsQQTcQQB/7vDZ45mKA276
G6nQyc9+gvglI3qaX6450dRDnYS12h5yM1TWAXCMwYOLV0etfiUDzYG6FJinWU01
T9KLWXkOB9UaKgaS5d75kKJ1v9IgPZ0JlGqp0WcODYvl1NR9w7K5sTYeevPRE67Y
/Y1IZe3dzc8E3AEU4sBPt0BP9gEzehEoj9fd/31CHtuy3PGD+WlOOiYtmYq/CwCn
bMbxJqJh5EKVPgbRObD6IMNCFpvIyUoZx0JBkqdhfR8P2G4juFYudv7Mea5qk9FZ
g0OjZ/nE32qliI0hPSWG+iVjTxBIDjEpPr1gUD+JApwc8VGM0nznaHgGwz2usNA0
MvJOLl6HoFDw0AOWhm3Dq4qywtzJyAqvfyJ1Ed41sJiHrnUbRlm0cdOEGXDOBAN0
kUrvxDsMhnpjod/DktHP9q3ac00sN2H4h0lZDnKduMwNH1xtwdEVKu5/gtz9LfYa
Nw3AA3KOwk3nDePm8LBpCH+c0HTh5aynIMsXxPEZ8bA/bDS4e/L23KsEuEshd4Y/
7ioprLVjOY8Xwn0Ea2sbJAVCvPsiyb9mpQ/Es9U9J/hsqyEeph8pmV7y2SSBkEKB
cI29kXD4/20UJ/h+OdgX
=nICm
-----END PGP SIGNATURE-----

--Hf61M2y+wYpnELGG--
