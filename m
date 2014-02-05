Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170AbaBEAJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 19:09:25 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:40722 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933118AbaBEAJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 19:09:21 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Laura Abbott <lauraa@codeaurora.org>, Greg KH <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 6/7] staging: ion: Fix ION_IOC_FREE compat ioctl
Date: Tue,  4 Feb 2014 16:08:39 -0800
Message-Id: <1391558920-31590-7-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391558920-31590-1-git-send-email-john.stultz@linaro.org>
References: <1391558920-31590-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laura Abbott <lauraa@codeaurora.org>

The compat ioctl for ION_IOC_FREE currently passes allocation data
instead of the free data. Correct this.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
[jstultz: Folded in a small build fix]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/compat_ion.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/android/ion/compat_ion.c b/drivers/staging/android/ion/compat_ion.c
index af6cd37..ee3a738 100644
--- a/drivers/staging/android/ion/compat_ion.c
+++ b/drivers/staging/android/ion/compat_ion.c
@@ -35,9 +35,14 @@ struct compat_ion_custom_data {
 	compat_ulong_t arg;
 };
 
+struct compat_ion_handle_data {
+	compat_int_t handle;
+};
+
 #define COMPAT_ION_IOC_ALLOC	_IOWR(ION_IOC_MAGIC, 0, \
 				      struct compat_ion_allocation_data)
-#define COMPAT_ION_IOC_FREE	_IOWR(ION_IOC_MAGIC, 1, struct ion_handle_data)
+#define COMPAT_ION_IOC_FREE	_IOWR(ION_IOC_MAGIC, 1, \
+				      struct compat_ion_handle_data)
 #define COMPAT_ION_IOC_CUSTOM	_IOWR(ION_IOC_MAGIC, 6, \
 				      struct compat_ion_custom_data)
 
@@ -64,6 +69,19 @@ static int compat_get_ion_allocation_data(
 	return err;
 }
 
+static int compat_get_ion_handle_data(
+			struct compat_ion_handle_data __user *data32,
+			struct ion_handle_data __user *data)
+{
+	compat_int_t i;
+	int err;
+
+	err = get_user(i, &data32->handle);
+	err |= put_user(i, &data->handle);
+
+	return err;
+}
+
 static int compat_put_ion_allocation_data(
 			struct compat_ion_allocation_data __user *data32,
 			struct ion_allocation_data __user *data)
@@ -132,8 +150,8 @@ long compat_ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	}
 	case COMPAT_ION_IOC_FREE:
 	{
-		struct compat_ion_allocation_data __user *data32;
-		struct ion_allocation_data __user *data;
+		struct compat_ion_handle_data __user *data32;
+		struct ion_handle_data __user *data;
 		int err;
 
 		data32 = compat_ptr(arg);
@@ -141,7 +159,7 @@ long compat_ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (data == NULL)
 			return -EFAULT;
 
-		err = compat_get_ion_allocation_data(data32, data);
+		err = compat_get_ion_handle_data(data32, data);
 		if (err)
 			return err;
 
-- 
1.8.3.2

