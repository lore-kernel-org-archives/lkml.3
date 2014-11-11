Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbaKKLJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:09:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57237 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbaKKLJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 030/170] ext4: check s_chksum_driver when looking for bg csum presence
Date: Tue, 11 Nov 2014 11:06:29 +0000
Message-Id: <1415704129-12709-31-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 813d32f91333e4c33d5a19b67167c4bae42dae75 upstream.

Convert the ext4_has_group_desc_csum predicate to look for a checksum
driver instead of the metadata_csum flag and change the bg checksum
calculation function to look for GDT_CSUM before taking the crc16
path.

Without this patch, if we mount with ^uninit_bg,^metadata_csum and
later metadata_csum gets turned on by accident, the block group
checksum functions will incorrectly assume that checksumming is
enabled (metadata_csum) but that crc16 should be used
(!s_chksum_driver).  This is totally wrong, so fix the predicate
and the checksum formula selection.

(Granted, if the metadata_csum feature bit gets enabled on a live FS
then something underhanded is going on, but we could at least avoid
writing garbage into the on-disk fields.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/ext4.h  | 4 ++--
 fs/ext4/super.c | 4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index cf79b1d9b028..20889da7f8a0 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2332,8 +2332,8 @@ extern int ext4_register_li_request(struct super_block *sb,
 static inline int ext4_has_group_desc_csum(struct super_block *sb)
 {
 	return EXT4_HAS_RO_COMPAT_FEATURE(sb,
-					  EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
-					  EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
+					  EXT4_FEATURE_RO_COMPAT_GDT_CSUM) ||
+	       (EXT4_SB(sb)->s_chksum_driver != NULL);
 }
 
 static inline int ext4_has_metadata_csum(struct super_block *sb)
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 872f5a188a0d..a6c188bb5265 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2025,6 +2025,10 @@ static __le16 ext4_group_desc_csum(struct ext4_sb_info *sbi, __u32 block_group,
 	}
 
 	/* old crc16 code */
+	if (!(sbi->s_es->s_feature_ro_compat &
+	      cpu_to_le32(EXT4_FEATURE_RO_COMPAT_GDT_CSUM)))
+		return 0;
+
 	offset = offsetof(struct ext4_group_desc, bg_checksum);
 
 	crc = crc16(~0, sbi->s_es->s_uuid, sizeof(sbi->s_es->s_uuid));
-- 
2.1.0

