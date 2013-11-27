Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab3K0GWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 01:22:30 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43557 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab3K0GUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 01:20:12 -0500
X-AuditID: 9c930197-b7caaae000001cef-b2-52958f17bbbd
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 10/17] tracing/probes: Move 'symbol' fetch method to kprobes
Date: Wed, 27 Nov 2013 15:19:56 +0900
Message-Id: <1385533203-10014-11-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
References: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Move existing functions to trace_kprobe.c and add NULL entries to the
uprobes fetch type table.  I don't make them static since some generic
routines like update/free_XXX_fetch_param() require pointers to the
functions.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
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
index 03a79db63a3f..aa0ef55316ff 100644
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
index 6d2d1c0b9a26..649e02ac4cf2 100644
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
index a2dfa7e048dc..006e3bab37dd 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -236,6 +236,30 @@ ASSIGN_FETCH_FUNC(bitfield, ftype),			\
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
+static unsigned long __used update_symbol_cache(struct symbol_cache *sc)
+{
+	return 0;
+}
+
+static void __used free_symbol_cache(struct symbol_cache *sc)
+{
+}
+
+static struct symbol_cache * __used
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
index 7829bcdb020c..3fcc5169391b 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -115,6 +115,14 @@ DEFINE_BASIC_FETCH_FUNCS(stack)
 #define fetch_stack_string_size	NULL
 
 
+/* uprobes don't support symbol fetch methods */
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
1.7.11.7

