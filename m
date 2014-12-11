Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933817AbaLKNEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 08:04:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:51427 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933650AbaLKNEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 08:04:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,557,1413270000"; 
   d="scan'208";a="636109411"
From: Octavian Purdila <octavian.purdila@intel.com>
To: linus.walleij@linaro.org, lee.jones@linaro.org
Cc: johan@kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH 3/3] mfd: dln2: add suspend/resume functionality
Date: Thu, 11 Dec 2014 15:02:31 +0200
Message-Id: <1418302951-9309-4-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418302951-9309-1-git-send-email-octavian.purdila@intel.com>
References: <1418302951-9309-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without suspend/resume functionality in the USB driver the USB core
will disconnect and reconnect the DLN2 port and because the GPIO
framework does not yet support removal of an in-use controller a
suspend/resume operation will result in a crash.

This patch provides suspend and resume functions for the DLN2 driver
so that the above scenario is avoided.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/mfd/dln2.c | 41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
index 6d49685..08c403c 100644
--- a/drivers/mfd/dln2.c
+++ b/drivers/mfd/dln2.c
@@ -587,7 +587,6 @@ static void dln2_free_rx_urbs(struct dln2_dev *dln2)
 	int i;
 
 	for (i = 0; i < DLN2_MAX_URBS; i++) {
-		usb_kill_urb(dln2->rx_urb[i]);
 		usb_free_urb(dln2->rx_urb[i]);
 		kfree(dln2->rx_buf[i]);
 	}
@@ -665,9 +664,8 @@ static const struct mfd_cell dln2_devs[] = {
 	},
 };
 
-static void dln2_disconnect(struct usb_interface *interface)
+static void dln2_stop(struct dln2_dev *dln2)
 {
-	struct dln2_dev *dln2 = usb_get_intfdata(interface);
 	int i, j;
 
 	/* don't allow starting new transfers */
@@ -696,6 +694,16 @@ static void dln2_disconnect(struct usb_interface *interface)
 	/* wait for transfers to end */
 	wait_event(dln2->disconnect_wq, !dln2->active_transfers);
 
+	for (i = 0; i < DLN2_MAX_URBS; i++)
+		usb_kill_urb(dln2->rx_urb[i]);
+}
+
+static void dln2_disconnect(struct usb_interface *interface)
+{
+	struct dln2_dev *dln2 = usb_get_intfdata(interface);
+
+	dln2_stop(dln2);
+
 	mfd_remove_devices(&interface->dev);
 
 	dln2_free(dln2);
@@ -767,11 +775,38 @@ static const struct usb_device_id dln2_table[] = {
 
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
+	int i;
+	int ret = 0;
+
+	dln2->disconnect = false;
+
+	for (i = 0; i < DLN2_MAX_URBS; i++) {
+		ret = usb_submit_urb(dln2->rx_urb[i], GFP_KERNEL);
+		if (ret)
+			break;
+	}
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
 };
 
 module_usb_driver(dln2_driver);
-- 
1.9.1

