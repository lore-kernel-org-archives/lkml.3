Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab3EXVBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 17:01:43 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:41417 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab3EXVBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 17:01:42 -0400
Message-ID: <519FD520.1010705@oracle.com>
Date: Fri, 24 May 2013 16:01:20 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Vahram Martirosyan <vmartirosyan@gmail.com>
CC: jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Vahram Martirosyan <vahram.martirosyan@linuxtesting.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, spruce-project@linuxtesting.org
Subject: [PATCH] jfs: Several bugs in jfs_freeze() and jfs_unfreeze()
References: <1369385833-6852-1-git-send-email-vahram.martirosyan@linuxtesting.org> <519F9D63.8000305@oracle.com>
In-Reply-To: <519F9D63.8000305@oracle.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vahram,
This is your first patch modified to be a little more robust. If there is
no objection, I'll push it to linux-next along with Gu's nointegrity
patch.

From: Vahram Martirosyan <vmartirosyan@gmail.com>
Date: Fri, 24 May 2013 13:57:12 +0500

The mentioned functions do not pay attention to the error codes returned
by the functions updateSuper(), lmLogInit() and lmLogShutdown(). It brings
to system crash later when writing to log.

The patch adds corresponding code to check and return the error codes
and to print correct error messages in case of errors.

Found by Linux File System Verification project (linuxtesting.org).

Signed-off-by: Vahram Martirosyan <vahram.martirosyan@linuxtesting.org>
Reviewed-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
---
 fs/jfs/super.c | 38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 2003e83..788e0a9 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -611,11 +611,28 @@ static int jfs_freeze(struct super_block *sb)
 {
 	struct jfs_sb_info *sbi = JFS_SBI(sb);
 	struct jfs_log *log = sbi->log;
+	int rc = 0;
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		txQuiesce(sb);
-		lmLogShutdown(log);
-		updateSuper(sb, FM_CLEAN);
+		rc = lmLogShutdown(log);
+		if (rc) {
+			jfs_error(sb, "jfs_freeze: lmLogShutdown failed");
+
+			/* let operations fail rather than hang */
+			txResume(sb);
+
+			return rc;
+		}
+		rc = updateSuper(sb, FM_CLEAN);
+		if (rc) {
+			jfs_err("jfs_freeze: updateSuper failed\n");
+			/*
+			 * Don't fail here. Everything succeeded except
+			 * marking the superblock clean, so there's really
+			 * no harm in leaving it frozen for now.
+			 */
+		}
 	}
 	return 0;
 }
@@ -627,13 +644,18 @@ static int jfs_unfreeze(struct super_block *sb)
 	int rc = 0;
 
 	if (!(sb->s_flags & MS_RDONLY)) {
-		updateSuper(sb, FM_MOUNT);
-		if ((rc = lmLogInit(log)))
-			jfs_err("jfs_unlock failed with return code %d", rc);
-		else
-			txResume(sb);
+		rc = updateSuper(sb, FM_MOUNT);
+		if (rc) {
+			jfs_error(sb, "jfs_unfreeze: updateSuper failed");
+			goto out;
+		}
+		rc = lmLogInit(log);
+		if (rc)
+			jfs_error(sb, "jfs_unfreeze: lmLogInit failed");
+out:
+		txResume(sb);
 	}
-	return 0;
+	return rc;
 }
 
 static struct dentry *jfs_do_mount(struct file_system_type *fs_type,
-- 
1.8.2.3
