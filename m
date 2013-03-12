Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770Ab3CLLJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:09:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42909 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab3CLLJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:09:12 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <stern@rowland.harvard.edu>, <balbi@ti.com>, <b-cousson@ti.com>,
        <mark.rutland@arm.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <rogerq@ti.com>,
        <kishon@ti.com>
Subject: [PATCH v2 12/12] USB: ehci-omap: Fix detection in HSIC mode
Date: Tue, 12 Mar 2013 13:09:00 +0200
Message-ID: <1363086540-30567-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363085090-24676-13-git-send-email-rogerq@ti.com>
References: <1363085090-24676-13-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HSIC devices need to be kept in reset while the EHCI controller
is being initialized and only brought out of reset after the
initialization is complete, else HSIC devices will not be detected.

Also remove outdated TODO list from header.

Signed-off-by: Roger Quadros <rogerq@ti.com>
CC: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/ehci-omap.c |   38 +++++++++++++++-----------------------
 1 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 1ba1df8..dc2de47 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -29,12 +29,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  *
- * TODO (last updated Feb 27, 2010):
- *	- add kernel-doc
- *	- enable AUTOIDLE
- *	- add suspend/resume
- *	- add HSIC and TLL support
- *	- convert to use hwmod and runtime PM
  */
 
 #include <linux/kernel.h>
@@ -90,26 +84,13 @@ static inline u32 ehci_read(void __iomem *base, u32 reg)
 static int omap_ehci_init(struct usb_hcd *hcd)
 {
 	struct ehci_hcd	*ehci = hcd_to_ehci(hcd);
-	struct omap_hcd	*omap = (struct omap_hcd *)ehci->priv;
-	int rc, i;
-
-	/* Hold PHYs in reset while initializing EHCI controller */
-	for (i = 0; i < omap->nports; i++) {
-		if (omap->phy[i])
-			usb_phy_shutdown(omap->phy[i]);
-	}
+	int rc;
 
 	/* we know this is the memory we want, no need to ioremap again */
 	ehci->caps = hcd->regs;
 
 	rc = ehci_setup(hcd);
 
-	/* Bring PHYs out of reset */
-	for (i = 0; i < omap->nports; i++) {
-		if (omap->phy[i])
-			usb_phy_init(omap->phy[i]);
-	}
-
 	return rc;
 }
 
@@ -219,9 +200,6 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 		}
 
 		omap->phy[i] = phy;
-		usb_phy_init(omap->phy[i]);
-		/* bring PHY out of suspend */
-		usb_phy_set_suspend(omap->phy[i], 0);
 	}
 
 	pm_runtime_enable(dev);
@@ -245,6 +223,20 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 		goto err_pm_runtime;
 	}
 
+	/*
+	 * Bring PHYs out of reset.
+	 * Even though HSIC mode is a PHY-less mode, the reset
+	 * line exists between the chips and can be modelled
+	 * as a PHY device for reset control.
+	 */
+	for (i = 0; i < omap->nports; i++) {
+		if (!omap->phy[i])
+			continue;
+
+		usb_phy_init(omap->phy[i]);
+		/* bring PHY out of suspend */
+		usb_phy_set_suspend(omap->phy[i], 0);
+	}
 
 	return 0;
 
-- 
1.7.4.1

