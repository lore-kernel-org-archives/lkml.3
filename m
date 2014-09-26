Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbaIZNkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 09:40:33 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:56453 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbaIZNk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 09:40:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
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
Subject: Re: [PATCH v3 00/17] Cross-architecture definitions of relaxed MMIO accessors
Date: Fri, 26 Sep 2014 15:39:49 +0200
Message-ID: <9197976.uQdLmtvIl1@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140926080551.GD31106@ulmo>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com> <4240583.SJ4jiIW6Zy@wuerfel> <20140926080551.GD31106@ulmo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:MksMwlp85kkPDCTab896R0mLCD7JFbZu/Z6/zD+Q8jQ
 Jga5j6GGfErJZhss4fkqVxiI+wz3LyouXbC5uvcsQuKsvOaIu5
 pAw7xafAB6r2DzyO5Ez8Z2T1ZVGAkWmhOhgAzFFGJ9vEu0ArVD
 X8tcv9oW27CmprBgr2IZrOi3qvBSgajgcc6zQOo9ASXh+fRMgK
 1c235/s9Qaov7bBovidEojCPXs+nDFDoXlKWbn2lfhMARW9B1g
 ekWGeK+WmXBOkkaJHCI3hjH8gvMjvl1EzfShmDEiCtJhhDSZOt
 miMNh4ytgqIsiViWFUWbxOz1cKg0Un4Ua3nzngIj8Z0i5Aeux7
 n3UrPta1HZM9LahTx1Co=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 September 2014 10:05:52 Thierry Reding wrote:

> My original patch to consolidate the read*/write*() and friends
> explicitly avoided the use of macros to do this. The reason was that if
> we have static inline functions in asm-generic/io.h it defines the
> canonical prototype of these functions, so that architectures that want
> to override them can just copy the prototype from there.
> 
> So for consistency the above would become:
> 
> 	#ifndef readb_relaxed
> 	#define readb_relaxed readb_relaxed
> 	static inline u8 readb_relaxed(const void __iomem *addr)
> 	{
> 		return readb(addr);
> 	}
> 	#endif
> 
> And analogously for the others. For the *_relaxed variants it's perhaps
> not as important because the signature is the same as for the plain
> variants, so I'm not objecting very strongly to the plain macros.

Ok. I'd prefer the brief version I think.

Russell found a number of other bugs with the series, the patch below
contains the fixes I've had to do so far.

I assume I'll add some more of these and then commit an update.

	Arnd

diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index 179ce4b93d9a..e9e70b19dc2f 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -347,10 +347,12 @@ extern void _memset_io(volatile void __iomem *, int, size_t);
 #define iowrite16be(v,p)	({ __iowmb(); __raw_writew((__force __u16)cpu_to_be16(v), p); })
 #define iowrite32be(v,p)	({ __iowmb(); __raw_writew((__force __u32)cpu_to_be32(v), p); })
 
+#ifndef ioport_map
 #define ioport_map ioport_map
 extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
 #define ioport_unmap ioport_unmap
 extern void ioport_unmap(void __iomem *addr);
+#endif
 
 struct pci_dev;
 
diff --git a/arch/arm/mach-ebsa110/include/mach/io.h b/arch/arm/mach-ebsa110/include/mach/io.h
index 11bb0799424b..72232a198d83 100644
--- a/arch/arm/mach-ebsa110/include/mach/io.h
+++ b/arch/arm/mach-ebsa110/include/mach/io.h
@@ -62,20 +62,30 @@ void __writel(u32 val, void __iomem *addr);
 #define writew(v,b)		__writew(v,b)
 #define writel(v,b)		__writel(v,b)
 
+#define insb insb
 extern void insb(unsigned int port, void *buf, int sz);
+#define insw insw
 extern void insw(unsigned int port, void *buf, int sz);
+#define insl insl
 extern void insl(unsigned int port, void *buf, int sz);
 
+#define outsb outsb
 extern void outsb(unsigned int port, const void *buf, int sz);
+#define outsw outsw
 extern void outsw(unsigned int port, const void *buf, int sz);
+#define outsl outsl
 extern void outsl(unsigned int port, const void *buf, int sz);
 
 /* can't support writesb atm */
+#define writesw writesw
 extern void writesw(void __iomem *addr, const void *data, int wordlen);
+#define writesl writesl
 extern void writesl(void __iomem *addr, const void *data, int longlen);
 
 /* can't support readsb atm */
+#define readsw readsw
 extern void readsw(const void __iomem *addr, void *data, int wordlen);
+#define readsl readsl
 extern void readsl(const void __iomem *addr, void *data, int longlen);
 
 #endif
