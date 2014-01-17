Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaAQMx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 07:53:57 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:50924 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaAQMxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 07:53:53 -0500
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
Subject: =?yes?q?=5BPATCH=2016/20=5D=20ACPI=20/=20GIC=3A=20Initialize=20GIC=20using=20the=20information=20in=20MADT?=
Date: Fri, 17 Jan 2014 20:25:10 +0800
Message-Id: <1389961514-13562-17-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=yes
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In MADT table, there are GIC cpu interface base address and
GIC distributor base address, use them to convert GIC to ACPI.

Only GICC and GICD are described in ACPI 5.0, and only one GIC
is supported at now.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/kernel/irq.c      |    6 ++++
 drivers/acpi/plat/arm-core.c |   64 ++++++++++++++++++++++++++++++++++++------
 include/linux/acpi.h         |    6 ++++
 3 files changed, 68 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
index 473e5db..490d971 100644
--- a/arch/arm64/kernel/irq.c
+++ b/arch/arm64/kernel/irq.c
@@ -25,6 +25,7 @@
 #include <linux/irq.h>
 #include <linux/smp.h>
 #include <linux/init.h>
+#include <linux/acpi.h>
 #include <linux/irqchip.h>
 #include <linux/seq_file.h>
 #include <linux/ratelimit.h>
@@ -78,6 +79,11 @@ void __init set_handle_irq(void (*handle_irq)(struct pt_regs *))
 void __init init_IRQ(void)
 {
 	irqchip_init();
+
+	/* FIXME: need to fix GIC hardcoded here and find a scalable way */
+	if (!handle_arch_irq)
+		acpi_gic_init();
+
 	if (!handle_arch_irq)
 		panic("No interrupt controller found.");
 }
diff --git a/drivers/acpi/plat/arm-core.c b/drivers/acpi/plat/arm-core.c
index 22c8235..c4a7327 100644
--- a/drivers/acpi/plat/arm-core.c
+++ b/drivers/acpi/plat/arm-core.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
+#include <linux/irqchip/arm-gic.h>
 #include <linux/bootmem.h>
 #include <linux/smp.h>
 
@@ -210,6 +211,15 @@ acpi_parse_gic(struct acpi_subtable_header *header, const unsigned long end)
 	acpi_table_print_madt_entry(header);
 
 	/*
+	 * As ACPI 5.0 said, the 64-bit physical address in GIC struct at
+	 * which the processor can access this GIC. If provided, the
+	 * “Local Interruptp controller Address” field in  the MADT
+	 * is ignored by OSPM.
+	 */
+	if (processor->base_address)
+		acpi_lapic_addr = processor->base_address;
+
+	/*
 	 * We need to register disabled CPU as well to permit
 	 * counting disabled CPUs. This allows us to size
 	 * cpus_possible_map more accurately, to permit
@@ -229,11 +239,26 @@ acpi_parse_gic(struct acpi_subtable_header *header, const unsigned long end)
 	return 0;
 }
 
+/*
+ * Hard code here, we can not get memory size from MADT (but FDT does),
+ * this size can be refered from GICv2 spec
+ */
+#define GIC_DISTRIBUTOR_MEMORY_SIZE (SZ_4K)
+#define GIC_CPU_INTERFACE_MEMORY_SIZE (SZ_8K)
+
+/*
+ * ACPI 5.0 only provides information of GICC and GICD, use them
+ * to initialize GIC
+ */
 static int __init
 acpi_parse_gic_distributor(struct acpi_subtable_header *header,
 				const unsigned long end)
 {
 	struct acpi_madt_generic_distributor *distributor = NULL;
+	void __iomem *dist_base, *cpu_base;
+
+	if (!IS_ENABLED(CONFIG_ARM_GIC))
+		return -ENODEV;
 
 	distributor = (struct acpi_madt_generic_distributor *)header;
 
@@ -242,6 +267,27 @@ acpi_parse_gic_distributor(struct acpi_subtable_header *header,
 
 	acpi_table_print_madt_entry(header);
 
+	/* GIC is initialised after page_init(), no need for early_ioremap */
+	dist_base = ioremap(distributor->base_address,
+				GIC_DISTRIBUTOR_MEMORY_SIZE);
+	if (!dist_base) {
+		pr_warn(PREFIX "unable to map gic dist registers\n");
+		return -ENOMEM;
+	}
+
+	/*
+	 * acpi_lapic_addr is stored in acpi_parse_madt() or acpi_parse_gic(),
+	 * so we can use it here for GIC init
+	 */
+	cpu_base = ioremap(acpi_lapic_addr, GIC_CPU_INTERFACE_MEMORY_SIZE);
+	if (!cpu_base) {
+		iounmap(dist_base);
+		pr_warn(PREFIX "unable to map gic cpu registers\n");
+		return -ENOMEM;
+	}
+
+	gic_init(distributor->gic_id, -1, dist_base, cpu_base);
+
 	return 0;
 }
 
@@ -423,19 +469,21 @@ static void __init acpi_process_madt(void)
 		 * Parse MADT GIC cpu interface entries
 		 */
 		error = acpi_parse_madt_gic_entries();
-		if (!error) {
-			/*
-			 * Parse MADT GIC distributor entries
-			 */
-			acpi_parse_madt_gic_distributor_entries();
-		}
+		if (!error)
+			pr_info("Using ACPI for processor (GIC) configuration information\n");
 	}
 
-	pr_info("Using ACPI for processor (GIC) configuration information\n");
-
 	return;
 }
 
+int __init acpi_gic_init(void)
+{
+	/*
+	 * Parse MADT GIC distributor entries
+	 */
+	return acpi_parse_madt_gic_distributor_entries();
+}
+
 /*
  * To see PCSI is enabled or not.
  *
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index da55da2..a2dbe67 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -106,6 +106,7 @@ char * __acpi_map_table (unsigned long phys_addr, unsigned long size);
 void __acpi_unmap_table(char *map, unsigned long size);
 int early_acpi_boot_init(void);
 int acpi_boot_init (void);
+int acpi_gic_init(void);
 void acpi_boot_table_init (void);
 int acpi_mps_check (void);
 int acpi_numa_init (void);
@@ -436,6 +437,11 @@ static inline int acpi_boot_init(void)
 	return 0;
 }
 
+static inline int acpi_gic_init(void)
+{
+	return -ENODEV;
+}
+
 static inline void acpi_boot_table_init(void)
 {
 	return;
-- 
1.7.9.5

