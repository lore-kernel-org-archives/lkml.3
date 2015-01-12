Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbbALTJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:09:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57465 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbbALSFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:52 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 041/216] Btrfs: make sure we wait on logged extents when fsycning two subvols
Date: Mon, 12 Jan 2015 18:02:38 +0000
Message-Id: <1421085933-32536-42-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fb.com>

commit 9dba8cf128ef98257ca719722280c9634e7e9dc7 upstream.

If we have two fsync()'s race on different subvols one will do all of its work
to get into the log_tree, wait on it's outstanding IO, and then allow the
log_tree to finish it's commit.  The problem is we were just free'ing that
subvols logged extents instead of waiting on them, so whoever lost the race
wouldn't really have their data on disk.  Fix this by waiting properly instead
of freeing the logged extents.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/tree-log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 9e1f2cd5e67a..b190efaf5688 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2596,9 +2596,9 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	if (atomic_read(&log_root_tree->log_commit[index2])) {
 		blk_finish_plug(&plug);
 		btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
+		btrfs_wait_logged_extents(log, log_transid);
 		wait_log_commit(trans, log_root_tree,
 				root_log_ctx.log_transid);
-		btrfs_free_logged_extents(log, log_transid);
 		mutex_unlock(&log_root_tree->log_mutex);
 		ret = root_log_ctx.log_ret;
 		goto out;
-- 
2.1.4

