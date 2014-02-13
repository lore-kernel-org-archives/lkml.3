Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaBMTra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:47:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbaBMTr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:47:26 -0500
Date: Thu, 13 Feb 2014 14:47:18 -0500
Message-Id: <201402131947.s1DJlIXY023048@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 27/38] staging/bcm: move IOCTL_BCM_FLASH2X_SECTION_READ case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 187 ++++++++++++++++++++++--------------------
 1 file changed, 97 insertions(+), 90 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 3564018f56d7..b0b14e31a394 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1432,6 +1432,100 @@ static int bcm_char_ioctl_nvm_rw(void __user *argp, struct bcm_mini_adapter *Ada
 	return STATUS_SUCCESS;
 }
 
+static int bcm_char_ioctl_flash2x_section_read(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	struct bcm_flash2x_readwrite sFlash2xRead = {0};
+	struct bcm_ioctl_buffer IoBuffer;
+	PUCHAR pReadBuff = NULL;
+	UINT NOB = 0;
+	UINT BuffSize = 0;
+	UINT ReadBytes = 0;
+	UINT ReadOffset = 0;
+	INT Status = STATUS_FAILURE;
+	void __user *OutPutBuff;
+
+	if (IsFlash2x(Adapter) != TRUE)	{
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Flash Does not have 2.x map");
+		return -EINVAL;
+	}
+
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_FLASH2X_SECTION_READ Called");
+	if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
+		return -EFAULT;
+
+	/* Reading FLASH 2.x READ structure */
+	if (copy_from_user(&sFlash2xRead, IoBuffer.InputBuffer, sizeof(struct bcm_flash2x_readwrite)))
+		return -EFAULT;
+
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.Section :%x", sFlash2xRead.Section);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.offset :%x", sFlash2xRead.offset);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.numOfBytes :%x", sFlash2xRead.numOfBytes);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.bVerify :%x\n", sFlash2xRead.bVerify);
+
+	/* This was internal to driver for raw read. now it has ben exposed to user space app. */
+	if (validateFlash2xReadWrite(Adapter, &sFlash2xRead) == false)
+		return STATUS_FAILURE;
+
+	NOB = sFlash2xRead.numOfBytes;
+	if (NOB > Adapter->uiSectorSize)
+		BuffSize = Adapter->uiSectorSize;
+	else
+		BuffSize = NOB;
+
+	ReadOffset = sFlash2xRead.offset;
+	OutPutBuff = IoBuffer.OutputBuffer;
+	pReadBuff = (PCHAR)kzalloc(BuffSize , GFP_KERNEL);
+
+	if (pReadBuff == NULL) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Memory allocation failed for Flash 2.x Read Structure");
+		return -ENOMEM;
+	}
+	down(&Adapter->NVMRdmWrmLock);
+
+	if ((Adapter->IdleMode == TRUE) ||
+		(Adapter->bShutStatus == TRUE) ||
+		(Adapter->bPreparingForLowPowerMode == TRUE)) {
+
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Device is in Idle/Shutdown Mode\n");
+		up(&Adapter->NVMRdmWrmLock);
+		kfree(pReadBuff);
+		return -EACCES;
+	}
+
+	while (NOB) {
+		if (NOB > Adapter->uiSectorSize)
+			ReadBytes = Adapter->uiSectorSize;
+		else
+			ReadBytes = NOB;
+
+		/* Reading the data from Flash 2.x */
+		Status = BcmFlash2xBulkRead(Adapter, (PUINT)pReadBuff, sFlash2xRead.Section, ReadOffset, ReadBytes);
+		if (Status) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Flash 2x read err with Status :%d", Status);
+			break;
+		}
+
+		BCM_DEBUG_PRINT_BUFFER(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, pReadBuff, ReadBytes);
+
+		Status = copy_to_user(OutPutBuff, pReadBuff, ReadBytes);
+		if (Status) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Copy to use failed with status :%d", Status);
+			up(&Adapter->NVMRdmWrmLock);
+			kfree(pReadBuff);
+			return -EFAULT;
+		}
+		NOB = NOB - ReadBytes;
+		if (NOB) {
+			ReadOffset = ReadOffset + ReadBytes;
+			OutPutBuff = OutPutBuff + ReadBytes;
+		}
+	}
+
+	up(&Adapter->NVMRdmWrmLock);
+	kfree(pReadBuff);
+	return Status;
+}
+
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -1629,96 +1723,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_nvm_rw(argp, Adapter, cmd);
 		return Status;
 
