Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbaGCKIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:08:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51728 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964815AbaGCJWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:10 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 058/198] USB: sierra: fix remote wakeup
Date: Thu,  3 Jul 2014 10:18:21 +0100
Message-Id: <1404379241-8590-59-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

