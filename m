Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbaIKMlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:41:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51680 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755456AbaIKMeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.602516901@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 064/131] powerpc/mm: Use read barrier when creating
 real_pte
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: include <asm/system.h> to ensure smp_rmb()
 is defined; cell_defconfig fails to build without this]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/include/asm/pte-hash64-64k.h | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

--- a/arch/powerpc/include/asm/pte-hash64-64k.h
+++ b/arch/powerpc/include/asm/pte-hash64-64k.h
@@ -40,17 +40,39 @@
 
 #ifndef __ASSEMBLY__
 
+#include <asm/system.h> /* for smp_rmb() */
+
 /*
  * With 64K pages on hash table, we have a special PTE format that
  * uses a second "half" of the page table to encode sub-page information
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

