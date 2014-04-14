Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbaDNT7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 15:59:05 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:33239 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbaDNT7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 15:59:02 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Oliver Neukum <oneukum@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Xiao Jin <jin.xiao@intel.com>, david.a.cohen@linux.intel.com,
        yanmin.zhang@intel.com, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH] USB: cdc-acm: fix broken runtime suspend
Date: Mon, 14 Apr 2014 21:58:12 +0200
Message-Id: <1397505492-10018-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20140411093715.GA17522@localhost>
References: <20140411093715.GA17522@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current ACM runtime-suspend implementation is broken in several
ways:

Firstly, it buffers only the first write request being made while
suspended -- any further writes are silently dropped.

Secondly, writes being dropped also leak write urbs, which are never
reclaimed (until the device is unbound).

Thirdly, even the single buffered write is not cleared at shutdown
(which may happen before the device is resumed), something which can
lead to another urb leak as well as a PM usage-counter leak.

Fix this by implementing a delayed-write queue using urb anchors and
making sure to discard the queue properly at shutdown.

Reported-by: Xiao Jin <jin.xiao@intel.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---

Let's fix the current runtime-suspend implementation before considering
adding a write fifo. 

Since this has never really worked, I'll let someone else decide whether
the fix should be back-ported to stable or not.

Jin, did you check what closing_wait setting your application is using?
Could you give this patch a try as well?

Thanks,
Johan


 drivers/usb/class/cdc-acm.c | 36 +++++++++++++++++++++++-------------
 drivers/usb/class/cdc-acm.h |  2 +-
 2 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 900f7ff805ee..ebbcc7a6a7c8 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -571,6 +571,8 @@ static void acm_port_destruct(struct tty_port *port)
 static void acm_port_shutdown(struct tty_port *port)
 {
 	struct acm *acm = container_of(port, struct acm, port);
+	struct urb *urb;
+	struct acm_wb *wb;
 	int i;
 
 	dev_dbg(&acm->control->dev, "%s\n", __func__);
@@ -578,6 +580,16 @@ static void acm_port_shutdown(struct tty_port *port)
 	mutex_lock(&acm->mutex);
 	if (!acm->disconnected) {
 		usb_autopm_get_interface(acm->control);
+		spin_lock_irq(&acm->write_lock);
+		for (;;) {
+			urb = usb_get_from_anchor(&acm->delayed);
+			if (!urb)
+				break;
+			wb = urb->context;
+			wb->use = 0;
+			usb_autopm_put_interface_async(acm->control);
+		}
+		spin_unlock_irq(&acm->write_lock);
 		acm_set_control(acm, acm->ctrlout = 0);
 		usb_kill_urb(acm->ctrlurb);
 		for (i = 0; i < ACM_NW; i++)
@@ -646,12 +658,9 @@ static int acm_tty_write(struct tty_struct *tty,
 
 	usb_autopm_get_interface_async(acm->control);
 	if (acm->susp_count) {
-		if (!acm->delayed_wb)
-			acm->delayed_wb = wb;
-		else
-			usb_autopm_put_interface_async(acm->control);
+		usb_anchor_urb(wb->urb, &acm->delayed);
 		spin_unlock_irqrestore(&acm->write_lock, flags);
-		return count;	/* A white lie */
+		return count;
 	}
 	usb_mark_last_busy(acm->dev);
 
@@ -1267,6 +1276,7 @@ made_compressed_probe:
 		acm->bInterval = epread->bInterval;
 	tty_port_init(&acm->port);
 	acm->port.ops = &acm_port_ops;
+	init_usb_anchor(&acm->delayed);
 
 	buf = usb_alloc_coherent(usb_dev, ctrlsize, GFP_KERNEL, &acm->ctrl_dma);
 	if (!buf) {
@@ -1540,7 +1550,7 @@ static int acm_suspend(struct usb_interface *intf, pm_message_t message)
 static int acm_resume(struct usb_interface *intf)
 {
 	struct acm *acm = usb_get_intfdata(intf);
-	struct acm_wb *wb;
+	struct urb *urb;
 	int rv = 0;
 	int cnt;
 
@@ -1556,14 +1566,14 @@ static int acm_resume(struct usb_interface *intf)
 		rv = usb_submit_urb(acm->ctrlurb, GFP_NOIO);
 
 		spin_lock_irq(&acm->write_lock);
-		if (acm->delayed_wb) {
-			wb = acm->delayed_wb;
-			acm->delayed_wb = NULL;
-			spin_unlock_irq(&acm->write_lock);
-			acm_start_wb(acm, wb);
-		} else {
-			spin_unlock_irq(&acm->write_lock);
+		for (;;) {
+			urb = usb_get_from_anchor(&acm->delayed);
+			if (!urb)
+				break;
+
+			acm_start_wb(acm, urb->context);
 		}
+		spin_unlock_irq(&acm->write_lock);
 
 		/*
 		 * delayed error checking because we must
diff --git a/drivers/usb/class/cdc-acm.h b/drivers/usb/class/cdc-acm.h
index e38dc785808f..80826f843e04 100644
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -120,7 +120,7 @@ struct acm {
 	unsigned int throttled:1;			/* actually throttled */
 	unsigned int throttle_req:1;			/* throttle requested */
 	u8 bInterval;
-	struct acm_wb *delayed_wb;			/* write queued for a device about to be woken */
+	struct usb_anchor delayed;			/* writes queued for a device about to be woken */
 };
 
 #define CDC_DATA_INTERFACE_TYPE	0x0a
-- 
1.8.3.2

