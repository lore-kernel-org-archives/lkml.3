Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaKFVzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:55:44 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57085 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaKFVzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:55:42 -0500
From: Mitchel Humpherys <mitchelh@codeaurora.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Matt Wagantall <mattw@codeaurora.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Mitchel Humpherys <mitchelh@codeaurora.org>
Subject: [PATCH RESEND v8] iopoll: Introduce memory-mapped IO polling macros
Date: Thu,  6 Nov 2014 13:55:22 -0800
Message-Id: <1415310922-23997-1-git-send-email-mitchelh@codeaurora.org>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Wagantall <mattw@codeaurora.org>

It is sometimes necessary to poll a memory-mapped register until its value
satisfies some condition. Introduce a family of convenience macros that do
this. Tight-looping, sleeping, and timing out can all be accomplished using
these macros.

Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Matt Wagantall <mattw@codeaurora.org>
Signed-off-by: Mitchel Humpherys <mitchelh@codeaurora.org>
---
Changes since v7:
  - sorted helper macros by size (b, w, l, q)
  - removed some of the more esoteric (or flat-out bogus) helper macros
---
 include/linux/iopoll.h | 140 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 140 insertions(+)
 create mode 100644 include/linux/iopoll.h

diff --git a/include/linux/iopoll.h b/include/linux/iopoll.h
new file mode 100644
index 0000000000..bd161dae2d
--- /dev/null
+++ b/include/linux/iopoll.h
@@ -0,0 +1,140 @@
+/*
+ * Copyright (c) 2012-2014 The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _LINUX_IOPOLL_H
+#define _LINUX_IOPOLL_H
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/hrtimer.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/io.h>
+
+/**
+ * readx_poll_timeout - Periodically poll an address until a condition is met or a timeout occurs
+ * @op: accessor function (takes @addr as its only argument)
+ * @addr: Address to poll
+ * @val: Variable to read the value into
+ * @cond: Break condition (usually involving @val)
+ * @sleep_us: Maximum time to sleep between reads in us (0 tight-loops)
+ * @timeout_us: Timeout in us, 0 means never timeout
+ *
+ * Returns 0 on success and -ETIMEDOUT upon a timeout. In either
+ * case, the last read value at @addr is stored in @val. Must not
+ * be called from atomic context if sleep_us or timeout_us are used.
+ *
+ * When available, you'll probably want to use one of the specialized
+ * macros defined below rather than this macro directly.
+ */
+#define readx_poll_timeout(op, addr, val, cond, sleep_us, timeout_us)	\
+({ \
+	ktime_t timeout = ktime_add_us(ktime_get(), timeout_us); \
+	might_sleep_if(sleep_us); \
+	for (;;) { \
+		(val) = op(addr); \
+		if (cond) \
+			break; \
+		if (timeout_us && ktime_compare(ktime_get(), timeout) > 0) { \
+			(val) = op(addr); \
+			break; \
+		} \
+		if (sleep_us) \
+			usleep_range((sleep_us >> 2) + 1, sleep_us); \
+	} \
+	(cond) ? 0 : -ETIMEDOUT; \
+})
+
+/**
+ * readx_poll_timeout_atomic - Periodically poll an address until a condition is met or a timeout occurs
+ * @op: accessor function (takes @addr as its only argument)
+ * @addr: Address to poll
+ * @val: Variable to read the value into
+ * @cond: Break condition (usually involving @val)
+ * @delay_us: Time to udelay between reads in us (0 tight-loops)
+ * @timeout_us: Timeout in us, 0 means never timeout
+ *
+ * Returns 0 on success and -ETIMEDOUT upon a timeout. In either
+ * case, the last read value at @addr is stored in @val.
+ *
+ * When available, you'll probably want to use one of the specialized
+ * macros defined below rather than this macro directly.
+ */
+#define readx_poll_timeout_atomic(op, addr, val, cond, delay_us, timeout_us) \
+({ \
+	ktime_t timeout = ktime_add_us(ktime_get(), timeout_us); \
+	for (;;) { \
+		(val) = op(addr); \
+		if (cond) \
+			break; \
+		if (timeout_us && ktime_compare(ktime_get(), timeout) > 0) { \
+			(val) = op(addr); \
+			break; \
+		} \
+		if (delay_us) \
+			udelay(delay_us);	\
+	} \
+	(cond) ? 0 : -ETIMEDOUT; \
+})
+
+
+#define readb_poll_timeout(addr, val, cond, delay_us, timeout_us) \
+	readx_poll_timeout(readb, addr, val, cond, delay_us, timeout_us)
+
+#define readb_poll_timeout_atomic(addr, val, cond, delay_us, timeout_us) \
+	readx_poll_timeout_atomic(readb, addr, val, cond, delay_us, timeout_us)
+
+#define readw_poll_timeout(addr, val, cond, delay_us, timeout_us) \
+	readx_poll_timeout(readw, addr, val, cond, delay_us, timeout_us)
+
+#define readw_poll_timeout_atomic(addr, val, cond, delay_us, timeout_us) \
+	readx_poll_timeout_atomic(readw, addr, val, cond, delay_us, timeout_us)
+
+#define readl_poll_timeout(addr, val, cond, delay_us, timeout_us) \
+	readx_poll_timeout(readl, addr, val, cond, delay_us, timeout_us)
+
+#define readl_poll_timeout_atomic(addr, val, cond, delay_us, timeout_us) \
+	readx_poll_timeout_atomic(readl, addr, val, cond, delay_us, timeout_us)
+
+#define readq_poll_timeout(addr, val, cond, delay_us, timeout_us) \
+	readx_poll_timeout(readq, addr, val, cond, delay_us, timeout_us)
+
+#define readq_poll_timeout_atomic(addr, val, cond, delay_us, timeout_us) \
+	readx_poll_timeout_atomic(readq, addr, val, cond, delay_us, timeout_us)
+
+#define readb_relaxed_poll_timeout(addr, val, cond, delay_us, timeout_us) \
+	readx_poll_timeout(readb_relaxed, addr, val, cond, delay_us, timeout_us)
+
+#define readb_relaxed_poll_timeout_atomic(addr, val, cond, delay_us, timeout_us) \
+	readx_poll_timeout_atomic(readb_relaxed, addr, val, cond, delay_us, timeout_us)
+
+#define readw_relaxed_poll_timeout(addr, val, cond, delay_us, timeout_us) \
+	readx_poll_timeout(readw_relaxed, addr, val, cond, delay_us, timeout_us)
+
+#define readw_relaxed_poll_timeout_atomic(addr, val, cond, delay_us, timeout_us) \
+	readx_poll_timeout_atomic(readw_relaxed, addr, val, cond, delay_us, timeout_us)
+
+#define readl_relaxed_poll_timeout(addr, val, cond, delay_us, timeout_us) \
+	readx_poll_timeout(readl_relaxed, addr, val, cond, delay_us, timeout_us)
+
+#define readl_relaxed_poll_timeout_atomic(addr, val, cond, delay_us, timeout_us) \
+	readx_poll_timeout_atomic(readl_relaxed, addr, val, cond, delay_us, timeout_us)
+
+#define readq_relaxed_poll_timeout(addr, val, cond, delay_us, timeout_us) \
+	readx_poll_timeout(readq_relaxed, addr, val, cond, delay_us, timeout_us)
+
+#define readq_relaxed_poll_timeout_atomic(addr, val, cond, delay_us, timeout_us) \
+	readx_poll_timeout_atomic(readq_relaxed, addr, val, cond, delay_us, timeout_us)
+
+#endif /* _LINUX_IOPOLL_H */
-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

