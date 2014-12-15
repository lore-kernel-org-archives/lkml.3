Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbaLOXbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 18:31:35 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54546 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaLOXbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 18:31:34 -0500
From: Mitchel Humpherys <mitchelh@codeaurora.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Elliott <elliott@hp.com>
Cc: Matt Wagantall <mattw@codeaurora.org>,
        Mitchel Humpherys <mitchelh@codeaurora.org>
Subject: [PATCH v9] iopoll: Introduce memory-mapped IO polling macros
Date: Mon, 15 Dec 2014 15:31:20 -0800
Message-Id: <1418686280-12972-1-git-send-email-mitchelh@codeaurora.org>
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
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Robert Elliott <elliott@hp.com>
Signed-off-by: Matt Wagantall <mattw@codeaurora.org>
Signed-off-by: Mitchel Humpherys <mitchelh@codeaurora.org>
---
v8..v9:
  - Added note in comments about max sleep time (Rob Elliott)

v7..v8:
  - sorted helper macros by size (b, w, l, q)
  - removed some of the more esoteric (or flat-out bogus) helper macros

This patch was originally part of a series [1] for adding support for IOMMU
address translations through an ARM SMMU hardware register.  The other
patch in the series (the one that actually uses these macros and implements
said hardware address translations) was Ack'd by the driver maintainer
there (Will Deacon) so I've pulled this patch out to avoid resending an
already Ack'd patch over and over again.

In short, please see [1] for previous discussion and the first user of
these macros.

Will also acked this patch in [2].  I didn't retain his Ack here because I
added to the macro comments.

[1] http://thread.gmane.org/gmane.linux.kernel.iommu/7140
[2] http://thread.gmane.org/gmane.linux.kernel.iommu/7449

---
 include/linux/iopoll.h | 140 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 140 insertions(+)
 create mode 100644 include/linux/iopoll.h

diff --git a/include/linux/iopoll.h b/include/linux/iopoll.h
new file mode 100644
index 000000000000..bd161dae2d40
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

