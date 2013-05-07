Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469Ab3EGNmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:42:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42555 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759364Ab3EGNmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:42:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Adrian Thomasset <adrian.thomasset@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 100/118] USB: ftdi_sio: enable two UART ports on ST Microconnect Lite
Date: Tue,  7 May 2013 14:39:06 +0100
Message-Id: <1367933964-1564-101-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Thomasset <adrian.thomasset@st.com>

commit 71d9a2b95fc9c9474d46d764336efd7a5a805555 upstream.

The FT4232H used in the ST Micro Connect Lite has four hi-speed UART ports.
The first two ports are reserved for the JTAG interface.

We enable by default ports 2 and 3 as UARTs (where port 2 is a
conventional RS-232 UART)

Signed-off-by: Adrian Thomasset <adrian.thomasset@st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index ecfd525..d5b9a74 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1799,20 +1799,24 @@ static int ftdi_8u2232c_probe(struct usb_serial *serial)
 }
 
 /*
- * First and second port on STMCLiteadaptors is reserved for JTAG interface
- * and the forth port for pio
+ * First two ports on JTAG adaptors using an FT4232 such as STMicroelectronics's
+ * ST Micro Connect Lite are reserved for JTAG or other non-UART interfaces and
+ * can be accessed from userspace.
+ * The next two ports are enabled as UARTs by default, where port 2 is
+ * a conventional RS-232 UART.
  */
 static int ftdi_stmclite_probe(struct usb_serial *serial)
 {
 	struct usb_device *udev = serial->dev;
 	struct usb_interface *interface = serial->interface;
 
-	if (interface == udev->actconfig->interface[2])
-		return 0;
-
-	dev_info(&udev->dev, "Ignoring serial port reserved for JTAG\n");
+	if (interface == udev->actconfig->interface[0] ||
+	    interface == udev->actconfig->interface[1]) {
+		dev_info(&udev->dev, "Ignoring serial port reserved for JTAG\n");
+		return -ENODEV;
+	}
 
-	return -ENODEV;
+	return 0;
 }
 
 /*
-- 
1.8.1.2

