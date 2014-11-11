Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaKKTSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 14:18:32 -0500
Received: from mail-by2on0143.outbound.protection.outlook.com ([207.46.100.143]:10016
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751833AbaKKTRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 14:17:53 -0500
X-WSS-ID: 0NEW2XN-08-FA6-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <bhelgaas@google.com>
CC: <liviu.dudau@arm.com>, <lorenzo.pieralisi@arm.com>, <will.deacon@arm.com>,
        <linux-pci@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH V2 1/2] PCI: Add new pci_ops for setting MSI parent for PCI bus
Date: Tue, 11 Nov 2014 13:17:33 -0600
Message-ID: <1415733454-24322-2-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415733454-24322-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1415733454-24322-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(102836001)(101416001)(120916001)(31966008)(33646002)(53416004)(97736003)(87936001)(87286001)(88136002)(36756003)(89996001)(76176999)(99396003)(44976005)(19580395003)(19580405001)(229853001)(2351001)(106466001)(105586002)(62966003)(77156002)(77096003)(64706001)(84676001)(47776003)(50986999)(110136001)(68736004)(20776003)(107046002)(4396001)(50226001)(92566001)(95666004)(50466002)(86152002)(92726001)(86362001)(104166001)(46102003)(21056001)(48376002)(93916002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-Forefront-PRVS: 0392679D18
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

In the pci_scan_root_bus, pci_bus is created and passed down to:
    pci_scan_child_bus
        pci_scan_bridge
    	pci_add_new_bus
    	    pci_alloc_child_bus

In pci_alloc_child_bus, the parent's msi_chip is propagated to child,
and the referenced by PCI devices when calling arch_setup_msi_irq().

However, in the current implementation of pci_scan_root_bus, the msi_chip
of the root_bus is not set before handing off to pci_scan_child_bus.

This patch proposes a new callback function in the struct pci_ops
to allow host controller to provide a call back for specifying
msi_chip to be used.

Cc: Bjorn Helgass <bhelgaas@google.com>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
---
 drivers/pci/probe.c | 3 +++
 include/linux/pci.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 5ed9930..cf7114d 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2081,6 +2081,9 @@ struct pci_bus *pci_scan_root_bus(struct device *parent, int bus,
 	if (!b)
 		return NULL;
 
+	if (ops->set_msi_parent)
+		ops->set_msi_parent(b);
+
 	if (!found) {
 		dev_info(&b->dev,
 		 "No busn resource found for root bus, will use [bus %02x-ff]\n",
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5be8db4..6093544 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -560,6 +560,7 @@ static inline int pcibios_err_to_errno(int err)
 struct pci_ops {
 	int (*read)(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *val);
 	int (*write)(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 val);
+	int (*set_msi_parent)(struct pci_bus *bus);
 };
 
 /*
-- 
1.9.3

