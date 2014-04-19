Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbaDSCxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 22:53:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754778AbaDSCxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 22:53:38 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH v2 2/5] x86/PCI: Support additional MMIO range capabilities
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: suravee.suthikulpanit@amd.com, aravind.gopalakrishnan@amd.com,
        kim.naru@amd.com, andreas.herrmann3@amd.com, daniel@numascale.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        bp@suse.de, sp@numascale.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 18 Apr 2014 20:53:23 -0600
Message-ID: <20140419025323.2408.88764.stgit@amt.stowe>
In-Reply-To: <20140419025308.2408.51252.stgit@amt.stowe>
References: <20140419025308.2408.51252.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

This patch adds supports for additional MMIO ranges (16 ranges).  Also,
each MMIO base/limit can now support up to 48-bit MMIO addresses.
However, this requires initializing the ECS sooner since the new registers
are in the ECS ranges.

This applies for AMD Family 15h and later.

Reference: Advanced Micro Devices (AMD), "BIOS and Kernel Developer's
Guide (BKDG) for AMD Family 15h Models 00h-0fh Processors."  Section 3.4
Device [1F:18]h Function 1 Configuration Registers;
  D18F1x[1CC:180,BC:80] MMIO Base/Limit,
  D18F1x[D8,D0,C8,C0] IO-Space Base,
  D18F1x[DC,D4,CC,C4] IO-Space Limit,
42301 Rev 3.12 - October 11, 2012.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
Tested-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---

 arch/x86/pci/amd_bus.c |  126 +++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 103 insertions(+), 23 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index c8cd75c..1b2895e 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -13,11 +13,30 @@
 
 #define AMD_NB_F0_NODE_ID			0x60
 #define AMD_NB_F0_UNIT_ID			0x64
+#define AMD_NB_F1_MMIO_BASE_REG			0x80
+#define AMD_NB_F1_MMIO_LIMIT_REG		0x84
+#define AMD_NB_F1_MMIO_BASE_LIMIT_HI_REG	0x180
+#define AMD_NB_F1_IO_BASE_ADDR_REG		0xc0
+#define AMD_NB_F1_IO_LIMIT_ADDR_REG		0xc4
 #define AMD_NB_F1_CONFIG_MAP_REG		0xe0
 
 #define RANGE_NUM				16
+#define AMD_NB_F1_MMIO_RANGES			16
+#define AMD_NB_F1_IOPORT_RANGES			4
 #define AMD_NB_F1_CONFIG_MAP_RANGES		4
 
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
  * This discovers the pcibus <-> node mapping on AMD K8, Family 10h, 12h,
  * 14h, 15h, and 16h processor based systems.  This also gets peer root bus
@@ -39,6 +58,20 @@ static struct amd_hostbridge hb_probes[] __initdata = {
 	{ 0xff, 0   , PCI_DEVICE_ID_AMD_10H_NB_HT },
 };
 
+/* This version of read_pci_config allows reading registers in the ECS area */
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
@@ -48,6 +81,9 @@ static struct pci_root_info __init *find_pci_root_info(int node, int link)
 		if (info->node == node && info->link == link)
 			return info;
 
+	pr_warn("AMD-Bus: WARNING: Failed to find root info for node %#x, link %#x\n",
+		node, link);
+
 	return NULL;
 }
 
@@ -118,6 +154,12 @@ static int __init early_fill_mp_bus_info(void)
 
 	pr_debug("Found AMD hostbridge at %x:%x.0\n", bus, slot);
 
+	/* We enable ECS mode prior to probing MMIO as MMIO related registers
+	 * are in the ECS area.
+	 */
+	pci_io_ecs_init(bus, slot);
+
+	found = false;
 	for (i = 0; i < AMD_NB_F1_CONFIG_MAP_RANGES; i++) {
 		int min_bus;
 		int max_bus;
@@ -128,6 +170,7 @@ static int __init early_fill_mp_bus_info(void)
 		if ((reg & 7) != 3)
 			continue;
 
+		found = true;
 		min_bus = (reg >> 16) & 0xff;
 		max_bus = (reg >> 24) & 0xff;
 		node = (reg >> 4) & 0x07;
@@ -136,6 +179,13 @@ static int __init early_fill_mp_bus_info(void)
 		info = alloc_pci_root_info(min_bus, max_bus, node, link);
 	}
 
