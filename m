Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965395AbaLKXbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 18:31:31 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:63231 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965695AbaLKXb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 18:31:28 -0500
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH 1/2] usb: serial: handle -EPROTO quietly in generic_read_bulk
Date: Thu, 11 Dec 2014 15:29:53 -0800
Message-Id: <1418340594-30469-2-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418340594-30469-1-git-send-email-jmmahler@gmail.com>
References: <1418340594-30469-1-git-send-email-jmmahler@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a USB serial device (e.g. /dev/ttyUSB0) with an active program is
unplugged, a bunch of -EPROTO (71) error messages will be produced by
usb_serial_generic_read_bulk_callback() as it tries to resubmit the
request.

  usb_serial_generic_read_bulk_callback - nonzero urb status: -71

Keep the same functionality, resubmit after an -EPROTO error, but change
message log level to debug instead of error so they are handled quietly
by default.

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---
 drivers/usb/serial/generic.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 1bd1922..98fe718 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -372,6 +372,10 @@ void usb_serial_generic_read_bulk_callback(struct urb *urb)
 		dev_err(&port->dev, "%s - urb stopped: %d\n",
 							__func__, urb->status);
 		return;
+	case -EPROTO:
+		dev_dbg(&port->dev, "%s - urb resubmit: %d\n",
+							__func__, urb->status);
+		goto resubmit;
 	default:
 		dev_err(&port->dev, "%s - nonzero urb status: %d\n",
 							__func__, urb->status);
-- 
2.1.3

