Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759103Ab3EFVNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 17:13:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757420Ab3EFUqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:46:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Adrian Thomasset <adrian.thomasset@st.com>
Subject: [ 024/115] USB: ftdi_sio: enable two UART ports on ST Microconnect Lite
Date: Mon,  6 May 2013 13:44:20 -0700
Message-Id: <20130506203058.048921646@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Thomasset <adrian.thomasset@st.com>

commit 71d9a2b95fc9c9474d46d764336efd7a5a805555 upstream.

The FT4232H used in the ST Micro Connect Lite has four hi-speed UART ports.
The first two ports are reserved for the JTAG interface.

We enable by default ports 2 and 3 as UARTs (where port 2 is a
conventional RS-232 UART)

Signed-off-by: Adrian Thomasset <adrian.thomasset@st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1795,20 +1795,24 @@ static int ftdi_8u2232c_probe(struct usb
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
+	if (interface == udev->actconfig->interface[0] ||
+	    interface == udev->actconfig->interface[1]) {
+		dev_info(&udev->dev, "Ignoring serial port reserved for JTAG\n");
+		return -ENODEV;
+	}
 
-	dev_info(&udev->dev, "Ignoring serial port reserved for JTAG\n");
-
-	return -ENODEV;
+	return 0;
 }
 
 /*


