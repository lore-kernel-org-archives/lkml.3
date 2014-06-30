Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbaF3MiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:38:13 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964828AbaF3Mbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:36 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 137/181] USB: sierra: fix remote wakeup
Date: Mon, 30 Jun 2014 13:52:38 +0200
Message-Id: <21ea51b09f33ea8a04d43eb6094e2f14836c2d7b.1404128998.git.jslaby@suse.cz>
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

commit 80cc0fcbdaeaf10d04ba27779a2d7ceb73d2717a upstream.

Make sure that needs_remote_wake up is always set when there are open
ports.

Currently close() would unconditionally set needs_remote_wakeup to 0
even though there might still be open ports. This could lead to blocked
input and possibly dropped data on devices that do not support remote
wakeup (and which must therefore not be runtime suspended while open).

Add an open_ports counter (protected by the susp_lock) and only clear
needs_remote_wakeup when the last port is closed.

Fixes: e6929a9020ac ("USB: support for autosuspend in sierra while
online")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/sierra.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index 0988887e2059..d84a3f31ae2d 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -58,6 +58,7 @@ struct sierra_intf_private {
 	spinlock_t susp_lock;
 	unsigned int suspended:1;
 	int in_flight;
+	unsigned int open_ports;
 };
 
 static int sierra_set_power_state(struct usb_device *udev, __u16 swiState)
@@ -776,7 +777,6 @@ static void sierra_close(struct usb_serial_port *port)
 
 	mutex_lock(&serial->disc_mutex);
 	if (!serial->disconnected) {
-		serial->interface->needs_remote_wakeup = 0;
 		/* odd error handling due to pm counters */
 		if (!usb_autopm_get_interface(serial->interface))
 			sierra_send_setup(port);
@@ -787,6 +787,8 @@ static void sierra_close(struct usb_serial_port *port)
 	mutex_unlock(&serial->disc_mutex);
 	spin_lock_irq(&intfdata->susp_lock);
 	portdata->opened = 0;
+	if (--intfdata->open_ports == 0)
+		serial->interface->needs_remote_wakeup = 0;
 	spin_unlock_irq(&intfdata->susp_lock);
 
 	for (;;) {
@@ -842,9 +844,10 @@ static int sierra_open(struct tty_struct *tty, struct usb_serial_port *port)
 
 	sierra_send_setup(port);
 
-	serial->interface->needs_remote_wakeup = 1;
 	spin_lock_irq(&intfdata->susp_lock);
 	portdata->opened = 1;
+	if (++intfdata->open_ports == 1)
+		serial->interface->needs_remote_wakeup = 1;
 	spin_unlock_irq(&intfdata->susp_lock);
 	usb_autopm_put_interface(serial->interface);
 
-- 
2.0.0

