Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaBMTrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:47:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbaBMTrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:47:41 -0500
Date: Thu, 13 Feb 2014 14:47:33 -0500
Message-Id: <201402131947.s1DJlXq1023066@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 30/38] staging/bcm: move IOCTL_BCM_SET_ACTIVE_SECTION case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 87 ++++++++++++++++++++++++-------------------
 1 file changed, 48 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 6732e6311db0..010dd2a56df0 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1682,6 +1682,51 @@ BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_GET_
 	return Status;
 }
 
+static int bcm_char_ioctl_set_active_section(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	enum bcm_flash2x_section_val eFlash2xSectionVal = 0;
+	INT Status = STATUS_FAILURE;
+	struct bcm_ioctl_buffer IoBuffer;
+
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_SET_ACTIVE_SECTION Called");
+
+	if (IsFlash2x(Adapter) != TRUE) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Flash Does not have 2.x map");
+		return -EINVAL;
+	}
+
+	Status = copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer));
+	if (Status) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy of IOCTL BUFFER failed");
+		return -EFAULT;
+	}
+
+	Status = copy_from_user(&eFlash2xSectionVal, IoBuffer.InputBuffer, sizeof(INT));
+	if (Status) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy of flash section val failed");
+		return -EFAULT;
+	}
+
+	down(&Adapter->NVMRdmWrmLock);
+
+	if ((Adapter->IdleMode == TRUE) ||
+		(Adapter->bShutStatus == TRUE) ||
+		(Adapter->bPreparingForLowPowerMode == TRUE)) {
+
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Device is in Idle/Shutdown Mode\n");
+		up(&Adapter->NVMRdmWrmLock);
+		return -EACCES;
+	}
+
+	Status = BcmSetActiveSection(Adapter, eFlash2xSectionVal);
+	if (Status)
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Failed to make it's priority Highest. Status %d", Status);
+
+	up(&Adapter->NVMRdmWrmLock);
+
+	return Status;
+}
+
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -1891,45 +1936,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_flash2x_section_bitmap(argp, Adapter);
 		return Status;
 
-	case IOCTL_BCM_SET_ACTIVE_SECTION: {
-		enum bcm_flash2x_section_val eFlash2xSectionVal = 0;
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_SET_ACTIVE_SECTION Called");
-
-		if (IsFlash2x(Adapter) != TRUE) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Flash Does not have 2.x map");
-			return -EINVAL;
-		}
-
-		Status = copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer));
-		if (Status) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy of IOCTL BUFFER failed");
-			return -EFAULT;
-		}
-
-		Status = copy_from_user(&eFlash2xSectionVal, IoBuffer.InputBuffer, sizeof(INT));
-		if (Status) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy of flash section val failed");
-			return -EFAULT;
-		}
-
-		down(&Adapter->NVMRdmWrmLock);
-
-		if ((Adapter->IdleMode == TRUE) ||
-			(Adapter->bShutStatus == TRUE) ||
-			(Adapter->bPreparingForLowPowerMode == TRUE)) {
-
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Device is in Idle/Shutdown Mode\n");
-			up(&Adapter->NVMRdmWrmLock);
-			return -EACCES;
-		}
-
-		Status = BcmSetActiveSection(Adapter, eFlash2xSectionVal);
-		if (Status)
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Failed to make it's priority Highest. Status %d", Status);
-
-		up(&Adapter->NVMRdmWrmLock);
-	}
-	break;
+	case IOCTL_BCM_SET_ACTIVE_SECTION:
+		Status = bcm_char_ioctl_set_active_section(argp, Adapter);
+		return Status;
 
 	case IOCTL_BCM_IDENTIFY_ACTIVE_SECTION: {
 		/* Right Now we are taking care of only DSD */
-- 
1.8.5.3

