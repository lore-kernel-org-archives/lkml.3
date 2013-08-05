Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab3HEUs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:48:56 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:50972 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab3HEUmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:42:43 -0400
Message-ID: <b84ca0e291d737d028a68e761aec83b85c7b3ed2.1375733180.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1375733180.git.cmetcalf@tilera.com>
References: <cover.1375733180.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 5 Aug 2013 16:06:20 -0400
Subject: [PATCH 05/20] tile PCI RC: handle case that PCI link is already up
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we are rebooting (e.g. via kexec) then the PCI RC link may
already be up.  In that case, we don't want to do the software
fixup to force the link up, since that can degrade it to Gen1.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/pci_gx.c | 41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/arch/tile/kernel/pci_gx.c b/arch/tile/kernel/pci_gx.c
index e99809e..2cc3e64 100644
--- a/arch/tile/kernel/pci_gx.c
+++ b/arch/tile/kernel/pci_gx.c
@@ -674,10 +674,33 @@ int __init pcibios_init(void)
 			continue;
 		}
 
-		ret = gxio_trio_force_rc_link_up(trio_context, mac);
-		if (ret < 0)
-			pr_err("PCI: PCIE_FORCE_LINK_UP failure, "
-				"MAC %d on TRIO %d\n", mac, trio_index);
+		/*
+		 * Check for PCIe link-up status to decide if we need
+		 * to force the link to come up.
+		 */
+		reg_offset =
+			(TRIO_PCIE_INTFC_PORT_STATUS <<
+				TRIO_CFG_REGION_ADDR__REG_SHIFT) |
+			(TRIO_CFG_REGION_ADDR__INTFC_VAL_MAC_INTERFACE <<
+				TRIO_CFG_REGION_ADDR__INTFC_SHIFT) |
+			(mac << TRIO_CFG_REGION_ADDR__MAC_SEL_SHIFT);
+
+		port_status.word =
+			__gxio_mmio_read(trio_context->mmio_base_mac +
+					 reg_offset);
+		if (!port_status.dl_up) {
+			if (rc_delay[trio_index][mac]) {
+				pr_info("Delaying PCIe RC TRIO init %d sec"
+					" on MAC %d on TRIO %d\n",
+					rc_delay[trio_index][mac], mac,
+					trio_index);
+				msleep(rc_delay[trio_index][mac] * 1000);
+			}
+			ret = gxio_trio_force_rc_link_up(trio_context, mac);
+			if (ret < 0)
+				pr_err("PCI: PCIE_FORCE_LINK_UP failure, "
+					"MAC %d on TRIO %d\n", mac, trio_index);
+		}
 
 		pr_info("PCI: Found PCI controller #%d on TRIO %d MAC %d\n", i,
 			trio_index, controller->mac);
@@ -700,16 +723,8 @@ int __init pcibios_init(void)
 		}
 
 		/*
-		 * Check for PCIe link-up status.
+		 * Check for PCIe link-up status again.
 		 */
-
-		reg_offset =
-			(TRIO_PCIE_INTFC_PORT_STATUS <<
-				TRIO_CFG_REGION_ADDR__REG_SHIFT) |
-			(TRIO_CFG_REGION_ADDR__INTFC_VAL_MAC_INTERFACE <<
-				TRIO_CFG_REGION_ADDR__INTFC_SHIFT ) |
-			(mac << TRIO_CFG_REGION_ADDR__MAC_SEL_SHIFT);
-
 		port_status.word =
 			__gxio_mmio_read(trio_context->mmio_base_mac +
 					 reg_offset);
-- 
1.8.3.1

