Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbaIZKAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:00:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088AbaIZJql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:41 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 049/142] powerpc/mm: Use read barrier when creating real_pte
Date: Fri, 26 Sep 2014 11:44:20 +0200
Message-Id: <21c4de8afa1ae7d4a03015304c1dfc236b927a09.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/powerpc/include/asm/pte-hash64-64k.h | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/pte-hash64-64k.h b/arch/powerpc/include/asm/pte-hash64-64k.h
index d836d945068d..9ecede1e124c 100644
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
2.1.0

