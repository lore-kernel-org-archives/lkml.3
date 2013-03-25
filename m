Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab3CYBap (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:30:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33958 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755964Ab3CYBP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:56 -0400
Message-Id: <20130325010532.304885756@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:45 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 081/104] USB: garmin_gps: fix memory leak on disconnect
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 618aa1068df29c37a58045fe940f9106664153fd upstream.

Remove bogus disconnect test introduced by 95bef012e ("USB: more serial
drivers writing after disconnect") which prevented queued data from
being freed on disconnect.

The possible IO it was supposed to prevent is long gone.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/garmin_gps.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/usb/serial/garmin_gps.c
+++ b/drivers/usb/serial/garmin_gps.c
@@ -973,10 +973,7 @@ static void garmin_close(struct usb_seri
 	if (!serial)
 		return;
 
-	mutex_lock(&port->serial->disc_mutex);
-
-	if (!port->serial->disconnected)
-		garmin_clear(garmin_data_p);
+	garmin_clear(garmin_data_p);
 
 	/* shutdown our urbs */
 	usb_kill_urb(port->read_urb);
@@ -985,8 +982,6 @@ static void garmin_close(struct usb_seri
 	/* keep reset state so we know that we must start a new session */
 	if (garmin_data_p->state != STATE_RESET)
 		garmin_data_p->state = STATE_DISCONNECTED;
-
-	mutex_unlock(&port->serial->disc_mutex);
 }
 
 


