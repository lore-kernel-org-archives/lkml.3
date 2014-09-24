Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbaIXTJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:09:49 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:42290 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaIXTJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:09:48 -0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        antoine.tenart@free-electrons.com, yoshihiro.shimoda.uh@renesas.com
Subject: [PATCH v6 2/2] usb: hcd: add generic PHY support
Date: Wed, 24 Sep 2014 23:09:44 +0400
Message-ID: <4738517.TNcWBCM3Rf@wasted.cogentembedded.com>
Organization: Cogent Embedded Inc.
User-Agent: KMail/4.13.3 (Linux/3.15.10-201.fc20.x86_64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <37148636.BU5lT4M4eC@wasted.cogentembedded.com>
References: <37148636.BU5lT4M4eC@wasted.cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the generic PHY support, analogous to the USB PHY support. Intended it to be
used with the PCI EHCI/OHCI drivers and the xHCI platform driver.

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

---
Changes in version 5:
- renamed the new 'gen_phy' field of 'struct usb_phy' back to 'phy';
- resolved rejects occured due to a newly added patch.

Changes in version 4:
- refreshed the patch.

Changes in version 3:
- refreshed the patch.

Changes in version 2:
- renamed the new 'phy' field of 'struct usb_phy' to 'gen_phy';
- resolved rejects due to removal of the first patch in the series.

 drivers/usb/core/hcd.c  |   42 ++++++++++++++++++++++++++++++++++++++++--
 include/linux/usb/hcd.h |    1 +
 2 files changed, 41 insertions(+), 2 deletions(-)

Index: usb/drivers/usb/core/hcd.c
===================================================================
--- usb.orig/drivers/usb/core/hcd.c
+++ usb/drivers/usb/core/hcd.c
@@ -42,6 +42,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/types.h>
 
+#include <linux/phy/phy.h>
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
 #include <linux/usb/phy.h>
@@ -2645,6 +2646,29 @@ int usb_add_hcd(struct usb_hcd *hcd,
 		}
 	}
 
+	if (IS_ENABLED(CONFIG_GENERIC_PHY)) {
+		struct phy *phy = phy_get(hcd->self.controller, "usb");
+
+		if (IS_ERR(phy)) {
+			retval = PTR_ERR(phy);
+			if (retval == -EPROBE_DEFER)
+				goto err_phy;
+		} else {
+			retval = phy_init(phy);
+			if (retval) {
+				phy_put(phy);
+				goto err_phy;
+			}
+			retval = phy_power_on(phy);
+			if (retval) {
+				phy_exit(phy);
+				phy_put(phy);
+				goto err_phy;
+			}
+			hcd->phy = phy;
+		}
+	}
+
 	dev_info(hcd->self.controller, "%s\n", hcd->product_desc);
 
 	/* Keep old behaviour if authorized_default is not in [0, 1]. */
@@ -2660,7 +2684,7 @@ int usb_add_hcd(struct usb_hcd *hcd,
 	 */
 	if ((retval = hcd_buffer_create(hcd)) != 0) {
 		dev_dbg(hcd->self.controller, "pool alloc failed\n");
-		goto err_remove_phy;
+		goto err_create_buf;
 	}
 
 	if ((retval = usb_register_bus(&hcd->self)) < 0)
@@ -2787,7 +2811,14 @@ err_allocate_root_hub:
 	usb_deregister_bus(&hcd->self);
 err_register_bus:
 	hcd_buffer_destroy(hcd);
-err_remove_phy:
+err_create_buf:
+	if (IS_ENABLED(CONFIG_GENERIC_PHY) && hcd->phy) {
+		phy_power_off(hcd->phy);
+		phy_exit(hcd->phy);
+		phy_put(hcd->phy);
+		hcd->phy = NULL;
+	}
+err_phy:
 	if (hcd->remove_phy && hcd->usb_phy) {
 		usb_phy_shutdown(hcd->usb_phy);
 		usb_put_phy(hcd->usb_phy);
@@ -2864,6 +2895,13 @@ void usb_remove_hcd(struct usb_hcd *hcd)
 
 	usb_deregister_bus(&hcd->self);
 	hcd_buffer_destroy(hcd);
+
+	if (IS_ENABLED(CONFIG_GENERIC_PHY) && hcd->phy) {
+		phy_power_off(hcd->phy);
+		phy_exit(hcd->phy);
+		phy_put(hcd->phy);
+		hcd->phy = NULL;
+	}
 	if (hcd->remove_phy && hcd->usb_phy) {
 		usb_phy_shutdown(hcd->usb_phy);
 		usb_put_phy(hcd->usb_phy);
Index: usb/include/linux/usb/hcd.h
===================================================================
--- usb.orig/include/linux/usb/hcd.h
+++ usb/include/linux/usb/hcd.h
@@ -107,6 +107,7 @@ struct usb_hcd {
 	 * other external phys should be software-transparent
 	 */
 	struct usb_phy		*usb_phy;
+	struct phy		*phy;
 
 	/* Flags that need to be manipulated atomically because they can
 	 * change while the host controller is running.  Always use

