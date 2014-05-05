Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645AbaEEMra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:47:30 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932324AbaEEMnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:35 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        <hmh@hmh.eng.br>, <Kim.Naru@amd.com>, <Suravee.Suthikulpanit@amd.com>,
        <bp@suse.de>, <sherry.hurwitz@amd.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 15/50] x86/quirks: Add workaround for AMD F16h Erratum792
Date: Mon,  5 May 2014 14:42:57 +0200
Message-Id: <8e0a45a8ca903015a88bf5008371cec9ee6ddebc.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit fb53a1ab88d14848dc292842e35c3bda3a665997 upstream.

The workaround for this Erratum is included in AGESA. But BIOSes
spun only after Jan2014 will have the fix (atleast server
versions of the chip). The erratum affects both embedded and
server platforms and since we cannot say with certainity that
ALL BIOSes on systems out in the field will have the fix, we
should probably insulate ourselves in case BIOS does not do the
right thing or someone is using old BIOSes.

Refer to Revision Guide for AMD F16h models 00h-0fh, document 51810
Rev. 3.04, November2013 for details on the Erratum.

Tested the patch on Fam16h server platform and it works fine.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: <hmh@hmh.eng.br>
Cc: <Kim.Naru@amd.com>
Cc: <Suravee.Suthikulpanit@amd.com>
Cc: <bp@suse.de>
Cc: <sherry.hurwitz@amd.com>
Link: http://lkml.kernel.org/r/1390515212-1824-1-git-send-email-Aravind.Gopalakrishnan@amd.com
[ Minor edits. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kernel/quirks.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 52dbf1e400dc..ff898bbf579d 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -571,3 +571,40 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F5,
 			quirk_amd_nb_node);
 
 #endif
+
+#ifdef CONFIG_PCI
+/*
+ * Processor does not ensure DRAM scrub read/write sequence
+ * is atomic wrt accesses to CC6 save state area. Therefore
+ * if a concurrent scrub read/write access is to same address
+ * the entry may appear as if it is not written. This quirk
+ * applies to Fam16h models 00h-0Fh
+ *
+ * See "Revision Guide" for AMD F16h models 00h-0fh,
+ * document 51810 rev. 3.04, Nov 2013
+ */
+static void amd_disable_seq_and_redirect_scrub(struct pci_dev *dev)
+{
+	u32 val;
+
+	/*
+	 * Suggested workaround:
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
1.9.2

