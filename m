Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab3HRUus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:50:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029Ab3HRUdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:33:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 28/34] USB: mos7720: fix broken control requests
Date: Sun, 18 Aug 2013 13:34:41 -0700
Message-Id: <20130818203301.607431997@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203259.653403173@linuxfoundation.org>
References: <20130818203259.653403173@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit ef6c8c1d733e244f0499035be0dabe1f4ed98c6f upstream.

The parallel-port code of the drivers used a stack allocated
control-request buffer for asynchronous (and possibly deferred) control
requests. This not only violates the no-DMA-from-stack requirement but
could also lead to corrupt control requests being submitted.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mos7720.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -97,6 +97,7 @@ struct urbtracker {
 	struct list_head        urblist_entry;
 	struct kref             ref_count;
 	struct urb              *urb;
+	struct usb_ctrlrequest	*setup;
 };
 
 enum mos7715_pp_modes {
@@ -279,6 +280,7 @@ static void destroy_urbtracker(struct kr
 	struct mos7715_parport *mos_parport = urbtrack->mos_parport;
 	dbg("%s called", __func__);
 	usb_free_urb(urbtrack->urb);
+	kfree(urbtrack->setup);
 	kfree(urbtrack);
 	kref_put(&mos_parport->ref_count, destroy_mos_parport);
 }
@@ -363,7 +365,6 @@ static int write_parport_reg_nonblock(st
 	struct urbtracker *urbtrack;
 	int ret_val;
 	unsigned long flags;
-	struct usb_ctrlrequest setup;
 	struct usb_serial *serial = mos_parport->serial;
 	struct usb_device *usbdev = serial->dev;
 	dbg("%s called", __func__);
@@ -382,14 +383,20 @@ static int write_parport_reg_nonblock(st
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


