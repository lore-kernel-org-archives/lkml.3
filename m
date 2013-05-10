Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab3EJOeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:34:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57194 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755489Ab3EJOVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:31 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Adrian Thomasset" <adrian.thomasset@st.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.902244180@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [054/118] USB: ftdi_sio: enable two UART ports on ST Microconnect
 Lite
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Thomasset <adrian.thomasset@st.com>

commit 71d9a2b95fc9c9474d46d764336efd7a5a805555 upstream.

The FT4232H used in the ST Micro Connect Lite has four hi-speed UART ports.
The first two ports are reserved for the JTAG interface.

We enable by default ports 2 and 3 as UARTs (where port 2 is a
conventional RS-232 UART)

Signed-off-by: Adrian Thomasset <adrian.thomasset@st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1819,8 +1819,11 @@ static int ftdi_8u2232c_probe(struct usb
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
@@ -1829,12 +1832,13 @@ static int ftdi_stmclite_probe(struct us
 
 	dbg("%s", __func__);
 
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

