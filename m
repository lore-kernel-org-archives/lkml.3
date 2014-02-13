Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaBMTqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:46:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbaBMTqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:46:09 -0500
Date: Thu, 13 Feb 2014 14:45:57 -0500
Message-Id: <201402131945.s1DJjvV8022543@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 11/38] staging/bcm: move IOCTL_BCM_BUFFER_DOWNLOAD_START case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 67 ++++++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 9b9bc5b09693..9b4284078255 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -781,6 +781,41 @@ cntrlEnd:
 	return Status;
 }
 
+static int bcm_char_ioctl_buffer_download_start(struct bcm_mini_adapter *Adapter)
+{
+	INT Status;
+
+	if (down_trylock(&Adapter->NVMRdmWrmLock)) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
+				"IOCTL_BCM_CHIP_RESET not allowed as EEPROM Read/Write is in progress\n");
+		return -EACCES;
+	}
+
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+			"Starting the firmware download PID =0x%x!!!!\n", current->pid);
+
+	if (down_trylock(&Adapter->fw_download_sema))
+		return -EBUSY;
+
+	Adapter->bBinDownloaded = false;
+	Adapter->fw_download_process_pid = current->pid;
+	Adapter->bCfgDownloaded = false;
+	Adapter->fw_download_done = false;
+	netif_carrier_off(Adapter->dev);
+	netif_stop_queue(Adapter->dev);
+	Status = reset_card_proc(Adapter);
+	if (Status) {
+		pr_err(PFX "%s: reset_card_proc Failed!\n", Adapter->dev->name);
+		up(&Adapter->fw_download_sema);
+		up(&Adapter->NVMRdmWrmLock);
+		return Status;
+	}
+	mdelay(10);
+
+	up(&Adapter->NVMRdmWrmLock);
+	return Status;
+}
+
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -879,37 +914,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_misc_request(argp, Adapter);
 		return Status;
 
-	case IOCTL_BCM_BUFFER_DOWNLOAD_START: {
-		if (down_trylock(&Adapter->NVMRdmWrmLock)) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
-					"IOCTL_BCM_CHIP_RESET not allowed as EEPROM Read/Write is in progress\n");
-			return -EACCES;
-		}
-
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-				"Starting the firmware download PID =0x%x!!!!\n", current->pid);
-
-		if (down_trylock(&Adapter->fw_download_sema))
-			return -EBUSY;
-
-		Adapter->bBinDownloaded = false;
-		Adapter->fw_download_process_pid = current->pid;
-		Adapter->bCfgDownloaded = false;
-		Adapter->fw_download_done = false;
-		netif_carrier_off(Adapter->dev);
-		netif_stop_queue(Adapter->dev);
-		Status = reset_card_proc(Adapter);
-		if (Status) {
-			pr_err(PFX "%s: reset_card_proc Failed!\n", Adapter->dev->name);
-			up(&Adapter->fw_download_sema);
-			up(&Adapter->NVMRdmWrmLock);
-			return Status;
-		}
-		mdelay(10);
-
-		up(&Adapter->NVMRdmWrmLock);
+	case IOCTL_BCM_BUFFER_DOWNLOAD_START:
+		Status = bcm_char_ioctl_buffer_download_start(Adapter);
 		return Status;
-	}
 
 	case IOCTL_BCM_BUFFER_DOWNLOAD: {
 		struct bcm_firmware_info *psFwInfo = NULL;
-- 
1.8.5.3

