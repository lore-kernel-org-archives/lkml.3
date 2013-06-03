Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054Ab3FCC7L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 22:59:11 -0400
Received: from mail.ispras.ru ([83.149.199.45]:50625 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab3FCC7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 22:59:08 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] staging/media: lirc_imon: fix leaks in imon_probe()
Date: Mon,  3 Jun 2013 06:58:49 +0400
Message-Id: <1370228329-10439-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Error handling of usb_submit_urb() is not as all others in imon_probe().
It just unlocks mutexes and returns nonzero leaving all already
allocated resources unfreed.

The patch makes sure all the resources are deallocated.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/media/lirc/lirc_imon.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index 0a2c45d..4afa7da 100644
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -911,8 +911,8 @@ static int imon_probe(struct usb_interface *interface,
 	if (retval) {
 		dev_err(dev, "%s: usb_submit_urb failed for intf0 (%d)\n",
 			__func__, retval);
-		mutex_unlock(&context->ctx_lock);
-		goto exit;
+		alloc_status = 8;
+		goto unlock;
 	}
 
 	usb_set_intfdata(interface, context);
@@ -937,6 +937,8 @@ unlock:
 alloc_status_switch:
 
 	switch (alloc_status) {
+	case 8:
+		lirc_unregister_driver(driver->minor);
 	case 7:
 		usb_free_urb(tx_urb);
 	case 6:
@@ -959,7 +961,6 @@ alloc_status_switch:
 		retval = 0;
 	}
 
-exit:
 	mutex_unlock(&driver_lock);
 
 	return retval;
-- 
1.8.1.2
