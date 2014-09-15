Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541AbaIOWUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:20:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51328 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758460AbaIOWU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:20:28 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 120/187] ext4: fix ext4_discard_allocated_blocks() if we can't allocate the pa struct
Date: Mon, 15 Sep 2014 15:08:50 -0700
Message-Id: <1410818997-9432-121-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/mballoc.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 502f0fd..795d5af 100644
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
1.9.1

