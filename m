Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbbAHRCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:02:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756525AbbAHRBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:01:35 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH 2/3] xen: correct race in alloc_p2m_pmd()
Date: Thu,  8 Jan 2015 18:01:29 +0100
Message-Id: <1420736490-15351-3-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1420736490-15351-1-git-send-email-jgross@suse.com>
References: <1420736490-15351-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When allocating a new pmd for the linear mapped p2m list a check is
done for not introducing another pmd when this just happened on
another cpu. In this case the old pte pointer was returned which
points to the p2m_missing or p2m_identity page. The correct value
would be the pointer to the found new page.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/p2m.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 36ae094..fdb996e 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -440,10 +440,9 @@ EXPORT_SYMBOL_GPL(get_phys_to_machine);
  * a new pmd is to replace p2m_missing_pte or p2m_identity_pte by a individual
  * pmd. In case of PAE/x86-32 there are multiple pmds to allocate!
  */
-static pte_t *alloc_p2m_pmd(unsigned long addr, pte_t *ptep, pte_t *pte_pg)
+static pte_t *alloc_p2m_pmd(unsigned long addr, pte_t *pte_pg)
 {
 	pte_t *ptechk;
-	pte_t *pteret = ptep;
 	pte_t *pte_newpg[PMDS_PER_MID_PAGE];
 	pmd_t *pmdp;
 	unsigned int level;
@@ -477,8 +476,6 @@ static pte_t *alloc_p2m_pmd(unsigned long addr, pte_t *ptep, pte_t *pte_pg)
 		if (ptechk == pte_pg) {
 			set_pmd(pmdp,
 				__pmd(__pa(pte_newpg[i]) | _KERNPG_TABLE));
-			if (vaddr == (addr & ~(PMD_SIZE - 1)))
-				pteret = pte_offset_kernel(pmdp, addr);
 			pte_newpg[i] = NULL;
 		}
 
@@ -492,7 +489,7 @@ static pte_t *alloc_p2m_pmd(unsigned long addr, pte_t *ptep, pte_t *pte_pg)
 		vaddr += PMD_SIZE;
 	}
 
-	return pteret;
+	return lookup_address(addr, &level);
 }
 
 /*
@@ -521,7 +518,7 @@ static bool alloc_p2m(unsigned long pfn)
 
 	if (pte_pg == p2m_missing_pte || pte_pg == p2m_identity_pte) {
 		/* PMD level is missing, allocate a new one */
-		ptep = alloc_p2m_pmd(addr, ptep, pte_pg);
+		ptep = alloc_p2m_pmd(addr, pte_pg);
 		if (!ptep)
 			return false;
 	}
-- 
2.1.2

