Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163Ab3B1Owx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:52:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42579 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933206Ab3B1Ov1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:51:27 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 135/139] staging: vt6656: Fix URB submitted while active warning.
Date: Thu, 28 Feb 2013 14:44:45 +0000
Message-Id: <1362062689-2567-136-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit ae5943de8c8c4438cbac5cda599ff0b88c224468 upstream.

This error happens because PIPEnsControlOut and PIPEnsControlIn unlock the
spin lock for delay, letting in another thread.

The patch moves the current MP_SET_FLAG to before filling
of sUsbCtlRequest for pControlURB and clears it in event of failing.

Any thread calling either function while fMP_CONTROL_READS or fMP_CONTROL_WRITES
flags set will return STATUS_FAILURE.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/vt6656/usbpipe.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index c612ab5..f759352 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -168,6 +168,11 @@ int PIPEnsControlOut(
     if (pDevice->Flags & fMP_CONTROL_WRITES)
         return STATUS_FAILURE;
 
+	if (pDevice->Flags & fMP_CONTROL_READS)
+		return STATUS_FAILURE;
+
+	MP_SET_FLAG(pDevice, fMP_CONTROL_WRITES);
+
 	pDevice->sUsbCtlRequest.bRequestType = 0x40;
 	pDevice->sUsbCtlRequest.bRequest = byRequest;
 	pDevice->sUsbCtlRequest.wValue = cpu_to_le16p(&wValue);
@@ -182,12 +187,13 @@ int PIPEnsControlOut(
 
 	ntStatus = usb_submit_urb(pDevice->pControlURB, GFP_ATOMIC);
 	if (ntStatus != 0) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"control send request submission failed: %d\n", ntStatus);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"control send request submission failed: %d\n",
+				ntStatus);
+		MP_CLEAR_FLAG(pDevice, fMP_CONTROL_WRITES);
 		return STATUS_FAILURE;
 	}
-	else {
-	    MP_SET_FLAG(pDevice, fMP_CONTROL_WRITES);
-	}
+
 	spin_unlock_irq(&pDevice->lock);
     for (ii = 0; ii <= USB_CTL_WAIT; ii ++) {
 
@@ -227,6 +233,11 @@ int PIPEnsControlIn(
     if (pDevice->Flags & fMP_CONTROL_READS)
 	return STATUS_FAILURE;
 
+	if (pDevice->Flags & fMP_CONTROL_WRITES)
+		return STATUS_FAILURE;
+
+	MP_SET_FLAG(pDevice, fMP_CONTROL_READS);
+
 	pDevice->sUsbCtlRequest.bRequestType = 0xC0;
 	pDevice->sUsbCtlRequest.bRequest = byRequest;
 	pDevice->sUsbCtlRequest.wValue = cpu_to_le16p(&wValue);
@@ -240,10 +251,11 @@ int PIPEnsControlIn(
 
 	ntStatus = usb_submit_urb(pDevice->pControlURB, GFP_ATOMIC);
 	if (ntStatus != 0) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"control request submission failed: %d\n", ntStatus);
-	}else {
-		MP_SET_FLAG(pDevice, fMP_CONTROL_READS);
-    }
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"control request submission failed: %d\n", ntStatus);
+		MP_CLEAR_FLAG(pDevice, fMP_CONTROL_READS);
+		return STATUS_FAILURE;
+	}
 
 	spin_unlock_irq(&pDevice->lock);
     for (ii = 0; ii <= USB_CTL_WAIT; ii ++) {
-- 
1.8.1.2

