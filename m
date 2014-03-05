Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbaCEVHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:07:23 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:2735 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754349AbaCEVHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:07:17 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 5
X-BigFish: VPS5(z1039mzzz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch21a7h1fc6hzz1de098h8275bh1de097hz2dh839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
X-WSS-ID: 0N1ZENV-07-208-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <aravind.gopalakrishnan@amd.com>,
        <kim.naru@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 1/3] amd/pci: Add supports for generic AMD hostbridges
Date: Wed, 5 Mar 2014 15:06:41 -0600
Message-ID: <1394053603-3724-2-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1394053603-3724-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1394053603-3724-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

AMD hostbridges are gnenerally show up as PCI device 0:18.0.
This patch adds logic to automatically probe the device at
this location and check PCI device class code.

This patch should support AMD hostbridges from AMD platforms
(K8, family10h, 11h, 12h, 14h 15h  and 16h processors).

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Tested-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 arch/x86/pci/amd_bus.c |   88 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 60 insertions(+), 28 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index a48be98..4041cbe 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -11,27 +11,39 @@
 
 #include "bus_numa.h"
 
+#define AMD_NB_F0_NODE_ID                       0x60
+#define AMD_NB_F0_UNIT_ID                       0x64
+#define AMD_NB_F1_MMIO_BASE_REG                 0x80
+#define AMD_NB_F1_MMIO_LIMIT_REG                0x84
+#define AMD_NB_F1_IO_BASEA_DDR_REG              0xc0
+#define AMD_NB_F1_IO_LIMIT_ADDR_REG             0xc4
+#define AMD_NB_F1_CONFIG_MAP_REG                0xe0
+
+#define RANGE_NUM                               16
+#define AMD_NB_F1_MMIO_RANGES                   8
+#define AMD_NB_F1_IOPORT_RANGES                 4
+#define AMD_NB_F1_CONFIG_MAP_RANGES             4
+
 /*
  * This discovers the pcibus <-> node mapping on AMD K8.
  * also get peer root bus resource for io,mmio
  */
 
-struct pci_hostbridge_probe {
+struct amd_hostbridge {
 	u32 bus;
 	u32 slot;
-	u32 vendor;
 	u32 device;
 };
 
-static struct pci_hostbridge_probe pci_probes[] __initdata = {
-	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1100 },
-	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1200 },
-	{ 0xff, 0, PCI_VENDOR_ID_AMD, 0x1200 },
-	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1300 },
+static struct amd_hostbridge hb_probes[] __initdata = {
+	/* Standard AMD Hostbriges is at bus 0x0 slot 0x18.
+	 * In case of PCI_ANY_ID, the logic will try matching
+	 * PCI_CLASS_BRIDGE_HOST instead.
+	 */
+	{ 0x0 , 0x18, PCI_ANY_ID },
+	{ 0xff, 0   , PCI_DEVICE_ID_AMD_10H_NB_HT },
 };
 
