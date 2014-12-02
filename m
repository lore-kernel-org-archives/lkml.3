Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933761AbaLBT0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:26:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46970 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933730AbaLBT0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:26:39 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <johan@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 021/121] USB: kobil_sct: fix non-atomic allocation in write path
Date: Tue,  2 Dec 2014 11:18:20 -0800
Message-Id: <1417548000-1794-22-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 191252837626fca0de694c18bb2aa64c118eda89 upstream.

Write may be called from interrupt context so make sure to use
GFP_ATOMIC for all allocations in write.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/kobil_sct.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/kobil_sct.c b/drivers/usb/serial/kobil_sct.c
index 78b48c3..efa75b4 100644
--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -336,7 +336,8 @@ static int kobil_write(struct tty_struct *tty, struct usb_serial_port *port,
 			port->interrupt_out_urb->transfer_buffer_length = length;
 
 			priv->cur_pos = priv->cur_pos + length;
-			result = usb_submit_urb(port->interrupt_out_urb, GFP_NOIO);
+			result = usb_submit_urb(port->interrupt_out_urb,
+					GFP_ATOMIC);
 			dev_dbg(&port->dev, "%s - Send write URB returns: %i\n", __func__, result);
 			todo = priv->filled - priv->cur_pos;
 
@@ -351,7 +352,7 @@ static int kobil_write(struct tty_struct *tty, struct usb_serial_port *port,
 		if (priv->device_type == KOBIL_ADAPTER_B_PRODUCT_ID ||
 			priv->device_type == KOBIL_ADAPTER_K_PRODUCT_ID) {
 			result = usb_submit_urb(port->interrupt_in_urb,
-								GFP_NOIO);
+					GFP_ATOMIC);
 			dev_dbg(&port->dev, "%s - Send read URB returns: %i\n", __func__, result);
 		}
 	}
-- 
1.9.1

