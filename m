Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965920AbaLKXbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 18:31:40 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:47812 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965780AbaLKXbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 18:31:31 -0500
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH 2/2] usb: serial: handle -ENODEV quietly in generic_submit_read_urb
Date: Thu, 11 Dec 2014 15:29:54 -0800
Message-Id: <1418340594-30469-3-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418340594-30469-1-git-send-email-jmmahler@gmail.com>
References: <1418340594-30469-1-git-send-email-jmmahler@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a USB serial device (e.g. /dev/ttyUSB0) with an active program is
unplugged, an -ENODEV (19) error will be produced after it gives up
trying to resubmit a read.

  usb_serial_generic_submit_read_urb - usb_submit_urb failed: -19

Add -ENODEV as one of the permanent errors along with -EPERM that
usb_serial_generic_submit_read_urb() handles quietly without an error.

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---
 drivers/usb/serial/generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 98fe718..cca81c4 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -286,7 +286,7 @@ static int usb_serial_generic_submit_read_urb(struct usb_serial_port *port,
 
 	res = usb_submit_urb(port->read_urbs[index], mem_flags);
 	if (res) {
-		if (res != -EPERM) {
+		if (res != -EPERM && res != -ENODEV) {
 			dev_err(&port->dev,
 					"%s - usb_submit_urb failed: %d\n",
 					__func__, res);
-- 
2.1.3

