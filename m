Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaBMTsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:48:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbaBMTsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:48:01 -0500
Date: Thu, 13 Feb 2014 14:47:53 -0500
Message-Id: <201402131947.s1DJlrTa023271@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 34/38] staging/bcm: move IOCTL_BCM_SELECT_DSD case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 93 +++++++++++++++++++++++--------------------
 1 file changed, 50 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 95cad1cfdce3..046e67ff2e35 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1838,6 +1838,53 @@ static int bcm_char_ioctl_get_flash_cs_info(void __user *argp, struct bcm_mini_a
 	return Status;
 }
 
+static int bcm_char_ioctl_select_dsd(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	struct bcm_ioctl_buffer IoBuffer;
+	INT Status = STATUS_FAILURE;
+	UINT SectOfset = 0;
+	enum bcm_flash2x_section_val eFlash2xSectionVal;
+
+	eFlash2xSectionVal = NO_SECTION_VAL;
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_SELECT_DSD Called");
+
+	if (IsFlash2x(Adapter) != TRUE) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Flash Does not have 2.x map");
+		return -EINVAL;
+	}
+
+	Status = copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer));
+	if (Status) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy of IOCTL BUFFER failed");
+		return -EFAULT;
+	}
+	Status = copy_from_user(&eFlash2xSectionVal, IoBuffer.InputBuffer, sizeof(INT));
+	if (Status) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy of flash section val failed");
+		return -EFAULT;
+	}
+
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Read Section :%d", eFlash2xSectionVal);
+	if ((eFlash2xSectionVal != DSD0) &&
+		(eFlash2xSectionVal != DSD1) &&
+		(eFlash2xSectionVal != DSD2)) {
+
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Passed section<%x> is not DSD section", eFlash2xSectionVal);
+		return STATUS_FAILURE;
+	}
+
+	SectOfset = BcmGetSectionValStartOffset(Adapter, eFlash2xSectionVal);
+	if (SectOfset == INVALID_OFFSET) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Provided Section val <%d> does not exist in Flash 2.x", eFlash2xSectionVal);
+		return -EINVAL;
+	}
+
+	Adapter->bAllDSDWriteAllow = TRUE;
+	Adapter->ulFlashCalStart = SectOfset;
+	Adapter->eActiveDSD = eFlash2xSectionVal;
+
+	return STATUS_SUCCESS;
+}
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -2066,49 +2113,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_get_flash_cs_info(argp, Adapter);
 		return Status;
 
-	case IOCTL_BCM_SELECT_DSD: {
-		UINT SectOfset = 0;
-		enum bcm_flash2x_section_val eFlash2xSectionVal;
-		eFlash2xSectionVal = NO_SECTION_VAL;
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_SELECT_DSD Called");
-
-		if (IsFlash2x(Adapter) != TRUE) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Flash Does not have 2.x map");
-			return -EINVAL;
-		}
-
-		Status = copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer));
-		if (Status) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy of IOCTL BUFFER failed");
-			return -EFAULT;
-		}
-		Status = copy_from_user(&eFlash2xSectionVal, IoBuffer.InputBuffer, sizeof(INT));
-		if (Status) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy of flash section val failed");
-			return -EFAULT;
-		}
-
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Read Section :%d", eFlash2xSectionVal);
-		if ((eFlash2xSectionVal != DSD0) &&
-			(eFlash2xSectionVal != DSD1) &&
-			(eFlash2xSectionVal != DSD2)) {
-
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Passed section<%x> is not DSD section", eFlash2xSectionVal);
-			return STATUS_FAILURE;
-		}
-
-		SectOfset = BcmGetSectionValStartOffset(Adapter, eFlash2xSectionVal);
-		if (SectOfset == INVALID_OFFSET) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Provided Section val <%d> does not exist in Flash 2.x", eFlash2xSectionVal);
-			return -EINVAL;
-		}
-
-		Adapter->bAllDSDWriteAllow = TRUE;
-		Adapter->ulFlashCalStart = SectOfset;
-		Adapter->eActiveDSD = eFlash2xSectionVal;
-	}
-	Status = STATUS_SUCCESS;
-	break;
+	case IOCTL_BCM_SELECT_DSD:
+		Status = bcm_char_ioctl_select_dsd(argp, Adapter);
+		return Status;
 
 	case IOCTL_BCM_NVM_RAW_READ: {
 		struct bcm_nvm_readwrite stNVMRead;
-- 
1.8.5.3

