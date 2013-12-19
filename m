Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab3LSX4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 18:56:33 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:37172 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab3LSX4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 18:56:31 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: [PATCH] ion_test: Add compat_ioctl support (v2)
Date: Thu, 19 Dec 2013 15:56:23 -0800
Message-Id: <1387497383-8321-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <CAMbhsRR9XODihXhYof=Fo=ZEb=_t_OZ7g2xd9_Zd2B0RT1nXXA@mail.gmail.com>
References: <CAMbhsRR9XODihXhYof=Fo=ZEb=_t_OZ7g2xd9_Zd2B0RT1nXXA@mail.gmail.com>
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

This patch resolves this issue by adding a padding entry after
the write flag, and adding the compat_ioctl ptr.

Changes in v2:
- Add a padding int rather then making write a u64

Cc: Colin Cross <ccross@android.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_test.c  | 1 +
 drivers/staging/android/uapi/ion_test.h | 1 +
 2 files changed, 2 insertions(+)

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
index 614d1e3..ffef06f 100644
--- a/drivers/staging/android/uapi/ion_test.h
+++ b/drivers/staging/android/uapi/ion_test.h
@@ -32,6 +32,7 @@ struct ion_test_rw_data {
 	__u64 offset;
 	__u64 size;
 	int write;
+	int __padding;
 };
 
 #define ION_IOC_MAGIC		'I'
-- 
1.8.3.2

