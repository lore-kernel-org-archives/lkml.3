Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaBMTr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:47:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbaBMTrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:47:55 -0500
Date: Thu, 13 Feb 2014 14:47:43 -0500
Message-Id: <201402131947.s1DJlhK5023078@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 32/38] staging/bcm: move IOCTL_BCM_COPY_SECTION case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 153 ++++++++++++++++++++++--------------------
 1 file changed, 80 insertions(+), 73 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index a4a68a9bbd5f..7cf793b2746a 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1727,6 +1727,83 @@ static int bcm_char_ioctl_set_active_section(void __user *argp, struct bcm_mini_
 	return Status;
 }
 
+static int bcm_char_ioctl_copy_section(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	struct bcm_flash2x_copy_section sCopySectStrut = {0};
+	struct bcm_ioctl_buffer IoBuffer;
+	INT Status = STATUS_SUCCESS;
+
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_COPY_SECTION  Called");
+
+	Adapter->bAllDSDWriteAllow = false;
+	if (IsFlash2x(Adapter) != TRUE) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Flash Does not have 2.x map");
+		return -EINVAL;
+	}
+
+	Status = copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer));
+	if (Status) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy of IOCTL BUFFER failed Status :%d", Status);
+		return -EFAULT;
+	}
+
+	Status = copy_from_user(&sCopySectStrut, IoBuffer.InputBuffer, sizeof(struct bcm_flash2x_copy_section));
+	if (Status) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy of Copy_Section_Struct failed with Status :%d", Status);
+		return -EFAULT;
+	}
+
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Source SEction :%x", sCopySectStrut.SrcSection);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Destination SEction :%x", sCopySectStrut.DstSection);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "offset :%x", sCopySectStrut.offset);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "NOB :%x", sCopySectStrut.numOfBytes);
+
+	if (IsSectionExistInFlash(Adapter, sCopySectStrut.SrcSection) == false) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Source Section<%x> does not exist in Flash ", sCopySectStrut.SrcSection);
+		return -EINVAL;
+	}
+
+	if (IsSectionExistInFlash(Adapter, sCopySectStrut.DstSection) == false) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Destinatio Section<%x> does not exist in Flash ", sCopySectStrut.DstSection);
+		return -EINVAL;
+	}
+
+	if (sCopySectStrut.SrcSection == sCopySectStrut.DstSection) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Source and Destination section should be different");
+		return -EINVAL;
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
+	if (sCopySectStrut.SrcSection == ISO_IMAGE1 || sCopySectStrut.SrcSection == ISO_IMAGE2) {
+		if (IsNonCDLessDevice(Adapter)) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Device is Non-CDLess hence won't have ISO !!");
+			Status = -EINVAL;
+		} else if (sCopySectStrut.numOfBytes == 0) {
+			Status = BcmCopyISO(Adapter, sCopySectStrut);
+		} else {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Partial Copy of ISO section is not Allowed..");
+			Status = STATUS_FAILURE;
+		}
+		up(&Adapter->NVMRdmWrmLock);
+		return Status;
+	}
+
+	Status = BcmCopySection(Adapter, sCopySectStrut.SrcSection,
+				sCopySectStrut.DstSection, sCopySectStrut.offset, sCopySectStrut.numOfBytes);
+	up(&Adapter->NVMRdmWrmLock);
+	return Status;
+}
+
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -1947,79 +2024,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = STATUS_SUCCESS;
 		break;
 
-	case IOCTL_BCM_COPY_SECTION: {
-		struct bcm_flash2x_copy_section sCopySectStrut = {0};
-		Status = STATUS_SUCCESS;
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_COPY_SECTION  Called");
-
-		Adapter->bAllDSDWriteAllow = false;
-		if (IsFlash2x(Adapter) != TRUE) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Flash Does not have 2.x map");
-			return -EINVAL;
-		}
-
-		Status = copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer));
-		if (Status) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy of IOCTL BUFFER failed Status :%d", Status);
-			return -EFAULT;
-		}
-
-		Status = copy_from_user(&sCopySectStrut, IoBuffer.InputBuffer, sizeof(struct bcm_flash2x_copy_section));
-		if (Status) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy of Copy_Section_Struct failed with Status :%d", Status);
-			return -EFAULT;
-		}
-
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Source SEction :%x", sCopySectStrut.SrcSection);
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Destination SEction :%x", sCopySectStrut.DstSection);
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "offset :%x", sCopySectStrut.offset);
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "NOB :%x", sCopySectStrut.numOfBytes);
-
-		if (IsSectionExistInFlash(Adapter, sCopySectStrut.SrcSection) == false) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Source Section<%x> does not exist in Flash ", sCopySectStrut.SrcSection);
-			return -EINVAL;
-		}
-
-		if (IsSectionExistInFlash(Adapter, sCopySectStrut.DstSection) == false) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Destinatio Section<%x> does not exist in Flash ", sCopySectStrut.DstSection);
-			return -EINVAL;
-		}
-
-		if (sCopySectStrut.SrcSection == sCopySectStrut.DstSection) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Source and Destination section should be different");
-			return -EINVAL;
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
-		if (sCopySectStrut.SrcSection == ISO_IMAGE1 || sCopySectStrut.SrcSection == ISO_IMAGE2) {
-			if (IsNonCDLessDevice(Adapter)) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Device is Non-CDLess hence won't have ISO !!");
-				Status = -EINVAL;
-			} else if (sCopySectStrut.numOfBytes == 0) {
-				Status = BcmCopyISO(Adapter, sCopySectStrut);
-			} else {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Partial Copy of ISO section is not Allowed..");
-				Status = STATUS_FAILURE;
-			}
-			up(&Adapter->NVMRdmWrmLock);
-			return Status;
-		}
-
-		Status = BcmCopySection(Adapter, sCopySectStrut.SrcSection,
-					sCopySectStrut.DstSection, sCopySectStrut.offset, sCopySectStrut.numOfBytes);
-		up(&Adapter->NVMRdmWrmLock);
-	}
-	break;
+	case IOCTL_BCM_COPY_SECTION:
+		Status = bcm_char_ioctl_copy_section(argp, Adapter);
+		return Status;
 
 	case IOCTL_BCM_GET_FLASH_CS_INFO: {
 		Status = STATUS_SUCCESS;
-- 
1.8.5.3

