Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaBMTqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:46:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbaBMTqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:46:34 -0500
Date: Thu, 13 Feb 2014 14:46:27 -0500
Message-Id: <201402131946.s1DJkR55022579@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 17/38] staging/bcm: move IOCTL_BCM_GET_DRIVER_VERSION case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 9d8048feae23..17d2a3f941f5 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1013,6 +1013,23 @@ static int bcm_char_ioctl_switch_transfer_mode(void __user *argp, struct bcm_min
 	return STATUS_SUCCESS;
 }
 
+static int bcm_char_ioctl_get_driver_version(void __user *argp)
+{
+	struct bcm_ioctl_buffer IoBuffer;
+	ulong len;
+
+	/* Copy Ioctl Buffer structure */
+	if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
+		return -EFAULT;
+
+	len = min_t(ulong, IoBuffer.OutputLength, strlen(DRV_VERSION) + 1);
+
+	if (copy_to_user(IoBuffer.OutputBuffer, DRV_VERSION, len))
+		return -EFAULT;
+
+	return STATUS_SUCCESS;
+}
+
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -1159,20 +1176,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_switch_transfer_mode(argp, Adapter);
 		return Status;
 
-	case IOCTL_BCM_GET_DRIVER_VERSION: {
-		ulong len;
-
-		/* Copy Ioctl Buffer structure */
-		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
-			return -EFAULT;
-
-		len = min_t(ulong, IoBuffer.OutputLength, strlen(DRV_VERSION) + 1);
-
-		if (copy_to_user(IoBuffer.OutputBuffer, DRV_VERSION, len))
-			return -EFAULT;
-		Status = STATUS_SUCCESS;
-		break;
-	}
+	case IOCTL_BCM_GET_DRIVER_VERSION:
+		Status = bcm_char_ioctl_get_driver_version(argp);
+		return Status;
 
 	case IOCTL_BCM_GET_CURRENT_STATUS: {
 		struct bcm_link_state link_state;
-- 
1.8.5.3

