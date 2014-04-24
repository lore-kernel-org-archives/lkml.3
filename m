Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbaDXIzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:55:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46928 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbaDXIzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:55:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vlastimil Babka <vbabka@suse.cz>, Bob Liu <bob.liu@oracle.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 134/182] mm: try_to_unmap_cluster() should lock_page() before mlocking
Date: Thu, 24 Apr 2014 09:50:59 +0100
Message-Id: <1398329507-5911-135-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/mlock.c |  2 ++
 mm/rmap.c  | 14 ++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 79b7cf7..713e462 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -76,6 +76,7 @@ void clear_page_mlock(struct page *page)
  */
 void mlock_vma_page(struct page *page)
 {
+	/* Serialize with page migration */
 	BUG_ON(!PageLocked(page));
 
 	if (!TestSetPageMlocked(page)) {
@@ -106,6 +107,7 @@ unsigned int munlock_vma_page(struct page *page)
 {
 	unsigned int page_mask = 0;
 
+	/* For try_to_munlock() and to serialize with page migration */
 	BUG_ON(!PageLocked(page));
 
 	if (TestClearPageMlocked(page)) {
diff --git a/mm/rmap.c b/mm/rmap.c
index 75f4c82..54935c5 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1395,9 +1395,19 @@ static int try_to_unmap_cluster(unsigned long cursor, unsigned int *mapcount,
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
 
-- 
1.9.1

