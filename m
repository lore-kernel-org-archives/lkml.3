Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbaCLKbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:31:09 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:51993 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbaCLKbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:31:04 -0400
From: Boris BREZILLON <brezillonboris@gmail.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: [PATCH] net: macb: set interface name based on DT aliases
Date: Wed, 12 Mar 2014 11:30:55 +0100
Message-Id: <1394620255-6357-1-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <532013C4.1000107@atmel.com>
References: <532013C4.1000107@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use aliases to set the interface name (ethX) instead of automatic
assignement.

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---

Hello Nicolas, Jean-Christophe,

This is an example on how we could set the ethernet interface id based on DT
aliases.
As you can see this patch is not properly separated.

I'm still not happy with this approach for several reasons:
1) If another ethernet iface has already been registered with the same id the
   net dev registration will fail.
2) We bypass the ethernet macros/functions and directly use the net device
   functions which IMHO is not future proof.

Best Regards,

Boris



 arch/arm/boot/dts/sama5d36.dtsi     |    2 +-
 arch/arm/boot/dts/sama5d3_emac.dtsi |    4 ++++
 arch/arm/boot/dts/sama5d3_gmac.dtsi |    4 ++++
 drivers/net/ethernet/cadence/macb.c |   15 +++++++++++++--
 4 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/sama5d36.dtsi b/arch/arm/boot/dts/sama5d36.dtsi
index 6c31c26..db58cad 100644
--- a/arch/arm/boot/dts/sama5d36.dtsi
+++ b/arch/arm/boot/dts/sama5d36.dtsi
@@ -8,8 +8,8 @@
  */
 #include "sama5d3.dtsi"
 #include "sama5d3_can.dtsi"
-#include "sama5d3_emac.dtsi"
 #include "sama5d3_gmac.dtsi"
+#include "sama5d3_emac.dtsi"
 #include "sama5d3_lcd.dtsi"
 #include "sama5d3_mci2.dtsi"
 #include "sama5d3_tcb1.dtsi"
diff --git a/arch/arm/boot/dts/sama5d3_emac.dtsi b/arch/arm/boot/dts/sama5d3_emac.dtsi
index fe2af92..f2c5da0 100644
--- a/arch/arm/boot/dts/sama5d3_emac.dtsi
+++ b/arch/arm/boot/dts/sama5d3_emac.dtsi
@@ -11,6 +11,10 @@
 #include <dt-bindings/interrupt-controller/irq.h>
 
 / {
+	aliases {
+		eth1 = &macb1;
+	};
+
 	ahb {
 		apb {
 			pinctrl@fffff200 {
diff --git a/arch/arm/boot/dts/sama5d3_gmac.dtsi b/arch/arm/boot/dts/sama5d3_gmac.dtsi
index a6cb050..05164de 100644
--- a/arch/arm/boot/dts/sama5d3_gmac.dtsi
+++ b/arch/arm/boot/dts/sama5d3_gmac.dtsi
@@ -11,6 +11,10 @@
 #include <dt-bindings/interrupt-controller/irq.h>
 
 / {
+	aliases {
+		eth0 = &macb0;
+	};
+
 	ahb {
 		apb {
 			pinctrl@fffff200 {
diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index 3190d38..b6f1f7c 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -1795,7 +1795,7 @@ static int __init macb_probe(struct platform_device *pdev)
 {
 	struct macb_platform_data *pdata;
 	struct resource *regs;
-	struct net_device *dev;
+	struct net_device *dev = NULL;
 	struct macb *bp;
 	struct phy_device *phydev;
 	u32 config;
@@ -1819,7 +1819,18 @@ static int __init macb_probe(struct platform_device *pdev)
 	}
 
 	err = -ENOMEM;
-	dev = alloc_etherdev(sizeof(*bp));
+	if (pdev->dev.of_node) {
+		int id = of_alias_get_id(pdev->dev.of_node, "eth");
+		if (id >= 0) {
+			char name[IFNAMSIZ];
+			snprintf(name, sizeof(name), "eth%d", id);
+			dev = alloc_netdev(sizeof(*bp), name, ether_setup);
+		}
+	}
+
+	if (!dev)
+		dev = alloc_etherdev(sizeof(*bp));
+
 	if (!dev)
 		goto err_out;
 
-- 
1.7.9.5

