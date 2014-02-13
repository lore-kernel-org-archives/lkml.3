Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaBMTq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:46:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbaBMTqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:46:55 -0500
Date: Thu, 13 Feb 2014 14:46:47 -0500
Message-Id: <201402131946.s1DJkle8022990@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 21/38] staging/bcm: move IOCTL_BCM_GET_HOST_MIBS case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 68 ++++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 00c66f503799..fb252c25f5ef 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1100,6 +1100,41 @@ static int bcm_char_ioctl_get_dsx_indication(void __user *argp, struct bcm_mini_
 	return STATUS_SUCCESS;
 }
 
+static int bcm_char_ioctl_get_host_mibs(void __user *argp, struct bcm_mini_adapter *Adapter, struct bcm_tarang_data *pTarang)
+{
+	struct bcm_ioctl_buffer IoBuffer;
+	INT Status = STATUS_FAILURE;
+	PVOID temp_buff;
+
+	if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
+		return -EFAULT;
+
+	if (IoBuffer.OutputLength != sizeof(struct bcm_host_stats_mibs)) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+				"Length Check failed %lu %zd\n",
+				IoBuffer.OutputLength, sizeof(struct bcm_host_stats_mibs));
+		return -EINVAL;
+	}
+
+	/* FIXME: HOST_STATS are too big for kmalloc (122048)! */
+	temp_buff = kzalloc(sizeof(struct bcm_host_stats_mibs), GFP_KERNEL);
+	if (!temp_buff)
+		return STATUS_FAILURE;
+
+	Status = ProcessGetHostMibs(Adapter, temp_buff);
+	GetDroppedAppCntrlPktMibs(temp_buff, pTarang);
+
+	if (Status != STATUS_FAILURE) {
+		if (copy_to_user(IoBuffer.OutputBuffer, temp_buff, sizeof(struct bcm_host_stats_mibs))) {
+			kfree(temp_buff);
+			return -EFAULT;
+		}
+	}
+
+	kfree(temp_buff);
+	return Status;
+}
+
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -1262,36 +1297,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_get_dsx_indication(argp, Adapter);
 		return Status;
 
-	case IOCTL_BCM_GET_HOST_MIBS: {
-		PVOID temp_buff;
-
-		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
-			return -EFAULT;
-
-		if (IoBuffer.OutputLength != sizeof(struct bcm_host_stats_mibs)) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-					"Length Check failed %lu %zd\n",
-					IoBuffer.OutputLength, sizeof(struct bcm_host_stats_mibs));
-			return -EINVAL;
-		}
-
-		/* FIXME: HOST_STATS are too big for kmalloc (122048)! */
-		temp_buff = kzalloc(sizeof(struct bcm_host_stats_mibs), GFP_KERNEL);
-		if (!temp_buff)
-			return STATUS_FAILURE;
-
-		Status = ProcessGetHostMibs(Adapter, temp_buff);
-		GetDroppedAppCntrlPktMibs(temp_buff, pTarang);
-
-		if (Status != STATUS_FAILURE)
-			if (copy_to_user(IoBuffer.OutputBuffer, temp_buff, sizeof(struct bcm_host_stats_mibs))) {
-				kfree(temp_buff);
-				return -EFAULT;
-			}
-
-		kfree(temp_buff);
-		break;
-	}
+	case IOCTL_BCM_GET_HOST_MIBS:
+		Status = bcm_char_ioctl_get_host_mibs(argp, Adapter, pTarang);
+		return Status;
 
 	case IOCTL_BCM_WAKE_UP_DEVICE_FROM_IDLE:
 		if ((false == Adapter->bTriedToWakeUpFromlowPowerMode) && (TRUE == Adapter->IdleMode)) {
-- 
1.8.5.3

