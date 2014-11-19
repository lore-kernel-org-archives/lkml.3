Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbaKSHyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 02:54:25 -0500
Received: from ozlabs.org ([103.22.144.67]:39552 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824AbaKSHyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 02:54:23 -0500
Date: Wed, 19 Nov 2014 18:54:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: linux-next: build failure after merge of the asm-generic tree
Message-ID: <20141119185414.4ab8e35d@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Vjvyd9JaeUv//HCqsuK2_y="; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Vjvyd9JaeUv//HCqsuK2_y=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

After merging the asm-generic tree, today's linux-next build (sparc
defconfig) failed like this:

In file included from include/linux/io.h:22:0,
                 from include/linux/irq.h:23,
                 from include/asm-generic/hardirq.h:12,
                 from arch/sparc/include/asm/hardirq_32.h:10,
                 from arch/sparc/include/asm/hardirq.h:6,
                 from include/linux/hardirq.h:8,
                 from include/linux/memcontrol.h:24,
                 from include/linux/swap.h:8,
                 from arch/sparc/include/asm/pgtable_32.h:17,
                 from arch/sparc/include/asm/pgtable.h:6,
                 from include/linux/mm.h:52,
                 from include/linux/pagemap.h:7,
                 from include/linux/blkdev.h:14,
                 from init/do_mounts.h:2,
                 from init/do_mounts_rd.c:21:
arch/sparc/include/asm/io.h:14:0: warning: "readb_relaxed" redefined
 #define readb_relaxed(__addr)  readb(__addr)
 ^
In file included from arch/sparc/include/asm/io_32.h:13:0,
                 from arch/sparc/include/asm/io.h:6,
                 from include/linux/io.h:22,
                 from include/linux/irq.h:23,
                 from include/asm-generic/hardirq.h:12,
                 from arch/sparc/include/asm/hardirq_32.h:10,
                 from arch/sparc/include/asm/hardirq.h:6,
                 from include/linux/hardirq.h:8,
                 from include/linux/memcontrol.h:24,
                 from include/linux/swap.h:8,
                 from arch/sparc/include/asm/pgtable_32.h:17,
                 from arch/sparc/include/asm/pgtable.h:6,
                 from include/linux/mm.h:52,
                 from include/linux/pagemap.h:7,
                 from include/linux/blkdev.h:14,
                 from init/do_mounts.h:2,
                 from init/do_mounts_rd.c:21:
include/asm-generic/io.h:183:0: note: this is the location of the previous =
definition
 #define readb_relaxed readb
 ^

