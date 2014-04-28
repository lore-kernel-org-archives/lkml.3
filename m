Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbaD1BbM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:31:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42976 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752716AbaD1B3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:22 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Theodore Ts'o" <tytso@mit.edu>,
        "Eric Whitney" <enwlinux@gmail.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.754809858@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 47/94] ext4: fix partial cluster handling for bigalloc
 file systems
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/extents.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2372,6 +2372,27 @@ ext4_ext_rm_leaf(handle_t *handle, struc
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

