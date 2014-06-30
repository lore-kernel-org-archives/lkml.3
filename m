Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbaF3MC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:02:28 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52052 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753893AbaF3Lx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Roger Quadros <rogerq@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 094/181] usb: usbtest: Add timetout to simple_io()
Date: Mon, 30 Jun 2014 13:51:55 +0200
Message-Id: <5e13a4925da0ba2483d49f52fe8c049ec461c5ac.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e5e4746510d140261918aecce2e5e3aa4456f7e9 upstream.

Without a timetout some tests e.g. test_halt() can remain stuck forever.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/misc/usbtest.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index aa28ac8c7607..afe616b55f01 100644
--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -10,6 +10,7 @@
 
 #include <linux/usb.h>
 
+#define SIMPLE_IO_TIMEOUT	10000	/* in milliseconds */
 
 /*-------------------------------------------------------------------------*/
 
@@ -366,6 +367,7 @@ static int simple_io(
 	int			max = urb->transfer_buffer_length;
 	struct completion	completion;
 	int			retval = 0;
+	unsigned long		expire;
 
 	urb->context = &completion;
 	while (retval == 0 && iterations-- > 0) {
@@ -378,9 +380,15 @@ static int simple_io(
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
-- 
2.0.0

