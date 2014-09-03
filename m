Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936062AbaICX2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:28:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45626 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933609AbaICWIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:08:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 3.14 45/88] ext4: fix BUG_ON in mb_free_blocks()
Date: Wed,  3 Sep 2014 15:05:19 -0700
Message-Id: <20140903220517.318610379@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220515.958924632@linuxfoundation.org>
References: <20140903220515.958924632@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/mballoc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1398,6 +1398,8 @@ static void mb_free_blocks(struct inode
 	int last = first + count - 1;
 	struct super_block *sb = e4b->bd_sb;
 
+	if (WARN_ON(count == 0))
+		return;
 	BUG_ON(last >= (sb->s_blocksize << 3));
 	assert_spin_locked(ext4_group_lock_ptr(sb, e4b->bd_group));
 	/* Don't bother if the block group is corrupt. */
@@ -3200,6 +3202,8 @@ static void ext4_discard_allocated_block
 	int err;
 
 	if (pa == NULL) {
+		if (ac->ac_f_ex.fe_len == 0)
+			return;
 		err = ext4_mb_load_buddy(ac->ac_sb, ac->ac_f_ex.fe_group, &e4b);
 		if (err) {
 			/*
@@ -3214,6 +3218,7 @@ static void ext4_discard_allocated_block
 		mb_free_blocks(ac->ac_inode, &e4b, ac->ac_f_ex.fe_start,
 			       ac->ac_f_ex.fe_len);
 		ext4_unlock_group(ac->ac_sb, ac->ac_f_ex.fe_group);
+		ext4_mb_unload_buddy(&e4b);
 		return;
 	}
 	if (pa->pa_type == MB_INODE_PA)


