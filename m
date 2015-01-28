Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964972AbbA2Cf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:35:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46944 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759863AbbA2Cfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:35:53 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 042/139] Btrfs: make sure we wait on logged extents when fsycning two subvols
Date: Wed, 28 Jan 2015 14:19:45 -0800
Message-Id: <1422483682-15393-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/btrfs/tree-log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 9f7fc51..51c038d 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2526,9 +2526,9 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	if (atomic_read(&log_root_tree->log_commit[index2])) {
 		blk_finish_plug(&plug);
 		btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
+		btrfs_wait_logged_extents(log, log_transid);
 		wait_log_commit(trans, log_root_tree,
 				log_root_tree->log_transid);
-		btrfs_free_logged_extents(log, log_transid);
 		mutex_unlock(&log_root_tree->log_mutex);
 		ret = 0;
 		goto out;
-- 
1.9.1

