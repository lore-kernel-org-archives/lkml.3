Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbaIKNEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:04:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52280 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755276AbaIKNEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:04:35 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.493737810@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 116/131] sparc64: Guard against flushing openfirmware
 mappings.
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 4ca9a23765da3260058db3431faf5b4efd8cf926 ]

Based almost entirely upon a patch by Christopher Alexander Tobias
Schulze.

In commit db64fe02258f1507e13fe5212a989922323685ce ("mm: rewrite vmap
layer") lazy VMAP tlb flushing was added to the vmalloc layer.  This
causes problems on sparc64.

Sparc64 has two VMAP mapped regions and they are not contiguous with
eachother.  First we have the malloc mapping area, then another
unrelated region, then the vmalloc region.

This "another unrelated region" is where the firmware is mapped.

If the lazy TLB flushing logic in the vmalloc code triggers after
we've had both a module unload and a vfree or similar, it will pass an
address range that goes from somewhere inside the malloc region to
somewhere inside the vmalloc region, and thus covering the
openfirmware area entirely.

The sparc64 kernel learns about openfirmware's dynamic mappings in
this region early in the boot, and then services TLB misses in this
area.  But openfirmware has some locked TLB entries which are not
mentioned in those dynamic mappings and we should thus not disturb
them.

These huge lazy TLB flush ranges causes those openfirmware locked TLB
entries to be removed, resulting in all kinds of problems including
hard hangs and crashes during reboot/reset.

Besides causing problems like this, such huge TLB flush ranges are
also incredibly inefficient.  A plea has been made with the author of
the VMAP lazy TLB flushing code, but for now we'll put a safety guard
into our flush_tlb_kernel_range() implementation.

Since the implementation has become non-trivial, stop defining it as a
macro and instead make it a function in a C source file.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/sparc/include/asm/tlbflush_64.h | 12 ++----------
 arch/sparc/mm/init_64.c              | 23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/arch/sparc/include/asm/tlbflush_64.h b/arch/sparc/include/asm/tlbflush_64.h
index f0d6a97..1a4bb97 100644
--- a/arch/sparc/include/asm/tlbflush_64.h
+++ b/arch/sparc/include/asm/tlbflush_64.h
@@ -35,6 +35,8 @@ static inline void flush_tlb_range(struct vm_area_struct *vma,
 {
 }
 
+void flush_tlb_kernel_range(unsigned long start, unsigned long end);
+
 #define __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 
 extern void flush_tlb_pending(void);
@@ -49,11 +51,6 @@ extern void __flush_tlb_kernel_range(unsigned long start, unsigned long end);
 
 #ifndef CONFIG_SMP
 
-#define flush_tlb_kernel_range(start,end) \
-do {	flush_tsb_kernel_range(start,end); \
-	__flush_tlb_kernel_range(start,end); \
-} while (0)
-
 static inline void global_flush_tlb_page(struct mm_struct *mm, unsigned long vaddr)
 {
 	__flush_tlb_page(CTX_HWBITS(mm->context), vaddr);
@@ -64,11 +61,6 @@ static inline void global_flush_tlb_page(struct mm_struct *mm, unsigned long vad
 extern void smp_flush_tlb_kernel_range(unsigned long start, unsigned long end);
 extern void smp_flush_tlb_page(struct mm_struct *mm, unsigned long vaddr);
 
-#define flush_tlb_kernel_range(start, end) \
-do {	flush_tsb_kernel_range(start,end); \
-	smp_flush_tlb_kernel_range(start, end); \
-} while (0)
-
 #define global_flush_tlb_page(mm, vaddr) \
 	smp_flush_tlb_page(mm, vaddr)
 
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 77ad815..d2c5737 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -2440,3 +2440,26 @@ void __flush_tlb_all(void)
 	__asm__ __volatile__("wrpr	%0, 0, %%pstate"
 			     : : "r" (pstate));
 }
+
+#ifdef CONFIG_SMP
+#define do_flush_tlb_kernel_range	smp_flush_tlb_kernel_range
+#else
+#define do_flush_tlb_kernel_range	__flush_tlb_kernel_range
+#endif
+
+void flush_tlb_kernel_range(unsigned long start, unsigned long end)
+{
+	if (start < HI_OBP_ADDRESS && end > LOW_OBP_ADDRESS) {
+		if (start < LOW_OBP_ADDRESS) {
+			flush_tsb_kernel_range(start, LOW_OBP_ADDRESS);
+			do_flush_tlb_kernel_range(start, LOW_OBP_ADDRESS);
+		}
+		if (end > HI_OBP_ADDRESS) {
+			flush_tsb_kernel_range(end, HI_OBP_ADDRESS);
+			do_flush_tlb_kernel_range(end, HI_OBP_ADDRESS);
+		}
+	} else {
+		flush_tsb_kernel_range(start, end);
+		do_flush_tlb_kernel_range(start, end);
+	}
+}

