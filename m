Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbaD1BcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:32:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43010 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752778AbaD1B3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:22 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Wanpeng Li" <liwanp@linux.vnet.ibm.com>,
        "Bob Liu" <bob.liu@oracle.com>, "Sasha Levin" <sasha.levin@oracle.com>,
        "Vlastimil Babka" <vbabka@suse.cz>, "Mel Gorman" <mgorman@suse.de>,
        "Rik van Riel" <riel@redhat.com>,
        "Joonsoo Kim" <iamjoonsoo.kim@lge.com>,
        "Hugh Dickins" <hughd@google.com>,
        "Michel Lespinasse" <walken@google.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
        "David Rientjes" <rientjes@google.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.469240383@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 80/94] mm: try_to_unmap_cluster() should lock_page()
 before mlocking
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Vlastimil Babka <vbabka@suse.cz>

commit 57e68e9cd65b4b8eb4045a1e0d0746458502554c upstream.

A BUG_ON(!PageLocked) was triggered in mlock_vma_page() by Sasha Levin
fuzzing with trinity.  The call site try_to_unmap_cluster() does not lock
the pages other than its check_page parameter (which is already locked).

The BUG_ON in mlock_vma_page() is not documented and its purpose is
somewhat unclear, but apparently it serializes against page migration,
which could otherwise fail to transfer the PG_mlocked flag.  This would
not be fatal, as the page would be eventually encountered again, but
NR_MLOCK accounting would become distorted nevertheless.  This patch adds
a comment to the BUG_ON in mlock_vma_page() and munlock_vma_page() to that
effect.

The call site try_to_unmap_cluster() is fixed so that for page !=
check_page, trylock_page() is attempted (to avoid possible deadlocks as we
already have check_page locked) and mlock_vma_page() is performed only
upon success.  If the page lock cannot be obtained, the page is left
without PG_mlocked, which is again not a problem in the whole unevictable
memory design.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Bob Liu <bob.liu@oracle.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/mlock.c |  2 ++
 mm/rmap.c  | 14 ++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -78,6 +78,7 @@ void __clear_page_mlock(struct page *pag
  */
 void mlock_vma_page(struct page *page)
 {
+	/* Serialize with page migration */
 	BUG_ON(!PageLocked(page));
 
 	if (!TestSetPageMlocked(page)) {
@@ -105,6 +106,7 @@ void mlock_vma_page(struct page *page)
  */
 void munlock_vma_page(struct page *page)
 {
+	/* For try_to_munlock() and to serialize with page migration */
 	BUG_ON(!PageLocked(page));
 
 	if (TestClearPageMlocked(page)) {
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1385,9 +1385,19 @@ static int try_to_unmap_cluster(unsigned
 		BUG_ON(!page || PageAnon(page));
 
 		if (locked_vma) {
-			mlock_vma_page(page);   /* no-op if already mlocked */
-			if (page == check_page)
+			if (page == check_page) {
+				/* we know we have check_page locked */
+				mlock_vma_page(page);
 				ret = SWAP_MLOCK;
+			} else if (trylock_page(page)) {
+				/*
+				 * If we can lock the page, perform mlock.
+				 * Otherwise leave the page alone, it will be
+				 * eventually encountered again later.
+				 */
+				mlock_vma_page(page);
+				unlock_page(page);
+			}
 			continue;	/* don't unmap */
 		}
 

