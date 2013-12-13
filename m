Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab3LMWa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:30:56 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:62782 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab3LMW2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:28:17 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 084/115] ion: Fix compat support to use proper compat ioctl numbers
Date: Fri, 13 Dec 2013 14:24:58 -0800
Message-Id: <1386973529-4884-85-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compat support added to ion didn't provide compat ioctl numbers
(who's value depends on the compat structure size). So 32bit
applications would get an error when trying to make ioctl calls.

This patch adds the needed COMPAT_ macros and uses them in the
compat_ion_ioctl, translating them to their non-compat cmd when
calling the normal ioctl call.

Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/compat_ion.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/android/ion/compat_ion.c b/drivers/staging/android/ion/compat_ion.c
index d4a33c7..079a5bb 100644
--- a/drivers/staging/android/ion/compat_ion.c
+++ b/drivers/staging/android/ion/compat_ion.c
@@ -35,6 +35,12 @@ struct compat_ion_custom_data {
 	compat_ulong_t arg;
 };
 
+#define COMPAT_ION_IOC_ALLOC	_IOWR(ION_IOC_MAGIC, 0, \
+				      struct compat_ion_allocation_data)
+#define COMPAT_ION_IOC_FREE	_IOWR(ION_IOC_MAGIC, 1, struct ion_handle_data)
+#define COMPAT_ION_IOC_CUSTOM	_IOWR(ION_IOC_MAGIC, 6, \
+				      struct compat_ion_custom_data)
+
 static int compat_get_ion_allocation_data(
 			struct compat_ion_allocation_data __user *data32,
 			struct ion_allocation_data __user *data)
@@ -105,7 +111,7 @@ long compat_ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return -ENOTTY;
 
 	switch (cmd) {
-	case ION_IOC_ALLOC:
+	case COMPAT_ION_IOC_ALLOC:
 	{
 		struct compat_ion_allocation_data __user *data32;
 		struct ion_allocation_data __user *data;
@@ -119,13 +125,12 @@ long compat_ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		err = compat_get_ion_allocation_data(data32, data);
 		if (err)
 			return err;
-
-		ret = filp->f_op->unlocked_ioctl(filp, cmd,
+		ret = filp->f_op->unlocked_ioctl(filp, ION_IOC_ALLOC,
 							(unsigned long)data);
 		err = compat_put_ion_allocation_data(data32, data);
 		return ret ? ret : err;
 	}
-	case ION_IOC_FREE:
+	case COMPAT_ION_IOC_FREE:
 	{
 		struct compat_ion_allocation_data __user *data32;
 		struct ion_allocation_data __user *data;
@@ -140,10 +145,10 @@ long compat_ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (err)
 			return err;
 
-		return filp->f_op->unlocked_ioctl(filp, cmd,
+		return filp->f_op->unlocked_ioctl(filp, ION_IOC_FREE,
 							(unsigned long)data);
 	}
-	case ION_IOC_CUSTOM: {
+	case COMPAT_ION_IOC_CUSTOM: {
 		struct compat_ion_custom_data __user *data32;
 		struct ion_custom_data __user *data;
 		int err;
@@ -157,7 +162,7 @@ long compat_ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (err)
 			return err;
 
-		return filp->f_op->unlocked_ioctl(filp, cmd,
+		return filp->f_op->unlocked_ioctl(filp, ION_IOC_CUSTOM,
 							(unsigned long)data);
 	}
 	case ION_IOC_SHARE:
-- 
1.8.3.2

