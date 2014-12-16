Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaLPP55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 10:57:57 -0500
Received: from mga03.intel.com ([134.134.136.65]:29973 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaLPP5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 10:57:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="499594998"
From: Octavian Purdila <octavian.purdila@intel.com>
To: linus.walleij@linaro.org, lee.jones@linaro.org
Cc: johan@kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v2 4/4] mfd: dln2: add suspend/resume functionality
Date: Tue, 16 Dec 2014 17:57:15 +0200
Message-Id: <1418745435-2851-5-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418745435-2851-1-git-send-email-octavian.purdila@intel.com>
References: <1418745435-2851-1-git-send-email-octavian.purdila@intel.com>
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
 drivers/mfd/dln2.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
index 75358d2..f9c4a0b 100644
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

