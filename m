Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaJJHYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 03:24:04 -0400
Received: from sauhun.de ([89.238.76.85]:45230 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbaJJHYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 03:24:00 -0400
Date: Fri, 10 Oct 2014 09:24:39 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, cocci@systeme.lip6.fr,
        kernel-janitors@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Subject: [RFC] drop owner assignment from platform_drivers
Message-ID: <20141010072439.GA1741@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

people found out that for platform_driver, we don't need to set the
=2Eowner field because this is done by the platform driver core. So far,
so good. However, now I got patches removing the .owner field for this
single i2c driver or for that one. To prevent getting thousands of
patches fixing single drivers, I used coccinelle to remove all instances
=66rom the kernel. The SmPL looks like this, it doesn't blindly remove all
THIS_MODULE, but checks if the platform_driver struct was really used by
a call actually setting the .owner field:

=3D=3D=3D

@match1@
declarer name module_platform_driver;
declarer name module_platform_driver_probe;
identifier __driver;
@@
(
	module_platform_driver(__driver);
|
	module_platform_driver_probe(__driver, ...);
)

@fix1 depends on match1@
identifier match1.__driver;
@@
	static struct platform_driver __driver =3D {
		.driver =3D {
-			.owner =3D THIS_MODULE,
		}
	};

@match2@
identifier __driver;
@@
(
	platform_driver_register(&__driver)
|
	platform_driver_probe(&__driver, ...)
|
	platform_create_bundle(&__driver, ...)
)

@fix2 depends on match2@
identifier match2.__driver;
@@
	static struct platform_driver __driver =3D {
		.driver =3D {
-			.owner =3D THIS_MODULE,
		}
	};

=3D=3D=3D

I tried to group the changes. The current granularity is directory
level. The resulting branch can be found here (it is based on linux-next
of yesterday):

git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git drop_platform_d=
river_owner

This still results in 300 patches as this shortened pull request shows:

=3D=3D=3D

Wolfram Sang (299):
      ARM: common: drop owner assignment from platform_drivers
      ARM: mach-davinci: drop owner assignment from platform_drivers
      ARM: mach-imx: drop owner assignment from platform_drivers
=2E..
      ASoC: txx9: drop owner assignment from platform_drivers
      ASoC: ux500: drop owner assignment from platform_drivers
      ALSA: sparc: drop owner assignment from platform_drivers

 arch/arm/common/sa1111.c                                         | 1 -
 arch/arm/mach-davinci/cpuidle.c                                  | 1 -
 arch/arm/mach-davinci/pm.c                                       | 1 -
=2E..
 sound/sparc/amd7930.c                                            | 1 -
 sound/sparc/cs4231.c                                             | 1 -
 sound/sparc/dbri.c                                               | 1 -
 1688 files changed, 1718 deletions(-)

=3D=3D=3D

I don't want to send all 300 patches to lkml. I still think, they should
go via subsystems, though, and not via a single pull request. So, I am
working on just sending smaller pieces of this huge series to the
apropriate mailing lists (like arm, netdev...) as an independent series.
Then, each subsystem can decide if the patches should be further folded.
In my experience, this mileage varies from subsystem to subsystem.

That's my plan for today. If you have comments, other suggestions or
remarks, I'd like to hear them.

Thanks,

   Wolfram


--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUN4m3AAoJEBQN5MwUoCm2N2EP/3HUEgD9V2+qrXwwNDOyl4LR
0W6SBsmY/KJUomWr8ODeK3xo6J3Dy1NCCq5psnJQSBe/4ss99D8kKhbcad99329D
YIxDk9qbN1fyQFUtMrsrqC8+h15PUOcX3xpy3SEwyICGHh4aepZsWKZwTTfrZVAm
Hd2RfeWSs0dxClV0hepkk3pyu8K1l7sYMjEkNnmcDiPDfXxvgWYfwL5/bGO8fXyD
aafUAZt7aQnjKN8Rwxf3lf3wbVaMCMGm3xxA82YsSXLDuqEq2E4dShmXqTWzQW8L
9jD7Wm/w6hT6K2ThzvvWdI3he4OM2gSCK8/jgluvU4HbLYf08zdViDM1NTGDEWxZ
OvGWevRmXzWp370rOo10qoqBNHyFJy+QGv0Oz87ujqoHAPjlJWq1RJFt9aGbFmH2
N4DBvX1BeWICtX7ZsETDK2YCyZK0pyRgUFHvY724rVZ3uqL0/B+TOsz9bEN2V5Y3
joz6rvcpWqfu/1nFNWCaTERXHHkvYHp0Gj2Kr8vlkf+jlmz9a+dHP2E/jjY6cZZZ
DK2RDSXHqpB9jrAqjnA2glnR8lezYjunPo/9nE/E2h2TgM6G+liVbPt6scU/7msa
6/N18/yAeGtWTknr5xcJWUFLz5ee+TMNsY95ePmAifXUN4Nxu0GveIxXOleCETcY
yQGcqg1FFEjucfokcWuc
=zi40
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
