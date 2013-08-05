Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab3HEUm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:42:56 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:50977 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab3HEUmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:42:52 -0400
Message-ID: <4af292f2d636d7f526df2df50f3a5cd1c9d371c4.1375733180.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1375733180.git.cmetcalf@tilera.com>
References: <cover.1375733180.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 5 Aug 2013 16:06:20 -0400
Subject: [PATCH 08/20] tile PCI RC: gentler warning for missing plug-in PCI
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Besides using pr_info() to print the linkdown status for a plug-in
slot, add extra indication that this is expected if the slot is empty.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/hv/drv_trio_intf.h |  5 +++--
 arch/tile/kernel/pci_gx.c            | 10 ++++++++--
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/tile/include/hv/drv_trio_intf.h b/arch/tile/include/hv/drv_trio_intf.h
index ef9f3f5..ec643a0 100644
--- a/arch/tile/include/hv/drv_trio_intf.h
+++ b/arch/tile/include/hv/drv_trio_intf.h
@@ -64,8 +64,9 @@ struct pcie_port_property
    *  will not consider it an error if the link comes up as a x8 link. */
   uint8_t allow_x8: 1;
 
-  /** Reserved. */
-  uint8_t reserved: 1;
+  /** If true, this link is connected to a device which may or may not
+   *  be present. */
+  uint8_t removable: 1;
 
 };
 
diff --git a/arch/tile/kernel/pci_gx.c b/arch/tile/kernel/pci_gx.c
index e0d6664..bf8c69d 100644
--- a/arch/tile/kernel/pci_gx.c
+++ b/arch/tile/kernel/pci_gx.c
@@ -729,8 +729,14 @@ int __init pcibios_init(void)
 			__gxio_mmio_read(trio_context->mmio_base_mac +
 					 reg_offset);
 		if (!port_status.dl_up) {
-			pr_err("PCI: link is down, MAC %d on TRIO %d\n",
-				mac, trio_index);
+			if (pcie_ports[trio_index][mac].removable) {
+				pr_info("PCI: link is down, MAC %d on TRIO %d\n",
+					mac, trio_index);
+				pr_info("This is expected if no PCIe card"
+					" is connected to this link\n");
+			} else
+				pr_err("PCI: link is down, MAC %d on TRIO %d\n",
+					mac, trio_index);
 			continue;
 		}
 
-- 
1.8.3.1

