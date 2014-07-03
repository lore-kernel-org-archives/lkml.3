Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbaGCKHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:07:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51734 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964859AbaGCJWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:12 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 054/198] USB: sierra: fix AA deadlock in open error path
Date: Thu,  3 Jul 2014 10:18:17 +0100
Message-Id: <1404379241-8590-55-git-send-email-luis.henriques@canonical.com>
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

commit 353fe198602e8b4d1c7bdcceb8e60955087201b1 upstream.

Fix AA deadlock in open error path that would call close() and try to
grab the already held disc_mutex.

Fixes: b9a44bc19f48 ("sierra: driver urb handling improvements")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/sierra.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index b6910b7ab7e2..b3f2b60465bd 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -824,14 +824,9 @@ static int sierra_open(struct tty_struct *tty, struct usb_serial_port *port)
 			usb_sndbulkpipe(serial->dev, endpoint) | USB_DIR_IN);
 
 	err = sierra_submit_rx_urbs(port, GFP_KERNEL);
-	if (err) {
-		/* get rid of everything as in close */
-		sierra_close(port);
-		/* restore balance for autopm */
-		if (!serial->disconnected)
-			usb_autopm_put_interface(serial->interface);
-		return err;
-	}
+	if (err)
+		goto err_submit;
+
 	sierra_send_setup(port);
 
 	serial->interface->needs_remote_wakeup = 1;
@@ -841,6 +836,16 @@ static int sierra_open(struct tty_struct *tty, struct usb_serial_port *port)
 	usb_autopm_put_interface(serial->interface);
 
 	return 0;
+
+err_submit:
+	sierra_stop_rx_urbs(port);
+
+	for (i = 0; i < portdata->num_in_urbs; i++) {
+		sierra_release_urb(portdata->in_urbs[i]);
+		portdata->in_urbs[i] = NULL;
+	}
+
+	return err;
 }
 
 
-- 
1.9.1

