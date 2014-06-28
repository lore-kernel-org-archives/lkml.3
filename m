Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbaF1SQm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:16:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbaF1Rvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:51:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.15 055/139] USB: sierra: fix use after free at suspend/resume
Date: Sat, 28 Jun 2014 10:46:56 -0700
Message-Id: <20140628174607.953486687@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/serial/sierra.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -933,6 +933,7 @@ static int sierra_port_remove(struct usb
 	struct sierra_port_private *portdata;
 
 	portdata = usb_get_serial_port_data(port);
+	usb_set_serial_port_data(port, NULL);
 	kfree(portdata);
 
 	return 0;
@@ -949,6 +950,8 @@ static void stop_read_write_urbs(struct
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
 		portdata = usb_get_serial_port_data(port);
+		if (!portdata)
+			continue;
 		sierra_stop_rx_urbs(port);
 		usb_kill_anchored_urbs(&portdata->active);
 	}
@@ -991,6 +994,9 @@ static int sierra_resume(struct usb_seri
 		port = serial->port[i];
 		portdata = usb_get_serial_port_data(port);
 
+		if (!portdata)
+			continue;
+
 		while ((urb = usb_get_from_anchor(&portdata->delayed))) {
 			usb_anchor_urb(urb, &portdata->active);
 			intfdata->in_flight++;


