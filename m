Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760331Ab3B0ADq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:03:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42525 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933554Ab3BZX7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:59:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [ 34/53] staging: vt6656: Fix URB submitted while active warning.
Date: Tue, 26 Feb 2013 15:58:03 -0800
Message-Id: <20130226235623.373418437@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235619.844721947@linuxfoundation.org>
References: <20130226235619.844721947@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/staging/vt6656/usbpipe.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

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


