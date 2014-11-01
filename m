Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaKAW40 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:56:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60127 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751559AbaKAWj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:27 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Theodore Ts'o" <tytso@mit.edu>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.573495844@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 083/102] ext4: fix BUG_ON in mb_free_blocks()
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/mballoc.c | 5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1312,6 +1312,8 @@ static void mb_free_blocks(struct inode
 	void *buddy2;
 	struct super_block *sb = e4b->bd_sb;
 
+	if (WARN_ON(count == 0))
+		return;
 	BUG_ON(first + count > (sb->s_blocksize << 3));
 	assert_spin_locked(ext4_group_lock_ptr(sb, e4b->bd_group));
 	mb_check_buddy(e4b);
@@ -3132,6 +3134,8 @@ static void ext4_discard_allocated_block
 	int err;
 
 	if (pa == NULL) {
+		if (ac->ac_f_ex.fe_len == 0)
+			return;
 		err = ext4_mb_load_buddy(ac->ac_sb, ac->ac_f_ex.fe_group, &e4b);
 		if (err) {
 			/*
@@ -3146,6 +3150,7 @@ static void ext4_discard_allocated_block
 		mb_free_blocks(ac->ac_inode, &e4b, ac->ac_f_ex.fe_start,
 			       ac->ac_f_ex.fe_len);
 		ext4_unlock_group(ac->ac_sb, ac->ac_f_ex.fe_group);
+		ext4_mb_unload_buddy(&e4b);
 		return;
 	}
 	if (pa->pa_type == MB_INODE_PA)

