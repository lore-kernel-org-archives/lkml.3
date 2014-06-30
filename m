Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbaF3MTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:19:25 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51942 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753236AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 025/181] Btrfs: do not release metadata for space cache inodes
Date: Mon, 30 Jun 2014 13:50:46 +0200
Message-Id: <4b6d66d14e0d502e3109659d9ae4a2d87bfd52e3.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josef Bacik <jbacik@fusionio.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b6d08f0630d51ec09d67f16f6d7839699bbc0402 upstream.

I've been testing our error paths and I was tripping the BUG_ON() in
drop_outstanding_extent because our outstanding_extents is 0 for space cache
inodes.  This is because we don't reserve metadata space for these inodes since
we depend on the global block reserve for our space.  To fix this we need to
make sure the DO_ACCOUNTING stuff doesn't actually call release_metadata for
space cache inodes.  With this patch I'm no longer panicing.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 250ed4ef6b91..fa8010c1b628 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1551,7 +1551,13 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 			spin_unlock(&BTRFS_I(inode)->lock);
 		}
 
-		if (*bits & EXTENT_DO_ACCOUNTING)
+		/*
+		 * We don't reserve metadata space for space cache inodes so we
+		 * don't need to call dellalloc_release_metadata if there is an
+		 * error.
+		 */
+		if (*bits & EXTENT_DO_ACCOUNTING &&
+		    root != root->fs_info->tree_root)
 			btrfs_delalloc_release_metadata(inode, len);
 
 		if (root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID
-- 
2.0.0

