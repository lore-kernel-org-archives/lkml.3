Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaKFWl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:41:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58713 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbaKFWlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:41:17 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 050/162] sparc64: Increase MAX_PHYS_ADDRESS_BITS to 53.
Date: Thu,  6 Nov 2014 14:35:14 -0800
Message-Id: <1415313426-9622-51-git-send-email-kamal@canonical.com>
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

[ Upstream commit 7c0fa0f24bb76ce3d67be7f737b799846a04570f ]

Make sure, at compile time, that the kernel can properly support
whatever MAX_PHYS_ADDRESS_BITS is defined to.

On M7 chips, use a max_phys_bits value of 49.

Based upon a patch by Bob Picco.

Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Bob Picco <bob.picco@oracle.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/include/asm/page_64.h    | 8 ++++----
 arch/sparc/include/asm/pgtable_64.h | 4 ++++
 arch/sparc/mm/init_64.c             | 9 ++++++++-
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/sparc/include/asm/page_64.h b/arch/sparc/include/asm/page_64.h
index b70210d..275fc6c 100644
--- a/arch/sparc/include/asm/page_64.h
+++ b/arch/sparc/include/asm/page_64.h
@@ -122,11 +122,11 @@ extern unsigned long PAGE_OFFSET;
 
 #endif /* !(__ASSEMBLY__) */
 
-/* The maximum number of physical memory address bits we support, this
- * is used to size various tables used to manage kernel TLB misses and
- * also the sparsemem code.
+/* The maximum number of physical memory address bits we support.  The
+ * largest value we can support is whatever "KPGD_SHIFT + KPTE_BITS"
+ * evaluates to.
  */
-#define MAX_PHYS_ADDRESS_BITS	47
+#define MAX_PHYS_ADDRESS_BITS	53
 
 #define ILOG2_4MB		22
 #define ILOG2_256MB		28
diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index be03c00..58547f7 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -67,6 +67,10 @@
 #define PGDIR_MASK	(~(PGDIR_SIZE-1))
 #define PGDIR_BITS	(PAGE_SHIFT - 3)
 
+#if (MAX_PHYS_ADDRESS_BITS > PGDIR_SHIFT + PGDIR_BITS)
+#error MAX_PHYS_ADDRESS_BITS exceeds what kernel page tables can support
+#endif
+
 #if (PGDIR_SHIFT + PGDIR_BITS) != 53
 #error Page table parameters do not cover virtual address space properly.
 #endif
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 75d26ee..9565f4d 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1683,12 +1683,19 @@ static void __init setup_page_offset(void)
 		case SUN4V_CHIP_NIAGARA4:
 		case SUN4V_CHIP_NIAGARA5:
 		case SUN4V_CHIP_SPARC64X:
-		default:
+		case SUN4V_CHIP_SPARC_M6:
 			/* T4 and later support 52-bit virtual addresses.  */
 			sparc64_va_hole_top =    0xfff8000000000000UL;
 			sparc64_va_hole_bottom = 0x0008000000000000UL;
 			max_phys_bits = 47;
 			break;
+		case SUN4V_CHIP_SPARC_M7:
+		default:
+			/* M7 and later support 52-bit virtual addresses.  */
+			sparc64_va_hole_top =    0xfff8000000000000UL;
+			sparc64_va_hole_bottom = 0x0008000000000000UL;
+			max_phys_bits = 49;
+			break;
 		}
 	}
 
-- 
1.9.1

