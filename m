Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbaHHUrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:47:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40525 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995AbaHHUrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:47:19 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <johan@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 026/259] USB: ftdi_sio: fix null deref at port probe
Date: Fri,  8 Aug 2014 13:37:29 -0700
Message-Id: <1407530482-4483-27-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index f009887..244c00f 100644
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
1.9.1

