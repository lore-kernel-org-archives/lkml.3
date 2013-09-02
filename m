Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393Ab3IBIzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:55:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37723 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758355Ab3IBIzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:55:12 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 22/58] USB: mos7720: fix broken control requests
Date: Mon,  2 Sep 2013 09:54:07 +0100
Message-Id: <1378112083-9475-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit ef6c8c1d733e244f0499035be0dabe1f4ed98c6f upstream.

The parallel-port code of the drivers used a stack allocated
control-request buffer for asynchronous (and possibly deferred) control
requests. This not only violates the no-DMA-from-stack requirement but
could also lead to corrupt control requests being submitted.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/mos7720.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 614ad93..9809fbc 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -97,6 +97,7 @@ struct urbtracker {
 	struct list_head        urblist_entry;
 	struct kref             ref_count;
 	struct urb              *urb;
+	struct usb_ctrlrequest	*setup;
 };
 
 enum mos7715_pp_modes {
@@ -278,6 +279,7 @@ static void destroy_urbtracker(struct kref *kref)
 	struct mos7715_parport *mos_parport = urbtrack->mos_parport;
 
 	usb_free_urb(urbtrack->urb);
+	kfree(urbtrack->setup);
 	kfree(urbtrack);
 	kref_put(&mos_parport->ref_count, destroy_mos_parport);
 }
@@ -360,7 +362,6 @@ static int write_parport_reg_nonblock(struct mos7715_parport *mos_parport,
 	struct urbtracker *urbtrack;
 	int ret_val;
 	unsigned long flags;
-	struct usb_ctrlrequest setup;
 	struct usb_serial *serial = mos_parport->serial;
 	struct usb_device *usbdev = serial->dev;
 
@@ -378,14 +379,20 @@ static int write_parport_reg_nonblock(struct mos7715_parport *mos_parport,
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
1.8.3.2

