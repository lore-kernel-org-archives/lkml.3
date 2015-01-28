Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965081AbbA1EYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:24:18 -0500
Received: from mail.kernel.org ([198.145.29.136]:40585 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964977AbbA1EYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:24:11 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 125/177] USB: kobil_sct: fix non-atomic allocation in write path
Date: Wed, 28 Jan 2015 12:09:43 +0800
Message-Id: <1422418236-12852-216-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 191252837626fca0de694c18bb2aa64c118eda89 upstream.

Write may be called from interrupt context so make sure to use
GFP_ATOMIC for all allocations in write.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Johan Hovold <johan@kernel.org>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/serial/kobil_sct.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/kobil_sct.c b/drivers/usb/serial/kobil_sct.c
index 4a9a75e..c3a53ac 100644
--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -447,7 +447,7 @@ static int kobil_write(struct tty_struct *tty, struct usb_serial_port *port,
 			);
 
 			priv->cur_pos = priv->cur_pos + length;
-			result = usb_submit_urb(port->write_urb, GFP_NOIO);
+			result = usb_submit_urb(port->write_urb, GFP_ATOMIC);
 			dbg("%s - port %d Send write URB returns: %i",
 					__func__, port->number, result);
 			todo = priv->filled - priv->cur_pos;
@@ -463,7 +463,7 @@ static int kobil_write(struct tty_struct *tty, struct usb_serial_port *port,
 		if (priv->device_type == KOBIL_ADAPTER_B_PRODUCT_ID ||
 			priv->device_type == KOBIL_ADAPTER_K_PRODUCT_ID) {
 			result = usb_submit_urb(port->interrupt_in_urb,
-								GFP_NOIO);
+								GFP_ATOMIC);
 			dbg("%s - port %d Send read URB returns: %i",
 					__func__, port->number, result);
 		}
-- 
1.9.1

