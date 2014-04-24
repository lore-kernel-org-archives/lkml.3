Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbaDXIxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:53:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46477 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbaDXIxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:53:08 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Whitney <enwlinux@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 051/182] ext4: fix partial cluster handling for bigalloc file systems
Date: Thu, 24 Apr 2014 09:49:36 +0100
Message-Id: <1398329507-5911-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Whitney <enwlinux@gmail.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/extents.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 79ace91..3960bba 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2527,6 +2527,27 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
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
1.9.1