And many, many more :-(

Caused by commit 1191ccb34cf8 ("sparc: io: implement dummy relaxed
accessor macros for writes").

I applied the following fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 19 Nov 2014 18:49:07 +1100
Subject: [PATCH] sparc: io: fix for implement dummy relaxed accessor macros=
 for writes

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/sparc/include/asm/io.h    | 9 ---------
 arch/sparc/include/asm/io_32.h | 9 +++++++++
 arch/sparc/include/asm/io_64.h | 9 +++++++++
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/sparc/include/asm/io.h b/arch/sparc/include/asm/io.h
index 493f22c4684f..f6902cf3cbe9 100644
--- a/arch/sparc/include/asm/io.h
+++ b/arch/sparc/include/asm/io.h
@@ -10,15 +10,6 @@
  * Defines used for both SPARC32 and SPARC64
  */
=20
-/* Relaxed accessors for MMIO */
-#define readb_relaxed(__addr)		readb(__addr)
-#define readw_relaxed(__addr)		readw(__addr)
-#define readl_relaxed(__addr)		readl(__addr)
-
-#define writeb_relaxed(__b, __addr)	writeb(__b, __addr)
-#define writew_relaxed(__w, __addr)	writew(__w, __addr)
-#define writel_relaxed(__l, __addr)	writel(__l, __addr)
-
 /* Big endian versions of memory read/write routines */
 #define readb_be(__addr)	__raw_readb(__addr)
 #define readw_be(__addr)	__raw_readw(__addr)
diff --git a/arch/sparc/include/asm/io_32.h b/arch/sparc/include/asm/io_32.h
index 407ac14295f4..9484c8ec18cf 100644
--- a/arch/sparc/include/asm/io_32.h
+++ b/arch/sparc/include/asm/io_32.h
@@ -4,6 +4,15 @@
 #include <linux/kernel.h>
 #include <linux/ioport.h>  /* struct resource */
=20
+/* Relaxed accessors for MMIO */
+#define readb_relaxed(__addr)		readb(__addr)
+#define readw_relaxed(__addr)		readw(__addr)
+#define readl_relaxed(__addr)		readl(__addr)
+
+#define writeb_relaxed(__b, __addr)	writeb(__b, __addr)
+#define writew_relaxed(__w, __addr)	writew(__w, __addr)
+#define writel_relaxed(__l, __addr)	writel(__l, __addr)
+
 #define IO_SPACE_LIMIT 0xffffffff
=20
 #define memset_io(d,c,sz)     _memset_io(d,c,sz)
diff --git a/arch/sparc/include/asm/io_64.h b/arch/sparc/include/asm/io_64.h
index d50e6127325d..078f600376c6 100644
--- a/arch/sparc/include/asm/io_64.h
+++ b/arch/sparc/include/asm/io_64.h
@@ -265,6 +265,15 @@ static inline void iowrite32_rep(void __iomem *port, c=
onst void *buf, unsigned l
 	outsl((unsigned long __force)port, buf, count);
 }
=20
+/* Relaxed accessors for MMIO */
+#define readb_relaxed(__addr)		readb(__addr)
+#define readw_relaxed(__addr)		readw(__addr)
+#define readl_relaxed(__addr)		readl(__addr)
+
+#define writeb_relaxed(__b, __addr)	writeb(__b, __addr)
+#define writew_relaxed(__w, __addr)	writew(__w, __addr)
+#define writel_relaxed(__l, __addr)	writel(__l, __addr)
+
 /* Valid I/O Space regions are anywhere, because each PCI bus supported
  * can live in an arbitrary area of the physical address range.
  */
--=20
2.1.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Vjvyd9JaeUv//HCqsuK2_y=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUbEytAAoJEMDTa8Ir7ZwVoocP/A2AS8rhujlduPNnx2NAIvx+
WkgGyyTAsMrRkwlaZ+U8B2OQWHL6lbO25OFCwDpiHr+nQFRVBxOFykrdMWo9Fnf6
RR7+bt6B2fYgWZSBg2g5V4aw8Y4+iScq6ZN+7nTk7/yWnxbTOMKeUWLuusI6YU2U
IkSTDUtQjr6lB4Bxs07LKLUvXEJWCzxEKPOZMB3O0cL7/h7m9sgdnkwVdK135V+7
C8Ockb1clGGkV3a+Im87//PC5diaeBX5qPTSdsfCAGMpf9ftrXLU4byH8Hg0iPPu
BLQXv6D8A1MPCFng+8emSg/Rf0F14Qmg69048K5yhDGTvUGlpo9mqcyA7hg0cVUU
2NNBblwqmqhyfiDcz79gtteDmKw31NhqsWZ3YlT1S6/hLTVO2dx0rVLoyvQme0R+
fX4YGs8ZB/71skwoA0DJp3xcTdBakDz7L+93Sf2lTmMQVLI7OQ32bhpZjzpirSSQ
zvEej8YuV2goKHxVjiLV0BuZZb2Ldc4GjbVVk/i0r1aj2xmaQSVK+awGcn+rqm0G
9olEYMwWtR9kpZBbBDIrWfHLDwrDLO2wH7E4osTs3XScBYtX/POMQEIEhsy3Xy3Y
Sy4UOVNVmSaTfO1jRyUE4i3Tna/SAx/KEhWg8VbLjpX4+oHUkdLd1mInIa1nvbhL
MGS6bxpMARgL6b5ncqfd
=nEig
-----END PGP SIGNATURE-----

--Sig_/Vjvyd9JaeUv//HCqsuK2_y=--
