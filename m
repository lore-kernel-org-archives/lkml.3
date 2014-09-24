Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaIXRUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:20:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41619 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751883AbaIXRUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:20:21 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, benh@kernel.crashing.org, chris@zankel.net,
        cmetcalf@tilera.com, davem@davemloft.net, deller@gmx.de,
        dhowells@redhat.com, geert@linux-m68k.org, heiko.carstens@de.ibm.com,
        hpa@zytor.com, jcmvbkbc@gmail.com, jesper.nilsson@axis.com,
        mingo@redhat.com, monstr@monstr.eu, paulmck@linux.vnet.ibm.com,
        rdunlap@infradead.org, sam@ravnborg.org, schwidefsky@de.ibm.com,
        starvik@axis.com, takata@linux-m32r.org, tglx@linutronix.de,
        tony.luck@intel.com, daniel.thompson@linaro.org, broonie@linaro.org,
        linux@arm.linux.org.uk, Will Deacon <will.deacon@arm.com>
Subject: [PATCH v3 13/17] sparc: io: implement dummy relaxed accessor macros for writes
Date: Wed, 24 Sep 2014 18:17:32 +0100
Message-Id: <1411579056-16966-14-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write{b,w,l,q}_relaxed are implemented by some architectures in order to
permit memory-mapped I/O accesses with weaker barrier semantics than the
non-relaxed variants.

This patch adds dummy macros for the write accessors to sparc, in the
same vein as the dummy definitions for the relaxed read accessors. The
existing relaxed read{b,w,l} accessors are moved into asm/io.h, since
they are identical between 32-bit and 64-bit machines.

Acked-by: "David S. Miller" <davem@davemloft.net>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/sparc/include/asm/io.h    | 9 +++++++++
 arch/sparc/include/asm/io_32.h | 4 ----
 arch/sparc/include/asm/io_64.h | 8 ++------
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/sparc/include/asm/io.h b/arch/sparc/include/asm/io.h
index f6902cf3cbe9..493f22c4684f 100644
--- a/arch/sparc/include/asm/io.h
+++ b/arch/sparc/include/asm/io.h
@@ -10,6 +10,15 @@
  * Defines used for both SPARC32 and SPARC64
  */
 
+/* Relaxed accessors for MMIO */
+#define readb_relaxed(__addr)		readb(__addr)
+#define readw_relaxed(__addr)		readw(__addr)
+#define readl_relaxed(__addr)		readl(__addr)
+
+#define writeb_relaxed(__b, __addr)	writeb(__b, __addr)
+#define writew_relaxed(__w, __addr)	writew(__w, __addr)
+#define writel_relaxed(__l, __addr)	writel(__l, __addr)
+
 /* Big endian versions of memory read/write routines */
 #define readb_be(__addr)	__raw_readb(__addr)
 #define readw_be(__addr)	__raw_readw(__addr)
diff --git a/arch/sparc/include/asm/io_32.h b/arch/sparc/include/asm/io_32.h
index 9f532902627c..407ac14295f4 100644
--- a/arch/sparc/include/asm/io_32.h
+++ b/arch/sparc/include/asm/io_32.h
@@ -4,10 +4,6 @@
 #include <linux/kernel.h>
 #include <linux/ioport.h>  /* struct resource */
 
-#define readb_relaxed(__addr)	readb(__addr)
-#define readw_relaxed(__addr)	readw(__addr)
-#define readl_relaxed(__addr)	readl(__addr)
-
 #define IO_SPACE_LIMIT 0xffffffff
 
 #define memset_io(d,c,sz)     _memset_io(d,c,sz)
diff --git a/arch/sparc/include/asm/io_64.h b/arch/sparc/include/asm/io_64.h
index 80b54b326d49..d50e6127325d 100644
--- a/arch/sparc/include/asm/io_64.h
+++ b/arch/sparc/include/asm/io_64.h
@@ -136,6 +136,7 @@ static inline u32 readl(const volatile void __iomem *addr)
 }
 
 #define readq readq
+#define readq_relaxed readq
 static inline u64 readq(const volatile void __iomem *addr)
 {	u64 ret;
 
@@ -175,6 +176,7 @@ static inline void writel(u32 l, volatile void __iomem *addr)
 }
 
 #define writeq writeq
+#define writeq_relaxed writeq
 static inline void writeq(u64 q, volatile void __iomem *addr)
 {
 	__asm__ __volatile__("stxa\t%r0, [%1] %2\t/* pci_writeq */"
@@ -183,7 +185,6 @@ static inline void writeq(u64 q, volatile void __iomem *addr)
 			     : "memory");
 }
 
-
 #define inb inb
 static inline u8 inb(unsigned long addr)
 {
@@ -264,11 +265,6 @@ static inline void iowrite32_rep(void __iomem *port, const void *buf, unsigned l
 	outsl((unsigned long __force)port, buf, count);
 }
 
-#define readb_relaxed(__addr)	readb(__addr)
-#define readw_relaxed(__addr)	readw(__addr)
-#define readl_relaxed(__addr)	readl(__addr)
-#define readq_relaxed(__addr)	readq(__addr)
-
 /* Valid I/O Space regions are anywhere, because each PCI bus supported
  * can live in an arbitrary area of the physical address range.
  */
-- 
2.1.0

