Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbaLDL0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 06:26:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50376 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbaLDLYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 06:24:49 -0500
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 09/10] mm: numa: Add paranoid check around pte_protnone_numa
Date: Thu,  4 Dec 2014 11:24:32 +0000
Message-Id: <1417692273-27170-10-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1417692273-27170-1-git-send-email-mgorman@suse.de>
References: <1417692273-27170-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pte_protnone_numa is only safe to use after VMA checks for PROT_NONE are
complete. Treating a real PROT_NONE PTE as a NUMA hinting fault is going
to result in strangeness so add a check for it. BUG_ON looks like overkill
but if this is hit then it's a serious bug that could result in corruption
so do not even try recovering. It would have been more comprehensive to
check VMA flags in pte_protnone_numa but it would have made the API ugly
just for a debugging check.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/huge_memory.c | 3 +++
 mm/memory.c      | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ad2a3ee..8546654 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1273,6 +1273,9 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	bool migrated = false;
 	int flags = 0;
 
+	/* A PROT_NONE fault should not end up here */
+	BUG_ON(!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)));
+
 	ptl = pmd_lock(mm, pmdp);
 	if (unlikely(!pmd_same(pmd, *pmdp)))
 		goto out_unlock;
diff --git a/mm/memory.c b/mm/memory.c
index 2ec07a9..7d97af5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3109,6 +3109,9 @@ static int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	bool migrated = false;
 	int flags = 0;
 
+	/* A PROT_NONE fault should not end up here */
+	BUG_ON(!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)));
+
 	/*
 	* The "pte" at this point cannot be used safely without
 	* validation through pte_unmap_same(). It's of NUMA type but
-- 
2.1.2

