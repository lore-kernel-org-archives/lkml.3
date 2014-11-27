Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbaK0L5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:57:51 -0500
Received: from mga01.intel.com ([192.55.52.88]:26739 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391AbaK0L5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:57:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,469,1413270000"; 
   d="scan'208";a="639014097"
From: Octavian Purdila <octavian.purdila@intel.com>
To: lee.jones@linaro.org
Cc: johan@kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH] mfd: dln2: add suspend/resume functionality
Date: Thu, 27 Nov 2014 13:57:14 +0200
Message-Id: <1417089434-11274-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without suspend/resume functionality in the USB driver the USB core
will disconnect and reconnect the DLN2 port and because the GPIO
framework does not yet support removal of an in-use controller a
suspend/resume operation will result in a crash.

This patch provides suspend, resume and reset_resume functions for the
DLN2 driver so that the above scenario is avoided.

In the suspend routine we flush any pending trasactions and prevent
any new transactions from being started.

In the resume_reset routine we just reinitializing the RX URBS as
the hardware does not lose it's state when a USB reset is performed.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/mfd/dln2.c | 41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
index b9019e4..0f1697c 100644
--- a/drivers/mfd/dln2.c
+++ b/drivers/mfd/dln2.c
@@ -651,9 +651,8 @@ static const struct mfd_cell dln2_devs[] = {
 	},
 };
 
-static void dln2_disconnect(struct usb_interface *interface)
+static void dln2_stop(struct dln2_dev *dln2)
 {
-	struct dln2_dev *dln2 = usb_get_intfdata(interface);
 	int i, j;
 
 	/* don't allow starting new transfers */
@@ -681,6 +680,13 @@ static void dln2_disconnect(struct usb_interface *interface)
 
 	/* wait for transfers to end */
 	wait_event(dln2->disconnect_wq, !dln2->active_transfers);
+}
+
+static void dln2_disconnect(struct usb_interface *interface)
+{
+	struct dln2_dev *dln2 = usb_get_intfdata(interface);
+
+	dln2_stop(dln2);
 
 	mfd_remove_devices(&interface->dev);
 
@@ -753,11 +759,42 @@ static const struct usb_device_id dln2_table[] = {
 
 MODULE_DEVICE_TABLE(usb, dln2_table);
 
+static int dln2_suspend(struct usb_interface *iface, pm_message_t message)
+{
+	struct dln2_dev *dln2 = usb_get_intfdata(iface);
+
+	dln2_stop(dln2);
+	return 0;
+}
+
+static int dln2_resume(struct usb_interface *iface)
+{
+	struct dln2_dev *dln2 = usb_get_intfdata(iface);
+
+	dln2->disconnect = false;
+	return 0;
+}
+
+static int dln2_reset_resume(struct usb_interface *iface)
+{
+	struct dln2_dev *dln2 = usb_get_intfdata(iface);
+	int ret;
+
+	dln2_free_rx_urbs(dln2);
+	ret = dln2_setup_rx_urbs(dln2, iface->cur_altsetting);
+	dln2->disconnect = false;
+
+	return ret;
+}
+
 static struct usb_driver dln2_driver = {
 	.name = "dln2",
 	.probe = dln2_probe,
 	.disconnect = dln2_disconnect,
 	.id_table = dln2_table,
+	.suspend = dln2_suspend,
+	.resume = dln2_resume,
+	.reset_resume = dln2_reset_resume,
 };
 
 module_usb_driver(dln2_driver);
-- 
1.9.1

