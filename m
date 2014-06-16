Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaFPX6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 19:58:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54768 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaFPX6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 19:58:30 -0400
From: Abhimanyu Kapur <abhimany@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        will.deacon@arm.com, catalin.marinas@arm.com
Subject: [PATCH] ARM64: TTY: hvc_dcc: Add support for ARM64 dcc
Date: Mon, 16 Jun 2014 15:29:38 -0700
Message-Id: <1402957778-13830-1-git-send-email-abhimany@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for debug communications channel based
hvc console for arm64 cpus.

Signed-off-by: Abhimanyu Kapur <abhimany@codeaurora.org>
---
 arch/arm64/include/asm/dcc.h | 41 +++++++++++++++++++++++++++++++++++++++++
 drivers/tty/hvc/Kconfig      |  2 +-
 2 files changed, 42 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/dcc.h

diff --git a/arch/arm64/include/asm/dcc.h b/arch/arm64/include/asm/dcc.h
new file mode 100644
index 0000000..ef74324
--- /dev/null
+++ b/arch/arm64/include/asm/dcc.h
@@ -0,0 +1,41 @@
+/* Copyright (c) 2014 The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <asm/barrier.h>
+
+static inline u32 __dcc_getstatus(void)
+{
+	u32 __ret;
+
+	asm volatile("mrs %0, mdccsr_el0" : "=r" (__ret)
+			: : "cc");
+
+	return __ret;
+}
+
+static inline char __dcc_getchar(void)
+{
+	char __c;
+
+	asm volatile("mrs %0, dbgdtrrx_el0" : "=r" (__c));
+	isb();
+
+	return __c;
+}
+
+static inline void __dcc_putchar(char c)
+{
+	asm volatile("msr dbgdtrtx_el0, %0"
+			: /* No output register */
+			: "r" (c));
+	isb();
+}
diff --git a/drivers/tty/hvc/Kconfig b/drivers/tty/hvc/Kconfig
index 8902f9b..02051a1 100644
--- a/drivers/tty/hvc/Kconfig
+++ b/drivers/tty/hvc/Kconfig
@@ -88,7 +88,7 @@ config HVC_UDBG
 
 config HVC_DCC
        bool "ARM JTAG DCC console"
-       depends on ARM
+       depends on ARM || ARM64
        select HVC_DRIVER
        help
          This console uses the JTAG DCC on ARM to create a console under the HVC
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

