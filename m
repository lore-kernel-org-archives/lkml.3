Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbaEHQpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:45:30 -0400
Received: from mail-bl2lp0206.outbound.protection.outlook.com ([207.46.163.206]:10625
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755165AbaEHQpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:45:02 -0400
X-WSS-ID: 0N59L6G-07-DX9-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        Borislav Petkov <bp@suse.de>, "Robert Richter" <rric@kernel.org>,
        Daniel J Blueman <daniel@numascale.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH V4 4/4] X86/PCI: Remove unnecessary 'quirk_amd_nb_node'
Date: Thu, 8 May 2014 11:44:21 -0500
Message-ID: <1399567461-15928-5-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399567461-15928-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1399567461-15928-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(33646001)(84676001)(2009001)(99396002)(80022001)(4396001)(50466002)(50226001)(68736004)(48376002)(97736001)(50986999)(64706001)(19580395003)(87286001)(62966002)(20776003)(19580405001)(76176999)(87936001)(83322001)(89996001)(83072002)(85852003)(53416003)(93916002)(46102001)(86362001)(92566001)(86152002)(47776003)(21056001)(77982001)(101416001)(74662001)(77156001)(36756003)(81542001)(31966008)(76482001)(88136002)(44976005)(92726001)(79102001)(81342001)(74502001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR02MB124;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0205EDCD76
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Myron Stowe <myron.stowe@redhat.com>

The quirk is used for fixing up the numa_node information in sysfs for AMD hostbridge
devices (i.e. PCI device 00:[18-1f].x).  However, this is currently unused.
and is becoming maintenance burden. Therefore, it is removed.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Robert Richter <rric@kernel.org>
Cc: Daniel J Blueman <daniel@numascale.com>
Cc: Andreas Herrmann <herrmann.der.user@googlemail.com>
Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
---
 arch/x86/kernel/quirks.c | 58 ------------------------------------------------
 1 file changed, 58 deletions(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index ff898bb..abbd6bc 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -514,64 +514,6 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
 
 #endif
 
-#if defined(CONFIG_PCI) && defined(CONFIG_NUMA)
-/* Set correct numa_node information for AMD NB functions */
-static void quirk_amd_nb_node(struct pci_dev *dev)
-{
-	struct pci_dev *nb_ht;
-	unsigned int devfn;
-	u32 node;
-	u32 val;
-
-	devfn = PCI_DEVFN(PCI_SLOT(dev->devfn), 0);
-	nb_ht = pci_get_slot(dev->bus, devfn);
-	if (!nb_ht)
-		return;
-
-	pci_read_config_dword(nb_ht, 0x60, &val);
-	node = pcibus_to_node(dev->bus) | (val & 7);
-	/*
-	 * Some hardware may return an invalid node ID,
-	 * so check it first:
-	 */
-	if (node_online(node))
-		set_dev_node(&dev->dev, node);
-	pci_dev_put(nb_ht);
-}
-
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB,
-			quirk_amd_nb_node);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_ADDRMAP,
-			quirk_amd_nb_node);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MEMCTL,
-			quirk_amd_nb_node);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC,
-			quirk_amd_nb_node);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_HT,
-			quirk_amd_nb_node);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MAP,
-			quirk_amd_nb_node);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_DRAM,
-			quirk_amd_nb_node);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC,
-			quirk_amd_nb_node);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_LINK,
-			quirk_amd_nb_node);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F0,
-			quirk_amd_nb_node);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F1,
-			quirk_amd_nb_node);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F2,
-			quirk_amd_nb_node);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F3,
-			quirk_amd_nb_node);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F4,
-			quirk_amd_nb_node);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F5,
-			quirk_amd_nb_node);
-
-#endif
-
 #ifdef CONFIG_PCI
 /*
  * Processor does not ensure DRAM scrub read/write sequence
-- 
1.9.0

