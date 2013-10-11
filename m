Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab3JKLBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:01:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58545 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859Ab3JKKnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:43:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 044/100] staging: vt6656: [BUG] main_usb.c oops on device_close move flag earlier.
Date: Fri, 11 Oct 2013 11:41:14 +0100
Message-Id: <1381488130-30235-45-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/vt6656/main_usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index fa6dbe0..c829863 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1220,6 +1220,8 @@ device_release_WPADEV(pDevice);
     memset(pMgmt->abyCurrBSSID, 0, 6);
     pMgmt->eCurrState = WMAC_STATE_IDLE;
 
+	pDevice->flags &= ~DEVICE_FLAGS_OPENED;
+
     device_free_tx_bufs(pDevice);
     device_free_rx_bufs(pDevice);
     device_free_int_bufs(pDevice);
@@ -1231,7 +1233,6 @@ device_release_WPADEV(pDevice);
     usb_free_urb(pDevice->pInterruptURB);
 
     BSSvClearNodeDBTable(pDevice, 0);
-    pDevice->flags &=(~DEVICE_FLAGS_OPENED);
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_close2 \n");
 
-- 
1.8.3.2

