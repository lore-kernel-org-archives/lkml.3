Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510AbaGHTRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:17:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54339 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755757AbaGHTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <jhovold@gmail.com>, "Xiao Jin" <jin.xiao@intel.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.916264710@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 036/125] USB: cdc-acm: fix broken runtime suspend
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 140cb81ac8c625942a1d695875932c615767a526 upstream.

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

Fixes: 11ea859d64b6 ("USB: additional power savings for cdc-acm devices
that support remote wakeup")

Reported-by: Xiao Jin <jin.xiao@intel.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/class/cdc-acm.c | 32 ++++++++++++++++++++++----------
 drivers/usb/class/cdc-acm.h |  2 +-
 2 files changed, 23 insertions(+), 11 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -183,12 +183,9 @@ static int acm_write_start(struct acm *a
 							acm->susp_count);
 	usb_autopm_get_interface_async(acm->control);
 	if (acm->susp_count) {
-		if (!acm->delayed_wb)
-			acm->delayed_wb = wb;
-		else
-			usb_autopm_put_interface_async(acm->control);
+		usb_anchor_urb(wb->urb, &acm->delayed);
 		spin_unlock_irqrestore(&acm->write_lock, flags);
-		return 0;	/* A white lie */
+		return 0;
 	}
 	usb_mark_last_busy(acm->dev);
 
@@ -545,11 +542,23 @@ static void acm_tty_unregister(struct ac
 
 static void acm_port_down(struct acm *acm)
 {
+	struct urb *urb;
+	struct acm_wb *wb;
 	int i;
 
 	if (acm->dev) {
 		usb_autopm_get_interface(acm->control);
 		acm_set_control(acm, acm->ctrlout = 0);
+
+		for (;;) {
+			urb = usb_get_from_anchor(&acm->delayed);
+			if (!urb)
+				break;
+			wb = urb->context;
+			wb->use = 0;
+			usb_autopm_put_interface_async(acm->control);
+		}
+
 		usb_kill_urb(acm->ctrlurb);
 		for (i = 0; i < ACM_NW; i++)
 			usb_kill_urb(acm->wb[i].urb);
@@ -1112,6 +1121,7 @@ made_compressed_probe:
 		acm->bInterval = epread->bInterval;
 	tty_port_init(&acm->port);
 	acm->port.ops = &acm_port_ops;
+	init_usb_anchor(&acm->delayed);
 
 	buf = usb_alloc_coherent(usb_dev, ctrlsize, GFP_KERNEL, &acm->ctrl_dma);
 	if (!buf) {
@@ -1369,7 +1379,7 @@ static int acm_suspend(struct usb_interf
 static int acm_resume(struct usb_interface *intf)
 {
 	struct acm *acm = usb_get_intfdata(intf);
-	struct acm_wb *wb;
+	struct urb *urb;
 	int rv = 0;
 
 	mutex_lock(&acm->mutex);
@@ -1382,10 +1392,12 @@ static int acm_resume(struct usb_interfa
 	if (acm->port.count) {
 		rv = usb_submit_urb(acm->ctrlurb, GFP_ATOMIC);
 
-		if (acm->delayed_wb) {
-			wb = acm->delayed_wb;
-			acm->delayed_wb = NULL;
-			acm_start_wb(acm, wb);
+		for (;;) {
+			urb = usb_get_from_anchor(&acm->delayed);
+			if (!urb)
+				break;
+
+			acm_start_wb(acm, urb->context);
 		}
 
 		/*
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -116,7 +116,7 @@ struct acm {
 	unsigned int throttled:1;			/* actually throttled */
 	unsigned int throttle_req:1;			/* throttle requested */
 	u8 bInterval;
-	struct acm_wb *delayed_wb;			/* write queued for a device about to be woken */
+	struct usb_anchor delayed;			/* writes queued for a device about to be woken */
 };
 
 #define CDC_DATA_INTERFACE_TYPE	0x0a

