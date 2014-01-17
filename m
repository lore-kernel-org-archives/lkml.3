Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaAQMgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 07:36:47 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37995 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaAQMgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 07:36:45 -0500
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linaro-acpi@lists.linaro.org,
        Charles.Garcia-Tobin@arm.com, Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH 06/20] ARM64 / ACPI: Introduce some PCI functions when PCI is enabled
Date: Fri, 17 Jan 2014 20:25:00 +0800
Message-Id: <1389961514-13562-7-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce some PCI functions to make ACPI can be compiled when
CONFIG_PCI is enabled, these functions should be revisited when
implemented on ARM64.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/Makefile          |    1 +
 arch/arm64/pci/Makefile      |    1 +
 arch/arm64/pci/pci.c         |   33 +++++++++++++++++++++++++++++++++
 drivers/acpi/plat/arm-core.c |   19 +++++++++++++++++++
 4 files changed, 54 insertions(+)
 create mode 100644 arch/arm64/pci/Makefile
 create mode 100644 arch/arm64/pci/pci.c

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 2fceb71..fcaa58e 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -45,6 +45,7 @@ export	TEXT_OFFSET GZFLAGS
 core-y		+= arch/arm64/kernel/ arch/arm64/mm/
 core-$(CONFIG_KVM) += arch/arm64/kvm/
 core-$(CONFIG_XEN) += arch/arm64/xen/
+drivers-$(CONFIG_PCI)	+= arch/arm64/pci/
 libs-y		:= arch/arm64/lib/ $(libs-y)
 libs-y		+= $(LIBGCC)
 
diff --git a/arch/arm64/pci/Makefile b/arch/arm64/pci/Makefile
new file mode 100644
index 0000000..b8d5dbd
--- /dev/null
+++ b/arch/arm64/pci/Makefile
@@ -0,0 +1 @@
+obj-y                 += pci.o
diff --git a/arch/arm64/pci/pci.c b/arch/arm64/pci/pci.c
new file mode 100644
index 0000000..4e46790
--- /dev/null
+++ b/arch/arm64/pci/pci.c
@@ -0,0 +1,33 @@
+#include <linux/acpi.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/pci.h>
+
+/**
+ * raw_pci_read - Platform-specific PCI config space access.
+ *
+ * Default empty implementation.  Replace with an architecture-specific setup
+ * routine, if necessary.
+ */
+int __weak raw_pci_read(unsigned int domain, unsigned int bus,
+			unsigned int devfn, int reg, int len, u32 *val)
+{
+	return -EINVAL;
+}
+
+int __weak raw_pci_write(unsigned int domain, unsigned int bus,
+			unsigned int devfn, int reg, int len, u32 val)
+{
+	return -EINVAL;
+}
+
+/* Root bridge scanning */
+struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
+{
+	return NULL;
+}
+
+void __init pci_acpi_crs_quirks(void)
+{
+	return;
+}
diff --git a/drivers/acpi/plat/arm-core.c b/drivers/acpi/plat/arm-core.c
index 3c8521d..1835b21 100644
--- a/drivers/acpi/plat/arm-core.c
+++ b/drivers/acpi/plat/arm-core.c
@@ -100,6 +100,25 @@ int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
 }
 EXPORT_SYMBOL_GPL(acpi_gsi_to_irq);
 
+int acpi_isa_irq_to_gsi(unsigned isa_irq, u32 *gsi)
+{
+	return -1;
+}
+
+int acpi_register_ioapic(acpi_handle handle, u64 phys_addr, u32 gsi_base)
+{
+	/* TBD */
+	return -EINVAL;
+}
+EXPORT_SYMBOL(acpi_register_ioapic);
+
+int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base)
+{
+	/* TBD */
+	return -EINVAL;
+}
+EXPORT_SYMBOL(acpi_unregister_ioapic);
+
 /*
  * success: return IRQ number (>0)
  * failure: return =< 0
-- 
1.7.9.5

