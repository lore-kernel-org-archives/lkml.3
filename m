Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaBMTrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:47:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbaBMTrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:47:00 -0500
Date: Thu, 13 Feb 2014 14:46:52 -0500
Message-Id: <201402131946.s1DJkqP4023011@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 22/38] staging/bcm: move IOCTL_BCM_BULK_WRM case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 126 ++++++++++++++++++++++--------------------
 1 file changed, 65 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index fb252c25f5ef..e67e73ae3072 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1135,6 +1135,68 @@ static int bcm_char_ioctl_get_host_mibs(void __user *argp, struct bcm_mini_adapt
 	return Status;
 }
 
+static int bcm_char_ioctl_bulk_wrm(void __user *argp, struct bcm_mini_adapter *Adapter, UINT cmd)
+{
+	struct bcm_bulk_wrm_buffer *pBulkBuffer;
+	struct bcm_ioctl_buffer IoBuffer;
+	UINT uiTempVar = 0;
+	INT Status = STATUS_FAILURE;
+	PCHAR pvBuffer = NULL;
+
+	if ((Adapter->IdleMode == TRUE) ||
+		(Adapter->bShutStatus == TRUE) ||
+		(Adapter->bPreparingForLowPowerMode == TRUE)) {
+
+		BCM_DEBUG_PRINT (Adapter, DBG_TYPE_PRINTK, 0, 0, "Device in Idle/Shutdown Mode, Blocking Wrms\n");
+		return -EACCES;
+	}
+
+	/* Copy Ioctl Buffer structure */
+	if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
+		return -EFAULT;
+
+	if (IoBuffer.InputLength < sizeof(ULONG) * 2)
+		return -EINVAL;
+
+	pvBuffer = memdup_user(IoBuffer.InputBuffer,
+			       IoBuffer.InputLength);
+	if (IS_ERR(pvBuffer))
+		return PTR_ERR(pvBuffer);
+
+	pBulkBuffer = (struct bcm_bulk_wrm_buffer *)pvBuffer;
+
+	if (((ULONG)pBulkBuffer->Register & 0x0F000000) != 0x0F000000 ||
+		((ULONG)pBulkBuffer->Register & 0x3)) {
+		BCM_DEBUG_PRINT (Adapter, DBG_TYPE_PRINTK, 0, 0, "WRM Done On invalid Address : %x Access Denied.\n", (int)pBulkBuffer->Register);
+		kfree(pvBuffer);
+		return -EINVAL;
+	}
+
+	uiTempVar = pBulkBuffer->Register & EEPROM_REJECT_MASK;
+	if (!((Adapter->pstargetparams->m_u32Customize)&VSG_MODE) &&
+		((uiTempVar == EEPROM_REJECT_REG_1) ||
+			(uiTempVar == EEPROM_REJECT_REG_2) ||
+			(uiTempVar == EEPROM_REJECT_REG_3) ||
+			(uiTempVar == EEPROM_REJECT_REG_4)) &&
+		(cmd == IOCTL_BCM_REGISTER_WRITE)) {
+
+		kfree(pvBuffer);
+		BCM_DEBUG_PRINT (Adapter, DBG_TYPE_PRINTK, 0, 0, "EEPROM Access Denied, not in VSG Mode\n");
+		return -EFAULT;
+	}
+
+	if (pBulkBuffer->SwapEndian == false)
+		Status = wrmWithLock(Adapter, (UINT)pBulkBuffer->Register, (PCHAR)pBulkBuffer->Values, IoBuffer.InputLength - 2*sizeof(ULONG));
+	else
+		Status = wrmaltWithLock(Adapter, (UINT)pBulkBuffer->Register, (PUINT)pBulkBuffer->Values, IoBuffer.InputLength - 2*sizeof(ULONG));
+
+	if (Status != STATUS_SUCCESS)
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "WRM Failed\n");
+
+	kfree(pvBuffer);
+	return Status;
+}
+
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -1311,67 +1373,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = STATUS_SUCCESS;
 		break;
 
-	case IOCTL_BCM_BULK_WRM: {
-		struct bcm_bulk_wrm_buffer *pBulkBuffer;
-		UINT uiTempVar = 0;
-		PCHAR pvBuffer = NULL;
-
-		if ((Adapter->IdleMode == TRUE) ||
-			(Adapter->bShutStatus == TRUE) ||
-			(Adapter->bPreparingForLowPowerMode == TRUE)) {
-
-			BCM_DEBUG_PRINT (Adapter, DBG_TYPE_PRINTK, 0, 0, "Device in Idle/Shutdown Mode, Blocking Wrms\n");
-			Status = -EACCES;
-			break;
-		}
-
-		/* Copy Ioctl Buffer structure */
-		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
-			return -EFAULT;
-
-		if (IoBuffer.InputLength < sizeof(ULONG) * 2)
-			return -EINVAL;
-
-		pvBuffer = memdup_user(IoBuffer.InputBuffer,
-				       IoBuffer.InputLength);
-		if (IS_ERR(pvBuffer))
-			return PTR_ERR(pvBuffer);
-
-		pBulkBuffer = (struct bcm_bulk_wrm_buffer *)pvBuffer;
-
-		if (((ULONG)pBulkBuffer->Register & 0x0F000000) != 0x0F000000 ||
-			((ULONG)pBulkBuffer->Register & 0x3)) {
-			BCM_DEBUG_PRINT (Adapter, DBG_TYPE_PRINTK, 0, 0, "WRM Done On invalid Address : %x Access Denied.\n", (int)pBulkBuffer->Register);
-			kfree(pvBuffer);
-			Status = -EINVAL;
-			break;
-		}
-
-		uiTempVar = pBulkBuffer->Register & EEPROM_REJECT_MASK;
-		if (!((Adapter->pstargetparams->m_u32Customize)&VSG_MODE) &&
-			((uiTempVar == EEPROM_REJECT_REG_1) ||
-				(uiTempVar == EEPROM_REJECT_REG_2) ||
-				(uiTempVar == EEPROM_REJECT_REG_3) ||
-				(uiTempVar == EEPROM_REJECT_REG_4)) &&
-			(cmd == IOCTL_BCM_REGISTER_WRITE)) {
-
-			kfree(pvBuffer);
-			BCM_DEBUG_PRINT (Adapter, DBG_TYPE_PRINTK, 0, 0, "EEPROM Access Denied, not in VSG Mode\n");
-			Status = -EFAULT;
-			break;
-		}
-
-		if (pBulkBuffer->SwapEndian == false)
-			Status = wrmWithLock(Adapter, (UINT)pBulkBuffer->Register, (PCHAR)pBulkBuffer->Values, IoBuffer.InputLength - 2*sizeof(ULONG));
-		else
-			Status = wrmaltWithLock(Adapter, (UINT)pBulkBuffer->Register, (PUINT)pBulkBuffer->Values, IoBuffer.InputLength - 2*sizeof(ULONG));
-
-		if (Status != STATUS_SUCCESS)
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "WRM Failed\n");
-
-		kfree(pvBuffer);
-		break;
-	}
+	case IOCTL_BCM_BULK_WRM:
+		Status = bcm_char_ioctl_bulk_wrm(argp, Adapter, cmd);
+		return Status;
 
 	case IOCTL_BCM_GET_NVM_SIZE:
 		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
-- 
1.8.5.3

