Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbaF1TSF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 15:18:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbaF1Rre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:47:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.4 28/43] USB: sierra: fix remote wakeup
Date: Sat, 28 Jun 2014 10:46:19 -0700
Message-Id: <20140628174451.088008254@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174449.788784511@linuxfoundation.org>
References: <20140628174449.788784511@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/serial/sierra.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -59,6 +59,7 @@ struct sierra_intf_private {
 	spinlock_t susp_lock;
 	unsigned int suspended:1;
 	int in_flight;
+	unsigned int open_ports;
 };
 
 static int sierra_set_power_state(struct usb_device *udev, __u16 swiState)
@@ -813,7 +814,6 @@ static void sierra_close(struct usb_seri
 	if (serial->dev) {
 		mutex_lock(&serial->disc_mutex);
 		if (!serial->disconnected) {
-			serial->interface->needs_remote_wakeup = 0;
 			/* odd error handling due to pm counters */
 			if (!usb_autopm_get_interface(serial->interface))
 				sierra_send_setup(port);
@@ -824,6 +824,8 @@ static void sierra_close(struct usb_seri
 		mutex_unlock(&serial->disc_mutex);
 		spin_lock_irq(&intfdata->susp_lock);
 		portdata->opened = 0;
+		if (--intfdata->open_ports == 0)
+			serial->interface->needs_remote_wakeup = 0;
 		spin_unlock_irq(&intfdata->susp_lock);
 
 		for (;;) {
@@ -884,9 +886,10 @@ static int sierra_open(struct tty_struct
 
 	sierra_send_setup(port);
 
-	serial->interface->needs_remote_wakeup = 1;
 	spin_lock_irq(&intfdata->susp_lock);
 	portdata->opened = 1;
+	if (++intfdata->open_ports == 1)
+		serial->interface->needs_remote_wakeup = 1;
 	spin_unlock_irq(&intfdata->susp_lock);
 	usb_autopm_put_interface(serial->interface);
 


