Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158Ab3EXI5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 04:57:33 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:36597 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758065Ab3EXI5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 04:57:31 -0400
From: Vahram Martirosyan <vmartirosyan@gmail.com>
To: Dave Kleikamp <shaggy@kernel.org>
Cc: Vahram Martirosyan <vahram.martirosyan@linuxtesting.org>,
        jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        spruce-project@linuxtesting.org, Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] jfs: Several bugs in jfs_freeze() and jfs_unfreeze()
Date: Fri, 24 May 2013 13:57:12 +0500
Message-Id: <1369385833-6852-1-git-send-email-vahram.martirosyan@linuxtesting.org>
X-Mailer: git-send-email 1.8.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mentioned functions do not pay attention to the error codes returned
by the functions updateSuper(), lmLogInit() and lmLogShutdown(). It brings to
system crash later when writing to log.

The patch adds corresponding code to check and return the error codes
and to print correct error messages in case of errors.

Besides that the lmLogShutdown() function must not be called when 'nointegrity' mount option is provided.
It leads to kernel OOPS.

Found by Linux File System Verification project (linuxtesting.org).

Signed-off-by: Vahram Martirosyan <vahram.martirosyan@linuxtesting.org>

Reviewed-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/jfs/super.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 2003e83..a3d424d 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -611,11 +611,20 @@ static int jfs_freeze(struct super_block *sb)
 {
 	struct jfs_sb_info *sbi = JFS_SBI(sb);
 	struct jfs_log *log = sbi->log;
+	int rc = 0;
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		txQuiesce(sb);
-		lmLogShutdown(log);
-		updateSuper(sb, FM_CLEAN);
+		rc = lmLogShutdown(log);
+		if (rc != 0) {
+			jfs_err("lmLogShutdown failed with return code %d", rc);
+			return rc;
+		}
+		rc = updateSuper(sb, FM_CLEAN);
+		if (rc != 0) {
+			jfs_err("updateSuper failed with return code %d", rc);
+			return rc;
+		}
 	}
 	return 0;
 }
@@ -627,11 +636,17 @@ static int jfs_unfreeze(struct super_block *sb)
 	int rc = 0;
 
 	if (!(sb->s_flags & MS_RDONLY)) {
-		updateSuper(sb, FM_MOUNT);
-		if ((rc = lmLogInit(log)))
-			jfs_err("jfs_unlock failed with return code %d", rc);
-		else
-			txResume(sb);
+		rc = updateSuper(sb, FM_MOUNT);
+		if (rc != 0) {
+			jfs_err("updateSuper failed with return code %d", rc);
+			return rc;
+		}
+		rc = lmLogInit(log);
+		if (rc != 0) {
+			jfs_err("lmLogInit failed with return code %d", rc);
+			return rc;
+		}
+		txResume(sb);
 	}
 	return 0;
 }
-- 
1.8.2.3

