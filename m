Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbaLXM3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 07:29:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:39291 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbaLXMXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 07:23:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="432964937"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: akpm@linux-foundation.org
Cc: peterz@infradead.org, mingo@kernel.org, davej@redhat.com,
        sasha.levin@oracle.com, hughd@google.com, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: [PATCH 25/38] mn10300: drop _PAGE_FILE and pte_file()-related helpers
Date: Wed, 24 Dec 2014 14:22:33 +0200
Message-Id: <1419423766-114457-26-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've replaced remap_file_pages(2) implementation with emulation.
Nobody creates non-linear mapping anymore.

This patch also increase number of bits availble for swap offset.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
---
 arch/mn10300/include/asm/pgtable.h | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/arch/mn10300/include/asm/pgtable.h b/arch/mn10300/include/asm/pgtable.h
index 2ddaa67e7983..629181ae111e 100644
--- a/arch/mn10300/include/asm/pgtable.h
+++ b/arch/mn10300/include/asm/pgtable.h
@@ -134,7 +134,6 @@ extern pte_t kernel_vmalloc_ptes[(VMALLOC_END - VMALLOC_START) / PAGE_SIZE];
 #define _PAGE_NX		0			/* no-execute bit */
 
 /* If _PAGE_VALID is clear, we use these: */
-#define _PAGE_FILE		xPTEL2_C	/* set:pagecache unset:swap */
 #define _PAGE_PROTNONE		0x000		/* If not present */
 
 #define __PAGE_PROT_UWAUX	0x010
@@ -241,11 +240,6 @@ static inline int pte_young(pte_t pte)	{ return pte_val(pte) & _PAGE_ACCESSED; }
 static inline int pte_write(pte_t pte)	{ return pte_val(pte) & __PAGE_PROT_WRITE; }
 static inline int pte_special(pte_t pte){ return 0; }
 
-/*
- * The following only works if pte_present() is not true.
- */
-static inline int pte_file(pte_t pte)	{ return pte_val(pte) & _PAGE_FILE; }
-
 static inline pte_t pte_rdprotect(pte_t pte)
 {
 	pte_val(pte) &= ~(__PAGE_PROT_USER|__PAGE_PROT_UWAUX); return pte;
@@ -338,16 +332,11 @@ static inline int pte_exec_kernel(pte_t pte)
 	return 1;
 }
 
-#define PTE_FILE_MAX_BITS	30
-
-#define pte_to_pgoff(pte)	(pte_val(pte) >> 2)
-#define pgoff_to_pte(off)	__pte((off) << 2 | _PAGE_FILE)
-
 /* Encode and de-code a swap entry */
-#define __swp_type(x)			(((x).val >> 2) & 0x3f)
-#define __swp_offset(x)			((x).val >> 8)
+#define __swp_type(x)			(((x).val >> 1) & 0x3f)
+#define __swp_offset(x)			((x).val >> 7)
 #define __swp_entry(type, offset) \
-	((swp_entry_t) { ((type) << 2) | ((offset) << 8) })
+	((swp_entry_t) { ((type) << 1) | ((offset) << 7) })
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)		__pte((x).val)
 
-- 
2.1.3

