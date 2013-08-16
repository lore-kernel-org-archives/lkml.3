Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563Ab3HQAXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:23:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51538 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab3HPWiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:38:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josef Bacik <jbacik@fusionio.com>, Chris Mason <chris.mason@fusionio.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 112/133] Btrfs: release both paths before logging dir/changed extents
Date: Fri, 16 Aug 2013 15:34:14 -0700
Message-Id: <1376692475-28413-113-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit f3b15ccdbb9a79781578249a63318805e55a6c34 upstream.

The ceph guys tripped over this bug where we were still holding onto the
original path that we used to copy the inode with when logging.  This is based
on Chris's fix which was reported to fix the problem.  We need to drop the paths
in two cases anyway so just move the drop up so that we don't have duplicate
code.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/btrfs/tree-log.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 8a00e2f..372a7d4 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3684,8 +3684,9 @@ next_slot:
 	}
 
 log_extents:
+	btrfs_release_path(path);
+	btrfs_release_path(dst_path);
 	if (fast_search) {
-		btrfs_release_path(dst_path);
 		ret = btrfs_log_changed_extents(trans, root, inode, dst_path);
 		if (ret) {
 			err = ret;
@@ -3702,8 +3703,6 @@ log_extents:
 	}
 
 	if (inode_only == LOG_INODE_ALL && S_ISDIR(inode->i_mode)) {
-		btrfs_release_path(path);
-		btrfs_release_path(dst_path);
 		ret = log_directory_changes(trans, root, inode, path, dst_path);
 		if (ret) {
 			err = ret;
-- 
1.8.1.2

