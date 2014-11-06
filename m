Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaKFWxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:53:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59063 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbaKFWn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:43:57 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 067/162] ext4: don't orphan or truncate the boot loader inode
Date: Thu,  6 Nov 2014 14:35:31 -0800
Message-Id: <1415313426-9622-68-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit e2bfb088fac03c0f621886a04cffc7faa2b49b1d upstream.

The boot loader inode (inode #5) should never be visible in the
directory hierarchy, but it's possible if the file system is corrupted
that there will be a directory entry that points at inode #5.  In
order to avoid accidentally trashing it, when such a directory inode
is opened, the inode will be marked as a bad inode, so that it's not
possible to modify (or read) the inode from userspace.

Unfortunately, when we unlink this (invalid/illegal) directory entry,
we will put the bad inode on the ophan list, and then when try to
unlink the directory, we don't actually remove the bad inode from the
orphan list before freeing in-memory inode structure.  This means the
in-memory orphan list is corrupted, leading to a kernel oops.

In addition, avoid truncating a bad inode in ext4_destroy_inode(),
since truncating the boot loader inode is not a smart thing to do.

Reported-by: Sami Liedes <sami.liedes@iki.fi>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[ kamal: backport to 3.13-stable (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/inode.c | 7 +++----
 fs/ext4/namei.c | 2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index fd6501e3..37d3b1a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -221,16 +221,15 @@ void ext4_evict_inode(struct inode *inode)
 		goto no_delete;
 	}
 
-	if (!is_bad_inode(inode))
-		dquot_initialize(inode);
+	if (is_bad_inode(inode))
+		goto no_delete;
+	dquot_initialize(inode);
 
 	if (ext4_should_order_data(inode))
 		ext4_begin_ordered_truncate(inode, 0);
 	truncate_inode_pages(&inode->i_data, 0);
 
 	WARN_ON(atomic_read(&EXT4_I(inode)->i_ioend_count));
-	if (is_bad_inode(inode))
-		goto no_delete;
 
 	/*
 	 * Protect us against freezing - iput() caller didn't have to have any
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 5a0408d..d4fa3ed 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2554,7 +2554,7 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	struct ext4_iloc iloc;
 	int err = 0, rc;
 
-	if (!EXT4_SB(sb)->s_journal)
+	if (!EXT4_SB(sb)->s_journal || is_bad_inode(inode))
 		return 0;
 
 	mutex_lock(&EXT4_SB(sb)->s_orphan_lock);
-- 
1.9.1

