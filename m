Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbaKAXBI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 19:01:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60074 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751487AbaKAWj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mel Gorman" <mgorman@suse.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Rik van Riel" <riel@redhat.com>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.129046125@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 075/102] mm: migrate: Close race between migration
 completion and mprotect
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/migrate.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -141,8 +141,11 @@ static int remove_migration_pte(struct p
 
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

