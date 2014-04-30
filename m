Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042AbaD3RBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 13:01:54 -0400
Received: from mx02.posteo.de ([89.146.194.165]:57758 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752425AbaD3RBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 13:01:53 -0400
From: Martin Kepplinger <martink@posteo.de>
To: gregkh@linuxfoundation.org
Cc: forest@alittletooquiet.net, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] staging: vt6656: make spin_lock_irq() human readable
Date: Wed, 30 Apr 2014 19:01:18 +0200
Message-Id: <1398877278-2280-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't require FIRMWAREbDownload() to, first off, unlock a held lock.
Thus do all locking in main_usb.c and hold it for a insignificantly
shorter period of time. This makes the affected area significantly more
readable though.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
 drivers/staging/vt6656/firmware.c |    2 --
 drivers/staging/vt6656/main_usb.c |    5 ++++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/firmware.c b/drivers/staging/vt6656/firmware.c
index cd2ea76..79129ad 100644
--- a/drivers/staging/vt6656/firmware.c
+++ b/drivers/staging/vt6656/firmware.c
@@ -54,7 +54,6 @@ int FIRMWAREbDownload(struct vnt_private *pDevice)
 	int ii, rc;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Download firmware\n");
-	spin_unlock_irq(&pDevice->lock);
 
 	rc = request_firmware(&fw, FIRMWARE_NAME, dev);
 	if (rc) {
@@ -91,7 +90,6 @@ free_fw:
 out:
 	kfree(pBuffer);
 
-	spin_lock_irq(&pDevice->lock);
 	return result;
 }
 MODULE_FIRMWARE(FIRMWARE_NAME);
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 3c93230..1dc02c4 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -319,7 +319,11 @@ static int device_init_registers(struct vnt_private *pDevice)
 	memcpy(pDevice->abySNAP_Bridgetunnel, abySNAP_Bridgetunnel, ETH_ALEN);
 
 	if (!FIRMWAREbCheckVersion(pDevice)) {
+
+		spin_unlock_irq(&pDevice->lock);
 		if (FIRMWAREbDownload(pDevice) == true) {
+
+			spin_lock_irq(&pDevice->lock);
 			if (FIRMWAREbBrach2Sram(pDevice) == false) {
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 					" FIRMWAREbBrach2Sram fail\n");
@@ -329,7 +333,6 @@ static int device_init_registers(struct vnt_private *pDevice)
 		} else {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 				" FIRMWAREbDownload fail\n");
-			spin_unlock_irq(&pDevice->lock);
 			return false;
 		}
 	}
-- 
1.7.10.4

