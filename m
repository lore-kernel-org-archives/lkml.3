Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbaKFXIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:08:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58786 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbaKFWlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:41:47 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 047/162] sparc64: Adjust KTSB assembler to support larger physical addresses.
Date: Thu,  6 Nov 2014 14:35:11 -0800
Message-Id: <1415313426-9622-48-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 8c82dc0e883821c098c8b0b130ffebabf9aab5df ]

As currently coded the KTSB accesses in the kernel only support up to
47 bits of physical addressing.

Adjust the instruction and patching sequence in order to support
arbitrary 64 bits addresses.

Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Bob Picco <bob.picco@oracle.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/include/asm/tsb.h | 30 ++++++++++++------------------
 arch/sparc/mm/init_64.c      | 28 +++++++++++++++++++++++++---
 2 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/arch/sparc/include/asm/tsb.h b/arch/sparc/include/asm/tsb.h
index 2e268b6..a2f5419 100644
--- a/arch/sparc/include/asm/tsb.h
+++ b/arch/sparc/include/asm/tsb.h
@@ -256,8 +256,6 @@ extern struct tsb_phys_patch_entry __tsb_phys_patch, __tsb_phys_patch_end;
 	(KERNEL_TSB_SIZE_BYTES / 16)
 #define KERNEL_TSB4M_NENTRIES	4096
 
-#define KTSB_PHYS_SHIFT		15
-
 	/* Do a kernel TSB lookup at tl>0 on VADDR+TAG, branch to OK_LABEL
 	 * on TSB hit.  REG1, REG2, REG3, and REG4 are used as temporaries
 	 * and the found TTE will be left in REG1.  REG3 and REG4 must
@@ -266,17 +264,15 @@ extern struct tsb_phys_patch_entry __tsb_phys_patch, __tsb_phys_patch_end;
 	 * VADDR and TAG will be preserved and not clobbered by this macro.
 	 */
 #define KERN_TSB_LOOKUP_TL1(VADDR, TAG, REG1, REG2, REG3, REG4, OK_LABEL) \
-661:	sethi		%hi(swapper_tsb), REG1;			\
-	or		REG1, %lo(swapper_tsb), REG1; \
+661:	sethi		%uhi(swapper_tsb), REG1; \
+	sethi		%hi(swapper_tsb), REG2; \
+	or		REG1, %ulo(swapper_tsb), REG1; \
+	or		REG2, %lo(swapper_tsb), REG2; \
 	.section	.swapper_tsb_phys_patch, "ax"; \
 	.word		661b; \
 	.previous; \
-661:	nop; \
-	.section	.tsb_ldquad_phys_patch, "ax"; \
-	.word		661b; \
-	sllx		REG1, KTSB_PHYS_SHIFT, REG1; \
-	sllx		REG1, KTSB_PHYS_SHIFT, REG1; \
-	.previous; \
+	sllx		REG1, 32, REG1; \
+	or		REG1, REG2, REG1; \
 	srlx		VADDR, PAGE_SHIFT, REG2; \
 	and		REG2, (KERNEL_TSB_NENTRIES - 1), REG2; \
 	sllx		REG2, 4, REG2; \
@@ -291,17 +287,15 @@ extern struct tsb_phys_patch_entry __tsb_phys_patch, __tsb_phys_patch_end;
 	 * we can make use of that for the index computation.
 	 */
 #define KERN_TSB4M_LOOKUP_TL1(TAG, REG1, REG2, REG3, REG4, OK_LABEL) \
-661:	sethi		%hi(swapper_4m_tsb), REG1;	     \
-	or		REG1, %lo(swapper_4m_tsb), REG1; \
+661:	sethi		%uhi(swapper_4m_tsb), REG1; \
+	sethi		%hi(swapper_4m_tsb), REG2; \
+	or		REG1, %ulo(swapper_4m_tsb), REG1; \
+	or		REG2, %lo(swapper_4m_tsb), REG2; \
 	.section	.swapper_4m_tsb_phys_patch, "ax"; \
 	.word		661b; \
 	.previous; \
-661:	nop; \
-	.section	.tsb_ldquad_phys_patch, "ax"; \
-	.word		661b; \
-	sllx		REG1, KTSB_PHYS_SHIFT, REG1; \
-	sllx		REG1, KTSB_PHYS_SHIFT, REG1; \
-	.previous; \
+	sllx		REG1, 32, REG1; \
+	or		REG1, REG2, REG1; \
 	and		TAG, (KERNEL_TSB4M_NENTRIES - 1), REG2; \
 	sllx		REG2, 4, REG2; \
 	add		REG1, REG2, REG2; \
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 44eb215..f743f05 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1726,19 +1726,41 @@ static void __init tsb_phys_patch(void)
 static struct hv_tsb_descr ktsb_descr[NUM_KTSB_DESCR];
 extern struct tsb swapper_tsb[KERNEL_TSB_NENTRIES];
 
+/* The swapper TSBs are loaded with a base sequence of:
+ *
+ *	sethi	%uhi(SYMBOL), REG1
+ *	sethi	%hi(SYMBOL), REG2
+ *	or	REG1, %ulo(SYMBOL), REG1
+ *	or	REG2, %lo(SYMBOL), REG2
+ *	sllx	REG1, 32, REG1
+ *	or	REG1, REG2, REG1
+ *
+ * When we use physical addressing for the TSB accesses, we patch the
+ * first four instructions in the above sequence.
+ */
+
 static void patch_one_ktsb_phys(unsigned int *start, unsigned int *end, unsigned long pa)
 {
-	pa >>= KTSB_PHYS_SHIFT;
+	unsigned long high_bits, low_bits;
+
+	high_bits = (pa >> 32) & 0xffffffff;
+	low_bits = (pa >> 0) & 0xffffffff;
 
 	while (start < end) {
 		unsigned int *ia = (unsigned int *)(unsigned long)*start;
 
-		ia[0] = (ia[0] & ~0x3fffff) | (pa >> 10);
+		ia[0] = (ia[0] & ~0x3fffff) | (high_bits >> 10);
 		__asm__ __volatile__("flush	%0" : : "r" (ia));
 
-		ia[1] = (ia[1] & ~0x3ff) | (pa & 0x3ff);
+		ia[1] = (ia[1] & ~0x3fffff) | (low_bits >> 10);
 		__asm__ __volatile__("flush	%0" : : "r" (ia + 1));
 
+		ia[2] = (ia[2] & ~0x1fff) | (high_bits & 0x3ff);
+		__asm__ __volatile__("flush	%0" : : "r" (ia + 2));
+
+		ia[3] = (ia[3] & ~0x1fff) | (low_bits & 0x3ff);
+		__asm__ __volatile__("flush	%0" : : "r" (ia + 3));
+
 		start++;
 	}
 }
-- 
1.9.1

