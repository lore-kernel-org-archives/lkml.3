Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322AbaD3Oef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:34:35 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52347 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759217AbaD3Oav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:30:51 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [RFC 01/16] ftrace: Add function to find fentry of function
Date: Wed, 30 Apr 2014 16:30:34 +0200
Message-Id: <1398868249-26169-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for kgr to find fentry location to be "ftraced". We use
this to find a place where to jump to a new/old code location.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 include/linux/ftrace.h |  1 +
 kernel/trace/ftrace.c  | 29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index ae9504b4b67d..8b447493b6a5 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -299,6 +299,7 @@ extern void
 unregister_ftrace_function_probe_func(char *glob, struct ftrace_probe_ops *ops);
 extern void unregister_ftrace_function_probe_all(char *glob);
 
+extern unsigned long ftrace_function_to_fentry(unsigned long addr);
 extern int ftrace_text_reserved(const void *start, const void *end);
 
 extern int ftrace_nr_registered_ops(void);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4a54a25afa2f..9968695cdcf9 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1495,6 +1495,35 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip, void *regs)
 		}				\
 	}
 
+/**
+ * ftrace_function_to_fentry -- lookup fentry location for a function
+ * @addr: function address to find a fentry in
+ *
+ * Perform a lookup in a list of fentry callsites to find one that fits a
+ * specified function @addr. It returns the corresponding fentry callsite or
+ * zero on failure.
+ */
+unsigned long ftrace_function_to_fentry(unsigned long addr)
+{
+	const struct dyn_ftrace *rec;
+	const struct ftrace_page *pg;
+	unsigned long ret = 0;
+
+	mutex_lock(&ftrace_lock);
+	do_for_each_ftrace_rec(pg, rec) {
+		unsigned long off;
+		if (!kallsyms_lookup_size_offset(rec->ip, NULL, &off))
+			continue;
+		if (addr + off == rec->ip) {
+			ret = rec->ip;
+			goto end;
+		}
+	} while_for_each_ftrace_rec()
+end:
+	mutex_unlock(&ftrace_lock);
+
+	return ret;
+}
 
 static int ftrace_cmp_recs(const void *a, const void *b)
 {
-- 
1.9.2

