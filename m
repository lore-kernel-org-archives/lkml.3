Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbaF1TZR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 15:25:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52749 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaF1RrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:47:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.4 25/43] USB: sierra: fix use after free at suspend/resume
Date: Sat, 28 Jun 2014 10:46:16 -0700
Message-Id: <20140628174450.952441673@linuxfoundation.org>
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
@@ -999,6 +999,7 @@ static void sierra_release(struct usb_se
 		portdata = usb_get_serial_port_data(port);
 		if (!portdata)
 			continue;
+		usb_set_serial_port_data(port, NULL);
 		kfree(portdata);
 	}
 	kfree(serial->private);
@@ -1015,6 +1016,8 @@ static void stop_read_write_urbs(struct
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
 		portdata = usb_get_serial_port_data(port);
+		if (!portdata)
+			continue;
 		sierra_stop_rx_urbs(port);
 		usb_kill_anchored_urbs(&portdata->active);
 	}
@@ -1057,6 +1060,9 @@ static int sierra_resume(struct usb_seri
 		port = serial->port[i];
 		portdata = usb_get_serial_port_data(port);
 
+		if (!portdata)
+			continue;
+
 		while ((urb = usb_get_from_anchor(&portdata->delayed))) {
 			usb_anchor_urb(urb, &portdata->active);
 			intfdata->in_flight++;


