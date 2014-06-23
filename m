Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbaFWNbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:31:37 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60774 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754860AbaFWN3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:29:39 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 01/21] ftrace: Add function to find fentry of function
Date: Mon, 23 Jun 2014 15:29:15 +0200
Message-Id: <1403530175-29217-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for kGraft to find a fentry location to be "ftraced".
We use this to find a place where to jump to a new/old code location.

Note that we use a O(n) algorithm to assert correctness (and
simplicity). This algorithm can be further optimized to be O(log(n))
using binary search, but care has to be taken about the first member
of each entries page. I.e. we cannot use 1:1 what is in
ftrace_location_range etc.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 include/linux/ftrace.h |  1 +
 kernel/trace/ftrace.c  | 30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 404a686a3644..c142816c2801 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -295,6 +295,7 @@ extern void
 unregister_ftrace_function_probe_func(char *glob, struct ftrace_probe_ops *ops);
 extern void unregister_ftrace_function_probe_all(char *glob);
 
+extern unsigned long ftrace_function_to_fentry(unsigned long addr);
 extern int ftrace_text_reserved(const void *start, const void *end);
 
 extern int ftrace_nr_registered_ops(void);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5b372e3ed675..f4da441c0125 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1422,6 +1422,36 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip, void *regs)
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
+
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
2.0.0

