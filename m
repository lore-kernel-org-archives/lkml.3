Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965023AbaDKJm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 05:42:26 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:43091 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585AbaDKJmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:42:21 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Oliver Neukum <oneukum@suse.de>, Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Xiao Jin <jin.xiao@intel.com>, david.a.cohen@linux.intel.com,
        yanmin.zhang@intel.com, Johan Hovold <jhovold@gmail.com>
Subject: [RFC 2/2] USB: cdc-acm: fix broken runtime suspend
Date: Fri, 11 Apr 2014 11:41:25 +0200
Message-Id: <1397209285-15471-2-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397209285-15471-1-git-send-email-jhovold@gmail.com>
References: <20140411093715.GA17522@localhost>
 <1397209285-15471-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current runtime suspend implementation is broken in several ways:

Firstly, it buffers only the first write request being made while
suspended -- any further writes are silently dropped.

Secondly, writes being dropped also leak write urbs which are never
reclaimed (until the device is unbound).

Thirdly, even the single buffered write is not cleared at shutdown
(which may happen before the device is resumed), something which can
lead to another urb leak.

Fix this by simple removing the broken and redundant buffer
implementation from the driver, and rely on the tty buffers instead.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/class/cdc-acm.c | 28 +++++++---------------------
 drivers/usb/class/cdc-acm.h |  1 -
 2 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 900f7ff805ee..c85bf3062bba 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -646,12 +646,10 @@ static int acm_tty_write(struct tty_struct *tty,
 
 	usb_autopm_get_interface_async(acm->control);
 	if (acm->susp_count) {
-		if (!acm->delayed_wb)
-			acm->delayed_wb = wb;
-		else
-			usb_autopm_put_interface_async(acm->control);
+		wb->use = 0;
+		usb_autopm_put_interface_async(acm->control);
 		spin_unlock_irqrestore(&acm->write_lock, flags);
-		return count;	/* A white lie */
+		return 0;
 	}
 	usb_mark_last_busy(acm->dev);
 
@@ -1540,7 +1538,6 @@ static int acm_suspend(struct usb_interface *intf, pm_message_t message)
 static int acm_resume(struct usb_interface *intf)
 {
 	struct acm *acm = usb_get_intfdata(intf);
-	struct acm_wb *wb;
 	int rv = 0;
 	int cnt;
 
@@ -1554,25 +1551,14 @@ static int acm_resume(struct usb_interface *intf)
 
 	if (test_bit(ASYNCB_INITIALIZED, &acm->port.flags)) {
 		rv = usb_submit_urb(acm->ctrlurb, GFP_NOIO);
-
-		spin_lock_irq(&acm->write_lock);
-		if (acm->delayed_wb) {
-			wb = acm->delayed_wb;
-			acm->delayed_wb = NULL;
-			spin_unlock_irq(&acm->write_lock);
-			acm_start_wb(acm, wb);
-		} else {
-			spin_unlock_irq(&acm->write_lock);
-		}
-
-		/*
-		 * delayed error checking because we must
-		 * do the write path at all cost
-		 */
 		if (rv < 0)
 			goto err_out;
 
 		rv = acm_submit_read_urbs(acm, GFP_NOIO);
+		if (rv < 0)
+			goto err_out;
+
+		schedule_work(&acm->work);
 	}
 
 err_out:
diff --git a/drivers/usb/class/cdc-acm.h b/drivers/usb/class/cdc-acm.h
index e38dc785808f..538bb1b3b0bc 100644
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -120,7 +120,6 @@ struct acm {
 	unsigned int throttled:1;			/* actually throttled */
 	unsigned int throttle_req:1;			/* throttle requested */
 	u8 bInterval;
-	struct acm_wb *delayed_wb;			/* write queued for a device about to be woken */
 };
 
 #define CDC_DATA_INTERFACE_TYPE	0x0a
-- 
1.8.3.2

