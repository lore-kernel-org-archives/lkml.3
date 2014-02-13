Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaBMTrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:47:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbaBMTrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:47:14 -0500
Date: Thu, 13 Feb 2014 14:47:02 -0500
Message-Id: <201402131947.s1DJl2VT023026@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 24/38] staging/bcm: move IOCTL_BCM_CAL_INIT case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 75 ++++++++++++++++++++++++-------------------
 1 file changed, 42 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 064fc5173dc5..dc0e53493e64 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1212,6 +1212,45 @@ static int bcm_char_ioctl_get_nvm_size(void __user *argp, struct bcm_mini_adapte
 	return STATUS_SUCCESS;
 }
 
+static int bcm_char_ioctl_cal_init(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	struct bcm_ioctl_buffer IoBuffer;
+	UINT uiSectorSize = 0;
+	INT Status = STATUS_FAILURE;
+
+	if (Adapter->eNVMType == NVM_FLASH) {
+		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
+			return -EFAULT;
+
+		if (copy_from_user(&uiSectorSize, IoBuffer.InputBuffer, sizeof(UINT)))
+			return -EFAULT;
+
+		if ((uiSectorSize < MIN_SECTOR_SIZE) || (uiSectorSize > MAX_SECTOR_SIZE)) {
+			if (copy_to_user(IoBuffer.OutputBuffer, &Adapter->uiSectorSize,
+						sizeof(UINT)))
+				return -EFAULT;
+		} else {
+			if (IsFlash2x(Adapter)) {
+				if (copy_to_user(IoBuffer.OutputBuffer,	&Adapter->uiSectorSize, sizeof(UINT)))
+					return -EFAULT;
+			} else {
+				if ((TRUE == Adapter->bShutStatus) || (TRUE == Adapter->IdleMode)) {
+					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Device is in Idle/Shutdown Mode\n");
+					return -EACCES;
+				}
+
+				Adapter->uiSectorSize = uiSectorSize;
+				BcmUpdateSectorSize(Adapter, Adapter->uiSectorSize);
+			}
+		}
+		Status = STATUS_SUCCESS;
+	} else {
+		Status = STATUS_FAILURE;
+	}
+	return Status;
+}
+
+
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
 	struct bcm_tarang_data *pTarang = filp->private_data;
@@ -1395,39 +1434,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_get_nvm_size(argp, Adapter);
 		return Status;
 
-	case IOCTL_BCM_CAL_INIT: {
-		UINT uiSectorSize = 0;
-		if (Adapter->eNVMType == NVM_FLASH) {
-			if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
-				return -EFAULT;
-
-			if (copy_from_user(&uiSectorSize, IoBuffer.InputBuffer, sizeof(UINT)))
-				return -EFAULT;
-
-			if ((uiSectorSize < MIN_SECTOR_SIZE) || (uiSectorSize > MAX_SECTOR_SIZE)) {
-				if (copy_to_user(IoBuffer.OutputBuffer, &Adapter->uiSectorSize,
-							sizeof(UINT)))
-					return -EFAULT;
-			} else {
-				if (IsFlash2x(Adapter)) {
-					if (copy_to_user(IoBuffer.OutputBuffer,	&Adapter->uiSectorSize, sizeof(UINT)))
-						return -EFAULT;
-				} else {
-					if ((TRUE == Adapter->bShutStatus) || (TRUE == Adapter->IdleMode)) {
-						BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Device is in Idle/Shutdown Mode\n");
-						return -EACCES;
-					}
-
-					Adapter->uiSectorSize = uiSectorSize;
-					BcmUpdateSectorSize(Adapter, Adapter->uiSectorSize);
-				}
-			}
-			Status = STATUS_SUCCESS;
-		} else {
-			Status = STATUS_FAILURE;
-		}
-	}
-	break;
+	case IOCTL_BCM_CAL_INIT:
+		Status = bcm_char_ioctl_cal_init(argp, Adapter);
+		return Status;
 
 	case IOCTL_BCM_SET_DEBUG:
 #ifdef DEBUG
-- 
1.8.5.3

