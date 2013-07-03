Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724Ab3GCMfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:35:53 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:50635 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100Ab3GCMfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:35:50 -0400
X-AuditID: 9c93017e-b7c04ae00000295f-eb-51d41aa4c2a5
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hyeoncheol Lee <cheol.lee@lge.com>, LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 02/12] tracing/kprobes: Add fetch{,_size} member into symbol and deref fetch method
Date: Wed,  3 Jul 2013 21:35:36 +0900
Message-Id: <1372854946-17074-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372854946-17074-1-git-send-email-namhyung@kernel.org>
References: <1372854946-17074-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hyeoncheol Lee <cheol.lee@lge.com>

Those symbol and deref fetch methods access a memory region but they
assume it's a kernel memory since uprobes does not support them.

Add ->fetch and ->fetch_size member in order to provide a proper
access method for supporting uprobes.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Hyeoncheol Lee <cheol.lee@lge.com>
[namhyung@kernel.org: Split original patch into pieces as requested]
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_probe.c | 48 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index c58c25d81591..c123a890c5b1 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -93,6 +93,8 @@ struct symbol_cache {
 	char		*symbol;
 	long		offset;
 	unsigned long	addr;
+	fetch_func_t	fetch;
+	fetch_func_t	fetch_size;
 };
 
 static unsigned long update_symbol_cache(struct symbol_cache *sc)
@@ -139,18 +141,29 @@ __kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,	\
 {									\
 	struct symbol_cache *sc = data;					\
 	if (sc->addr)							\
-		fetch_memory_##type(regs, (void *)sc->addr, dest);	\
+		sc->fetch(regs, (void *)sc->addr, dest);		\
 	else								\
 		*(type *)dest = 0;					\
 }
 DEFINE_BASIC_FETCH_FUNCS(symbol)
 DEFINE_FETCH_symbol(string)
-DEFINE_FETCH_symbol(string_size)
+
+__kprobes void FETCH_FUNC_NAME(symbol, string_size)(struct pt_regs *regs,
+						    void *data, void *dest)
+{
+	struct symbol_cache *sc = data;
+	if (sc->addr && sc->fetch_size)
+		sc->fetch_size(regs, (void *)sc->addr, dest);
+	else
+		*(string_size *)dest = 0;
+}
 
 /* Dereference memory access function */
 struct deref_fetch_param {
 	struct fetch_param	orig;
 	long			offset;
+	fetch_func_t		fetch;
+	fetch_func_t		fetch_size;
 };
 
 #define DEFINE_FETCH_deref(type)					\
@@ -162,13 +175,26 @@ __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,	\
 	call_fetch(&dprm->orig, regs, &addr);				\
 	if (addr) {							\
 		addr += dprm->offset;					\
-		fetch_memory_##type(regs, (void *)addr, dest);		\
+		dprm->fetch(regs, (void *)addr, dest);			\
 	} else								\
 		*(type *)dest = 0;					\
 }
 DEFINE_BASIC_FETCH_FUNCS(deref)
 DEFINE_FETCH_deref(string)
-DEFINE_FETCH_deref(string_size)
+
+__kprobes void FETCH_FUNC_NAME(deref, string_size)(struct pt_regs *regs,
+						   void *data, void *dest)
+{
+	struct deref_fetch_param *dprm = data;
+	unsigned long addr;
+
+	call_fetch(&dprm->orig, regs, &addr);
+	if (addr && dprm->fetch_size) {
+		addr += dprm->offset;
+		dprm->fetch_size(regs, (void *)addr, dest);
+	} else
+		*(string_size *)dest = 0;
+}
 
 static __kprobes void update_deref_fetch_param(struct deref_fetch_param *data)
 {
@@ -410,13 +436,20 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 			f->fn = t->fetch[FETCH_MTD_memory];
 			f->data = (void *)param;
 		} else {
+			struct symbol_cache *sc;
+
 			ret = traceprobe_split_symbol_offset(arg + 1, &offset);
 			if (ret)
 				break;
 
-			f->data = alloc_symbol_cache(arg + 1, offset);
-			if (f->data)
+			sc = alloc_symbol_cache(arg + 1, offset);
+			if (sc) {
 				f->fn = t->fetch[FETCH_MTD_symbol];
+				sc->fetch = t->fetch[FETCH_MTD_memory];
+				sc->fetch_size = get_fetch_size_function(t,
+							sc->fetch, ttbl);
+				f->data = sc;
+			}
 		}
 		break;
 
@@ -448,6 +481,9 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 				return -ENOMEM;
 
 			dprm->offset = offset;
+			dprm->fetch = t->fetch[FETCH_MTD_memory];
+			dprm->fetch_size = get_fetch_size_function(t,
+							dprm->fetch, ttbl);
 			ret = parse_probe_arg(arg, t2, &dprm->orig, is_return,
 							is_kprobe);
 			if (ret)
-- 
1.7.11.7

