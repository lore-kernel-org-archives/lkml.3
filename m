Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbbALSNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:13:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57734 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbbALSGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 093/216] can: peak_usb: fix cleanup sequence order in case of error during init
Date: Mon, 12 Jan 2015 18:03:30 +0000
Message-Id: <1421085933-32536-94-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephane Grosjean <s.grosjean@peak-system.com>

commit af35d0f1cce7a990286e2b94c260a2c2d2a0e4b0 upstream.

This patch sets the correct reverse sequence order to the instructions
set to run, when any failure occurs during the initialization steps.
It also adds the missing unregistration call of the can device if the
failure appears after having been registered.

Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index 644e6ab8a489..dc807e10f802 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -735,7 +735,7 @@ static int peak_usb_create_dev(struct peak_usb_adapter *peak_usb_adapter,
 	dev->cmd_buf = kmalloc(PCAN_USB_MAX_CMD_LEN, GFP_KERNEL);
 	if (!dev->cmd_buf) {
 		err = -ENOMEM;
-		goto lbl_set_intf_data;
+		goto lbl_free_candev;
 	}
 
 	dev->udev = usb_dev;
@@ -775,7 +775,7 @@ static int peak_usb_create_dev(struct peak_usb_adapter *peak_usb_adapter,
 	err = register_candev(netdev);
 	if (err) {
 		dev_err(&intf->dev, "couldn't register CAN device: %d\n", err);
-		goto lbl_free_cmd_buf;
+		goto lbl_restore_intf_data;
 	}
 
 	if (dev->prev_siblings)
@@ -788,14 +788,14 @@ static int peak_usb_create_dev(struct peak_usb_adapter *peak_usb_adapter,
 	if (dev->adapter->dev_init) {
 		err = dev->adapter->dev_init(dev);
 		if (err)
-			goto lbl_free_cmd_buf;
+			goto lbl_unregister_candev;
 	}
 
 	/* set bus off */
 	if (dev->adapter->dev_set_bus) {
 		err = dev->adapter->dev_set_bus(dev, 0);
 		if (err)
-			goto lbl_free_cmd_buf;
+			goto lbl_unregister_candev;
 	}
 
 	/* get device number early */
@@ -807,11 +807,14 @@ static int peak_usb_create_dev(struct peak_usb_adapter *peak_usb_adapter,
 
 	return 0;
 
-lbl_free_cmd_buf:
-	kfree(dev->cmd_buf);
+lbl_unregister_candev:
+	unregister_candev(netdev);
 
-lbl_set_intf_data:
+lbl_restore_intf_data:
 	usb_set_intfdata(intf, dev->prev_siblings);
+	kfree(dev->cmd_buf);
+
+lbl_free_candev:
 	free_candev(netdev);
 
 	return err;
-- 
2.1.4

