Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbaF1TUy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 15:20:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbaF1RrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:47:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roger Quadros <rogerq@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.4 42/43] usb: usbtest: Add timetout to simple_io()
Date: Sat, 28 Jun 2014 10:46:33 -0700
Message-Id: <20140628174451.717863703@linuxfoundation.org>
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

From: Roger Quadros <rogerq@ti.com>

commit e5e4746510d140261918aecce2e5e3aa4456f7e9 upstream.

Without a timetout some tests e.g. test_halt() can remain stuck forever.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/usbtest.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -10,6 +10,7 @@
 #include <linux/timer.h>
 #include <linux/usb.h>
 
+#define SIMPLE_IO_TIMEOUT	10000	/* in milliseconds */
 
 /*-------------------------------------------------------------------------*/
 
@@ -355,6 +356,7 @@ static int simple_io(
 	int			max = urb->transfer_buffer_length;
 	struct completion	completion;
 	int			retval = 0;
+	unsigned long		expire;
 
 	urb->context = &completion;
 	while (retval == 0 && iterations-- > 0) {
@@ -367,9 +369,15 @@ static int simple_io(
 		if (retval != 0)
 			break;
 
-		/* NOTE:  no timeouts; can't be broken out of by interrupt */
-		wait_for_completion(&completion);
-		retval = urb->status;
+		expire = msecs_to_jiffies(SIMPLE_IO_TIMEOUT);
+		if (!wait_for_completion_timeout(&completion, expire)) {
+			usb_kill_urb(urb);
+			retval = (urb->status == -ENOENT ?
+				  -ETIMEDOUT : urb->status);
+		} else {
+			retval = urb->status;
+		}
+
 		urb->dev = udev;
 		if (retval == 0 && usb_pipein(urb->pipe))
 			retval = simple_check_buf(tdev, urb);


