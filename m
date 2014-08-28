Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965740AbaH1K13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:27:29 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39407 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934654AbaH1K03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:26:29 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] usb: phy: twl4030-usb: Fix lost interrupts after ID pin goes down
Date: Thu, 28 Aug 2014 15:55:03 +0530
Message-ID: <1409221506-6262-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409221506-6262-1-git-send-email-kishon@ti.com>
References: <1409221506-6262-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

Commit 249751f22380 ("usb: phy: twl4030-usb: poll for ID disconnect")
added twl4030_id_workaround_work() to deal with lost interrupts
after ID pin goes down. Looks like commit f1ddc24c9e33 ("usb: phy:
twl4030-usb: remove *set_suspend* and *phy_init* ops") changed
things around for the generic phy framework, and delayed work no
longer got called except initially during boot.

The PHY connect and disconnect interrupts for twl4030-usb are not
working after disconnecting a USB-A cable from the board, and the
deeper idle states for omap are blocked as the USB controller
stays busy.

The issue can be solved by calling delayed work from twl4030_usb_irq()
when ID pin is down and the PHY is not asleep like we already do
in twl4030_id_workaround_work().

But as both twl4030_usb_irq() and twl4030_id_workaround_work()
already do pretty much the same thing, let's call twl4030_usb_irq()
from twl4030_id_workaround_work() instead of adding some more
duplicate code. We also must call sysfs_notify() only when we have
an interrupt and not from the delayed work as notified by
Grazvydas Ignotas <notasas@gmail.com>.

Fixes: f1ddc24c9e33 ("usb: phy: twl4030-usb: remove *set_suspend* and *phy_init* ops")
Cc: stable@vger.kernel.org # v3.13+
Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-twl4030-usb.c |   33 ++++++++++-----------------------
 1 file changed, 10 insertions(+), 23 deletions(-)

diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
index 0cb872b..9cd33a4 100644
--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -589,7 +589,15 @@ static irqreturn_t twl4030_usb_irq(int irq, void *_twl)
 		}
 		omap_musb_mailbox(status);
 	}
-	sysfs_notify(&twl->dev->kobj, NULL, "vbus");
+
+	/* don't schedule during sleep - irq works right then */
+	if (status == OMAP_MUSB_ID_GROUND && !twl->asleep) {
+		cancel_delayed_work(&twl->id_workaround_work);
+		schedule_delayed_work(&twl->id_workaround_work, HZ);
+	}
+
+	if (irq)
+		sysfs_notify(&twl->dev->kobj, NULL, "vbus");
 
 	return IRQ_HANDLED;
 }
@@ -598,29 +606,8 @@ static void twl4030_id_workaround_work(struct work_struct *work)
 {
 	struct twl4030_usb *twl = container_of(work, struct twl4030_usb,
 		id_workaround_work.work);
-	enum omap_musb_vbus_id_status status;
-	bool status_changed = false;
-
-	status = twl4030_usb_linkstat(twl);
-
-	spin_lock_irq(&twl->lock);
-	if (status >= 0 && status != twl->linkstat) {
-		twl->linkstat = status;
-		status_changed = true;
-	}
-	spin_unlock_irq(&twl->lock);
-
-	if (status_changed) {
-		dev_dbg(twl->dev, "handle missing status change to %d\n",
-				status);
-		omap_musb_mailbox(status);
-	}
 
-	/* don't schedule during sleep - irq works right then */
-	if (status == OMAP_MUSB_ID_GROUND && !twl->asleep) {
-		cancel_delayed_work(&twl->id_workaround_work);
-		schedule_delayed_work(&twl->id_workaround_work, HZ);
-	}
+	twl4030_usb_irq(0, twl);
 }
 
 static int twl4030_phy_init(struct phy *phy)
-- 
1.7.9.5

