Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbaAQNA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 08:00:26 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:61142 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaAQNAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 08:00:20 -0500
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
        Charles.Garcia-Tobin@arm.com, Hanjun Guo <hanjun.guo@linaro.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH 19/20] clocksource / ACPI: Introduce clocksource_acpi_init() using CLOCKSOURCE_ACPI_DECLARE
Date: Fri, 17 Jan 2014 20:25:13 +0800
Message-Id: <1389961514-13562-20-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_table_parse() will find table with table id and run handler
on it. So we use CLOCKSOURCE_ACPI_DECLARE to decalare timer tables
and glue its handler, then initialize them in clocksource_acpi_init().

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/clocksource/Makefile         |    1 +
 drivers/clocksource/arm_arch_timer.c |    1 +
 drivers/clocksource/clksrc-acpi.c    |   36 ++++++++++++++++++++++++++++++++++
 include/linux/clocksource.h          |    3 +++
 4 files changed, 41 insertions(+)
 create mode 100644 drivers/clocksource/clksrc-acpi.c

diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 33621ef..2304c99 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_CLKSRC_OF)	+= clksrc-of.o
+obj-$(CONFIG_ACPI)	+= clksrc-acpi.o
 obj-$(CONFIG_ATMEL_TCB_CLKSRC)	+= tcb_clksrc.o
 obj-$(CONFIG_X86_CYCLONE_TIMER)	+= cyclone.o
 obj-$(CONFIG_X86_PM_TIMER)	+= acpi_pm.o
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 1fa5f67..6489037 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -738,6 +738,7 @@ void __init arch_timer_acpi_init(struct acpi_table_header *table)
 	arch_timers_present |= ARCH_CP15_TIMER;
 	arch_timer_init();
 }
+CLOCKSOURCE_ACPI_DECLARE(armv8_arch_timer, "GTDT", arch_timer_acpi_init);
 #endif
 
 static void __init arch_timer_mem_init(struct device_node *np)
diff --git a/drivers/clocksource/clksrc-acpi.c b/drivers/clocksource/clksrc-acpi.c
new file mode 100644
index 0000000..41efc83
--- /dev/null
+++ b/drivers/clocksource/clksrc-acpi.c
@@ -0,0 +1,36 @@
+/*
+ * Copyright (c) 2014, Hanjun Guo <hanjun.guo@linaro.org>
+ * Copyright (c) 2014, Amit Daniel Kachhap <amit.daniel@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/init.h>
+#include <linux/acpi.h>
+#include <linux/clocksource.h>
+
+extern struct acpi_device_id __clksrc_acpi_table[];
+
+static const struct acpi_device_id __clksrc_acpi_table_sentinel
+	__used __section(__clksrc_acpi_table_end);
+
+void __init clocksource_acpi_init(void)
+{
+	const struct acpi_device_id *id;
+	acpi_tbl_table_handler init_func;
+
+	for (id = __clksrc_acpi_table; id->id[0]; id++) {
+		init_func = (acpi_tbl_table_handler)id->driver_data;
+		acpi_table_parse(id->id, init_func);
+	}
+}
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 1d500cf..9bee8b3 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -361,12 +361,15 @@ static inline void clocksource_of_init(void) {}
 #endif
 
 #ifdef CONFIG_ACPI
+extern void clocksource_acpi_init(void);
+
 #define CLOCKSOURCE_ACPI_DECLARE(name, compat, fn)			\
 	static const struct acpi_device_id __clksrc_acpi_table_##name	\
 		__used __section(__clksrc_acpi_table)			\
 		 = { .id = compat,				\
 		     .driver_data = (kernel_ulong_t)fn }
 #else
+static inline void clocksource_acpi_init(void) { return; }
 #define CLOCKSOURCE_ACPI_DECLARE(name, compat, fn)
 #endif
 
-- 
1.7.9.5

