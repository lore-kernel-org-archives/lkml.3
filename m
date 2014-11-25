Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaKYKkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:40:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58032 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbaKYKkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:24 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <johan@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 012/254] USB: kobil_sct: fix non-atomic allocation in write path
Date: Tue, 25 Nov 2014 10:36:02 +0000
Message-Id: <1416912004-5928-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 191252837626fca0de694c18bb2aa64c118eda89 upstream.

Write may be called from interrupt context so make sure to use
GFP_ATOMIC for all allocations in write.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/kobil_sct.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/kobil_sct.c b/drivers/usb/serial/kobil_sct.c
index 078f9ed419c8..a31ff1503a99 100644
--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -335,7 +335,8 @@ static int kobil_write(struct tty_struct *tty, struct usb_serial_port *port,
 			port->interrupt_out_urb->transfer_buffer_length = length;
 
 			priv->cur_pos = priv->cur_pos + length;
-			result = usb_submit_urb(port->interrupt_out_urb, GFP_NOIO);
+			result = usb_submit_urb(port->interrupt_out_urb,
+					GFP_ATOMIC);
 			dev_dbg(&port->dev, "%s - Send write URB returns: %i\n", __func__, result);
 			todo = priv->filled - priv->cur_pos;
 
@@ -350,7 +351,7 @@ static int kobil_write(struct tty_struct *tty, struct usb_serial_port *port,
 		if (priv->device_type == KOBIL_ADAPTER_B_PRODUCT_ID ||
 			priv->device_type == KOBIL_ADAPTER_K_PRODUCT_ID) {
 			result = usb_submit_urb(port->interrupt_in_urb,
-								GFP_NOIO);
+					GFP_ATOMIC);
 			dev_dbg(&port->dev, "%s - Send read URB returns: %i\n", __func__, result);
 		}
 	}
-- 
2.1.0

