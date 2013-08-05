Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab3HEUmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:42:36 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:50968 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab3HEUmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:42:35 -0400
Message-ID: <e5779310b2c20b3c927308995e5a99652f33b6d3.1375733180.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1375733180.git.cmetcalf@tilera.com>
References: <cover.1375733180.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 5 Aug 2013 16:06:20 -0400
Subject: [PATCH 01/20] tile PCI RC: cleanups for tilepro PCI RC
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove unneeded <linux/bootmem.h> include in pci.c
- eliminate unused pci_controller.first_busno field
- prefer msleep to mdelay
- remove stale comment about pci_scan_bus_parented()

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/pci.h |  1 -
 arch/tile/kernel/pci.c      | 16 +++-------------
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/arch/tile/include/asm/pci.h b/arch/tile/include/asm/pci.h
index 54a9242..cd10e65 100644
--- a/arch/tile/include/asm/pci.h
+++ b/arch/tile/include/asm/pci.h
@@ -29,7 +29,6 @@ struct pci_controller {
 	int index;		/* PCI domain number */
 	struct pci_bus *root_bus;
 
-	int first_busno;
 	int last_busno;
 
 	int hv_cfg_fd[2];	/* config{0,1} fds for this PCIe controller */
diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
index 67237d3..1dae3b2 100644
--- a/arch/tile/kernel/pci.c
+++ b/arch/tile/kernel/pci.c
@@ -20,7 +20,6 @@
 #include <linux/capability.h>
 #include <linux/sched.h>
 #include <linux/errno.h>
-#include <linux/bootmem.h>
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
@@ -192,7 +191,6 @@ int __init tile_pci_init(void)
 			controller->hv_cfg_fd[0] = hv_cfg_fd0;
 			controller->hv_cfg_fd[1] = hv_cfg_fd1;
 			controller->hv_mem_fd = hv_mem_fd;
-			controller->first_busno = 0;
 			controller->last_busno = 0xff;
 			controller->ops = &tile_cfg_ops;
 
@@ -283,7 +281,7 @@ int __init pcibios_init(void)
 	 * known to require at least 20ms here, but we use a more
 	 * conservative value.
 	 */
-	mdelay(250);
+	msleep(250);
 
 	/* Scan all of the recorded PCI controllers.  */
 	for (i = 0; i < TILE_NUM_PCIE; i++) {
@@ -304,18 +302,10 @@ int __init pcibios_init(void)
 
 			pr_info("PCI: initializing controller #%d\n", i);
 
-			/*
-			 * This comes from the generic Linux PCI driver.
-			 *
-			 * It reads the PCI tree for this bus into the Linux
-			 * data structures.
-			 *
-			 * This is inlined in linux/pci.h and calls into
-			 * pci_scan_bus_parented() in probe.c.
-			 */
 			pci_add_resource(&resources, &ioport_resource);
 			pci_add_resource(&resources, &iomem_resource);
-			bus = pci_scan_root_bus(NULL, 0, controller->ops, controller, &resources);
+			bus = pci_scan_root_bus(NULL, 0, controller->ops,
+						controller, &resources);
 			controller->root_bus = bus;
 			controller->last_busno = bus->busn_res.end;
 		}
-- 
1.8.3.1

