Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaBMTzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:55:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbaBMTqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:46:12 -0500
Date: Thu, 13 Feb 2014 14:46:02 -0500
Message-Id: <201402131946.s1DJk2Kj022549@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 12/38] staging/bcm: move IOCTL_BCM_BUFFER_DOWNLOAD case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 151 ++++++++++++++++++++++--------------------
 1 file changed, 79 insertions(+), 72 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 9b4284078255..2edf85ea6af6 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -816,6 +816,83 @@ static int bcm_char_ioctl_buffer_download_start(struct bcm_mini_adapter *Adapter
 	return Status;
 }
 
+static int bcm_char_ioctl_buffer_download(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	struct bcm_firmware_info *psFwInfo = NULL;
+	struct bcm_ioctl_buffer IoBuffer;
+	INT Status;
+
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Starting the firmware download PID =0x%x!!!!\n", current->pid);
+
+	if (!down_trylock(&Adapter->fw_download_sema)) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+				"Invalid way to download buffer. Use Start and then call this!!!\n");
+		up(&Adapter->fw_download_sema);
+		return -EINVAL;
+	}
+
+	/* Copy Ioctl Buffer structure */
+	if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer))) {
+		up(&Adapter->fw_download_sema);
+		return -EFAULT;
+	}
+
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+			"Length for FW DLD is : %lx\n", IoBuffer.InputLength);
+
+	if (IoBuffer.InputLength > sizeof(struct bcm_firmware_info)) {
+		up(&Adapter->fw_download_sema);
+		return -EINVAL;
+	}
+
+	psFwInfo = kmalloc(sizeof(*psFwInfo), GFP_KERNEL);
+	if (!psFwInfo) {
+		up(&Adapter->fw_download_sema);
+		return -ENOMEM;
+	}
+
+	if (copy_from_user(psFwInfo, IoBuffer.InputBuffer, IoBuffer.InputLength)) {
+		up(&Adapter->fw_download_sema);
+		kfree(psFwInfo);
+		return -EFAULT;
+	}
+
+	if (!psFwInfo->pvMappedFirmwareAddress ||
+		(psFwInfo->u32FirmwareLength == 0)) {
+
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Something else is wrong %lu\n",
+				psFwInfo->u32FirmwareLength);
+		up(&Adapter->fw_download_sema);
+		kfree(psFwInfo);
+		Status = -EINVAL;
+		return Status;
+	}
+
+	Status = bcm_ioctl_fw_download(Adapter, psFwInfo);
+
+	if (Status != STATUS_SUCCESS) {
+		if (psFwInfo->u32StartingAddress == CONFIG_BEGIN_ADDR)
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "IOCTL: Configuration File Upload Failed\n");
+		else
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,	"IOCTL: Firmware File Upload Failed\n");
+
+		/* up(&Adapter->fw_download_sema); */
+
+		if (Adapter->LEDInfo.led_thread_running & BCM_LED_THREAD_RUNNING_ACTIVELY) {
+			Adapter->DriverState = DRIVER_INIT;
+			Adapter->LEDInfo.bLedInitDone = false;
+			wake_up(&Adapter->LEDInfo.notify_led_event);
+		}
+	}
+
+	if (Status != STATUS_SUCCESS)
+		up(&Adapter->fw_download_sema);
+
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, OSAL_DBG, DBG_LVL_ALL, "IOCTL: Firmware File Uploaded\n");
+	kfree(psFwInfo);
+	return Status;
+}
+
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -918,79 +995,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_buffer_download_start(Adapter);
 		return Status;
 
-	case IOCTL_BCM_BUFFER_DOWNLOAD: {
-		struct bcm_firmware_info *psFwInfo = NULL;
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Starting the firmware download PID =0x%x!!!!\n", current->pid);
-
-		if (!down_trylock(&Adapter->fw_download_sema)) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-					"Invalid way to download buffer. Use Start and then call this!!!\n");
-			up(&Adapter->fw_download_sema);
-			Status = -EINVAL;
-			return Status;
-		}
-
-		/* Copy Ioctl Buffer structure */
-		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer))) {
-			up(&Adapter->fw_download_sema);
-			return -EFAULT;
-		}
-
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-				"Length for FW DLD is : %lx\n", IoBuffer.InputLength);
-
-		if (IoBuffer.InputLength > sizeof(struct bcm_firmware_info)) {
-			up(&Adapter->fw_download_sema);
-			return -EINVAL;
-		}
-
-		psFwInfo = kmalloc(sizeof(*psFwInfo), GFP_KERNEL);
-		if (!psFwInfo) {
-			up(&Adapter->fw_download_sema);
-			return -ENOMEM;
-		}
-
-		if (copy_from_user(psFwInfo, IoBuffer.InputBuffer, IoBuffer.InputLength)) {
-			up(&Adapter->fw_download_sema);
-			kfree(psFwInfo);
-			return -EFAULT;
-		}
-
-		if (!psFwInfo->pvMappedFirmwareAddress ||
-			(psFwInfo->u32FirmwareLength == 0)) {
-
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Something else is wrong %lu\n",
-					psFwInfo->u32FirmwareLength);
-			up(&Adapter->fw_download_sema);
-			kfree(psFwInfo);
-			Status = -EINVAL;
-			return Status;
-		}
-
-		Status = bcm_ioctl_fw_download(Adapter, psFwInfo);
-
-		if (Status != STATUS_SUCCESS) {
-			if (psFwInfo->u32StartingAddress == CONFIG_BEGIN_ADDR)
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "IOCTL: Configuration File Upload Failed\n");
-			else
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,	"IOCTL: Firmware File Upload Failed\n");
-
-			/* up(&Adapter->fw_download_sema); */
-
-			if (Adapter->LEDInfo.led_thread_running & BCM_LED_THREAD_RUNNING_ACTIVELY) {
-				Adapter->DriverState = DRIVER_INIT;
-				Adapter->LEDInfo.bLedInitDone = false;
-				wake_up(&Adapter->LEDInfo.notify_led_event);
-			}
-		}
-
-		if (Status != STATUS_SUCCESS)
-			up(&Adapter->fw_download_sema);
-
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, OSAL_DBG, DBG_LVL_ALL, "IOCTL: Firmware File Uploaded\n");
-		kfree(psFwInfo);
+	case IOCTL_BCM_BUFFER_DOWNLOAD:
+		Status = bcm_char_ioctl_buffer_download(argp, Adapter);
 		return Status;
-	}
 
 	case IOCTL_BCM_BUFFER_DOWNLOAD_STOP: {
 		if (!down_trylock(&Adapter->fw_download_sema)) {
-- 
1.8.5.3

