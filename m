Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030457AbaGRNKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:10:07 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17471 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030417AbaGRNJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:09:58 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 072/170] USB: ftdi_sio: fix null deref at port probe
Date: Fri, 18 Jul 2014 14:11:17 +0200
Message-Id: <5b7169673a2f472bc2ed4cfe4c3926ba546a201a.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit aea1ae8760314e072bf1b773521e9de5d5dda10d upstream.

Fix NULL-pointer dereference when probing an interface with no
endpoints.

These devices have two bulk endpoints per interface, but this avoids
crashing the kernel if a user forces a non-FTDI device to be probed.

Note that the iterator variable was made unsigned in order to avoid
a maybe-uninitialized compiler warning for ep_desc after the loop.

Fixes: 895f28badce9 ("USB: ftdi_sio: fix hi-speed device packet size
calculation")

Reported-by: Mike Remski <mremski@mutualink.net>
Tested-by: Mike Remski <mremski@mutualink.net>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/ftdi_sio.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 503c89e18187..ebf04c7d49cb 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1567,14 +1567,17 @@ static void ftdi_set_max_packet_size(struct usb_serial_port *port)
 	struct usb_device *udev = serial->dev;
 
 	struct usb_interface *interface = serial->interface;
-	struct usb_endpoint_descriptor *ep_desc = &interface->cur_altsetting->endpoint[1].desc;
+	struct usb_endpoint_descriptor *ep_desc;
 
 	unsigned num_endpoints;
-	int i;
+	unsigned i;
 
 	num_endpoints = interface->cur_altsetting->desc.bNumEndpoints;
 	dev_info(&udev->dev, "Number of endpoints %d\n", num_endpoints);
 
+	if (!num_endpoints)
+		return;
+
 	/* NOTE: some customers have programmed FT232R/FT245R devices
 	 * with an endpoint size of 0 - not good.  In this case, we
 	 * want to override the endpoint descriptor setting and use a
-- 
2.0.0

