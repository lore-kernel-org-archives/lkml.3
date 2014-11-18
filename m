Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248AbaKROsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:48:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981AbaKROJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:58 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 125/206] ext4: check s_chksum_driver when looking for bg csum presence
Date: Tue, 18 Nov 2014 15:08:00 +0100
Message-Id: <9154dd792c9820b25d51e67e6e8e7ae277b64250.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ext4/ext4.h  | 4 ++--
 fs/ext4/super.c | 4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bd5f351ef10b..29c4e30bf4ca 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2324,8 +2324,8 @@ extern int ext4_register_li_request(struct super_block *sb,
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
index 4ddd6cf12f63..64a94388bc8d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2000,6 +2000,10 @@ static __le16 ext4_group_desc_csum(struct ext4_sb_info *sbi, __u32 block_group,
 	}
 
 	/* old crc16 code */
+	if (!(sbi->s_es->s_feature_ro_compat &
+	      cpu_to_le32(EXT4_FEATURE_RO_COMPAT_GDT_CSUM)))
+		return 0;
+
 	offset = offsetof(struct ext4_group_desc, bg_checksum);
 
 	crc = crc16(~0, sbi->s_es->s_uuid, sizeof(sbi->s_es->s_uuid));
-- 
2.1.3

