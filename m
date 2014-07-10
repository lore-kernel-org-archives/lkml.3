Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbaGJBHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 21:07:05 -0400
Received: from mail-yh0-f74.google.com ([209.85.213.74]:53830 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbaGJBFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 21:05:55 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Julius Werner <jwerner@chromium.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH 2/4] xhci: Check for XHCI_COMP_MODE_QUIRK when disabling D3cold
Date: Wed,  9 Jul 2014 18:05:48 -0700
Message-Id: <1404954350-26343-3-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1404954350-26343-1-git-send-email-abrestic@chromium.org>
References: <1404954350-26343-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of calling xhci_compliance_mode_recovery_timer_quirk_check() again
in the PCI suspend path, just check for XHCI_COMP_MODE_QUIRK which will
have been set based on xhci_compliance_mode_recovery_timer_quirk_check()
in xhci_init().

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/usb/host/xhci-pci.c | 2 +-
 drivers/usb/host/xhci.c     | 3 ++-
 drivers/usb/host/xhci.h     | 3 ---
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 97648e4..d06ffe7 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -277,7 +277,7 @@ static int xhci_pci_suspend(struct usb_hcd *hcd, bool do_wakeup)
 	 * Systems with the TI redriver that loses port status change events
 	 * need to have the registers polled during D3, so avoid D3cold.
 	 */
-	if (xhci_compliance_mode_recovery_timer_quirk_check())
+	if (xhci->quirks & XHCI_COMP_MODE_QUIRK)
 		pdev->no_d3cold = true;
 
 	return xhci_suspend(xhci);
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 8de75b7..f681087 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -491,7 +491,7 @@ static void compliance_mode_recovery_timer_init(struct xhci_hcd *xhci)
  * Systems:
  * Vendor: Hewlett-Packard -> System Models: Z420, Z620 and Z820
  */
-bool xhci_compliance_mode_recovery_timer_quirk_check(void)
+static bool xhci_compliance_mode_recovery_timer_quirk_check(void)
 {
 	const char *dmi_product_name, *dmi_sys_vendor;
 
@@ -4936,6 +4936,7 @@ static const struct hc_driver xhci_hc_driver = {
 
 void xhci_init_driver(struct hc_driver *drv, int (*setup_fn)(struct usb_hcd *))
 {
+	BUG_ON(!setup_fn);
 	*drv = xhci_hc_driver;
 	drv->reset = setup_fn;
 }
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 0d9b2cf..902f55b 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1886,7 +1886,4 @@ struct xhci_input_control_ctx *xhci_get_input_control_ctx(struct xhci_hcd *xhci,
 struct xhci_slot_ctx *xhci_get_slot_ctx(struct xhci_hcd *xhci, struct xhci_container_ctx *ctx);
 struct xhci_ep_ctx *xhci_get_ep_ctx(struct xhci_hcd *xhci, struct xhci_container_ctx *ctx, unsigned int ep_index);
 
-/* xHCI quirks */
-bool xhci_compliance_mode_recovery_timer_quirk_check(void);
-
 #endif /* __LINUX_XHCI_HCD_H */
-- 
2.0.0.526.g5318336

