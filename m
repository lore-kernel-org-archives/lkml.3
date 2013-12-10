Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3LJPyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:54:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44427 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866Ab3LJPvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:51:44 -0500
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 09/18] mm: numa: Clear numa hinting information on mprotect
Date: Tue, 10 Dec 2013 15:51:27 +0000
Message-Id: <1386690695-27380-10-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386690695-27380-1-git-send-email-mgorman@suse.de>
References: <1386690695-27380-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a protection change it is no longer clear if the page should be still
accessible.  This patch clears the NUMA hinting fault bits on a protection
change.

Cc: stable@vger.kernel.org
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
---
 mm/huge_memory.c | 2 ++
 mm/mprotect.c    | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0f00b96..0ecaba2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1522,6 +1522,8 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		ret = 1;
 		if (!prot_numa) {
 			entry = pmdp_get_and_clear(mm, addr, pmd);
+			if (pmd_numa(entry))
+				entry = pmd_mknonnuma(entry);
 			entry = pmd_modify(entry, newprot);
 			ret = HPAGE_PMD_NR;
 			BUG_ON(pmd_write(entry));
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 0a07e2d..eb2f349 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -54,6 +54,8 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 
 			if (!prot_numa) {
 				ptent = ptep_modify_prot_start(mm, addr, pte);
+				if (pte_numa(ptent))
+					ptent = pte_mknonnuma(ptent);
 				ptent = pte_modify(ptent, newprot);
 				updated = true;
 			} else {
-- 
1.8.4

