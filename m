Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934790AbaKLDvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:51:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbaKLB1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:27:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sami Liedes <sami.liedes@iki.fi>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 3.17 156/319] ext4: dont orphan or truncate the boot loader inode
Date: Wed, 12 Nov 2014 10:14:54 +0900
Message-Id: <20141112011018.490117837@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |    7 +++----
 fs/ext4/namei.c |    2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -224,16 +224,15 @@ void ext4_evict_inode(struct inode *inod
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
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2573,7 +2573,7 @@ int ext4_orphan_add(handle_t *handle, st
 	int err = 0, rc;
 	bool dirty = false;
 
-	if (!sbi->s_journal)
+	if (!sbi->s_journal || is_bad_inode(inode))
 		return 0;
 
 	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&


