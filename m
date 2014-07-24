Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbaGXKMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:12:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54861 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934502AbaGXJrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:47:49 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <johan@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 059/128] USB: ftdi_sio: fix null deref at port probe
Date: Thu, 24 Jul 2014 10:45:08 +0100
Message-Id: <1406195177-8656-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index b9e663ac9a35..3e315de9bbd4 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1577,14 +1577,17 @@ static void ftdi_set_max_packet_size(struct usb_serial_port *port)
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
1.9.1

