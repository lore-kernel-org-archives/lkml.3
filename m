Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133Ab3ICQ3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:29:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46674 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757015Ab3ICQ33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:29:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 20/58] USB: mos7720: fix broken control requests
Date: Tue,  3 Sep 2013 09:23:24 -0700
Message-Id: <1378225442-20654-21-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit ef6c8c1d733e244f0499035be0dabe1f4ed98c6f upstream.

The parallel-port code of the drivers used a stack allocated
control-request buffer for asynchronous (and possibly deferred) control
requests. This not only violates the no-DMA-from-stack requirement but
could also lead to corrupt control requests being submitted.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/mos7720.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index d166d3a..397e028 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -91,6 +91,7 @@ struct urbtracker {
 	struct list_head        urblist_entry;
 	struct kref             ref_count;
 	struct urb              *urb;
+	struct usb_ctrlrequest	*setup;
 };
 
 enum mos7715_pp_modes {
@@ -272,6 +273,7 @@ static void destroy_urbtracker(struct kref *kref)
 	struct mos7715_parport *mos_parport = urbtrack->mos_parport;
 
 	usb_free_urb(urbtrack->urb);
+	kfree(urbtrack->setup);
 	kfree(urbtrack);
 	kref_put(&mos_parport->ref_count, destroy_mos_parport);
 }
@@ -356,7 +358,6 @@ static int write_parport_reg_nonblock(struct mos7715_parport *mos_parport,
 	struct urbtracker *urbtrack;
 	int ret_val;
 	unsigned long flags;
-	struct usb_ctrlrequest setup;
 	struct usb_serial *serial = mos_parport->serial;
 	struct usb_device *usbdev = serial->dev;
 
@@ -374,14 +375,20 @@ static int write_parport_reg_nonblock(struct mos7715_parport *mos_parport,
 		kfree(urbtrack);
 		return -ENOMEM;
 	}
-	setup.bRequestType = (__u8)0x40;
-	setup.bRequest = (__u8)0x0e;
-	setup.wValue = get_reg_value(reg, dummy);
-	setup.wIndex = get_reg_index(reg);
-	setup.wLength = 0;
+	urbtrack->setup = kmalloc(sizeof(*urbtrack->setup), GFP_KERNEL);
+	if (!urbtrack->setup) {
+		usb_free_urb(urbtrack->urb);
+		kfree(urbtrack);
+		return -ENOMEM;
+	}
+	urbtrack->setup->bRequestType = (__u8)0x40;
+	urbtrack->setup->bRequest = (__u8)0x0e;
+	urbtrack->setup->wValue = get_reg_value(reg, dummy);
+	urbtrack->setup->wIndex = get_reg_index(reg);
+	urbtrack->setup->wLength = 0;
 	usb_fill_control_urb(urbtrack->urb, usbdev,
 			     usb_sndctrlpipe(usbdev, 0),
-			     (unsigned char *)&setup,
+			     (unsigned char *)urbtrack->setup,
 			     NULL, 0, async_complete, urbtrack);
 	kref_init(&urbtrack->ref_count);
 	INIT_LIST_HEAD(&urbtrack->urblist_entry);
-- 
1.8.1.2

