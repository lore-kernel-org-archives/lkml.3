Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbaK0Itk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:49:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:42556 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094AbaK0Itf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:49:35 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 71/91] mm: migrate: Close race between migration completion and mprotect
Date: Thu, 27 Nov 2014 16:42:54 +0800
Message-Id: <1417077794-9299-71-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mgorman@suse.de>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit d3cb8bf6081b8b7a2dabb1264fe968fd870fa595 upstream.

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
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 mm/migrate.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 5f588b1..98b998f 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -139,8 +139,11 @@ static int remove_migration_pte(struct page *new, struct vm_area_struct *vma,
 
 	get_page(new);
 	pte = pte_mkold(mk_pte(new, vma->vm_page_prot));
+
+	/* Recheck VMA as permissions can change since migration started  */
 	if (is_write_migration_entry(entry))
-		pte = pte_mkwrite(pte);
+		pte = maybe_mkwrite(pte, vma);
+
 #ifdef CONFIG_HUGETLB_PAGE
 	if (PageHuge(new))
 		pte = pte_mkhuge(pte);
-- 
1.9.1

