Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaEVWHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 18:07:46 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38165 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaEVWHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 18:07:45 -0400
From: Christopher Covington <cov@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Christopher Covington <cov@codeaurora.org>
Subject: [PATCH v2] ARM: tty: Move HVC DCC assembly to arch/arm
Date: Thu, 22 May 2014 18:07:18 -0400
Message-Id: <1400796438-6911-1-git-send-email-cov@codeaurora.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1382120064-2459-1-git-send-email-cov@codeaurora.org>
References: <1382120064-2459-1-git-send-email-cov@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put architecture-specific assembly code where it belongs,
allowing for support of additional architectures such as arm64 in
the future.

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 arch/arm/include/asm/dcc.h | 41 +++++++++++++++++++++++++++++++++++++++++
 drivers/tty/hvc/hvc_dcc.c  | 42 ++----------------------------------------
 2 files changed, 43 insertions(+), 40 deletions(-)
 create mode 100644 arch/arm/include/asm/dcc.h

diff --git a/arch/arm/include/asm/dcc.h b/arch/arm/include/asm/dcc.h
new file mode 100644
index 0000000..b74899d
--- /dev/null
+++ b/arch/arm/include/asm/dcc.h
@@ -0,0 +1,41 @@
+/* Copyright (c) 2010, 2014 The Linux Foundation. All rights reserved.
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
+	asm volatile("mrc p14, 0, %0, c0, c1, 0	@ read comms ctrl reg"
+		: "=r" (__ret) : : "cc");
+
+	return __ret;
+}
+
+static inline char __dcc_getchar(void)
+{
+	char __c;
+
+	asm volatile("mrc p14, 0, %0, c0, c5, 0	@ read comms data reg"
+		: "=r" (__c));
+	isb();
+
+	return __c;
+}
+
+static inline void __dcc_putchar(char c)
+{
+	asm volatile("mcr p14, 0, %0, c0, c5, 0	@ write a char"
+		: /* no output register */
+		: "r" (c));
+	isb();
+}
diff --git a/drivers/tty/hvc/hvc_dcc.c b/drivers/tty/hvc/hvc_dcc.c
index 44fbeba..c3357b7 100644
--- a/drivers/tty/hvc/hvc_dcc.c
+++ b/drivers/tty/hvc/hvc_dcc.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+/* Copyright (c) 2010, 2014 The Linux Foundation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
@@ -8,20 +8,11 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  */
 
-#include <linux/console.h>
-#include <linux/delay.h>
-#include <linux/err.h>
 #include <linux/init.h>
-#include <linux/moduleparam.h>
-#include <linux/types.h>
 
+#include <asm/dcc.h>
 #include <asm/processor.h>
 
 #include "hvc_console.h"
@@ -30,35 +21,6 @@
 #define DCC_STATUS_RX		(1 << 30)
 #define DCC_STATUS_TX		(1 << 29)
 
-static inline u32 __dcc_getstatus(void)
-{
-	u32 __ret;
-	asm volatile("mrc p14, 0, %0, c0, c1, 0	@ read comms ctrl reg"
-		: "=r" (__ret) : : "cc");
-
-	return __ret;
-}
-
-
-static inline char __dcc_getchar(void)
-{
-	char __c;
-
-	asm volatile("mrc p14, 0, %0, c0, c5, 0	@ read comms data reg"
-		: "=r" (__c));
-	isb();
-
-	return __c;
-}
-
-static inline void __dcc_putchar(char c)
-{
-	asm volatile("mcr p14, 0, %0, c0, c5, 0	@ write a char"
-		: /* no output register */
-		: "r" (c));
-	isb();
-}
-
 static int hvc_dcc_put_chars(uint32_t vt, const char *buf, int count)
 {
 	int i;
-- 
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by the Linux Foundation.

