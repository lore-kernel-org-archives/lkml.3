Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbaD3PlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 11:41:09 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:58561 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759061AbaD3PlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 11:41:06 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Travis <travis@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>,
        Hedi Berriche <hedi@sgi.com>, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com
Subject: [PATCH 1/3] kdb: Add framework to display sequence files
Date: Wed, 30 Apr 2014 16:40:25 +0100
Message-Id: <1398872427-18435-2-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398872427-18435-1-git-send-email-daniel.thompson@linaro.org>
References: <1398781841-15152-1-git-send-email-daniel.thompson@linaro.org>
 <1398872427-18435-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lots of useful information about the system is held in pseudo filesystems
and presented using the seq_file mechanism. Unfortunately during both boot
up and kernel panic (both good times to break out kdb) it is difficult to
examine these files. This patch introduces a means to display sequence
files via kdb.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 include/linux/kdb.h       |  5 +++++
 kernel/debug/kdb/kdb_io.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index 290db12..fb46dd4 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -25,6 +25,7 @@ typedef int (*kdb_func_t)(int, const char **);
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/atomic.h>
+#include <linux/seq_file.h>
 
 #define KDB_POLL_FUNC_MAX	5
 extern int kdb_poll_idx;
@@ -117,6 +118,8 @@ extern __printf(1, 0) int vkdb_printf(const char *fmt, va_list args);
 extern __printf(1, 2) int kdb_printf(const char *, ...);
 typedef __printf(1, 2) int (*kdb_printf_t)(const char *, ...);
 
+extern int kdb_print_seq_file(const struct seq_operations *ops);
+
 extern void kdb_init(int level);
 
 /* Access to kdb specific polling devices */
@@ -151,6 +154,8 @@ extern int kdb_register_repeat(char *, kdb_func_t, char *, char *,
 extern int kdb_unregister(char *);
 #else /* ! CONFIG_KGDB_KDB */
 static inline __printf(1, 2) int kdb_printf(const char *fmt, ...) { return 0; }
+static inline int
+kdb_print_seq_file(const struct seq_operations *ops) { return 0; }
 static inline void kdb_init(int level) {}
 static inline int kdb_register(char *cmd, kdb_func_t func, char *usage,
 			       char *help, short minlen) { return 0; }
diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 14ff484..c68c223 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -850,3 +850,54 @@ int kdb_printf(const char *fmt, ...)
 	return r;
 }
 EXPORT_SYMBOL_GPL(kdb_printf);
+
+/*
+ * Display a seq_file on the kdb console.
+ */
+
+static int __kdb_print_seq_file(struct seq_file *m, void *v)
+{
+	int i, res;
+
+	res = m->op->show(m, v);
+	if (0 != res)
+		return KDB_BADLENGTH;
+
+	for (i = 0; i < m->count && !KDB_FLAG(CMD_INTERRUPT); i++)
+		kdb_printf("%c", m->buf[i]);
+	m->count = 0;
+
+	return 0;
+}
+
+int kdb_print_seq_file(const struct seq_operations *ops)
+{
+	static char seq_buf[4096];
+	static DEFINE_SPINLOCK(seq_buf_lock);
+	unsigned long flags;
+	struct seq_file m = {
+		.buf = seq_buf,
+		.size = sizeof(seq_buf),
+		/* .lock is deliberately uninitialized to help reveal
+		 * unsupportable show methods
+		 */
+		.op = ops,
+	};
+	loff_t pos = 0;
+	void *v;
+	int res = 0;
+
+	v = ops->start(&m, &pos);
+	while (v) {
+		spin_lock_irqsave(&seq_buf_lock, flags);
+		res = __kdb_print_seq_file(&m, v);
+		spin_unlock_irqrestore(&seq_buf_lock, flags);
+		if (res != 0 || KDB_FLAG(CMD_INTERRUPT))
+			break;
+
+		v = ops->next(&m, v, &pos);
+	}
+	ops->stop(&m, v);
+
+	return res;
+}
-- 
1.9.0