+	if (!found) {
+		/* In case there is no AMDNB_F1_CONFIG_MAP_REGs,
+		 * we just use default to bus 0, node 0 link 0)
+		 */
+		info = alloc_pci_root_info(0, 0, 0, 0);
+	}
+
 	/* get the default node and link for left over res */
 	reg = read_pci_config(bus, slot, 0, AMD_NB_F0_NODE_ID);
 	def_node = (reg >> 8) & 0x07;
@@ -144,14 +194,17 @@ static int __init early_fill_mp_bus_info(void)
 
 	memset(range, 0, sizeof(range));
 	add_range(range, RANGE_NUM, 0, 0, 0xffff + 1);
+
 	/* io port resource */
-	for (i = 0; i < 4; i++) {
-		reg = read_pci_config(bus, slot, 1, 0xc0 + (i << 3));
+	for (i = 0; i < AMD_NB_F1_IOPORT_RANGES; i++) {
+		reg = read_pci_config(bus, slot, 1,
+				AMD_NB_F1_IO_BASE_ADDR_REG + (i << 3));
 		if (!(reg & 3))
 			continue;
 
 		start = reg & 0xfff000;
-		reg = read_pci_config(bus, slot, 1, 0xc4 + (i << 3));
+		reg = read_pci_config(bus, slot, 1,
+				AMD_NB_F1_IO_LIMIT_ADDR_REG + (i << 3));
 		node = reg & 0x07;
 		link = (reg >> 4) & 0x03;
 		end = (reg & 0xfff000) | 0xfff;
@@ -169,6 +222,7 @@ static int __init early_fill_mp_bus_info(void)
 		update_res(info, start, end, IORESOURCE_IO, 1);
 		subtract_range(range, RANGE_NUM, start, end + 1);
 	}
+
 	/* add left over io port range to def node/link, [0, 0xffff] */
 	/* find the position */
 	info = find_pci_root_info(def_node, def_link);
@@ -211,22 +265,46 @@ static int __init early_fill_mp_bus_info(void)
 	}
 
 	/* mmio resource */
-	for (i = 0; i < 8; i++) {
-		reg = read_pci_config(bus, slot, 1, 0x80 + (i << 3));
+	for (i = 0; i < AMD_NB_F1_MMIO_RANGES; i++) {
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
-		reg = read_pci_config(bus, slot, 1, 0x84 + (i << 3));
+		start = (reg & 0xffffff00UL) << 8;	/* 39:16 on 31:8 */
+
+		/* Limit lo */
+		reg = _amd_read_pci_config(bus, slot, 1, limit);
 		node = reg & 0x07;
 		link = (reg >> 4) & 0x03;
-		end = (reg & 0xffffff00);
-		end <<= 8;
-		end |= 0xffff;
+		end = (reg & 0xffffff00UL) << 8;	/* 39:16 on 31:8 */
+		end |= 0xffffUL;
 
-		info = find_pci_root_info(node, link);
+		/* Base/Limit hi */
+		tmp = _amd_read_pci_config(bus, slot, 1, base_limit_hi);
+		start |= ((tmp & 0xffUL) << 40);
+		end |= ((tmp & (0xffUL << 16)) << 24);
 
+		info = find_pci_root_info(node, link);
 		if (!info)
 			continue;
 
@@ -354,20 +432,24 @@ static struct notifier_block amd_cpu_notifier = {
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
@@ -375,13 +457,14 @@ static void __init pci_enable_pci_io_ecs(void)
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
 
@@ -389,9 +472,7 @@ static int __init pci_io_ecs_init(void)
         if (boot_cpu_data.x86 < 0x10)
 		return 0;
 
-	/* Try the PCI method first. */
-	if (early_pci_allowed())
-		pci_enable_pci_io_ecs();
+	pci_enable_pci_io_ecs(bus, slot);
 
 	cpu_notifier_register_begin();
 	for_each_online_cpu(cpu)
@@ -411,7 +492,6 @@ static int __init amd_postcore_init(void)
 		return 0;
 
 	early_fill_mp_bus_info();
-	pci_io_ecs_init();
 
 	return 0;
 }

