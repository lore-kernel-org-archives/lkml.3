Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbaBEUJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:09:53 -0500
Received: from mail.windriver.com ([147.11.1.11]:55770 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbaBEUIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:08:53 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 211/213] PCI: Add quirk for still enabled interrupts on Intel Sandy Bridge GPUs
Date: Wed, 5 Feb 2014 15:02:46 -0500
Message-ID: <1391630568-49251-212-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Jarosch <thomas.jarosch@intra2net.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit cdb1f35dc7de42802527140a3613871c394548e1 upstream.

commit f67fd55fa96f7d7295b43ffbc4a97d8f55e473aa upstream.

Some BIOS implementations leave the Intel GPU interrupts enabled,
even though no one is handling them (f.e. i915 driver is never loaded).
Additionally the interrupt destination is not set up properly
and the interrupt ends up -somewhere-.

These spurious interrupts are "sticky" and the kernel disables
the (shared) interrupt line after 100.000+ generated interrupts.

Fix it by disabling the still enabled interrupts.
This resolves crashes often seen on monitor unplug.

Tested on the following boards:
- Intel DH61CR: Affected
- Intel DH67BL: Affected
- Intel S1200KP server board: Affected
- Asus P8H61-M LE: Affected, but system does not crash.
  Probably the IRQ ends up somewhere unnoticed.

According to reports on the net, the Intel DH61WW board is also affected.

Many thanks to Jesse Barnes from Intel for helping
with the register configuration and to Intel in general
for providing public hardware documentation.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Tested-by: Charlie Suffin <charlie.suffin@stratus.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/pci/quirks.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 6938fdc41e79..052af89854c1 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2692,6 +2692,40 @@ static void __devinit fixup_ti816x_class(struct pci_dev* dev)
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_TI, 0xb800, fixup_ti816x_class);
 
+/*
+ * Some BIOS implementations leave the Intel GPU interrupts enabled,
+ * even though no one is handling them (f.e. i915 driver is never loaded).
+ * Additionally the interrupt destination is not set up properly
+ * and the interrupt ends up -somewhere-.
+ *
+ * These spurious interrupts are "sticky" and the kernel disables
+ * the (shared) interrupt line after 100.000+ generated interrupts.
+ *
+ * Fix it by disabling the still enabled interrupts.
+ * This resolves crashes often seen on monitor unplug.
+ */
+#define I915_DEIER_REG 0x4400c
+static void __devinit disable_igfx_irq(struct pci_dev *dev)
+{
+	void __iomem *regs = pci_iomap(dev, 0, 0);
+	if (regs == NULL) {
+		dev_warn(&dev->dev, "igfx quirk: Can't iomap PCI device\n");
+		return;
+	}
+
+	/* Check if any interrupt line is still enabled */
+	if (readl(regs + I915_DEIER_REG) != 0) {
+		dev_warn(&dev->dev, "BIOS left Intel GPU interrupts enabled; "
+			"disabling\n");
+
+		writel(0, regs + I915_DEIER_REG);
+	}
+
+	pci_iounmap(dev, regs);
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0102, disable_igfx_irq);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x010a, disable_igfx_irq);
+
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)
 {
-- 
1.8.5.2

