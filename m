Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbaHVPvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:51:54 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55554 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932249AbaHVPu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:50:29 -0400
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
Subject: [PATCH v3 6/9] usb: allow to supply the PHY in the drivers when using HCD
Date: Fri, 22 Aug 2014 17:50:17 +0200
Message-Id: <1408722621-3635-7-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408722621-3635-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1408722621-3635-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modify the generic code handling PHYs to allow them to be
supplied from the drivers. This adds checks to ensure no PHY was already
there when looking for one in the generic code. This also makes sure we
do not modify its state in the generic HCD functions, it was provided by
the driver.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/core/hcd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 6619239baf6d..dc0e46e5e618 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2646,7 +2646,7 @@ int usb_add_hcd(struct usb_hcd *hcd,
 		}
 	}
 
-	if (IS_ENABLED(CONFIG_GENERIC_PHY)) {
+	if (IS_ENABLED(CONFIG_GENERIC_PHY) && !hcd->phy) {
 		struct phy *phy = phy_get(hcd->self.controller, "usb");
 
 		if (IS_ERR(phy)) {
@@ -2666,6 +2666,7 @@ int usb_add_hcd(struct usb_hcd *hcd,
 				goto err_phy;
 			}
 			hcd->phy = phy;
+			hcd->remove_phy = 1;
 		}
 	}
 
@@ -2812,7 +2813,7 @@ err_allocate_root_hub:
 err_register_bus:
 	hcd_buffer_destroy(hcd);
 err_create_buf:
-	if (IS_ENABLED(CONFIG_GENERIC_PHY) && hcd->phy) {
+	if (IS_ENABLED(CONFIG_GENERIC_PHY) && hcd->remove_phy && hcd->phy) {
 		phy_power_off(hcd->phy);
 		phy_exit(hcd->phy);
 		phy_put(hcd->phy);
@@ -2896,7 +2897,7 @@ void usb_remove_hcd(struct usb_hcd *hcd)
 	usb_deregister_bus(&hcd->self);
 	hcd_buffer_destroy(hcd);
 
-	if (IS_ENABLED(CONFIG_GENERIC_PHY) && hcd->phy) {
+	if (IS_ENABLED(CONFIG_GENERIC_PHY) && hcd->remove_phy && hcd->phy) {
 		phy_power_off(hcd->phy);
 		phy_exit(hcd->phy);
 		phy_put(hcd->phy);
-- 
1.9.1

