Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761946AbbA1FEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:04:45 -0500
Received: from mail.kernel.org ([198.145.29.136]:38897 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761580AbbA1ETb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:19:31 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 063/177] ext4: don't orphan or truncate the boot loader inode
Date: Wed, 28 Jan 2015 12:08:12 +0800
Message-Id: <1422418236-12852-125-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/ext4/inode.c | 8 +++-----
 fs/ext4/namei.c | 2 +-
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5b6dcba..b9c3995 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -157,16 +157,14 @@ void ext4_evict_inode(struct inode *inode)
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
 
-	if (is_bad_inode(inode))
-		goto no_delete;
-
 	handle = ext4_journal_start(inode, ext4_blocks_for_truncate(inode)+3);
 	if (IS_ERR(handle)) {
 		ext4_std_error(inode->i_sb, PTR_ERR(handle));
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 665e55c..11566d7 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1992,7 +1992,7 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	struct ext4_iloc iloc;
 	int err = 0, rc;
 
-	if (!ext4_handle_valid(handle))
+	if (!ext4_handle_valid(handle) || is_bad_inode(inode))
 		return 0;
 
 	mutex_lock(&EXT4_SB(sb)->s_orphan_lock);
-- 
1.9.1

