Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab3JNRln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 13:41:43 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:53646 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831Ab3JNRll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 13:41:41 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH] fs/fhandle.c: 'handle_to_path' function reorganization
Date: Mon, 14 Oct 2013 14:37:02 -0300
Message-Id: <1381772222-21323-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reorganization:

Removes the exiting labels and adds direct return, once that
there is only one cleanup necessity.

Removes 'retval' and 'file_handle' prior assignments due this new
approach.

Adds 'size' and 'byte' variables to make the code cleaner and more
understandable.

Uses 'memdup_user' instead 'kmalloc' + 'copy_from_user'.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 fs/fhandle.c | 48 ++++++++++++++++++------------------------------
 1 file changed, 18 insertions(+), 30 deletions(-)

diff --git a/fs/fhandle.c b/fs/fhandle.c
index 999ff5c..56b120d 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -166,47 +166,35 @@ out_err:
 static int handle_to_path(int mountdirfd, struct file_handle __user *ufh,
 		   struct path *path)
 {
-	int retval = 0;
+	int retval;
 	struct file_handle f_handle;
-	struct file_handle *handle = NULL;
+	struct file_handle *handle;
+	unsigned int size, bytes;
 
 	/*
 	 * With handle we don't look at the execute bit on the
 	 * the directory. Ideally we would like CAP_DAC_SEARCH.
 	 * But we don't have that
 	 */
-	if (!capable(CAP_DAC_READ_SEARCH)) {
-		retval = -EPERM;
-		goto out_err;
-	}
-	if (copy_from_user(&f_handle, ufh, sizeof(struct file_handle))) {
-		retval = -EFAULT;
-		goto out_err;
-	}
-	if ((f_handle.handle_bytes > MAX_HANDLE_SZ) ||
-	    (f_handle.handle_bytes == 0)) {
-		retval = -EINVAL;
-		goto out_err;
-	}
-	handle = kmalloc(sizeof(struct file_handle) + f_handle.handle_bytes,
-			 GFP_KERNEL);
-	if (!handle) {
-		retval = -ENOMEM;
-		goto out_err;
-	}
-	/* copy the full handle */
-	if (copy_from_user(handle, ufh,
-			   sizeof(struct file_handle) +
-			   f_handle.handle_bytes)) {
-		retval = -EFAULT;
-		goto out_handle;
-	}
+	if (!capable(CAP_DAC_READ_SEARCH))
+		return -EPERM;
+
+	size = sizeof(struct file_handle);
+	if (copy_from_user(&f_handle, ufh, size))
+		return -EFAULT;
+
+	bytes = f_handle.handle_bytes;
+	if ((bytes > MAX_HANDLE_SZ) || (bytes == 0))
+		return -EINVAL;
+
+	size += bytes;
+	handle = memdup_user(ufh, size);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
 
 	retval = do_handle_to_path(mountdirfd, handle, path);
 
-out_handle:
 	kfree(handle);
-out_err:
 	return retval;
 }
 
-- 
1.8.4

