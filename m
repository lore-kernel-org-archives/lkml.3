Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbbAGCBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:01:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46250 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031AbbAGBwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:52:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.18 80/84] Btrfs: make sure we wait on logged extents when fsycning two subvols
Date: Tue,  6 Jan 2015 17:50:23 -0800
Message-Id: <20150107014031.552710806@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014029.012974975@linuxfoundation.org>
References: <20150107014029.012974975@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/tree-log.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2600,9 +2600,9 @@ int btrfs_sync_log(struct btrfs_trans_ha
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


