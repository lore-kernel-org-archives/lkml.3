Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbaGCJW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:22:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51777 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758423AbaGCJWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 066/198] USB: cdc-acm: fix write and resume race
Date: Thu,  3 Jul 2014 10:18:29 +0100
Message-Id: <1404379241-8590-67-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/class/cdc-acm.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 6ebcd38dfb06..2d9601da87b3 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1447,27 +1447,20 @@ static int acm_resume(struct usb_interface *intf)
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
@@ -1475,12 +1468,14 @@ static int acm_resume(struct usb_interface *intf)
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
 
-- 
1.9.1

