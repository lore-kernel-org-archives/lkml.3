Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936357Ab3DHKLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:11:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42833 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935713Ab3DHJwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josef Bacik <jbacik@fusionio.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 052/102] Btrfs: use set_nlink if our i_nlink is 0
Date: Mon,  8 Apr 2013 10:50:07 +0100
Message-Id: <1365414657-29191-53-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit 9bf7a4890518186238d2579be16ecc5190a707c0 upstream.

We need to inc the nlink of deleted entries when running replay so we can do the
unlink on the fs_root and get everything cleaned up and then have the orphan
cleanup do the right thing.  The problem is inc_nlink complains about this, even
thought it still does the right thing.  So use set_nlink() if our i_nlink is 0
to keep users from seeing the warnings during log replay.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/tree-log.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 8abeae4..aad8644 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1132,7 +1132,10 @@ static noinline int link_to_fixup_dir(struct btrfs_trans_handle *trans,
 
 	btrfs_release_path(path);
 	if (ret == 0) {
-		btrfs_inc_nlink(inode);
+		if (!inode->i_nlink)
+			set_nlink(inode, 1);
+		else
+			btrfs_inc_nlink(inode);
 		btrfs_update_inode(trans, root, inode);
 	} else if (ret == -EEXIST) {
 		ret = 0;
-- 
1.8.1.2

