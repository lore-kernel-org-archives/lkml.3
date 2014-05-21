Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbaEUXSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:18:31 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:47883 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbaEUXS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:18:27 -0400
Subject: [PATCH V5 4/4] x86/PCI: Clean up and mark early_root_info_init() as
 deprecated
To: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Robert Richter <rric@kernel.org>, Daniel J Blueman <daniel@numascale.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        linux-pci@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Myron Stowe <myron.stowe@redhat.com>
Date: Wed, 21 May 2014 17:18:23 -0600
Message-ID: <20140521231823.26447.2250.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140521231615.26447.38060.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140521231615.26447.38060.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

early_root_info_init() is now deprecated in favor of info in ACPI.  Add a
note to that effect.  Also, clean up the code a bit.

There is no functional change.

Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/pci/amd_bus.c |   68 +++++++++++++++++++++++++++---------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 67dadf179348..cdce6ed59e2c 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -11,28 +11,33 @@
 
 #include "bus_numa.h"
 
-/*
- * This discovers the pcibus <-> node mapping on AMD K8.
- * also get peer root bus resource for io,mmio
- */
+#define AMD_NB_F0_NODE_ID			0x60
+#define AMD_NB_F0_UNIT_ID			0x64
+#define AMD_NB_F1_CONFIG_MAP_REG		0xe0
+
+#define RANGE_NUM				16
+#define AMD_NB_F1_CONFIG_MAP_RANGES		4
 
-struct pci_hostbridge_probe {
+struct amd_hostbridge {
 	u32 bus;
 	u32 slot;
-	u32 vendor;
 	u32 device;
 };
 
-static struct pci_hostbridge_probe pci_probes[] __initdata = {
-	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1100 }, /* K8 */
-	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1200 }, /* Fam10h */
-	{ 0xff, 0, PCI_VENDOR_ID_AMD, 0x1200 }, /* Fam10h */
-	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1300 }, /* Fam11h */
-	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1600 }, /* Fam15h */
+/*
+ * IMPORTANT NOTE:
+ * hb_probes[] and early_root_info_init() is in maintenance mode.
+ * It only supports K8, Fam10h, Fam11h, and Fam15h_00h-0fh .
+ * Future processor will rely on information in ACPI.
+ */
+static struct amd_hostbridge hb_probes[] __initdata = {
+	{ 0, 0x18, 0x1100 }, /* K8 */
+	{ 0, 0x18, 0x1200 }, /* Family10h */
+	{ 0xff, 0, 0x1200 }, /* Family10h */
+	{ 0, 0x18, 0x1300 }, /* Family11h */
+	{ 0, 0x18, 0x1600 }, /* Family15h */
 };
 
-#define RANGE_NUM 16
-
 static struct pci_root_info __init *find_pci_root_info(int node, int link)
 {
 	struct pci_root_info *info;
@@ -46,12 +51,12 @@ static struct pci_root_info __init *find_pci_root_info(int node, int link)
 }
 
 /**
- * early_fill_mp_bus_to_node()
+ * early_root_info_init()
  * called before pcibios_scan_root and pci_scan_bus
- * fills the mp_bus_to_cpumask array based according to the LDT Bus Number
- * Registers found in the K8 northbridge
+ * fills the mp_bus_to_cpumask array based according
+ * to the LDT Bus Number Registers found in the northbridge.
  */
-static int __init early_fill_mp_bus_info(void)
+static int __init early_root_info_init(void)
 {
 	int i;
 	unsigned bus;
@@ -76,19 +81,21 @@ static int __init early_fill_mp_bus_info(void)
 		return -1;
 
 	found = false;
-	for (i = 0; i < ARRAY_SIZE(pci_probes); i++) {
+	for (i = 0; i < ARRAY_SIZE(hb_probes); i++) {
 		u32 id;
 		u16 device;
 		u16 vendor;
 
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
+
+		if (vendor != PCI_VENDOR_ID_AMD)
+			continue;
+
+		if (hb_probes[i].device == device) {
 			found = true;
 			break;
 		}
@@ -102,10 +109,11 @@ static int __init early_fill_mp_bus_info(void)
 	 * _CRS methods in the ACPI namespace.  We extract node numbers
 	 * here to work around BIOSes that don't supply _PXM.
 	 */
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < AMD_NB_F1_CONFIG_MAP_RANGES; i++) {
 		int min_bus;
 		int max_bus;
-		reg = read_pci_config(bus, slot, 1, 0xe0 + (i << 2));
+		reg = read_pci_config(bus, slot, 1,
+				AMD_NB_F1_CONFIG_MAP_REG + (i << 2));
 
 		/* Check if that register is enabled for bus range */
 		if ((reg & 7) != 3)
@@ -131,9 +139,9 @@ static int __init early_fill_mp_bus_info(void)
 		return 0;
 
 	/* get the default node and link for left over res */
-	reg = read_pci_config(bus, slot, 0, 0x60);
+	reg = read_pci_config(bus, slot, 0, AMD_NB_F0_NODE_ID);
 	def_node = (reg >> 8) & 0x07;
-	reg = read_pci_config(bus, slot, 0, 0x64);
+	reg = read_pci_config(bus, slot, 0, AMD_NB_F0_UNIT_ID);
 	def_link = (reg >> 8) & 0x03;
 
 	memset(range, 0, sizeof(range));
@@ -380,7 +388,7 @@ static int __init pci_io_ecs_init(void)
 	int cpu;
 
 	/* assume all cpus from fam10h have IO ECS */
-        if (boot_cpu_data.x86 < 0x10)
+	if (boot_cpu_data.x86 < 0x10)
 		return 0;
 
 	/* Try the PCI method first. */
@@ -404,7 +412,7 @@ static int __init amd_postcore_init(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
 		return 0;
 
-	early_fill_mp_bus_info();
+	early_root_info_init();
 
 	if (boot_cpu_data.x86 <= 0x16)
 		pci_io_ecs_init();

