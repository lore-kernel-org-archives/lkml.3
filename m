Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab3JUJM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:12:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39630 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753909Ab3JUIvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:48 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Malcolm Priestley" <tvboxspy@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.330613997@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 086/149] staging: vt6656: [BUG] main_usb.c oops on
 device_close move flag earlier.
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/vt6656/main_usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1221,6 +1221,8 @@ device_release_WPADEV(pDevice);
     memset(pMgmt->abyCurrBSSID, 0, 6);
     pMgmt->eCurrState = WMAC_STATE_IDLE;
 
+	pDevice->flags &= ~DEVICE_FLAGS_OPENED;
+
     device_free_tx_bufs(pDevice);
     device_free_rx_bufs(pDevice);
     device_free_int_bufs(pDevice);
@@ -1232,7 +1234,6 @@ device_release_WPADEV(pDevice);
     usb_free_urb(pDevice->pInterruptURB);
 
     BSSvClearNodeDBTable(pDevice, 0);
-    pDevice->flags &=(~DEVICE_FLAGS_OPENED);
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_close2 \n");
 

