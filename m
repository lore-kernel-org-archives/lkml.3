Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbaD3CES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:04:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:14184 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745AbaD3CEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:04:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,955,1389772800"; 
   d="scan'208";a="523496291"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 06/27] ACPICA: Add support for LPIT table.
Date: Wed, 30 Apr 2014 10:04:06 +0800
Message-Id: <0c5546de38a826b99da3049fa6611fa701a40d5a.1398817612.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1398817612.git.lv.zheng@intel.com>
References: <cover.1398817612.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Adds header, disassembler, table compiler, and template support
for the Low Power Idle Table (LPIT).
Note that the disassembler and table compiler are not shipped in
the kernel.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 include/acpi/actbl2.h |   65 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index c8adad9..6874261 100644
--- a/include/acpi/actbl2.h
+++ b/include/acpi/actbl2.h
@@ -70,6 +70,7 @@
 #define ACPI_SIG_HPET           "HPET"	/* High Precision Event Timer table */
 #define ACPI_SIG_IBFT           "IBFT"	/* iSCSI Boot Firmware Table */
 #define ACPI_SIG_IVRS           "IVRS"	/* I/O Virtualization Reporting Structure */
+#define ACPI_SIG_LPIT           "LPIT"	/* Low Power Idle Table */
 #define ACPI_SIG_MCFG           "MCFG"	/* PCI Memory Mapped Configuration table */
 #define ACPI_SIG_MCHI           "MCHI"	/* Management Controller Host Interface table */
 #define ACPI_SIG_MTMR           "MTMR"	/* MID Timer table */
@@ -820,6 +821,70 @@ struct acpi_ivrs_memory {
 
 /*******************************************************************************
  *
+ * LPIT - Low Power Idle Table
+ *
+ * Conforms to "ACPI Low Power Idle Table (LPIT) and _LPD Proposal (DRAFT)"
+ *
+ ******************************************************************************/
+
+struct acpi_table_lpit {
+	struct acpi_table_header header;	/* Common ACPI table header */
+};
+
+/* LPIT subtable header */
+
+struct acpi_lpit_header {
+	u32 type;		/* Subtable type */
+	u32 length;		/* Subtable length */
+	u16 unique_id;
+	u16 reserved;
+	u32 flags;
+};
+
+/* Values for subtable Type above */
+
+enum acpi_lpit_type {
+	ACPI_LPIT_TYPE_NATIVE_CSTATE = 0x00,
+	ACPI_LPIT_TYPE_SIMPLE_IO = 0x01
+};
+
+/* Masks for Flags field above  */
+
+#define ACPI_LPIT_STATE_DISABLED    (1)
+#define ACPI_LPIT_NO_COUNTER        (1<<1)
+
+/*
+ * LPIT subtables, correspond to Type in struct acpi_lpit_header
+ */
+
+/* 0x00: Native C-state instruction based LPI structure */
+
+struct acpi_lpit_native {
+	struct acpi_lpit_header header;
+	struct acpi_generic_address entry_trigger;
+	u32 residency;
+	u32 latency;
+	struct acpi_generic_address residency_counter;
+	u64 counter_frequency;
+};
+
+/* 0x01: Simple I/O based LPI structure */
+
+struct acpi_lpit_io {
+	struct acpi_lpit_header header;
+	struct acpi_generic_address entry_trigger;
+	u32 trigger_action;
+	u64 trigger_value;
+	u64 trigger_mask;
+	struct acpi_generic_address minimum_idle_state;
+	u32 residency;
+	u32 latency;
+	struct acpi_generic_address residency_counter;
+	u64 counter_frequency;
+};
+
+/*******************************************************************************
+ *
  * MCFG - PCI Memory Mapped Configuration table and sub-table
  *        Version 1
  *
-- 
1.7.10

