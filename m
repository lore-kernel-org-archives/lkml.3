Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbaEHQpD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:45:03 -0400
Received: from mail-bl2lp0206.outbound.protection.outlook.com ([207.46.163.206]:43042
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755077AbaEHQpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:45:00 -0400
X-WSS-ID: 0N59L6D-07-DX4-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        Borislav Petkov <bp@suse.de>, "Robert Richter" <rric@kernel.org>,
        Daniel J Blueman <daniel@numascale.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH V4 2/4] x86/PCI: Clean up and mark early_root_info_init as deprecated
Date: Thu, 8 May 2014 11:44:19 -0500
Message-ID: <1399567461-15928-3-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399567461-15928-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1399567461-15928-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(77982001)(62966002)(21056001)(53416003)(74502001)(92566001)(86362001)(85852003)(50466002)(50226001)(81542001)(84676001)(101416001)(89996001)(46102001)(93916002)(50986999)(92726001)(48376002)(97736001)(77156001)(74662001)(87936001)(19580405001)(36756003)(19580395003)(47776003)(68736004)(20776003)(99396002)(64706001)(2009001)(76176999)(83322001)(86152002)(87286001)(44976005)(88136002)(76482001)(4396001)(83072002)(33646001)(81342001)(80022001)(31966008)(79102001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR02MB123;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0205EDCD76
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

early_root_info_init is now deprecated in favor of info in ACPI.
Therefore, this patch adds note stating the deprecation.
Also, adding some clean up.

There is no functional change

Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
---
 arch/x86/pci/amd_bus.c | 69 ++++++++++++++++++++++++++++----------------------
 1 file changed, 39 insertions(+), 30 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 330dbfe..7c251c2 100644
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
@@ -97,10 +104,11 @@ static int __init early_fill_mp_bus_info(void)
 	if (!found)
 		return 0;
 
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < AMD_NB_F1_CONFIG_MAP_RANGES; i++) {
 		int min_bus;
 		int max_bus;
-		reg = read_pci_config(bus, slot, 1, 0xe0 + (i << 2));
+		reg = read_pci_config(bus, slot, 1,
+				AMD_NB_F1_CONFIG_MAP_REG + (i << 2));
 
 		/* Check if that register is enabled for bus range */
 		if ((reg & 7) != 3)
@@ -122,9 +130,9 @@ static int __init early_fill_mp_bus_info(void)
 		return 0;
 
 	/* get the default node and link for left over res */
-	reg = read_pci_config(bus, slot, 0, 0x60);
+	reg = read_pci_config(bus, slot, 0, AMD_NB_F0_NODE_ID);
 	def_node = (reg >> 8) & 0x07;
-	reg = read_pci_config(bus, slot, 0, 0x64);
+	reg = read_pci_config(bus, slot, 0, AMD_NB_F0_UNIT_ID);
 	def_link = (reg >> 8) & 0x03;
 
 	memset(range, 0, sizeof(range));
@@ -371,7 +379,7 @@ static int __init pci_io_ecs_init(void)
 	int cpu;
 
 	/* assume all cpus from fam10h have IO ECS */
-        if (boot_cpu_data.x86 < 0x10)
+	if (boot_cpu_data.x86 < 0x10)
 		return 0;
 
 	/* Try the PCI method first. */
@@ -395,7 +403,8 @@ static int __init amd_postcore_init(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
 		return 0;
 
-	early_fill_mp_bus_info();
+	early_root_info_init();
+
 	pci_io_ecs_init();
 
 	return 0;
-- 
1.9.0

