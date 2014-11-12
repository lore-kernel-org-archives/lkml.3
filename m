Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935055AbaKLBr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:47:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934921AbaKLBrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:47:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.14 162/203] USB: kobil_sct: fix non-atomic allocation in write path
Date: Wed, 12 Nov 2014 10:17:12 +0900
Message-Id: <20141112011550.106851435@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 191252837626fca0de694c18bb2aa64c118eda89 upstream.

Write may be called from interrupt context so make sure to use
GFP_ATOMIC for all allocations in write.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/kobil_sct.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -335,7 +335,8 @@ static int kobil_write(struct tty_struct
 			port->interrupt_out_urb->transfer_buffer_length = length;
 
 			priv->cur_pos = priv->cur_pos + length;
-			result = usb_submit_urb(port->interrupt_out_urb, GFP_NOIO);
+			result = usb_submit_urb(port->interrupt_out_urb,
+					GFP_ATOMIC);
 			dev_dbg(&port->dev, "%s - Send write URB returns: %i\n", __func__, result);
 			todo = priv->filled - priv->cur_pos;
 
@@ -350,7 +351,7 @@ static int kobil_write(struct tty_struct
 		if (priv->device_type == KOBIL_ADAPTER_B_PRODUCT_ID ||
 			priv->device_type == KOBIL_ADAPTER_K_PRODUCT_ID) {
 			result = usb_submit_urb(port->interrupt_in_urb,
-								GFP_NOIO);
+					GFP_ATOMIC);
 			dev_dbg(&port->dev, "%s - Send read URB returns: %i\n", __func__, result);
 		}
 	}


