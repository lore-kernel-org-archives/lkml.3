Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbaCDVmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:42:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40735 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456AbaCDUCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:02:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Theodore Tso" <tytso@mit.edu>
Subject: [PATCH 3.13 011/172] ext4: dont try to modify s_flags if the the file system is read-only
Date: Tue,  4 Mar 2014 12:01:35 -0800
Message-Id: <20140304200300.072688558@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3695,16 +3695,22 @@ static int ext4_fill_super(struct super_
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


