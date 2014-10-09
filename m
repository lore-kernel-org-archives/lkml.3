Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbaJIVEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:04:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58944 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaJIVD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:03:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tony Lindgren <tony@atomide.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 008/163] usb: phy: twl4030-usb: Fix lost interrupts after ID pin goes down
Date: Thu,  9 Oct 2014 14:00:33 -0700
Message-Id: <1412888588-26755-9-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

commit 85601b8d81e24ce9ae2d31e93f35468ab7616b18 upstream.

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
Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/phy/phy-twl4030-usb.c | 33 ++++++++++-----------------------
 1 file changed, 10 insertions(+), 23 deletions(-)

diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
index daf65e6..70b513a 100644
--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -560,7 +560,15 @@ static irqreturn_t twl4030_usb_irq(int irq, void *_twl)
 		 */
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
@@ -569,29 +577,8 @@ static void twl4030_id_workaround_work(struct work_struct *work)
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
1.9.1

