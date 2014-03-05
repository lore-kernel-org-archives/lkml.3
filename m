Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbaCEVHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:07:33 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:42891
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757374AbaCEVH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:07:26 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz1414Jzz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch21a7h1fc6hzz1de098h8275bh1de097hz2dh839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
X-WSS-ID: 0N1ZEO3-07-20H-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <aravind.gopalakrishnan@amd.com>,
        <kim.naru@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 3/3] amd/pci: Miscellaneous code clean up for early_fillup_mp_bus_info
Date: Wed, 5 Mar 2014 15:06:43 -0600
Message-ID: <1394053603-3724-4-git-send-email-suravee.suthikulpanit@amd.com>
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

This patch doesn't have functional changes. List of changes including

* Refactoring the function early_fill_mp_bus_info into multiple helper
  functions since it is getting long, and difficult to follow.

* Merge early_fill_mp_bus_info into amd_postcore_init since no need to have
  this as a separate function.

* Use pr_xxx instead of printk

* Prepends the "AMD-Bus" for each print.

* The current code is using "fam10h_mmconf_*" in several place.
  But this is not specific to family10h system. This patch changes
  it to "amd_mmconf_*" instead for clarity.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Tested-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 arch/x86/pci/amd_bus.c |  250 ++++++++++++++++++++++++++----------------------
 1 file changed, 136 insertions(+), 114 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 577995e..8ce3bd5 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -35,8 +35,6 @@
 
 static bool amd_early_ecs_enabled;
 
