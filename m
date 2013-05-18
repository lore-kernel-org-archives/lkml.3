Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab3ERCaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:30:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25200 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab3ERCQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:46 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=AhbiI0qg5HQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=3Dd8U3po1w8A:10 a=8b9GpE9nAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=DrQNnGUBFA7A8ePPMwIA:9 a=RUNXi7WdHkcA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021644.170658287@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Adrian Thomasset <adrian.thomasset@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 015/136 ] USB: ftdi_sio: enable two UART ports on ST Microconnect Lite
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0015-USB-ftdi_sio-enable-two-UART-ports-on-ST-Microconnec.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Adrian Thomasset <adrian.thomasset@st.com>

[ Upstream commit 71d9a2b95fc9c9474d46d764336efd7a5a805555 ]

The FT4232H used in the ST Micro Connect Lite has four hi-speed UART ports.
The first two ports are reserved for the JTAG interface.

We enable by default ports 2 and 3 as UARTs (where port 2 is a
conventional RS-232 UART)

Signed-off-by: Adrian Thomasset <adrian.thomasset@st.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/ftdi_sio.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 8e9a6cd..5843cc8 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1795,20 +1795,24 @@ static int ftdi_8u2232c_probe(struct usb_serial *serial)
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
1.7.10.4


