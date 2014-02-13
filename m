Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaBMTrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:47:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbaBMTrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:47:08 -0500
Date: Thu, 13 Feb 2014 14:46:57 -0500
Message-Id: <201402131946.s1DJkvho023020@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 23/38] staging/bcm: move IOCTL_BCM_GET_NVM_SIZE case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index e67e73ae3072..064fc5173dc5 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1197,6 +1197,20 @@ static int bcm_char_ioctl_bulk_wrm(void __user *argp, struct bcm_mini_adapter *A
 	return Status;
 }
 
+static int bcm_char_ioctl_get_nvm_size(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	struct bcm_ioctl_buffer IoBuffer;
+
+	if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
+		return -EFAULT;
+
+	if (Adapter->eNVMType == NVM_EEPROM || Adapter->eNVMType == NVM_FLASH) {
+		if (copy_to_user(IoBuffer.OutputBuffer, &Adapter->uiNVMDSDSize, sizeof(UINT)))
+			return -EFAULT;
+	}
+
+	return STATUS_SUCCESS;
+}
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -1378,16 +1392,8 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		return Status;
 
 	case IOCTL_BCM_GET_NVM_SIZE:
-		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
-			return -EFAULT;
-
-		if (Adapter->eNVMType == NVM_EEPROM || Adapter->eNVMType == NVM_FLASH) {
-			if (copy_to_user(IoBuffer.OutputBuffer, &Adapter->uiNVMDSDSize, sizeof(UINT)))
-				return -EFAULT;
-		}
-
-		Status = STATUS_SUCCESS;
-		break;
+		Status = bcm_char_ioctl_get_nvm_size(argp, Adapter);
+		return Status;
 
 	case IOCTL_BCM_CAL_INIT: {
 		UINT uiSectorSize = 0;
-- 
1.8.5.3

