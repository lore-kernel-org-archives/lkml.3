Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab3HLNJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:09:04 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:2372 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313Ab3HLNHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:07:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 12 Aug 2013 06:07:07 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <balbi@ti.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        Matthieu CASTET <matthieu.castet@parrot.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v3 1/6] usb: host: add has_tdi_phy_lpm capability bit
Date: Mon, 12 Aug 2013 16:06:49 +0300
Message-ID: <1376312814-18992-2-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376312814-18992-1-git-send-email-ttynkkynen@nvidia.com>
References: <1376312814-18992-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The has_hostpc capability bit indicates that the host controller has the
HOSTPC register extensions, but at the same time enables clock disabling
power saving features with the PHY Low Power Clock Disable (PHCD) bit.

However, some host controllers have the HOSTPC extensions but don't
support the low-power feature, so the PHCD bit must not be set on those
controllers. Add a separate capability bit for the low-power feature
instead, and change all existing users of has_hostpc to use this new
capability bit.

The idea for this commit is taken from an old 2012 commit that never got
merged ("disociate chipidea PHY low power suspend control from hostpc")

Inspired-by: Matthieu CASTET <matthieu.castet@parrot.com>
Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Stephen Warren <swarren@nvidia.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
---
v2: Add Alan's ack
 drivers/usb/chipidea/host.c |  1 +
 drivers/usb/host/ehci-hub.c | 14 +++++++-------
 drivers/usb/host/ehci.h     |  1 +
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
index 40d0fda..9b3aaf1 100644
--- a/drivers/usb/chipidea/host.c
+++ b/drivers/usb/chipidea/host.c
@@ -63,6 +63,7 @@ static int host_start(struct ci_hdrc *ci)
 	ehci = hcd_to_ehci(hcd);
 	ehci->caps = ci->hw_bank.cap;
 	ehci->has_hostpc = ci->hw_bank.lpm;
+	ehci->has_tdi_phy_lpm = ci->hw_bank.lpm;
 
 	ret = usb_add_hcd(hcd, 0, 0);
 	if (ret)
diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 6e69ee1..6d5ad37 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -183,7 +183,7 @@ static void ehci_adjust_port_wakeup_flags(struct ehci_hcd *ehci,
 	spin_lock_irq(&ehci->lock);
 
 	/* clear phy low-power mode before changing wakeup flags */
-	if (ehci->has_hostpc) {
+	if (ehci->has_tdi_phy_lpm) {
 		port = HCS_N_PORTS(ehci->hcs_params);
 		while (port--) {
 			u32 __iomem	*hostpc_reg = &ehci->regs->hostpc[port];
@@ -217,7 +217,7 @@ static void ehci_adjust_port_wakeup_flags(struct ehci_hcd *ehci,
 	}
 
 	/* enter phy low-power mode again */
-	if (ehci->has_hostpc) {
+	if (ehci->has_tdi_phy_lpm) {
 		port = HCS_N_PORTS(ehci->hcs_params);
 		while (port--) {
 			u32 __iomem	*hostpc_reg = &ehci->regs->hostpc[port];
@@ -309,7 +309,7 @@ static int ehci_bus_suspend (struct usb_hcd *hcd)
 		}
 	}
 
-	if (changed && ehci->has_hostpc) {
+	if (changed && ehci->has_tdi_phy_lpm) {
 		spin_unlock_irq(&ehci->lock);
 		msleep(5);	/* 5 ms for HCD to enter low-power mode */
 		spin_lock_irq(&ehci->lock);
@@ -435,7 +435,7 @@ static int ehci_bus_resume (struct usb_hcd *hcd)
 		goto shutdown;
 
 	/* clear phy low-power mode before resume */
-	if (ehci->bus_suspended && ehci->has_hostpc) {
+	if (ehci->bus_suspended && ehci->has_tdi_phy_lpm) {
 		i = HCS_N_PORTS(ehci->hcs_params);
 		while (i--) {
 			if (test_bit(i, &ehci->bus_suspended)) {
@@ -788,7 +788,7 @@ static int ehci_hub_control (
 				goto error;
 
 			/* clear phy low-power mode before resume */
-			if (ehci->has_hostpc) {
+			if (ehci->has_tdi_phy_lpm) {
 				temp1 = ehci_readl(ehci, hostpc_reg);
 				ehci_writel(ehci, temp1 & ~HOSTPC_PHCD,
 						hostpc_reg);
@@ -1025,12 +1025,12 @@ static int ehci_hub_control (
 
 			/* After above check the port must be connected.
 			 * Set appropriate bit thus could put phy into low power
-			 * mode if we have hostpc feature
+			 * mode if we have tdi_phy_lpm feature
 			 */
 			temp &= ~PORT_WKCONN_E;
 			temp |= PORT_WKDISC_E | PORT_WKOC_E;
 			ehci_writel(ehci, temp | PORT_SUSPEND, status_reg);
-			if (ehci->has_hostpc) {
+			if (ehci->has_tdi_phy_lpm) {
 				spin_unlock_irqrestore(&ehci->lock, flags);
 				msleep(5);/* 5ms for HCD enter low pwr mode */
 				spin_lock_irqsave(&ehci->lock, flags);
diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
index 64f9a08..d034d94 100644
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -210,6 +210,7 @@ struct ehci_hcd {			/* one per controller */
 	#define OHCI_HCCTRL_LEN         0x4
 	__hc32			*ohci_hcctrl_reg;
 	unsigned		has_hostpc:1;
+	unsigned		has_tdi_phy_lpm:1;
 	unsigned		has_ppcd:1; /* support per-port change bits */
 	u8			sbrn;		/* packed release number */
 
-- 
1.8.1.5

