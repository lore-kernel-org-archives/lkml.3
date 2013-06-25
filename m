Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab3FYQTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 12:19:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:29715 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427Ab3FYQT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 12:19:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,938,1363158000"; 
   d="scan'208";a="322373907"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Yinghai Lu <yinghai@kernel.org>,
        john.ronciak@intel.com, miles.j.penner@intel.com,
        bruce.w.allan@intel.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        x86@kernel.org
Subject: [PATCH 6/6] x86/PCI: quirk Thunderbolt PCI-to-PCI bridges
Date: Tue, 25 Jun 2013 19:22:10 +0300
Message-Id: <1372177330-28013-7-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thunderbolt PCI-to-PCI bridges typically use BIOS "assisted" enumeration.
This means that the BIOS will allocate bridge resources based on some
assumptions of a maximum Thunderbolt chain. It also disables native PCIe
hotplug of the root port where the Thunderbolt host router is connected.

In order to support this we must make sure that the kernel does not try to
be too smart and resize / open the bridge windows during PCI enumeration.
For example by default the kernel will add certain amount of space to the
bridge memory/io windows (this is configurable via pci=hp[mem|io]size=xxx
command line option). Eventually we run out of space that the BIOS has
allocated.

Also address space for expansion ROMs should not be allocated (BIOS does
not execute them for Thunderbolt endpoints). If we don't prevent this the
kernel might find expansion ROM associated with some endpoint and reopen
the bridge window which the BIOS already closed leading again resource
exhaustion.

Fix this by adding a quirk that matches known Thunderbolt PCI-to-PCI
bridges and in that case prevents allocation of expansion ROM resources and
makes sure that the PCI core does not increase size of bridge windows.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 arch/x86/pci/fixup.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index f5809fa..924822b 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -7,6 +7,8 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/vgaarb.h>
+#include <linux/acpi.h>
+#include <linux/pci-acpi.h>
 #include <asm/pci_x86.h>
 
 static void pci_fixup_i450nx(struct pci_dev *d)
@@ -539,3 +541,52 @@ static void twinhead_reserve_killing_zone(struct pci_dev *dev)
         }
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x27B9, twinhead_reserve_killing_zone);
+
+#ifdef CONFIG_ACPI
+/*
+ * BIOS assisted Thunderbolt PCI enumeration should handle all resource
+ * allocation on behalf of OS.
+ */
+static void quirk_thunderbolt(struct pci_dev *dev)
+{
+	struct acpi_pci_root *root;
+	acpi_handle handle;
+
+	handle = acpi_find_root_bridge_handle(dev);
+	if (!handle)
+		return;
+
+	root = acpi_pci_find_root(handle);
+	if (!root)
+		return;
+
+	/*
+	 * Native PCIe hotplug should be disabled when BIOS assisted
+	 * hotplug is in use.
+	 */
+	if (root->osc_control_set & OSC_PCI_EXPRESS_NATIVE_HP_CONTROL)
+		return;
+
+	/*
+	 * Make sure that we don't allocate resources for expansion ROMs.
+	 * This may accidentally increase the size of the bridge window
+	 * causing us to run out of resources.
+	 */
+	if (!(pci_probe & PCI_NOASSIGN_ROMS)) {
+		pr_info("Thunderbolt host router detected disabling ROMs\n");
+		pci_probe |= PCI_NOASSIGN_ROMS;
+	}
+
+	/*
+	 * Don't add anything to the BIOS allocated bridge window size for
+	 * the same reason.
+	 */
+	dev->is_hotplug_bridge = 0;
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x1513, quirk_thunderbolt);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x151a, quirk_thunderbolt);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x151b, quirk_thunderbolt);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x1547, quirk_thunderbolt);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x1548, quirk_thunderbolt);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x1549, quirk_thunderbolt);
+#endif
-- 
1.8.3.1

