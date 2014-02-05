Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365AbaBEAJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 19:09:40 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:61959 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933177AbaBEAJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 19:09:26 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Todd Poynor <toddpoynor@google.com>, Greg KH <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 4/7] staging: ashmem: Avoid deadlock between read and mmap calls
Date: Tue,  4 Feb 2014 16:08:37 -0800
Message-Id: <1391558920-31590-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391558920-31590-1-git-send-email-john.stultz@linaro.org>
References: <1391558920-31590-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Todd Poynor <toddpoynor@google.com>

Avoid holding ashmem_mutex across code that can page fault.  Page faults
grab the mmap_sem for the process, which are also held by mmap calls
prior to calling ashmem_mmap, which locks ashmem_mutex.  The reversed
order of locking between the two can deadlock.

The calls that can page fault are read() and the ASHMEM_SET_NAME and
ASHMEM_GET_NAME ioctls.  Move the code that accesses userspace pages
outside the ashmem_mutex.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Todd Poynor <toddpoynor@google.com>
[jstultz: minor commit message tweaks]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ashmem.c | 45 +++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index 23948f1..713a972 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -295,21 +295,29 @@ static ssize_t ashmem_read(struct file *file, char __user *buf,
 
 	/* If size is not set, or set to 0, always return EOF. */
 	if (asma->size == 0)
-		goto out;
+		goto out_unlock;
 
 	if (!asma->file) {
 		ret = -EBADF;
-		goto out;
+		goto out_unlock;
 	}
 
-	ret = asma->file->f_op->read(asma->file, buf, len, pos);
-	if (ret < 0)
-		goto out;
+	mutex_unlock(&ashmem_mutex);
 
-	/** Update backing file pos, since f_ops->read() doesn't */
-	asma->file->f_pos = *pos;
+	/*
+	 * asma and asma->file are used outside the lock here.  We assume
+	 * once asma->file is set it will never be changed, and will not
+	 * be destroyed until all references to the file are dropped and
+	 * ashmem_release is called.
+	 */
+	ret = asma->file->f_op->read(asma->file, buf, len, pos);
+	if (ret >= 0) {
+		/** Update backing file pos, since f_ops->read() doesn't */
+		asma->file->f_pos = *pos;
+	}
+	return ret;
 
-out:
+out_unlock:
 	mutex_unlock(&ashmem_mutex);
 	return ret;
 }
@@ -498,6 +506,7 @@ out:
 
 static int set_name(struct ashmem_area *asma, void __user *name)
 {
+	int len;
 	int ret = 0;
 	char local_name[ASHMEM_NAME_LEN];
 
@@ -510,21 +519,19 @@ static int set_name(struct ashmem_area *asma, void __user *name)
 	 * variable that does not need protection and later copy the local
 	 * variable to the structure member with lock held.
 	 */
-	if (copy_from_user(local_name, name, ASHMEM_NAME_LEN))
-		return -EFAULT;
-
+	len = strncpy_from_user(local_name, name, ASHMEM_NAME_LEN);
+	if (len < 0)
+		return len;
+	if (len == ASHMEM_NAME_LEN)
+		local_name[ASHMEM_NAME_LEN - 1] = '\0';
 	mutex_lock(&ashmem_mutex);
 	/* cannot change an existing mapping's name */
-	if (unlikely(asma->file)) {
+	if (unlikely(asma->file))
 		ret = -EINVAL;
-		goto out;
-	}
-	memcpy(asma->name + ASHMEM_NAME_PREFIX_LEN,
-		local_name, ASHMEM_NAME_LEN);
-	asma->name[ASHMEM_FULL_NAME_LEN-1] = '\0';
-out:
-	mutex_unlock(&ashmem_mutex);
+	else
+		strcpy(asma->name + ASHMEM_NAME_PREFIX_LEN, local_name);
 
+	mutex_unlock(&ashmem_mutex);
 	return ret;
 }
 
-- 
1.8.3.2

