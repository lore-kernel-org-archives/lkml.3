Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaBMTre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:47:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbaBMTrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:47:31 -0500
Date: Thu, 13 Feb 2014 14:47:23 -0500
Message-Id: <201402131947.s1DJlNRT023054@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 28/38] staging/bcm: move IOCTL_BCM_FLASH2X_SECTION_WRITE case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 223 ++++++++++++++++++++++--------------------
 1 file changed, 115 insertions(+), 108 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index b0b14e31a394..77e96e040f34 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1526,6 +1526,118 @@ static int bcm_char_ioctl_flash2x_section_read(void __user *argp, struct bcm_min
 	return Status;
 }
 
+static int bcm_char_ioctl_flash2x_section_write(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	struct bcm_flash2x_readwrite sFlash2xWrite = {0};
+	struct bcm_ioctl_buffer IoBuffer;
+	PUCHAR pWriteBuff;
+	void __user *InputAddr;
+	UINT NOB = 0;
+	UINT BuffSize = 0;
+	UINT WriteOffset = 0;
+	UINT WriteBytes = 0;
+	INT Status = STATUS_FAILURE;
+
+	if (IsFlash2x(Adapter) != TRUE) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Flash Does not have 2.x map");
+		return -EINVAL;
+	}
+
+	/* First make this False so that we can enable the Sector Permission Check in BeceemFlashBulkWrite */
+	Adapter->bAllDSDWriteAllow = false;
+
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_FLASH2X_SECTION_WRITE Called");
+
+	if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
+		return -EFAULT;
+
+	/* Reading FLASH 2.x READ structure */
+	if (copy_from_user(&sFlash2xWrite, IoBuffer.InputBuffer, sizeof(struct bcm_flash2x_readwrite)))
+		return -EFAULT;
+
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.Section :%x", sFlash2xWrite.Section);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.offset :%d", sFlash2xWrite.offset);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.numOfBytes :%x", sFlash2xWrite.numOfBytes);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.bVerify :%x\n", sFlash2xWrite.bVerify);
+
+	if ((sFlash2xWrite.Section != VSA0) && (sFlash2xWrite.Section != VSA1) && (sFlash2xWrite.Section != VSA2)) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Only VSA write is allowed");
+		return -EINVAL;
+	}
+
+	if (validateFlash2xReadWrite(Adapter, &sFlash2xWrite) == false)
+		return STATUS_FAILURE;
+
+	InputAddr = sFlash2xWrite.pDataBuff;
+	WriteOffset = sFlash2xWrite.offset;
+	NOB = sFlash2xWrite.numOfBytes;
+
+	if (NOB > Adapter->uiSectorSize)
+		BuffSize = Adapter->uiSectorSize;
+	else
+		BuffSize = NOB;
+
+	pWriteBuff = kmalloc(BuffSize, GFP_KERNEL);
+
+	if (pWriteBuff == NULL)
+		return -ENOMEM;
+
+	/* extracting the remainder of the given offset. */
+	WriteBytes = Adapter->uiSectorSize;
+	if (WriteOffset % Adapter->uiSectorSize)
+		WriteBytes = Adapter->uiSectorSize - (WriteOffset % Adapter->uiSectorSize);
+
+	if (NOB < WriteBytes)
+		WriteBytes = NOB;
+
+	down(&Adapter->NVMRdmWrmLock);
+
+	if ((Adapter->IdleMode == TRUE) ||
+		(Adapter->bShutStatus == TRUE) ||
+		(Adapter->bPreparingForLowPowerMode == TRUE)) {
+
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Device is in Idle/Shutdown Mode\n");
+		up(&Adapter->NVMRdmWrmLock);
+		kfree(pWriteBuff);
+		return -EACCES;
+	}
+
+	BcmFlash2xCorruptSig(Adapter, sFlash2xWrite.Section);
+	do {
+		Status = copy_from_user(pWriteBuff, InputAddr, WriteBytes);
+		if (Status) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy to user failed with status :%d", Status);
+			up(&Adapter->NVMRdmWrmLock);
+			kfree(pWriteBuff);
+			return -EFAULT;
+		}
+		BCM_DEBUG_PRINT_BUFFER(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, pWriteBuff, WriteBytes);
+
+		/* Writing the data from Flash 2.x */
+		Status = BcmFlash2xBulkWrite(Adapter, (PUINT)pWriteBuff, sFlash2xWrite.Section, WriteOffset, WriteBytes, sFlash2xWrite.bVerify);
+
+		if (Status) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Flash 2x read err with Status :%d", Status);
+			break;
+		}
+
+		NOB = NOB - WriteBytes;
+		if (NOB) {
+			WriteOffset = WriteOffset + WriteBytes;
+			InputAddr = InputAddr + WriteBytes;
+			if (NOB > Adapter->uiSectorSize)
+				WriteBytes = Adapter->uiSectorSize;
+			else
+				WriteBytes = NOB;
+		}
+	} while (NOB > 0);
+
+	BcmFlash2xWriteSig(Adapter, sFlash2xWrite.Section);
+	up(&Adapter->NVMRdmWrmLock);
+	kfree(pWriteBuff);
+	return Status;
+}
+
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -1727,114 +1839,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_flash2x_section_read(argp, Adapter);
 		return Status;
 
