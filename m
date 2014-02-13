Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaBMTrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:47:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbaBMTrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:47:20 -0500
Date: Thu, 13 Feb 2014 14:47:13 -0500
Message-Id: <201402131947.s1DJlDrE023042@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 26/38] staging/bcm: move IOCTL_BCM_NVM_[READ|WRITE] cases out to their own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 290 ++++++++++++++++++++++--------------------
 1 file changed, 149 insertions(+), 141 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index a5d5c58b5a90..3564018f56d7 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1286,6 +1286,152 @@ static int bcm_char_ioctl_set_debug(void __user *argp, struct bcm_mini_adapter *
 	return STATUS_SUCCESS;
 }
 
+static int bcm_char_ioctl_nvm_rw(void __user *argp, struct bcm_mini_adapter *Adapter, UINT cmd)
+{
+	struct bcm_nvm_readwrite stNVMReadWrite;
+	struct timeval tv0, tv1;
+	struct bcm_ioctl_buffer IoBuffer;
+	PUCHAR pReadData = NULL;
+	ULONG ulDSDMagicNumInUsrBuff = 0;
+	INT Status = STATUS_FAILURE;
+
+	memset(&tv0, 0, sizeof(struct timeval));
+	memset(&tv1, 0, sizeof(struct timeval));
+	if ((Adapter->eNVMType == NVM_FLASH) && (Adapter->uiFlashLayoutMajorVersion == 0)) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "The Flash Control Section is Corrupted. Hence Rejection on NVM Read/Write\n");
+		return -EFAULT;
+	}
+
+	if (IsFlash2x(Adapter)) {
+		if ((Adapter->eActiveDSD != DSD0) &&
+			(Adapter->eActiveDSD != DSD1) &&
+			(Adapter->eActiveDSD != DSD2)) {
+
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "No DSD is active..hence NVM Command is blocked");
+			return STATUS_FAILURE;
+		}
+	}
+
+	/* Copy Ioctl Buffer structure */
+	if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
+		return -EFAULT;
+
+	if (copy_from_user(&stNVMReadWrite,
+				(IOCTL_BCM_NVM_READ == cmd) ? IoBuffer.OutputBuffer : IoBuffer.InputBuffer,
+				sizeof(struct bcm_nvm_readwrite)))
+		return -EFAULT;
+
+	/*
+	 * Deny the access if the offset crosses the cal area limit.
+	 */
+	if (stNVMReadWrite.uiNumBytes > Adapter->uiNVMDSDSize)
+		return STATUS_FAILURE;
+
+	if (stNVMReadWrite.uiOffset > Adapter->uiNVMDSDSize - stNVMReadWrite.uiNumBytes) {
+		/* BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"Can't allow access beyond NVM Size: 0x%x 0x%x\n", stNVMReadWrite.uiOffset, stNVMReadWrite.uiNumBytes); */
+		return STATUS_FAILURE;
+	}
+
+	pReadData = memdup_user(stNVMReadWrite.pBuffer,
+				stNVMReadWrite.uiNumBytes);
+	if (IS_ERR(pReadData))
+		return PTR_ERR(pReadData);
+
+	do_gettimeofday(&tv0);
+	if (IOCTL_BCM_NVM_READ == cmd) {
+		down(&Adapter->NVMRdmWrmLock);
+
+		if ((Adapter->IdleMode == TRUE) ||
+			(Adapter->bShutStatus == TRUE) ||
+			(Adapter->bPreparingForLowPowerMode == TRUE)) {
+
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Device is in Idle/Shutdown Mode\n");
+			up(&Adapter->NVMRdmWrmLock);
+			kfree(pReadData);
+			return -EACCES;
+		}
+
+		Status = BeceemNVMRead(Adapter, (PUINT)pReadData, stNVMReadWrite.uiOffset, stNVMReadWrite.uiNumBytes);
+		up(&Adapter->NVMRdmWrmLock);
+
+		if (Status != STATUS_SUCCESS) {
+			kfree(pReadData);
+			return Status;
+		}
+
+		if (copy_to_user(stNVMReadWrite.pBuffer, pReadData, stNVMReadWrite.uiNumBytes)) {
+			kfree(pReadData);
+			return -EFAULT;
+		}
+	} else {
+		down(&Adapter->NVMRdmWrmLock);
+
+		if ((Adapter->IdleMode == TRUE) ||
+			(Adapter->bShutStatus == TRUE) ||
+			(Adapter->bPreparingForLowPowerMode == TRUE)) {
+
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Device is in Idle/Shutdown Mode\n");
+			up(&Adapter->NVMRdmWrmLock);
+			kfree(pReadData);
+			return -EACCES;
+		}
+
+		Adapter->bHeaderChangeAllowed = TRUE;
+		if (IsFlash2x(Adapter)) {
+			/*
+			 *			New Requirement:-
+			 *			DSD section updation will be allowed in two case:-
+			 *			1.  if DSD sig is present in DSD header means dongle is ok and updation is fruitfull
+			 *			2.  if point 1 failes then user buff should have DSD sig. this point ensures that if dongle is
+			 *			      corrupted then user space program first modify the DSD header with valid DSD sig so
+			 *			      that this as well as further write may be worthwhile.
+			 *
+			 *			 This restriction has been put assuming that if DSD sig is corrupted, DSD
+			 *			 data won't be considered valid.
+			 */
+
+			Status = BcmFlash2xCorruptSig(Adapter, Adapter->eActiveDSD);
+			if (Status != STATUS_SUCCESS) {
+				if (((stNVMReadWrite.uiOffset + stNVMReadWrite.uiNumBytes) != Adapter->uiNVMDSDSize) ||
+					(stNVMReadWrite.uiNumBytes < SIGNATURE_SIZE)) {
+
+					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "DSD Sig is present neither in Flash nor User provided Input..");
+					up(&Adapter->NVMRdmWrmLock);
+					kfree(pReadData);
+					return Status;
+				}
+
+				ulDSDMagicNumInUsrBuff = ntohl(*(PUINT)(pReadData + stNVMReadWrite.uiNumBytes - SIGNATURE_SIZE));
+				if (ulDSDMagicNumInUsrBuff != DSD_IMAGE_MAGIC_NUMBER) {
+					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "DSD Sig is present neither in Flash nor User provided Input..");
+					up(&Adapter->NVMRdmWrmLock);
+					kfree(pReadData);
+					return Status;
+				}
+			}
+		}
+
+		Status = BeceemNVMWrite(Adapter, (PUINT)pReadData, stNVMReadWrite.uiOffset, stNVMReadWrite.uiNumBytes, stNVMReadWrite.bVerify);
+		if (IsFlash2x(Adapter))
+			BcmFlash2xWriteSig(Adapter, Adapter->eActiveDSD);
+
+		Adapter->bHeaderChangeAllowed = false;
+
+		up(&Adapter->NVMRdmWrmLock);
+
+		if (Status != STATUS_SUCCESS) {
+			kfree(pReadData);
+			return Status;
+		}
+	}
+
+	do_gettimeofday(&tv1);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, " timetaken by Write/read :%ld msec\n", (tv1.tv_sec - tv0.tv_sec)*1000 + (tv1.tv_usec - tv0.tv_usec)/1000);
+
+	kfree(pReadData);
+	return STATUS_SUCCESS;
+}
+
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -1479,147 +1625,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		return Status;
 
 	case IOCTL_BCM_NVM_READ:
