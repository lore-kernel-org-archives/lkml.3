Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab3KZSWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:22:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35344 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344Ab3KZSMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:12:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Olivier Sobrie <olivier@sobrie.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3.11 07/36] can: kvaser_usb: fix usb endpoints detection
Date: Tue, 26 Nov 2013 10:12:17 -0800
Message-Id: <20131126181026.589189960@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131126181025.029404973@linuxfoundation.org>
References: <20131126181025.029404973@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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