-#define RANGE_NUM 16
-
 static struct pci_root_info __init *find_pci_root_info(int node, int link)
 {
 	struct pci_root_info *info;
@@ -84,31 +96,47 @@ static int __init early_fill_mp_bus_info(void)
 		return -1;
 
 	found = false;
-	for (i = 0; i < ARRAY_SIZE(pci_probes); i++) {
+	for (i = 0; i < ARRAY_SIZE(hb_probes); i++) {
 		u32 id;
 		u16 device;
 		u16 vendor;
+		u32 class;
 
-		bus = pci_probes[i].bus;
-		slot = pci_probes[i].slot;
+		bus = hb_probes[i].bus;
+		slot = hb_probes[i].slot;
 		id = read_pci_config(bus, slot, 0, PCI_VENDOR_ID);
-
 		vendor = id & 0xffff;
 		device = (id>>16) & 0xffff;
-		if (pci_probes[i].vendor == vendor &&
-		    pci_probes[i].device == device) {
-			found = true;
-			break;
+		class = read_pci_config(bus, slot, 0,
+			PCI_CLASS_REVISION) >> 16;
+
+		if (PCI_VENDOR_ID_AMD == vendor) {
+			if (hb_probes[i].device == device) {
+				found = true;
+				break;
+			}
+
+			if ((hb_probes[i].device == PCI_ANY_ID) &&
+			    (class == PCI_CLASS_BRIDGE_HOST)) {
+				hb_probes[i].device = device;
+				found = true;
+				break;
+			}
 		}
 	}
 
-	if (!found)
+	if (!found) {
+		printk(KERN_WARNING "AMD hostbridge not found\n");
 		return 0;
+	}
+
+	printk(KERN_DEBUG "Found AMD hostbridge at %x:%x.0\n", bus, slot);
 
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < AMD_NB_F1_CONFIG_MAP_RANGES; i++) {
 		int min_bus;
 		int max_bus;
-		reg = read_pci_config(bus, slot, 1, 0xe0 + (i << 2));
+		reg = read_pci_config(bus, slot, 1,
+				AMD_NB_F1_CONFIG_MAP_REG + (i << 2));
 
 		/* Check if that register is enabled for bus range */
 		if ((reg & 7) != 3)
@@ -124,21 +152,23 @@ static int __init early_fill_mp_bus_info(void)
 	}
 
 	/* get the default node and link for left over res */
-	reg = read_pci_config(bus, slot, 0, 0x60);
+	reg = read_pci_config(bus, slot, 0, AMD_NB_F0_NODE_ID);
 	def_node = (reg >> 8) & 0x07;
-	reg = read_pci_config(bus, slot, 0, 0x64);
+	reg = read_pci_config(bus, slot, 0, AMD_NB_F0_UNIT_ID);
 	def_link = (reg >> 8) & 0x03;
 
 	memset(range, 0, sizeof(range));
 	add_range(range, RANGE_NUM, 0, 0, 0xffff + 1);
 	/* io port resource */
-	for (i = 0; i < 4; i++) {
-		reg = read_pci_config(bus, slot, 1, 0xc0 + (i << 3));
+	for (i = 0; i < AMD_NB_F1_IOPORT_RANGES; i++) {
+		reg = read_pci_config(bus, slot, 1,
+				AMD_NB_F1_IO_BASEA_DDR_REG + (i << 3));
 		if (!(reg & 3))
 			continue;
 
 		start = reg & 0xfff000;
-		reg = read_pci_config(bus, slot, 1, 0xc4 + (i << 3));
+		reg = read_pci_config(bus, slot, 1,
+				AMD_NB_F1_IO_LIMIT_ADDR_REG + (i << 3));
 		node = reg & 0x07;
 		link = (reg >> 4) & 0x03;
 		end = (reg & 0xfff000) | 0xfff;
@@ -198,14 +228,16 @@ static int __init early_fill_mp_bus_info(void)
 	}
 
 	/* mmio resource */
-	for (i = 0; i < 8; i++) {
-		reg = read_pci_config(bus, slot, 1, 0x80 + (i << 3));
+	for (i = 0; i < AMD_NB_F1_MMIO_RANGES; i++) {
+		reg = read_pci_config(bus, slot, 1,
+				AMD_NB_F1_MMIO_BASE_REG + (i << 3));
 		if (!(reg & 3))
 			continue;
 
 		start = reg & 0xffffff00; /* 39:16 on 31:8*/
 		start <<= 8;
-		reg = read_pci_config(bus, slot, 1, 0x84 + (i << 3));
+		reg = read_pci_config(bus, slot, 1,
+				AMD_NB_F1_MMIO_LIMIT_REG + (i << 3));
 		node = reg & 0x07;
 		link = (reg >> 4) & 0x03;
 		end = (reg & 0xffffff00);
-- 
1.7.10.4


