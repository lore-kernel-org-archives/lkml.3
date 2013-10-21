Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab3JUIuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:50:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39363 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753390Ab3JUIus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:50:48 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Oliver Neukum" <oneukum@suse.de>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.630563272@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 023/149] USB: cdc-wdm: fix race between interrupt
 handler and tasklet
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit 6dd433e6cf2475ce8abec1b467720858c24450eb upstream.

Both could want to submit the same URB. Some checks of the flag
intended to prevent that were missing.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/class/cdc-wdm.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -187,6 +187,7 @@ skip_error:
 static void wdm_int_callback(struct urb *urb)
 {
 	int rv = 0;
+	int responding;
 	int status = urb->status;
 	struct wdm_device *desc;
 	struct usb_ctrlrequest *req;
@@ -260,8 +261,8 @@ static void wdm_int_callback(struct urb
 	desc->response->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 	spin_lock(&desc->iuspin);
 	clear_bit(WDM_READ, &desc->flags);
-	set_bit(WDM_RESPONDING, &desc->flags);
-	if (!test_bit(WDM_DISCONNECTING, &desc->flags)
+	responding = test_and_set_bit(WDM_RESPONDING, &desc->flags);
+	if (!responding && !test_bit(WDM_DISCONNECTING, &desc->flags)
 		&& !test_bit(WDM_SUSPENDING, &desc->flags)) {
 		rv = usb_submit_urb(desc->response, GFP_ATOMIC);
 		dev_dbg(&desc->intf->dev, "%s: usb_submit_urb %d",
@@ -658,16 +659,20 @@ static void wdm_rxwork(struct work_struc
 {
 	struct wdm_device *desc = container_of(work, struct wdm_device, rxwork);
 	unsigned long flags;
-	int rv;
+	int rv = 0;
+	int responding;
 
 	spin_lock_irqsave(&desc->iuspin, flags);
 	if (test_bit(WDM_DISCONNECTING, &desc->flags)) {
 		spin_unlock_irqrestore(&desc->iuspin, flags);
 	} else {
+		responding = test_and_set_bit(WDM_RESPONDING, &desc->flags);
 		spin_unlock_irqrestore(&desc->iuspin, flags);
-		rv = usb_submit_urb(desc->response, GFP_KERNEL);
+		if (!responding)
+			rv = usb_submit_urb(desc->response, GFP_KERNEL);
 		if (rv < 0 && rv != -EPERM) {
 			spin_lock_irqsave(&desc->iuspin, flags);
+			clear_bit(WDM_RESPONDING, &desc->flags);
 			if (!test_bit(WDM_DISCONNECTING, &desc->flags))
 				schedule_work(&desc->rxwork);
 			spin_unlock_irqrestore(&desc->iuspin, flags);

