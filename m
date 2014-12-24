Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaLXM02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 07:26:28 -0500
Received: from mga14.intel.com ([192.55.52.115]:54991 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbaLXMXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 07:23:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,638,1413270000"; 
   d="scan'208";a="628669855"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: akpm@linux-foundation.org
Cc: peterz@infradead.org, mingo@kernel.org, davej@redhat.com,
        sasha.levin@oracle.com, hughd@google.com, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Chris Metcalf <cmetcalf@ezchip.com>
Subject: [PATCH 34/38] tile: drop pte_file()-related helpers
Date: Wed, 24 Dec 2014 14:22:42 +0200
Message-Id: <1419423766-114457-35-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've replaced remap_file_pages(2) implementation with emulation.
Nobody creates non-linear mapping anymore.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
---
 arch/tile/include/asm/pgtable.h | 11 -----------
 arch/tile/mm/homecache.c        |  4 ----
 2 files changed, 15 deletions(-)

diff --git a/arch/tile/include/asm/pgtable.h b/arch/tile/include/asm/pgtable.h
index 5d1950788c69..bc75b6ef2e79 100644
--- a/arch/tile/include/asm/pgtable.h
+++ b/arch/tile/include/asm/pgtable.h
@@ -285,17 +285,6 @@ extern void start_mm_caching(struct mm_struct *mm);
 extern void check_mm_caching(struct mm_struct *prev, struct mm_struct *next);
 
 /*
- * Support non-linear file mappings (see sys_remap_file_pages).
- * This is defined by CLIENT1 set but CLIENT0 and _PAGE_PRESENT clear, and the
- * file offset in the 32 high bits.
- */
-#define _PAGE_FILE        HV_PTE_CLIENT1
-#define PTE_FILE_MAX_BITS 32
-#define pte_file(pte)     (hv_pte_get_client1(pte) && !hv_pte_get_client0(pte))
-#define pte_to_pgoff(pte) ((pte).val >> 32)
-#define pgoff_to_pte(off) ((pte_t) { (((long long)(off)) << 32) | _PAGE_FILE })
-
-/*
  * Encode and de-code a swap entry (see <linux/swapops.h>).
  * We put the swap file type+offset in the 32 high bits;
  * I believe we can just leave the low bits clear.
diff --git a/arch/tile/mm/homecache.c b/arch/tile/mm/homecache.c
index cd3387370ebb..0029b3fb651b 100644
--- a/arch/tile/mm/homecache.c
+++ b/arch/tile/mm/homecache.c
@@ -263,10 +263,6 @@ static int pte_to_home(pte_t pte)
 /* Update the home of a PTE if necessary (can also be used for a pgprot_t). */
 pte_t pte_set_home(pte_t pte, int home)
 {
-	/* Check for non-linear file mapping "PTEs" and pass them through. */
-	if (pte_file(pte))
-		return pte;
-
 #if CHIP_HAS_MMIO()
 	/* Check for MMIO mappings and pass them through. */
 	if (hv_pte_get_mode(pte) == HV_PTE_MODE_MMIO)
-- 
2.1.3

