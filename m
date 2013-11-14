Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab3KNSrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 13:47:55 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:63923 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab3KNSrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 13:47:47 -0500
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: geyslan@gmail.com
Cc: Tyler Hicks <tyhicks@canonical.com>,
        ecryptfs@vger.kernel.org (open list:ECRYPT FILE SYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] ecryptfs: Fix explicit null dereference
Date: Thu, 14 Nov 2013 15:42:14 -0300
Message-Id: <1384454534-27807-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the condition 'ecryptfs_file_to_private(file)' takes false branch
lower_file is dereferenced when NULL.

Caught by Coverity: CIDs 1128834 and 1128833.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 fs/ecryptfs/file.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 2229a74..1c0403a 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -316,10 +316,12 @@ ecryptfs_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	struct file *lower_file = NULL;
 	long rc = -ENOTTY;
 
-	if (ecryptfs_file_to_private(file))
-		lower_file = ecryptfs_file_to_lower(file);
+	if (!ecryptfs_file_to_private(file))
+		goto out;
+	lower_file = ecryptfs_file_to_lower(file);
 	if (lower_file->f_op->unlocked_ioctl)
 		rc = lower_file->f_op->unlocked_ioctl(lower_file, cmd, arg);
+out:
 	return rc;
 }
 
@@ -330,10 +332,12 @@ ecryptfs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	struct file *lower_file = NULL;
 	long rc = -ENOIOCTLCMD;
 
-	if (ecryptfs_file_to_private(file))
-		lower_file = ecryptfs_file_to_lower(file);
+	if (!ecryptfs_file_to_private(file))
+		goto out;
+	lower_file = ecryptfs_file_to_lower(file);
 	if (lower_file->f_op && lower_file->f_op->compat_ioctl)
 		rc = lower_file->f_op->compat_ioctl(lower_file, cmd, arg);
+out:
 	return rc;
 }
 #endif
-- 
1.8.4.2

