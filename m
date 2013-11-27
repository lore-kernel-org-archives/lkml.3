Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759749Ab3K0BaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:30:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab3K0A6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Olivier Sobrie <olivier@sobrie.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3.12 006/116] can: kvaser_usb: fix usb endpoints detection
Date: Tue, 26 Nov 2013 16:56:19 -0800
Message-Id: <20131127005737.360150066@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Sobrie <olivier@sobrie.be>

commit 896e23bd04ea50a146dffd342e2f96180f0812a5 upstream.

Some devices, like the Kvaser Memorator Professional, have several bulk in
endpoints. Only the first one found must be used by the driver. The same holds
for the bulk out endpoint. The official Kvaser driver (leaf) was used as
reference for this patch.

Signed-off-by: Olivier Sobrie <olivier@sobrie.be>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/usb/kvaser_usb.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/drivers/net/can/usb/kvaser_usb.c
+++ b/drivers/net/can/usb/kvaser_usb.c
@@ -1544,9 +1544,9 @@ static int kvaser_usb_init_one(struct us
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
@@ -1557,12 +1557,18 @@ static void kvaser_usb_get_endpoints(con
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
@@ -1576,8 +1582,8 @@ static int kvaser_usb_probe(struct usb_i
 	if (!dev)
 		return -ENOMEM;
 
-	kvaser_usb_get_endpoints(intf, &dev->bulk_in, &dev->bulk_out);
-	if (!dev->bulk_in || !dev->bulk_out) {
+	err = kvaser_usb_get_endpoints(intf, &dev->bulk_in, &dev->bulk_out);
+	if (err) {
 		dev_err(&intf->dev, "Cannot get usb endpoint(s)");
 		return err;
 	}


