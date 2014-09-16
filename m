Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbaIPA6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 20:58:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38461 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbaIPA6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 20:58:47 -0400
Date: Mon, 15 Sep 2014 17:58:09 -0700
From: tip-bot for Peter Neubauer <tipbot@zytor.com>
Message-ID: <tip-2e151c70dfb0075ff83bec305c52a9da1ba49089@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        eric.sesterhenn@lsexperts.de, tglx@linutronix.de,
        ck@conrad-kostecki.de, pneubauer@bluerwhite.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.sesterhenn@lsexperts.de, tglx@linutronix.de,
        pneubauer@bluerwhite.org, ck@conrad-kostecki.de
In-Reply-To: <5412D3A5.2030909@lsexperts.de>
References: <5412D3A5.2030909@lsexperts.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: HPET force enable for e6xx based systems
Git-Commit-ID: 2e151c70dfb0075ff83bec305c52a9da1ba49089
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e151c70dfb0075ff83bec305c52a9da1ba49089
Gitweb:     http://git.kernel.org/tip/2e151c70dfb0075ff83bec305c52a9da1ba49089
Author:     Peter Neubauer <pneubauer@bluerwhite.org>
AuthorDate: Fri, 12 Sep 2014 13:06:13 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 15 Sep 2014 17:53:35 -0700

x86: HPET force enable for e6xx based systems

As the Soekris net6501 and other e6xx based systems do not have
any ACPI implementation, HPET won't get enabled.
This patch enables HPET on such platforms.

[    0.430149] pci 0000:00:01.0: Force enabled HPET at 0xfed00000
[    0.644838] HPET: 3 timers in total, 0 timers will be used for per-cpu timer

Original patch by Peter Neubauer (http://www.mail-archive.com/soekris-tech@lists.soekris.com/msg06462.html)
slightly modified by Conrad Kostecki <ck@conrad-kostecki.de> and massaged
accoring to Thomas Gleixners <tglx@linutronix.de> by me.

Suggested-by: Conrad Kostecki <ck@conrad-kostecki.de>
Signed-off-by: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
Cc: Peter Neubauer <pneubauer@bluerwhite.org>
Link: http://lkml.kernel.org/r/5412D3A5.2030909@lsexperts.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/kernel/quirks.c | 18 ++++++++++++++++++
 include/linux/pci_ids.h  |  1 +
 2 files changed, 19 insertions(+)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index ff898bb..176a0f9 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -498,6 +498,24 @@ void force_hpet_resume(void)
 }
 
 /*
+ * According to the datasheet e6xx systems have the HPET hardwired to
+ * 0xfed00000
+ */
+static void e6xx_force_enable_hpet(struct pci_dev *dev)
+{
+	if (hpet_address || force_hpet_address)
+		return;
+
+	force_hpet_address = 0xFED00000;
+	force_hpet_resume_type = NONE_FORCE_HPET_RESUME;
+	dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at "
+		"0x%lx\n", force_hpet_address);
+	return;
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_E6XX_CU,
+			 e6xx_force_enable_hpet);
+
+/*
  * HPET MSI on some boards (ATI SB700/SB800) has side effect on
  * floppy DMA. Disable HPET MSI on such platforms.
  * See erratum #27 (Misinterpreted MSI Requests May Result in
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 6ed0bb7..aa0d390 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2860,6 +2860,7 @@
 #define PCI_DEVICE_ID_INTEL_82372FB_1	0x7601
 #define PCI_DEVICE_ID_INTEL_SCH_LPC	0x8119
 #define PCI_DEVICE_ID_INTEL_SCH_IDE	0x811a
+#define PCI_DEVICE_ID_INTEL_E6XX_CU	0x8183
 #define PCI_DEVICE_ID_INTEL_ITC_LPC	0x8186
 #define PCI_DEVICE_ID_INTEL_82454GX	0x84c4
 #define PCI_DEVICE_ID_INTEL_82450GX	0x84c5
