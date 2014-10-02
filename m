Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaJBSsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:48:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbaJBSrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:47:48 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        Kirill A Shutemov <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] mm: migrate: Close race between migration completion and mprotect
Date: Thu,  2 Oct 2014 19:47:41 +0100
Message-Id: <1412275662-16201-2-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1412275662-16201-1-git-send-email-mgorman@suse.de>
References: <1412275662-16201-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A migration entry is marked as write if pte_write was true at the time the
entry was created. The VMA protections are not double checked when migration
entries are being removed as mprotect marks write-migration-entries as
read. It means that potentially we take a spurious fault to mark PTEs write
again but it's straight-forward. However, there is a race between write
migrations being marked read and migrations finishing. This potentially
allows a PTE to be write that should have been read. Close this race by
double checking the VMA permissions using maybe_mkwrite when migration
completes.

[torvalds@linux-foundation.org: use maybe_mkwrite]
Cc: stable@vger.kernel.org
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
---
 mm/migrate.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index f78ec9b..0c07339 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -146,8 +146,11 @@ static int remove_migration_pte(struct page *new, struct vm_area_struct *vma,
 	pte = pte_mkold(mk_pte(new, vma->vm_page_prot));
 	if (pte_swp_soft_dirty(*ptep))
 		pte = pte_mksoft_dirty(pte);
+
+	/* Recheck VMA as permissions can change since migration started  */
 	if (is_write_migration_entry(entry))
-		pte = pte_mkwrite(pte);
+		pte = maybe_mkwrite(pte, vma);
+
 #ifdef CONFIG_HUGETLB_PAGE
 	if (PageHuge(new)) {
 		pte = pte_mkhuge(pte);
-- 
1.8.4.5

