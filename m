Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaGOOkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:40:32 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54888 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753737AbaGOOj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:39:26 -0400
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
Subject: [PATCH v2 6/8] usb: allow to supply the PHY in the drivers when using HCD
Date: Tue, 15 Jul 2014 16:39:14 +0200
Message-Id: <1405435156-27297-7-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405435156-27297-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1405435156-27297-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modify the generic code handling PHYs to allow them to be
supplied from the drivers. This adds checks to ensure no PHY was already
there when looking for one in the generic code. This also makes sure we
do not modify its state in the generic HCD functions, it it was
provided by the driver.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 drivers/usb/core/hcd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 228bad89f09b..ce9ea309ab0f 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2650,7 +2650,7 @@ int usb_add_hcd(struct usb_hcd *hcd,
 		}
 	}
 
-	if (IS_ENABLED(CONFIG_GENERIC_PHY)) {
+	if (IS_ENABLED(CONFIG_GENERIC_PHY) && !hcd->phy) {
 		struct phy *phy = phy_get(hcd->self.controller, "usb");
 
 		if (IS_ERR(phy)) {
@@ -2670,6 +2670,7 @@ int usb_add_hcd(struct usb_hcd *hcd,
 				goto err_phy;
 			}
 			hcd->phy = phy;
+			hcd->remove_phy = 1;
 		}
 	}
 
@@ -2816,7 +2817,7 @@ err_allocate_root_hub:
 err_register_bus:
 	hcd_buffer_destroy(hcd);
 err_create_buf:
-	if (IS_ENABLED(CONFIG_GENERIC_PHY) && hcd->phy) {
+	if (IS_ENABLED(CONFIG_GENERIC_PHY) && hcd->remove_phy && hcd->phy) {
 		phy_power_off(hcd->phy);
 		phy_exit(hcd->phy);
 		phy_put(hcd->phy);
@@ -2900,7 +2901,7 @@ void usb_remove_hcd(struct usb_hcd *hcd)
 	usb_deregister_bus(&hcd->self);
 	hcd_buffer_destroy(hcd);
 
-	if (IS_ENABLED(CONFIG_GENERIC_PHY) && hcd->phy) {
+	if (IS_ENABLED(CONFIG_GENERIC_PHY) && hcd->remove_phy && hcd->phy) {
 		phy_power_off(hcd->phy);
 		phy_exit(hcd->phy);
 		phy_put(hcd->phy);
-- 
1.9.1

