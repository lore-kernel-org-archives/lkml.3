Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbaLVUIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 15:08:18 -0500
Received: from mga03.intel.com ([134.134.136.65]:58546 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755557AbaLVUIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 15:08:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,626,1413270000"; 
   d="scan'208";a="641564569"
Subject: [PATCH 2/2] x86 mpx: fix potential performance issue on unmaps
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, x86@kernel.org, Dave Hansen <dave@sr71.net>,
        dave.hansen@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Mon, 22 Dec 2014 12:08:05 -0800
References: <20141222200803.D316DA2A@viggo.jf.intel.com>
In-Reply-To: <20141222200803.D316DA2A@viggo.jf.intel.com>
Message-Id: <20141222200805.13639956@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

The 3.19 release window saw some TLB modifications merged which
caused a performance regression.  They were fixed in commit
045bbb9fa.

Once that fix was applied, I also noticed that there was a small
but intermittent regression still present.  It was not present
consistently enough to bisect reliably, but I'm fairly confident
that it came from (my own) MPX patches.  The source was reading
a relatively unused field in the mm_struct via arch_unmap.

I also noted that this code was in the main instruction flow of
do_munmap() and probably had more icache impact than we want.

This patch does two things:
1. Adds a static (via Kconfig) and dynamic (via cpuid) check
   for MPX with cpu_feature_enabled().  This keeps us from
   reading that cacheline in the mm and trades it for a check
   of the global CPUID variables at least on CPUs without MPX.
2. Adds an unlikely() to ensure that the MPX call ends up out
   of the main instruction flow in do_munmap().  I've added
   a detailed comment about why this was done and why we want
   it even on systems where MPX is present.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/x86/include/asm/mmu_context.h |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff -puN arch/x86/include/asm/mmu_context.h~fix-mpx-regression-on-unmap arch/x86/include/asm/mmu_context.h
--- a/arch/x86/include/asm/mmu_context.h~fix-mpx-regression-on-unmap	2014-12-22 12:06:18.677928330 -0800
+++ b/arch/x86/include/asm/mmu_context.h	2014-12-22 12:06:18.680928465 -0800
@@ -130,7 +130,25 @@ static inline void arch_bprm_mm_init(str
 static inline void arch_unmap(struct mm_struct *mm, struct vm_area_struct *vma,
 			      unsigned long start, unsigned long end)
 {
-	mpx_notify_unmap(mm, vma, start, end);
+	/*
+	 * mpx_notify_unmap() goes and reads a rarely-hot
+	 * cacheline in the mm_struct.  That can be expensive
+	 * enough to be seen in profiles.
+	 *
+	 * The mpx_notify_unmap() call and its contents have been
+	 * observed to affect munmap() performance on hardware
+	 * where MPX is not present.
+	 *
+	 * The unlikely() optimizes for the fast case: no MPX
+	 * in the CPU, or no MPX use in the process.  Even if
+	 * we get this wrong (in the unlikely event that MPX
+	 * is widely enabled on some system) the overhead of
+	 * MPX itself (reading bounds tables) is expected to
+	 * overwhelm the overhead of getting this unlikely()
+	 * consistently wrong.
+	 */
+	if (unlikely(cpu_feature_enabled(X86_FEATURE_MPX)))
+		mpx_notify_unmap(mm, vma, start, end);
 }
 
 #endif /* _ASM_X86_MMU_CONTEXT_H */
_
