Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbaGIPLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:11:46 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:55618 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666AbaGIPLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:11:43 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] asm-generic/io.h: Implement generic {read,write}s*()
Date: Wed,  9 Jul 2014 17:11:37 +0200
Message-Id: <1404918699-17284-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

This patch implements generic versions of readsb(), readsw(), readsl(),
readsq(), writesb(), writesw(), writesl() and writesq(). Variants of
these string functions for I/O accesses (ins*() and outs*() as well as
ioread*_rep() and iowrite*_rep()) are now implemented in terms of the
new functions.

While at it, also make sure that any of the functions provided as
fallback for architectures that don't override them can't be overridden
subsequently.

This is compile- and runtime-tested on 32-bit and 64-bit ARM and compile
tested on Microblaze, s390, SPARC and Xtensa. For ARC, Blackfin, Metag,
OpenRISC, Score and Unicore32 which also use asm-generic/io.h I couldn't
find or build a cross-compiler that would run on my system. But by code
inspection they shouldn't break with this patch.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 include/asm-generic/io.h | 278 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 197 insertions(+), 81 deletions(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 975e1cc75edb..bf9d3cd4e89e 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -32,6 +32,7 @@
  * memory location directly.
  */
 #ifndef __raw_readb
+#define __raw_readb __raw_readb
 static inline u8 __raw_readb(const volatile void __iomem *addr)
 {
 	return *(const volatile u8 __force *) addr;
@@ -39,6 +40,7 @@ static inline u8 __raw_readb(const volatile void __iomem *addr)
 #endif
 
 #ifndef __raw_readw
+#define __raw_readw __raw_readw
 static inline u16 __raw_readw(const volatile void __iomem *addr)
 {
 	return *(const volatile u16 __force *) addr;
@@ -46,27 +48,35 @@ static inline u16 __raw_readw(const volatile void __iomem *addr)
 #endif
 
 #ifndef __raw_readl
+#define __raw_readl __raw_readl
 static inline u32 __raw_readl(const volatile void __iomem *addr)
 {
 	return *(const volatile u32 __force *) addr;
 }
 #endif
 
+#ifndef readb
 #define readb __raw_readb
+#endif
 
+#ifndef readw
 #define readw readw
 static inline u16 readw(const volatile void __iomem *addr)
 {
 	return __le16_to_cpu(__raw_readw(addr));
 }
+#endif
 
+#ifndef readl
 #define readl readl
 static inline u32 readl(const volatile void __iomem *addr)
 {
 	return __le32_to_cpu(__raw_readl(addr));
 }
+#endif
 
 #ifndef __raw_writeb
+#define __raw_writeb __raw_writeb
 static inline void __raw_writeb(u8 b, volatile void __iomem *addr)
 {
 	*(volatile u8 __force *) addr = b;
@@ -74,6 +84,7 @@ static inline void __raw_writeb(u8 b, volatile void __iomem *addr)
 #endif
 
 #ifndef __raw_writew
+#define __raw_writew __raw_writew
 static inline void __raw_writew(u16 b, volatile void __iomem *addr)
 {
 	*(volatile u16 __force *) addr = b;
@@ -81,78 +92,225 @@ static inline void __raw_writew(u16 b, volatile void __iomem *addr)
 #endif
 
 #ifndef __raw_writel
+#define __raw_writel __raw_writel
 static inline void __raw_writel(u32 b, volatile void __iomem *addr)
 {
 	*(volatile u32 __force *) addr = b;
 }
 #endif
 
+#ifndef writeb
 #define writeb __raw_writeb
+#endif
+
+#ifndef writew
 #define writew(b,addr) __raw_writew(__cpu_to_le16(b),addr)
+#endif
+
+#ifndef writel
 #define writel(b,addr) __raw_writel(__cpu_to_le32(b),addr)
+#endif
 
 #ifdef CONFIG_64BIT
 #ifndef __raw_readq
+#define __raw_readq __raw_readq
 static inline u64 __raw_readq(const volatile void __iomem *addr)
 {
 	return *(const volatile u64 __force *) addr;
 }
 #endif
 
+#ifndef readq
 #define readq readq
 static inline u64 readq(const volatile void __iomem *addr)
 {
 	return __le64_to_cpu(__raw_readq(addr));
 }
+#endif
 
 #ifndef __raw_writeq
+#define __raw_writeq __raw_writeq
 static inline void __raw_writeq(u64 b, volatile void __iomem *addr)
 {
 	*(volatile u64 __force *) addr = b;
 }
 #endif
 
+#ifndef writeq
 #define writeq(b, addr) __raw_writeq(__cpu_to_le64(b), addr)
+#endif
+#endif /* CONFIG_64BIT */
+
+#ifndef readsb
+#define readsb readsb
+static inline void readsb(const void __iomem *addr, void *buffer, int count)
+{
+	if (count) {
+		u8 *buf = buffer;
+		do {
+			u8 x = __raw_readb(addr);
+			*buf++ = x;
+		} while (--count);
+	}
+}
+#endif
+
+#ifndef readsw
+#define readsw readsw
+static inline void readsw(const void __iomem *addr, void *buffer, int count)
+{
+	if (count) {
+		u16 *buf = buffer;
+		do {
+			u16 x = __raw_readw(addr);
+			*buf++ = x;
+		} while (--count);
+	}
+}
+#endif
+
+#ifndef readsl
+#define readsl readsl
+static inline void readsl(const void __iomem *addr, void *buffer, int count)
+{
+	if (count) {
+		u32 *buf = buffer;
+		do {
+			u32 x = __raw_readl(addr);
+			*buf++ = x;
+		} while (--count);
+	}
+}
+#endif
+
+#ifndef writesb
+#define writesb writesb
+static inline void writesb(void __iomem *addr, const void *buffer, int count)
+{
+	if (count) {
+		const u8 *buf = buffer;
+		do {
+			__raw_writeb(*buf++, addr);
+		} while (--count);
+	}
+}
+#endif
+
+#ifndef writesw
+#define writesw writesw
+static inline void writesw(void __iomem *addr, const void *buffer, int count)
+{
+	if (count) {
+		const u16 *buf = buffer;
+		do {
+			__raw_writew(*buf++, addr);
+		} while (--count);
+	}
+}
+#endif
+
+#ifndef writesl
+#define writesl writesl
+static inline void writesl(void __iomem *addr, const void *buffer, int count)
+{
+	if (count) {
+		const u32 *buf = buffer;
+		do {
+			__raw_writel(*buf++, addr);
+		} while (--count);
+	}
+}
+#endif
+
+#ifdef CONFIG_64BIT
+#ifndef readsq
+#define readsq readsq
+static inline void readsq(const void __iomem *addr, void *buffer, int count)
+{
+	if (count) {
+		u64 *buf = buffer;
+		do {
+			u64 x = __raw_readq(addr);
+			*buf++ = x;
+		} while (--count);
+	}
+}
+#endif
+
+#ifndef writesq
+#define writesq writesq
+static inline void writesq(void __iomem *addr, const void *buffer, int count)
+{
+	if (count) {
+		const u64 *buf = buffer;
+		do {
+			__raw_writeq(*buf++, addr);
+		} while (--count);
+	}
+}
+#endif
 #endif /* CONFIG_64BIT */
 
 #ifndef PCI_IOBASE
 #define PCI_IOBASE ((void __iomem *) 0)
 #endif
 
+#ifndef IO_SPACE_LIMIT
+#define IO_SPACE_LIMIT 0xffff
+#endif
+
 /*****************************************************************************/
 /*
  * traditional input/output functions
  */
 
+#ifndef inb
+#define inb inb
 static inline u8 inb(unsigned long addr)
 {
-	return readb(addr + PCI_IOBASE);
+	return readb(PCI_IOBASE + addr);
 }
+#endif
 
+#ifndef inw
+#define inw inw
 static inline u16 inw(unsigned long addr)
 {
-	return readw(addr + PCI_IOBASE);
+	return readw(PCI_IOBASE + addr);
 }
+#endif
 
+#ifndef inl
+#define inl inl
 static inline u32 inl(unsigned long addr)
 {
-	return readl(addr + PCI_IOBASE);
+	return readl(PCI_IOBASE + addr);
 }
+#endif
 
+#ifndef outb
+#define outb outb
 static inline void outb(u8 b, unsigned long addr)
 {
-	writeb(b, addr + PCI_IOBASE);
+	writeb(b, PCI_IOBASE + addr);
 }
+#endif
 
+#ifndef outw
+#define outw outw
 static inline void outw(u16 b, unsigned long addr)
 {
-	writew(b, addr + PCI_IOBASE);
+	writew(b, PCI_IOBASE + addr);
 }
+#endif
 
+#ifndef outl
+#define outl outl
 static inline void outl(u32 b, unsigned long addr)
 {
-	writel(b, addr + PCI_IOBASE);
+	writel(b, PCI_IOBASE + addr);
 }
+#endif
 
 #define inb_p(addr)	inb(addr)
 #define inw_p(addr)	inw(addr)
@@ -162,80 +320,37 @@ static inline void outl(u32 b, unsigned long addr)
 #define outl_p(x, addr)	outl((x), (addr))
 
 #ifndef insb
-static inline void insb(unsigned long addr, void *buffer, int count)
-{
-	if (count) {
-		u8 *buf = buffer;
-		do {
-			u8 x = __raw_readb(addr + PCI_IOBASE);
-			*buf++ = x;
-		} while (--count);
-	}
-}
+#define insb(addr, buffer, count) readsb(PCI_IOBASE + addr, buffer, count)
 #endif
 
 #ifndef insw
-static inline void insw(unsigned long addr, void *buffer, int count)
-{
-	if (count) {
-		u16 *buf = buffer;
-		do {
-			u16 x = __raw_readw(addr + PCI_IOBASE);
-			*buf++ = x;
-		} while (--count);
-	}
-}
+#define insw(addr, buffer, count) readsw(PCI_IOBASE + addr, buffer, count)
 #endif
 
 #ifndef insl
-static inline void insl(unsigned long addr, void *buffer, int count)
-{
-	if (count) {
-		u32 *buf = buffer;
-		do {
-			u32 x = __raw_readl(addr + PCI_IOBASE);
-			*buf++ = x;
-		} while (--count);
-	}
-}
+#define insl(addr, buffer, count) readsl(PCI_IOBASE + addr, buffer, count)
 #endif
 
 #ifndef outsb
-static inline void outsb(unsigned long addr, const void *buffer, int count)
-{
-	if (count) {
-		const u8 *buf = buffer;
-		do {
-			__raw_writeb(*buf++, addr + PCI_IOBASE);
-		} while (--count);
-	}
-}
+#define outsb(addr, buffer, count) writesb(PCI_IOBASE + addr, buffer, count)
 #endif
 
 #ifndef outsw
-static inline void outsw(unsigned long addr, const void *buffer, int count)
-{
-	if (count) {
-		const u16 *buf = buffer;
-		do {
-			__raw_writew(*buf++, addr + PCI_IOBASE);
-		} while (--count);
-	}
-}
+#define outsw(addr, buffer, count) writesw(PCI_IOBASE + addr, buffer, count)
 #endif
 
 #ifndef outsl
-static inline void outsl(unsigned long addr, const void *buffer, int count)
-{
-	if (count) {
-		const u32 *buf = buffer;
-		do {
-			__raw_writel(*buf++, addr + PCI_IOBASE);
-		} while (--count);
-	}
-}
+#define outsl(addr, buffer, count) writesl(PCI_IOBASE + addr, buffer, count)
 #endif
 
+#define insb_p(port,to,len)	insb(port,to,len)
+#define insw_p(port,to,len)	insw(port,to,len)
+#define insl_p(port,to,len)	insl(port,to,len)
+
+#define outsb_p(port,from,len)	outsb(port,from,len)
+#define outsw_p(port,from,len)	outsw(port,from,len)
+#define outsl_p(port,from,len)	outsl(port,from,len)
+
 #ifndef CONFIG_GENERIC_IOMAP
 #define ioread8(addr)		readb(addr)
 #define ioread16(addr)		readw(addr)
@@ -249,24 +364,14 @@ static inline void outsl(unsigned long addr, const void *buffer, int count)
 #define iowrite32(v, addr)	writel((v), (addr))
 #define iowrite32be(v, addr)	__raw_writel(__cpu_to_be32(v), addr)
 
-#define ioread8_rep(p, dst, count) \
-	insb((unsigned long) (p), (dst), (count))
-#define ioread16_rep(p, dst, count) \
-	insw((unsigned long) (p), (dst), (count))
-#define ioread32_rep(p, dst, count) \
-	insl((unsigned long) (p), (dst), (count))
-
-#define iowrite8_rep(p, src, count) \
-	outsb((unsigned long) (p), (src), (count))
-#define iowrite16_rep(p, src, count) \
-	outsw((unsigned long) (p), (src), (count))
-#define iowrite32_rep(p, src, count) \
-	outsl((unsigned long) (p), (src), (count))
-#endif /* CONFIG_GENERIC_IOMAP */
+#define ioread8_rep(p, dst, count) readsb(p, dst, count)
+#define ioread16_rep(p, dst, count) readsw(p, dst, count)
+#define ioread32_rep(p, dst, count) readsl(p, dst, count)
 
-#ifndef IO_SPACE_LIMIT
-#define IO_SPACE_LIMIT 0xffff
-#endif
+#define iowrite8_rep(p, src, count) writesb(p, src, count)
+#define iowrite16_rep(p, src, count) writesw(p, src, count)
+#define iowrite32_rep(p, src, count) writesl(p, src, count)
+#endif /* CONFIG_GENERIC_IOMAP */
 
 #ifdef __KERNEL__
 
@@ -278,6 +383,7 @@ struct pci_dev;
 extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
 
 #ifndef pci_iounmap
+#define pci_iounmap pci_iounmap
 static inline void pci_iounmap(struct pci_dev *dev, void __iomem *p)
 {
 }
@@ -289,11 +395,15 @@ static inline void pci_iounmap(struct pci_dev *dev, void __iomem *p)
  * These are pretty trivial
  */
 #ifndef virt_to_phys
+#define virt_to_phys virt_to_phys
 static inline unsigned long virt_to_phys(volatile void *address)
 {
 	return __pa((unsigned long)address);
 }
+#endif
 
+#ifndef phys_to_virt
+#define phys_to_virt phys_to_virt
 static inline void *phys_to_virt(unsigned long address)
 {
 	return __va(address);
@@ -329,14 +439,20 @@ static inline void iounmap(void __iomem *addr)
 
 #ifdef CONFIG_HAS_IOPORT_MAP
 #ifndef CONFIG_GENERIC_IOMAP
+#ifndef ioport_map
+#define ioport_map ioport_map
 static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
 {
-	return (void __iomem *) port;
+	return PCI_IOBASE + port;
 }
+#endif
 
+#ifndef ioport_unmap
+#define ioport_unmap ioport_unmap
 static inline void ioport_unmap(void __iomem *p)
 {
 }
+#endif
 #else /* CONFIG_GENERIC_IOMAP */
 extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
 extern void ioport_unmap(void __iomem *p);
-- 
2.0.1

