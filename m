Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbaCEVIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:08:13 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:35872
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756758AbaCEVHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:07:21 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch21a7h1fc6hzz1de098h8275bh1de097hz2dh839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
X-WSS-ID: 0N1ZENV-08-66V-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <aravind.gopalakrishnan@amd.com>,
        <kim.naru@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 2/3] amd/pci: Support additional MMIO ranges capabilities
Date: Wed, 5 Mar 2014 15:06:42 -0600
Message-ID: <1394053603-3724-3-git-send-email-suravee.suthikulpanit@amd.com>
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

This patch adds supports for additional MMIO ranges (16 ranges)
Also, each MMIO base/limit can now supports upto 48-bit MMIO address.
However, this requires initializing the ECS sooner since the new registers
are in the ECS ranges.

This applies for AMD family15h and later.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Tested-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 arch/x86/pci/amd_bus.c |  116 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 94 insertions(+), 22 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 4041cbe..577995e 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -15,15 +15,28 @@
 #define AMD_NB_F0_UNIT_ID                       0x64
 #define AMD_NB_F1_MMIO_BASE_REG                 0x80
 #define AMD_NB_F1_MMIO_LIMIT_REG                0x84
+#define AMD_NB_F1_MMIO_BASE_LIMIT_HI_REG        0x180
 #define AMD_NB_F1_IO_BASEA_DDR_REG              0xc0
 #define AMD_NB_F1_IO_LIMIT_ADDR_REG             0xc4
 #define AMD_NB_F1_CONFIG_MAP_REG                0xe0
 
 #define RANGE_NUM                               16
-#define AMD_NB_F1_MMIO_RANGES                   8
+#define AMD_NB_F1_MMIO_RANGES                   16
 #define AMD_NB_F1_IOPORT_RANGES                 4
 #define AMD_NB_F1_CONFIG_MAP_RANGES             4
 
+#define AMD_PCIE_CF8(bus, dev, fn, reg) \
+			(0x80000000 | \
+			((reg & 0xF00) << 16) | \
+			((bus & 0xF) << 16) | \
+			((dev & 0x1F) << 11) | \
+			((fn & 0x7) << 8) | \
+			((reg & 0xFC)))
+
+static bool amd_early_ecs_enabled;
+
+static int __init pci_io_ecs_init(u8 bus, u8 slot);
+
 /*
  * This discovers the pcibus <-> node mapping on AMD K8.
  * also get peer root bus resource for io,mmio
@@ -44,6 +57,20 @@ static struct amd_hostbridge hb_probes[] __initdata = {
 	{ 0xff, 0   , PCI_DEVICE_ID_AMD_10H_NB_HT },
 };
 
+/* This version of read_pci_config allows reading of registers in ECS area */
+static inline int _amd_read_pci_config(u8 bus, u8 slot, u8 fn, u32 offset)
+{
+	u32 value;
+
+	if ((!amd_early_ecs_enabled) && (offset > 0xFF))
+		return -1;
+
+	outl(AMD_PCIE_CF8(bus, slot, fn, offset), 0xcf8);
+	value = inl(0xcfc);
+
+	return value;
+}
+
 static struct pci_root_info __init *find_pci_root_info(int node, int link)
 {
 	struct pci_root_info *info;
@@ -53,6 +80,9 @@ static struct pci_root_info __init *find_pci_root_info(int node, int link)
 		if (info->node == node && info->link == link)
 			return info;
 
+	pr_warn("AMD-Bus: WARNING: Failed to find root info for node %#x, link %#x\n",
+		node, link);
+
 	return NULL;
 }
 
@@ -65,6 +95,7 @@ static void __init set_mp_bus_range_to_node(int min_bus, int max_bus, int node)
 		set_mp_bus_to_node(j, node);
 #endif
 }
+
 /**
  * early_fill_mp_bus_to_node()
  * called before pcibios_scan_root and pci_scan_bus
@@ -132,6 +163,12 @@ static int __init early_fill_mp_bus_info(void)
 
 	printk(KERN_DEBUG "Found AMD hostbridge at %x:%x.0\n", bus, slot);
 
+	/* We enabling ECS mode prior to probing MMIO since
+	 * the MMIO-related registers are in the ECS area.
+	 */
+	pci_io_ecs_init(bus, slot);
+
+	found = false;
 	for (i = 0; i < AMD_NB_F1_CONFIG_MAP_RANGES; i++) {
 		int min_bus;
 		int max_bus;
@@ -142,6 +179,7 @@ static int __init early_fill_mp_bus_info(void)
 		if ((reg & 7) != 3)
 			continue;
 
+		found = true;
 		min_bus = (reg >> 16) & 0xff;
 		max_bus = (reg >> 24) & 0xff;
 		node = (reg >> 4) & 0x07;
@@ -151,6 +189,14 @@ static int __init early_fill_mp_bus_info(void)
 		info = alloc_pci_root_info(min_bus, max_bus, node, link);
 	}
 
+	if (!found) {
+		/* In case there is no AMDNB_F1_CONFIG_MAP_REGs,
+		 * we just use default to bus 0, node 0 link 0)
+		 */
+		set_mp_bus_range_to_node(0, 0, 0);
+		info = alloc_pci_root_info(0, 0, 0, 0);
+	}
+
 	/* get the default node and link for left over res */
 	reg = read_pci_config(bus, slot, 0, AMD_NB_F0_NODE_ID);
 	def_node = (reg >> 8) & 0x07;
@@ -159,6 +205,7 @@ static int __init early_fill_mp_bus_info(void)
 
 	memset(range, 0, sizeof(range));
 	add_range(range, RANGE_NUM, 0, 0, 0xffff + 1);
