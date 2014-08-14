Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbaHNT6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 15:58:44 -0400
Received: from mail-yk0-f179.google.com ([209.85.160.179]:60404 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbaHNT5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 15:57:55 -0400
From: Ashwin Chaugule <ashwin.chaugule@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, mike.turquette@linaro.org,
        morten.rasmussen@arm.com, arjan@linux.intel.com, mingo@kernel.org,
        peterz@infradead.org, len.brown@intel.com, rjw@rjwysocki.ne,
        linaro-acpi@lists.linaro.org, arnd@arndb.de,
        linux-acpi@vger.kernel.org, cpufreq@vger.kernel.org,
        patches@linaro.org, Ashwin Chaugule <ashwin.chaugule@linaro.org>
Subject: [RFC 1/3] ACPI: Add support for Platform Communication Channel
Date: Thu, 14 Aug 2014 15:57:08 -0400
Message-Id: <1408046230-16439-2-git-send-email-ashwin.chaugule@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408046230-16439-1-git-send-email-ashwin.chaugule@linaro.org>
References: <1408046230-16439-1-git-send-email-ashwin.chaugule@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACPI 5.0+ spec defines a generic mode of communication
between the OS and a platform such as the BMC or external power
controller. This medium (PCC) is typically used by CPPC
(ACPI CPU Performance management), RAS (ACPI reliability protocol)
and MPST (ACPI Memory power states).

This patch adds initial support for PCC to be usable by the
aforementioned PCC clients.

Signed-off-by: Ashwin Chaugule <ashwin.chaugule@linaro.org>
---
 drivers/acpi/Kconfig  |  10 +++
 drivers/acpi/Makefile |   1 +
 drivers/acpi/pcc.c    | 192 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 203 insertions(+)
 create mode 100644 drivers/acpi/pcc.c

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index a34a228..16d7c9a 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -364,6 +364,16 @@ config ACPI_REDUCED_HARDWARE_ONLY
 
 	If you are unsure what to do, do not enable this option.
 
+config ACPI_PCC
+	bool "ACPI Platform Communication Channel"
+	def_bool n
+	depends on ACPI
+	help
+	Enable this option if your platform supports PCC as defined in the
+	ACPI spec 5.0a+. PCC is a generic mechanism for the OS to communicate
+	with a platform such as a BMC. PCC is typically used by CPPC, RAS
+	and MPST. 
+
 source "drivers/acpi/apei/Kconfig"
 
 config ACPI_EXTLOG
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index ea55e01..35015fa 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -74,6 +74,7 @@ obj-$(CONFIG_ACPI_HED)		+= hed.o
 obj-$(CONFIG_ACPI_EC_DEBUGFS)	+= ec_sys.o
 obj-$(CONFIG_ACPI_CUSTOM_METHOD)+= custom_method.o
 obj-$(CONFIG_ACPI_BGRT)		+= bgrt.o
+obj-$(CONFIG_ACPI_PCC)		+= pcc.o
 
 # processor has its own "processor." module_param namespace
 processor-y			:= processor_driver.o processor_throttling.o
diff --git a/drivers/acpi/pcc.c b/drivers/acpi/pcc.c
new file mode 100644
index 0000000..105e11a
--- /dev/null
+++ b/drivers/acpi/pcc.c
@@ -0,0 +1,192 @@
+/*
+ *	Copyright (C) 2014 Linaro Ltd.
+ *	Author:	Ashwin Chaugule <ashwin.chaugule@linaro.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ */
+
+#include <linux/acpi.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <linux/init.h>
+#include <linux/cpufreq.h>
+#include <linux/delay.h>
+#include <linux/ioctl.h>
+#include <linux/vmalloc.h>
+#include <linux/module.h>
+
+#include <acpi/actbl.h>
+
+#define MAX_PCC_SUBSPACES	256
+#define PCCS_SS_SIG_MAGIC	0x50434300
+#define PCC_CMD_COMPLETE	0x1
+#define PCC_VERSION			"0.1"
+
+struct pcc_ss_desc {
+	struct acpi_pcct_subspace *pcc_ss_ptr;
+	raw_spinlock_t lock;
+};
+
+/* Array of pointers to Type 0 Generic Communication Subspace Structures */
+struct pcc_ss_desc pcc_ss_arr[MAX_PCC_SUBSPACES];
+
+/* Total number of subspaces detected in PCCT. */
+static int total_ss;
+
+/*
+ * PCC clients call this function to get a base address of their
+ * Communication channel
+ */
+int get_pcc_comm_channel(u32 ss_idx, u64 __iomem *addr, int *len)
+{
+	struct acpi_pcct_subspace *pcct_subspace = pcc_ss_arr[ss_idx].pcc_ss_ptr;
+
+	if (pcct_subspace) {
+		*addr = pcct_subspace->base_address;
+		*len = pcct_subspace->length;
+	} else
+		return -EINVAL;
+
+	pr_debug("base addr: %llx\n", pcct_subspace->base_address);
+
+	return 0;
+}
+
+/* Send PCC cmd on behalf of this (subspace id) PCC client */
+u16 send_pcc_cmd(u8 cmd, u8 sci, u32 ss_idx, u64 __iomem *base_addr)
+{
+	struct acpi_pcct_subspace *pcct_subspace = pcc_ss_arr[ss_idx].pcc_ss_ptr;
+	struct acpi_pcct_shared_memory *generic_comm_base =
+		(struct acpi_pcct_shared_memory *)base_addr;
+	struct acpi_generic_address doorbell;
+	u64 doorbell_preserve;
+	u64 doorbell_val;
+	u64 doorbell_write;
+
+	/* 
+	 * Min time in usec that OSPM is expected to wait
+	 * before sending the next PCC cmd.
+	 */
+	u16 cmd_delay = pcct_subspace->min_turnaround_time;
+
+	pr_debug("cmd: %d, ss_idx: %d, addr: %llx\n", cmd, ss_idx, (u64) base_addr);
+	if (!generic_comm_base) {
+		pr_err("No Generic Communication Channel provided.\n");
+		return -EINVAL;
+	}
+
+	raw_spin_lock(&pcc_ss_arr[ss_idx].lock);
+
+	/* Get doorbell details for this subspace. */
+	doorbell = pcct_subspace->doorbell_register;
+	doorbell_preserve = pcct_subspace->preserve_mask;
+	doorbell_write = pcct_subspace->write_mask;
+
+	/* Write to the shared comm region. */
+	iowrite16(cmd, &generic_comm_base->command);
+
+	/* Write Subspace MAGIC value so platform can identify destination. */
+	iowrite32((PCCS_SS_SIG_MAGIC | ss_idx), &generic_comm_base->signature);
+
+	/* Flip CMD COMPLETE bit */
+	iowrite16(0, &generic_comm_base->status);
+
+	/* Sync notification from OSPM to Platform. */
+	acpi_read(&doorbell_val, &doorbell);
+	acpi_write((doorbell_val & doorbell_preserve) | doorbell_write,
+			&doorbell);
+
+	/* Wait for Platform to consume. */
+	while (!(ioread16(&generic_comm_base->status) & PCC_CMD_COMPLETE))
+		udelay(cmd_delay);
+
+	raw_spin_unlock(&pcc_ss_arr[ss_idx].lock);
+
+	return generic_comm_base->status;
+}
+
+static int parse_pcc_subspace(struct acpi_subtable_header *header,
+		const unsigned long end)
+{
+	struct acpi_pcct_subspace *pcct_ss;
+
+	if (total_ss <= MAX_PCC_SUBSPACES) {
+		pcct_ss = (struct acpi_pcct_subspace*) header;
+
+		if (pcct_ss->header.type != ACPI_PCCT_TYPE_GENERIC_SUBSPACE) {
+			pr_err("Incorrect PCC Subspace type detected\n");
+			return -EINVAL;
+		}
+
+		pcc_ss_arr[total_ss].pcc_ss_ptr = pcct_ss;
+		pr_debug("(%s)PCCT base addr: %llx", __func__, pcct_ss->base_address);
+		raw_spin_lock_init(&pcc_ss_arr[total_ss].lock);
+
+		total_ss++;
+	} else {
+		pr_err("No more space for PCC subspaces.\n");
+		return -ENOSPC;
+	}
+
+	return 0;
+}
+
+static int __init pcc_probe(void)
+{
+	acpi_status status = AE_OK;
+	acpi_size pcct_tbl_header_size;
+	struct acpi_table_pcct *pcct_tbl;
+
+	/* Search for PCCT */
+	status = acpi_get_table_with_size(ACPI_SIG_PCCT, 0,
+			(struct acpi_table_header **)&pcct_tbl,
+			&pcct_tbl_header_size);
+
+	if (ACPI_SUCCESS(status) && !pcct_tbl) {
+		pr_warn("PCCT header not found.\n");
+		status = AE_NOT_FOUND;
+		goto out_err;
+	}
+
+	status = acpi_table_parse_entries(ACPI_SIG_PCCT,
+			sizeof(struct acpi_table_pcct), ACPI_PCCT_TYPE_GENERIC_SUBSPACE,
+			parse_pcc_subspace, MAX_PCC_SUBSPACES);
+
+	if (ACPI_SUCCESS(status))
+		pr_err("Error parsing PCC subspaces from PCCT\n");
+
+	pr_info("Detected %d PCC Subspaces\n", total_ss);
+
+out_err:
+	return (ACPI_SUCCESS(status) ? 1 : 0);
+}
+
+static int __init pcc_init(void)
+{
+	int ret;
+
+	if (acpi_disabled)
+		return -ENODEV;
+
+	/* Check if PCC support is available. */
+	ret = pcc_probe();
+
+	if (ret) {
+		pr_debug("PCC probe failed.\n");
+		return -EINVAL;
+	}
+
+	return ret;
+}
+device_initcall(pcc_init);
+
+
-- 
1.9.1

