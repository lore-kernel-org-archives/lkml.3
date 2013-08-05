Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab3HEUoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:44:08 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:50988 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360Ab3HEUnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:43:19 -0400
Message-ID: <ce158413650f70a6551c6af726e07d40b6ba7cc5.1375733180.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1375733180.git.cmetcalf@tilera.com>
References: <cover.1375733180.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 5 Aug 2013 16:06:20 -0400
Subject: [PATCH 19/20] tile PCI RC: reduce driver's vmalloc space usage
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can take advantage of the fact that bit 29 is hard-wired
to zero in register TRIO_TILE_PIO_REGION_SETUP_CFG_ADDR.
This is handy since at the moment we only allocate one 4GB
region for vmalloc, and with this change we can allocate
four or more TRIO MACs without using up all the vmalloc space.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/pci_gx.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/tile/kernel/pci_gx.c b/arch/tile/kernel/pci_gx.c
index f2bf200..4843881 100644
--- a/arch/tile/kernel/pci_gx.c
+++ b/arch/tile/kernel/pci_gx.c
@@ -860,9 +860,15 @@ int __init pcibios_init(void)
 
 #endif
 
+		/*
+		 * To save VMALLOC space, we take advantage of the fact that
+		 * bit 29 in the PIO CFG address format is reserved 0. With
+		 * TRIO_TILE_PIO_REGION_SETUP_CFG_ADDR__MAC_SHIFT being 30,
+		 * this cuts VMALLOC space usage from 1GB to 512MB per mac.
+		 */
 		trio_context->mmio_base_pio_cfg[mac] =
-			iorpc_ioremap(trio_context->fd, offset,
-			(1 << TRIO_TILE_PIO_REGION_SETUP_CFG_ADDR__MAC_SHIFT));
+			iorpc_ioremap(trio_context->fd, offset, (1UL <<
+			(TRIO_TILE_PIO_REGION_SETUP_CFG_ADDR__MAC_SHIFT - 1)));
 		if (trio_context->mmio_base_pio_cfg[mac] == NULL) {
 			pr_err("PCI: PIO map failure for mac %d on TRIO %d\n",
 				mac, trio_index);
-- 
1.8.3.1

