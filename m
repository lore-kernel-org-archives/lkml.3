Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934847Ab3FSOHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 10:07:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56802 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934775Ab3FSOGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 10:06:31 -0400
From: Roger Quadros <rogerq@ti.com>
To: <stern@rowland.harvard.edu>, <tony@atomide.com>
CC: <balbi@ti.com>, <ruslan.bilovol@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 3/6] USB: ehci: allow controller drivers to override irq & bus_suspend/resume
Date: Wed, 19 Jun 2013 17:05:50 +0300
Message-ID: <1371650753-11452-4-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371650753-11452-1-git-send-email-rogerq@ti.com>
References: <1371650753-11452-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers (e.g. ehci_omap) need to do additional work in
bus suspend/resume and interrupt handler to support low power
modes and remote wakeup.
Allow drivers to override these functions through ehci_driver_overrides.

Also export the ehci_irq(), ehci_bus_suspend() and ehci_bus_resume()
functions so they can be called from the controller drivers.

CC: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/host/ehci-hcd.c |    9 ++++++++-
 drivers/usb/host/ehci-hub.c |    6 ++++--
 drivers/usb/host/ehci.h     |    6 ++++++
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 246e124..8d35dd4 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -681,7 +681,7 @@ EXPORT_SYMBOL_GPL(ehci_setup);
 
 /*-------------------------------------------------------------------------*/
 
-static irqreturn_t ehci_irq (struct usb_hcd *hcd)
+irqreturn_t ehci_irq(struct usb_hcd *hcd)
 {
 	struct ehci_hcd		*ehci = hcd_to_ehci (hcd);
 	u32			status, masked_status, pcd_status = 0, cmd;
@@ -828,6 +828,7 @@ dead:
 		usb_hcd_poll_rh_status(hcd);
 	return IRQ_HANDLED;
 }
+EXPORT_SYMBOL_GPL(ehci_irq);
 
 /*-------------------------------------------------------------------------*/
 
@@ -1211,6 +1212,12 @@ void ehci_init_driver(struct hc_driver *drv,
 		drv->hcd_priv_size += over->extra_priv_size;
 		if (over->reset)
 			drv->reset = over->reset;
+		if (over->bus_suspend)
+			drv->bus_suspend = over->bus_suspend;
+		if (over->bus_resume)
+			drv->bus_resume = over->bus_resume;
+		if (over->irq)
+			drv->irq = over->irq;
 	}
 }
 EXPORT_SYMBOL_GPL(ehci_init_driver);
diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 9ab4a4d..1fc03f9 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -218,7 +218,7 @@ static void ehci_adjust_port_wakeup_flags(struct ehci_hcd *ehci,
 	spin_unlock_irq(&ehci->lock);
 }
 
-static int ehci_bus_suspend (struct usb_hcd *hcd)
+int ehci_bus_suspend(struct usb_hcd *hcd)
 {
 	struct ehci_hcd		*ehci = hcd_to_ehci (hcd);
 	int			port;
@@ -348,10 +348,11 @@ static int ehci_bus_suspend (struct usb_hcd *hcd)
 	hrtimer_cancel(&ehci->hrtimer);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ehci_bus_suspend);
 
 
 /* caller has locked the root hub, and should reset/reinit on error */
-static int ehci_bus_resume (struct usb_hcd *hcd)
+int ehci_bus_resume(struct usb_hcd *hcd)
 {
 	struct ehci_hcd		*ehci = hcd_to_ehci (hcd);
 	u32			temp;
@@ -489,6 +490,7 @@ static int ehci_bus_resume (struct usb_hcd *hcd)
 	spin_unlock_irq(&ehci->lock);
 	return -ESHUTDOWN;
 }
+EXPORT_SYMBOL_GPL(ehci_bus_resume);
 
 #else
 
diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
index 7c978b2..992d626 100644
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -795,15 +795,21 @@ static inline u32 hc32_to_cpup (const struct ehci_hcd *ehci, const __hc32 *x)
 struct ehci_driver_overrides {
 	size_t		extra_priv_size;
 	int		(*reset)(struct usb_hcd *hcd);
+	int		(*bus_suspend)(struct usb_hcd *hcd);
+	int		(*bus_resume)(struct usb_hcd *hcd);
+	irqreturn_t	(*irq) (struct usb_hcd *hcd);
 };
 
 extern void	ehci_init_driver(struct hc_driver *drv,
 				const struct ehci_driver_overrides *over);
 extern int	ehci_setup(struct usb_hcd *hcd);
+extern irqreturn_t ehci_irq(struct usb_hcd *hcd);
 
 #ifdef CONFIG_PM
 extern int	ehci_suspend(struct usb_hcd *hcd, bool do_wakeup);
 extern int	ehci_resume(struct usb_hcd *hcd, bool hibernated);
+extern int	ehci_bus_suspend(struct usb_hcd *hcd);
+extern int	ehci_bus_resume(struct usb_hcd *hcd);
 #endif	/* CONFIG_PM */
 
 #endif /* __LINUX_EHCI_HCD_H */
-- 
1.7.4.1