+
 	/* io port resource */
 	for (i = 0; i < AMD_NB_F1_IOPORT_RANGES; i++) {
 		reg = read_pci_config(bus, slot, 1,
@@ -186,6 +233,7 @@ static int __init early_fill_mp_bus_info(void)
 		update_res(info, start, end, IORESOURCE_IO, 1);
 		subtract_range(range, RANGE_NUM, start, end + 1);
 	}
+
 	/* add left over io port range to def node/link, [0, 0xffff] */
 	/* find the position */
 	info = find_pci_root_info(def_node, def_link);
@@ -229,23 +277,45 @@ static int __init early_fill_mp_bus_info(void)
 
 	/* mmio resource */
 	for (i = 0; i < AMD_NB_F1_MMIO_RANGES; i++) {
-		reg = read_pci_config(bus, slot, 1,
-				AMD_NB_F1_MMIO_BASE_REG + (i << 3));
+		u64 tmp;
+		u32 base = AMD_NB_F1_MMIO_BASE_REG + (i << 3);
+		u32 limit = AMD_NB_F1_MMIO_LIMIT_REG + (i << 3);
+		u32 base_limit_hi = AMD_NB_F1_MMIO_BASE_LIMIT_HI_REG + (i << 2);
+
+		if (i >= 12) {
+			/* Range 12 base/limit starts at 0x2A0 */
+			base += 0x1c0;
+			limit += 0x1c0;
+			/* Range 12 base/limit hi starts at 0x2C0 */
+			base_limit_hi += 0x110;
+		} else if (i >= 8) {
+			/* Range 8 base/limit starts at 0x1A0 */
+			base += 0xe0;
+			limit += 0xe0;
+			/* Range 12 base/limit hi starts at 0x1C0 */
+			base_limit_hi += 0x20;
+		}
+
+		/* Base lo */
+		reg = _amd_read_pci_config(bus, slot, 1, base);
 		if (!(reg & 3))
 			continue;
 
-		start = reg & 0xffffff00; /* 39:16 on 31:8*/
-		start <<= 8;
-		reg = read_pci_config(bus, slot, 1,
-				AMD_NB_F1_MMIO_LIMIT_REG + (i << 3));
+		start = (reg & 0xffffff00UL) << 8; /* 39:16 on 31:8*/
+
+		/* Limit lo */
+		reg = _amd_read_pci_config(bus, slot, 1, limit);
 		node = reg & 0x07;
 		link = (reg >> 4) & 0x03;
-		end = (reg & 0xffffff00);
-		end <<= 8;
-		end |= 0xffff;
+		end = (reg & 0xffffff00UL) << 8; /* 39:16 on 31:8*/
+		end |= 0xffffUL;
 
-		info = find_pci_root_info(node, link);
+		/* Base/Limit hi */
+		tmp = _amd_read_pci_config(bus, slot, 1, base_limit_hi);
+		start |= ((tmp & 0xffUL) << 40);
+		end |= ((tmp & (0xffUL << 16)) << 24);
 
+		info = find_pci_root_info(node, link);
 		if (!info)
 			continue;
 
@@ -373,20 +443,24 @@ static struct notifier_block amd_cpu_notifier = {
 	.notifier_call	= amd_cpu_notify,
 };
 
-static void __init pci_enable_pci_io_ecs(void)
+static void __init pci_enable_pci_io_ecs(u8 bus, u8 slot)
 {
 #ifdef CONFIG_AMD_NB
 	unsigned int i, n;
+	u8 limit;
 
 	for (n = i = 0; !n && amd_nb_bus_dev_ranges[i].dev_limit; ++i) {
-		u8 bus = amd_nb_bus_dev_ranges[i].bus;
-		u8 slot = amd_nb_bus_dev_ranges[i].dev_base;
-		u8 limit = amd_nb_bus_dev_ranges[i].dev_limit;
+		/* Try matching for the bus range */
+		if ((bus != amd_nb_bus_dev_ranges[i].bus) ||
+		    (slot != amd_nb_bus_dev_ranges[i].dev_base))
+			continue;
+
+		limit = amd_nb_bus_dev_ranges[i].dev_limit;
 
+		/* Setup all northbridges within the range */
 		for (; slot < limit; ++slot) {
 			u32 val = read_pci_config(bus, slot, 3, 0);
-
-			if (!early_is_amd_nb(val))
+			if (!val)
 				continue;
 
 			val = read_pci_config(bus, slot, 3, 0x8c);
@@ -394,13 +468,14 @@ static void __init pci_enable_pci_io_ecs(void)
 				val |= ENABLE_CF8_EXT_CFG >> 32;
 				write_pci_config(bus, slot, 3, 0x8c, val);
 			}
+			amd_early_ecs_enabled = true;
 			++n;
 		}
 	}
 #endif
 }
 
-static int __init pci_io_ecs_init(void)
+static int __init pci_io_ecs_init(u8 bus, u8 slot)
 {
 	int cpu;
 
@@ -408,9 +483,7 @@ static int __init pci_io_ecs_init(void)
         if (boot_cpu_data.x86 < 0x10)
 		return 0;
 
-	/* Try the PCI method first. */
-	if (early_pci_allowed())
-		pci_enable_pci_io_ecs();
+	pci_enable_pci_io_ecs(bus, slot);
 
 	register_cpu_notifier(&amd_cpu_notifier);
 	for_each_online_cpu(cpu)
@@ -427,7 +500,6 @@ static int __init amd_postcore_init(void)
 		return 0;
 
 	early_fill_mp_bus_info();
-	pci_io_ecs_init();
 
 	return 0;
 }
-- 
1.7.10.4


