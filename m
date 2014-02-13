Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaBMTpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:45:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbaBMTpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:45:30 -0500
Date: Thu, 13 Feb 2014 14:45:21 -0500
Message-Id: <201402131945.s1DJjLdr022501@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 04/38] staging/bcm: move IOCTL_BCM_EEPROM_REGISTER_WRITE case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 126 ++++++++++++++++++++++--------------------
 1 file changed, 67 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index fcb19eaad244..c2219c544811 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -310,6 +310,70 @@ static int bcm_char_ioctl_eeprom_reg_read(void __user *argp, struct bcm_mini_ada
 	return Status;
 }
 
+static int bcm_char_ioctl_eeprom_reg_write(void __user *argp, struct bcm_mini_adapter *Adapter, UINT cmd)
+{
+	struct bcm_wrm_buffer sWrmBuffer = {0};
+	struct bcm_ioctl_buffer IoBuffer;
+	UINT uiTempVar = 0;
+	INT Status;
+
+	if ((Adapter->IdleMode == TRUE) ||
+		(Adapter->bShutStatus == TRUE) ||
+		(Adapter->bPreparingForLowPowerMode == TRUE)) {
+
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+				"Device in Idle Mode, Blocking Wrms\n");
+		return -EACCES;
+	}
+
+	/* Copy Ioctl Buffer structure */
+	if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
+		return -EFAULT;
+
+	if (IoBuffer.InputLength > sizeof(sWrmBuffer))
+		return -EINVAL;
+
+	/* Get WrmBuffer structure */
+	if (copy_from_user(&sWrmBuffer, IoBuffer.InputBuffer, IoBuffer.InputLength))
+		return -EFAULT;
+
+	if ((((ULONG)sWrmBuffer.Register & 0x0F000000) != 0x0F000000) ||
+		((ULONG)sWrmBuffer.Register & 0x3)) {
+
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+				"WRM Done On invalid Address : %x Access Denied.\n",
+				(int)sWrmBuffer.Register);
+		return -EINVAL;
+	}
+
+	uiTempVar = sWrmBuffer.Register & EEPROM_REJECT_MASK;
+	if (!((Adapter->pstargetparams->m_u32Customize) & VSG_MODE) &&
+			((uiTempVar == EEPROM_REJECT_REG_1) ||
+			(uiTempVar == EEPROM_REJECT_REG_2) ||
+			(uiTempVar == EEPROM_REJECT_REG_3) ||
+			(uiTempVar == EEPROM_REJECT_REG_4)) &&
+			(cmd == IOCTL_BCM_REGISTER_WRITE)) {
+
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"EEPROM Access Denied, not in VSG Mode\n");
+			return -EFAULT;
+	}
+
+	Status = wrmaltWithLock(Adapter, (UINT)sWrmBuffer.Register,
+				(PUINT)sWrmBuffer.Data,
+				sWrmBuffer.Length);
+
+	if (Status == STATUS_SUCCESS) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, OSAL_DBG,
+				DBG_LVL_ALL, "WRM Done\n");
+	} else {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "WRM Failed\n");
+		Status = -EFAULT;
+	}
+	return Status;
+}
+
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
 	struct bcm_tarang_data *pTarang = filp->private_data;
@@ -375,66 +439,10 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		return Status;
 
 	case IOCTL_BCM_REGISTER_WRITE:
-	case IOCTL_BCM_EEPROM_REGISTER_WRITE: {
-		struct bcm_wrm_buffer sWrmBuffer = {0};
-		UINT uiTempVar = 0;
-
-		if ((Adapter->IdleMode == TRUE) ||
-			(Adapter->bShutStatus == TRUE) ||
-			(Adapter->bPreparingForLowPowerMode == TRUE)) {
-
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-					"Device in Idle Mode, Blocking Wrms\n");
-			return -EACCES;
-		}
-
-		/* Copy Ioctl Buffer structure */
-		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
-			return -EFAULT;
-
-		if (IoBuffer.InputLength > sizeof(sWrmBuffer))
-			return -EINVAL;
-
-		/* Get WrmBuffer structure */
-		if (copy_from_user(&sWrmBuffer, IoBuffer.InputBuffer, IoBuffer.InputLength))
-			return -EFAULT;
-
-		if ((((ULONG)sWrmBuffer.Register & 0x0F000000) != 0x0F000000) ||
-			((ULONG)sWrmBuffer.Register & 0x3)) {
-
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-					"WRM Done On invalid Address : %x Access Denied.\n",
-					(int)sWrmBuffer.Register);
-			return -EINVAL;
-		}
-
-		uiTempVar = sWrmBuffer.Register & EEPROM_REJECT_MASK;
-		if (!((Adapter->pstargetparams->m_u32Customize) & VSG_MODE) &&
-				((uiTempVar == EEPROM_REJECT_REG_1) ||
-				(uiTempVar == EEPROM_REJECT_REG_2) ||
-				(uiTempVar == EEPROM_REJECT_REG_3) ||
-				(uiTempVar == EEPROM_REJECT_REG_4)) &&
-				(cmd == IOCTL_BCM_REGISTER_WRITE)) {
-
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-						"EEPROM Access Denied, not in VSG Mode\n");
-				return -EFAULT;
-		}
-
-		Status = wrmaltWithLock(Adapter, (UINT)sWrmBuffer.Register,
-					(PUINT)sWrmBuffer.Data,
-					sWrmBuffer.Length);
+	case IOCTL_BCM_EEPROM_REGISTER_WRITE:
+		Status = bcm_char_ioctl_eeprom_reg_write(argp, Adapter, cmd);
+		return Status;
 
-		if (Status == STATUS_SUCCESS) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, OSAL_DBG,
-					DBG_LVL_ALL, "WRM Done\n");
-		} else {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
-					DBG_LVL_ALL, "WRM Failed\n");
-			Status = -EFAULT;
-		}
-		break;
-	}
 	case IOCTL_BCM_GPIO_SET_REQUEST: {
 		UCHAR ucResetValue[4];
 		UINT value = 0;
-- 
1.8.5.3

