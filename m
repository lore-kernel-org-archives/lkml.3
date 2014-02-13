Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaBMTqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:46:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbaBMTqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:46:19 -0500
Date: Thu, 13 Feb 2014 14:46:07 -0500
Message-Id: <201402131946.s1DJk7AJ022555@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 13/38] staging/bcm: move IOCTL_BCM_BUFFER_DOWNLOAD_STOP case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 134 ++++++++++++++++++++++--------------------
 1 file changed, 71 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 2edf85ea6af6..9db4ec9d1983 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -893,6 +893,74 @@ static int bcm_char_ioctl_buffer_download(void __user *argp, struct bcm_mini_ada
 	return Status;
 }
 
+static int bcm_char_ioctl_buffer_download_stop(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	INT Status;
+	int timeout = 0;
+
+	if (!down_trylock(&Adapter->fw_download_sema)) {
+		up(&Adapter->fw_download_sema);
+		return -EINVAL;
+	}
+
+	if (down_trylock(&Adapter->NVMRdmWrmLock)) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+				"FW download blocked as EEPROM Read/Write is in progress\n");
+		up(&Adapter->fw_download_sema);
+		return -EACCES;
+	}
+
+	Adapter->bBinDownloaded = TRUE;
+	Adapter->bCfgDownloaded = TRUE;
+	atomic_set(&Adapter->CurrNumFreeTxDesc, 0);
+	Adapter->CurrNumRecvDescs = 0;
+	Adapter->downloadDDR = 0;
+
+	/* setting the Mips to Run */
+	Status = run_card_proc(Adapter);
+
+	if (Status) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Firm Download Failed\n");
+		up(&Adapter->fw_download_sema);
+		up(&Adapter->NVMRdmWrmLock);
+		return Status;
+	} else {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL, "Firm Download Over...\n");
+	}
+
+	mdelay(10);
+
+	/* Wait for MailBox Interrupt */
+	if (StartInterruptUrb((struct bcm_interface_adapter *)Adapter->pvInterfaceAdapter))
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Unable to send interrupt...\n");
+
+	timeout = 5*HZ;
+	Adapter->waiting_to_fw_download_done = false;
+	wait_event_timeout(Adapter->ioctl_fw_dnld_wait_queue,
+			Adapter->waiting_to_fw_download_done, timeout);
+	Adapter->fw_download_process_pid = INVALID_PID;
+	Adapter->fw_download_done = TRUE;
+	atomic_set(&Adapter->CurrNumFreeTxDesc, 0);
+	Adapter->CurrNumRecvDescs = 0;
+	Adapter->PrevNumRecvDescs = 0;
+	atomic_set(&Adapter->cntrlpktCnt, 0);
+	Adapter->LinkUpStatus = 0;
+	Adapter->LinkStatus = 0;
+
+	if (Adapter->LEDInfo.led_thread_running & BCM_LED_THREAD_RUNNING_ACTIVELY) {
+		Adapter->DriverState = FW_DOWNLOAD_DONE;
+		wake_up(&Adapter->LEDInfo.notify_led_event);
+	}
+
+	if (!timeout)
+		Status = -ENODEV;
+
+	up(&Adapter->fw_download_sema);
+	up(&Adapter->NVMRdmWrmLock);
+	return Status;
+}
+
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -900,7 +968,6 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 	void __user *argp = (void __user *)arg;
 	struct bcm_mini_adapter *Adapter = pTarang->Adapter;
 	INT Status = STATUS_FAILURE;
-	int timeout = 0;
 	struct bcm_ioctl_buffer IoBuffer;
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
@@ -999,69 +1066,10 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_buffer_download(argp, Adapter);
 		return Status;
 
-	case IOCTL_BCM_BUFFER_DOWNLOAD_STOP: {
-		if (!down_trylock(&Adapter->fw_download_sema)) {
-			up(&Adapter->fw_download_sema);
-			return -EINVAL;
-		}
-
-		if (down_trylock(&Adapter->NVMRdmWrmLock)) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-					"FW download blocked as EEPROM Read/Write is in progress\n");
-			up(&Adapter->fw_download_sema);
-			return -EACCES;
-		}
-
-		Adapter->bBinDownloaded = TRUE;
-		Adapter->bCfgDownloaded = TRUE;
-		atomic_set(&Adapter->CurrNumFreeTxDesc, 0);
-		Adapter->CurrNumRecvDescs = 0;
-		Adapter->downloadDDR = 0;
-
-		/* setting the Mips to Run */
-		Status = run_card_proc(Adapter);
-
-		if (Status) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Firm Download Failed\n");
-			up(&Adapter->fw_download_sema);
-			up(&Adapter->NVMRdmWrmLock);
-			return Status;
-		} else {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
-					DBG_LVL_ALL, "Firm Download Over...\n");
-		}
-
-		mdelay(10);
-
-		/* Wait for MailBox Interrupt */
-		if (StartInterruptUrb((struct bcm_interface_adapter *)Adapter->pvInterfaceAdapter))
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Unable to send interrupt...\n");
-
-		timeout = 5*HZ;
-		Adapter->waiting_to_fw_download_done = false;
-		wait_event_timeout(Adapter->ioctl_fw_dnld_wait_queue,
-				Adapter->waiting_to_fw_download_done, timeout);
-		Adapter->fw_download_process_pid = INVALID_PID;
-		Adapter->fw_download_done = TRUE;
-		atomic_set(&Adapter->CurrNumFreeTxDesc, 0);
-		Adapter->CurrNumRecvDescs = 0;
-		Adapter->PrevNumRecvDescs = 0;
-		atomic_set(&Adapter->cntrlpktCnt, 0);
-		Adapter->LinkUpStatus = 0;
-		Adapter->LinkStatus = 0;
-
-		if (Adapter->LEDInfo.led_thread_running & BCM_LED_THREAD_RUNNING_ACTIVELY) {
-			Adapter->DriverState = FW_DOWNLOAD_DONE;
-			wake_up(&Adapter->LEDInfo.notify_led_event);
-		}
-
-		if (!timeout)
-			Status = -ENODEV;
-
-		up(&Adapter->fw_download_sema);
-		up(&Adapter->NVMRdmWrmLock);
+	case IOCTL_BCM_BUFFER_DOWNLOAD_STOP:
+		Status = bcm_char_ioctl_buffer_download_stop(argp, Adapter);
 		return Status;
-	}
+
 
 	case IOCTL_BE_BUCKET_SIZE:
 		Status = 0;
-- 
1.8.5.3

