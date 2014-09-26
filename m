Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbaIZKDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:03:07 -0400
Received: from ozlabs.org ([103.22.144.67]:54339 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755157AbaIZKDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:03:03 -0400
Date: Fri, 26 Sep 2014 20:02:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: linux-next: build failure after merge of the asm-generic tree
Message-ID: <20140926200251.78f0d713@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/yb+8xIKGiuav0vrI.v1y4lU"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/yb+8xIKGiuav0vrI.v1y4lU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

After merging the asm-generic tree, today's linux-next build (sparc
defconfig) failed like this:

In file included from /scratch/sfr/next/include/linux/clocksource.h:19:0,
                 from /scratch/sfr/next/arch/sparc/include/asm/timer_32.h:1=
1,
                 from /scratch/sfr/next/arch/sparc/include/asm/timer.h:6,
                 from /scratch/sfr/next/arch/sparc/kernel/sun4m_irq.c:14:
/scratch/sfr/next/arch/sparc/include/asm/io.h:14:0: error: "readb_relaxed" =
redefined [-Werror]
 #define readb_relaxed(__addr)  readb(__addr)
 ^
In file included from /scratch/sfr/next/arch/sparc/include/asm/io_32.h:13:0,
                 from /scratch/sfr/next/arch/sparc/include/asm/io.h:6,
                 from /scratch/sfr/next/include/linux/clocksource.h:19,
                 from /scratch/sfr/next/arch/sparc/include/asm/timer_32.h:1=
1,
                 from /scratch/sfr/next/arch/sparc/include/asm/timer.h:6,
                 from /scratch/sfr/next/arch/sparc/kernel/sun4m_irq.c:14:
/scratch/sfr/next/include/asm-generic/io.h:182:0: note: this is the locatio=
n of the previous definition
 #define readb_relaxed readb
 ^

And so on several hundred times ... :-(

Caused by commits 95a668b0452e ("sparc: io: implement dummy relaxed
accessor macros for writes") and 4c255791ffd6 ("asm-generic: io:
implement relaxed accessor macros as conditional wrappers").

arch/sparc/include/asm_32.h includes asm-generic/io.h which means it is
include before the arch specific versions of the relaxed functions are
defined ...

I have added this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 26 Sep 2014 19:57:03 +1000
Subject: [PATCH] sparc: io: fix for asm-generic: io: implement relaxed
 accessor macros as conditional wrappers

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/sparc/include/asm/io.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/sparc/include/asm/io.h b/arch/sparc/include/asm/io.h
index 493f22c4684f..79b167674010 100644
--- a/arch/sparc/include/asm/io.h
+++ b/arch/sparc/include/asm/io.h
@@ -1,10 +1,5 @@
 #ifndef ___ASM_SPARC_IO_H
 #define ___ASM_SPARC_IO_H
-#if defined(__sparc__) && defined(__arch64__)
-#include <asm/io_64.h>
-#else
-#include <asm/io_32.h>
-#endif
=20
 /*
  * Defines used for both SPARC32 and SPARC64
@@ -19,6 +14,12 @@
 #define writew_relaxed(__w, __addr)	writew(__w, __addr)
 #define writel_relaxed(__l, __addr)	writel(__l, __addr)
=20
+#if defined(__sparc__) && defined(__arch64__)
+#include <asm/io_64.h>
+#else
+#include <asm/io_32.h>
+#endif
+
 /* Big endian versions of memory read/write routines */
 #define readb_be(__addr)	__raw_readb(__addr)
 #define readw_be(__addr)	__raw_readw(__addr)
--=20
2.1.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/yb+8xIKGiuav0vrI.v1y4lU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUJTnQAAoJEMDTa8Ir7ZwVzZcQAIIlPmj9pGDPqbRFIRISqv4R
zAb0LkEN/FLxPnPyihurSVA0R8DbtC2Hsi68sgcSShLNdOLRsQbqZ4JxmMexNKyJ
i9UNdBBkK7I4fKNDwp+/LxN9+Fn9ZeEP0lwS+Z02DRWnaOKbadCemHN8JSJGyJHU
OaXgSA+6u2z2rpUlRrbVi0NkUCFBWohV3Tt6Puz6uMgP10/aFT0ejJBZ4eG7Z0vi
1j28ifnb5PDYb6kVj1YTaw1CHhclWSWLE0URHtIKTC2YE3tLGz4LL55GopUMDXHU
saFsUlqyIxCv+xnFgiCyI9s/DRincSXpOLKF1ehDD+8Acs+bf94e7A5A2cbZw0Ee
thMyzBeIHat0RiRZHiI/wkzX7EQN99IU7VladI/tVUOAh/TeeHf+oFWnXphcY9cr
4ns1lF4Tiwh+ZTJZF+JwLcxQEUaKQsTOJIQOHC5CPNL8bIGVU3GOBQlA/Lf0HdTF
ZPmuvMx/P8KUNNKZib7HjNdMyalHf8YOeHbnSCnwp+tz8iXKFCKrjAqrcp09/Fxk
JQYDPMlk3RPEO15FpLqTKCiTkqBYFYl54730nYs2wX+4W74lLzGMLXW7xm2Y7ZsP
vynlgzlpIGL/uMW2JtTzycfpBHrIKYdKlakbwtRa9I8/VGbAje40vbnLDluqRNkv
xxiNcOOyLd6l4HFs7S3d
=aPJY
-----END PGP SIGNATURE-----

--Sig_/yb+8xIKGiuav0vrI.v1y4lU--
