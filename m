Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaBMTsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:48:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbaBMTsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:48:16 -0500
Date: Thu, 13 Feb 2014 14:48:09 -0500
Message-Id: <201402131948.s1DJm9fF023513@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 37/38] staging/bcm: move IOCTL_BCM_GET_DEVICE_DRIVER_INFO case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 51 ++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 2cfdbeeff14a..74360ee45c2b 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -2003,6 +2003,32 @@ static int bcm_char_ioctl_cntrlmsg_mask(void __user *argp, struct bcm_mini_adapt
 	return Status;
 }
 
+static int bcm_char_ioctl_get_device_driver_info(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	struct bcm_driver_info DevInfo;
+	struct bcm_ioctl_buffer IoBuffer;
+
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Called IOCTL_BCM_GET_DEVICE_DRIVER_INFO\n");
+
+	memset(&DevInfo, 0, sizeof(DevInfo));
+	DevInfo.MaxRDMBufferSize = BUFFER_4K;
+	DevInfo.u32DSDStartOffset = EEPROM_CALPARAM_START;
+	DevInfo.u32RxAlignmentCorrection = 0;
+	DevInfo.u32NVMType = Adapter->eNVMType;
+	DevInfo.u32InterfaceType = BCM_USB;
+
+	if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
+		return -EFAULT;
+
+	if (IoBuffer.OutputLength < sizeof(DevInfo))
+		return -EINVAL;
+
+	if (copy_to_user(IoBuffer.OutputBuffer, &DevInfo, sizeof(DevInfo)))
+		return -EFAULT;
+
+	return STATUS_SUCCESS;
+}
+
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -2243,28 +2269,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_cntrlmsg_mask(argp, Adapter, pTarang);
 		return Status;
 
-	case IOCTL_BCM_GET_DEVICE_DRIVER_INFO: {
-		struct bcm_driver_info DevInfo;
-
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Called IOCTL_BCM_GET_DEVICE_DRIVER_INFO\n");
-
-		memset(&DevInfo, 0, sizeof(DevInfo));
-		DevInfo.MaxRDMBufferSize = BUFFER_4K;
-		DevInfo.u32DSDStartOffset = EEPROM_CALPARAM_START;
-		DevInfo.u32RxAlignmentCorrection = 0;
-		DevInfo.u32NVMType = Adapter->eNVMType;
-		DevInfo.u32InterfaceType = BCM_USB;
-
-		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
-			return -EFAULT;
-
-		if (IoBuffer.OutputLength < sizeof(DevInfo))
-			return -EINVAL;
-
-		if (copy_to_user(IoBuffer.OutputBuffer, &DevInfo, sizeof(DevInfo)))
-			return -EFAULT;
-	}
-	break;
+	case IOCTL_BCM_GET_DEVICE_DRIVER_INFO:
+		Status = bcm_char_ioctl_get_device_driver_info(argp, Adapter);
+		return Status;
 
 	case IOCTL_BCM_TIME_SINCE_NET_ENTRY: {
 		struct bcm_time_elapsed stTimeElapsedSinceNetEntry = {0};
-- 
1.8.5.3

