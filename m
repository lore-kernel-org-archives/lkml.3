Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169AbbANHsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:48:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933086AbbANHiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:38:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3.10 04/44] can: peak_usb: fix cleanup sequence order in case of error during init
Date: Tue, 13 Jan 2015 23:23:25 -0800
Message-Id: <20150114072227.671728088@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072227.419663002@linuxfoundation.org>
References: <20150114072227.419663002@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephane Grosjean <s.grosjean@peak-system.com>

commit af35d0f1cce7a990286e2b94c260a2c2d2a0e4b0 upstream.

This patch sets the correct reverse sequence order to the instructions
set to run, when any failure occurs during the initialization steps.
It also adds the missing unregistration call of the can device if the
failure appears after having been registered.

Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -727,7 +727,7 @@ static int peak_usb_create_dev(struct pe
 	dev->cmd_buf = kmalloc(PCAN_USB_MAX_CMD_LEN, GFP_KERNEL);
 	if (!dev->cmd_buf) {
 		err = -ENOMEM;
-		goto lbl_set_intf_data;
+		goto lbl_free_candev;
 	}
 
 	dev->udev = usb_dev;
@@ -766,7 +766,7 @@ static int peak_usb_create_dev(struct pe
 	err = register_candev(netdev);
 	if (err) {
 		dev_err(&intf->dev, "couldn't register CAN device: %d\n", err);
-		goto lbl_free_cmd_buf;
+		goto lbl_restore_intf_data;
 	}
 
 	if (dev->prev_siblings)
@@ -779,14 +779,14 @@ static int peak_usb_create_dev(struct pe
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
@@ -798,11 +798,14 @@ static int peak_usb_create_dev(struct pe
 
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


