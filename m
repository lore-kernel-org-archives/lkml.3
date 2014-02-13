Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaBMTp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:45:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbaBMTpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:45:25 -0500
Date: Thu, 13 Feb 2014 14:45:11 -0500
Message-Id: <201402131945.s1DJjBGG022489@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 02/38] staging/bcm: move IOCTL_BCM_REGISTER_WRITE_PRIVATE case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 89 ++++++++++++++++++++++++-------------------
 1 file changed, 49 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 0e63929b7b11..8779ed6b3099 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -199,6 +199,52 @@ static int bcm_char_ioctl_reg_read_private(void __user *argp, struct bcm_mini_ad
 	return Status;
 }
 
+static int bcm_char_ioctl_reg_write_private(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	struct bcm_wrm_buffer sWrmBuffer = {0};
+	struct bcm_ioctl_buffer IoBuffer;
+	UINT uiTempVar = 0;
+	INT Status;
+
+	/* Copy Ioctl Buffer structure */
+
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
+	uiTempVar = sWrmBuffer.Register & EEPROM_REJECT_MASK;
+	if (!((Adapter->pstargetparams->m_u32Customize) & VSG_MODE) &&
+		((uiTempVar == EEPROM_REJECT_REG_1) ||
+			(uiTempVar == EEPROM_REJECT_REG_2) ||
+			(uiTempVar == EEPROM_REJECT_REG_3) ||
+			(uiTempVar == EEPROM_REJECT_REG_4))) {
+
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+				"EEPROM Access Denied, not in VSG Mode\n");
+		return -EFAULT;
+	}
+
+	Status = wrmalt(Adapter, (UINT)sWrmBuffer.Register,
+			(PUINT)sWrmBuffer.Data, sizeof(ULONG));
+
+	if (Status == STATUS_SUCCESS) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "WRM Done\n");
+	} else {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "WRM Failed\n");
+		Status = -EFAULT;
+	}
+	return Status;
+}
+
+
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
 	struct bcm_tarang_data *pTarang = filp->private_data;
@@ -254,46 +300,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_reg_read_private(argp, Adapter);
 		return Status;
 
-	case IOCTL_BCM_REGISTER_WRITE_PRIVATE: {
-		struct bcm_wrm_buffer sWrmBuffer = {0};
-		UINT uiTempVar = 0;
-		/* Copy Ioctl Buffer structure */
-
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
-		uiTempVar = sWrmBuffer.Register & EEPROM_REJECT_MASK;
-		if (!((Adapter->pstargetparams->m_u32Customize) & VSG_MODE) &&
-			((uiTempVar == EEPROM_REJECT_REG_1) ||
-				(uiTempVar == EEPROM_REJECT_REG_2) ||
-				(uiTempVar == EEPROM_REJECT_REG_3) ||
-				(uiTempVar == EEPROM_REJECT_REG_4))) {
-
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-					"EEPROM Access Denied, not in VSG Mode\n");
-			return -EFAULT;
-		}
-
-		Status = wrmalt(Adapter, (UINT)sWrmBuffer.Register,
-				(PUINT)sWrmBuffer.Data, sizeof(ULONG));
-
-		if (Status == STATUS_SUCCESS) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
-					DBG_LVL_ALL, "WRM Done\n");
-		} else {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
-					DBG_LVL_ALL, "WRM Failed\n");
-			Status = -EFAULT;
-		}
-		break;
-	}
+	case IOCTL_BCM_REGISTER_WRITE_PRIVATE:
+		Status = bcm_char_ioctl_reg_write_private(argp, Adapter);
+		return Status;
 
 	case IOCTL_BCM_REGISTER_READ:
 	case IOCTL_BCM_EEPROM_REGISTER_READ: {
-- 
1.8.5.3

