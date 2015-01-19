Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbbASPoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 10:44:46 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:35232 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbbASPop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 10:44:45 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: [PATCH v2] powerpc/8xx: reduce pressure on TLB due to context switches
Message-Id: <20150119154442.8E9E11A5E85@localhost.localdomain>
Date: Mon, 19 Jan 2015 16:44:42 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For nohash powerpc, when we run out of contexts, contexts are freed by stealing
used contexts in-turn. When a victim has been selected, the associated TLB
entries are freed using _tlbil_pid(). Unfortunatly, on the PPC 8xx, _tlbil_pid()
does a tlbia, hence flushes ALL TLB entries and not only the one linked to the
stolen context. Therefore, as implented today, at each task switch requiring a
new context, all entries are flushed.

This patch modifies the implementation so that when running out of contexts, all
contexts get freed at once, hence dividing the number of calls to tlbia by 16.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
v1->v2: removed blank line and added comment

 arch/powerpc/mm/mmu_context_nohash.c | 43 +++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/mmu_context_nohash.c b/arch/powerpc/mm/mmu_context_nohash.c
index 928ebe7..dcbc231 100644
--- a/arch/powerpc/mm/mmu_context_nohash.c
+++ b/arch/powerpc/mm/mmu_context_nohash.c
@@ -52,12 +52,15 @@
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
 
+#include "mmu_decl.h"
+
 static unsigned int first_context, last_context;
 static unsigned int next_context, nr_free_contexts;
 static unsigned long *context_map;
 static unsigned long *stale_map[NR_CPUS];
 static struct mm_struct **context_mm;
 static DEFINE_RAW_SPINLOCK(context_lock);
+static bool no_selective_tlbil;
 
 #define CTX_MAP_SIZE	\
 	(sizeof(unsigned long) * (last_context / BITS_PER_LONG + 1))
@@ -133,6 +136,38 @@ static unsigned int steal_context_smp(unsigned int id)
 }
 #endif  /* CONFIG_SMP */
 
+static unsigned int steal_all_contexts(void)
+{
+	struct mm_struct *mm;
+	int cpu = smp_processor_id();
+	unsigned int id;
+
+	for (id = first_context; id <= last_context; id++) {
+		/* Pick up the victim mm */
+		mm = context_mm[id];
+
+		pr_hardcont(" | steal %d from 0x%p", id, mm);
+
+		/* Mark this mm as having no context anymore */
+		mm->context.id = MMU_NO_CONTEXT;
+		if (id != first_context) {
+			context_mm[id] = NULL;
+			__clear_bit(id, context_map);
+#ifdef DEBUG_MAP_CONSISTENCY
+			mm->context.active = 0;
+#endif
+		}
+		__clear_bit(id, stale_map[cpu]);
+	}
+
+	/* Flush the TLB for all contexts (not to be used on SMP) */
+	_tlbil_all();
+
+	nr_free_contexts = last_context - first_context;
+
+	return first_context;
+}
+
 /* Note that this will also be called on SMP if all other CPUs are
  * offlined, which means that it may be called for cpu != 0. For
  * this to work, we somewhat assume that CPUs that are onlined
@@ -241,7 +276,10 @@ void switch_mmu_context(struct mm_struct *prev, struct mm_struct *next)
 			goto stolen;
 		}
 #endif /* CONFIG_SMP */
-		id = steal_context_up(id);
+		if (no_selective_tlbil)
+			id = steal_all_contexts();
+		else
+			id = steal_context_up(id);
 		goto stolen;
 	}
 	nr_free_contexts--;
@@ -407,12 +445,15 @@ void __init mmu_context_init(void)
 	if (mmu_has_feature(MMU_FTR_TYPE_8xx)) {
 		first_context = 0;
 		last_context = 15;
+		no_selective_tlbil = true;
 	} else if (mmu_has_feature(MMU_FTR_TYPE_47x)) {
 		first_context = 1;
 		last_context = 65535;
+		no_selective_tlbil = false;
 	} else {
 		first_context = 1;
 		last_context = 255;
+		no_selective_tlbil = false;
 	}
 
 #ifdef DEBUG_CLAMP_LAST_CONTEXT
-- 
2.1.0

