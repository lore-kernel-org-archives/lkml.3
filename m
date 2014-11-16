Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbaKPWBx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:01:53 -0500
Received: from 1wt.eu ([62.212.114.60]:48004 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbaKPWBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:01:50 -0500
Message-Id: <20141116215329.060529649@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:53:38 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Vlastimil Babka <vbabka@suse.cz>, Bob Liu <bob.liu@oracle.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>,
        Andy Whitcroft <andy.whitcroft@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 10/48] mm: try_to_unmap_cluster() should lock_page() before
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 mlocking

From: Vlastimil Babka <vbabka@suse.cz>

commit 68f662b89de39aae5f43ecd3fbc6ea120d0a47cf upstream

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
(back ported from commit 57e68e9cd65b4b8eb4045a1e0d0746458502554c)
CVE-2014-3122
BugLink: http://bugs.launchpad.net/bugs/1316268
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Acked-by: Andy Whitcroft <andy.whitcroft@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 mm/mlock.c |  2 ++
 mm/rmap.c  | 14 ++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 2d846cf..4db29b3 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -78,6 +78,7 @@ void __clear_page_mlock(struct page *page)
  */
 void mlock_vma_page(struct page *page)
 {
+	/* Serialize with page migration */
 	BUG_ON(!PageLocked(page));
 
 	if (!TestSetPageMlocked(page)) {
@@ -108,6 +109,7 @@ void mlock_vma_page(struct page *page)
  */
 void munlock_vma_page(struct page *page)
 {
+	/* For try_to_munlock() and to serialize with page migration */
 	BUG_ON(!PageLocked(page));
 
 	if (TestClearPageMlocked(page)) {
diff --git a/mm/rmap.c b/mm/rmap.c
index dd43373..cedeae8 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -944,9 +944,19 @@ static int try_to_unmap_cluster(unsigned long cursor, unsigned int *mapcount,
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
1.7.12.2.21.g234cd45.dirty



