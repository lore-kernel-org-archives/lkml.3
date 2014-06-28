Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbaF1RsG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:48:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52967 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbaF1RsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:48:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.10 33/77] USB: sierra: fix AA deadlock in open error path
Date: Sat, 28 Jun 2014 10:46:26 -0700
Message-Id: <20140628174523.239191377@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174521.691276402@linuxfoundation.org>
References: <20140628174521.691276402@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 353fe198602e8b4d1c7bdcceb8e60955087201b1 upstream.

Fix AA deadlock in open error path that would call close() and try to
grab the already held disc_mutex.

Fixes: b9a44bc19f48 ("sierra: driver urb handling improvements")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/sierra.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -824,14 +824,9 @@ static int sierra_open(struct tty_struct
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
@@ -841,6 +836,16 @@ static int sierra_open(struct tty_struct
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
 
 


