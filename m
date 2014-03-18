Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaCRF6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 01:58:39 -0400
Received: from ozlabs.org ([203.10.76.45]:55862 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbaCRF6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 01:58:38 -0400
Date: Tue, 18 Mar 2014 16:58:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: linux-next: manual merge of the usb tree with the samsung tree
Message-Id: <20140318165829.a13e43598654a1144d0325dd@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__18_Mar_2014_16_58_29_+1100_ZWm+04+XM81cTegN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_Mar_2014_16_58_29_+1100_ZWm+04+XM81cTegN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
Documentation/devicetree/bindings/phy/samsung-phy.txt between commit
ba0d7ed391b7 ("ARM: dts: enable ahci sata and sata phy for exynos5250")
from the samsung tree and commit 06fb01373cae ("phy: Add new Exynos USB
2.0 PHY driver") from the usb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/devicetree/bindings/phy/samsung-phy.txt
index a937f75d062c,28f9edb8f19c..000000000000
--- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
+++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
@@@ -21,38 -21,56 +21,92 @@@ Required properties
  - reg : offset and length of the Display Port PHY register set;
  - #phy-cells : from the generic PHY bindings, must be 0;
 =20
 +Samsung SATA PHY Controller
 +---------------------------
 +
 +SATA PHY nodes are defined to describe on-chip SATA Physical layer contro=
llers.
 +Each SATA PHY controller should have its own node.
 +
 +Required properties:
 +- compatible        : compatible list, contains "samsung,exynos5250-sata-=
phy"
 +- reg : offset and length of the SATA PHY register set;
 +- #phy-cells : from the generic phy bindings;
 +
 +Example:
 +	sata_phy: sata-phy@12170000 {
 +		compatible =3D "samsung,exynos5250-sata-phy";
 +		reg =3D <0x12170000 0x1ff>;
 +		clocks =3D <&clock 287>;
 +		clock-names =3D "sata_phyctrl";
 +		#phy-cells =3D <0>;
 +		samsung,exynos-sataphy-i2c-phandle =3D <&sata_phy_i2c>;
 +		samsung,syscon-phandle =3D <&pmu_syscon>;
 +	};
 +
 +Device-Tree bindings for sataphy i2c client driver
 +--------------------------------------------------
 +
 +Required properties:
 +compatible: Should be "samsung,exynos-sataphy-i2c"
 +- reg: I2C address of the sataphy i2c device.
 +
 +Example:
 +
 +	sata_phy_i2c:sata-phy@38 {
 +		compatible =3D "samsung,exynos-sataphy-i2c";
 +		reg =3D <0x38>;
 +	};
++
+ Samsung S5P/EXYNOS SoC series USB PHY
+ -------------------------------------------------
+=20
+ Required properties:
+ - compatible : should be one of the listed compatibles:
+ 	- "samsung,exynos4210-usb2-phy"
+ 	- "samsung,exynos4x12-usb2-phy"
+ 	- "samsung,exynos5250-usb2-phy"
+ - reg : a list of registers used by phy driver
+ 	- first and obligatory is the location of phy modules registers
+ - samsung,sysreg-phandle - handle to syscon used to control the system re=
gisters
+ - samsung,pmureg-phandle - handle to syscon used to control PMU registers
+ - #phy-cells : from the generic phy bindings, must be 1;
+ - clocks and clock-names:
+ 	- the "phy" clock is required by the phy module, used as a gate
+ 	- the "ref" clock is used to get the rate of the clock provided to the
+ 	  PHY module
+=20
+ The first phandle argument in the PHY specifier identifies the PHY, its
+ meaning is compatible dependent. For the currently supported SoCs (Exynos=
 4210
+ and Exynos 4212) it is as follows:
+   0 - USB device ("device"),
+   1 - USB host ("host"),
+   2 - HSIC0 ("hsic0"),
+   3 - HSIC1 ("hsic1"),
+=20
+ Exynos 4210 and Exynos 4212 use mode switching and require that mode swit=
ch
+ register is supplied.
+=20
+ Example:
+=20
+ For Exynos 4412 (compatible with Exynos 4212):
+=20
+ usbphy: phy@125b0000 {
+ 	compatible =3D "samsung,exynos4x12-usb2-phy";
+ 	reg =3D <0x125b0000 0x100>;
+ 	clocks =3D <&clock 305>, <&clock 2>;
+ 	clock-names =3D "phy", "ref";
+ 	status =3D "okay";
+ 	#phy-cells =3D <1>;
+ 	samsung,sysreg-phandle =3D <&sys_reg>;
+ 	samsung,pmureg-phandle =3D <&pmu_reg>;
+ };
+=20
+ Then the PHY can be used in other nodes such as:
+=20
+ phy-consumer@12340000 {
+ 	phys =3D <&usbphy 2>;
+ 	phy-names =3D "phy";
+ };
+=20
+ Refer to DT bindings documentation of particular PHY consumer devices for=
 more
+ information about required PHYs and the way of specification.

--Signature=_Tue__18_Mar_2014_16_58_29_+1100_ZWm+04+XM81cTegN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTJ+CMAAoJEMDTa8Ir7ZwVQZUP/3Ga+wtPLZp+fXo1IV53uoe+
GsTa+uneOgt9Kxd1qMtEZvVbQeavV31JQ03Tkb+AabH6uAS6Hvn7pVF6oe5kEHbz
HL3uDCAy5iEYLAIMMIad36GlAj+E0LvH5dRYiW97CLyFNLJsL3O1YCqbdYiiaG4j
MHdA3C6QYdzgqyEUWtTbYIb9uqSzysV1E91CE5Wmvw5CEW5P8TwvqzSaKlqRpPML
8zzXucbs4W4iDQlGquBWxD/EKFqEINCt/aeUkOg+Gfbo1OcLIL1VJ9upxT5kTYc1
+axRCMCEz3YxpEKpRQEF34pCP1IkXpe/rYryS/LIY+ldu9/9i56oFjhsc01uqGW/
hD4yuPgyWo9haedMHyZ/bdpf/SG3n3hJtzEDgtAHSllY7ZQvTWu0s6V7bl80E1Ck
AvFYjdLcN0ek2KWTdqDruU1yu8igNRWHbO65MQKVM6/9O6wA3vpQP2U0bCL7szd6
9FUoiyqZ0HV4piHh4Q0r4KFBbilJxeVJNYbZyPVi56AQE6U9W/XIgqTOJHuP39f/
ZfP/7es2eHBLmzFeBXOqhvQU1TvFb4L5vbwuCOJaxMVGym3TksGp96rkwVSDs+Yd
z6U4H3/FHd94VZvwnQ3ppOJpTXblJkLbc/bSyFH3i4qMjkThmwTUH5sJM9XitMGf
BHkdqS4iFr1LivmqX2VW
=cV+c
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Mar_2014_16_58_29_+1100_ZWm+04+XM81cTegN--
