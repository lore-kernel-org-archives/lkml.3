Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbaJFGV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 02:21:27 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:50225 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaJFGVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 02:21:23 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        drake@endlessm.com, grant.likely@secretlab.ca, kgene.kim@samsung.com,
        jg1.han@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH] usb: ehci/ohci-exynos: Fix of_node_put() for child when getting PHYs
Date: Mon,  6 Oct 2014 11:51:10 +0530
Message-Id: <1412576470-23974-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On enabling CONFIG_OF_SELFTEST which enables CONFIG_OF_DYNAMIC,
we found out that while getting PHYs for the controller we were
doing an extra of_node_put on the child node in our routines -
exynos_e/ohci_get_phy().
This child is however already put by of_get_next_available_child()
which does a of_node_put() on the "prev" node. So there's no point
in putting the same node again in our routine.

Reported-by: Daniel Drake <drake@endlessm.com>
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/host/ehci-exynos.c |    1 -
 drivers/usb/host/ohci-exynos.c |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
index 7189f2e..1b726bf 100644
--- a/drivers/usb/host/ehci-exynos.c
+++ b/drivers/usb/host/ehci-exynos.c
@@ -74,7 +74,6 @@ static int exynos_ehci_get_phy(struct device *dev,
 
 		phy = devm_of_phy_get(dev, child, NULL);
 		exynos_ehci->phy[phy_number] = phy;
-		of_node_put(child);
 		if (IS_ERR(phy)) {
 			ret = PTR_ERR(phy);
 			if (ret == -EPROBE_DEFER) {
diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
index d28b658..39f366b 100644
--- a/drivers/usb/host/ohci-exynos.c
+++ b/drivers/usb/host/ohci-exynos.c
@@ -63,7 +63,6 @@ static int exynos_ohci_get_phy(struct device *dev,
 
 		phy = devm_of_phy_get(dev, child, NULL);
 		exynos_ohci->phy[phy_number] = phy;
-		of_node_put(child);
 		if (IS_ERR(phy)) {
 			ret = PTR_ERR(phy);
 			if (ret == -EPROBE_DEFER) {
-- 
1.7.10.4

