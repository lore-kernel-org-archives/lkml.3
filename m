Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbaG3EWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 00:22:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:60792 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbaG3EWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 00:22:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,762,1400050800"; 
   d="scan'208";a="462977312"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Hanjun Guo <hanjun.guo@linaro.org>, Bob Moore <robert.moore@intel.com>
Subject: [PATCH 15/17] ACPICA/ARM: ACPI 5.1: Update for GTDT table changes.
Date: Wed, 30 Jul 2014 12:21:58 +0800
Message-Id: <a3f86a5075c565002cd4bed0befb7d167fa0f105.1406689494.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1406689493.git.lv.zheng@intel.com>
References: <cover.1406689493.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Nowicki <tomasz.nowicki@linaro.org>

New fields and new subtables. Tomasz Nowicki.
tomasz.nowicki@linaro.org

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 include/acpi/actbl3.h |   93 +++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 78 insertions(+), 15 deletions(-)

diff --git a/include/acpi/actbl3.h b/include/acpi/actbl3.h
index c2295cc..41ad964 100644
--- a/include/acpi/actbl3.h
+++ b/include/acpi/actbl3.h
@@ -241,33 +241,96 @@ struct acpi_s3pt_suspend {
 
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
+	u64 counter_block_addresss;
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
+	u64 counter_read_block_address;
+	u32 platform_timer_count;
+	u32 platform_timer_offset;
 };
 
-/* Values for Flags field above */
+/* Flag Definitions: Timer Block Physical Timers and Virtual timers */
+
+#define ACPI_GTDT_INTERRUPT_MODE        (1)
+#define ACPI_GTDT_INTERRUPT_POLARITY    (1<<1)
+#define ACPI_GTDT_ALWAYS_ON             (1<<2)
+
+/* Common GTDT subtable header */
+
+struct acpi_gtdt_header {
+	u8 type;
+	u16 length;
+};
+
+/* Values for GTDT subtable type above */
+
+enum acpi_gtdt_type {
+	ACPI_GTDT_TYPE_TIMER_BLOCK = 0,
+	ACPI_GTDT_TYPE_WATCHDOG = 1,
+	ACPI_GTDT_TYPE_RESERVED = 2	/* 2 and greater are reserved */
+};
 
-#define ACPI_GTDT_MAPPED_BLOCK_PRESENT      1
+/* GTDT Subtables, correspond to Type in struct acpi_gtdt_header */
+
+/* 0: Generic Timer Block */
+
+struct acpi_gtdt_timer_block {
+	struct acpi_gtdt_header header;
+	u8 reserved;
+	u64 block_address;
+	u32 timer_count;
+	u32 timer_offset;
+};
+
+/* Timer Sub-Structure, one per timer */
+
+struct acpi_gtdt_timer_entry {
+	u8 frame_number;
+	u8 reserved[3];
+	u64 base_address;
+	u64 el0_base_address;
+	u32 timer_interrupt;
+	u32 timer_flags;
+	u32 virtual_timer_interrupt;
+	u32 virtual_timer_flags;
+	u32 common_flags;
+};
+
+/* Flag Definitions: common_flags above */
+
+#define ACPI_GTDT_GT_IS_SECURE_TIMER    (1)
+#define ACPI_GTDT_GT_ALWAYS_ON          (1<<1)
+
+/* 1: SBSA Generic Watchdog Structure */
+
+struct acpi_gtdt_watchdog {
+	struct acpi_gtdt_header header;
+	u8 reserved;
+	u64 refresh_frame_address;
+	u64 control_frame_address;
+	u32 timer_interrupt;
+	u32 timer_flags;
+};
 
-/* Values for all "TimerFlags" fields above */
+/* Flag Definitions: timer_flags above */
 
-#define ACPI_GTDT_INTERRUPT_MODE            1
-#define ACPI_GTDT_INTERRUPT_POLARITY        2
+#define ACPI_GTDT_WATCHDOG_IRQ_MODE         (1)
+#define ACPI_GTDT_WATCHDOG_IRQ_POLARITY     (1<<1)
+#define ACPI_GTDT_WATCHDOG_SECURE           (1<<2)
 
 /*******************************************************************************
  *
-- 
1.7.10