diff --git a/arch/arm/mach-ixp4xx/include/mach/io.h b/arch/arm/mach-ixp4xx/include/mach/io.h
index 559c69a47731..3e74cd3be9bd 100644
--- a/arch/arm/mach-ixp4xx/include/mach/io.h
+++ b/arch/arm/mach-ixp4xx/include/mach/io.h
@@ -225,7 +225,7 @@ static inline void __indirect_readsl(const volatile void __iomem *bus_addr,
  * transaction.  This means that we need to override the default
  * I/O functions.
  */
-
+#define outb outb
 static inline void outb(u8 value, u32 addr)
 {
 	u32 n, byte_enables, data;
@@ -235,12 +235,14 @@ static inline void outb(u8 value, u32 addr)
 	ixp4xx_pci_write(addr, byte_enables | NP_CMD_IOWRITE, data);
 }
 
+#define outsb outsb
 static inline void outsb(u32 io_addr, const u8 *vaddr, u32 count)
 {
 	while (count--)
 		outb(*vaddr++, io_addr);
 }
 
+#define outw outw
 static inline void outw(u16 value, u32 addr)
 {
 	u32 n, byte_enables, data;
@@ -250,23 +252,27 @@ static inline void outw(u16 value, u32 addr)
 	ixp4xx_pci_write(addr, byte_enables | NP_CMD_IOWRITE, data);
 }
 
+#define outsw outsw
 static inline void outsw(u32 io_addr, const u16 *vaddr, u32 count)
 {
 	while (count--)
 		outw(cpu_to_le16(*vaddr++), io_addr);
 }
 
+#define outl outl
 static inline void outl(u32 value, u32 addr)
 {
 	ixp4xx_pci_write(addr, NP_CMD_IOWRITE, value);
 }
 
+#define outsl outsl
 static inline void outsl(u32 io_addr, const u32 *vaddr, u32 count)
 {
 	while (count--)
 		outl(cpu_to_le32(*vaddr++), io_addr);
 }
 
+#define inb inb
 static inline u8 inb(u32 addr)
 {
 	u32 n, byte_enables, data;
@@ -278,12 +284,14 @@ static inline u8 inb(u32 addr)
 	return data >> (8*n);
 }
 
+#define insb insb
 static inline void insb(u32 io_addr, u8 *vaddr, u32 count)
 {
 	while (count--)
 		*vaddr++ = inb(io_addr);
 }
 
+#define inw inw
 static inline u16 inw(u32 addr)
 {
 	u32 n, byte_enables, data;
@@ -295,12 +303,14 @@ static inline u16 inw(u32 addr)
 	return data>>(8*n);
 }
 
+#define insw insw
 static inline void insw(u32 io_addr, u16 *vaddr, u32 count)
 {
 	while (count--)
 		*vaddr++ = le16_to_cpu(inw(io_addr));
 }
 
+#define inl inl
 static inline u32 inl(u32 addr)
 {
 	u32 data;
@@ -310,6 +320,7 @@ static inline u32 inl(u32 addr)
 	return data;
 }
 
+#define insl insl
 static inline void insl(u32 io_addr, u32 *vaddr, u32 count)
 {
 	while (count--)
diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 6aeb6add49a6..7872527c08db 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -560,35 +560,53 @@ static inline void outsl_p(unsigned long addr, const void *buffer,
 #endif
 
 #ifndef CONFIG_GENERIC_IOMAP
+#ifndef ioread8
+#define ioread8 ioread8
 static inline u8 ioread8(const void __iomem *addr)
 {
 	return readb(addr);
 }
+#endif
 
+#ifndef ioread16
+#define ioread16 ioread16
 static inline u16 ioread16(const void __iomem *addr)
 {
 	return readw(addr);
 }
+#endif
 
+#ifndef ioread32
+#define ioread32 ioread32
 static inline u32 ioread32(const void __iomem *addr)
 {
 	return readl(addr);
 }
+#endif
 
+#ifndef iowrite8
+#define iowrite8 iowrite8
 static inline void iowrite8(u8 value, void __iomem *addr)
 {
 	writeb(value, addr);
 }
+#endif
 
+#ifndef iowrite16
+#define iowrite16 iowrite16
 static inline void iowrite16(u16 value, void __iomem *addr)
 {
 	writew(value, addr);
 }
+#endif
 
+#ifndef iowrite32
+#define iowrite32 iowrite32
 static inline void iowrite32(u32 value, void __iomem *addr)
 {
 	writel(value, addr);
 }
+#endif
 
 #ifndef ioread16be
 #define ioread16be ioread16be

