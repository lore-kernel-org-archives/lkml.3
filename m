Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbaI1Uyn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 16:54:43 -0400
Received: from mail-bn1bn0109.outbound.protection.outlook.com ([157.56.110.109]:9653
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753525AbaI1Uye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 16:54:34 -0400
X-WSS-ID: 0NCMQ2Q-08-OWH-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <will.deacon@arm.com>, <liviu.dudau@arm.com>, <marc.zyngier@arm.com>,
        <mark.rutland@arm.com>, <catalin.marinas@arm.com>,
        <jason@lakedaemon.net>, <tglx@linutronix.de>, <robh+dt@kernel.org>,
        <bhelgaas@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>
Subject: [RFC 2/4] PCI: generic: Add support for ARM64 and MSI(x)
Date: Sun, 28 Sep 2014 15:53:28 -0500
Message-ID: <1411937610-22125-3-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(87936001)(64706001)(62966002)(83072002)(20776003)(21056001)(33646002)(50226001)(88136002)(95666004)(81342003)(4396001)(47776003)(74502003)(50466002)(80022003)(48376002)(104166001)(77982003)(79102003)(74662003)(81542003)(102836001)(105586002)(89996001)(87286001)(85852003)(85306004)(84676001)(120916001)(86362001)(10300001)(77096002)(93916002)(76482002)(76176999)(86152002)(575784001)(92566001)(90102001)(31966008)(36756003)(97736003)(19580405001)(46102003)(19580395003)(92726001)(106466001)(101416001)(107046002)(229853001)(44976005)(2201001)(77156001)(68736004)(53416004)(83322001)(50986999)(99396003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB194;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB194;
X-Forefront-PRVS: 03484C0ABF
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This patch adds ARM64 support to the generic PCI host driver.

For MSI support, it adds new device tree binding "msi-parent",
which should point to corresponded msi-controller.

Cc: Will Deacon <will.deacon@arm.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
---
 .../devicetree/bindings/pci/host-generic-pci.txt   |  3 +
 drivers/pci/host/Kconfig                           |  2 +-
 drivers/pci/host/pci-host-generic.c                | 95 ++++++++++++++++++++--
 3 files changed, 90 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/pci/host-generic-pci.txt b/Documentation/devicetree/bindings/pci/host-generic-pci.txt
index f0b0436..327e5b1 100644
--- a/Documentation/devicetree/bindings/pci/host-generic-pci.txt
+++ b/Documentation/devicetree/bindings/pci/host-generic-pci.txt
@@ -69,6 +69,9 @@ Practice: Interrupt Mapping' and requires the following properties:
 
 - interrupt-map-mask : <see aforementioned specification>
 
+Optinal Properties:
+
+- msi-parent     : Specify the msi-controller phandle.
 
 Example:
 
diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
index 90f5cca..44bf523 100644
--- a/drivers/pci/host/Kconfig
+++ b/drivers/pci/host/Kconfig
@@ -50,7 +50,7 @@ config PCI_RCAR_GEN2_PCIE
 
 config PCI_HOST_GENERIC
 	bool "Generic PCI host controller"
-	depends on ARM && OF
+	depends on (ARM || ARM64) && OF
 	help
 	  Say Y here if you want to support a simple generic PCI host
 	  controller, such as the one emulated by kvmtool.
diff --git a/drivers/pci/host/pci-host-generic.c b/drivers/pci/host/pci-host-generic.c
index 3d2076f..f33c547 100644
--- a/drivers/pci/host/pci-host-generic.c
+++ b/drivers/pci/host/pci-host-generic.c
@@ -42,14 +42,24 @@ struct gen_pci {
 	struct pci_host_bridge			host;
 	struct gen_pci_cfg_windows		cfg;
 	struct list_head			resources;
+	struct device_node *msi_parent;
 };
 
+#ifdef CONFIG_ARM64
+#define bus_to_gen_pci(b) \
+	((struct gen_pci *)b->sysdata)
+#else
+#define bus_to_gen_pci(b) \
+	((struct gen_pci *) \
+	(((struct pci_sys_data *) \
+	(bus->sysdata))->private_data))
+#endif
+
 static void __iomem *gen_pci_map_cfg_bus_cam(struct pci_bus *bus,
 					     unsigned int devfn,
 					     int where)
 {
-	struct pci_sys_data *sys = bus->sysdata;
-	struct gen_pci *pci = sys->private_data;
+	struct gen_pci *pci = bus_to_gen_pci(bus);
 	resource_size_t idx = bus->number - pci->cfg.bus_range.start;
 
 	return pci->cfg.win[idx] + ((devfn << 8) | where);
@@ -64,8 +74,7 @@ static void __iomem *gen_pci_map_cfg_bus_ecam(struct pci_bus *bus,
 					      unsigned int devfn,
 					      int where)
 {
-	struct pci_sys_data *sys = bus->sysdata;
-	struct gen_pci *pci = sys->private_data;
+	struct gen_pci *pci = bus_to_gen_pci(bus);
 	resource_size_t idx = bus->number - pci->cfg.bus_range.start;
 
 	return pci->cfg.win[idx] + ((devfn << 12) | where);
@@ -80,8 +89,7 @@ static int gen_pci_config_read(struct pci_bus *bus, unsigned int devfn,
 				int where, int size, u32 *val)
 {
 	void __iomem *addr;
-	struct pci_sys_data *sys = bus->sysdata;
-	struct gen_pci *pci = sys->private_data;
+	struct gen_pci *pci = bus_to_gen_pci(bus);
 
 	addr = pci->cfg.ops->map_bus(bus, devfn, where);
 
@@ -103,8 +111,7 @@ static int gen_pci_config_write(struct pci_bus *bus, unsigned int devfn,
 				 int where, int size, u32 val)
 {
 	void __iomem *addr;
-	struct pci_sys_data *sys = bus->sysdata;
-	struct gen_pci *pci = sys->private_data;
+	struct gen_pci *pci = bus_to_gen_pci(bus);
 
 	addr = pci->cfg.ops->map_bus(bus, devfn, where);
 
@@ -144,8 +151,11 @@ static int gen_pci_calc_io_offset(struct device *dev,
 				  resource_size_t *offset)
 {
 	static atomic_t wins = ATOMIC_INIT(0);
-	int err, idx, max_win;
+	int idx, max_win;
 	unsigned int window;
+#ifndef CONFIG_ARM64
+	int err;
+#endif
 
 	if (!PAGE_ALIGNED(range->cpu_addr))
 		return -EINVAL;
@@ -156,9 +166,12 @@ static int gen_pci_calc_io_offset(struct device *dev,
 		return -ENOSPC;
 
 	window = (idx - 1) * SZ_64K;
+
+#ifndef CONFIG_ARM64
 	err = pci_ioremap_io(window, range->cpu_addr);
 	if (err)
 		return err;
+#endif
 
 	of_pci_range_to_resource(range, dev->of_node, res);
 	res->start = window;
@@ -310,12 +323,58 @@ static int gen_pci_parse_map_cfg_windows(struct gen_pci *pci)
 	return 0;
 }
 
+#ifndef CONFIG_ARM64
 static int gen_pci_setup(int nr, struct pci_sys_data *sys)
 {
 	struct gen_pci *pci = sys->private_data;
 	list_splice_init(&pci->resources, &sys->resources);
 	return 1;
 }
+#endif
+
+#ifdef CONFIG_ARM64
+struct pci_bus *gen_scan_root_bus(struct device *parent, int bus,
+				       struct pci_ops *ops, void *sysdata,
+				       struct list_head *resources)
+{
+	struct pci_host_bridge_window *window;
+	bool found = false;
+	struct pci_bus *b;
+	int max;
+	struct gen_pci *pci = sysdata;
+
+	list_for_each_entry(window, resources, list)
+		if (window->res->flags & IORESOURCE_BUS) {
+			found = true;
+			break;
+		}
+
+	b = pci_create_root_bus(parent, bus, ops, sysdata, resources);
+	if (!b)
+		return NULL;
+
+	/* TODO:
+	 * This is probably should be done in the core pci driver somewhere
+	 */
+	if (pci->msi_parent)
+		b->msi = of_pci_find_msi_chip_by_node(pci->msi_parent);
+
+	if (!found) {
+		dev_info(&b->dev,
+		 "No busn resource found for root bus, will use [bus %02x-ff]\n",
+			bus);
+		pci_bus_insert_busn_res(b, bus, 255);
+	}
+
+	max = pci_scan_child_bus(b);
+
+	if (!found)
+		pci_bus_update_busn_res_end(b, max);
+
+	pci_bus_add_devices(b);
+	return b;
+}
+#endif
 
 static int gen_pci_probe(struct platform_device *pdev)
 {
@@ -326,6 +385,7 @@ static int gen_pci_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct device_node *np = dev->of_node;
 	struct gen_pci *pci = devm_kzalloc(dev, sizeof(*pci), GFP_KERNEL);
+#ifndef CONFIG_ARM64
 	struct hw_pci hw = {
 		.nr_controllers	= 1,
 		.private_data	= (void **)&pci,
@@ -333,6 +393,7 @@ static int gen_pci_probe(struct platform_device *pdev)
 		.map_irq	= of_irq_parse_and_map_pci,
 		.ops		= &gen_pci_ops,
 	};
+#endif
 
 	if (!pci)
 		return -ENOMEM;
@@ -368,8 +429,24 @@ static int gen_pci_probe(struct platform_device *pdev)
 		gen_pci_release_of_pci_ranges(pci);
 		return err;
 	}
+#ifdef CONFIG_ARM64
 
+#ifdef CONFIG_PCI_MSI
+	pci->msi_parent = of_parse_phandle(np, "msi-parent", 0);
+	if (!pci->msi_parent) {
+		dev_err(&pdev->dev, "Failed to allocate msi-parent.\n");
+		return -EINVAL;
+	}
+#endif
+
+	if (!gen_scan_root_bus(&pdev->dev, pci->cfg.bus_range.start,
+			       &gen_pci_ops, pci, &pci->resources)) {
+		dev_err(&pdev->dev, "failed to enable PCIe ports\n");
+		return -ENODEV;
+	}
+#else
 	pci_common_init_dev(dev, &hw);
+#endif /* CONFIG_ARM64 */
 	return 0;
 }
 
-- 
1.9.3

