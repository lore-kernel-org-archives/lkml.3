Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab3HMP6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:58:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9153 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758674Ab3HMP6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:41 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=dA54d0OBvKkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Oh_qystl_fcA:10 a=vmLDa1wCAAAA:8 a=QyXUC8HyAAAA:8 a=20KFwNOVAAAA:8 a=1XWaLZrsAAAA:8 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=tA7aZXjiAAAA:8 a=yPCof4ZbAAAA:8 a=XnfKoTeQ4CRjI8mGxxcA:9 a=gv_BBZfBKR8A:10 a=jEp0ucaQiEUA:10 a=UTB_XpHje0EA:10 a=dGJ0OcVc7YAA:10 a=3Rfx1nUSh_UA:10 a=qM0ISud-tAQA:10 a=7DSvI1NPTFQA:10 a=jeBq3FmKZ4MA:10 a=pmdg7LrLQe9PXhzq:21 a=R2wCLlGuL50o-oRP:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155830.984837267@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Prarit Bhargava <prarit@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Don Dutile <ddutile@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        David Woodhouse <dwmw2@infradead.org>, Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?q?Arkadiusz=20Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: [47/88] iommu/vt-d: add quirk for broken interrupt remapping on 55XX
 chipsets
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0047-iommu-vt-d-add-quirk-for-broken-interrupt-remapping-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

[ Upstream commit 03bbcb2e7e292838bb0244f5a7816d194c911d62 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/irq_remapping.h |    2 ++
 arch/x86/kernel/early-quirks.c       |   20 ++++++++++++++++++++
 drivers/iommu/intel_irq_remapping.c  |   10 ++++++++++
 drivers/iommu/irq_remapping.c        |    6 ++++++
 drivers/iommu/irq_remapping.h        |    1 +
 5 files changed, 39 insertions(+)

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
index 151690d..4a971f7 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -12,6 +12,7 @@
 int irq_remapping_enabled;
 
 int disable_irq_remap;
+int irq_remap_broken;
 int disable_sourceid_checking;
 int no_x2apic_optout;
 
@@ -53,6 +54,11 @@ void __init setup_irq_remapping_ops(void)
 	remap_ops = &intel_irq_remap_ops;
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
index b12974c..3fcf62c 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -32,6 +32,7 @@ struct pci_dev;
 struct msi_msg;
 
 extern int disable_irq_remap;
+extern int irq_remap_broken;
 extern int disable_sourceid_checking;
 extern int no_x2apic_optout;
 
-- 
1.7.10.4


