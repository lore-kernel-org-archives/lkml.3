Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbaLVKg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 05:36:56 -0500
Received: from regular2.263xmail.com ([211.157.152.4]:39272 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbaLVKgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 05:36:53 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: wulf@rock-chips.com
X-SENDER-IP: 104.167.231.20
X-LOGIN-NAME: wulf@rock-chips.com
X-UNIQUE-TAG: <c137333197bd3cb2306a97e014303d4d>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Wu Liang feng <wulf@rock-chips.com>
To: heiko@sntech.de
Cc: huangtao@rock-chips.com, kever.yang@rock-chips.com,
        eddie.cai@rock-chips.com, roy.li@rock-chips.com, zyw@rock-chips.com,
        jwerner@google.com, dianders@google.com, posciak@google.com,
        tfiga@google.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Wu Liang feng <wulf@rock-chips.com>
Subject: [PATCH 2/2] USB: ehci-platform: Support ehci reset after resume quirk
Date: Mon, 22 Dec 2014 18:36:28 +0800
Message-Id: <1419244588-5227-3-git-send-email-wulf@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1419244588-5227-1-git-send-email-wulf@rock-chips.com>
References: <1419244588-5227-1-git-send-email-wulf@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EHCI controller doesn't properly detect the case when
a device is removed during suspend. Specifically,when we
resume from suspend the EHCI controller maintaining the
USB state (FLAG_CF is 1 Current Connect Status is 1) but
a USB device (like a USB camera on rk3288) may have been
disconnected actually.

Let's add a quirk to force ehci to go into the
usb_root_hub_lost_power() path and reset after resume.
This should generally reset the whole controller and all
ports and initialize everything cleanly again, and bring
the devices back up.

As part of this, rename the "hibernation" paramter of
ehci_resume() to force_reset since hibernation is simply
another case where we can't trust the autodetected status
and need to force a reset of devices.

Signed-off-by: Wu Liang feng <wulf@rock-chips.com>
---
 drivers/usb/host/ehci-hcd.c      | 6 +++---
 drivers/usb/host/ehci-platform.c | 6 +++++-
 drivers/usb/host/ehci.h          | 2 +-
 include/linux/usb/ehci_pdriver.h | 3 +++
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 38bfeed..85e56d1 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1110,7 +1110,7 @@ int ehci_suspend(struct usb_hcd *hcd, bool do_wakeup)
 EXPORT_SYMBOL_GPL(ehci_suspend);
 
 /* Returns 0 if power was preserved, 1 if power was lost */
-int ehci_resume(struct usb_hcd *hcd, bool hibernated)
+int ehci_resume(struct usb_hcd *hcd, bool force_reset)
 {
 	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
 
@@ -1124,12 +1124,12 @@ int ehci_resume(struct usb_hcd *hcd, bool hibernated)
 		return 0;		/* Controller is dead */
 
 	/*
-	 * If CF is still set and we aren't resuming from hibernation
+	 * If CF is still set and reset isn't forced
 	 * then we maintained suspend power.
 	 * Just undo the effect of ehci_suspend().
 	 */
 	if (ehci_readl(ehci, &ehci->regs->configured_flag) == FLAG_CF &&
-			!hibernated) {
+			!force_reset) {
 		int	mask = INTR_MASK;
 
 		ehci_prepare_ports_for_controller_resume(ehci);
diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-platform.c
index 8557803..db5c29e 100644
--- a/drivers/usb/host/ehci-platform.c
+++ b/drivers/usb/host/ehci-platform.c
@@ -185,6 +185,10 @@ static int ehci_platform_probe(struct platform_device *dev)
 		if (of_property_read_bool(dev->dev.of_node, "big-endian"))
 			ehci->big_endian_mmio = ehci->big_endian_desc = 1;
 
+		if (of_property_read_bool(dev->dev.of_node,
+					  "needs-reset-on-resume"))
+			pdata->reset_on_resume = 1;
+
 		priv->phy = devm_phy_get(&dev->dev, "usb");
 		if (IS_ERR(priv->phy)) {
 			err = PTR_ERR(priv->phy);
@@ -340,7 +344,7 @@ static int ehci_platform_resume(struct device *dev)
 			return err;
 	}
 
-	ehci_resume(hcd, false);
+	ehci_resume(hcd, pdata->reset_on_resume);
 	return 0;
 }
 #endif /* CONFIG_PM_SLEEP */
diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
index 6f0577b..52ef084 100644
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -871,7 +871,7 @@ extern int	ehci_handshake(struct ehci_hcd *ehci, void __iomem *ptr,
 
 #ifdef CONFIG_PM
 extern int	ehci_suspend(struct usb_hcd *hcd, bool do_wakeup);
-extern int	ehci_resume(struct usb_hcd *hcd, bool hibernated);
+extern int	ehci_resume(struct usb_hcd *hcd, bool force_reset);
 #endif	/* CONFIG_PM */
 
 extern int	ehci_hub_control(struct usb_hcd	*hcd, u16 typeReq, u16 wValue,
diff --git a/include/linux/usb/ehci_pdriver.h b/include/linux/usb/ehci_pdriver.h
index 7eb4dcd..6287b39 100644
--- a/include/linux/usb/ehci_pdriver.h
+++ b/include/linux/usb/ehci_pdriver.h
@@ -34,6 +34,8 @@ struct usb_hcd;
  *			after initialization.
  * @no_io_watchdog:	set to 1 if the controller does not need the I/O
  *			watchdog to run.
+ * @reset_on_resume:	set to 1 if the controller needs to be reset after
+ * 			a suspend / resume cycle (but can't detect that itself).
  *
  * These are general configuration options for the EHCI controller. All of
  * these options are activating more or less workarounds for some hardware.
@@ -45,6 +47,7 @@ struct usb_ehci_pdata {
 	unsigned	big_endian_desc:1;
 	unsigned	big_endian_mmio:1;
 	unsigned	no_io_watchdog:1;
+	unsigned	reset_on_resume:1;
 
 	/* Turn on all power and clocks */
 	int (*power_on)(struct platform_device *pdev);
-- 
1.8.3.2


