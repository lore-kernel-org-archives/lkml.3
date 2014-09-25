Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaIYNQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:16:14 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:62480 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaIYNQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:16:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, chris@zankel.net, cmetcalf@tilera.com,
        davem@davemloft.net, deller@gmx.de, dhowells@redhat.com,
        geert@linux-m68k.org, heiko.carstens@de.ibm.com, hpa@zytor.com,
        jcmvbkbc@gmail.com, jesper.nilsson@axis.com, mingo@redhat.com,
        monstr@monstr.eu, paulmck@linux.vnet.ibm.com, rdunlap@infradead.org,
        sam@ravnborg.org, schwidefsky@de.ibm.com, starvik@axis.com,
        takata@linux-m32r.org, tglx@linutronix.de, tony.luck@intel.com,
        daniel.thompson@linaro.org, broonie@linaro.org, linux@arm.linux.org.uk,
        thierry.reding@gmail.com
Subject: Re: [PATCH v3 00/17] Cross-architecture definitions of relaxed MMIO accessors
Date: Thu, 25 Sep 2014 15:15:10 +0200
Message-ID: <2811016.mhqlsl6pTS@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:0L5HwaR9AL/Sad/zUwyWCnbe7zuCtUin8Hti41hBi0i
 V2SuRv0t9HyWyPP0sYI9FnhQYGOCGpipnuWacgJMg2FD3O+hXR
 VIuLjTT+A6WBSft25Uc//3uKdM7jPEAUQv4j1eqk9uSnfyv9U5
 jXX1JDqTTBLayvLHeSZciTENl3yOMxy6EB7xIMr5laSlLpEmFJ
 NxY0Pgz/UEimNebYAZYHBYASDvYrP6K4KCL78F4ofGhN0jIeWO
 tn5vMZiMJTC5DsmBnj9QiXtxGHBuQENuaty6EyKxfu6PcUsB+A
 x2XJTo9205keshATR7qDW87GUfpS9qJX+buC1arzDwKDQDinRW
 xRnJNjxYYE4a6OM/ws8M=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 September 2014 18:17:19 Will Deacon wrote:
> Hello everybody,
> 
> This is version three of the series I've originally posted here:
> 
>   v1: https://lkml.org/lkml/2014/4/17/269
>   v2: https://lkml.org/lkml/2014/5/22/468
> 
> This is basically just a rebase on top of 3.17-rc6, minus the alpha patch
> (which was merged into mainline).
> 
> I looked at reworking the non-relaxed accessors to imply mmiowb, but it
> quickly got messy as some architectures (e.g. mips) deliberately keep
> mmiowb and readX/writeX separate whilst others (e.g. powerpc) don't trust
> drivers to get mmiowb correct, so add barriers to both. Given that
> arm/arm64/x86 don't care about mmiowb, I've left that as an exercise for
> an architecture that does care.
> 
> In order to get this lot merged, we probably want to merge the asm-generic
> patch (1/17) first, so Acks would be much appreciated on the architecture
> bits.
> 
> As before, I've included the original cover letter below, as that describes
> what I'm trying to do in more detail.
> 

I've now applied the parts of your series that are required to have
every architecture provide all the 'relaxed' accessors to the
asm-generic tree, on top of Thierry's series.

I had to change your first patch significantly because all the context
changed in his patches. See below for the new version. Thierry, can
you also confirm that this matches up with the intention of your
series? Since that now adds a separate #ifdef for each symbol, I
ended up putting the #ifdef for the relaxed version inside of the
#ifdef for the non-relaxed version, but it could alternatively
be defined outside of it as well.

The entire series of both Thierry's and Will's changes is now in
git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git
and should show up in linux-next tomorrow. There are currently
no conflicts against anything else in linux-next.

Since we're rather close to the merge window, I'd probably leave
this in linux-next for a while longer and submit it all for inclusion
in 3.18 in the second week after 3.17.

If anybody still has concerns, please let me know.

	Arnd

---
Thierry Reding (8):
      ARC: Remove redundant PCI_IOBASE declaration
      serial: sunzilog: Remove unnecessary volatile keyword
      sparc: Remove unnecessary volatile usage
      [IA64] Change xlate_dev_{kmem,mem}_ptr() prototypes
      /dev/mem: Use more consistent data types
      asm-generic/io.h: Implement generic {read,write}s*()
      ARM: Use include/asm-generic/io.h
      arm64: Use include/asm-generic/io.h

