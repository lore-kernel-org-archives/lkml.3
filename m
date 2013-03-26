Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965543Ab3CZPm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:42:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53960 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965210Ab3CZPXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:14 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 095/150] USB: garmin_gps: fix memory leak on disconnect
Date: Tue, 26 Mar 2013 15:19:54 +0000
Message-Id: <1364311249-14454-96-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 618aa1068df29c37a58045fe940f9106664153fd upstream.

Remove bogus disconnect test introduced by 95bef012e ("USB: more serial
drivers writing after disconnect") which prevented queued data from
being freed on disconnect.

The possible IO it was supposed to prevent is long gone.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/garmin_gps.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/usb/serial/garmin_gps.c b/drivers/usb/serial/garmin_gps.c
index 346c15a..3ae17e0 100644
--- a/drivers/usb/serial/garmin_gps.c
+++ b/drivers/usb/serial/garmin_gps.c
@@ -959,10 +959,7 @@ static void garmin_close(struct usb_serial_port *port)
 	if (!serial)
 		return;
 
-	mutex_lock(&port->serial->disc_mutex);
-
-	if (!port->serial->disconnected)
-		garmin_clear(garmin_data_p);
+	garmin_clear(garmin_data_p);
 
 	/* shutdown our urbs */
 	usb_kill_urb(port->read_urb);
@@ -971,8 +968,6 @@ static void garmin_close(struct usb_serial_port *port)
 	/* keep reset state so we know that we must start a new session */
 	if (garmin_data_p->state != STATE_RESET)
 		garmin_data_p->state = STATE_DISCONNECTED;
-
-	mutex_unlock(&port->serial->disc_mutex);
 }
 
 
-- 
1.8.1.2

