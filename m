Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815AbaEEMut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:50:49 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41020 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932304AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Whitney <enwlinux@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 40/50] ext4: fix partial cluster handling for bigalloc file systems
Date: Mon,  5 May 2014 14:43:22 +0200
Message-Id: <23606f1b0b2a09aa32146b3c1f0687383699c164.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Whitney <enwlinux@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c06344939422bbd032ac967223a7863de57496b5 upstream.

Commit 9cb00419fa, which enables hole punching for bigalloc file
systems, exposed a bug introduced by commit 6ae06ff51e in an earlier
release.  When run on a bigalloc file system, xfstests generic/013, 068,
075, 083, 091, 100, 112, 127, 263, 269, and 270 fail with e2fsck errors
or cause kernel error messages indicating that previously freed blocks
are being freed again.

The latter commit optimizes the selection of the starting extent in
ext4_ext_rm_leaf() when hole punching by beginning with the extent
supplied in the path argument rather than with the last extent in the
leaf node (as is still done when truncating).  However, the code in
rm_leaf that initially sets partial_cluster to track cluster sharing on
extent boundaries is only guaranteed to run if rm_leaf starts with the
last node in the leaf.  Consequently, partial_cluster is not correctly
initialized when hole punching, and a cluster on the boundary of a
punched region that should be retained may instead be deallocated.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ext4/extents.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index bd048b6addad..d9c53f12a4d9 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2616,6 +2616,27 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 	ex_ee_block = le32_to_cpu(ex->ee_block);
 	ex_ee_len = ext4_ext_get_actual_len(ex);
 
+	/*
+	 * If we're starting with an extent other than the last one in the
+	 * node, we need to see if it shares a cluster with the extent to
+	 * the right (towards the end of the file). If its leftmost cluster
+	 * is this extent's rightmost cluster and it is not cluster aligned,
+	 * we'll mark it as a partial that is not to be deallocated.
+	 */
+
+	if (ex != EXT_LAST_EXTENT(eh)) {
+		ext4_fsblk_t current_pblk, right_pblk;
+		long long current_cluster, right_cluster;
+
+		current_pblk = ext4_ext_pblock(ex) + ex_ee_len - 1;
+		current_cluster = (long long)EXT4_B2C(sbi, current_pblk);
+		right_pblk = ext4_ext_pblock(ex + 1);
+		right_cluster = (long long)EXT4_B2C(sbi, right_pblk);
+		if (current_cluster == right_cluster &&
+			EXT4_PBLK_COFF(sbi, right_pblk))
+			*partial_cluster = -right_cluster;
+	}
+
 	trace_ext4_ext_rm_leaf(inode, start, ex, *partial_cluster);
 
 	while (ex >= EXT_FIRST_EXTENT(eh) &&
-- 
1.9.2