-	case IOCTL_BCM_NVM_WRITE: {
-		struct bcm_nvm_readwrite stNVMReadWrite;
-		PUCHAR pReadData = NULL;
-		ULONG ulDSDMagicNumInUsrBuff = 0;
-		struct timeval tv0, tv1;
-		memset(&tv0, 0, sizeof(struct timeval));
-		memset(&tv1, 0, sizeof(struct timeval));
-		if ((Adapter->eNVMType == NVM_FLASH) && (Adapter->uiFlashLayoutMajorVersion == 0)) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "The Flash Control Section is Corrupted. Hence Rejection on NVM Read/Write\n");
-			return -EFAULT;
-		}
-
-		if (IsFlash2x(Adapter)) {
-			if ((Adapter->eActiveDSD != DSD0) &&
-				(Adapter->eActiveDSD != DSD1) &&
-				(Adapter->eActiveDSD != DSD2)) {
-
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "No DSD is active..hence NVM Command is blocked");
-				return STATUS_FAILURE;
-			}
-		}
-
-		/* Copy Ioctl Buffer structure */
-		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
-			return -EFAULT;
-
-		if (copy_from_user(&stNVMReadWrite,
-					(IOCTL_BCM_NVM_READ == cmd) ? IoBuffer.OutputBuffer : IoBuffer.InputBuffer,
-					sizeof(struct bcm_nvm_readwrite)))
-			return -EFAULT;
-
-		/*
-		 * Deny the access if the offset crosses the cal area limit.
-		 */
-		if (stNVMReadWrite.uiNumBytes > Adapter->uiNVMDSDSize)
-			return STATUS_FAILURE;
-
-		if (stNVMReadWrite.uiOffset > Adapter->uiNVMDSDSize - stNVMReadWrite.uiNumBytes) {
-			/* BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"Can't allow access beyond NVM Size: 0x%x 0x%x\n", stNVMReadWrite.uiOffset, stNVMReadWrite.uiNumBytes); */
-			return STATUS_FAILURE;
-		}
-
-		pReadData = memdup_user(stNVMReadWrite.pBuffer,
-					stNVMReadWrite.uiNumBytes);
-		if (IS_ERR(pReadData))
-			return PTR_ERR(pReadData);
-
-		do_gettimeofday(&tv0);
-		if (IOCTL_BCM_NVM_READ == cmd) {
-			down(&Adapter->NVMRdmWrmLock);
-
-			if ((Adapter->IdleMode == TRUE) ||
-				(Adapter->bShutStatus == TRUE) ||
-				(Adapter->bPreparingForLowPowerMode == TRUE)) {
-
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Device is in Idle/Shutdown Mode\n");
-				up(&Adapter->NVMRdmWrmLock);
-				kfree(pReadData);
-				return -EACCES;
-			}
-
-			Status = BeceemNVMRead(Adapter, (PUINT)pReadData, stNVMReadWrite.uiOffset, stNVMReadWrite.uiNumBytes);
-			up(&Adapter->NVMRdmWrmLock);
-
-			if (Status != STATUS_SUCCESS) {
-				kfree(pReadData);
-				return Status;
-			}
-
-			if (copy_to_user(stNVMReadWrite.pBuffer, pReadData, stNVMReadWrite.uiNumBytes)) {
-				kfree(pReadData);
-				return -EFAULT;
-			}
-		} else {
-			down(&Adapter->NVMRdmWrmLock);
-
-			if ((Adapter->IdleMode == TRUE) ||
-				(Adapter->bShutStatus == TRUE) ||
-				(Adapter->bPreparingForLowPowerMode == TRUE)) {
-
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Device is in Idle/Shutdown Mode\n");
-				up(&Adapter->NVMRdmWrmLock);
-				kfree(pReadData);
-				return -EACCES;
-			}
-
-			Adapter->bHeaderChangeAllowed = TRUE;
-			if (IsFlash2x(Adapter)) {
-				/*
-				 *			New Requirement:-
-				 *			DSD section updation will be allowed in two case:-
-				 *			1.  if DSD sig is present in DSD header means dongle is ok and updation is fruitfull
-				 *			2.  if point 1 failes then user buff should have DSD sig. this point ensures that if dongle is
-				 *			      corrupted then user space program first modify the DSD header with valid DSD sig so
-				 *			      that this as well as further write may be worthwhile.
-				 *
-				 *			 This restriction has been put assuming that if DSD sig is corrupted, DSD
-				 *			 data won't be considered valid.
-				 */
-
-				Status = BcmFlash2xCorruptSig(Adapter, Adapter->eActiveDSD);
-				if (Status != STATUS_SUCCESS) {
-					if (((stNVMReadWrite.uiOffset + stNVMReadWrite.uiNumBytes) != Adapter->uiNVMDSDSize) ||
-						(stNVMReadWrite.uiNumBytes < SIGNATURE_SIZE)) {
-
-						BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "DSD Sig is present neither in Flash nor User provided Input..");
-						up(&Adapter->NVMRdmWrmLock);
-						kfree(pReadData);
-						return Status;
-					}
-
-					ulDSDMagicNumInUsrBuff = ntohl(*(PUINT)(pReadData + stNVMReadWrite.uiNumBytes - SIGNATURE_SIZE));
-					if (ulDSDMagicNumInUsrBuff != DSD_IMAGE_MAGIC_NUMBER) {
-						BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "DSD Sig is present neither in Flash nor User provided Input..");
-						up(&Adapter->NVMRdmWrmLock);
-						kfree(pReadData);
-						return Status;
-					}
-				}
-			}
-
-			Status = BeceemNVMWrite(Adapter, (PUINT)pReadData, stNVMReadWrite.uiOffset, stNVMReadWrite.uiNumBytes, stNVMReadWrite.bVerify);
-			if (IsFlash2x(Adapter))
-				BcmFlash2xWriteSig(Adapter, Adapter->eActiveDSD);
-
-			Adapter->bHeaderChangeAllowed = false;
-
-			up(&Adapter->NVMRdmWrmLock);
-
-			if (Status != STATUS_SUCCESS) {
-				kfree(pReadData);
-				return Status;
-			}
-		}
-
-		do_gettimeofday(&tv1);
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, " timetaken by Write/read :%ld msec\n", (tv1.tv_sec - tv0.tv_sec)*1000 + (tv1.tv_usec - tv0.tv_usec)/1000);
-
-		kfree(pReadData);
-		return STATUS_SUCCESS;
-	}
+	case IOCTL_BCM_NVM_WRITE:
+		Status = bcm_char_ioctl_nvm_rw(argp, Adapter, cmd);
+		return Status;
 
 	case IOCTL_BCM_FLASH2X_SECTION_READ: {
 		struct bcm_flash2x_readwrite sFlash2xRead = {0};
-- 
1.8.5.3

