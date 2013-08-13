Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab3HMGdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:33:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524Ab3HMGdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [ 28/60] Btrfs: release both paths before logging dir/changed extents
Date: Mon, 12 Aug 2013 23:33:55 -0700
Message-Id: <20130813063335.999357981@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/tree-log.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3728,8 +3728,9 @@ next_slot:
 	}
 
 log_extents:
+	btrfs_release_path(path);
+	btrfs_release_path(dst_path);
 	if (fast_search) {
-		btrfs_release_path(dst_path);
 		ret = btrfs_log_changed_extents(trans, root, inode, dst_path);
 		if (ret) {
 			err = ret;
@@ -3746,8 +3747,6 @@ log_extents:
 	}
 
 	if (inode_only == LOG_INODE_ALL && S_ISDIR(inode->i_mode)) {
-		btrfs_release_path(path);
-		btrfs_release_path(dst_path);
 		ret = log_directory_changes(trans, root, inode, path, dst_path);
 		if (ret) {
 			err = ret;


