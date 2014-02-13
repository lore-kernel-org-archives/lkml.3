Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaBMTqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:46:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbaBMTqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:46:20 -0500
Date: Thu, 13 Feb 2014 14:46:12 -0500
Message-Id: <201402131946.s1DJkCV6022561@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 14/38] staging/bcm: move IOCTL_CHIP_RESET case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 9db4ec9d1983..a03ba2ec02f8 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -961,6 +961,26 @@ static int bcm_char_ioctl_buffer_download_stop(void __user *argp, struct bcm_min
 	return Status;
 }
 
+static int bcm_char_ioctl_chip_reset(struct bcm_mini_adapter *Adapter)
+{
+	INT Status;
+	INT NVMAccess;
+
+	NVMAccess = down_trylock(&Adapter->NVMRdmWrmLock);
+	if (NVMAccess) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, " IOCTL_BCM_CHIP_RESET not allowed as EEPROM Read/Write is in progress\n");
+		return -EACCES;
+	}
+
+	down(&Adapter->RxAppControlQueuelock);
+	Status = reset_card_proc(Adapter);
+	flushAllAppQ();
+	up(&Adapter->RxAppControlQueuelock);
+	up(&Adapter->NVMRdmWrmLock);
+	ResetCounters(Adapter);
+	return Status;
+}
+
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -1083,21 +1103,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 			Status = -EFAULT;
 		break;
 
-	case IOCTL_CHIP_RESET: {
-		INT NVMAccess = down_trylock(&Adapter->NVMRdmWrmLock);
-		if (NVMAccess) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, " IOCTL_BCM_CHIP_RESET not allowed as EEPROM Read/Write is in progress\n");
-			return -EACCES;
-		}
-
-		down(&Adapter->RxAppControlQueuelock);
-		Status = reset_card_proc(Adapter);
-		flushAllAppQ();
-		up(&Adapter->RxAppControlQueuelock);
-		up(&Adapter->NVMRdmWrmLock);
-		ResetCounters(Adapter);
-		break;
-	}
+	case IOCTL_CHIP_RESET:
+		Status = bcm_char_ioctl_chip_reset(Adapter);
+		return Status;
 
 	case IOCTL_QOS_THRESHOLD: {
 		USHORT uiLoopIndex;
-- 
1.8.5.3

