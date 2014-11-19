Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbaKSJWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 04:22:16 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:57751 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046AbaKSJWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 04:22:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: build failure after merge of the asm-generic tree
Date: Wed, 19 Nov 2014 10:21:59 +0100
Message-ID: <8149639.gnb4MSRbPQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141119185414.4ab8e35d@canb.auug.org.au>
References: <20141119185414.4ab8e35d@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:FkhOLkP8pLz/3t1zmCLGTCrS5V9TBs5gukUbfLIhy48
 t5xzz/BGsSoi0hdazWPvaMvdBL9tgZTn5gSM0zWAei+Hjur14H
 Hk9NDdNfbL20d7gts0LIKPS0BEGDktggHOEt90LhU2xCXjkZiD
 ZrO++nVx4bhbd/PZpd+CkZxKama3yGfkl9ZvNssCy1ITvon/29
 CAM6cmKcmbimGAO0ROqk0KKcL6rXq9svFU32p8TH3EKTfkz1Io
 uzcOFKfsWXe2C4CBJLVWYg5V+5P78kraVmZMtSzn8ocDviYyNb
 FU1n61V0xM1y6W77WRqW7xSje019pdCDHUNCkMTo18HWDMrKFK
 ArR9tYKFOe8zqq4a4YC4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 November 2014 18:54:14 Stephen Rothwell wrote:
> Hi Arnd,
> 
> After merging the asm-generic tree, today's linux-next build (sparc
> defconfig) failed like this:
> 
> In file included from include/linux/io.h:22:0,
>                  from include/linux/irq.h:23,
>                  from include/asm-generic/hardirq.h:12,
>                  from arch/sparc/include/asm/hardirq_32.h:10,
>                  from arch/sparc/include/asm/hardirq.h:6,
>                  from include/linux/hardirq.h:8,
>                  from include/linux/memcontrol.h:24,
>                  from include/linux/swap.h:8,
>                  from arch/sparc/include/asm/pgtable_32.h:17,
>                  from arch/sparc/include/asm/pgtable.h:6,
>                  from include/linux/mm.h:52,
>                  from include/linux/pagemap.h:7,
>                  from include/linux/blkdev.h:14,
>                  from init/do_mounts.h:2,
>                  from init/do_mounts_rd.c:21:
> arch/sparc/include/asm/io.h:14:0: warning: "readb_relaxed" redefined

Thanks for the report! I think we had seen this one before, but from what
I remembered, Will had already fixed all problems like this one. Apparently
the version I merged did not have the fix, so I applied the patch below
on top of my branch, and checked that it works on both sparc32 and sparc64.

Let me know if I should fix it differently.

	Arnd

>From 7c3969c3a4f3593bf7963355e10401a8638cb1cb Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 19 Nov 2014 10:15:33 +0100
Subject: [PATCH] sparc: io: remove duplicate relaxed accessors on sparc32

Commit 1191ccb34cf8 ("sparc: io: implement dummy relaxed accessor
macros for writes") added the relaxed accessors (readl_relaxed etc) in
a file that is shared between sparc32 and sparc64. However, the earlier
e1039fb42609 ("sparc32: introduce asm-generic/io.h") had already changed
the sparc32 implementation to use asm-generic/io.h, which provides the
same macros, resulting in lots of build errors.

This moves the definitions from the shared sparc file into the
sparc64-only file to fix the sparc32 build regression.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 1191ccb34cf8 ("sparc: io: implement dummy relaxed accessor macros for writes")

diff --git a/arch/sparc/include/asm/io.h b/arch/sparc/include/asm/io.h
index 493f22c4684f..f6902cf3cbe9 100644
--- a/arch/sparc/include/asm/io.h
+++ b/arch/sparc/include/asm/io.h
@@ -10,15 +10,6 @@
  * Defines used for both SPARC32 and SPARC64
  */
 
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
diff --git a/arch/sparc/include/asm/io_64.h b/arch/sparc/include/asm/io_64.h
index d50e6127325d..9b672be70dda 100644
--- a/arch/sparc/include/asm/io_64.h
+++ b/arch/sparc/include/asm/io_64.h
@@ -101,6 +101,7 @@ static inline void __raw_writeq(u64 q, const volatile void __iomem *addr)
  * the cache by using ASI_PHYS_BYPASS_EC_E_L
  */
 #define readb readb
+#define readb_relaxed readb
 static inline u8 readb(const volatile void __iomem *addr)
 {	u8 ret;
 
@@ -112,6 +113,7 @@ static inline u8 readb(const volatile void __iomem *addr)
 }
 
 #define readw readw
+#define readw_relaxed readw
 static inline u16 readw(const volatile void __iomem *addr)
 {	u16 ret;
 
@@ -124,6 +126,7 @@ static inline u16 readw(const volatile void __iomem *addr)
 }
 
 #define readl readl
+#define readl_relaxed readl
 static inline u32 readl(const volatile void __iomem *addr)
 {	u32 ret;
 
@@ -149,6 +152,7 @@ static inline u64 readq(const volatile void __iomem *addr)
 }
 
 #define writeb writeb
+#define writeb_relaxed writeb
 static inline void writeb(u8 b, volatile void __iomem *addr)
 {
 	__asm__ __volatile__("stba\t%r0, [%1] %2\t/* pci_writeb */"
@@ -158,6 +162,7 @@ static inline void writeb(u8 b, volatile void __iomem *addr)
 }
 
 #define writew writew
+#define writew_relaxed writew
 static inline void writew(u16 w, volatile void __iomem *addr)
 {
 	__asm__ __volatile__("stha\t%r0, [%1] %2\t/* pci_writew */"
@@ -167,6 +172,7 @@ static inline void writew(u16 w, volatile void __iomem *addr)
 }
 
 #define writel writel
+#define writel_relaxed writel
 static inline void writel(u32 l, volatile void __iomem *addr)
 {
 	__asm__ __volatile__("stwa\t%r0, [%1] %2\t/* pci_writel */"

