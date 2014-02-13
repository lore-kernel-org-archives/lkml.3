Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaBMTsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:48:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbaBMTsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:48:21 -0500
Date: Thu, 13 Feb 2014 14:48:14 -0500
Message-Id: <201402131948.s1DJmEHR023519@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 38/38] staging/bcm: move IOCTL_BCM_TIME_SINCE_NET_ENTRY case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 42 ++++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 74360ee45c2b..fdebc3bba0b5 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -2029,6 +2029,27 @@ static int bcm_char_ioctl_get_device_driver_info(void __user *argp, struct bcm_m
 	return STATUS_SUCCESS;
 }
 
+static int bcm_char_ioctl_time_since_net_entry(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	struct bcm_time_elapsed stTimeElapsedSinceNetEntry = {0};
+	struct bcm_ioctl_buffer IoBuffer;
+
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_TIME_SINCE_NET_ENTRY called");
+
+	if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
+		return -EFAULT;
+
+	if (IoBuffer.OutputLength < sizeof(struct bcm_time_elapsed))
+		return -EINVAL;
+
+	stTimeElapsedSinceNetEntry.ul64TimeElapsedSinceNetEntry = get_seconds() - Adapter->liTimeSinceLastNetEntry;
+
+	if (copy_to_user(IoBuffer.OutputBuffer, &stTimeElapsedSinceNetEntry, sizeof(struct bcm_time_elapsed)))
+		return -EFAULT;
+
+	return STATUS_SUCCESS;
+}
+
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -2036,7 +2057,6 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 	void __user *argp = (void __user *)arg;
 	struct bcm_mini_adapter *Adapter = pTarang->Adapter;
 	INT Status = STATUS_FAILURE;
-	struct bcm_ioctl_buffer IoBuffer;
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
 			"Parameters Passed to control IOCTL cmd=0x%X arg=0x%lX",
@@ -2273,23 +2293,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_get_device_driver_info(argp, Adapter);
 		return Status;
 
-	case IOCTL_BCM_TIME_SINCE_NET_ENTRY: {
-		struct bcm_time_elapsed stTimeElapsedSinceNetEntry = {0};
-
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_TIME_SINCE_NET_ENTRY called");
-
-		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
-			return -EFAULT;
-
-		if (IoBuffer.OutputLength < sizeof(struct bcm_time_elapsed))
-			return -EINVAL;
-
-		stTimeElapsedSinceNetEntry.ul64TimeElapsedSinceNetEntry = get_seconds() - Adapter->liTimeSinceLastNetEntry;
-
-		if (copy_to_user(IoBuffer.OutputBuffer, &stTimeElapsedSinceNetEntry, sizeof(struct bcm_time_elapsed)))
-			return -EFAULT;
-	}
-	break;
+	case IOCTL_BCM_TIME_SINCE_NET_ENTRY:
+		Status = bcm_char_ioctl_time_since_net_entry(argp, Adapter);
+		return Status;
 
 	case IOCTL_CLOSE_NOTIFICATION:
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_CLOSE_NOTIFICATION");
-- 
1.8.5.3

