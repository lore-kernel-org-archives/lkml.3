Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298AbaGXNDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:03:00 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49222 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759219AbaGXNC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:02:57 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi-private@linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH 11/19] ACPI / processor: Make it possible to get CPU hardware ID via GICC
Date: Thu, 24 Jul 2014 21:00:17 +0800
Message-Id: <1406206825-15590-12-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new function map_gicc_mpidr() to allow MPIDRs to be obtained
from the GICC Structure introduced by ACPI 5.1.

MPIDR is the CPU hardware ID as local APIC ID on x86 platform, so we use
MPIDR not the GIC CPU interface ID to identify CPUs.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/include/asm/acpi.h |   14 ++++++++++++++
 arch/arm64/kernel/acpi.c      |   21 ++++++++++++++++++++-
 drivers/acpi/processor_core.c |   36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index 6240327..f40e137 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -12,6 +12,8 @@
 #ifndef _ASM_ACPI_H
 #define _ASM_ACPI_H
 
+#include <asm/smp_plat.h>
+
 /* Basic configuration for ACPI */
 #ifdef	CONFIG_ACPI
 /*
@@ -49,6 +51,18 @@ static inline void disable_acpi(void)
 	acpi_noirq = 1;
 }
 
+u32 pack_mpidr_into_32_bits(u64 mpidr);
+
+/*
+ * The ACPI processor driver for ACPI core code needs this macro
+ * to find out this cpu was already mapped (mapping from CPU hardware
+ * ID to CPU logical ID) or not.
+ *
+ * cpu_logical_map(cpu) is the mapping of MPIDR and the logical cpu,
+ * and MPIDR is the cpu hardware ID we needed.
+ */
+#define cpu_physical_id(cpu) pack_mpidr_into_32_bits(cpu_logical_map(cpu))
+
 /*
  * MADT must provide at least one GICC structure
  * for GIC initialization, so CPU will be
diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index 2af6662..ef06e91 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -22,7 +22,6 @@
 #include <linux/bootmem.h>
 #include <linux/smp.h>
 
-#include <asm/smp_plat.h>
 #include <asm/cputype.h>
 
 /*
@@ -279,6 +278,26 @@ static int __init parse_acpi(char *arg)
 }
 early_param("acpi", parse_acpi);
 
+/* MPIDR value provided in GICC structure is 64 bits, but
+ * the acpi processor driver use the 32 bits cpu hardware
+ * ID (apic_id on intel platform) everywhere, it is pretty
+ * hard to modify the acpi processor driver to accept the
+ * 64 bits MPIDR value, at the same time, only 32 bits of
+ * the MPIDR is used in the 64 bits MPIDR, just pack the
+ * Affx fields into a single 32 bit identifier to accommodate
+ * the acpi processor drivers.
+ */
+u32 pack_mpidr_into_32_bits(u64 mpidr)
+{
+	/*
+	 * Bits [0:7] Aff0;
+	 * Bits [8:15] Aff1;
+	 * Bits [16:23] Aff2;
+	 * Bits [32:39] Aff3;
+	 */
+	return (u32) ((mpidr & 0xff00000000) >> 8) | mpidr;
+}
+
 /*
  * acpi_suspend_lowlevel() - save kernel state and suspend.
  *
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 00f48d1..fa3d0ed 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -64,6 +64,37 @@ static int map_lsapic_id(struct acpi_subtable_header *entry,
 	return 0;
 }
 
+/*
+ * On ARM platform, MPIDR value is the hardware ID as apic ID
+ * on Intel platforms
+ */
+static int map_gicc_mpidr(struct acpi_subtable_header *entry,
+		int device_declaration, u32 acpi_id, int *mpidr)
+{
+	struct acpi_madt_generic_interrupt *gicc =
+	    container_of(entry, struct acpi_madt_generic_interrupt, header);
+
+	if (!(gicc->flags & ACPI_MADT_ENABLED))
+		return -ENODEV;
+
+	/* In the GIC interrupt model, logical processors are
+	 * required to have a Processor Device object in the DSDT,
+	 * so we should check device_declaration here
+	 */
+	if (device_declaration && (gicc->uid == acpi_id)) {
+		/*
+		 * Only bits [0:7] Aff0, bits [8:15] Aff1, bits [16:23] Aff2
+		 * and bits [32:39] Aff3 are meaningful, so pack the Affx
+		 * fields into a single 32 bit identifier to accommodate the
+		 * acpi processor drivers.
+		 */
+		*mpidr = ((gicc->mpidr & 0xff00000000) >> 8) | gicc->mpidr;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 static int map_madt_entry(int type, u32 acpi_id)
 {
 	unsigned long madt_end, entry;
@@ -99,6 +130,9 @@ static int map_madt_entry(int type, u32 acpi_id)
 		} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
 			if (!map_lsapic_id(header, type, acpi_id, &apic_id))
 				break;
+		} else if (header->type == ACPI_MADT_TYPE_GENERIC_INTERRUPT) {
+			if (!map_gicc_mpidr(header, type, acpi_id, &apic_id))
+				break;
 		}
 		entry += header->length;
 	}
@@ -129,6 +163,8 @@ static int map_mat_entry(acpi_handle handle, int type, u32 acpi_id)
 		map_lapic_id(header, acpi_id, &apic_id);
 	} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
 		map_lsapic_id(header, type, acpi_id, &apic_id);
+	} else if (header->type == ACPI_MADT_TYPE_GENERIC_INTERRUPT) {
+		map_gicc_mpidr(header, type, acpi_id, &apic_id);
 	}
 
 exit:
-- 
1.7.9.5

