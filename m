Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577AbaGHTRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:17:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54344 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755759AbaGHTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johan Hovold" <jhovold@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.849728407@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 035/125] USB: cdc-acm: fix write and resume race
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
[bwh: Backported to 3.2:
 - Adjust context
 - Move mutex_lock(acm->mutex) above acquisition of spinlocks]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/class/cdc-acm.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1371,28 +1371,21 @@ static int acm_resume(struct usb_interfa
 	struct acm *acm = usb_get_intfdata(intf);
 	struct acm_wb *wb;
 	int rv = 0;
-	int cnt;
 
+	mutex_lock(&acm->mutex);
 	spin_lock_irq(&acm->read_lock);
-	acm->susp_count -= 1;
-	cnt = acm->susp_count;
-	spin_unlock_irq(&acm->read_lock);
+	spin_lock(&acm->write_lock);
 
-	if (cnt)
-		return 0;
+	if (--acm->susp_count)
+		goto out;
 
-	mutex_lock(&acm->mutex);
 	if (acm->port.count) {
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
@@ -1400,13 +1393,15 @@ static int acm_resume(struct usb_interfa
 		 * do the write path at all cost
 		 */
 		if (rv < 0)
-			goto err_out;
+			goto out;
 
-		rv = acm_submit_read_urbs(acm, GFP_NOIO);
+		rv = acm_submit_read_urbs(acm, GFP_ATOMIC);
 	}
-
-err_out:
+out:
+	spin_unlock(&acm->write_lock);
+	spin_unlock_irq(&acm->read_lock);
 	mutex_unlock(&acm->mutex);
+
 	return rv;
 }
 

