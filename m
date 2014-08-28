Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaH1ShY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:37:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbaH1ShR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:37:17 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 87/97] mm/memory.c: use entry = ACCESS_ONCE(*pte) in handle_pte_fault()
Date: Thu, 28 Aug 2014 19:35:35 +0100
Message-Id: <1409250945-30874-88-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

commit c0d73261f5c1355a35b8b40e871d31578ce0c044 upstream.

Use ACCESS_ONCE() in handle_pte_fault() when getting the entry or
orig_pte upon which all subsequent decisions and pte_same() tests will
be made.

I have no evidence that its lack is responsible for the mm/filemap.c:202
BUG_ON(page_mapped(page)) in __delete_from_page_cache() found by
trinity, and I am not optimistic that it will fix it.  But I have found
no other explanation, and ACCESS_ONCE() here will surely not hurt.

If gcc does re-access the pte before passing it down, then that would be
disastrous for correct page fault handling, and certainly could explain
the page_mapped() BUGs seen (concurrent fault causing page to be mapped
in a second time on top of itself: mapcount 2 for a single pte).

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 99fe3aa..b870c9c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3698,7 +3698,7 @@ static int handle_pte_fault(struct mm_struct *mm,
 	pte_t entry;
 	spinlock_t *ptl;
 
-	entry = *pte;
+	entry = ACCESS_ONCE(*pte);
 	if (!pte_present(entry)) {
 		if (pte_none(entry)) {
 			if (vma->vm_ops) {
-- 
1.8.4.5