-static int __init pci_io_ecs_init(u8 bus, u8 slot);
-
 /*
  * This discovers the pcibus <-> node mapping on AMD K8.
  * also get peer root bus resource for io,mmio
@@ -96,84 +94,49 @@ static void __init set_mp_bus_range_to_node(int min_bus, int max_bus, int node)
 #endif
 }
 
-/**
- * early_fill_mp_bus_to_node()
- * called before pcibios_scan_root and pci_scan_bus
- * fills the mp_bus_to_cpumask array based according to the LDT Bus Number
- * Registers found in the K8 northbridge
- */
-static int __init early_fill_mp_bus_info(void)
+static struct amd_hostbridge * __init probe_pci_hostbridge(void)
 {
 	int i;
-	unsigned bus;
-	unsigned slot;
-	int node;
-	int link;
-	int def_node;
-	int def_link;
-	struct pci_root_info *info;
-	u32 reg;
-	u64 start;
-	u64 end;
-	struct range range[RANGE_NUM];
-	u64 val;
-	u32 address;
-	bool found;
-	struct resource fam10h_mmconf_res, *fam10h_mmconf;
-	u64 fam10h_mmconf_start;
-	u64 fam10h_mmconf_end;
+	struct amd_hostbridge *hb = NULL;
 
-	if (!early_pci_allowed())
-		return -1;
-
-	found = false;
 	for (i = 0; i < ARRAY_SIZE(hb_probes); i++) {
 		u32 id;
 		u16 device;
 		u16 vendor;
 		u32 class;
 
-		bus = hb_probes[i].bus;
-		slot = hb_probes[i].slot;
-		id = read_pci_config(bus, slot, 0, PCI_VENDOR_ID);
+		hb = &hb_probes[i];
+		id = read_pci_config(hb->bus, hb->slot, 0, PCI_VENDOR_ID);
 		vendor = id & 0xffff;
 		device = (id>>16) & 0xffff;
-		class = read_pci_config(bus, slot, 0,
+		class = read_pci_config(hb->bus, hb->slot, 0,
 			PCI_CLASS_REVISION) >> 16;
 
 		if (PCI_VENDOR_ID_AMD == vendor) {
-			if (hb_probes[i].device == device) {
-				found = true;
+			if (hb->device == device)
 				break;
-			}
 
-			if ((hb_probes[i].device == PCI_ANY_ID) &&
+			if ((hb->device == PCI_ANY_ID) &&
 			    (class == PCI_CLASS_BRIDGE_HOST)) {
-				hb_probes[i].device = device;
-				found = true;
+				hb->device = device;
 				break;
 			}
 		}
+		hb = NULL;
 	}
 
-	if (!found) {
-		printk(KERN_WARNING "AMD hostbridge not found\n");
-		return 0;
-	}
-
-	printk(KERN_DEBUG "Found AMD hostbridge at %x:%x.0\n", bus, slot);
+	return hb;
+}
 
-	/* We enabling ECS mode prior to probing MMIO since
-	 * the MMIO-related registers are in the ECS area.
-	 */
-	pci_io_ecs_init(bus, slot);
+static int __init setup_pci_root_info(struct amd_hostbridge *hb)
+{
+	int i, min_bus, max_bus;
+	int node = 0, link = 0;
+	bool found = false;
 
-	found = false;
 	for (i = 0; i < AMD_NB_F1_CONFIG_MAP_RANGES; i++) {
-		int min_bus;
-		int max_bus;
-		reg = read_pci_config(bus, slot, 1,
-				AMD_NB_F1_CONFIG_MAP_REG + (i << 2));
+		int offset = AMD_NB_F1_CONFIG_MAP_REG + (i << 2);
+		u32 reg = read_pci_config(hb->bus, hb->slot, 1, offset);
 
 		/* Check if that register is enabled for bus range */
 		if ((reg & 7) != 3)
@@ -186,7 +149,8 @@ static int __init early_fill_mp_bus_info(void)
 		set_mp_bus_range_to_node(min_bus, max_bus, node);
 		link = (reg >> 8) & 0x03;
 
-		info = alloc_pci_root_info(min_bus, max_bus, node, link);
+		if (!alloc_pci_root_info(min_bus, max_bus, node, link))
+			return -ENOMEM;
 	}
 
 	if (!found) {
@@ -194,27 +158,33 @@ static int __init early_fill_mp_bus_info(void)
 		 * we just use default to bus 0, node 0 link 0)
 		 */
 		set_mp_bus_range_to_node(0, 0, 0);
-		info = alloc_pci_root_info(0, 0, 0, 0);
+		if (!alloc_pci_root_info(0, 0, 0, 0))
+			return -ENOMEM;
 	}
 
-	/* get the default node and link for left over res */
-	reg = read_pci_config(bus, slot, 0, AMD_NB_F0_NODE_ID);
-	def_node = (reg >> 8) & 0x07;
-	reg = read_pci_config(bus, slot, 0, AMD_NB_F0_UNIT_ID);
-	def_link = (reg >> 8) & 0x03;
+	return 0;
+}
+
+static void __init probe_ioport_resource(struct amd_hostbridge *hb)
+{
+	int i, node, link;
+	u64 start, end;
+	u32 reg;
+	struct pci_root_info *info;
+	struct range range[RANGE_NUM];
 
 	memset(range, 0, sizeof(range));
 	add_range(range, RANGE_NUM, 0, 0, 0xffff + 1);
 
 	/* io port resource */
 	for (i = 0; i < AMD_NB_F1_IOPORT_RANGES; i++) {
-		reg = read_pci_config(bus, slot, 1,
+		reg = read_pci_config(hb->bus, hb->slot, 1,
 				AMD_NB_F1_IO_BASEA_DDR_REG + (i << 3));
 		if (!(reg & 3))
 			continue;
 
 		start = reg & 0xfff000;
-		reg = read_pci_config(bus, slot, 1,
+		reg = read_pci_config(hb->bus, hb->slot, 1,
 				AMD_NB_F1_IO_LIMIT_ADDR_REG + (i << 3));
 		node = reg & 0x07;
 		link = (reg >> 4) & 0x03;
@@ -224,8 +194,8 @@ static int __init early_fill_mp_bus_info(void)
 		if (!info)
 			continue; /* not found */
 
-		printk(KERN_DEBUG "node %d link %d: io port [%llx, %llx]\n",
-		       node, link, start, end);
+		printk(KERN_DEBUG "AMD-Bus: index %d node %d link %d: io port [%llx, %llx]\n",
+		       i, node, link, start, end);
 
 		/* kernel only handle 16 bit only */
 		if (end > 0xffff)
@@ -236,7 +206,12 @@ static int __init early_fill_mp_bus_info(void)
 
 	/* add left over io port range to def node/link, [0, 0xffff] */
 	/* find the position */
-	info = find_pci_root_info(def_node, def_link);
+
+	reg = read_pci_config(hb->bus, hb->slot, 0, AMD_NB_F0_NODE_ID);
+	node = (reg >> 8) & 0x07;
+	reg = read_pci_config(hb->bus, hb->slot, 0, AMD_NB_F0_UNIT_ID);
+	link = (reg >> 8) & 0x03;
+	info = find_pci_root_info(node, link);
 	if (info) {
 		for (i = 0; i < RANGE_NUM; i++) {
 			if (!range[i].end)
@@ -246,8 +221,19 @@ static int __init early_fill_mp_bus_info(void)
 				   IORESOURCE_IO, 1);
 		}
 	}
+}
+
+static void __init probe_mmio_resource(struct amd_hostbridge *hb)
+{
+	int i, node, link;
+	u32 address, reg;
+	u64 start, end, val, amd_mmconf_start, amd_mmconf_end;
+	struct pci_root_info *info;
+	struct resource amd_mmconf_res, *amd_mmconf;
+	struct range range[RANGE_NUM];
 
 	memset(range, 0, sizeof(range));
+
 	/* 0xfd00000000-0xffffffffff for HT */
 	end = cap_resource((0xfdULL<<32) - 1);
 	end++;
@@ -257,25 +243,25 @@ static int __init early_fill_mp_bus_info(void)
 	address = MSR_K8_TOP_MEM1;
 	rdmsrl(address, val);
 	end = (val & 0xffffff800000ULL);
-	printk(KERN_INFO "TOM: %016llx aka %lldM\n", end, end>>20);
+	pr_info("AMD-Bus: TOM: %016llx aka %lldM\n", end, end>>20);
 	if (end < (1ULL<<32))
 		subtract_range(range, RANGE_NUM, 0, end);
 
 	/* get mmconfig */
-	fam10h_mmconf = amd_get_mmconfig_range(&fam10h_mmconf_res);
+	amd_mmconf = amd_get_mmconfig_range(&amd_mmconf_res);
 	/* need to take out mmconf range */
-	if (fam10h_mmconf) {
-		printk(KERN_DEBUG "Fam 10h mmconf %pR\n", fam10h_mmconf);
-		fam10h_mmconf_start = fam10h_mmconf->start;
-		fam10h_mmconf_end = fam10h_mmconf->end;
-		subtract_range(range, RANGE_NUM, fam10h_mmconf_start,
-				 fam10h_mmconf_end + 1);
+	if (amd_mmconf) {
+		printk(KERN_DEBUG "AMD-Bus: mmconf %pR\n", amd_mmconf);
+		amd_mmconf_start = amd_mmconf->start;
+		amd_mmconf_end = amd_mmconf->end;
+		subtract_range(range, RANGE_NUM, amd_mmconf_start,
+				 amd_mmconf_end + 1);
 	} else {
-		fam10h_mmconf_start = 0;
-		fam10h_mmconf_end = 0;
+		amd_mmconf_start = 0;
+		amd_mmconf_end = 0;
 	}
 
-	/* mmio resource */
+	/* Probing mmio base/limit regs */
 	for (i = 0; i < AMD_NB_F1_MMIO_RANGES; i++) {
 		u64 tmp;
 		u32 base = AMD_NB_F1_MMIO_BASE_REG + (i << 3);
@@ -297,21 +283,21 @@ static int __init early_fill_mp_bus_info(void)
 		}
 
 		/* Base lo */
-		reg = _amd_read_pci_config(bus, slot, 1, base);
+		reg = _amd_read_pci_config(hb->bus, hb->slot, 1, base);
 		if (!(reg & 3))
 			continue;
 
 		start = (reg & 0xffffff00UL) << 8; /* 39:16 on 31:8*/
 
 		/* Limit lo */
-		reg = _amd_read_pci_config(bus, slot, 1, limit);
+		reg = _amd_read_pci_config(hb->bus, hb->slot, 1, limit);
 		node = reg & 0x07;
 		link = (reg >> 4) & 0x03;
 		end = (reg & 0xffffff00UL) << 8; /* 39:16 on 31:8*/
 		end |= 0xffffUL;
 
 		/* Base/Limit hi */
-		tmp = _amd_read_pci_config(bus, slot, 1, base_limit_hi);
+		tmp = _amd_read_pci_config(hb->bus, hb->slot, 1, base_limit_hi);
 		start |= ((tmp & 0xffUL) << 40);
 		end |= ((tmp & (0xffUL << 16)) << 24);
 
@@ -319,36 +305,38 @@ static int __init early_fill_mp_bus_info(void)
 		if (!info)
 			continue;
 
-		printk(KERN_DEBUG "node %d link %d: mmio [%llx, %llx]",
-		       node, link, start, end);
+		printk(KERN_DEBUG "AMD-Bus: index %d node %d link %d: mmio [%llx, %llx]",
+		       i, node, link, start, end);
+
 		/*
 		 * some sick allocation would have range overlap with fam10h
 		 * mmconf range, so need to update start and end.
 		 */
-		if (fam10h_mmconf_end) {
+		if (amd_mmconf_end) {
 			int changed = 0;
 			u64 endx = 0;
-			if (start >= fam10h_mmconf_start &&
-			    start <= fam10h_mmconf_end) {
-				start = fam10h_mmconf_end + 1;
+			if (start >= amd_mmconf_start &&
+			    start <= amd_mmconf_end) {
+				start = amd_mmconf_end + 1;
 				changed = 1;
 			}
 
-			if (end >= fam10h_mmconf_start &&
-			    end <= fam10h_mmconf_end) {
-				end = fam10h_mmconf_start - 1;
+			if (end >= amd_mmconf_start &&
+			    end <= amd_mmconf_end) {
+				end = amd_mmconf_start - 1;
 				changed = 1;
 			}
 
-			if (start < fam10h_mmconf_start &&
-			    end > fam10h_mmconf_end) {
+			if (start < amd_mmconf_start &&
+			    end > amd_mmconf_end) {
 				/* we got a hole */
-				endx = fam10h_mmconf_start - 1;
-				update_res(info, start, endx, IORESOURCE_MEM, 0);
+				endx = amd_mmconf_start - 1;
+				update_res(info, start, endx,
+						IORESOURCE_MEM, 0);
 				subtract_range(range, RANGE_NUM, start,
 						 endx + 1);
 				printk(KERN_CONT " ==> [%llx, %llx]", start, endx);
-				start = fam10h_mmconf_end + 1;
+				start = amd_mmconf_end + 1;
 				changed = 1;
 			}
 			if (changed) {
@@ -377,7 +365,8 @@ static int __init early_fill_mp_bus_info(void)
 		address = MSR_K8_TOP_MEM2;
 		rdmsrl(address, val);
 		end = (val & 0xffffff800000ULL);
-		printk(KERN_INFO "TOM2: %016llx aka %lldM\n", end, end>>20);
+		pr_info("AMD-Bus: TOM2: %016llx aka %lldM\n",
+			end, end>>20);
 		subtract_range(range, RANGE_NUM, 1ULL<<32, end);
 	}
 
@@ -385,7 +374,11 @@ static int __init early_fill_mp_bus_info(void)
 	 * add left over mmio range to def node/link ?
 	 * that is tricky, just record range in from start_min to 4G
 	 */
-	info = find_pci_root_info(def_node, def_link);
+	reg = read_pci_config(hb->bus, hb->slot, 0, AMD_NB_F0_NODE_ID);
+	node = (reg >> 8) & 0x07;
+	reg = read_pci_config(hb->bus, hb->slot, 0, AMD_NB_F0_UNIT_ID);
+	link = (reg >> 8) & 0x03;
+	info = find_pci_root_info(node, link);
 	if (info) {
 		for (i = 0; i < RANGE_NUM; i++) {
 			if (!range[i].end)
@@ -396,20 +389,6 @@ static int __init early_fill_mp_bus_info(void)
 				   IORESOURCE_MEM, 1);
 		}
 	}
-
-	list_for_each_entry(info, &pci_root_infos, list) {
-		int busnum;
-		struct pci_root_res *root_res;
-
-		busnum = info->busn.start;
-		printk(KERN_DEBUG "bus: %pR on node %x link %x\n",
-		       &info->busn, info->node, info->link);
-		list_for_each_entry(root_res, &info->resources, list)
-			printk(KERN_DEBUG "bus: %02x %pR\n",
-				       busnum, &root_res->res);
-	}
-
-	return 0;
 }
 
 #define ENABLE_CF8_EXT_CFG      (1ULL << 46)
@@ -475,7 +454,7 @@ static void __init pci_enable_pci_io_ecs(u8 bus, u8 slot)
 #endif
 }
 
-static int __init pci_io_ecs_init(u8 bus, u8 slot)
+static int __init pci_io_ecs_init(struct amd_hostbridge *hb)
 {
 	int cpu;
 
@@ -483,7 +462,7 @@ static int __init pci_io_ecs_init(u8 bus, u8 slot)
         if (boot_cpu_data.x86 < 0x10)
 		return 0;
 
-	pci_enable_pci_io_ecs(bus, slot);
+	pci_enable_pci_io_ecs(hb->bus, hb->slot);
 
 	register_cpu_notifier(&amd_cpu_notifier);
 	for_each_online_cpu(cpu)
@@ -494,12 +473,55 @@ static int __init pci_io_ecs_init(u8 bus, u8 slot)
 	return 0;
 }
 
+
+/**
+ * amd_postcore_init is called before pcibios_scan_root and pci_scan_bus.
+ */
 static int __init amd_postcore_init(void)
 {
+	struct pci_root_info *info;
+	struct amd_hostbridge *hb;
+
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
 		return 0;
 
-	early_fill_mp_bus_info();
+	if (!early_pci_allowed())
+		return -1;
+
+	hb = probe_pci_hostbridge();
+	if (!hb) {
+		pr_warn("AMD-Bus: AMD hostbridge not found\n");
+		return -1;
+	}
+
+	printk(KERN_DEBUG "AMD-Bus: Found hostbridge %x:%x.0 (device ID = %#x)\n",
+		hb->bus, hb->slot, hb->device);
+
+	/* We enabling ECS mode prior to probing MMIO since
+	 * the MMIO-related registers are in the ECS area.
+	 */
+	pci_io_ecs_init(hb);
+
+	if (setup_pci_root_info(hb) != 0) {
+		pr_warn("AMD-Bus: Failed to setup pci root info.\n");
+		return -1;
+	}
+
+	probe_ioport_resource(hb);
+
+	probe_mmio_resource(hb);
+
+	list_for_each_entry(info, &pci_root_infos, list) {
+		int busnum;
+		struct pci_root_res *root_res;
+
+		busnum = info->busn.start;
+		printk(KERN_DEBUG "AMD-Bus: bus: %pR on node %x link %x\n",
+		       &info->busn, info->node, info->link);
+		list_for_each_entry(root_res, &info->resources, list)
+			printk(KERN_DEBUG "AMD-Bus: bus: %02x %pR\n",
+				       busnum, &root_res->res);
+	}
 
 	return 0;
 }
-- 
1.7.10.4


