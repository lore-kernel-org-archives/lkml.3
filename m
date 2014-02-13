Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaBMTsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:48:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbaBMTsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:48:06 -0500
Date: Thu, 13 Feb 2014 14:47:59 -0500
Message-Id: <201402131947.s1DJlxIJ023501@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 35/38] staging/bcm: move IOCTL_BCM_NVM_RAW_READ case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 181 ++++++++++++++++++++++--------------------
 1 file changed, 94 insertions(+), 87 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 046e67ff2e35..0dc1c88c4576 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1886,6 +1886,97 @@ static int bcm_char_ioctl_select_dsd(void __user *argp, struct bcm_mini_adapter
 	return STATUS_SUCCESS;
 }
 
+static int bcm_char_ioctl_nvm_raw_read(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	struct bcm_nvm_readwrite stNVMRead;
+	struct bcm_ioctl_buffer IoBuffer;
+	INT NOB;
+	INT BuffSize;
+	INT ReadOffset = 0;
+	UINT ReadBytes = 0;
+	PUCHAR pReadBuff;
+	void __user *OutPutBuff;
+	INT Status = STATUS_FAILURE;
+
+	if (Adapter->eNVMType != NVM_FLASH) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "NVM TYPE is not Flash");
+		return -EINVAL;
+	}
+
+	/* Copy Ioctl Buffer structure */
+	if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer))) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "copy_from_user 1 failed\n");
+		return -EFAULT;
+	}
+
+	if (copy_from_user(&stNVMRead, IoBuffer.OutputBuffer, sizeof(struct bcm_nvm_readwrite)))
+		return -EFAULT;
+
+	NOB = stNVMRead.uiNumBytes;
+	/* In Raw-Read max Buff size : 64MB */
+
+	if (NOB > DEFAULT_BUFF_SIZE)
+		BuffSize = DEFAULT_BUFF_SIZE;
+	else
+		BuffSize = NOB;
+
+	ReadOffset = stNVMRead.uiOffset;
+	OutPutBuff = stNVMRead.pBuffer;
+
+	pReadBuff = kzalloc(BuffSize , GFP_KERNEL);
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
+		kfree(pReadBuff);
+		up(&Adapter->NVMRdmWrmLock);
+		return -EACCES;
+	}
+
+	Adapter->bFlashRawRead = TRUE;
+
+	while (NOB) {
+		if (NOB > DEFAULT_BUFF_SIZE)
+			ReadBytes = DEFAULT_BUFF_SIZE;
+		else
+			ReadBytes = NOB;
+
+		/* Reading the data from Flash 2.x */
+		Status = BeceemNVMRead(Adapter, (PUINT)pReadBuff, ReadOffset, ReadBytes);
+		if (Status) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Flash 2x read err with Status :%d", Status);
+			break;
+		}
+
+		BCM_DEBUG_PRINT_BUFFER(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, pReadBuff, ReadBytes);
+
+		Status = copy_to_user(OutPutBuff, pReadBuff, ReadBytes);
+		if (Status) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy to use failed with status :%d", Status);
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
+	Adapter->bFlashRawRead = false;
+	up(&Adapter->NVMRdmWrmLock);
+	kfree(pReadBuff);
+	return Status;
+}
+
+
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
 	struct bcm_tarang_data *pTarang = filp->private_data;
@@ -2117,93 +2208,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_select_dsd(argp, Adapter);
 		return Status;
 
-	case IOCTL_BCM_NVM_RAW_READ: {
-		struct bcm_nvm_readwrite stNVMRead;
-		INT NOB;
-		INT BuffSize;
-		INT ReadOffset = 0;
-		UINT ReadBytes = 0;
-		PUCHAR pReadBuff;
-		void __user *OutPutBuff;
-
-		if (Adapter->eNVMType != NVM_FLASH) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "NVM TYPE is not Flash");
-			return -EINVAL;
-		}
-
-		/* Copy Ioctl Buffer structure */
-		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer))) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "copy_from_user 1 failed\n");
-			return -EFAULT;
-		}
-
-		if (copy_from_user(&stNVMRead, IoBuffer.OutputBuffer, sizeof(struct bcm_nvm_readwrite)))
-			return -EFAULT;
-
-		NOB = stNVMRead.uiNumBytes;
-		/* In Raw-Read max Buff size : 64MB */
-
-		if (NOB > DEFAULT_BUFF_SIZE)
-			BuffSize = DEFAULT_BUFF_SIZE;
-		else
-			BuffSize = NOB;
-
-		ReadOffset = stNVMRead.uiOffset;
-		OutPutBuff = stNVMRead.pBuffer;
-
-		pReadBuff = kzalloc(BuffSize , GFP_KERNEL);
-		if (pReadBuff == NULL) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Memory allocation failed for Flash 2.x Read Structure");
-			Status = -ENOMEM;
-			break;
-		}
-		down(&Adapter->NVMRdmWrmLock);
-
-		if ((Adapter->IdleMode == TRUE) ||
-			(Adapter->bShutStatus == TRUE) ||
-			(Adapter->bPreparingForLowPowerMode == TRUE)) {
-
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Device is in Idle/Shutdown Mode\n");
-			kfree(pReadBuff);
-			up(&Adapter->NVMRdmWrmLock);
-			return -EACCES;
-		}
-
-		Adapter->bFlashRawRead = TRUE;
-
-		while (NOB) {
-			if (NOB > DEFAULT_BUFF_SIZE)
-				ReadBytes = DEFAULT_BUFF_SIZE;
-			else
-				ReadBytes = NOB;
-
-			/* Reading the data from Flash 2.x */
-			Status = BeceemNVMRead(Adapter, (PUINT)pReadBuff, ReadOffset, ReadBytes);
-			if (Status) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Flash 2x read err with Status :%d", Status);
-				break;
-			}
-
-			BCM_DEBUG_PRINT_BUFFER(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, pReadBuff, ReadBytes);
-
-			Status = copy_to_user(OutPutBuff, pReadBuff, ReadBytes);
-			if (Status) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy to use failed with status :%d", Status);
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
-		Adapter->bFlashRawRead = false;
-		up(&Adapter->NVMRdmWrmLock);
-		kfree(pReadBuff);
-		break;
-	}
+	case IOCTL_BCM_NVM_RAW_READ:
+		Status = bcm_char_ioctl_nvm_raw_read(argp, Adapter);
+		return Status;
 
 	case IOCTL_BCM_CNTRLMSG_MASK: {
 		ULONG RxCntrlMsgBitMask = 0;
-- 
1.8.5.3

