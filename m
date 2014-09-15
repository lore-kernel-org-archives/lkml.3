Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881AbaIOXBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:01:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50837 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932677AbaIOWOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:14:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 185/187] powerpc/mm: Use read barrier when creating real_pte
Date: Mon, 15 Sep 2014 15:09:55 -0700
Message-Id: <1410818997-9432-186-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

commit 85c1fafd7262e68ad821ee1808686b1392b1167d upstream.

On ppc64 we support 4K hash pte with 64K page size. That requires
us to track the hash pte slot information on a per 4k basis. We do that
by storing the slot details in the second half of pte page. The pte bit
_PAGE_COMBO is used to indicate whether the second half need to be
looked while building real_pte. We need to use read memory barrier while
doing that so that load of hidx is not reordered w.r.t _PAGE_COMBO
check. On the store side we already do a lwsync in __hash_page_4K

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/include/asm/pte-hash64-64k.h | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/pte-hash64-64k.h b/arch/powerpc/include/asm/pte-hash64-64k.h
index d836d94..9ecede1 100644
--- a/arch/powerpc/include/asm/pte-hash64-64k.h
+++ b/arch/powerpc/include/asm/pte-hash64-64k.h
@@ -46,11 +46,31 @@
  * in order to deal with 64K made of 4K HW pages. Thus we override the
  * generic accessors and iterators here
  */
-#define __real_pte(e,p) 	((real_pte_t) { \
-			(e), (pte_val(e) & _PAGE_COMBO) ? \
-				(pte_val(*((p) + PTRS_PER_PTE))) : 0 })
-#define __rpte_to_hidx(r,index)	((pte_val((r).pte) & _PAGE_COMBO) ? \
-        (((r).hidx >> ((index)<<2)) & 0xf) : ((pte_val((r).pte) >> 12) & 0xf))
+#define __real_pte __real_pte
+static inline real_pte_t __real_pte(pte_t pte, pte_t *ptep)
+{
+	real_pte_t rpte;
+
+	rpte.pte = pte;
+	rpte.hidx = 0;
+	if (pte_val(pte) & _PAGE_COMBO) {
+		/*
+		 * Make sure we order the hidx load against the _PAGE_COMBO
+		 * check. The store side ordering is done in __hash_page_4K
+		 */
+		smp_rmb();
+		rpte.hidx = pte_val(*((ptep) + PTRS_PER_PTE));
+	}
+	return rpte;
+}
+
+static inline unsigned long __rpte_to_hidx(real_pte_t rpte, unsigned long index)
+{
+	if ((pte_val(rpte.pte) & _PAGE_COMBO))
+		return (rpte.hidx >> (index<<2)) & 0xf;
+	return (pte_val(rpte.pte) >> 12) & 0xf;
+}
+
 #define __rpte_to_pte(r)	((r).pte)
 #define __rpte_sub_valid(rpte, index) \
 	(pte_val(rpte.pte) & (_PAGE_HPTE_SUB0 >> (index)))
-- 
1.9.1

