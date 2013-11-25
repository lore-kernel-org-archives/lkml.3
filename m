Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab3KYRUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 12:20:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433Ab3KYRUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 12:20:38 -0500
Date: Mon, 25 Nov 2013 18:21:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/3] tracing: introduce {calc,parse}_probe_offset() for
	FETCH_MTD_{symbol,deref}
Message-ID: <20131125172145.GC14516@redhat.com>
References: <20131123201543.GA22148@redhat.com> <20131125172106.GA14516@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131125172106.GA14516@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparation to simplify the review of the next patch.

Add 2 "dummy" helpers used by FETCH_MTD_{symbol,deref} parse/fetch
code: calc_probe_offset(offset) which currently simply returns its
arg, and parse_probe_offset(name, offset) which calls kstrtol().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_probe.c |   27 +++++++++++++++++++++------
 1 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index dcf7780..723e6e9 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -263,12 +263,14 @@ static struct symbol_cache *alloc_symbol_cache(const char *sym, long offset)
 	return sc;
 }
 
+static long calc_probe_offset(unsigned long offset);
+
 #define DEFINE_FETCH_symbol(type)					\
 static __kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,\
 					  void *data, void *dest)	\
 {									\
 	struct symbol_cache *sc = data;					\
-	long off = sc->offset;						\
+	long off = calc_probe_offset(sc->offset);			\
 	if (sc->addr)							\
 		fetch_memory_##type(regs, (void *)sc->addr + off, dest);\
 	else								\
@@ -292,7 +294,7 @@ static __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,\
 	unsigned long addr;						\
 	call_fetch(&dprm->orig, regs, &addr);				\
 	if (addr) {							\
-		addr += dprm->offset;					\
+		addr += calc_probe_offset(dprm->offset);		\
 		fetch_memory_##type(regs, (void *)addr, dest);		\
 	} else								\
 		*(type *)dest = 0;					\
@@ -487,6 +489,8 @@ static fetch_func_t get_fetch_size_function(const struct fetch_type *type,
 	return NULL;
 }
 
+static int parse_probe_offset(const char *name, unsigned long *offset);
+
 /* Split symbol and offset. */
 int traceprobe_split_symbol_offset(char *symbol, unsigned long *offset)
 {
@@ -495,8 +499,7 @@ int traceprobe_split_symbol_offset(char *symbol, unsigned long *offset)
 
 	tmp = strchr(symbol, '+');
 	if (tmp) {
-		/* skip sign because kstrtoul doesn't accept '+' */
-		ret = kstrtoul(tmp + 1, 0, offset);
+		ret = parse_probe_offset(tmp, offset);
 		if (ret)
 			return ret;
 
@@ -588,6 +591,19 @@ static int pseudo_reg_query_offset(const char *name)
 	return -EINVAL;
 }
 
+static long calc_probe_offset(unsigned long offset)
+{
+	return offset;
+}
+
+static int parse_probe_offset(const char *name, unsigned long *offset)
+{
+	if (name[0] == '+')	/* kstrtol() rejects '+' */
+		name++;
+
+	return kstrtol(name, 0, offset);
+}
+
 /* Recursive argument parser */
 static int parse_probe_arg(char *arg, const struct fetch_type *t,
 		     struct fetch_param *f, bool is_return, bool is_kprobe)
@@ -641,14 +657,13 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 		break;
 
 	case '+':	/* deref memory */
-		arg++;	/* Skip '+', because kstrtol() rejects it. */
 	case '-':
 		tmp = strchr(arg, '(');
 		if (!tmp)
 			break;
 
 		*tmp = '\0';
-		ret = kstrtol(arg, 0, &offset);
+		ret = parse_probe_offset(arg, &offset);
 
 		if (ret)
 			break;
-- 
1.5.5.1


