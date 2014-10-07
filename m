Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365AbaJGXnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:43:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495AbaJGXTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:19:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.16 06/26] mm: migrate: Close race between migration completion and mprotect
Date: Tue,  7 Oct 2014 16:19:22 -0700
Message-Id: <20141007231848.680657180@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231848.487609292@linuxfoundation.org>
References: <20141007231848.487609292@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/migrate.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -146,8 +146,11 @@ static int remove_migration_pte(struct p
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


