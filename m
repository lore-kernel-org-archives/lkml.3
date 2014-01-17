Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaAQSWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 13:22:53 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:54010
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752066AbaAQSWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 13:22:49 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzdchz1de098h8275bh1de097hz2dh839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h2487h1155h)
X-WSS-ID: 0MZK5NP-08-AP8-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <x86@kernel.org>, <bp@suse.de>, <linux-kernel@vger.kernel.org>,
        <sherry.hurwitz@amd.com>
CC: <hmh@hmh.eng.br>, <Kim.Naru@amd.com>, <Suravee.Suthikulpanit@amd.com>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH] x86, quirks: Add workaround for AMD F16h Erratum792
Date: Fri, 17 Jan 2014 12:39:33 -0600
Message-ID: <1389983973-3965-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
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
chip). The erratum affects both client and server platforms and since
we cannot say with certainity that ALL BIOSes on systems out in the
field will have the fix, we should probably insulate ourselves in case
BIOS does not do the right thing or someone is using old BIOSes.

Refer Revision Guide for AMD F16h models 00h-0fh, document 51810
Rev. 3.04, November2013 for details on the Erratum.

Tested the patch on Fam16h server platform and works fine.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 arch/x86/kernel/quirks.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 04ee1e2..e55ae02 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -571,3 +571,34 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F5,
 			quirk_amd_nb_node);
 
 #endif
+
+#if defined(CONFIG_PCI)
+/*
+ * Apply AMD Fam16h Erratum792
+ * see Revision Guide for AMD F16h models 00h-0fh,
+ * document 51810 rev. 3.04, Nov 2013
+ */
+static void quirk_amd_dram_scrub(struct pci_dev *dev)
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
+			quirk_amd_dram_scrub);
+
+#endif
-- 
1.7.9.5


