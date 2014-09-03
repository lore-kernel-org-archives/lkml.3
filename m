Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbaICKEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:04:46 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57436 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932318AbaICJ55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:57:57 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 40/56] ext4: fix ext4_discard_allocated_blocks() if we can't allocate the pa struct
Date: Wed,  3 Sep 2014 11:26:59 +0200
Message-Id: <9f48c2853290b15ecdcd9ba83b41eaab63f22682.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 86f0afd463215fc3e58020493482faa4ac3a4d69 upstream.

If there is a failure while allocating the preallocation structure, a
number of blocks can end up getting marked in the in-memory buddy
bitmap, and then not getting released.  This can result in the
following corruption getting reported by the kernel:

EXT4-fs error (device sda3): ext4_mb_generate_buddy:758: group 1126,
12793 clusters in bitmap, 12729 in gd

In that case, we need to release the blocks using mb_free_blocks().

Tested: fs smoke test; also demonstrated that with injected errors,
	the file system is no longer getting corrupted

Google-Bug-Id: 16657874

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ext4/mballoc.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 502f0fd71470..795d5afc1479 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3196,8 +3196,27 @@ static void ext4_mb_collect_stats(struct ext4_allocation_context *ac)
 static void ext4_discard_allocated_blocks(struct ext4_allocation_context *ac)
 {
 	struct ext4_prealloc_space *pa = ac->ac_pa;
+	struct ext4_buddy e4b;
+	int err;
 
-	if (pa && pa->pa_type == MB_INODE_PA)
+	if (pa == NULL) {
+		err = ext4_mb_load_buddy(ac->ac_sb, ac->ac_f_ex.fe_group, &e4b);
+		if (err) {
+			/*
+			 * This should never happen since we pin the
+			 * pages in the ext4_allocation_context so
+			 * ext4_mb_load_buddy() should never fail.
+			 */
+			WARN(1, "mb_load_buddy failed (%d)", err);
+			return;
+		}
+		ext4_lock_group(ac->ac_sb, ac->ac_f_ex.fe_group);
+		mb_free_blocks(ac->ac_inode, &e4b, ac->ac_f_ex.fe_start,
+			       ac->ac_f_ex.fe_len);
+		ext4_unlock_group(ac->ac_sb, ac->ac_f_ex.fe_group);
+		return;
+	}
+	if (pa->pa_type == MB_INODE_PA)
 		pa->pa_free += ac->ac_b_ex.fe_len;
 }
 
-- 
2.1.0

