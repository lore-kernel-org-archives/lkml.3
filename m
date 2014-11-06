Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaKFWlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:41:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58778 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbaKFWlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:41:44 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 046/162] sparc64: Define VA hole at run time, rather than at compile time.
Date: Thu,  6 Nov 2014 14:35:10 -0800
Message-Id: <1415313426-9622-47-git-send-email-kamal@canonical.com>
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

[ Upstream commit 4397bed080598001e88f612deb8b080bb1cc2322 ]

Now that we use 4-level page tables, we can provide up to 53-bits of
virtual address space to the user.

Adjust the VA hole based upon the capabilities of the cpu type probed.

Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Bob Picco <bob.picco@oracle.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/include/asm/page_64.h | 15 ++++-----------
 arch/sparc/mm/init_64.c          | 21 +++++++++++++++++++++
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/arch/sparc/include/asm/page_64.h b/arch/sparc/include/asm/page_64.h
index 3747c4f..6dc1948 100644
--- a/arch/sparc/include/asm/page_64.h
+++ b/arch/sparc/include/asm/page_64.h
@@ -102,21 +102,14 @@ typedef unsigned long pgprot_t;
 
 typedef pte_t *pgtable_t;
 
-/* These two values define the virtual address space range in which we
- * must forbid 64-bit user processes from making mappings.  It used to
- * represent precisely the virtual address space hole present in most
- * early sparc64 chips including UltraSPARC-I.  But now it also is
- * further constrained by the limits of our page tables, which is
- * 43-bits of virtual address.
- */
-#define SPARC64_VA_HOLE_TOP	_AC(0xfffffc0000000000,UL)
-#define SPARC64_VA_HOLE_BOTTOM	_AC(0x0000040000000000,UL)
+extern unsigned long sparc64_va_hole_top;
+extern unsigned long sparc64_va_hole_bottom;
 
 /* The next two defines specify the actual exclusion region we
  * enforce, wherein we use a 4GB red zone on each side of the VA hole.
  */
-#define VA_EXCLUDE_START (SPARC64_VA_HOLE_BOTTOM - (1UL << 32UL))
-#define VA_EXCLUDE_END   (SPARC64_VA_HOLE_TOP + (1UL << 32UL))
+#define VA_EXCLUDE_START (sparc64_va_hole_bottom - (1UL << 32UL))
+#define VA_EXCLUDE_END   (sparc64_va_hole_top + (1UL << 32UL))
 
 #define TASK_UNMAPPED_BASE	(test_thread_flag(TIF_32BIT) ? \
 				 _AC(0x0000000070000000,UL) : \
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 7b03310..44eb215 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1623,25 +1623,46 @@ static void __init page_offset_shift_patch(unsigned long phys_bits)
 	}
 }
 
+unsigned long sparc64_va_hole_top =    0xfffff80000000000UL;
+unsigned long sparc64_va_hole_bottom = 0x0000080000000000UL;
+
 static void __init setup_page_offset(void)
 {
 	unsigned long max_phys_bits = 40;
 
 	if (tlb_type == cheetah || tlb_type == cheetah_plus) {
+		/* Cheetah/Panther support a full 64-bit virtual
+		 * address, so we can use all that our page tables
+		 * support.
+		 */
+		sparc64_va_hole_top =    0xfff0000000000000UL;
+		sparc64_va_hole_bottom = 0x0010000000000000UL;
+
 		max_phys_bits = 42;
 	} else if (tlb_type == hypervisor) {
 		switch (sun4v_chip_type) {
 		case SUN4V_CHIP_NIAGARA1:
 		case SUN4V_CHIP_NIAGARA2:
+			/* T1 and T2 support 48-bit virtual addresses.  */
+			sparc64_va_hole_top =    0xffff800000000000UL;
+			sparc64_va_hole_bottom = 0x0000800000000000UL;
+
 			max_phys_bits = 39;
 			break;
 		case SUN4V_CHIP_NIAGARA3:
+			/* T3 supports 48-bit virtual addresses.  */
+			sparc64_va_hole_top =    0xffff800000000000UL;
+			sparc64_va_hole_bottom = 0x0000800000000000UL;
+
 			max_phys_bits = 43;
 			break;
 		case SUN4V_CHIP_NIAGARA4:
 		case SUN4V_CHIP_NIAGARA5:
 		case SUN4V_CHIP_SPARC64X:
 		default:
+			/* T4 and later support 52-bit virtual addresses.  */
+			sparc64_va_hole_top =    0xfff8000000000000UL;
+			sparc64_va_hole_bottom = 0x0008000000000000UL;
 			max_phys_bits = 47;
 			break;
 		}
-- 
1.9.1

