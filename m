Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbaGHTev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:34:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54778 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755828AbaGHTed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:34:33 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johan Hovold" <jhovold@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.888799323@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 024/125] USB: sierra: fix AA deadlock in open error path
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 353fe198602e8b4d1c7bdcceb8e60955087201b1 upstream.

Fix AA deadlock in open error path that would call close() and try to
grab the already held disc_mutex.

Fixes: b9a44bc19f48 ("sierra: driver urb handling improvements")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/sierra.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -868,14 +868,9 @@ static int sierra_open(struct tty_struct
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
@@ -885,6 +880,16 @@ static int sierra_open(struct tty_struct
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
 
 

