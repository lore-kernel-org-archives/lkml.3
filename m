Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaAYOYZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 09:24:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52425 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbaAYOXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 09:23:54 -0500
Date: Sat, 25 Jan 2014 06:23:29 -0800
From: tip-bot for Aravind Gopalakrishnan <tipbot@zytor.com>
Message-ID: <tip-fb53a1ab88d14848dc292842e35c3bda3a665997@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        Aravind.Gopalakrishnan@amd.com, sherry.hurwitz@amd.com,
        Kim.Naru@amd.com, hmh@hmh.eng.br, Suravee.Suthikulpanit@amd.com,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        Aravind.Gopalakrishnan@amd.com, Kim.Naru@amd.com,
        sherry.hurwitz@amd.com, hmh@hmh.eng.br, Suravee.Suthikulpanit@amd.com,
        tglx@linutronix.de, bp@suse.de
In-Reply-To: <1390515212-1824-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
References: <1390515212-1824-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/quirks:
  Add workaround for AMD F16h Erratum792
Git-Commit-ID: fb53a1ab88d14848dc292842e35c3bda3a665997
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 25 Jan 2014 06:23:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb53a1ab88d14848dc292842e35c3bda3a665997
Gitweb:     http://git.kernel.org/tip/fb53a1ab88d14848dc292842e35c3bda3a665997
Author:     Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
AuthorDate: Thu, 23 Jan 2014 16:13:32 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 25 Jan 2014 08:44:19 +0100

x86/quirks: Add workaround for AMD F16h Erratum792

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
---
 arch/x86/kernel/quirks.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 04ee1e2..7c6acd4 100644
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
