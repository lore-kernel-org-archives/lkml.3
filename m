Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbaDSCxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 22:53:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754778AbaDSCxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 22:53:46 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH v2 3/5] x86/PCI: Miscellaneous code clean up for
	early_fillup_mp_bus_info
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: suravee.suthikulpanit@amd.com, aravind.gopalakrishnan@amd.com,
        kim.naru@amd.com, andreas.herrmann3@amd.com, daniel@numascale.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        bp@suse.de, sp@numascale.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 18 Apr 2014 20:53:31 -0600
Message-ID: <20140419025331.2408.40589.stgit@amt.stowe>
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

* Refactoring of the early_fill_mp_bus_info function into multiple helper
  functions since it is getting long, and difficult to follow.

* Merge early_fill_mp_bus_info into amd_postcore_init as there is no need to
  have this as a separate function.

* Use pr_xxx instead of printk

* Prepend "AMD-Bus" for each print.

* The current code is using "fam10h_mmconf_*" in several place.  As this
  file is no longer specific to family10h systems, this patch changes
  such occurrances to "amd_mmconf_*" instead for clarity.

No functional changes.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
Tested-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---

 arch/x86/pci/amd_bus.c |  284 ++++++++++++++++++++++++++----------------------
 1 files changed, 152 insertions(+), 132 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 1b2895e..c15add6 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -35,8 +35,6 @@
 
 static bool amd_early_ecs_enabled;
 
-static int __init pci_io_ecs_init(u8 bus, u8 slot);
-
 /*
  * This discovers the pcibus <-> node mapping on AMD K8, Family 10h, 12h,
  * 14h, 15h, and 16h processor based systems.  This also gets peer root bus
@@ -87,86 +85,51 @@ static struct pci_root_info __init *find_pci_root_info(int node, int link)
 	return NULL;
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
-
-	if (!early_pci_allowed())
-		return -1;
+	struct amd_hostbridge *hb = NULL;
 
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
-		pr_warn("AMD hostbridge not found\n");
-		return 0;
-	}
-
-	pr_debug("Found AMD hostbridge at %x:%x.0\n", bus, slot);
+	return hb;
+}
 
-	/* We enable ECS mode prior to probing MMIO as MMIO related registers
-	 * are in the ECS area.
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
 
-		/* Check if that register is enabled for bus range */
+		/* Check if register is enabled for bus range */
 		if ((reg & 7) != 3)
 			continue;
 
@@ -176,34 +139,41 @@ static int __init early_fill_mp_bus_info(void)
 		node = (reg >> 4) & 0x07;
 		link = (reg >> 8) & 0x03;
 
