Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab3IKE7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:59:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab3IKE46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:58 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=_UtqrmwR0vEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Sx4qtyAM1UgA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=_picTQVsrCXNaikNwXkA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042926.952725867@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [209/251] USB: mos7720: fix broken control requests
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0209-USB-mos7720-fix-broken-control-requests.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

[ Upstream commit ef6c8c1d733e244f0499035be0dabe1f4ed98c6f ]

The parallel-port code of the drivers used a stack allocated
control-request buffer for asynchronous (and possibly deferred) control
requests. This not only violates the no-DMA-from-stack requirement but
could also lead to corrupt control requests being submitted.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/mos7720.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index b691404..3d3b53d 100644
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
1.7.10.4


