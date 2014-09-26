Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaIZJp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:45:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344AbaIZJpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:45:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 005/142] ext4: fix BUG_ON in mb_free_blocks()
Date: Fri, 26 Sep 2014 11:43:36 +0200
Message-Id: <bbcd86fa91e60af29c3de9a38aa28c314468cc5f.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c99d1e6e83b06744c75d9f5e491ed495a7086b7b upstream.

If we suffer a block allocation failure (for example due to a memory
allocation failure), it's possible that we will call
ext4_discard_allocated_blocks() before we've actually allocated any
blocks.  In that case, fe_len and fe_start in ac->ac_f_ex will still
be zero, and this will result in mb_free_blocks(inode, e4b, 0, 0)
triggering the BUG_ON on mb_free_blocks():

	BUG_ON(last >= (sb->s_blocksize << 3));

Fix this by bailing out of ext4_discard_allocated_blocks() if fs_len
is zero.

Also fix a missing ext4_mb_unload_buddy() call in
ext4_discard_allocated_blocks().

Google-Bug-Id: 16844242

Fixes: 86f0afd463215fc3e58020493482faa4ac3a4d69
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ext4/mballoc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 795d5afc1479..242226a87be7 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1398,6 +1398,8 @@ static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 	int last = first + count - 1;
 	struct super_block *sb = e4b->bd_sb;
 
+	if (WARN_ON(count == 0))
+		return;
 	BUG_ON(last >= (sb->s_blocksize << 3));
 	assert_spin_locked(ext4_group_lock_ptr(sb, e4b->bd_group));
 	/* Don't bother if the block group is corrupt. */
@@ -3200,6 +3202,8 @@ static void ext4_discard_allocated_blocks(struct ext4_allocation_context *ac)
 	int err;
 
 	if (pa == NULL) {
+		if (ac->ac_f_ex.fe_len == 0)
+			return;
 		err = ext4_mb_load_buddy(ac->ac_sb, ac->ac_f_ex.fe_group, &e4b);
 		if (err) {
 			/*
@@ -3214,6 +3218,7 @@ static void ext4_discard_allocated_blocks(struct ext4_allocation_context *ac)
 		mb_free_blocks(ac->ac_inode, &e4b, ac->ac_f_ex.fe_start,
 			       ac->ac_f_ex.fe_len);
 		ext4_unlock_group(ac->ac_sb, ac->ac_f_ex.fe_group);
+		ext4_mb_unload_buddy(&e4b);
 		return;
 	}
 	if (pa->pa_type == MB_INODE_PA)
-- 
2.1.0

