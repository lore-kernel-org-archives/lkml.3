Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaKKTSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 14:18:06 -0500
Received: from mail-bn1bn0106.outbound.protection.outlook.com ([157.56.110.106]:1356
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751880AbaKKTSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 14:18:00 -0500
X-WSS-ID: 0NEW2XS-08-FA9-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <bhelgaas@google.com>
CC: <liviu.dudau@arm.com>, <lorenzo.pieralisi@arm.com>, <will.deacon@arm.com>,
        <linux-pci@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH V2 2/2] PCI: generic: Add msi_parent DT binding
Date: Tue, 11 Nov 2014 13:17:34 -0600
Message-ID: <1415733454-24322-3-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415733454-24322-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1415733454-24322-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(64706001)(86362001)(53416004)(47776003)(20776003)(110136001)(229853001)(21056001)(84676001)(68736004)(97736003)(44976005)(99396003)(19580395003)(19580405001)(33646002)(120916001)(107046002)(2351001)(105586002)(89996001)(102836001)(50466002)(77156002)(62966003)(77096003)(87936001)(50226001)(4396001)(106466001)(87286001)(88136002)(36756003)(86152002)(46102003)(104166001)(95666004)(93916002)(31966008)(76176999)(48376002)(92566001)(101416001)(50986999)(92726001)(41533002);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB206;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB206;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB206;
X-Forefront-PRVS: 0392679D18
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB206;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This patch introduces a new DT binding, msi-parent, which can
be used to specify MSI-parent phandle for a particular PCI
generic host controller.

Also, it implements and registers set_msi_parent callback.

Cc: Bjorn Helgass <bhelgaas@google.com>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
---
 Documentation/devicetree/bindings/pci/host-generic-pci.txt |  3 +++
 drivers/pci/host/pci-host-generic.c                        | 13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/Documentation/devicetree/bindings/pci/host-generic-pci.txt b/Documentation/devicetree/bindings/pci/host-generic-pci.txt
index cf3e205..6996af7 100644
--- a/Documentation/devicetree/bindings/pci/host-generic-pci.txt
+++ b/Documentation/devicetree/bindings/pci/host-generic-pci.txt
@@ -36,6 +36,8 @@ Properties of the host controller node:
 - reg            : The Configuration Space base address and size, as accessed
                    from the parent bus.
 
+- msi-parent     : Specify the phandle of the corresponded MSI controller
+                   for this PCI host controller.
 
 Properties of the /chosen node:
 
@@ -77,6 +79,7 @@ pci {
     device_type = "pci";
     #address-cells = <3>;
     #size-cells = <2>;
+    msi-parent = <&msictrl0>;
     bus-range = <0x0 0x1>;
 
     // CPU_PHYSICAL(2)  SIZE(2)
diff --git a/drivers/pci/host/pci-host-generic.c b/drivers/pci/host/pci-host-generic.c
index 1895907..c4fbcda 100644
--- a/drivers/pci/host/pci-host-generic.c
+++ b/drivers/pci/host/pci-host-generic.c
@@ -42,6 +42,7 @@ struct gen_pci {
 	struct pci_host_bridge			host;
 	struct gen_pci_cfg_windows		cfg;
 	struct list_head			resources;
+	struct msi_chip				*mchip;
 };
 
 static void __iomem *gen_pci_map_cfg_bus_cam(struct pci_bus *bus,
@@ -122,9 +123,19 @@ static int gen_pci_config_write(struct pci_bus *bus, unsigned int devfn,
 	return PCIBIOS_SUCCESSFUL;
 }
 
+static int gen_pci_set_msi_parent(struct pci_bus *bus)
+{
+	struct gen_pci *pci = bus_to_gen_pci(bus);
+
+	bus->msi = pci->mchip;
+
+	return PCIBIOS_SUCCESSFUL;
+}
+
 static struct pci_ops gen_pci_ops = {
 	.read	= gen_pci_config_read,
 	.write	= gen_pci_config_write,
+	.set_msi_parent = gen_pci_set_msi_parent,
 };
 
 static const struct of_device_id gen_pci_of_match[] = {
@@ -303,6 +314,8 @@ static int gen_pci_probe(struct platform_device *pdev)
 		return err;
 	}
 
+	pci->mchip = of_pci_find_msi_chip_by_node(of_parse_phandle(np,
+						  "msi-parent", 0));
 	pci_common_init_dev(dev, &hw);
 	return 0;
 }
-- 
1.9.3