-	case IOCTL_BCM_FLASH2X_SECTION_WRITE: {
-		struct bcm_flash2x_readwrite sFlash2xWrite = {0};
-		PUCHAR pWriteBuff;
-		void __user *InputAddr;
-		UINT NOB = 0;
-		UINT BuffSize = 0;
-		UINT WriteOffset = 0;
-		UINT WriteBytes = 0;
-
-		if (IsFlash2x(Adapter) != TRUE) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Flash Does not have 2.x map");
-			return -EINVAL;
-		}
-
-		/* First make this False so that we can enable the Sector Permission Check in BeceemFlashBulkWrite */
-		Adapter->bAllDSDWriteAllow = false;
-
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_FLASH2X_SECTION_WRITE Called");
-
-		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
-			return -EFAULT;
-
-		/* Reading FLASH 2.x READ structure */
-		if (copy_from_user(&sFlash2xWrite, IoBuffer.InputBuffer, sizeof(struct bcm_flash2x_readwrite)))
-			return -EFAULT;
-
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.Section :%x", sFlash2xWrite.Section);
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.offset :%d", sFlash2xWrite.offset);
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.numOfBytes :%x", sFlash2xWrite.numOfBytes);
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.bVerify :%x\n", sFlash2xWrite.bVerify);
-
-		if ((sFlash2xWrite.Section != VSA0) && (sFlash2xWrite.Section != VSA1) && (sFlash2xWrite.Section != VSA2)) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Only VSA write is allowed");
-			return -EINVAL;
-		}
-
-		if (validateFlash2xReadWrite(Adapter, &sFlash2xWrite) == false)
-			return STATUS_FAILURE;
-
-		InputAddr = sFlash2xWrite.pDataBuff;
-		WriteOffset = sFlash2xWrite.offset;
-		NOB = sFlash2xWrite.numOfBytes;
-
-		if (NOB > Adapter->uiSectorSize)
-			BuffSize = Adapter->uiSectorSize;
-		else
-			BuffSize = NOB;
-
-		pWriteBuff = kmalloc(BuffSize, GFP_KERNEL);
-
-		if (pWriteBuff == NULL)
-			return -ENOMEM;
-
-		/* extracting the remainder of the given offset. */
-		WriteBytes = Adapter->uiSectorSize;
-		if (WriteOffset % Adapter->uiSectorSize)
-			WriteBytes = Adapter->uiSectorSize - (WriteOffset % Adapter->uiSectorSize);
-
-		if (NOB < WriteBytes)
-			WriteBytes = NOB;
-
-		down(&Adapter->NVMRdmWrmLock);
-
-		if ((Adapter->IdleMode == TRUE) ||
-			(Adapter->bShutStatus == TRUE) ||
-			(Adapter->bPreparingForLowPowerMode == TRUE)) {
-
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Device is in Idle/Shutdown Mode\n");
-			up(&Adapter->NVMRdmWrmLock);
-			kfree(pWriteBuff);
-			return -EACCES;
-		}
-
-		BcmFlash2xCorruptSig(Adapter, sFlash2xWrite.Section);
-		do {
-			Status = copy_from_user(pWriteBuff, InputAddr, WriteBytes);
-			if (Status) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy to user failed with status :%d", Status);
-				up(&Adapter->NVMRdmWrmLock);
-				kfree(pWriteBuff);
-				return -EFAULT;
-			}
-			BCM_DEBUG_PRINT_BUFFER(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, pWriteBuff, WriteBytes);
-
-			/* Writing the data from Flash 2.x */
-			Status = BcmFlash2xBulkWrite(Adapter, (PUINT)pWriteBuff, sFlash2xWrite.Section, WriteOffset, WriteBytes, sFlash2xWrite.bVerify);
-
-			if (Status) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Flash 2x read err with Status :%d", Status);
-				break;
-			}
-
-			NOB = NOB - WriteBytes;
-			if (NOB) {
-				WriteOffset = WriteOffset + WriteBytes;
-				InputAddr = InputAddr + WriteBytes;
-				if (NOB > Adapter->uiSectorSize)
-					WriteBytes = Adapter->uiSectorSize;
-				else
-					WriteBytes = NOB;
-			}
-		} while (NOB > 0);
-
-		BcmFlash2xWriteSig(Adapter, sFlash2xWrite.Section);
-		up(&Adapter->NVMRdmWrmLock);
-		kfree(pWriteBuff);
-	}
-	break;
+	case IOCTL_BCM_FLASH2X_SECTION_WRITE:
+		Status = bcm_char_ioctl_flash2x_section_write(argp, Adapter);
+		return Status;
 
 	case IOCTL_BCM_GET_FLASH2X_SECTION_BITMAP: {
 		struct bcm_flash2x_bitmap *psFlash2xBitMap;
-- 
1.8.5.3

