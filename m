Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaBMTrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:47:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbaBMTrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:47:36 -0500
Date: Thu, 13 Feb 2014 14:47:28 -0500
Message-Id: <201402131947.s1DJlSKH023060@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 29/38] staging/bcm: move IOCTL_BCM_GET_FLASH2X_SECTION_BITMAP case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 86 +++++++++++++++++++++++--------------------
 1 file changed, 47 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 77e96e040f34..6732e6311db0 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1638,6 +1638,50 @@ static int bcm_char_ioctl_flash2x_section_write(void __user *argp, struct bcm_mi
 	return Status;
 }
 
+static int bcm_char_ioctl_flash2x_section_bitmap(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	struct bcm_flash2x_bitmap *psFlash2xBitMap;
+	struct bcm_ioctl_buffer IoBuffer;
+	INT Status = STATUS_FAILURE;
+
+BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_GET_FLASH2X_SECTION_BITMAP Called");
+
+	if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
+		return -EFAULT;
+
+	if (IoBuffer.OutputLength != sizeof(struct bcm_flash2x_bitmap))
+		return -EINVAL;
+
+	psFlash2xBitMap = kzalloc(sizeof(struct bcm_flash2x_bitmap), GFP_KERNEL);
+	if (psFlash2xBitMap == NULL) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Memory is not available");
+		return -ENOMEM;
+	}
+
+	/* Reading the Flash Sectio Bit map */
+	down(&Adapter->NVMRdmWrmLock);
+
+	if ((Adapter->IdleMode == TRUE) ||
+		(Adapter->bShutStatus == TRUE) ||
+		(Adapter->bPreparingForLowPowerMode == TRUE)) {
+
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Device is in Idle/Shutdown Mode\n");
+		up(&Adapter->NVMRdmWrmLock);
+		kfree(psFlash2xBitMap);
+		return -EACCES;
+	}
+
+	BcmGetFlash2xSectionalBitMap(Adapter, psFlash2xBitMap);
+	up(&Adapter->NVMRdmWrmLock);
+	if (copy_to_user(IoBuffer.OutputBuffer, psFlash2xBitMap, sizeof(struct bcm_flash2x_bitmap))) {
+		kfree(psFlash2xBitMap);
+		return -EFAULT;
+	}
+
+	kfree(psFlash2xBitMap);
+	return Status;
+}
+
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -1843,45 +1887,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_flash2x_section_write(argp, Adapter);
 		return Status;
 
-	case IOCTL_BCM_GET_FLASH2X_SECTION_BITMAP: {
-		struct bcm_flash2x_bitmap *psFlash2xBitMap;
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_GET_FLASH2X_SECTION_BITMAP Called");
-
-		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
-			return -EFAULT;
-
-		if (IoBuffer.OutputLength != sizeof(struct bcm_flash2x_bitmap))
-			return -EINVAL;
-
-		psFlash2xBitMap = kzalloc(sizeof(struct bcm_flash2x_bitmap), GFP_KERNEL);
-		if (psFlash2xBitMap == NULL) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Memory is not available");
-			return -ENOMEM;
-		}
-
-		/* Reading the Flash Sectio Bit map */
-		down(&Adapter->NVMRdmWrmLock);
-
-		if ((Adapter->IdleMode == TRUE) ||
-			(Adapter->bShutStatus == TRUE) ||
-			(Adapter->bPreparingForLowPowerMode == TRUE)) {
-
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Device is in Idle/Shutdown Mode\n");
-			up(&Adapter->NVMRdmWrmLock);
-			kfree(psFlash2xBitMap);
-			return -EACCES;
-		}
-
-		BcmGetFlash2xSectionalBitMap(Adapter, psFlash2xBitMap);
-		up(&Adapter->NVMRdmWrmLock);
-		if (copy_to_user(IoBuffer.OutputBuffer, psFlash2xBitMap, sizeof(struct bcm_flash2x_bitmap))) {
-			kfree(psFlash2xBitMap);
-			return -EFAULT;
-		}
-
-		kfree(psFlash2xBitMap);
-	}
-	break;
+	case IOCTL_BCM_GET_FLASH2X_SECTION_BITMAP:
+		Status = bcm_char_ioctl_flash2x_section_bitmap(argp, Adapter);
+		return Status;
 
 	case IOCTL_BCM_SET_ACTIVE_SECTION: {
 		enum bcm_flash2x_section_val eFlash2xSectionVal = 0;
-- 
1.8.5.3

