Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab3DYJuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:50:13 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:58665 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757000Ab3DYJuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:50:09 -0400
From: Andrew Murray <Andrew.Murray@arm.com>
To: linux-pci@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        microblaze-uclinux@itee.uq.edu.au
Cc: benh@kernel.crashing.org, monstr@monstr.eu, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de, grant.likely@secretlab.ca,
        Andrew Murray <Andrew.Murray@arm.com>
Subject: [RFC PATCH 2/3] microblaze: Use asm-generic version of pci_controller
Date: Thu, 25 Apr 2013 10:49:19 +0100
Message-Id: <1366883360-14061-3-git-send-email-Andrew.Murray@arm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1366883360-14061-1-git-send-email-Andrew.Murray@arm.com>
References: <1366883360-14061-1-git-send-email-Andrew.Murray@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes struct pci_controller from Microblaze and instead
uses struct pci_controller from asm-generic.

Signed-off-by: Andrew Murray <Andrew.Murray@arm.com>
---
 arch/microblaze/include/asm/pci-bridge.h |   75 ++++++------------------------
 include/asm-generic/pci-bridge.h         |    2 +-
 2 files changed, 16 insertions(+), 61 deletions(-)

diff --git a/arch/microblaze/include/asm/pci-bridge.h b/arch/microblaze/include/asm/pci-bridge.h
index 5783cd6..0ee75dc 100644
--- a/arch/microblaze/include/asm/pci-bridge.h
+++ b/arch/microblaze/include/asm/pci-bridge.h
@@ -8,9 +8,9 @@
  * 2 of the License, or (at your option) any later version.
  */
 #include <linux/pci.h>
-#include <linux/list.h>
 #include <linux/ioport.h>
 #include <linux/of_pci.h>
+#include <asm-generic/pci-bridge.h>
 
 struct device_node;
 
@@ -25,72 +25,27 @@ static inline int pcibios_vaddr_is_ioport(void __iomem *address)
 #endif
 
 /*
- * Structure of a PCI controller (host bridge)
+ * Used for variants of PCI indirect handling and possible quirks:
+ *  SET_CFG_TYPE - used on 4xx or any PHB that does explicit type0/1
+ *  EXT_REG - provides access to PCI-e extended registers
+ *  SURPRESS_PRIMARY_BUS - we suppress the setting of PCI_PRIMARY_BUS
+ *   on Freescale PCI-e controllers since they used the PCI_PRIMARY_BUS
+ *   to determine which bus number to match on when generating type0
+ *   config cycles
+ *  NO_PCIE_LINK - the Freescale PCI-e controllers have issues with
+ *   hanging if we don't have link and try to do config cycles to
+ *   anything but the PHB.  Only allow talking to the PHB if this is
+ *   set.
+ *  BIG_ENDIAN - cfg_addr is a big endian register
+ *  BROKEN_MRM - the 440EPx/GRx chips have an errata that causes hangs
+ *   on the PLB4.  Effectively disable MRM commands by setting this.
  */
-struct pci_controller {
-	struct pci_bus *bus;
-	char is_dynamic;
-	struct device_node *dn;
-	struct list_head list_node;
-	struct device *parent;
-
-	int first_busno;
-	int last_busno;
-
-	int self_busno;
-
-	void __iomem *io_base_virt;
-	resource_size_t io_base_phys;
-
-	resource_size_t pci_io_size;
-
-	/* Some machines (PReP) have a non 1:1 mapping of
-	 * the PCI memory space in the CPU bus space
-	 */
-	resource_size_t pci_mem_offset;
-
-	/* Some machines have a special region to forward the ISA
-	 * "memory" cycles such as VGA memory regions. Left to 0
-	 * if unsupported
-	 */
-	resource_size_t isa_mem_phys;
-	resource_size_t isa_mem_size;
-
-	struct pci_ops *ops;
-	unsigned int __iomem *cfg_addr;
-	void __iomem *cfg_data;
-
-	/*
-	 * Used for variants of PCI indirect handling and possible quirks:
-	 *  SET_CFG_TYPE - used on 4xx or any PHB that does explicit type0/1
-	 *  EXT_REG - provides access to PCI-e extended registers
-	 *  SURPRESS_PRIMARY_BUS - we suppress the setting of PCI_PRIMARY_BUS
-	 *   on Freescale PCI-e controllers since they used the PCI_PRIMARY_BUS
-	 *   to determine which bus number to match on when generating type0
-	 *   config cycles
-	 *  NO_PCIE_LINK - the Freescale PCI-e controllers have issues with
-	 *   hanging if we don't have link and try to do config cycles to
-	 *   anything but the PHB.  Only allow talking to the PHB if this is
-	 *   set.
-	 *  BIG_ENDIAN - cfg_addr is a big endian register
-	 *  BROKEN_MRM - the 440EPx/GRx chips have an errata that causes hangs
-	 *   on the PLB4.  Effectively disable MRM commands by setting this.
-	 */
 #define INDIRECT_TYPE_SET_CFG_TYPE		0x00000001
 #define INDIRECT_TYPE_EXT_REG		0x00000002
 #define INDIRECT_TYPE_SURPRESS_PRIMARY_BUS	0x00000004
 #define INDIRECT_TYPE_NO_PCIE_LINK		0x00000008
 #define INDIRECT_TYPE_BIG_ENDIAN		0x00000010
 #define INDIRECT_TYPE_BROKEN_MRM		0x00000020
-	u32 indirect_type;
-
-	/* Currently, we limit ourselves to 1 IO range and 3 mem
-	 * ranges since the common pci_bus structure can't handle more
-	 */
-	struct resource io_resource;
-	struct resource mem_resources[3];
-	int global_number;	/* PCI domain number */
-};
 
 #ifdef CONFIG_PCI
 static inline struct pci_controller *pci_bus_to_host(const struct pci_bus *bus)
diff --git a/include/asm-generic/pci-bridge.h b/include/asm-generic/pci-bridge.h
index e58830e..1a7f96d 100644
--- a/include/asm-generic/pci-bridge.h
+++ b/include/asm-generic/pci-bridge.h
@@ -46,7 +46,7 @@ struct device_node;
 /*
  * Structure of a PCI controller (host bridge)
  */
-#if defined(CONFIG_PPC32) || defined(CONFIG_PPC64)
+#if defined(CONFIG_PPC32) || defined(CONFIG_PPC64) || defined(CONFIG_MICROBLAZE)
 struct pci_controller {
 	struct pci_bus *bus;
 	char is_dynamic;
-- 
1.7.0.4

