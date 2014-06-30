Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbaF3MRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:17:35 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51968 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753259AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 058/181] USB: cdc-acm: fix write and suspend race
Date: Mon, 30 Jun 2014 13:51:19 +0200
Message-Id: <6bdf0862d98dd3431ea70f942d3a8a67609e7139.1404128998.git.jslaby@suse.cz>
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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/class/cdc-acm.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 0b5e381bcbe6..8bde4781d347 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1420,18 +1420,15 @@ static int acm_suspend(struct usb_interface *intf, pm_message_t message)
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
-- 
2.0.0