-		info = alloc_pci_root_info(min_bus, max_bus, node, link);
+		if (!alloc_pci_root_info(min_bus, max_bus, node, link))
+			return -ENOMEM;
 	}
 
 	if (!found) {
-		/* In case there is no AMDNB_F1_CONFIG_MAP_REGs,
-		 * we just use default to bus 0, node 0 link 0)
+		/* In case there are no AMDNB_F1_CONFIG_MAP_REGs, default
+		 * to bus 0, node 0 link 0.
 		 */
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
 
-	/* io port resource */
+	/* I/O port resource */
 	for (i = 0; i < AMD_NB_F1_IOPORT_RANGES; i++) {
-		reg = read_pci_config(bus, slot, 1,
+		reg = read_pci_config(hb->bus, hb->slot, 1,
 				AMD_NB_F1_IO_BASE_ADDR_REG + (i << 3));
 		if (!(reg & 3))
 			continue;
 
 		start = reg & 0xfff000;
-		reg = read_pci_config(bus, slot, 1,
+		reg = read_pci_config(hb->bus, hb->slot, 1,
 				AMD_NB_F1_IO_LIMIT_ADDR_REG + (i << 3));
 		node = reg & 0x07;
 		link = (reg >> 4) & 0x03;
@@ -213,19 +183,23 @@ static int __init early_fill_mp_bus_info(void)
 		if (!info)
 			continue; /* not found */
 
-		printk(KERN_DEBUG "node %d link %d: io port [%llx, %llx]\n",
-		       node, link, start, end);
+		pr_debug("AMD-Bus: index %d node %d link %d: io port [%llx, %llx]\n",
+		       i, node, link, start, end);
 
-		/* kernel only handle 16 bit only */
+		/* Kernel handles 16 bit only */
 		if (end > 0xffff)
 			end = 0xffff;
 		update_res(info, start, end, IORESOURCE_IO, 1);
 		subtract_range(range, RANGE_NUM, start, end + 1);
 	}
 
-	/* add left over io port range to def node/link, [0, 0xffff] */
-	/* find the position */
-	info = find_pci_root_info(def_node, def_link);
+	/* Add left over I/O port range to def node/link, [0, 0xffff] */
+	/* Find the position */
+	reg = read_pci_config(hb->bus, hb->slot, 0, AMD_NB_F0_NODE_ID);
+	node = (reg >> 8) & 0x07;
+	reg = read_pci_config(hb->bus, hb->slot, 0, AMD_NB_F0_UNIT_ID);
+	link = (reg >> 8) & 0x03;
+	info = find_pci_root_info(node, link);
 	if (info) {
 		for (i = 0; i < RANGE_NUM; i++) {
 			if (!range[i].end)
@@ -235,36 +209,47 @@ static int __init early_fill_mp_bus_info(void)
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
 	add_range(range, RANGE_NUM, 0, 0, end);
 
-	/* need to take out [0, TOM) for RAM*/
+	/* Need to take out [0, TOM] for RAM */
 	address = MSR_K8_TOP_MEM1;
 	rdmsrl(address, val);
 	end = (val & 0xffffff800000ULL);
-	printk(KERN_INFO "TOM: %016llx aka %lldM\n", end, end>>20);
+	pr_info("AMD-Bus: TOM: %016llx aka %lldM\n", end, end>>20);
 	if (end < (1ULL<<32))
 		subtract_range(range, RANGE_NUM, 0, end);
 
-	/* get mmconfig */
-	fam10h_mmconf = amd_get_mmconfig_range(&fam10h_mmconf_res);
-	/* need to take out mmconf range */
-	if (fam10h_mmconf) {
-		printk(KERN_DEBUG "Fam 10h mmconf %pR\n", fam10h_mmconf);
-		fam10h_mmconf_start = fam10h_mmconf->start;
-		fam10h_mmconf_end = fam10h_mmconf->end;
-		subtract_range(range, RANGE_NUM, fam10h_mmconf_start,
-				 fam10h_mmconf_end + 1);
+	/* Get mmconfig */
+	amd_mmconf = amd_get_mmconfig_range(&amd_mmconf_res);
+	/* Need to take out MMCONF range */
+	if (amd_mmconf) {
+		pr_debug("AMD-Bus: mmconf %pR\n", amd_mmconf);
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
+	/* Probing MMIO base/limit regs */
 	for (i = 0; i < AMD_NB_F1_MMIO_RANGES; i++) {
 		u64 tmp;
 		u32 base = AMD_NB_F1_MMIO_BASE_REG + (i << 3);
@@ -286,21 +271,21 @@ static int __init early_fill_mp_bus_info(void)
 		}
 
 		/* Base lo */
-		reg = _amd_read_pci_config(bus, slot, 1, base);
+		reg = _amd_read_pci_config(hb->bus, hb->slot, 1, base);
 		if (!(reg & 3))
 			continue;
 
 		start = (reg & 0xffffff00UL) << 8;	/* 39:16 on 31:8 */
 
 		/* Limit lo */
-		reg = _amd_read_pci_config(bus, slot, 1, limit);
+		reg = _amd_read_pci_config(hb->bus, hb->slot, 1, limit);
 		node = reg & 0x07;
 		link = (reg >> 4) & 0x03;
 		end = (reg & 0xffffff00UL) << 8;	/* 39:16 on 31:8 */
 		end |= 0xffffUL;
 
 		/* Base/Limit hi */
-		tmp = _amd_read_pci_config(bus, slot, 1, base_limit_hi);
+		tmp = _amd_read_pci_config(hb->bus, hb->slot, 1, base_limit_hi);
 		start |= ((tmp & 0xffUL) << 40);
 		end |= ((tmp & (0xffUL << 16)) << 24);
 
@@ -308,36 +293,38 @@ static int __init early_fill_mp_bus_info(void)
 		if (!info)
 			continue;
 
-		printk(KERN_DEBUG "node %d link %d: mmio [%llx, %llx]",
-		       node, link, start, end);
+		pr_debug("AMD-Bus: index %d node %d link %d: mmio [%llx, %llx]",
+		       i, node, link, start, end);
+
 		/*
-		 * some sick allocation would have range overlap with fam10h
-		 * mmconf range, so need to update start and end.
+		 * Some (sick) allocations have range overlapping with MMCONF
+		 * range, so need to update start and end.
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
-				/* we got a hole */
-				endx = fam10h_mmconf_start - 1;
-				update_res(info, start, endx, IORESOURCE_MEM, 0);
+			if (start < amd_mmconf_start &&
+			    end > amd_mmconf_end) {
+				/* We got a hole */
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
@@ -356,25 +343,30 @@ static int __init early_fill_mp_bus_info(void)
 		printk(KERN_CONT "\n");
 	}
 
-	/* need to take out [4G, TOM2) for RAM*/
+	/* Need to take out [4G, TOM2] for RAM */
 	/* SYS_CFG */
 	address = MSR_K8_SYSCFG;
 	rdmsrl(address, val);
-	/* TOP_MEM2 is enabled? */
+	/* Is TOP_MEM2 enabled? */
 	if (val & (1<<21)) {
 		/* TOP_MEM2 */
 		address = MSR_K8_TOP_MEM2;
 		rdmsrl(address, val);
 		end = (val & 0xffffff800000ULL);
-		printk(KERN_INFO "TOM2: %016llx aka %lldM\n", end, end>>20);
+		pr_info("AMD-Bus: TOM2: %016llx aka %lldM\n",
+			end, end>>20);
 		subtract_range(range, RANGE_NUM, 1ULL<<32, end);
 	}
 
 	/*
-	 * add left over mmio range to def node/link ?
-	 * that is tricky, just record range in from start_min to 4G
+	 * Add left over MMIO range to def node/link?
+	 * That is tricky, just record range from start_min to 4G.
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
@@ -385,20 +377,6 @@ static int __init early_fill_mp_bus_info(void)
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
@@ -464,15 +442,15 @@ static void __init pci_enable_pci_io_ecs(u8 bus, u8 slot)
 #endif
 }
 
-static int __init pci_io_ecs_init(u8 bus, u8 slot)
+static int __init pci_io_ecs_init(struct amd_hostbridge *hb)
 {
 	int cpu;
 
-	/* assume all cpus from fam10h have IO ECS */
+	/* Assume all CPUs from Family 10h onward have IO ECS */
         if (boot_cpu_data.x86 < 0x10)
 		return 0;
 
-	pci_enable_pci_io_ecs(bus, slot);
+	pci_enable_pci_io_ecs(hb->bus, hb->slot);
 
 	cpu_notifier_register_begin();
 	for_each_online_cpu(cpu)
@@ -486,12 +464,54 @@ static int __init pci_io_ecs_init(u8 bus, u8 slot)
 	return 0;
 }
 
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
+	pr_debug("AMD-Bus: Found hostbridge %x:%x.0 (device ID = %#x)\n",
+		hb->bus, hb->slot, hb->device);
+
+	/* Enable Extended Configuration Space (ECS) mode prior to probing
+	 * MMIO since the MMIO related registers are in the ECS area.
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
+		pr_debug("AMD-Bus: bus: %pR on node %x link %x\n",
+			&info->busn, info->node, info->link);
+		list_for_each_entry(root_res, &info->resources, list)
+			pr_debug("AMD-Bus: bus: %02x %pR\n",
+					busnum, &root_res->res);
+	}
 
 	return 0;
 }

