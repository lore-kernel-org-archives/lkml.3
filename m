Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbaAWV5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 16:57:41 -0500
Received: from [216.32.180.12] ([216.32.180.12]:35784 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753684AbaAWV5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 16:57:38 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh1de097hz2dh839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h1155h)
X-WSS-ID: 0MZVJKW-08-5IU-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <x86@kernel.org>, <bp@suse.de>, <linux-kernel@vger.kernel.org>,
        <sherry.hurwitz@amd.com>
CC: <hmh@hmh.eng.br>, <Kim.Naru@amd.com>, <Suravee.Suthikulpanit@amd.com>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH V2] x86, quirks: Add workaround for AMD F16h Erratum792
Date: Thu, 23 Jan 2014 16:13:32 -0600
Message-ID: <1390515212-1824-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The workaround for this Erratum is included in AGESA. But BIOSes spun
only after Jan2014 will have the fix (atleast server versions of the
chip). The erratum affects both embedded and server platforms and since
we cannot say with certainity that ALL BIOSes on systems out in the
field will have the fix, we should probably insulate ourselves in case
BIOS does not do the right thing or someone is using old BIOSes.

Refer Revision Guide for AMD F16h models 00h-0fh, document 51810
Rev. 3.04, November2013 for details on the Erratum.

Tested the patch on Fam16h server platform and works fine.

Changes from V1:
	- modify commit msg to say it affects embedded and server
	  systems..
	- per Ingo's suggestion: reword comment, function name
	- rebase off latest tip/master

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 arch/x86/kernel/quirks.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 04ee1e2..50ce52f 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -571,3 +571,39 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F5,
 			quirk_amd_nb_node);
 
 #endif
+
+#if defined(CONFIG_PCI)
+/*
+ * Processor does not ensure DRAM scrub read/write sequence
+ * is atomic wrt accesses to CC6 save state area. Therefore
+ * if a concurrent scrub read/write access is to same address
+ * the entry may appear as if it is not written. This quirk
+ * applies to Fam16h models 00h-0Fh
+ *
+ * see Revision Guide for AMD F16h models 00h-0fh,
+ * document 51810 rev. 3.04, Nov 2013
+ */
+static void amd_disable_seq_and_redirect_scrub(struct pci_dev *dev)
+{
+	u32 val;
+
+	/* Suggested workaround:
+	 * set D18F3x58[4:0] = 00h and set D18F3x5C[0] = 0b
+	 */
+	pci_read_config_dword(dev, 0x58, &val);
+	if (val & 0x1F) {
+		val &= ~(0x1F);
+		pci_write_config_dword(dev, 0x58, val);
+	}
+
+	pci_read_config_dword(dev, 0x5C, &val);
+	if (val & BIT(0)) {
+		val &= ~BIT(0);
+		pci_write_config_dword(dev, 0x5c, val);
+	}
+}
+
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F3,
+			amd_disable_seq_and_redirect_scrub);
+
+#endif
-- 
1.7.9.5


