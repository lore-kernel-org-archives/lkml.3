Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbaF3MR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:17:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51984 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753321AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 059/181] USB: cdc-acm: fix write and resume race
Date: Mon, 30 Jun 2014 13:51:20 +0200
Message-Id: <cb7ae87692ed7a4696ff8857296a03a43852cca4.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/class/cdc-acm.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 8bde4781d347..19263a3f3d0d 100644
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
2.0.0

