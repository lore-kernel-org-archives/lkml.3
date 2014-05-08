Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbaEHQoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:44:39 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:22825
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753156AbaEHQoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:44:37 -0400
X-WSS-ID: 0N59L67-08-6SQ-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        Borislav Petkov <bp@suse.de>, "Robert Richter" <rric@kernel.org>,
        Daniel J Blueman <daniel@numascale.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH V4 1/4] x86/PCI: Fix PCI root numa_node info on AMD family15h
Date: Thu, 8 May 2014 11:44:18 -0500
Message-ID: <1399567461-15928-2-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399567461-15928-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1399567461-15928-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(33646001)(84676001)(2009001)(99396002)(80022001)(4396001)(50466002)(50226001)(68736004)(48376002)(97736001)(50986999)(64706001)(19580395003)(87286001)(62966002)(20776003)(19580405001)(76176999)(87936001)(83322001)(89996001)(83072002)(85852003)(53416003)(93916002)(46102001)(86362001)(92566001)(86152002)(47776003)(21056001)(77982001)(101416001)(74662001)(77156001)(36756003)(81542001)(31966008)(76482001)(88136002)(44976005)(92726001)(79102001)(81342001)(74502001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR02MB124;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0205EDCD76
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This patch fixes the numa_node information in sysfs for PCI root
on AMD family15h platforms (currently showing -1) by adding
the hostbridge in the list of probed devices to be used for initializing
pci_root_info structue.

Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
Tested-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Robert Richter <rric@kernel.org>
Cc: Daniel J Blueman <daniel@numascale.com>
Cc: Andreas Herrmann <herrmann.der.user@googlemail.com>
---
 arch/x86/pci/amd_bus.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index e88f4c5..330dbfe 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -24,10 +24,11 @@ struct pci_hostbridge_probe {
 };
 
 static struct pci_hostbridge_probe pci_probes[] __initdata = {
-	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1100 },
-	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1200 },
-	{ 0xff, 0, PCI_VENDOR_ID_AMD, 0x1200 },
-	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1300 },
+	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1100 }, /* K8 */
+	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1200 }, /* Fam10h */
+	{ 0xff, 0, PCI_VENDOR_ID_AMD, 0x1200 }, /* Fam10h */
+	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1300 }, /* Fam11h */
+	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1600 }, /* Fam15h */
 };
 
 #define RANGE_NUM 16
@@ -113,6 +114,13 @@ static int __init early_fill_mp_bus_info(void)
 		info = alloc_pci_root_info(min_bus, max_bus, node, link);
 	}
 
+	/*
+	 * The following code is only supported until Fam11h.
+	 * Newer processors will depend on ACPI MCFG table instead.
+	 */
+	if (boot_cpu_data.x86 > 0x11)
+		return 0;
+
 	/* get the default node and link for left over res */
 	reg = read_pci_config(bus, slot, 0, 0x60);
 	def_node = (reg >> 8) & 0x07;
-- 
1.9.0

