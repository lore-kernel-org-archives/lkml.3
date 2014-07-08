Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbaGHTTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:19:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54327 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755749AbaGHTIm (ORCPT
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
Message-ID: <lsq.1404846110.376121368@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 038/125] USB: cdc-acm: fix potential urb leak and PM
 imbalance in write
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

commit 183a45087d126d126e8dd1d9b2602fc129dff9ad upstream.

Make sure to check return value of autopm get in write() in order to
avoid urb leak and PM counter imbalance on errors.

Fixes: 11ea859d64b6 ("USB: additional power savings for cdc-acm devices
that support remote wakeup")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2:
 - Adjust context
 - Error/status variable is called rc, not stat]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/class/cdc-acm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -191,7 +191,13 @@ static int acm_write_start(struct acm *a
 
 	dev_vdbg(&acm->data->dev, "%s - susp_count %d\n", __func__,
 							acm->susp_count);
-	usb_autopm_get_interface_async(acm->control);
+	rc = usb_autopm_get_interface_async(acm->control);
+	if (rc) {
+		wb->use = 0;
+		spin_unlock_irqrestore(&acm->write_lock, flags);
+		return rc;
+	}
+
 	if (acm->susp_count) {
 		usb_anchor_urb(wb->urb, &acm->delayed);
 		spin_unlock_irqrestore(&acm->write_lock, flags);

