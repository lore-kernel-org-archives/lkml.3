Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbaF3Mlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:41:53 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932139AbaF3MbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 129/181] USB: usb_wwan: fix write and suspend race
Date: Mon, 30 Jun 2014 13:52:30 +0200
Message-Id: <d61d8eda959f26f556f6b8e6cc902841c9677eb7.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 170fad9e22df0063eba0701adb966786d7a4ec5a upstream.

Fix race between write() and suspend() which could lead to writes being
dropped (or I/O while suspended) if the device is runtime suspended
while a write request is being processed.

Specifically, suspend() releases the susp_lock after determining the
device is idle but before setting the suspended flag, thus leaving a
window where a concurrent write() can submit an urb.

Fixes: 383cedc3bb43 ("USB: serial: full autosuspend support for the
option driver")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/usb_wwan.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 80c16d84156a..ede88f1e09a3 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -583,20 +583,17 @@ static void stop_read_write_urbs(struct usb_serial *serial)
 int usb_wwan_suspend(struct usb_serial *serial, pm_message_t message)
 {
 	struct usb_wwan_intf_private *intfdata = serial->private;
-	int b;
 
+	spin_lock_irq(&intfdata->susp_lock);
 	if (PMSG_IS_AUTO(message)) {
-		spin_lock_irq(&intfdata->susp_lock);
-		b = intfdata->in_flight;
-		spin_unlock_irq(&intfdata->susp_lock);
-
-		if (b)
+		if (intfdata->in_flight) {
+			spin_unlock_irq(&intfdata->susp_lock);
 			return -EBUSY;
+		}
 	}
-
-	spin_lock_irq(&intfdata->susp_lock);
 	intfdata->suspended = 1;
 	spin_unlock_irq(&intfdata->susp_lock);
+
 	stop_read_write_urbs(serial);
 
 	return 0;
-- 
2.0.0

