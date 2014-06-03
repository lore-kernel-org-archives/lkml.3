Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934301AbaFCUFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:05:20 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:34066 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934177AbaFCUFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:05:03 -0400
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>,
        Greg KH <greg@kroah.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH v5 12/15] PCI: Add pci_fixup_suspend_late quirk pass
Date: Tue,  3 Jun 2014 22:04:09 +0200
Message-Id: <1401825852-4745-13-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1401825852-4745-1-git-send-email-andreas.noever@gmail.com>
References: <1401825852-4745-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pci_fixup_suspend_late as a new pci_fixup_pass. The pass is called
from suspend_noirq and poweroff_noirq. Using the same pass for suspend
and hibernate is consistent with resume_early which is called by
resume_noirq and restore_noirq.

The new quirk pass is required for Thunderbolt support on Apple
hardware.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/pci-driver.c          | 18 ++++++++++++++----
 drivers/pci/quirks.c              |  7 +++++++
 include/asm-generic/vmlinux.lds.h |  3 +++
 include/linux/pci.h               | 12 +++++++++++-
 4 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index d911e0c..55dc1b8 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -542,7 +542,7 @@ static int pci_legacy_suspend_late(struct device *dev, pm_message_t state)
 			WARN_ONCE(pci_dev->current_state != prev,
 				"PCI PM: Device state not saved by %pF\n",
 				drv->suspend_late);
-			return 0;
+			goto Fixup;
 		}
 	}
 
@@ -551,6 +551,9 @@ static int pci_legacy_suspend_late(struct device *dev, pm_message_t state)
 
 	pci_pm_set_unknown_state(pci_dev);
 
+Fixup:
+	pci_fixup_device(pci_fixup_suspend_late, pci_dev);
+
 	return 0;
 }
 
@@ -694,7 +697,7 @@ static int pci_pm_suspend_noirq(struct device *dev)
 
 	if (!pm) {
 		pci_save_state(pci_dev);
-		return 0;
+		goto Fixup;
 	}
 
 	if (pm->suspend_noirq) {
@@ -711,7 +714,7 @@ static int pci_pm_suspend_noirq(struct device *dev)
 			WARN_ONCE(pci_dev->current_state != prev,
 				"PCI PM: State of device not saved by %pF\n",
 				pm->suspend_noirq);
-			return 0;
+			goto Fixup;
 		}
 	}
 
@@ -735,6 +738,9 @@ static int pci_pm_suspend_noirq(struct device *dev)
 	if (pci_dev->class == PCI_CLASS_SERIAL_USB_EHCI)
 		pci_write_config_word(pci_dev, PCI_COMMAND, 0);
 
+Fixup:
+	pci_fixup_device(pci_fixup_suspend_late, pci_dev);
+
 	return 0;
 }
 
@@ -959,8 +965,10 @@ static int pci_pm_poweroff_noirq(struct device *dev)
 	if (pci_has_legacy_pm_support(to_pci_dev(dev)))
 		return pci_legacy_suspend_late(dev, PMSG_HIBERNATE);
 
-	if (!drv || !drv->pm)
+	if (!drv || !drv->pm) {
+		pci_fixup_device(pci_fixup_suspend_late, pci_dev);
 		return 0;
+	}
 
 	if (drv->pm->poweroff_noirq) {
 		int error;
@@ -981,6 +989,8 @@ static int pci_pm_poweroff_noirq(struct device *dev)
 	if (pci_dev->class == PCI_CLASS_SERIAL_USB_EHCI)
 		pci_write_config_word(pci_dev, PCI_COMMAND, 0);
 
+	pci_fixup_device(pci_fixup_suspend_late, pci_dev);
+
 	if (pcibios_pm_ops.poweroff_noirq)
 		return pcibios_pm_ops.poweroff_noirq(dev);
 
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e729206..af2eba1 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3024,6 +3024,8 @@ extern struct pci_fixup __start_pci_fixups_resume_early[];
 extern struct pci_fixup __end_pci_fixups_resume_early[];
 extern struct pci_fixup __start_pci_fixups_suspend[];
 extern struct pci_fixup __end_pci_fixups_suspend[];
+extern struct pci_fixup __start_pci_fixups_suspend_late[];
+extern struct pci_fixup __end_pci_fixups_suspend_late[];
 
 static bool pci_apply_fixup_final_quirks;
 
@@ -3069,6 +3071,11 @@ void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev)
 		end = __end_pci_fixups_suspend;
 		break;
 
+	case pci_fixup_suspend_late:
+		start = __start_pci_fixups_suspend_late;
+		end = __end_pci_fixups_suspend_late;
+		break;
+
 	default:
 		/* stupid compiler warning, you would think with an enum... */
 		return;
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 146e4ff..2dea636 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -288,6 +288,9 @@
 		VMLINUX_SYMBOL(__start_pci_fixups_suspend) = .;		\
 		*(.pci_fixup_suspend)					\
 		VMLINUX_SYMBOL(__end_pci_fixups_suspend) = .;		\
+		VMLINUX_SYMBOL(__start_pci_fixups_suspend_late) = .;	\
+		*(.pci_fixup_suspend_late)				\
+		VMLINUX_SYMBOL(__end_pci_fixups_suspend_late) = .;	\
 	}								\
 									\
 	/* Built-in firmware blobs */					\
diff --git a/include/linux/pci.h b/include/linux/pci.h
index aab57b4..4724806 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1458,8 +1458,9 @@ enum pci_fixup_pass {
 	pci_fixup_final,	/* Final phase of device fixups */
 	pci_fixup_enable,	/* pci_enable_device() time */
 	pci_fixup_resume,	/* pci_device_resume() */
-	pci_fixup_suspend,	/* pci_device_suspend */
+	pci_fixup_suspend,	/* pci_device_suspend() */
 	pci_fixup_resume_early, /* pci_device_resume_early() */
+	pci_fixup_suspend_late,	/* pci_device_suspend_late() */
 };
 
 /* Anonymous variables would be nice... */
@@ -1500,6 +1501,11 @@ enum pci_fixup_pass {
 	DECLARE_PCI_FIXUP_SECTION(.pci_fixup_suspend,			\
 		suspend##hook, vendor, device, class,	\
 		class_shift, hook)
+#define DECLARE_PCI_FIXUP_CLASS_SUSPEND_LATE(vendor, device, class,	\
+					 class_shift, hook)		\
+	DECLARE_PCI_FIXUP_SECTION(.pci_fixup_suspend_late,		\
+		suspend_late##hook, vendor, device,	\
+		class, class_shift, hook)
 
 #define DECLARE_PCI_FIXUP_EARLY(vendor, device, hook)			\
 	DECLARE_PCI_FIXUP_SECTION(.pci_fixup_early,			\
@@ -1525,6 +1531,10 @@ enum pci_fixup_pass {
 	DECLARE_PCI_FIXUP_SECTION(.pci_fixup_suspend,			\
 		suspend##hook, vendor, device,		\
 		PCI_ANY_ID, 0, hook)
+#define DECLARE_PCI_FIXUP_SUSPEND_LATE(vendor, device, hook)		\
+	DECLARE_PCI_FIXUP_SECTION(.pci_fixup_suspend_late,		\
+		suspend_late##hook, vendor, device,	\
+		PCI_ANY_ID, 0, hook)
 
 #ifdef CONFIG_PCI_QUIRKS
 void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev);
-- 
2.0.0

