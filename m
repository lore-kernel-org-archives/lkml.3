Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422708Ab3LFXOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:14:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48456 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161399Ab3LFXMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:12:39 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Olivier Sobrie <olivier@sobrie.be>, Marc Kleine-Budde <mkl@pengutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 039/152] can: kvaser_usb: fix usb endpoints detection
Date: Fri,  6 Dec 2013 15:09:23 -0800
Message-Id: <1386371476-2477-40-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Sobrie <olivier@sobrie.be>

commit 896e23bd04ea50a146dffd342e2f96180f0812a5 upstream.

Some devices, like the Kvaser Memorator Professional, have several bulk in
endpoints. Only the first one found must be used by the driver. The same holds
for the bulk out endpoint. The official Kvaser driver (leaf) was used as
reference for this patch.

Signed-off-by: Olivier Sobrie <olivier@sobrie.be>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/can/usb/kvaser_usb.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb.c b/drivers/net/can/usb/kvaser_usb.c
index 20b5a3a..431f07e 100644
--- a/drivers/net/can/usb/kvaser_usb.c
+++ b/drivers/net/can/usb/kvaser_usb.c
@@ -1546,9 +1546,9 @@ static int kvaser_usb_init_one(struct usb_interface *intf,
 	return 0;
 }
 
-static void kvaser_usb_get_endpoints(const struct usb_interface *intf,
-				     struct usb_endpoint_descriptor **in,
-				     struct usb_endpoint_descriptor **out)
+static int kvaser_usb_get_endpoints(const struct usb_interface *intf,
+				    struct usb_endpoint_descriptor **in,
+				    struct usb_endpoint_descriptor **out)
 {
 	const struct usb_host_interface *iface_desc;
 	struct usb_endpoint_descriptor *endpoint;
@@ -1559,12 +1559,18 @@ static void kvaser_usb_get_endpoints(const struct usb_interface *intf,
 	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
 		endpoint = &iface_desc->endpoint[i].desc;
 
-		if (usb_endpoint_is_bulk_in(endpoint))
+		if (!*in && usb_endpoint_is_bulk_in(endpoint))
 			*in = endpoint;
 
-		if (usb_endpoint_is_bulk_out(endpoint))
+		if (!*out && usb_endpoint_is_bulk_out(endpoint))
 			*out = endpoint;
+
+		/* use first bulk endpoint for in and out */
+		if (*in && *out)
+			return 0;
 	}
+
+	return -ENODEV;
 }
 
 static int kvaser_usb_probe(struct usb_interface *intf,
@@ -1578,8 +1584,8 @@ static int kvaser_usb_probe(struct usb_interface *intf,
 	if (!dev)
 		return -ENOMEM;
 
-	kvaser_usb_get_endpoints(intf, &dev->bulk_in, &dev->bulk_out);
-	if (!dev->bulk_in || !dev->bulk_out) {
+	err = kvaser_usb_get_endpoints(intf, &dev->bulk_in, &dev->bulk_out);
+	if (err) {
 		dev_err(&intf->dev, "Cannot get usb endpoint(s)");
 		return err;
 	}
-- 
1.8.3.2

