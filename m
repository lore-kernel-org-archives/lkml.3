Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbaKJTZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:25:36 -0500
Received: from mail-bn1bon0145.outbound.protection.outlook.com ([157.56.111.145]:43136
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752214AbaKJTZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:25:05 -0500
X-WSS-ID: 0NEU8LL-08-XQ9-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <bhelgaas@google.com>
CC: <liviu.dudau@arm.com>, <lorenzo.pieralisi@arm.com>, <will.deacon@arm.com>,
        <linux-pci@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 2/2] PCI: generic: Add set_msi_parent callback
Date: Mon, 10 Nov 2014 13:24:40 -0600
Message-ID: <1415647480-3320-3-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415647480-3320-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1415647480-3320-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(229853001)(50466002)(77096003)(62966003)(77156002)(76176999)(50986999)(120916001)(102836001)(48376002)(107046002)(2351001)(44976005)(50226001)(95666004)(19580405001)(4396001)(19580395003)(20776003)(64706001)(99396003)(92566001)(92726001)(47776003)(89996001)(110136001)(86152002)(36756003)(93916002)(33646002)(53416004)(87286001)(87936001)(88136002)(106466001)(68736004)(105586002)(21056001)(97736003)(84676001)(101416001)(104166001)(46102003)(86362001)(31966008)(41533002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB201;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Forefront-PRVS: 039178EF4A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This patch implement set_msi_parent callback for PCI generic host controller.

Cc: Bjorn Helgass <bhelgaas@google.com>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
---
 drivers/pci/host/pci-host-generic.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/pci/host/pci-host-generic.c b/drivers/pci/host/pci-host-generic.c
index 036ab1b..f9bb97a 100644
--- a/drivers/pci/host/pci-host-generic.c
+++ b/drivers/pci/host/pci-host-generic.c
@@ -42,6 +42,7 @@ struct gen_pci {
 	struct pci_host_bridge			host;
 	struct gen_pci_cfg_windows		cfg;
 	struct list_head			resources;
+	struct msi_chip				*mchip;
 };
 
 #ifdef CONFIG_ARM
@@ -128,9 +129,19 @@ static int gen_pci_config_write(struct pci_bus *bus, unsigned int devfn,
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
@@ -313,6 +324,9 @@ static int gen_pci_probe(struct platform_device *pdev)
 		return err;
 	}
 
+	pci->mchip = of_pci_find_msi_chip_by_node(of_parse_phandle(np,
+						  "msi-parent", 0));
+
 #ifdef CONFIG_ARM
 	pci_common_init_dev(dev, &hw);
 #else
-- 
1.9.3

