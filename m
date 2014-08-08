Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132AbaHHPU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:20:58 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:39680 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757111AbaHHPU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:20:57 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Luis R. Rodriguez" <mcgrof@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] printk: Don't bother using LOG_CPU_MAX_BUF_SHIFT on !SMP
Date: Fri,  8 Aug 2014 17:20:44 +0200
Message-Id: <1407511244-5332-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When configuring a uniprocessor kernel, don't bother the user with an
irrelevant LOG_CPU_MAX_BUF_SHIFT question, and don't build the unused
code.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 init/Kconfig           | 1 +
 kernel/printk/printk.c | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index a5f8bc426f7c..aa6f87c04728 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -822,6 +822,7 @@ config LOG_BUF_SHIFT
 
 config LOG_CPU_MAX_BUF_SHIFT
 	int "CPU kernel log buffer size contribution (13 => 8 KB, 17 => 128KB)"
+	depends on SMP
 	range 0 21
 	default 12 if !BASE_SMALL
 	default 0 if BASE_SMALL
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index de1a6bb6861d..d5dc94028166 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -267,7 +267,6 @@ static u32 clear_idx;
 #define LOG_ALIGN __alignof__(struct printk_log)
 #endif
 #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
-#define __LOG_CPU_MAX_BUF_LEN (1 << CONFIG_LOG_CPU_MAX_BUF_SHIFT)
 static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
@@ -846,6 +845,9 @@ static int __init log_buf_len_setup(char *str)
 }
 early_param("log_buf_len", log_buf_len_setup);
 
+#ifdef CONFIG_SMP
+#define __LOG_CPU_MAX_BUF_LEN (1 << CONFIG_LOG_CPU_MAX_BUF_SHIFT)
+
 static void __init log_buf_add_cpu(void)
 {
 	unsigned int cpu_extra;
@@ -872,6 +874,9 @@ static void __init log_buf_add_cpu(void)
 
 	log_buf_len_update(cpu_extra + __LOG_BUF_LEN);
 }
+#else /* !CONFIG_SMP */
+static inline void log_buf_add_cpu(void) {}
+#endif /* CONFIG_SMP */
 
 void __init setup_log_buf(int early)
 {
-- 
1.9.1