Will Deacon (13):
      documentation: memory-barriers: clarify relaxed io accessor semantics
      frv: io: implement dummy relaxed accessor macros for writes
      ia64: io: implement dummy relaxed accessor macros for writes
      cris: io: implement dummy relaxed accessor macros for writes
      x86: io: implement dummy relaxed accessor macros for writes
      tile: io: implement dummy relaxed accessor macros for writes
      parisc: io: implement dummy relaxed accessor macros for writes
      m32r: io: implement dummy relaxed accessor macros for writes
      mn10300: io: implement dummy relaxed accessor macros for writes
      powerpc: io: implement dummy relaxed accessor macros for writes
      m68k: io: implement dummy relaxed accessor macros for writes
      sparc: io: implement dummy relaxed accessor macros for writes
      asm-generic: io: implement relaxed accessor macros as conditional wrappers

 Documentation/memory-barriers.txt |  13 +-
 arch/arc/include/asm/io.h         |   2 -
 arch/arm/include/asm/io.h         |  75 +++----
 arch/arm/include/asm/memory.h     |   2 +
 arch/arm64/Kconfig                |   1 -
 arch/arm64/include/asm/io.h       | 122 +++--------
 arch/arm64/include/asm/memory.h   |   2 +
 arch/cris/include/asm/io.h        |   3 +
 arch/frv/include/asm/io.h         |   3 +
 arch/ia64/include/asm/io.h        |   4 +
 arch/ia64/include/asm/uaccess.h   |  16 +-
 arch/m32r/include/asm/io.h        |   3 +
 arch/m68k/include/asm/io.h        |   8 +
 arch/m68k/include/asm/io_no.h     |   4 -
 arch/mn10300/include/asm/io.h     |   4 +
 arch/parisc/include/asm/io.h      |  12 +-
 arch/powerpc/include/asm/io.h     |  12 +-
 arch/s390/include/asm/io.h        |   5 +-
 arch/s390/mm/maccess.c            |   4 +-
 arch/sparc/include/asm/io.h       |   9 +
 arch/sparc/include/asm/io_32.h    |  22 +-
 arch/sparc/include/asm/io_64.h    |   8 +-
 arch/tile/include/asm/io.h        |   4 +
 arch/x86/include/asm/io.h         |   8 +-
 arch/x86/mm/ioremap.c             |   4 +-
 drivers/char/mem.c                |  13 +-
 drivers/tty/serial/sunzilog.h     |   8 +-
 include/asm-generic/io.h          | 705 ++++++++++++++++++++++++++++++++++++++++++++++++++++------------
 28 files changed, 739 insertions(+), 337 deletions(-)


commit 3c8c4968a36c76245fd6dc37648327602106ae11
Author: Will Deacon <will.deacon@arm.com>
Date:   Wed Sep 24 18:17:20 2014 +0100

    asm-generic: io: implement relaxed accessor macros as conditional wrappers
    
    {read,write}{b,w,l,q}_relaxed are implemented by some architectures in
    order to permit memory-mapped I/O accesses with weaker barrier semantics
    than the non-relaxed variants.
    
    This patch adds wrappers to asm-generic so that drivers can rely on the
    relaxed accessors being available, even if they don't always provide
    weaker ordering guarantees. Since some architectures both include
    asm-generic/io.h and define some relaxed accessors, the definitions here
    are conditional for the time being.
    
    Signed-off-by: Will Deacon <will.deacon@arm.com>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 508a57257de5..3344044a7e4f 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -111,6 +111,9 @@ static inline u8 readb(const void __iomem *addr)
 {
 	return __raw_readb(addr);
 }
+#ifndef readb_relaxed
+#define readb_relaxed readb
+#endif
 #endif
 
 #ifndef readw
@@ -119,6 +122,9 @@ static inline u16 readw(const void __iomem *addr)
 {
 	return __le16_to_cpu(__raw_readw(addr));
 }
+#ifndef readw_relaxed
+#define readw_relaxed readw
+#endif
 #endif
 
 #ifndef readl
@@ -127,6 +133,9 @@ static inline u32 readl(const void __iomem *addr)
 {
 	return __le32_to_cpu(__raw_readl(addr));
 }
+#ifndef readl_relaxed
+#define readl_relaxed readl
+#endif
 #endif
 
 #ifdef CONFIG_64BIT
@@ -136,6 +145,9 @@ static inline u64 readq(const void __iomem *addr)
 {
 	return __le64_to_cpu(__raw_readq(addr));
 }
+#ifndef readq_relaxed
+#define readq_relaxed readq
+#endif
 #endif
 #endif /* CONFIG_64BIT */
 
@@ -145,6 +157,9 @@ static inline void writeb(u8 value, void __iomem *addr)
 {
 	__raw_writeb(value, addr);
 }
+#ifndef writeb_relaxed
+#define writeb_relaxed writeb
+#endif
 #endif
 
 #ifndef writew
@@ -153,6 +168,9 @@ static inline void writew(u16 value, void __iomem *addr)
 {
 	__raw_writew(cpu_to_le16(value), addr);
 }
+#ifndef writew_relaxed
+#define writew_relaxed writew
+#endif
 #endif
 
 #ifndef writel
@@ -161,6 +179,9 @@ static inline void writel(u32 value, void __iomem *addr)
 {
 	__raw_writel(__cpu_to_le32(value), addr);
 }
+#ifndef writel_relaxed
+#define writel_relaxed writel
+#endif
 #endif
 
 #ifdef CONFIG_64BIT
@@ -170,6 +191,9 @@ static inline void writeq(u64 value, void __iomem *addr)
 {
 	__raw_writeq(__cpu_to_le64(value), addr);
 }
+#ifndef writeq_relaxed
+#define writeq_relaxed writeq
+#endif
 #endif
 #endif /* CONFIG_64BIT */
 

