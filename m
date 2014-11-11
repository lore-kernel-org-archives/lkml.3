Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbaKKMJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:09:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57189 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbaKKLJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:20 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 022/170] ext4: don't orphan or truncate the boot loader inode
Date: Tue, 11 Nov 2014 11:06:21 +0000
Message-Id: <1415704129-12709-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/inode.c | 7 +++----
 fs/ext4/namei.c | 2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 14f34b02dde5..eee357d03a87 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -224,16 +224,15 @@ void ext4_evict_inode(struct inode *inode)
 		goto no_delete;
 	}
 
-	if (!is_bad_inode(inode))
-		dquot_initialize(inode);
+	if (is_bad_inode(inode))
+		goto no_delete;
+	dquot_initialize(inode);
 
 	if (ext4_should_order_data(inode))
 		ext4_begin_ordered_truncate(inode, 0);
 	truncate_inode_pages_final(&inode->i_data);
 
 	WARN_ON(atomic_read(&EXT4_I(inode)->i_ioend_count));
-	if (is_bad_inode(inode))
-		goto no_delete;
 
 	/*
 	 * Protect us against freezing - iput() caller didn't have to have any
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 5e127be91bb6..1cafd5d98a9b 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2573,7 +2573,7 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	int err = 0, rc;
 	bool dirty = false;
 
-	if (!sbi->s_journal)
+	if (!sbi->s_journal || is_bad_inode(inode))
 		return 0;
 
 	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
-- 
2.1.0

