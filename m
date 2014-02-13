Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaBMTsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:48:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbaBMTsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:48:12 -0500
Date: Thu, 13 Feb 2014 14:48:04 -0500
Message-Id: <201402131948.s1DJm4fS023507@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 36/38] staging/bcm: move IOCTL_BCM_CNTRLMSG_MASK case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 54 ++++++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 0dc1c88c4576..2cfdbeeff14a 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1976,6 +1976,33 @@ static int bcm_char_ioctl_nvm_raw_read(void __user *argp, struct bcm_mini_adapte
 	return Status;
 }
 
+static int bcm_char_ioctl_cntrlmsg_mask(void __user *argp, struct bcm_mini_adapter *Adapter, struct bcm_tarang_data *pTarang)
+{
+	struct bcm_ioctl_buffer IoBuffer;
+	INT Status = STATUS_FAILURE;
+	ULONG RxCntrlMsgBitMask = 0;
+
+	/* Copy Ioctl Buffer structure */
+	Status = copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer));
+	if (Status) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "copy of Ioctl buffer is failed from user space");
+		return -EFAULT;
+	}
+
+	if (IoBuffer.InputLength != sizeof(unsigned long))
+		return -EINVAL;
+
+	Status = copy_from_user(&RxCntrlMsgBitMask, IoBuffer.InputBuffer, IoBuffer.InputLength);
+	if (Status) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "copy of control bit mask failed from user space");
+		return -EFAULT;
+	}
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\n Got user defined cntrl msg bit mask :%lx", RxCntrlMsgBitMask);
+	pTarang->RxCntrlMsgBitMask = RxCntrlMsgBitMask;
+
+	return Status;
+}
+
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -2212,30 +2239,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_nvm_raw_read(argp, Adapter);
 		return Status;
 
-	case IOCTL_BCM_CNTRLMSG_MASK: {
-		ULONG RxCntrlMsgBitMask = 0;
-
-		/* Copy Ioctl Buffer structure */
-		Status = copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer));
-		if (Status) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "copy of Ioctl buffer is failed from user space");
-			return -EFAULT;
-		}
-
-		if (IoBuffer.InputLength != sizeof(unsigned long)) {
-			Status = -EINVAL;
-			break;
-		}
-
-		Status = copy_from_user(&RxCntrlMsgBitMask, IoBuffer.InputBuffer, IoBuffer.InputLength);
-		if (Status) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "copy of control bit mask failed from user space");
-			return -EFAULT;
-		}
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\n Got user defined cntrl msg bit mask :%lx", RxCntrlMsgBitMask);
-		pTarang->RxCntrlMsgBitMask = RxCntrlMsgBitMask;
-	}
-	break;
+	case IOCTL_BCM_CNTRLMSG_MASK:
+		Status = bcm_char_ioctl_cntrlmsg_mask(argp, Adapter, pTarang);
+		return Status;
 
 	case IOCTL_BCM_GET_DEVICE_DRIVER_INFO: {
 		struct bcm_driver_info DevInfo;
-- 
1.8.5.3

