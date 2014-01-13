Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbaAMRE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:04:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52956 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbaAMQBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:42 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 034/208] ext4: Do not reserve clusters when fs doesn't support extents
Date: Mon, 13 Jan 2014 15:57:55 +0000
Message-Id: <1389628849-1614-35-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 30fac0f75da24dd5bb43c9e911d2039a984ac815 upstream.

When the filesystem doesn't support extents (like in ext2/3
compatibility modes), there is no need to reserve any clusters. Space
estimates for writing are exact, hole punching doesn't need new
metadata, and there are no unwritten extents to convert.

This fixes a problem when filesystem still having some free space when
accessed with a native ext2/3 driver suddently reports ENOSPC when
accessed with ext4 driver.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/super.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e222177..d5dd232 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3251,11 +3251,19 @@ int ext4_calculate_overhead(struct super_block *sb)
 }
 
 
-static ext4_fsblk_t ext4_calculate_resv_clusters(struct ext4_sb_info *sbi)
+static ext4_fsblk_t ext4_calculate_resv_clusters(struct super_block *sb)
 {
 	ext4_fsblk_t resv_clusters;
 
 	/*
+	 * There's no need to reserve anything when we aren't using extents.
+	 * The space estimates are exact, there are no unwritten extents,
+	 * hole punching doesn't need new metadata... This is needed especially
+	 * to keep ext2/3 backward compatibility.
+	 */
+	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS))
+		return 0;
+	/*
 	 * By default we reserve 2% or 4096 clusters, whichever is smaller.
 	 * This should cover the situations where we can not afford to run
 	 * out of space like for example punch hole, or converting
@@ -3263,7 +3271,8 @@ static ext4_fsblk_t ext4_calculate_resv_clusters(struct ext4_sb_info *sbi)
 	 * allocation would require 1, or 2 blocks, higher numbers are
 	 * very rare.
 	 */
-	resv_clusters = ext4_blocks_count(sbi->s_es) >> sbi->s_cluster_bits;
+	resv_clusters = ext4_blocks_count(EXT4_SB(sb)->s_es) >>
+			EXT4_SB(sb)->s_cluster_bits;
 
 	do_div(resv_clusters, 50);
 	resv_clusters = min_t(ext4_fsblk_t, resv_clusters, 4096);
@@ -4014,10 +4023,10 @@ no_journal:
 			 "available");
 	}
 
-	err = ext4_reserve_clusters(sbi, ext4_calculate_resv_clusters(sbi));
+	err = ext4_reserve_clusters(sbi, ext4_calculate_resv_clusters(sb));
 	if (err) {
 		ext4_msg(sb, KERN_ERR, "failed to reserve %llu clusters for "
-			 "reserved pool", ext4_calculate_resv_clusters(sbi));
+			 "reserved pool", ext4_calculate_resv_clusters(sb));
 		goto failed_mount4a;
 	}
 
-- 
1.8.3.2

