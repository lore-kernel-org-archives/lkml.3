Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab3BAQIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 11:08:48 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38498 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756409Ab3BAQIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 11:08:32 -0500
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kernel-team@android.com, arve@android.com, john.stultz@linaro.org,
        Dave.Butcher@arm.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH 2/2] staging: android: ashmem: Add support for 32bit ashmem calls in a 64bit kernel
Date: Fri,  1 Feb 2013 16:08:01 +0000
Message-Id: <1359734881-15093-3-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359734881-15093-1-git-send-email-serban.constantinescu@arm.com>
References: <1359734881-15093-1-git-send-email-serban.constantinescu@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Android's shared memory subsystem, Ashmem, does not support calls from a
32bit userspace in a 64 bit kernel. This patch adds support for syscalls
coming from a 32bit userspace in a 64bit kernel.

The patch has been successfully tested on ARMv8 AEM(64bit
platform model) and Versatile Express A9(32bit platform).

Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
---
 drivers/staging/android/ashmem.c |   65 ++++++++++++++++++++++++++++++--------
 drivers/staging/android/ashmem.h |   15 +++++++++
 2 files changed, 66 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index aa52646..75b08a9 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -577,33 +577,29 @@ static int ashmem_get_pin_status(struct ashmem_area *asma, size_t pgstart,
 }
 
 static int ashmem_pin_unpin(struct ashmem_area *asma, unsigned long cmd,
-			    void __user *p)
+			    struct ashmem_pin *pin)
 {
-	struct ashmem_pin pin;
 	size_t pgstart, pgend;
 	int ret = -EINVAL;
 
 	if (unlikely(!asma->file))
 		return -EINVAL;
 
-	if (unlikely(copy_from_user(&pin, p, sizeof(pin))))
-		return -EFAULT;
-
 	/* per custom, you can pass zero for len to mean "everything onward" */
-	if (!pin.len)
-		pin.len = PAGE_ALIGN(asma->size) - pin.offset;
+	if (!pin->len)
+		pin->len = PAGE_ALIGN(asma->size) - pin->offset;
 
-	if (unlikely((pin.offset | pin.len) & ~PAGE_MASK))
+	if (unlikely((pin->offset | pin->len) & ~PAGE_MASK))
 		return -EINVAL;
 
-	if (unlikely(((size_t) -1) - pin.offset < pin.len))
+	if (unlikely(((size_t) -1) - pin->offset < pin->len))
 		return -EINVAL;
 
-	if (unlikely(PAGE_ALIGN(asma->size) < pin.offset + pin.len))
+	if (unlikely(PAGE_ALIGN(asma->size) < pin->offset + pin->len))
 		return -EINVAL;
 
-	pgstart = pin.offset / PAGE_SIZE;
-	pgend = pgstart + (pin.len / PAGE_SIZE) - 1;
+	pgstart = pin->offset / PAGE_SIZE;
+	pgend = pgstart + (pin->len / PAGE_SIZE) - 1;
 
 	mutex_lock(&ashmem_mutex);
 
@@ -627,6 +623,7 @@ static int ashmem_pin_unpin(struct ashmem_area *asma, unsigned long cmd,
 static long ashmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct ashmem_area *asma = file->private_data;
+	struct ashmem_pin pin;
 	long ret = -ENOTTY;
 
 	switch (cmd) {
@@ -655,7 +652,9 @@ static long ashmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case ASHMEM_PIN:
 	case ASHMEM_UNPIN:
 	case ASHMEM_GET_PIN_STATUS:
-		ret = ashmem_pin_unpin(asma, cmd, (void __user *) arg);
+		if (unlikely(copy_from_user(&pin, (void __user *)arg, sizeof(pin))))
+			return -EFAULT;
+		ret = ashmem_pin_unpin(asma, cmd, &pin);
 		break;
 	case ASHMEM_PURGE_ALL_CACHES:
 		ret = -EPERM;
@@ -674,6 +673,42 @@ static long ashmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return ret;
 }
 
+/* support of 32bit userspace on 64bit platforms */
+#ifdef CONFIG_COMPAT
+static long compat_ashmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct compat_ashmem_pin c_pin;
+	struct ashmem_pin pin;
+
+	switch (cmd) {
+	case COMPAT_ASHMEM_SET_SIZE:
+		cmd = ASHMEM_SET_SIZE;
+		break;
+	case COMPAT_ASHMEM_SET_PROT_MASK:
+		cmd = ASHMEM_SET_PROT_MASK;
+		break;
+	case COMPAT_ASHMEM_PIN:
+	case COMPAT_ASHMEM_UNPIN:
+	case ASHMEM_GET_PIN_STATUS:
+		if (unlikely(copy_from_user(&c_pin, (void __user *)arg, sizeof(c_pin))))
+			return -EFAULT;
+		pin.offset = (size_t)c_pin.offset;
+		pin.len = (size_t)c_pin.len;
+		switch (cmd) {
+		case COMPAT_ASHMEM_PIN:
+			cmd = ASHMEM_PIN;
+			break;
+		case COMPAT_ASHMEM_UNPIN:
+			cmd = ASHMEM_UNPIN;
+			break;
+		}
+		return ashmem_pin_unpin(file->private_data, cmd, &pin);
+	}
+
+	return ashmem_ioctl(file, cmd, arg);
+}
+#endif /* CONFIG_COMPAT */
+
 static const struct file_operations ashmem_fops = {
 	.owner = THIS_MODULE,
 	.open = ashmem_open,
@@ -682,7 +717,9 @@ static const struct file_operations ashmem_fops = {
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
index c9b2eba..ff7328f 100644
--- a/drivers/staging/android/ashmem.h
+++ b/drivers/staging/android/ashmem.h
@@ -32,6 +32,13 @@ struct ashmem_pin {
 	size_t len;	/* length forward from offset, in bytes, page-aligned */
 };
 
+#ifdef CONFIG_COMPAT
+struct compat_ashmem_pin {
+	compat_size_t offset;	/* offset into region, in bytes, page-aligned */
+	compat_size_t len;	/* length forward from offset, in bytes, page-aligned */
+};
+#endif
+
 #define __ASHMEMIOC		0x77
 
 #define ASHMEM_SET_NAME		_IOW(__ASHMEMIOC, 1, char[ASHMEM_NAME_LEN])
@@ -45,4 +52,12 @@ struct ashmem_pin {
 #define ASHMEM_GET_PIN_STATUS	_IO(__ASHMEMIOC, 9)
 #define ASHMEM_PURGE_ALL_CACHES	_IO(__ASHMEMIOC, 10)
 
+/* support of 32bit userspace on 64bit platforms */
+#ifdef CONFIG_COMPAT
+#define COMPAT_ASHMEM_SET_SIZE		_IOW(__ASHMEMIOC, 3, compat_size_t)
+#define COMPAT_ASHMEM_SET_PROT_MASK	_IOW(__ASHMEMIOC, 5, unsigned int)
+#define COMPAT_ASHMEM_PIN		_IOW(__ASHMEMIOC, 7, struct compat_ashmem_pin)
+#define COMPAT_ASHMEM_UNPIN		_IOW(__ASHMEMIOC, 8, struct compat_ashmem_pin)
+#endif
+
 #endif	/* _LINUX_ASHMEM_H */
-- 
1.7.9.5

