Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490Ab3LSWkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 17:40:36 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:45968 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab3LSWkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 17:40:35 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: [PATCH] ion_test: Add compat_ioctl support
Date: Thu, 19 Dec 2013 14:40:30 -0800
Message-Id: <1387492830-7988-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prior to subitting this, Colin reworked the compat_ioctl support
for the ion_test driver, moving the structure to be the same size
on both 32 and 64 bit architectures.

Two small things were left out. The compat_ioctl ptr assignment,
and the fact that despite having uniform sized types in the
structure, the structure pads out to different sizes on different
arches.

This patch resolves this issue by setting the write flag as
a __u64, and adding the compat_ioctl ptr.

While this does affect the ABI for 32bit users, its only 
the ABI for the ion_test driver, not ion itself.

Cc: Colin Cross <ccross@android.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_test.c  | 1 +
 drivers/staging/android/uapi/ion_test.h | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion_test.c b/drivers/staging/android/ion/ion_test.c
index 3e20349..654acb5 100644
--- a/drivers/staging/android/ion/ion_test.c
+++ b/drivers/staging/android/ion/ion_test.c
@@ -231,6 +231,7 @@ static int ion_test_release(struct inode *inode, struct file *file)
 static const struct file_operations ion_test_fops = {
 	.owner = THIS_MODULE,
 	.unlocked_ioctl = ion_test_ioctl,
+	.compat_ioctl = ion_test_ioctl,
 	.open = ion_test_open,
 	.release = ion_test_release,
 };
diff --git a/drivers/staging/android/uapi/ion_test.h b/drivers/staging/android/uapi/ion_test.h
index 614d1e3..f1727f5 100644
--- a/drivers/staging/android/uapi/ion_test.h
+++ b/drivers/staging/android/uapi/ion_test.h
@@ -31,7 +31,7 @@ struct ion_test_rw_data {
 	__u64 ptr;
 	__u64 offset;
 	__u64 size;
-	int write;
+	__u64 write;
 };
 
 #define ION_IOC_MAGIC		'I'
-- 
1.8.3.2

