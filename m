Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaJ0TDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:03:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52720 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbaJ0TD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:03:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Chinner <dchinner@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 028/105] xfs: ensure WB_SYNC_ALL writeback handles partial pages correctly
Date: Mon, 27 Oct 2014 11:56:03 -0700
Message-Id: <1414436240-13879-29-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit 0d085a529b427d97710e6a41f8a4f23e1757cd12 upstream.

XFS has been having trouble with stray delayed allocation extents
beyond EOF for a long time. Recent changes to the collapse range
code has triggered erroneous EBUSY errors on page invalidtion for
block size smaller than page size filesystems. These
have been caused by dirty buffers beyond EOF on a partial page which
do not get written to disk during a sync.

The issue is that write-ahead in xfs_cluster_write() finds such a
partial page and handles it by leaving the page dirty but pushing it
into a writeback state. This used to work just fine, as the
write_cache_pages() code would then find the dirty partial page in
the next mapping tree lookup as the dirty tag is still set.

Unfortunately, when we moved to a mark and sweep approach to
writeback to fix other writeback sync issues, we broken this. THe
act of marking the page as under writeback now clears the TOWRITE
tag in the radix tree, even though the page is still dirty. This
causes the TOWRITE tag to be cleared, and hence the next lookup on
the mapping tree does not find the dirty partial page and so doesn't
try to write it again.

This same writeback bug was found recently in ext4 and fixed in
commit 1c8349a ("ext4: fix data integrity sync in ordered mode")
without communication to the wider filesystem community. We can use
exactly the same fix here so the TOWRITE flag is not cleared on
partial page writes.

Root-cause-found-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/xfs/xfs_aops.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 6dd69ae..e752236 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -434,10 +434,22 @@ xfs_start_page_writeback(
 {
 	ASSERT(PageLocked(page));
 	ASSERT(!PageWriteback(page));
-	if (clear_dirty)
+
+	/*
+	 * if the page was not fully cleaned, we need to ensure that the higher
+	 * layers come back to it correctly. That means we need to keep the page
+	 * dirty, and for WB_SYNC_ALL writeback we need to ensure the
+	 * PAGECACHE_TAG_TOWRITE index mark is not removed so another attempt to
+	 * write this page in this writeback sweep will be made.
+	 */
+	if (clear_dirty) {
 		clear_page_dirty_for_io(page);
-	set_page_writeback(page);
+		set_page_writeback(page);
+	} else
+		set_page_writeback_keepwrite(page);
+
 	unlock_page(page);
+
 	/* If no buffers on the page are to be written, finish it here */
 	if (!buffers)
 		end_page_writeback(page);
-- 
1.9.1

