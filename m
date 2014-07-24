Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943AbaGXNAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:00:19 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:45517 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758922AbaGXNAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:00:12 -0400
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
Subject: [PATCH 3/3] ACPI / ACPICA: Add GTDT support updated by ACPI 5.1
Date: Thu, 24 Jul 2014 20:59:17 +0800
Message-Id: <1406206757-15512-4-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406206757-15512-1-git-send-email-hanjun.guo@linaro.org>
References: <1406206757-15512-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With ACPI 5.0, we got per-processor timer support in GTDT,
and ACPI 5.1 introduced the support for platform (memory-mapped)
timers: GT Block and SBSA watchdog timer, add the code needed
for the spec change.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 include/acpi/actbl3.h |   99 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 85 insertions(+), 14 deletions(-)

diff --git a/include/acpi/actbl3.h b/include/acpi/actbl3.h
index c2295cc..96c60cd 100644
--- a/include/acpi/actbl3.h
+++ b/include/acpi/actbl3.h
@@ -241,33 +241,104 @@ struct acpi_s3pt_suspend {
 
 /*******************************************************************************
  *
- * GTDT - Generic Timer Description Table (ACPI 5.0)
- *        Version 1
+ * GTDT - Generic Timer Description Table (ACPI 5.1)
+ *        Version 2
  *
  ******************************************************************************/
 
 struct acpi_table_gtdt {
 	struct acpi_table_header header;	/* Common ACPI table header */
-	u64 address;
-	u32 flags;
-	u32 secure_pl1_interrupt;
-	u32 secure_pl1_flags;
-	u32 non_secure_pl1_interrupt;
-	u32 non_secure_pl1_flags;
+	u64 cnt_control_base_address;
+	u32 reserved;
+	u32 secure_el1_interrupt;
+	u32 secure_el1_flags;
+	u32 non_secure_el1_interrupt;
+	u32 non_secure_el1_flags;
 	u32 virtual_timer_interrupt;
 	u32 virtual_timer_flags;
-	u32 non_secure_pl2_interrupt;
-	u32 non_secure_pl2_flags;
+	u32 non_secure_el2_interrupt;
+	u32 non_secure_el2_flags;
+	u64 cnt_read_base_address;
+	u32 platform_timer_count;
+	u32 platform_timer_offset;
 };
 
-/* Values for Flags field above */
-
-#define ACPI_GTDT_MAPPED_BLOCK_PRESENT      1
-
 /* Values for all "TimerFlags" fields above */
 
 #define ACPI_GTDT_INTERRUPT_MODE            1
 #define ACPI_GTDT_INTERRUPT_POLARITY        2
+#define ACPI_GTDT_ALWAYS_ON		    4
+
+/*
+ * GTDT Subtable header
+ */
+struct acpi_gtdt_header {
+	u8 type;
+	u16 length;
+};
+
+/* Values for GTDT subtable type for GTDT subtables above */
+
+enum acpi_gtdt_type {
+	ACPI_GTDT_TYPE_GT_BLOCK = 0,	/* memory-mapped generic timer */
+	ACPI_GTDT_TYPE_SBSA_GENERIC_WATCHDOG = 1,
+	ACPI_GTDT_TYPE_RESERVED = 2	/* 2 and greater are reserved */
+};
+
+/*
+ * GTDT Subtables, correspond to Type in struct acpi_gtdt_header
+ */
+
+/* 0: Generic Timer Block */
+
+struct acpi_gtdt_gt_block {
+	struct acpi_gtdt_header header;
+	u8 reserved;
+	u64 gt_block_address;
+	u32 gt_block_timer_count;	/* must be less than or equal to 8 */
+	u32 gt_block_timer_offset;
+};
+
+/* GT Block Timer Structure */
+
+struct acpi_gt_block_timer {
+	u8 gt_frame_number;
+	u8 reseved[3];
+	u64 cnt_base_address;
+	u64 cnt_el0_base_adress;
+	u32 physical_timer_interrupt;
+	u32 physical_timer_flags;
+	u32 vitual_timer_interrupt;
+	u32 vitual_timer_flags;
+	u32 timer_common_flags;
+};
+
+/* Flag Definitions: GT Block Physical Timers and Virtual timers */
+
+#define ACPI_GT_BLOCK_INTERRUPT_MODE		1
+#define ACPI_GT_BLOCK_INTERRUPT_POLARITY	2
+
+/* Flag Definitions: Common Flags */
+
+#define ACPI_GT_BLOCK_IS_SECURE_TIMER	1
+#define ACPI_GT_BLOCK_ALWAYS_ON		2
+
+/* 1: SBSA Generic Watchdog Structure */
+
+struct acpi_sbsa_generic_watchdog {
+	struct acpi_gtdt_header header;
+	u8 reserved;
+	u64 refresh_frame_address;
+	u64 control_frame_address;
+	u32 interrupt;
+	u32 flags;
+};
+
+/* Flag Definitions: SBSA Generic Watchdog */
+
+#define ACPI_SBSA_WATCHDOG_INTERRUPT_MODE	1
+#define ACPI_SBSA_WATCHDOG_INTERRUPT_POLARITY	2
+#define ACPI_SBSA_WATCHDOG_IS_SECURE_TIMER	4
 
 /*******************************************************************************
  *
-- 
1.7.9.5