-	case IOCTL_BCM_FLASH2X_SECTION_READ: {
-		struct bcm_flash2x_readwrite sFlash2xRead = {0};
-		PUCHAR pReadBuff = NULL;
-		UINT NOB = 0;
-		UINT BuffSize = 0;
-		UINT ReadBytes = 0;
-		UINT ReadOffset = 0;
-		void __user *OutPutBuff;
-
-		if (IsFlash2x(Adapter) != TRUE)	{
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Flash Does not have 2.x map");
-			return -EINVAL;
-		}
-
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_FLASH2X_SECTION_READ Called");
-		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
-			return -EFAULT;
-
-		/* Reading FLASH 2.x READ structure */
-		if (copy_from_user(&sFlash2xRead, IoBuffer.InputBuffer, sizeof(struct bcm_flash2x_readwrite)))
-			return -EFAULT;
-
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.Section :%x", sFlash2xRead.Section);
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.offset :%x", sFlash2xRead.offset);
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.numOfBytes :%x", sFlash2xRead.numOfBytes);
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.bVerify :%x\n", sFlash2xRead.bVerify);
-
-		/* This was internal to driver for raw read. now it has ben exposed to user space app. */
-		if (validateFlash2xReadWrite(Adapter, &sFlash2xRead) == false)
-			return STATUS_FAILURE;
-
-		NOB = sFlash2xRead.numOfBytes;
-		if (NOB > Adapter->uiSectorSize)
-			BuffSize = Adapter->uiSectorSize;
-		else
-			BuffSize = NOB;
-
-		ReadOffset = sFlash2xRead.offset;
-		OutPutBuff = IoBuffer.OutputBuffer;
-		pReadBuff = (PCHAR)kzalloc(BuffSize , GFP_KERNEL);
-
-		if (pReadBuff == NULL) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Memory allocation failed for Flash 2.x Read Structure");
-			return -ENOMEM;
-		}
-		down(&Adapter->NVMRdmWrmLock);
-
-		if ((Adapter->IdleMode == TRUE) ||
-			(Adapter->bShutStatus == TRUE) ||
-			(Adapter->bPreparingForLowPowerMode == TRUE)) {
-
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Device is in Idle/Shutdown Mode\n");
-			up(&Adapter->NVMRdmWrmLock);
-			kfree(pReadBuff);
-			return -EACCES;
-		}
-
-		while (NOB) {
-			if (NOB > Adapter->uiSectorSize)
-				ReadBytes = Adapter->uiSectorSize;
-			else
-				ReadBytes = NOB;
-
-			/* Reading the data from Flash 2.x */
-			Status = BcmFlash2xBulkRead(Adapter, (PUINT)pReadBuff, sFlash2xRead.Section, ReadOffset, ReadBytes);
-			if (Status) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Flash 2x read err with Status :%d", Status);
-				break;
-			}
-
-			BCM_DEBUG_PRINT_BUFFER(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, pReadBuff, ReadBytes);
-
-			Status = copy_to_user(OutPutBuff, pReadBuff, ReadBytes);
-			if (Status) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Copy to use failed with status :%d", Status);
-				up(&Adapter->NVMRdmWrmLock);
-				kfree(pReadBuff);
-				return -EFAULT;
-			}
-			NOB = NOB - ReadBytes;
-			if (NOB) {
-				ReadOffset = ReadOffset + ReadBytes;
-				OutPutBuff = OutPutBuff + ReadBytes;
-			}
-		}
-
-		up(&Adapter->NVMRdmWrmLock);
-		kfree(pReadBuff);
-	}
-	break;
+	case IOCTL_BCM_FLASH2X_SECTION_READ:
+		Status = bcm_char_ioctl_flash2x_section_read(argp, Adapter);
+		return Status;
 
 	case IOCTL_BCM_FLASH2X_SECTION_WRITE: {
 		struct bcm_flash2x_readwrite sFlash2xWrite = {0};
-- 
1.8.5.3

