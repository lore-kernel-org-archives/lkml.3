Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbaIKMgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:36:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51699 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755467AbaIKMeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:09 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Theodore Ts'o" <tytso@mit.edu>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.517098496@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 034/131] ext4: fix ext4_discard_allocated_blocks() if
 we can't allocate the pa struct
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/mballoc.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3128,8 +3128,27 @@ static void ext4_mb_collect_stats(struct
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
 

