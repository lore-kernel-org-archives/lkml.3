Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139Ab3IFHFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 03:05:21 -0400
Received: from mail.peak-system.com ([213.157.13.214]:52093 "EHLO
	mail.peak-system.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab3IFHFR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 03:05:17 -0400
From: Stephane Grosjean <s.grosjean@peak-system.com>
Date: Fri, 6 Sep 2013 08:52:59 +0200
X-Mailer: Axigen WebMail
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Message-ID: <1378450379823688500@peak-system.com>
Subject: [PATCH] can: pcan_usb_core: fix memory leak on failure paths in
 peak_usb_start()
Importance: Normal
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
X-AxigenSpam-Level: 1
X-CTCH-RefID: str=0001.0A0C0204.52297BD5.0016,ss=1,fgs=0
X-CTCH-VOD: Unknown
X-CTCH-Spam: Unknown
X-AXIGEN-KAS-Info: Not spam
X-AXIGEN-KAS-Info: Version: 4.4.2 (May 20 2011 12:01:19)
X-AXIGEN-KAS-Info: Envelope from: 
X-AXIGEN-KAS-Info: Rate: 0
X-AXIGEN-KAS-Info: Status: not_detected
X-AXIGEN-KAS-Info: Method: none
X-AXIGEN-KAS-Info: DBG v.5. 3296, 2164. R:128,128,128,6,128,128,1,128,0.
 M:12,24,95,145,161,193,194,210, CF:1,2118,1. XMailer: Axigen WebMail Date:
 +0200
X-AXIGEN-KAS-Spam-Level: Not Spam
X-AXIGEN-KAS-Spam-Confidence: 0%
X-AxigenVirus-Level: 1
X-AXIGEN-KAV-Info: clean: Scanned with Kaspersky Anti Virus 8.0.3.83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tx and rx urbs are not deallocated if something goes wrong in peak_usb_start().
The patch fixes error handling to deallocate all the resources.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Stephane Grosjean <s.grosjean@peak-system.com>
---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index a0f647f..0b7a4c3 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -463,7 +463,7 @@ static int peak_usb_start(struct peak_usb_device *dev)
     if (i < PCAN_USB_MAX_TX_URBS) {
         if (i == 0) {
             netdev_err(netdev, "couldn't setup any tx URB\n");
-            return err;
+            goto err_tx;
         }
 
         netdev_warn(netdev, "tx performance may be slow\n");
@@ -472,7 +472,7 @@ static int peak_usb_start(struct peak_usb_device *dev)
     if (dev->adapter->dev_start) {
         err = dev->adapter->dev_start(dev);
         if (err)
-            goto failed;
+            goto err_adapter;
     }
 
     dev->state |= PCAN_USB_STATE_STARTED;
@@ -481,19 +481,26 @@ static int peak_usb_start(struct peak_usb_device *dev)
     if (dev->adapter->dev_set_bus) {
         err = dev->adapter->dev_set_bus(dev, 1);
         if (err)
-            goto failed;
+            goto err_adapter;
     }
 
     dev->can.state = CAN_STATE_ERROR_ACTIVE;
 
     return 0;
 
-failed:
+err_adapter:
     if (err == -ENODEV)
         netif_device_detach(dev->netdev);
 
     netdev_warn(netdev, "couldn't submit control: %d\n", err);
 
+    for (i = 0; i < PCAN_USB_MAX_TX_URBS; i++) {
+        usb_free_urb(dev->tx_contexts[i].urb);
+        dev->tx_contexts[i].urb = NULL;
+    }
+err_tx:
+    usb_kill_anchored_urbs(&dev->rx_submitted);
+
     return err;
 }
 
--
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-can" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
PEAK-System Technik GmbH, Otto-Roehm-Strasse 69, D-64293 Darmstadt 
Geschaeftsleitung: A.Gach/U.Wilhelm,St.Nr.:007/241/13586 FA Darmstadt 
HRB-9183 Darmstadt, Ust.IdNr.:DE 202220078, WEE-Reg.-Nr.: DE39305391 
Tel.+49 (0)6151-817320 / Fax:+49 (0)6151-817329, info@peak-system.com
