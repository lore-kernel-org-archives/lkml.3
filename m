Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab3JNSmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 14:42:06 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:33425 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab3JNSmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 14:42:04 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: matthew.garrett@nebula.com, jk@ozlabs.org, matt.fleming@intel.com
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-br@googlegroups.com, "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH] efivarfs: 'efivarfs_file_write' function reorganization
Date: Mon, 14 Oct 2013 15:37:17 -0300
Message-Id: <1381775837-26023-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reorganization:

Adds 'attrsize' variable to make the code cleaner and more
understandable, replacing all 'sizeof(attributes)'.

Removes 'bytes' prior assignment due this new approach.

Uses 'memdup_user' instead 'kmalloc' + 'copy_from_user'.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 fs/efivarfs/file.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/efivarfs/file.c b/fs/efivarfs/file.c
index 8dd524f..e190aa0 100644
--- a/fs/efivarfs/file.c
+++ b/fs/efivarfs/file.c
@@ -18,29 +18,24 @@ static ssize_t efivarfs_file_write(struct file *file,
 {
 	struct efivar_entry *var = file->private_data;
 	void *data;
-	u32 attributes;
+	u32 attributes, attrsize = sizeof(attributes);
 	struct inode *inode = file->f_mapping->host;
-	unsigned long datasize = count - sizeof(attributes);
-	ssize_t bytes = 0;
+	unsigned long datasize = count - attrsize;
+	ssize_t bytes;
 	bool set = false;
 
-	if (count < sizeof(attributes))
+	if (count < attrsize)
 		return -EINVAL;
 
-	if (copy_from_user(&attributes, userbuf, sizeof(attributes)))
+	if (copy_from_user(&attributes, userbuf, attrsize))
 		return -EFAULT;
 
 	if (attributes & ~(EFI_VARIABLE_MASK))
 		return -EINVAL;
 
-	data = kmalloc(datasize, GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	if (copy_from_user(data, userbuf + sizeof(attributes), datasize)) {
-		bytes = -EFAULT;
-		goto out;
-	}
+	data = memdup_user(userbuf + attrsize, datasize);
+	if (IS_ERR(data))
+		return PTR_ERR(data);
 
 	bytes = efivar_entry_set_get_size(var, attributes, &datasize,
 					  data, &set);
@@ -56,7 +51,7 @@ static ssize_t efivarfs_file_write(struct file *file,
 		dput(file->f_dentry);
 	} else {
 		mutex_lock(&inode->i_mutex);
-		i_size_write(inode, datasize + sizeof(attributes));
+		i_size_write(inode, datasize + attrsize);
 		mutex_unlock(&inode->i_mutex);
 	}
 
-- 
1.8.4

