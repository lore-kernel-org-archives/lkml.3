Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaBMTto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:49:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832AbaBMTr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:47:56 -0500
Date: Thu, 13 Feb 2014 14:47:48 -0500
Message-Id: <201402131947.s1DJlmZW023084@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 33/38] staging/bcm: move IOCTL_BCM_GET_FLASH_CS_INFO case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 68 +++++++++++++++++++++++--------------------
 1 file changed, 37 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 7cf793b2746a..95cad1cfdce3 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1804,6 +1804,40 @@ static int bcm_char_ioctl_copy_section(void __user *argp, struct bcm_mini_adapte
 	return Status;
 }
 
+static int bcm_char_ioctl_get_flash_cs_info(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	struct bcm_ioctl_buffer IoBuffer;
+	INT Status = STATUS_SUCCESS;
+
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, " IOCTL_BCM_GET_FLASH_CS_INFO Called");
+
+	Status = copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer));
+	if (Status) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy of IOCTL BUFFER failed");
+		return -EFAULT;
+	}
+
+	if (Adapter->eNVMType != NVM_FLASH) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Connected device does not have flash");
+		return -EINVAL;
+	}
+
+	if (IsFlash2x(Adapter) == TRUE) {
+		if (IoBuffer.OutputLength < sizeof(struct bcm_flash2x_cs_info))
+			return -EINVAL;
+
+		if (copy_to_user(IoBuffer.OutputBuffer, Adapter->psFlash2xCSInfo, sizeof(struct bcm_flash2x_cs_info)))
+			return -EFAULT;
+	} else {
+		if (IoBuffer.OutputLength < sizeof(struct bcm_flash_cs_info))
+			return -EINVAL;
+
+		if (copy_to_user(IoBuffer.OutputBuffer, Adapter->psFlashCSInfo, sizeof(struct bcm_flash_cs_info)))
+			return -EFAULT;
+	}
+	return Status;
+}
+
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -2028,37 +2062,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_copy_section(argp, Adapter);
 		return Status;
 
-	case IOCTL_BCM_GET_FLASH_CS_INFO: {
-		Status = STATUS_SUCCESS;
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, " IOCTL_BCM_GET_FLASH_CS_INFO Called");
-
-		Status = copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer));
-		if (Status) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy of IOCTL BUFFER failed");
-			return -EFAULT;
-		}
-
-		if (Adapter->eNVMType != NVM_FLASH) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Connected device does not have flash");
-			Status = -EINVAL;
-			break;
-		}
-
-		if (IsFlash2x(Adapter) == TRUE) {
-			if (IoBuffer.OutputLength < sizeof(struct bcm_flash2x_cs_info))
-				return -EINVAL;
-
-			if (copy_to_user(IoBuffer.OutputBuffer, Adapter->psFlash2xCSInfo, sizeof(struct bcm_flash2x_cs_info)))
-				return -EFAULT;
-		} else {
-			if (IoBuffer.OutputLength < sizeof(struct bcm_flash_cs_info))
-				return -EINVAL;
-
-			if (copy_to_user(IoBuffer.OutputBuffer, Adapter->psFlashCSInfo, sizeof(struct bcm_flash_cs_info)))
-				return -EFAULT;
-		}
-	}
-	break;
+	case IOCTL_BCM_GET_FLASH_CS_INFO:
+		Status = bcm_char_ioctl_get_flash_cs_info(argp, Adapter);
+		return Status;
 
 	case IOCTL_BCM_SELECT_DSD: {
 		UINT SectOfset = 0;
-- 
1.8.5.3

