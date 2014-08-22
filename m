Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452AbaHVPvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:51:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55545 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932228AbaHVPu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:50:28 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, Peter.Chen@freescale.com,
        kishon@ti.com, stern@rowland.harvard.edu
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        sergei.shtylyov@cogentembedded.com, yoshihiro.shimoda.uh@renesas.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/9] usb: rename gen_phy to phy in HCD
Date: Fri, 22 Aug 2014 17:50:16 +0200
Message-Id: <1408722621-3635-6-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408722621-3635-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1408722621-3635-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adding support to the generic PHY framework introduced a
'gen_phy' member in the HCD structure. Rename it to 'phy' to have a
consistent USB framework.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/core/hcd.c  | 22 +++++++++++-----------
 include/linux/usb/hcd.h |  4 +++-
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 86fdce55ae16..6619239baf6d 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2665,7 +2665,7 @@ int usb_add_hcd(struct usb_hcd *hcd,
 				phy_put(phy);
 				goto err_phy;
 			}
-			hcd->gen_phy = phy;
+			hcd->phy = phy;
 		}
 	}
 
@@ -2812,11 +2812,11 @@ err_allocate_root_hub:
 err_register_bus:
 	hcd_buffer_destroy(hcd);
 err_create_buf:
-	if (IS_ENABLED(CONFIG_GENERIC_PHY) && hcd->gen_phy) {
-		phy_power_off(hcd->gen_phy);
-		phy_exit(hcd->gen_phy);
-		phy_put(hcd->gen_phy);
-		hcd->gen_phy = NULL;
+	if (IS_ENABLED(CONFIG_GENERIC_PHY) && hcd->phy) {
+		phy_power_off(hcd->phy);
+		phy_exit(hcd->phy);
+		phy_put(hcd->phy);
+		hcd->phy = NULL;
 	}
 err_phy:
 	if (hcd->remove_phy && hcd->usb_phy) {
@@ -2896,11 +2896,11 @@ void usb_remove_hcd(struct usb_hcd *hcd)
 	usb_deregister_bus(&hcd->self);
 	hcd_buffer_destroy(hcd);
 
-	if (IS_ENABLED(CONFIG_GENERIC_PHY) && hcd->gen_phy) {
-		phy_power_off(hcd->gen_phy);
-		phy_exit(hcd->gen_phy);
-		phy_put(hcd->gen_phy);
-		hcd->gen_phy = NULL;
+	if (IS_ENABLED(CONFIG_GENERIC_PHY) && hcd->phy) {
+		phy_power_off(hcd->phy);
+		phy_exit(hcd->phy);
+		phy_put(hcd->phy);
+		hcd->phy = NULL;
 	}
 	if (hcd->remove_phy && hcd->usb_phy) {
 		usb_phy_shutdown(hcd->usb_phy);
diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index 604d2e6e0c1c..19b3fbd1f9e1 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -105,9 +105,11 @@ struct usb_hcd {
 	/*
 	 * OTG and some Host controllers need software interaction with phys;
 	 * other external phys should be software-transparent
+	 *
+	 * Keep the usb_phy for compatibility reasons, for now
 	 */
 	struct usb_phy		*usb_phy;
-	struct phy		*gen_phy;
+	struct phy		*phy;
 
 	/* Flags that need to be manipulated atomically because they can
 	 * change while the host controller is running.  Always use
-- 
1.9.1

