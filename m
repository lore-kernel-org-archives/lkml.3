Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3HEUnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:43:21 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:50987 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab3HEUnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:43:17 -0400
Message-ID: <34842e3c6a29c79b3702b18112f11feab1437682.1375733180.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1375733180.git.cmetcalf@tilera.com>
References: <cover.1375733180.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 5 Aug 2013 16:06:20 -0400
Subject: [PATCH 18/20] tile PCI RC: support PCIe TRIO 0 MAC 0 on Gx72 system
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tilera Gx72 systems, the logic for figuring out whether
a given port is root complex is slightly different.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/hv/drv_trio_intf.h |  3 +++
 arch/tile/kernel/pci_gx.c            | 33 ++++++++++++++++++++++++++++++---
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/arch/tile/include/hv/drv_trio_intf.h b/arch/tile/include/hv/drv_trio_intf.h
index ec643a0..237e04d 100644
--- a/arch/tile/include/hv/drv_trio_intf.h
+++ b/arch/tile/include/hv/drv_trio_intf.h
@@ -168,6 +168,9 @@ pcie_stream_intr_config_sel_t;
 struct pcie_trio_ports_property
 {
   struct pcie_port_property ports[TILEGX_TRIO_PCIES];
+
+  /** Set if this TRIO belongs to a Gx72 device. */
+  uint8_t is_gx72;
 };
 
 /* Flags indicating traffic class. */
diff --git a/arch/tile/kernel/pci_gx.c b/arch/tile/kernel/pci_gx.c
index de5008b..f2bf200 100644
--- a/arch/tile/kernel/pci_gx.c
+++ b/arch/tile/kernel/pci_gx.c
@@ -436,9 +436,26 @@ int __init tile_pci_init(void)
 
 	/*
 	 * Now determine which PCIe ports are configured to operate in RC
-	 * mode.  To use a port, it must be allowed to be in RC mode by the
+	 * mode. There is a differece in the port configuration capability
+	 * between the Gx36 and Gx72 devices.
+	 *
+	 * The Gx36 has configuration capability for each of the 3 PCIe
+	 * interfaces (disable, auto endpoint, auto RC, etc.).
+	 * On the Gx72, you can only select one of the 3 PCIe interfaces per
+	 * TRIO to train automatically. Further, the allowable training modes
+	 * are reduced to four options (auto endpoint, auto RC, stream x1,
+	 * stream x4).
+	 *
+	 * For Gx36 ports, it must be allowed to be in RC mode by the
 	 * Board Information Block, and the hardware strapping pins must be
 	 * set to RC mode.
+	 *
+	 * For Gx72 ports, the port will operate in RC mode if either of the
+	 * following is true:
+	 * 1. It is allowed to be in RC mode by the Board Information Block,
+	 *    and the BIB doesn't allow the EP mode.
+	 * 2. It is allowed to be in either the RC or the EP mode by the BIB,
+	 *    and the hardware strapping pin is set to RC mode.
 	 */
 	for (i = 0; i < TILEGX_NUM_TRIO; i++) {
 		gxio_trio_context_t *context = &trio_contexts[i];
@@ -447,8 +464,18 @@ int __init tile_pci_init(void)
 			continue;
 
 		for (j = 0; j < TILEGX_TRIO_PCIES; j++) {
-			if (pcie_ports[i].ports[j].allow_rc &&
-			    strapped_for_rc(context, j)) {
+			int is_rc = 0;
+
+			if (pcie_ports[i].is_gx72 &&
+			    pcie_ports[i].ports[j].allow_rc) {
+				if (!pcie_ports[i].ports[j].allow_ep ||
+				    strapped_for_rc(context, j))
+					is_rc = 1;
+			} else if (pcie_ports[i].ports[j].allow_rc &&
+				   strapped_for_rc(context, j)) {
+				is_rc = 1;
+			}
+			if (is_rc) {
 				pcie_rc[i][j] = 1;
 				num_rc_controllers++;
 			}
-- 
1.8.3.1

