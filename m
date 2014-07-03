Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbaGCKJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:09:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51709 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617AbaGCJWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:07 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 055/198] USB: sierra: fix use after free at suspend/resume
Date: Thu,  3 Jul 2014 10:18:18 +0100
Message-Id: <1404379241-8590-56-git-send-email-luis.henriques@canonical.com>
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

commit 8452727de70f6ad850cd6d0aaa18b5d9050aa63b upstream.

Fix use after free or NULL-pointer dereference during suspend and
resume.

The port data may never have been allocated (port probe failed)
or may already have been released by port_remove (e.g. driver is
unloaded) when suspend and resume are called.

Fixes: e6929a9020ac ("USB: support for autosuspend in sierra while
online")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/sierra.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index b3f2b60465bd..efdb76a7b787 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -941,6 +941,7 @@ static int sierra_port_remove(struct usb_serial_port *port)
 	struct sierra_port_private *portdata;
 
 	portdata = usb_get_serial_port_data(port);
+	usb_set_serial_port_data(port, NULL);
 	kfree(portdata);
 
 	return 0;
@@ -957,6 +958,8 @@ static void stop_read_write_urbs(struct usb_serial *serial)
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
 		portdata = usb_get_serial_port_data(port);
+		if (!portdata)
+			continue;
 		sierra_stop_rx_urbs(port);
 		usb_kill_anchored_urbs(&portdata->active);
 	}
@@ -999,6 +1002,9 @@ static int sierra_resume(struct usb_serial *serial)
 		port = serial->port[i];
 		portdata = usb_get_serial_port_data(port);
 
+		if (!portdata)
+			continue;
+
 		while ((urb = usb_get_from_anchor(&portdata->delayed))) {
 			usb_anchor_urb(urb, &portdata->active);
 			intfdata->in_flight++;
-- 
1.9.1

