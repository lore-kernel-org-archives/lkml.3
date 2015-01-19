Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbbASLvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 06:51:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:48059 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbbASLvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 06:51:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,426,1418112000"; 
   d="scan'208";a="514247937"
From: Octavian Purdila <octavian.purdila@intel.com>
To: lee.jones@linaro.org
Cc: johan@kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v3 2/2] mfd: dln2: add suspend/resume functionality
Date: Mon, 19 Jan 2015 13:51:36 +0200
Message-Id: <1421668296-28470-3-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421668296-28470-1-git-send-email-octavian.purdila@intel.com>
References: <1421668296-28470-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without suspend/resume functionality in the USB driver the USB core
will disconnect and reconnect the DLN2 port and because the GPIO
framework does not yet support removal of an in-use controller a
suspend/resume operation will result in a crash.

This patch provides suspend and resume functions for the DLN2 driver
so that the above scenario is avoided, if the host controller does not
drop VBUS during suspend, since in this case the device state is
preserved.

We chose not implemented reset_resume so that if the host controller
does drop VBUS the resume path will go through above the
disconnect/reconnect process since it is probably better to fix the
GPIO framework disconnect issue then to save and restore the device
state for every driver.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
Reviewed-by: Johan Hovold <johan@kernel.org>
---
 drivers/mfd/dln2.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
index 8311820..1be9bd1 100644
--- a/drivers/mfd/dln2.c
+++ b/drivers/mfd/dln2.c
@@ -791,6 +791,24 @@ out_free:
 	return ret;
 }
 
+static int dln2_suspend(struct usb_interface *iface, pm_message_t message)
+{
+	struct dln2_dev *dln2 = usb_get_intfdata(iface);
+
+	dln2_stop(dln2);
+
+	return 0;
+}
+
+static int dln2_resume(struct usb_interface *iface)
+{
+	struct dln2_dev *dln2 = usb_get_intfdata(iface);
+
+	dln2->disconnect = false;
+
+	return dln2_start_rx_urbs(dln2, GFP_NOIO);
+}
+
 static const struct usb_device_id dln2_table[] = {
 	{ USB_DEVICE(0xa257, 0x2013) },
 	{ }
@@ -803,6 +821,8 @@ static struct usb_driver dln2_driver = {
 	.probe = dln2_probe,
 	.disconnect = dln2_disconnect,
 	.id_table = dln2_table,
+	.suspend = dln2_suspend,
+	.resume = dln2_resume,
 };
 
 module_usb_driver(dln2_driver);
-- 
1.9.1

