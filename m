Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab3CEPbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:31:19 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35504 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755540Ab3CEPbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:31:18 -0500
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, arve@android.com, john.stultz@linaro.org,
        Dave.Butcher@arm.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH v2] staging: android: ashmem: Add support for 32bit ashmem calls in a 64bit kernel
Date: Tue,  5 Mar 2013 15:27:38 +0000
Message-Id: <1362497258-29661-1-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Android's shared memory subsystem, Ashmem, does not support calls from a
32bit userspace in a 64 bit kernel. This patch adds support for syscalls
coming from a 32bit userspace in a 64bit kernel.

The patch has been successfully tested on ARMv8 AEM(64bit
platform model) and Versatile Express A9(32bit platform).

v2: Fix missing compat.h include.

Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
Acked-by: Arve Hjønnevåg <arve@android.com>
Acked-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ashmem.c |   21 ++++++++++++++++++++-
 drivers/staging/android/ashmem.h |    7 +++++++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index 72064fc..268f0b4 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -674,6 +674,23 @@ static long ashmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return ret;
 }
 
+/* support of 32bit userspace on 64bit platforms */
+#ifdef CONFIG_COMPAT
+static long compat_ashmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+
+	switch (cmd) {
+	case COMPAT_ASHMEM_SET_SIZE:
+		cmd = ASHMEM_SET_SIZE;
+		break;
+	case COMPAT_ASHMEM_SET_PROT_MASK:
+		cmd = ASHMEM_SET_PROT_MASK;
+		break;
+	}
+	return ashmem_ioctl(file, cmd, arg);
+}
+#endif
+
 static const struct file_operations ashmem_fops = {
 	.owner = THIS_MODULE,
 	.open = ashmem_open,
@@ -682,7 +699,9 @@ static const struct file_operations ashmem_fops = {
 	.llseek = ashmem_llseek,
 	.mmap = ashmem_mmap,
 	.unlocked_ioctl = ashmem_ioctl,
-	.compat_ioctl = ashmem_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = compat_ashmem_ioctl,
+#endif
 };
 
 static struct miscdevice ashmem_misc = {
diff --git a/drivers/staging/android/ashmem.h b/drivers/staging/android/ashmem.h
index 1976b10..8dc0f0d 100644
--- a/drivers/staging/android/ashmem.h
+++ b/drivers/staging/android/ashmem.h
@@ -14,6 +14,7 @@
 
 #include <linux/limits.h>
 #include <linux/ioctl.h>
+#include <linux/compat.h>
 
 #define ASHMEM_NAME_LEN		256
 
@@ -45,4 +46,10 @@ struct ashmem_pin {
 #define ASHMEM_GET_PIN_STATUS	_IO(__ASHMEMIOC, 9)
 #define ASHMEM_PURGE_ALL_CACHES	_IO(__ASHMEMIOC, 10)
 
+/* support of 32bit userspace on 64bit platforms */
+#ifdef CONFIG_COMPAT
+#define COMPAT_ASHMEM_SET_SIZE		_IOW(__ASHMEMIOC, 3, compat_size_t)
+#define COMPAT_ASHMEM_SET_PROT_MASK	_IOW(__ASHMEMIOC, 5, unsigned int)
+#endif
+
 #endif	/* _LINUX_ASHMEM_H */
-- 
1.7.9.5

