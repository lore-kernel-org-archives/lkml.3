Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaBLFZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 00:25:07 -0500
Received: from ozlabs.org ([203.10.76.45]:44076 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbaBLFZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 00:25:05 -0500
Date: Wed, 12 Feb 2014 16:25:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: linux-next: build failure after merge of the final tree (cgroup
 tree related)
Message-Id: <20140212162500.242e91e4cc3541b992fa3a0c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__12_Feb_2014_16_25_00_+1100_QkOsFjCyETRGSVJN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Feb_2014_16_25_00_+1100_QkOsFjCyETRGSVJN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc defconfig)
failed like this:

arch/sparc/kernel/sun4m_irq.c: In function 'sun4m_build_device_irq':
arch/sparc/kernel/sun4m_irq.c:266:2: error: implicit declaration of functio=
n 'kzalloc' [-Werror=3Dimplicit-function-declaration]
arch/sparc/kernel/sun4m_irq.c:266:15: error: assignment makes pointer from =
integer without a cast [-Werror]

Presumably caused by commit 2bd59d48ebfb ("cgroup: convert to kernfs")
(see the comment in commit 1ff6bbfd13ca ("arm, pm, vmpressure: add
missing slab.h includes")).  I wonder how mane more builds are broken by
this :-(

Indeed, reverting that commit fixes the build.

I have added the following build fix for today (please check the
overnight builds for more breakage):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 12 Feb 2014 16:01:10 +1100
Subject: [PATCH] sun4M: add include of slab.h for kzalloc

This was being included implicitly via cgroup.h's inclusion of xattr.h
(which has now been removed).

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/sparc/kernel/sun4m_irq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/sparc/kernel/sun4m_irq.c b/arch/sparc/kernel/sun4m_irq.c
index c5ade9d27a1d..8bb3b3fddea7 100644
--- a/arch/sparc/kernel/sun4m_irq.c
+++ b/arch/sparc/kernel/sun4m_irq.c
@@ -9,6 +9,8 @@
  *  Copyright (C) 1996 Dave Redman (djhr@tadpole.co.uk)
  */
=20
+#include <linux/slab.h>
+
 #include <asm/timer.h>
 #include <asm/traps.h>
 #include <asm/pgalloc.h>
--=20
1.9.rc1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__12_Feb_2014_16_25_00_+1100_QkOsFjCyETRGSVJN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS+wWwAAoJEMDTa8Ir7ZwV0TUP/28n2eb0TPtm3kR05jTkHti0
e4R8Ccst50p0c6Y1JbcnGWitoJ+n4Bk42+nRiS6Ji4n0jpxE0NsVQ13TVxICV3QI
2Apd+T677u7r/aNGFSyI9UgySgCcNG7Sbbee54so/QyH1PIZaNI3fFYNzGhtS0MG
laU1d4DMxdO4hTyiyRIIP0MM1g/2HoeoN24i0T0Jb2LKRQrAcOAvS2M1RLtEalCF
U4to7rQfIO3M9bqbOjWYOvniX4UOeX5135ZOFxrOtSxD3aVl2gS6D+7z4sBP9P65
J6ppns47NqpiYOcZwHNGzIkOD0KzGMftGwTRtxWSvzt7BCpPkekZCqU/0p274kNK
spnxOb2jSTlvjY5JUNrhMftFIFVJjq4MMIjMXqbjXTK4qgmXThH3G2lVpmAuJ+0x
yqwFh7qQnR8/Oy/xVnCr1SMtSQOaKjZhjtVp1WduXGDCDLVOH9VF5tfPId9ghZRX
MJfvzp8Thg17+lHDvXi61I73sb2RfUinQoh3f0uVk6+062Rb/Nuiu1X4uZDb6qQX
rXwkea5VmGTLFwlIDglZ1Dnkh9SAoFgUXqMoM/R+UODcrYRDCHdVnx0uHeni2NM5
kceoN0bTxCDTWzwIfmjKgOXHZQk0IloRRxHLFHwRwxYILIdAm8Xis8pqIbwEQU0Y
0y27oxtXbaW9QwHI5QQM
=1xUE
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Feb_2014_16_25_00_+1100_QkOsFjCyETRGSVJN--
