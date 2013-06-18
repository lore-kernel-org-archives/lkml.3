Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651Ab3FRMIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:08:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55939 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab3FRLoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 14/93] USB: mos7840: fix DMA to stack
Date: Tue, 18 Jun 2013 12:42:22 +0100
Message-Id: <1371555821-12820-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 15ee89c3347fbf58a4361011eda5ac2731e45126 upstream.

Fix regression introduced by commit 0eafe4de1a ("USB: serial: mos7840:
add support for MCS7810 devices") which used stack-allocated buffers for
control messages.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/mos7840.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 2727955..dada37f 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2342,13 +2342,21 @@ static int mos7840_ioctl(struct tty_struct *tty,
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
@@ -2358,9 +2366,12 @@ static int mos7810_check(struct usb_serial *serial)
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
@@ -2374,6 +2385,8 @@ static int mos7810_check(struct usb_serial *serial)
 		MCS_WR_RTYPE, 0x0300 | mcr_data, MODEM_CONTROL_REGISTER, NULL,
 		0, MOS_WDR_TIMEOUT);
 
+	kfree(buf);
+
 	if (pass_count == 16)
 		return 1;
 
@@ -2383,11 +2396,17 @@ static int mos7810_check(struct usb_serial *serial)
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
1.8.1.2

