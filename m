Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbaLLGVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:21:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51804 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759477AbaLLGRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:17:15 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sami Liedes" <sami.liedes@iki.fi>,
        "Theodore Ts'o" <tytso@mit.edu>, "Jan Kara" <jack@suse.cz>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.154378508@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 046/164] ext4: don't orphan or truncate the boot
 loader inode
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/inode.c | 7 +++----
 fs/ext4/namei.c | 2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -155,15 +155,14 @@ void ext4_evict_inode(struct inode *inod
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
 
 	handle = ext4_journal_start(inode, ext4_blocks_for_truncate(inode)+3);
 	if (IS_ERR(handle)) {
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1979,7 +1979,7 @@ int ext4_orphan_add(handle_t *handle, st
 	struct ext4_iloc iloc;
 	int err = 0, rc;
 
-	if (!ext4_handle_valid(handle))
+	if (!ext4_handle_valid(handle) || is_bad_inode(inode))
 		return 0;
 
 	mutex_lock(&EXT4_SB(sb)->s_orphan_lock);

