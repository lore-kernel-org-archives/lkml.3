Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab3JCESj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:18:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47153 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949Ab3JCESh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:18:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [ 24/57] staging: vt6656: [BUG] main_usb.c oops on device_close move flag earlier.
Date: Wed,  2 Oct 2013 21:08:50 -0700
Message-Id: <20131003040638.262456251@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit e3eb270fab7734427dd8171a93e4946fe28674bc upstream.

The vt6656 is prone to resetting on the usb bus.

It seems there is a race condition and wpa supplicant is
trying to open the device via iw_handlers before its actually
closed at a stage that the buffers are being removed.

The device is longer considered open when the
buffers are being removed. So move ~DEVICE_FLAGS_OPENED
flag to before freeing the device buffers.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/main_usb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1099,6 +1099,8 @@ static int device_close(struct net_devic
     memset(pMgmt->abyCurrBSSID, 0, 6);
     pMgmt->eCurrState = WMAC_STATE_IDLE;
 
+	pDevice->flags &= ~DEVICE_FLAGS_OPENED;
+
     device_free_tx_bufs(pDevice);
     device_free_rx_bufs(pDevice);
     device_free_int_bufs(pDevice);
@@ -1110,7 +1112,6 @@ static int device_close(struct net_devic
     usb_free_urb(pDevice->pInterruptURB);
 
     BSSvClearNodeDBTable(pDevice, 0);
-    pDevice->flags &=(~DEVICE_FLAGS_OPENED);
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_close2 \n");
 


