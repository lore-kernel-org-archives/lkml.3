Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab3JJPtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:49:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52928 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390Ab3JJPtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:49:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 066/104] staging: vt6656: [BUG] main_usb.c oops on device_close move flag earlier.
Date: Thu, 10 Oct 2013 08:41:54 -0700
Message-Id: <1381419752-29733-67-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/vt6656/main_usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index f726970..2c3d388 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1112,6 +1112,8 @@ static int  device_close(struct net_device *dev) {
     memset(pMgmt->abyCurrBSSID, 0, 6);
     pMgmt->eCurrState = WMAC_STATE_IDLE;
 
+	pDevice->flags &= ~DEVICE_FLAGS_OPENED;
+
     device_free_tx_bufs(pDevice);
     device_free_rx_bufs(pDevice);
     device_free_int_bufs(pDevice);
@@ -1123,7 +1125,6 @@ static int  device_close(struct net_device *dev) {
     usb_free_urb(pDevice->pInterruptURB);
 
     BSSvClearNodeDBTable(pDevice, 0);
-    pDevice->flags &=(~DEVICE_FLAGS_OPENED);
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_close2 \n");
 
-- 
1.8.1.2

