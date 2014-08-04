Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbaHDRSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:18:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56448 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692AbaHDQty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johan Hovold" <johan@kernel.org>,
        "Mike Remski" <mremski@mutualink.net>
Date: Mon, 04 Aug 2014 17:48:31 +0100
Message-ID: <lsq.1407170911.962639714@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 07/94] USB: ftdi_sio: fix null deref at port probe
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1591,14 +1591,17 @@ static void ftdi_set_max_packet_size(str
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

