Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbbAEKy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:54:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbbAEKy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:54:26 -0500
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 10/10] mm: numa: Avoid unnecessary TLB flushes when setting NUMA hinting entries
Date: Mon,  5 Jan 2015 10:54:11 +0000
Message-Id: <1420455251-13644-11-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1420455251-13644-1-git-send-email-mgorman@suse.de>
References: <1420455251-13644-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a PTE or PMD is already marked NUMA when scanning to mark entries
for NUMA hinting then it is not necessary to update the entry and
incur a TLB flush penalty. Avoid the avoidhead where possible.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/huge_memory.c | 14 ++++++++------
 mm/mprotect.c    |  4 ++++
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8546654..f2bf521 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1524,12 +1524,14 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 			return 0;
 		}
 
-		ret = 1;
-		entry = pmdp_get_and_clear_notify(mm, addr, pmd);
-		entry = pmd_modify(entry, newprot);
-		ret = HPAGE_PMD_NR;
-		set_pmd_at(mm, addr, pmd, entry);
-		BUG_ON(pmd_write(entry));
+		if (!prot_numa || !pmd_protnone(*pmd)) {
+			ret = 1;
+			entry = pmdp_get_and_clear_notify(mm, addr, pmd);
+			entry = pmd_modify(entry, newprot);
+			ret = HPAGE_PMD_NR;
+			set_pmd_at(mm, addr, pmd, entry);
+			BUG_ON(pmd_write(entry));
+		}
 		spin_unlock(ptl);
 	}
 
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 33dfafb..109e7aa 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -86,6 +86,10 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 				page = vm_normal_page(vma, addr, oldpte);
 				if (!page || PageKsm(page))
 					continue;
+
+				/* Avoid TLB flush if possible */
+				if (pte_protnone(oldpte))
+					continue;
 			}
 
 			ptent = ptep_modify_prot_start(mm, addr, pte);
-- 
2.1.2

