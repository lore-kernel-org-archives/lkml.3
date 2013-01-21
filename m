Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab3AUUVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:21:42 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:22770
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752816Ab3AUUVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:21:24 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1155h)
X-WSS-ID: 0MGZSJH-01-3FS-02
X-M-MSG: 
From: "Steven L. Kinney" <steven.kinney@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Myron Stowe <myron.stowe@redhat.com>, Hiroshi DOYU <hdoyu@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Jiri Kosina <jkosina@suse.cz>,
        Kukjin Kim <kgene.kim@samsung.com>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Steven L. Kinney" <steven.kinney@amd.com>
Subject: [PATCH 1/3] AMD x86 quirks: Quirk for enabling IOMMUv2 PC feature
Date: Mon, 21 Jan 2013 14:20:56 -0600
Message-ID: <1358799658-6236-2-git-send-email-steven.kinney@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358799658-6236-1-git-send-email-steven.kinney@amd.com>
References: <1358799658-6236-1-git-send-email-steven.kinney@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven L. Kinney" <steven.kinney@amd.com>

Original code base by Andreas Herrmann at AMD with minor changes.

Signed-off-by: Steven L. Kinney <steven.kinney@amd.com>
---
 arch/x86/kernel/quirks.c |   17 +++++++++++++++++
 include/linux/pci_ids.h  |    2 ++
 2 files changed, 19 insertions(+)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 26ee48a..ab27b88 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -567,3 +567,20 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F5,
 			quirk_amd_nb_node);
 
 #endif
+
+#if defined(CONFIG_PCI) && defined(CONFIG_AMD_IOMMU_V2_PC)
+
+static void amd_force_iommu_v2_pc(struct pci_dev *dev)
+{
+	u32 val;
+
+	pci_read_config_dword(dev, 0x70, &val);
+	val |= (1<<9);
+	pci_write_config_dword(dev, 0x70, val);
+	dev_printk(KERN_DEBUG, &dev->dev, "Enabled IOMMUv2 PC\n");
+}
+
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M10H_IOMMU,
+			amd_force_iommu_v2_pc);
+
+#endif
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 0eb6579..c6ce47b 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -396,6 +396,8 @@
 /* AMD RD890 Chipset */
 #define PCI_DEVICE_ID_RD890_IOMMU	0x5a23
 
+#define PCI_DEVICE_ID_AMD_15H_M10H_IOMMU       0x1419
+
 #define PCI_VENDOR_ID_ADL		0x1005
 #define PCI_DEVICE_ID_ADL_2301		0x2301
 
-- 
1.7.9.5


