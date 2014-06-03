Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934258AbaFCUFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:05:16 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:47889 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934205AbaFCUFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:05:05 -0400
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>,
        Greg KH <greg@kroah.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH v5 13/15] PCI: Suspend/resume quirks for Apple thunderbolt
Date: Tue,  3 Jun 2014 22:04:10 +0200
Message-Id: <1401825852-4745-14-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1401825852-4745-1-git-send-email-andreas.noever@gmail.com>
References: <1401825852-4745-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add two quirks to support thunderbolt suspend/resume on Apple systems.
We need to perform two different actions during suspend and resume:

The whole controller has to be powered down before suspend. If this is
not done then the native host interface device will be gone after resume
if a thunderbolt device was plugged in before suspending. The controller
represents itself as multiple PCI devices/bridges. To power it down we
hook into the upstream bridge of the controller and call the magic ACPI
methods.  Power will be restored automatically during resume (by the
firmware presumably).

During resume we have to wait for the native host interface to
reestablish all pci tunnels. Since there is no parent-child relationship
between the NHI and the bridges we have to explicitly wait for them
using device_pm_wait_for_dev. We do this in the resume_noirq phase of
the downstream bridges of the controller (which lead into the
thunderbolt tunnels).

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/pci/quirks.c | 97 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index af2eba1..7950fd1 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2992,6 +2992,103 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_CHELSIO, 0x0030,
 DECLARE_PCI_FIXUP_HEADER(0x1814, 0x0601, /* Ralink RT2800 802.11n PCI */
 			 quirk_broken_intx_masking);
 
+#ifdef CONFIG_ACPI
+/*
+ * Apple: Shutdown Cactus Ridge Thunderbolt controller.
+ *
+ * On Apple hardware the Cactus Ridge Thunderbolt controller needs to be
+ * shutdown before suspend. Otherwise the native host interface (NHI) will not
+ * be present after resume if a device was plugged in before suspend.
+ *
+ * The thunderbolt controller consists of a pcie switch with downstream
+ * bridges leading to the NHI and to the tunnel pci bridges.
+ *
+ * This quirk cuts power to the whole chip. Therefore we have to apply it
+ * during suspend_noirq of the upstream bridge.
+ *
+ * Power is automagically restored before resume. No action is needed.
+ */
+static void quirk_apple_poweroff_thunderbolt(struct pci_dev *dev)
+{
+	acpi_handle bridge, SXIO, SXFP, SXLV;
+
+	if (!dmi_match(DMI_BOARD_VENDOR, "Apple Inc."))
+		return;
+	if (pci_pcie_type(dev) != PCI_EXP_TYPE_UPSTREAM)
+		return;
+	bridge = ACPI_HANDLE(&dev->dev);
+	if (!bridge)
+		return;
+	/*
+	 * SXIO and SXLV are present only on machines requiring this quirk.
+	 * TB bridges in external devices might have the same device id as those
+	 * on the host, but they will not have the associated ACPI methods. This
+	 * implicitly checks that we are at the right bridge.
+	 */
+	if (ACPI_FAILURE(acpi_get_handle(bridge, "DSB0.NHI0.SXIO", &SXIO))
+	    || ACPI_FAILURE(acpi_get_handle(bridge, "DSB0.NHI0.SXFP", &SXFP))
+	    || ACPI_FAILURE(acpi_get_handle(bridge, "DSB0.NHI0.SXLV", &SXLV)))
+		return;
+	dev_info(&dev->dev, "quirk: cutting power to thunderbolt controller...\n");
+
+	/* magic sequence */
+	acpi_execute_simple_method(SXIO, NULL, 1);
+	acpi_execute_simple_method(SXFP, NULL, 0);
+	msleep(300);
+	acpi_execute_simple_method(SXLV, NULL, 0);
+	acpi_execute_simple_method(SXIO, NULL, 0);
+	acpi_execute_simple_method(SXLV, NULL, 0);
+}
+DECLARE_PCI_FIXUP_SUSPEND_LATE(PCI_VENDOR_ID_INTEL, 0x1547,
+			       quirk_apple_poweroff_thunderbolt);
+
+/*
+ * Apple: Wait for the thunderbolt controller to reestablish pci tunnels.
+ *
+ * During suspend the thunderbolt controller is reset and all pci
+ * tunnels are lost. The NHI driver will try to reestablish all tunnels
+ * during resume. We have to manually wait for the NHI since there is
+ * no parent child relationship between the NHI and the tunneled
+ * bridges.
+ */
+static void quirk_apple_wait_for_thunderbolt(struct pci_dev *dev)
+{
+	struct pci_dev *sibling = NULL;
+	struct pci_dev *nhi = NULL;
+
+	if (!dmi_match(DMI_BOARD_VENDOR, "Apple Inc."))
+		return;
+	if (pci_pcie_type(dev) != PCI_EXP_TYPE_DOWNSTREAM)
+		return;
+	/*
+	 * Find the NHI and confirm that we are a bridge on the tb host
+	 * controller and not on a tb endpoint.
+	 */
+	sibling = pci_get_slot(dev->bus, 0x0);
+	if (sibling == dev)
+		goto out; /* we are the downstream bridge to the NHI */
+	if (!sibling || !sibling->subordinate)
+		goto out;
+	nhi = pci_get_slot(sibling->subordinate, 0x0);
+	if (!nhi)
+		goto out;
+	if (nhi->vendor != PCI_VENDOR_ID_INTEL
+			|| (nhi->device != 0x1547 && nhi->device != 0x156c)
+			|| nhi->subsystem_vendor != 0x2222
+			|| nhi->subsystem_device != 0x1111)
+		goto out;
+	dev_info(&dev->dev, "quirk: wating for thunderbolt to reestablish pci tunnels...\n");
+	device_pm_wait_for_dev(&dev->dev, &nhi->dev);
+out:
+	pci_dev_put(nhi);
+	pci_dev_put(sibling);
+}
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL, 0x1547,
+			       quirk_apple_wait_for_thunderbolt);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL, 0x156d,
+			       quirk_apple_wait_for_thunderbolt);
+#endif
+
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)
 {
-- 
2.0.0

