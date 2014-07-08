Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbaGHTLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:11:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54327 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754337AbaGHTJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:09:07 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <jhovold@gmail.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.34667820@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 034/125] USB: cdc-acm: fix write and suspend race
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

commit 5a345c20c17d87099224a4be12e69e5bd7023dca upstream.

Fix race between write() and suspend() which could lead to writes being
dropped (or I/O while suspended) if the device is runtime suspended
while a write request is being processed.

Specifically, suspend() releases the write_lock after determining the
device is idle but before incrementing the susp_count, thus leaving a
window where a concurrent write() can submit an urb.

Fixes: 11ea859d64b6 ("USB: additional power savings for cdc-acm devices
that support remote wakeup")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/class/cdc-acm.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1338,18 +1338,15 @@ static int acm_suspend(struct usb_interf
 	struct acm *acm = usb_get_intfdata(intf);
 	int cnt;
 
+	spin_lock_irq(&acm->read_lock);
+	spin_lock(&acm->write_lock);
 	if (PMSG_IS_AUTO(message)) {
-		int b;
-
-		spin_lock_irq(&acm->write_lock);
-		b = acm->transmitting;
-		spin_unlock_irq(&acm->write_lock);
-		if (b)
+		if (acm->transmitting) {
+			spin_unlock(&acm->write_lock);
+			spin_unlock_irq(&acm->read_lock);
 			return -EBUSY;
+		}
 	}
-
-	spin_lock_irq(&acm->read_lock);
-	spin_lock(&acm->write_lock);
 	cnt = acm->susp_count++;
 	spin_unlock(&acm->write_lock);
 	spin_unlock_irq(&acm->read_lock);

