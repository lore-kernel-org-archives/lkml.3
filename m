Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636AbaCEO6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:58:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41547 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758142AbaCEOhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:37:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 06/62] ext4: don't try to modify s_flags if the the file system is read-only
Date: Wed,  5 Mar 2014 14:36:10 +0000
Message-Id: <1394030226-26652-7-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 23301410972330c0ae9a8afc379ba2005e249cc6 upstream.

If an ext4 file system is created by some tool other than mke2fs
(perhaps by someone who has a pathalogical fear of the GPL) that
doesn't set one or the other of the EXT2_FLAGS_{UN}SIGNED_HASH flags,
and that file system is then mounted read-only, don't try to modify
the s_flags field.  Otherwise, if dm_verity is in use, the superblock
will change, causing an dm_verity failure.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/super.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b2ae1e8..44884b7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3548,16 +3548,22 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	for (i = 0; i < 4; i++)
 		sbi->s_hash_seed[i] = le32_to_cpu(es->s_hash_seed[i]);
 	sbi->s_def_hash_version = es->s_def_hash_version;
-	i = le32_to_cpu(es->s_flags);
-	if (i & EXT2_FLAGS_UNSIGNED_HASH)
-		sbi->s_hash_unsigned = 3;
-	else if ((i & EXT2_FLAGS_SIGNED_HASH) == 0) {
+	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_DIR_INDEX)) {
+		i = le32_to_cpu(es->s_flags);
+		if (i & EXT2_FLAGS_UNSIGNED_HASH)
+			sbi->s_hash_unsigned = 3;
+		else if ((i & EXT2_FLAGS_SIGNED_HASH) == 0) {
 #ifdef __CHAR_UNSIGNED__
-		es->s_flags |= cpu_to_le32(EXT2_FLAGS_UNSIGNED_HASH);
-		sbi->s_hash_unsigned = 3;
+			if (!(sb->s_flags & MS_RDONLY))
+				es->s_flags |=
+					cpu_to_le32(EXT2_FLAGS_UNSIGNED_HASH);
+			sbi->s_hash_unsigned = 3;
 #else
-		es->s_flags |= cpu_to_le32(EXT2_FLAGS_SIGNED_HASH);
+			if (!(sb->s_flags & MS_RDONLY))
+				es->s_flags |=
+					cpu_to_le32(EXT2_FLAGS_SIGNED_HASH);
 #endif
+		}
 	}
 
 	/* Handle clustersize */
-- 
1.9.0

