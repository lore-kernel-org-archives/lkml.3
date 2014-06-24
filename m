Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965046AbaFXQxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:53:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60782 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbaFXPve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:51:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.4 11/26] USB: cdc-acm: fix write and resume race
Date: Tue, 24 Jun 2014 11:50:34 -0400
Message-Id: <20140624154620.046757206@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154619.499002156@linuxfoundation.org>
References: <20140624154619.499002156@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit e144ed28bed10684f9aaec6325ed974d53f76110 upstream.

Fix race between write() and resume() due to improper locking that could
lead to writes being reordered.

Resume must be done atomically and susp_count be protected by the
write_lock in order to prevent racing with write(). This could otherwise
lead to writes being reordered if write() grabs the write_lock after
susp_count is decremented, but before the delayed urb is submitted.

Fixes: 11ea859d64b6 ("USB: additional power savings for cdc-acm devices
that support remote wakeup")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1468,27 +1468,20 @@ static int acm_resume(struct usb_interfa
 	struct acm *acm = usb_get_intfdata(intf);
 	struct acm_wb *wb;
 	int rv = 0;
-	int cnt;
 
 	spin_lock_irq(&acm->read_lock);
-	acm->susp_count -= 1;
-	cnt = acm->susp_count;
-	spin_unlock_irq(&acm->read_lock);
+	spin_lock(&acm->write_lock);
 
-	if (cnt)
-		return 0;
+	if (--acm->susp_count)
+		goto out;
 
 	if (test_bit(ASYNCB_INITIALIZED, &acm->port.flags)) {
-		rv = usb_submit_urb(acm->ctrlurb, GFP_NOIO);
+		rv = usb_submit_urb(acm->ctrlurb, GFP_ATOMIC);
 
-		spin_lock_irq(&acm->write_lock);
 		if (acm->delayed_wb) {
 			wb = acm->delayed_wb;
 			acm->delayed_wb = NULL;
-			spin_unlock_irq(&acm->write_lock);
 			acm_start_wb(acm, wb);
-		} else {
-			spin_unlock_irq(&acm->write_lock);
 		}
 
 		/*
@@ -1496,12 +1489,14 @@ static int acm_resume(struct usb_interfa
 		 * do the write path at all cost
 		 */
 		if (rv < 0)
-			goto err_out;
+			goto out;
 
-		rv = acm_submit_read_urbs(acm, GFP_NOIO);
+		rv = acm_submit_read_urbs(acm, GFP_ATOMIC);
 	}
+out:
+	spin_unlock(&acm->write_lock);
+	spin_unlock_irq(&acm->read_lock);
 
-err_out:
 	return rv;
 }
 


