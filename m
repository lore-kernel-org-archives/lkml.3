Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab3CZXDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:03:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53484 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756910Ab3CZXCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 19:02:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 40/49] USB: garmin_gps: fix memory leak on disconnect
Date: Tue, 26 Mar 2013 16:01:37 -0700
Message-Id: <20130326225843.736157724@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326225839.554028294@linuxfoundation.org>
References: <20130326225839.554028294@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 618aa1068df29c37a58045fe940f9106664153fd upstream.

Remove bogus disconnect test introduced by 95bef012e ("USB: more serial
drivers writing after disconnect") which prevented queued data from
being freed on disconnect.

The possible IO it was supposed to prevent is long gone.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
 
 


