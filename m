Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965162Ab3GCTDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:03:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6261 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965046Ab3GCTAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:32 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=nVMMZ_pgoL8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=GbiZm08Ugi0A:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=e0gVtgZ23HrhdBXb4dMA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=jxpA4z8-BymiTEoP:21 a=mjPeQBnAFBoidjM9:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184058.489317277@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [082/141] USB: mos7840: fix DMA to stack
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0082-USB-mos7840-fix-DMA-to-stack.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

[ Upstream commit 15ee89c3347fbf58a4361011eda5ac2731e45126 ]

Fix regression introduced by commit 0eafe4de1a ("USB: serial: mos7840:
add support for MCS7810 devices") which used stack-allocated buffers for
control messages.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/mos7840.c |   35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 8654df0..3193d25 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2341,13 +2341,21 @@ static int mos7840_ioctl(struct tty_struct *tty,
 static int mos7810_check(struct usb_serial *serial)
 {
 	int i, pass_count = 0;
+	u8 *buf;
 	__u16 data = 0, mcr_data = 0;
 	__u16 test_pattern = 0x55AA;
+	int res;
+
+	buf = kmalloc(VENDOR_READ_LENGTH, GFP_KERNEL);
+	if (!buf)
+		return 0;	/* failed to identify 7810 */
 
 	/* Store MCR setting */
-	usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
+	res = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
 		MCS_RDREQ, MCS_RD_RTYPE, 0x0300, MODEM_CONTROL_REGISTER,
-		&mcr_data, VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
+		buf, VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
+	if (res == VENDOR_READ_LENGTH)
+		mcr_data = *buf;
 
 	for (i = 0; i < 16; i++) {
 		/* Send the 1-bit test pattern out to MCS7810 test pin */
@@ -2357,9 +2365,12 @@ static int mos7810_check(struct usb_serial *serial)
 			MODEM_CONTROL_REGISTER, NULL, 0, MOS_WDR_TIMEOUT);
 
 		/* Read the test pattern back */
-		usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
-			MCS_RDREQ, MCS_RD_RTYPE, 0, GPIO_REGISTER, &data,
-			VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
+		res = usb_control_msg(serial->dev,
+				usb_rcvctrlpipe(serial->dev, 0), MCS_RDREQ,
+				MCS_RD_RTYPE, 0, GPIO_REGISTER, buf,
+				VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
+		if (res == VENDOR_READ_LENGTH)
+			data = *buf;
 
 		/* If this is a MCS7810 device, both test patterns must match */
 		if (((test_pattern >> i) ^ (~data >> 1)) & 0x0001)
@@ -2373,6 +2384,8 @@ static int mos7810_check(struct usb_serial *serial)
 		MCS_WR_RTYPE, 0x0300 | mcr_data, MODEM_CONTROL_REGISTER, NULL,
 		0, MOS_WDR_TIMEOUT);
 
+	kfree(buf);
+
 	if (pass_count == 16)
 		return 1;
 
@@ -2382,11 +2395,17 @@ static int mos7810_check(struct usb_serial *serial)
 static int mos7840_calc_num_ports(struct usb_serial *serial)
 {
 	__u16 data = 0x00;
+	u8 *buf;
 	int mos7840_num_ports;
 
-	usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
-		MCS_RDREQ, MCS_RD_RTYPE, 0, GPIO_REGISTER, &data,
-		VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
+	buf = kzalloc(VENDOR_READ_LENGTH, GFP_KERNEL);
+	if (buf) {
+		usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
+			MCS_RDREQ, MCS_RD_RTYPE, 0, GPIO_REGISTER, buf,
+			VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
+		data = *buf;
+		kfree(buf);
+	}
 
 	if (serial->dev->descriptor.idProduct == MOSCHIP_DEVICE_ID_7810 ||
 		serial->dev->descriptor.idProduct == MOSCHIP_DEVICE_ID_7820) {
-- 
1.7.10.4


