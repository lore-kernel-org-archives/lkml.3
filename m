Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaHEDJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 23:09:36 -0400
Received: from ozlabs.org ([103.22.144.67]:45255 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbaHEDJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 23:09:34 -0400
Date: Tue, 5 Aug 2014 13:09:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Wood <thomas.wood@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        YoungJun Cho <yj44.cho@samsung.com>, Inki Dae <daeinki@gmail.com>,
        Rahul Sharma <rahul.sharma@samsung.com>
Subject: linux-next: build failures after merge of the drm tree
Message-ID: <20140805130926.4e8c8fe5@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/zNlNE3wk/xPH4vpTN0Bg=IN"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/zNlNE3wk/xPH4vpTN0Bg=IN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the drm tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "drm_sysfs_connector_remove" [drivers/gpu/drm/i2c/tda998x.ko] undefi=
ned!
ERROR: "drm_sysfs_connector_add" [drivers/gpu/drm/i2c/tda998x.ko] undefined!

Caused by commit c707c3619ca8 ("drm/i2c: tda998x: add component
support") interacting with commit 34ea3d386347 ("drm: add register and
unregister functions for connectors").  Maybe it should have been fixed
up in the merge commit 920f946428b7 ("Merge branch 'tda998x-devel' of
git://ftp.arm.linux.org.uk/~rmk/linux-cubox into drm-next")?

I reverted commit c707c3619ca8 for today.

But then the arm multi_v7_defconfig build produced these errors:

ERROR (phandle_references): Reference to non-existent node or label "disp_p=
d"

ERROR: Input tree has errors, aborting (use -f to force output)
make[2]: *** [arch/arm/boot/dts/exynos5420-arndale-octa.dtb] Error 2
make[2]: *** Waiting for unfinished jobs....
ERROR (phandle_references): Reference to non-existent node or label "disp_p=
d"

ERROR: Input tree has errors, aborting (use -f to force output)
make[2]: *** [arch/arm/boot/dts/exynos5420-smdk5420.dtb] Error 2
ERROR (phandle_references): Reference to non-existent node or label "disp_p=
d"

ERROR: Input tree has errors, aborting (use -f to force output)
ERROR (phandle_references): Reference to non-existent node or label "disp_p=
d"

make[2]: *** [arch/arm/boot/dts/exynos5800-peach-pi.dtb] Error 2
ERROR: Input tree has errors, aborting (use -f to force output)

Caused by commit 5a8da524049c ("ARM: dts: exynos5420: add dsi node")
interacting with commit d51cad7df871 ("ARM: dts: remove display power
domain for exynos5420") from the arm-soc tree.

I applied this merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 5 Aug 2014 13:03:01 +1000
Subject: [PATCH] ARM: dts: exynos5420: remove disp_pd

per comit d51cad7df871 ("ARM: dts: remove display power
domain for exynos5420").

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/arm/boot/dts/exynos5420.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos54=
20.dtsi
index 95ec37dff3e8..bfe056d9148c 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -525,7 +525,6 @@
 		compatible =3D "samsung,exynos5410-mipi-dsi";
 		reg =3D <0x14500000 0x10000>;
 		interrupts =3D <0 82 0>;
-		samsung,power-domain =3D <&disp_pd>;
 		phys =3D <&mipi_phy 1>;
 		phy-names =3D "dsim";
 		clocks =3D <&clock CLK_DSIM1>, <&clock CLK_SCLK_MIPI1>;
--=20
2.0.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/zNlNE3wk/xPH4vpTN0Bg=IN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT4ErrAAoJEMDTa8Ir7ZwVRHsQAIq9BrNPUaozv163TqHSq8KT
jWTLE1ZsvnUB/qWS8qSJuVnGAX6SqWk4HqJ4OXMQeZxYXwmRz7UAXuqlFmiJEBpN
DTvPZNkxf9ASrC8h+wuAs84vzaQUU3n4wAjCfvxu1ZofWGofwUWuyyWzKGQ2q0ZX
W92d3vlp/CpqAgv8ycIgn63OXXQhh7nQVL/jRxevtZp67qmVg1rEoHnQJAjzPZFq
CmNH6IYAUCCbPKX0CimLMxIJm2mKrQ/QJ9kJzwr6PyI1nZ9qvvXMhJT0JTiDMECk
1xM9VRmDTQrQJ5B6r06pPf7zTOqQwvOK3t2cDnXlLYi/RkFF7sYUv7yopFeLdyeB
f6PkK8KPs4HK/z9Gc0NgiJhCRbIj472wZXfzZXyAezCaHMUq4rgj2BKkdbgUWFlO
zZhw6cEXpcLUDCIXe5Pt+LLmDnXcjBbj3OaU8bSQRVQlf1D26aUfZtmLa8Ek/K6F
oCLyt9hnyVFNdK/Rz3Yr3WIdaLogNPjdOI0KtfGRJfuBU9V70N6nlF6Am5igSlYn
RgXnivH5xwK91IyzA4go4v3XhT634OMMIzFxfI/xbvoY9KRFAAz4B7i1U5tzMaUH
mQ1FRLpslFTHysHZC+jcqBhRwxa90bMHf4k3RSQioFgU/7t+OLaTV78efbqAXR2T
qqiMSUzuZp70jlzAv+p0
=lGBR
-----END PGP SIGNATURE-----

--Sig_/zNlNE3wk/xPH4vpTN0Bg=IN--
