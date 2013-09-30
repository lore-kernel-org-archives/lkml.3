Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab3I3Kie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:38:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43380 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab3I3KLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:11:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Neukum <oneukum@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 012/104] USB: cdc-wdm: fix race between interrupt handler and tasklet
Date: Mon, 30 Sep 2013 11:09:49 +0100
Message-Id: <1380535881-9239-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit 6dd433e6cf2475ce8abec1b467720858c24450eb upstream.

Both could want to submit the same URB. Some checks of the flag
intended to prevent that were missing.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/class/cdc-wdm.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 97c1d8e..7c25710 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -233,6 +233,7 @@ skip_error:
 static void wdm_int_callback(struct urb *urb)
 {
 	int rv = 0;
+	int responding;
 	int status = urb->status;
 	struct wdm_device *desc;
 	struct usb_cdc_notification *dr;
@@ -286,8 +287,8 @@ static void wdm_int_callback(struct urb *urb)
 
 	spin_lock(&desc->iuspin);
 	clear_bit(WDM_READ, &desc->flags);
-	set_bit(WDM_RESPONDING, &desc->flags);
-	if (!test_bit(WDM_DISCONNECTING, &desc->flags)
+	responding = test_and_set_bit(WDM_RESPONDING, &desc->flags);
+	if (!responding && !test_bit(WDM_DISCONNECTING, &desc->flags)
 		&& !test_bit(WDM_SUSPENDING, &desc->flags)) {
 		rv = usb_submit_urb(desc->response, GFP_ATOMIC);
 		dev_dbg(&desc->intf->dev, "%s: usb_submit_urb %d",
@@ -691,16 +692,20 @@ static void wdm_rxwork(struct work_struct *work)
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
-- 
1.8.3.2

