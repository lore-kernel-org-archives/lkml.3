Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbaACCPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 21:15:14 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:36344 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752742AbaACCLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 21:11:47 -0500
Message-Id: <20140103021145.957897267@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 02 Jan 2014 21:10:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 10/17] tracing/probes: Move symbol fetch method to kprobes
References: <20140103021021.238772653@goodmis.org>
Content-Disposition: inline; filename=0010-tracing-probes-Move-symbol-fetch-method-to-kprobes.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Move existing functions to trace_kprobe.c and add NULL entries to the
uprobes fetch type table.  I don't make them static since some generic
routines like update/free_XXX_fetch_param() require pointers to the
functions.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_kprobe.c | 59 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_probe.c  | 59 ---------------------------------------------
 kernel/trace/trace_probe.h  | 24 ++++++++++++++++++
 kernel/trace/trace_uprobe.c |  8 ++++++
 4 files changed, 91 insertions(+), 59 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 389f9e4..d2a4fd2 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -88,6 +88,51 @@ static int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs);
 static int kretprobe_dispatcher(struct kretprobe_instance *ri,
 				struct pt_regs *regs);
 
+/* Memory fetching by symbol */
+struct symbol_cache {
+	char		*symbol;
+	long		offset;
+	unsigned long	addr;
+};
+
+unsigned long update_symbol_cache(struct symbol_cache *sc)
+{
+	sc->addr = (unsigned long)kallsyms_lookup_name(sc->symbol);
+
+	if (sc->addr)
+		sc->addr += sc->offset;
+
+	return sc->addr;
+}
+
+void free_symbol_cache(struct symbol_cache *sc)
+{
+	kfree(sc->symbol);
+	kfree(sc);
+}
+
+struct symbol_cache *alloc_symbol_cache(const char *sym, long offset)
+{
+	struct symbol_cache *sc;
+
+	if (!sym || strlen(sym) == 0)
+		return NULL;
+
+	sc = kzalloc(sizeof(struct symbol_cache), GFP_KERNEL);
+	if (!sc)
+		return NULL;
+
+	sc->symbol = kstrdup(sym, GFP_KERNEL);
+	if (!sc->symbol) {
+		kfree(sc);
+		return NULL;
+	}
+	sc->offset = offset;
+	update_symbol_cache(sc);
+
+	return sc;
+}
+
 /*
  * Kprobes-specific fetch functions
  */
@@ -103,6 +148,20 @@ DEFINE_BASIC_FETCH_FUNCS(stack)
 #define fetch_stack_string	NULL
 #define fetch_stack_string_size	NULL
 
+#define DEFINE_FETCH_symbol(type)					\
+__kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,	\
+					  void *data, void *dest)	\
+{									\
+	struct symbol_cache *sc = data;					\
+	if (sc->addr)							\
+		fetch_memory_##type(regs, (void *)sc->addr, dest);	\
+	else								\
+		*(type *)dest = 0;					\
+}
+DEFINE_BASIC_FETCH_FUNCS(symbol)
+DEFINE_FETCH_symbol(string)
+DEFINE_FETCH_symbol(string_size)
+
 /* Fetch type information table */
 const struct fetch_type kprobes_fetch_type_table[] = {
 	/* Special types */
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 77aa7d1..a31ad47 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -180,65 +180,6 @@ __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
 		*(u32 *)dest = len;
 }
 
-/* Memory fetching by symbol */
-struct symbol_cache {
-	char		*symbol;
-	long		offset;
-	unsigned long	addr;
-};
-
-static unsigned long update_symbol_cache(struct symbol_cache *sc)
-{
-	sc->addr = (unsigned long)kallsyms_lookup_name(sc->symbol);
-
-	if (sc->addr)
-		sc->addr += sc->offset;
-
-	return sc->addr;
-}
-
-static void free_symbol_cache(struct symbol_cache *sc)
-{
-	kfree(sc->symbol);
-	kfree(sc);
-}
-
-static struct symbol_cache *alloc_symbol_cache(const char *sym, long offset)
-{
-	struct symbol_cache *sc;
-
-	if (!sym || strlen(sym) == 0)
-		return NULL;
-
-	sc = kzalloc(sizeof(struct symbol_cache), GFP_KERNEL);
-	if (!sc)
-		return NULL;
-
-	sc->symbol = kstrdup(sym, GFP_KERNEL);
-	if (!sc->symbol) {
-		kfree(sc);
-		return NULL;
-	}
-	sc->offset = offset;
-	update_symbol_cache(sc);
-
-	return sc;
-}
-
-#define DEFINE_FETCH_symbol(type)					\
-__kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,	\
-					  void *data, void *dest)	\
-{									\
-	struct symbol_cache *sc = data;					\
-	if (sc->addr)							\
-		fetch_memory_##type(regs, (void *)sc->addr, dest);	\
-	else								\
-		*(type *)dest = 0;					\
-}
-DEFINE_BASIC_FETCH_FUNCS(symbol)
-DEFINE_FETCH_symbol(string)
-DEFINE_FETCH_symbol(string_size)
-
 /* Dereference memory access function */
 struct deref_fetch_param {
 	struct fetch_param	orig;
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 8211dd6..8be8455 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -239,6 +239,30 @@ ASSIGN_FETCH_FUNC(bitfield, ftype),			\
 extern __weak const struct fetch_type kprobes_fetch_type_table[];
 extern __weak const struct fetch_type uprobes_fetch_type_table[];
 
+#ifdef CONFIG_KPROBE_EVENT
+struct symbol_cache;
+unsigned long update_symbol_cache(struct symbol_cache *sc);
+void free_symbol_cache(struct symbol_cache *sc);
+struct symbol_cache *alloc_symbol_cache(const char *sym, long offset);
+#else
+struct symbol_cache {
+};
+static inline unsigned long __used update_symbol_cache(struct symbol_cache *sc)
+{
+	return 0;
+}
+
+static inline void __used free_symbol_cache(struct symbol_cache *sc)
+{
+}
+
+static inline struct symbol_cache * __used
+alloc_symbol_cache(const char *sym, long offset)
+{
+	return NULL;
+}
+#endif /* CONFIG_KPROBE_EVENT */
+
 struct probe_arg {
 	struct fetch_param	fetch;
 	struct fetch_param	fetch_size;
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 5395d37..24ef6a3 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -115,6 +115,14 @@ DEFINE_BASIC_FETCH_FUNCS(stack)
 #define fetch_stack_string_size	NULL
 
 
+/* uprobes do not support symbol fetch methods */
+#define fetch_symbol_u8			NULL
+#define fetch_symbol_u16		NULL
+#define fetch_symbol_u32		NULL
+#define fetch_symbol_u64		NULL
+#define fetch_symbol_string		NULL
+#define fetch_symbol_string_size	NULL
+
 /* Fetch type information table */
 const struct fetch_type uprobes_fetch_type_table[] = {
 	/* Special types */
-- 
1.8.4.3


