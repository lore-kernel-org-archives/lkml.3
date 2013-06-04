Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab3FDWmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:42:50 -0400
Received: from 1wt.eu ([62.212.114.60]:35557 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120Ab3FDWmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:45 -0400
Message-Id: <20130604172134.829188793@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:19 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 109/184] USB: garmin_gps: fix memory leak on disconnect
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 618aa1068df29c37a58045fe940f9106664153fd upstream.

Remove bogus disconnect test introduced by 95bef012e ("USB: more serial
drivers writing after disconnect") which prevented queued data from
being freed on disconnect.

The possible IO it was supposed to prevent is long gone.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/usb/serial/garmin_gps.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/usb/serial/garmin_gps.c b/drivers/usb/serial/garmin_gps.c
index 867d97b..7c3ac7b 100644
--- a/drivers/usb/serial/garmin_gps.c
+++ b/drivers/usb/serial/garmin_gps.c
@@ -974,10 +974,7 @@ static void garmin_close(struct usb_serial_port *port)
 	if (!serial)
 		return;
 
-	mutex_lock(&port->serial->disc_mutex);
-
-	if (!port->serial->disconnected)
-		garmin_clear(garmin_data_p);
+	garmin_clear(garmin_data_p);
 
 	/* shutdown our urbs */
 	usb_kill_urb(port->read_urb);
@@ -986,8 +983,6 @@ static void garmin_close(struct usb_serial_port *port)
 	/* keep reset state so we know that we must start a new session */
 	if (garmin_data_p->state != STATE_RESET)
 		garmin_data_p->state = STATE_DISCONNECTED;
-
-	mutex_unlock(&port->serial->disc_mutex);
 }
 
 
-- 
1.7.12.2.21.g234cd45.dirty



