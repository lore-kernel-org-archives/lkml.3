Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772AbaKTKXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 05:23:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757483AbaKTKUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 05:20:07 -0500
From: Mel Gorman <mgorman@suse.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linux-MM <linux-mm@kvack.org>,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 09/10] mm: numa: Add paranoid check around pte_protnone_numa
Date: Thu, 20 Nov 2014 10:19:49 +0000
Message-Id: <1416478790-27522-10-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1416478790-27522-1-git-send-email-mgorman@suse.de>
References: <1416478790-27522-1-git-send-email-mgorman@suse.de>
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
index 3013eb8..6458229f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1274,6 +1274,9 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	bool migrated = false;
 	int flags = 0;
 
+	/* A PROT_NONE fault should not end up here */
+	BUG_ON(!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)));
+
 	ptl = pmd_lock(mm, pmdp);
 	if (unlikely(!pmd_same(pmd, *pmdp)))
 		goto out_unlock;
diff --git a/mm/memory.c b/mm/memory.c
index a725c08..42d652d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3115,6 +3115,9 @@ static int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
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

