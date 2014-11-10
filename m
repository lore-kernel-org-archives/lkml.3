Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaKJTZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:25:07 -0500
Received: from mail-bn1on0138.outbound.protection.outlook.com ([157.56.110.138]:1591
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751444AbaKJTZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:25:02 -0500
X-WSS-ID: 0NEU8LG-08-XPX-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <bhelgaas@google.com>
CC: <liviu.dudau@arm.com>, <lorenzo.pieralisi@arm.com>, <will.deacon@arm.com>,
        <linux-pci@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 1/2] PCI: Add new pci_ops for setting MSI parent for PCI bus
Date: Mon, 10 Nov 2014 13:24:39 -0600
Message-ID: <1415647480-3320-2-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415647480-3320-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1415647480-3320-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(4396001)(50226001)(95666004)(36756003)(120916001)(77096003)(33646002)(62966003)(46102003)(77156002)(105586002)(20776003)(47776003)(64706001)(97736003)(21056001)(110136001)(99396003)(106466001)(229853001)(92726001)(104166001)(2351001)(53416004)(107046002)(84676001)(92566001)(86152002)(68736004)(86362001)(89996001)(93916002)(19580395003)(19580405001)(87936001)(44976005)(88136002)(87286001)(101416001)(48376002)(31966008)(102836001)(50466002)(76176999)(50986999);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB203;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB203;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB203;
X-Forefront-PRVS: 039178EF4A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB203;
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

