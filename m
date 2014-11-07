Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751173AbaKGAVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 19:21:21 -0500
Received: from mail-ig0-f202.google.com ([209.85.213.202]:56190 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaKGAVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 19:21:18 -0500
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: marc.zyngier@arm.com, mark.rutland@arm.com
Cc: lorenzo.pieralisi@arm.com, linux-kernel@vger.kernel.org,
        Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: [PATCH] arm64: kernel: Copy register_persistent_clock() to arm64 source subtree
Date: Thu,  6 Nov 2014 16:21:05 -0800
Message-Id: <1415319665-21701-1-git-send-email-anatol.pomozov@gmail.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows to port code that needs register_persistent_clock() to arm64

Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
---
 arch/arm64/include/asm/time.h | 17 +++++++++++++++++
 arch/arm64/kernel/time.c      | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)
 create mode 100644 arch/arm64/include/asm/time.h

diff --git a/arch/arm64/include/asm/time.h b/arch/arm64/include/asm/time.h
new file mode 100644
index 0000000..28015b8
--- /dev/null
+++ b/arch/arm64/include/asm/time.h
@@ -0,0 +1,17 @@
+/*
+ * Copyright (C) 2004 MontaVista Software, Inc.
+ * Copyright (C) 2014 The Chromium OS Authors.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __ASM_TIME_H
+#define __ASM_TIME_H
+
+struct timespec;
+typedef void (*clock_access_fn)(struct timespec *);
+extern int register_persistent_clock(clock_access_fn read_boot,
+		clock_access_fn read_persistent);
+
+#endif
diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
index 1a7125c..71a907e 100644
--- a/arch/arm64/kernel/time.c
+++ b/arch/arm64/kernel/time.c
@@ -40,6 +40,7 @@
 
 #include <asm/thread_info.h>
 #include <asm/stacktrace.h>
+#include <asm/time.h>
 
 #ifdef CONFIG_SMP
 unsigned long profile_pc(struct pt_regs *regs)
@@ -79,3 +80,39 @@ void __init time_init(void)
 	/* Calibrate the delay loop directly */
 	lpj_fine = arch_timer_rate / HZ;
 }
+
+static void dummy_clock_access(struct timespec *ts)
+{
+	ts->tv_sec = 0;
+	ts->tv_nsec = 0;
+}
+
+static clock_access_fn __read_persistent_clock = dummy_clock_access;
+static clock_access_fn __read_boot_clock = dummy_clock_access;
+
+void read_persistent_clock(struct timespec *ts)
+{
+	__read_persistent_clock(ts);
+}
+
+void read_boot_clock(struct timespec *ts)
+{
+	__read_boot_clock(ts);
+}
+
+int __init register_persistent_clock(clock_access_fn read_boot,
+				     clock_access_fn read_persistent)
+{
+	/* Only allow the clockaccess functions to be registered once */
+	if (__read_persistent_clock == dummy_clock_access &&
+	    __read_boot_clock == dummy_clock_access) {
+		if (read_boot)
+			__read_boot_clock = read_boot;
+		if (read_persistent)
+			__read_persistent_clock = read_persistent;
+
+		return 0;
+	}
+
+	return -EINVAL;
+}
-- 
2.1.0.rc2.206.gedb03e5

