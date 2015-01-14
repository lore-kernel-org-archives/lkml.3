Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbbANPIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:08:49 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:59667 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbbANPIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:08:25 -0500
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>
Cc: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Jon Masters <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        phoenix.liyi@huawei.com, Timur Tabi <timur@codeaurora.org>,
        suravee.suthikulpanit@amd.com, wangyijing@huawei.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v7 11/17] ACPI / processor: Make it possible to get CPU hardware ID via GICC
Date: Wed, 14 Jan 2015 23:04:59 +0800
Message-Id: <1421247905-3749-12-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new function map_gicc_mpidr() to allow MPIDRs to be obtained
from the GICC Structure introduced by ACPI 5.1.

MPIDR is the CPU hardware ID as local APIC ID on x86 platform, so we use
MPIDR not the GIC CPU interface ID to identify CPUs.

Tested-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Tested-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/include/asm/acpi.h | 29 +++++++++++++++++++++++++++++
 arch/arm64/kernel/acpi.c      |  1 -
 drivers/acpi/processor_core.c | 37 +++++++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index c82d4a1..639bb2a 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -12,6 +12,8 @@
 #ifndef _ASM_ACPI_H
 #define _ASM_ACPI_H
 
+#include <asm/smp_plat.h>
+
 /* Basic configuration for ACPI */
 #ifdef	CONFIG_ACPI
 #define acpi_strict 1	/* No out-of-spec workarounds on ARM64 */
@@ -45,6 +47,33 @@ static inline void enable_acpi(void)
 	acpi_noirq = 0;
 }
 
+/* MPIDR value provided in GICC structure is 64 bits, but the
+ * existing apic_id (CPU hardware ID) using in acpi processor
+ * driver is 32-bit, to conform to the same datatype we need
+ * to repack the GICC structure MPIDR.
+ *
+ * Only 32 bits of MPIDR are used:
+ *
+ * Bits [0:7] Aff0;
+ * Bits [8:15] Aff1;
+ * Bits [16:23] Aff2;
+ * Bits [32:39] Aff3;
+ */
+static inline u32 pack_mpidr(u64 mpidr)
+{
+	return (u32) ((mpidr & 0xff00000000) >> 8) | mpidr;
+}
+
+/*
+ * The ACPI processor driver for ACPI core code needs this macro
+ * to find out this cpu was already mapped (mapping from CPU hardware
+ * ID to CPU logical ID) or not.
+ *
+ * cpu_logical_map(cpu) is the mapping of MPIDR and the logical cpu,
+ * and MPIDR is the cpu hardware ID we needed to pack.
+ */
+#define cpu_physical_id(cpu) pack_mpidr(cpu_logical_map(cpu))
+
 /*
  * It's used from ACPI core in kdump to boot UP system with SMP kernel,
  * with this check the ACPI core will not override the CPU index
diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index 55d99d9..0b7c3a6 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -24,7 +24,6 @@
 #include <linux/bootmem.h>
 #include <linux/smp.h>
 
-#include <asm/smp_plat.h>
 #include <asm/cputype.h>
 #include <asm/cpu_ops.h>
 
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 02e4839..e634b14 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -64,6 +64,38 @@ static int map_lsapic_id(struct acpi_subtable_header *entry,
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
+		*mpidr = ((gicc->arm_mpidr & 0xff00000000) >> 8)
+			 | gicc->arm_mpidr;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 static int map_madt_entry(int type, u32 acpi_id)
 {
 	unsigned long madt_end, entry;
@@ -99,6 +131,9 @@ static int map_madt_entry(int type, u32 acpi_id)
 		} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
 			if (!map_lsapic_id(header, type, acpi_id, &phys_id))
 				break;
+		} else if (header->type == ACPI_MADT_TYPE_GENERIC_INTERRUPT) {
+			if (!map_gicc_mpidr(header, type, acpi_id, &phys_id))
+				break;
 		}
 		entry += header->length;
 	}
@@ -131,6 +166,8 @@ static int map_mat_entry(acpi_handle handle, int type, u32 acpi_id)
 		map_lsapic_id(header, type, acpi_id, &phys_id);
 	else if (header->type == ACPI_MADT_TYPE_LOCAL_X2APIC)
 		map_x2apic_id(header, type, acpi_id, &phys_id);
+	else if (header->type == ACPI_MADT_TYPE_GENERIC_INTERRUPT)
+		map_gicc_mpidr(header, type, acpi_id, &phys_id);
 
 exit:
 	kfree(buffer.pointer);
-- 
1.9.1

