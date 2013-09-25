Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab3IYAIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:08:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab3IYAIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:08:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oliver Neukum <oneukum@suse.de>
Subject: [ 11/28] USB: cdc-wdm: fix race between interrupt handler and tasklet
Date: Tue, 24 Sep 2013 17:07:42 -0700
Message-Id: <20130925000651.128748740@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925000648.404447782@linuxfoundation.org>
References: <20130925000648.404447782@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit 6dd433e6cf2475ce8abec1b467720858c24450eb upstream.

Both could want to submit the same URB. Some checks of the flag
intended to prevent that were missing.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-wdm.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -171,6 +171,7 @@ skip_error:
 static void wdm_int_callback(struct urb *urb)
 {
 	int rv = 0;
+	int responding;
 	int status = urb->status;
 	struct wdm_device *desc;
 	struct usb_ctrlrequest *req;
@@ -244,8 +245,8 @@ static void wdm_int_callback(struct urb
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
@@ -635,16 +636,20 @@ static void wdm_rxwork(struct work_struc
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


