Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbaHTL7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:59:42 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58956 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752563AbaHTLoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 054/104] sparc64: Guard against flushing openfirmware mappings.
Date: Wed, 20 Aug 2014 13:43:17 +0200
Message-Id: <a4ec094065b40797f44059799876f9f83a128099.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David S. Miller" <davem@davemloft.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/sparc/include/asm/tlbflush_64.h | 12 ++----------
 arch/sparc/mm/init_64.c              | 23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/arch/sparc/include/asm/tlbflush_64.h b/arch/sparc/include/asm/tlbflush_64.h
index f0d6a9700f4c..1a4bb971e06d 100644
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
index 774ba41dba4d..b26015f49c0d 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -2750,3 +2750,26 @@ void hugetlb_setup(struct pt_regs *regs)
 	}
 }
 #endif
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
-- 
2.0.4

