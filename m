Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934407Ab3CHQvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 11:51:14 -0500
Received: from mail.ispras.ru ([83.149.199.45]:56702 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933517Ab3CHQvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 11:51:13 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Hans de Goede <hdegoede@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] usb/core/devio.c: Don't use GFP_KERNEL while we cannot reset a storage device
Date: Sat,  9 Mar 2013 00:50:47 +0800
Message-Id: <1362761447-24643-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As it was described by Oliver Neukum in commit acbe2fe
"USB: Don't use GFP_KERNEL while we cannot reset a storage device":

  Memory allocations with GFP_KERNEL can cause IO to a storage device
  which can fail resulting in a need to reset the device. Therefore
  GFP_KERNEL cannot be safely used between usb_lock_device()
  and usb_unlock_device(). Replace by GFP_NOIO.

The patch fixes the same issue in usb/core/devio.c.
All the allocations fixed are under usb_lock_device() from usbdev_do_ioctl().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/usb/core/devio.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 8823e98..4be27e3 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -275,10 +275,10 @@ static struct async *alloc_async(unsigned int numisoframes)
 {
 	struct async *as;
 
-	as = kzalloc(sizeof(struct async), GFP_KERNEL);
+	as = kzalloc(sizeof(struct async), GFP_NOIO);
 	if (!as)
 		return NULL;
-	as->urb = usb_alloc_urb(numisoframes, GFP_KERNEL);
+	as->urb = usb_alloc_urb(numisoframes, GFP_NOIO);
 	if (!as->urb) {
 		kfree(as);
 		return NULL;
@@ -887,7 +887,7 @@ static int proc_control(struct dev_state *ps, void __user *arg)
 			sizeof(struct usb_ctrlrequest));
 	if (ret)
 		return ret;
-	tbuf = (unsigned char *)__get_free_page(GFP_KERNEL);
+	tbuf = (unsigned char *)__get_free_page(GFP_NOIO);
 	if (!tbuf) {
 		ret = -ENOMEM;
 		goto done;
@@ -983,7 +983,7 @@ static int proc_bulk(struct dev_state *ps, void __user *arg)
 	ret = usbfs_increase_memory_usage(len1 + sizeof(struct urb));
 	if (ret)
 		return ret;
-	if (!(tbuf = kmalloc(len1, GFP_KERNEL))) {
+	if (!(tbuf = kmalloc(len1, GFP_NOIO))) {
 		ret = -ENOMEM;
 		goto done;
 	}
@@ -1211,7 +1211,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 		/* min 8 byte setup packet */
 		if (uurb->buffer_length < 8)
 			return -EINVAL;
-		dr = kmalloc(sizeof(struct usb_ctrlrequest), GFP_KERNEL);
+		dr = kmalloc(sizeof(struct usb_ctrlrequest), GFP_NOIO);
 		if (!dr)
 			return -ENOMEM;
 		if (copy_from_user(dr, uurb->buffer, 8)) {
@@ -1278,7 +1278,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 			return -EINVAL;
 		isofrmlen = sizeof(struct usbdevfs_iso_packet_desc) *
 				   uurb->number_of_packets;
-		if (!(isopkt = kmalloc(isofrmlen, GFP_KERNEL)))
+		if (!(isopkt = kmalloc(isofrmlen, GFP_NOIO)))
 			return -ENOMEM;
 		if (copy_from_user(isopkt, iso_frame_desc, isofrmlen)) {
 			ret = -EFAULT;
@@ -1326,7 +1326,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 
 	if (num_sgs) {
 		as->urb->sg = kmalloc(num_sgs * sizeof(struct scatterlist),
-				      GFP_KERNEL);
+				      GFP_NOIO);
 		if (!as->urb->sg) {
 			ret = -ENOMEM;
 			goto error;
@@ -1337,7 +1337,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 		totlen = uurb->buffer_length;
 		for (i = 0; i < as->urb->num_sgs; i++) {
 			u = (totlen > USB_SG_SIZE) ? USB_SG_SIZE : totlen;
-			buf = kmalloc(u, GFP_KERNEL);
+			buf = kmalloc(u, GFP_NOIO);
 			if (!buf) {
 				ret = -ENOMEM;
 				goto error;
@@ -1355,7 +1355,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 		}
 	} else if (uurb->buffer_length > 0) {
 		as->urb->transfer_buffer = kmalloc(uurb->buffer_length,
-				GFP_KERNEL);
+				GFP_NOIO);
 		if (!as->urb->transfer_buffer) {
 			ret = -ENOMEM;
 			goto error;
@@ -1467,7 +1467,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 			ret = usb_submit_urb(as->urb, GFP_ATOMIC);
 		spin_unlock_irq(&ps->lock);
 	} else {
-		ret = usb_submit_urb(as->urb, GFP_KERNEL);
+		ret = usb_submit_urb(as->urb, GFP_NOIO);
 	}
 
 	if (ret) {
@@ -1798,7 +1798,7 @@ static int proc_ioctl(struct dev_state *ps, struct usbdevfs_ioctl *ctl)
 
 	/* alloc buffer */
 	if ((size = _IOC_SIZE(ctl->ioctl_code)) > 0) {
-		if ((buf = kmalloc(size, GFP_KERNEL)) == NULL)
+		if ((buf = kmalloc(size, GFP_NOIO)) == NULL)
 			return -ENOMEM;
 		if ((_IOC_DIR(ctl->ioctl_code) & _IOC_WRITE)) {
 			if (copy_from_user(buf, ctl->data, size)) {
-- 
1.7.9.5

