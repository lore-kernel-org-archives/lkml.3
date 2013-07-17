Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934Ab3GQXPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:15:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56590 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934466Ab3GQWzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:55:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Neil Horman <nhorman@tuxdriver.com>, Prarit Bhargava <prarit@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Don Dutile <ddutile@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pci@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?q?Arkadiusz=20Mi=C5=9Bkiewicz?= <arekm@maven.pl>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 089/145] iommu/vt-d: add quirk for broken interrupt remapping on 55XX chipsets
Date: Wed, 17 Jul 2013 15:47:01 -0700
Message-Id: <1374101277-7915-90-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

commit 03bbcb2e7e292838bb0244f5a7816d194c911d62 upstream.

A few years back intel published a spec update:
http://www.intel.com/content/dam/doc/specification-update/5520-and-5500-chipset-ioh-specification-update.pdf

For the 5520 and 5500 chipsets which contained an errata (specificially errata
53), which noted that these chipsets can't properly do interrupt remapping, and
as a result the recommend that interrupt remapping be disabled in bios.  While
many vendors have a bios update to do exactly that, not all do, and of course
not all users update their bios to a level that corrects the problem.  As a
result, occasionally interrupts can arrive at a cpu even after affinity for that
interrupt has be moved, leading to lost or spurrious interrupts (usually
characterized by the message:
kernel: do_IRQ: 7.71 No irq handler for vector (irq -1)

There have been several incidents recently of people seeing this error, and
investigation has shown that they have system for which their BIOS level is such
that this feature was not properly turned off.  As such, it would be good to
give them a reminder that their systems are vulnurable to this problem.  For
details of those that reported the problem, please see:
https://bugzilla.redhat.com/show_bug.cgi?id=887006

[ Joerg: Removed CONFIG_IRQ_REMAP ifdef from early-quirks.c ]

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Prarit Bhargava <prarit@redhat.com>
CC: Don Zickus <dzickus@redhat.com>
CC: Don Dutile <ddutile@redhat.com>
CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Asit Mallick <asit.k.mallick@intel.com>
CC: David Woodhouse <dwmw2@infradead.org>
CC: linux-pci@vger.kernel.org
CC: Joerg Roedel <joro@8bytes.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Arkadiusz Miśkiewicz <arekm@maven.pl>
Signed-off-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/include/asm/irq_remapping.h |  2 ++
 arch/x86/kernel/early-quirks.c       | 20 ++++++++++++++++++++
 drivers/iommu/intel_irq_remapping.c  | 10 ++++++++++
 drivers/iommu/irq_remapping.c        |  6 ++++++
 drivers/iommu/irq_remapping.h        |  2 ++
 5 files changed, 40 insertions(+)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 5fb9bbb..38477e6 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -30,6 +30,7 @@ extern int irq_remapping_enabled;
 
 extern void setup_irq_remapping_ops(void);
 extern int irq_remapping_supported(void);
+extern void set_irq_remapping_broken(void);
 extern int irq_remapping_prepare(void);
 extern int irq_remapping_enable(void);
 extern void irq_remapping_disable(void);
@@ -58,6 +59,7 @@ extern int setup_hpet_msi_remapped(unsigned int irq, unsigned int id);
 
 static inline void setup_irq_remapping_ops(void) { }
 static inline int irq_remapping_supported(void) { return 0; }
+static inline void set_irq_remapping_broken(void) { }
 static inline int irq_remapping_prepare(void) { return -ENODEV; }
 static inline int irq_remapping_enable(void) { return -ENODEV; }
 static inline void irq_remapping_disable(void) { }
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 3755ef4..94ab6b9 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -18,6 +18,7 @@
 #include <asm/apic.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
+#include <asm/irq_remapping.h>
 
 static void __init fix_hypertransport_config(int num, int slot, int func)
 {
@@ -192,6 +193,21 @@ static void __init ati_bugs_contd(int num, int slot, int func)
 }
 #endif
 
+static void __init intel_remapping_check(int num, int slot, int func)
+{
+	u8 revision;
+
+	revision = read_pci_config_byte(num, slot, func, PCI_REVISION_ID);
+
+	/*
+	 * Revision 0x13 of this chipset supports irq remapping
+	 * but has an erratum that breaks its behavior, flag it as such
+	 */
+	if (revision == 0x13)
+		set_irq_remapping_broken();
+
+}
+
 #define QFLAG_APPLY_ONCE 	0x1
 #define QFLAG_APPLIED		0x2
 #define QFLAG_DONE		(QFLAG_APPLY_ONCE|QFLAG_APPLIED)
@@ -221,6 +237,10 @@ static struct chipset early_qrk[] __initdata = {
 	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs },
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
 	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs_contd },
+	{ PCI_VENDOR_ID_INTEL, 0x3403, PCI_CLASS_BRIDGE_HOST,
+	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
+	{ PCI_VENDOR_ID_INTEL, 0x3406, PCI_CLASS_BRIDGE_HOST,
+	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
 	{}
 };
 
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index af8904d..4c9379c 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -509,6 +509,16 @@ static int __init intel_irq_remapping_supported(void)
 
 	if (disable_irq_remap)
 		return 0;
+	if (irq_remap_broken) {
+		WARN_TAINT(1, TAINT_FIRMWARE_WORKAROUND,
+			   "This system BIOS has enabled interrupt remapping\n"
+			   "on a chipset that contains an erratum making that\n"
+			   "feature unstable.  To maintain system stability\n"
+			   "interrupt remapping is being disabled.  Please\n"
+			   "contact your BIOS vendor for an update\n");
+		disable_irq_remap = 1;
+		return 0;
+	}
 
 	if (!dmar_ir_support())
 		return 0;
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index faf85d6..018382c 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -12,6 +12,7 @@
 int irq_remapping_enabled;
 
 int disable_irq_remap;
+int irq_remap_broken;
 int disable_sourceid_checking;
 int no_x2apic_optout;
 
@@ -58,6 +59,11 @@ void __init setup_irq_remapping_ops(void)
 #endif
 }
 
+void set_irq_remapping_broken(void)
+{
+	irq_remap_broken = 1;
+}
+
 int irq_remapping_supported(void)
 {
 	if (disable_irq_remap)
diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
index 95363ac..23bdea1 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -32,6 +32,7 @@ struct pci_dev;
 struct msi_msg;
 
 extern int disable_irq_remap;
+extern int irq_remap_broken;
 extern int disable_sourceid_checking;
 extern int no_x2apic_optout;
 
@@ -88,6 +89,7 @@ extern struct irq_remap_ops amd_iommu_irq_ops;
 
 #define irq_remapping_enabled 0
 #define disable_irq_remap     1
+#define irq_remap_broken      0
 
 #endif /* CONFIG_IRQ_REMAP */
 
-- 
1.8.1.2

