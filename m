Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbaDPNFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:05:00 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:54909 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343AbaDPNE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:04:58 -0400
Date: Wed, 16 Apr 2014 15:04:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20140416130450.GA12103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: ad466db5b0c302e85ad96c42a43194c234cbd862 Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/urgent

Tooling fixes, plus a simple hardware-enablement patch for the Intel 
RAPL PMU (energy use measurement) on Haswell CPUs, which I hope is 
still fine at this stage.

 Thanks,

	Ingo

------------------>
Adrian Hunter (1):
      perf tools: Fix double free in perf test 21 (code-reading.c)

Andi Kleen (1):
      perf stat: Initialize statistics correctly

Arnaldo Carvalho de Melo (2):
      perf callchains: Disable unwind libraries when libelf isn't found
      MAINTAINERS: Change e-mail to kernel.org one

Cody P Schafer (1):
      perf tools: Instead of redirecting flex output, use -o

Masami Hiramatsu (1):
      perf probe: Fix to handle errors in line_range searching

Namhyung Kim (5):
      perf top: Fix documentation of invalid -s option
      tools lib traceevent: Print event name when show warning if possible
      tools lib traceevent: Do not call warning() directly
      perf probe: Fix --line option behavior
      perf probe: Use dwarf_getcfi_elf() instead of dwarf_getcfi()

Ramkumar Ramachandra (4):
      perf tools: Pick up libdw without explicit LIBDW_DIR
      perf bench: Update manpage to mention numa and futex
      perf bench: Fix segfault at the end of an 'all' execution
      perf bench: Set more defaults in the 'numa' suite

Vince Weaver (1):
      perf/x86: Enable DRAM RAPL support on Intel Haswell


 MAINTAINERS                                 |   2 +-
 arch/x86/kernel/cpu/perf_event_intel_rapl.c |  33 ++++++++-
 tools/lib/traceevent/event-parse.c          | 109 +++++++++++++++++-----------
 tools/perf/Documentation/perf-bench.txt     |  22 ++++++
 tools/perf/Documentation/perf-top.txt       |   1 -
 tools/perf/Makefile.perf                    |   4 +-
 tools/perf/bench/numa.c                     |   4 +
 tools/perf/builtin-stat.c                   |  11 ++-
 tools/perf/config/Makefile                  |   7 +-
 tools/perf/tests/code-reading.c             |   1 +
 tools/perf/util/probe-finder.c              |  15 ++--
 11 files changed, 148 insertions(+), 61 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6dc67b1..80399ff 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6782,7 +6782,7 @@ PERFORMANCE EVENTS SUBSYSTEM
 M:	Peter Zijlstra <a.p.zijlstra@chello.nl>
 M:	Paul Mackerras <paulus@samba.org>
 M:	Ingo Molnar <mingo@redhat.com>
-M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
+M:	Arnaldo Carvalho de Melo <acme@kernel.org>
 L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf/core
 S:	Supported
diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
index 059218e..4b9a9e9 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
@@ -59,7 +59,7 @@
 #define INTEL_RAPL_PKG		0x2	/* pseudo-encoding */
 #define RAPL_IDX_RAM_NRG_STAT	2	/* DRAM */
 #define INTEL_RAPL_RAM		0x3	/* pseudo-encoding */
-#define RAPL_IDX_PP1_NRG_STAT	3	/* DRAM */
+#define RAPL_IDX_PP1_NRG_STAT	3	/* gpu */
 #define INTEL_RAPL_PP1		0x4	/* pseudo-encoding */
 
 /* Clients have PP0, PKG */
@@ -72,6 +72,12 @@
 			 1<<RAPL_IDX_PKG_NRG_STAT|\
 			 1<<RAPL_IDX_RAM_NRG_STAT)
 
+/* Servers have PP0, PKG, RAM, PP1 */
+#define RAPL_IDX_HSW	(1<<RAPL_IDX_PP0_NRG_STAT|\
+			 1<<RAPL_IDX_PKG_NRG_STAT|\
+			 1<<RAPL_IDX_RAM_NRG_STAT|\
+			 1<<RAPL_IDX_PP1_NRG_STAT)
+
 /*
  * event code: LSB 8 bits, passed in attr->config
  * any other bit is reserved
@@ -425,6 +431,24 @@ static struct attribute *rapl_events_cln_attr[] = {
 	NULL,
 };
 
+static struct attribute *rapl_events_hsw_attr[] = {
+	EVENT_PTR(rapl_cores),
+	EVENT_PTR(rapl_pkg),
+	EVENT_PTR(rapl_gpu),
+	EVENT_PTR(rapl_ram),
+
+	EVENT_PTR(rapl_cores_unit),
+	EVENT_PTR(rapl_pkg_unit),
+	EVENT_PTR(rapl_gpu_unit),
+	EVENT_PTR(rapl_ram_unit),
+
+	EVENT_PTR(rapl_cores_scale),
+	EVENT_PTR(rapl_pkg_scale),
+	EVENT_PTR(rapl_gpu_scale),
+	EVENT_PTR(rapl_ram_scale),
+	NULL,
+};
+
 static struct attribute_group rapl_pmu_events_group = {
 	.name = "events",
 	.attrs = NULL, /* patched at runtime */
@@ -631,11 +655,14 @@ static int __init rapl_pmu_init(void)
 	switch (boot_cpu_data.x86_model) {
 	case 42: /* Sandy Bridge */
 	case 58: /* Ivy Bridge */
-	case 60: /* Haswell */
-	case 69: /* Haswell-Celeron */
 		rapl_cntr_mask = RAPL_IDX_CLN;
 		rapl_pmu_events_group.attrs = rapl_events_cln_attr;
 		break;
+	case 60: /* Haswell */
+	case 69: /* Haswell-Celeron */
+		rapl_cntr_mask = RAPL_IDX_HSW;
+		rapl_pmu_events_group.attrs = rapl_events_hsw_attr;
+		break;
 	case 45: /* Sandy Bridge-EP */
 	case 62: /* IvyTown */
 		rapl_cntr_mask = RAPL_IDX_SRV;
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 1587ea39..baec7d8 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -50,6 +50,18 @@ static int show_warning = 1;
 			warning(fmt, ##__VA_ARGS__);	\
 	} while (0)
 
+#define do_warning_event(event, fmt, ...)			\
+	do {							\
+		if (!show_warning)				\
+			continue;				\
+								\
+		if (event)					\
+			warning("[%s:%s] " fmt, event->system,	\
+				event->name, ##__VA_ARGS__);	\
+		else						\
+			warning(fmt, ##__VA_ARGS__);		\
+	} while (0)
+
 static void init_input_buf(const char *buf, unsigned long long size)
 {
 	input_buf = buf;
@@ -1355,7 +1367,7 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 		}
 
 		if (!field->type) {
-			do_warning("%s: no type found", __func__);
+			do_warning_event(event, "%s: no type found", __func__);
 			goto fail;
 		}
 		field->name = last_token;
@@ -1402,7 +1414,7 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 				free_token(token);
 				type = read_token(&token);
 				if (type == EVENT_NONE) {
-					do_warning("failed to find token");
+					do_warning_event(event, "failed to find token");
 					goto fail;
 				}
 			}
@@ -1636,7 +1648,7 @@ process_cond(struct event_format *event, struct print_arg *top, char **tok)
 	right = alloc_arg();
 
 	if (!arg || !left || !right) {
-		do_warning("%s: not enough memory!", __func__);
+		do_warning_event(event, "%s: not enough memory!", __func__);
 		/* arg will be freed at out_free */
 		free_arg(left);
 		free_arg(right);
@@ -1686,7 +1698,7 @@ process_array(struct event_format *event, struct print_arg *top, char **tok)
 
 	arg = alloc_arg();
 	if (!arg) {
-		do_warning("%s: not enough memory!", __func__);
+		do_warning_event(event, "%s: not enough memory!", __func__);
 		/* '*tok' is set to top->op.op.  No need to free. */
 		*tok = NULL;
 		return EVENT_ERROR;
@@ -1792,7 +1804,7 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 	if (arg->type == PRINT_OP && !arg->op.left) {
 		/* handle single op */
 		if (token[1]) {
-			do_warning("bad op token %s", token);
+			do_warning_event(event, "bad op token %s", token);
 			goto out_free;
 		}
 		switch (token[0]) {
@@ -1802,7 +1814,7 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 		case '-':
 			break;
 		default:
-			do_warning("bad op token %s", token);
+			do_warning_event(event, "bad op token %s", token);
 			goto out_free;
 
 		}
@@ -1888,7 +1900,7 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 			char *new_atom;
 
 			if (left->type != PRINT_ATOM) {
-				do_warning("bad pointer type");
+				do_warning_event(event, "bad pointer type");
 				goto out_free;
 			}
 			new_atom = realloc(left->atom.atom,
@@ -1930,7 +1942,7 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 		type = process_array(event, arg, tok);
 
 	} else {
-		do_warning("unknown op '%s'", token);
+		do_warning_event(event, "unknown op '%s'", token);
 		event->flags |= EVENT_FL_FAILED;
 		/* the arg is now the left side */
 		goto out_free;
@@ -1951,7 +1963,7 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 	return type;
 
 out_warn_free:
-	do_warning("%s: not enough memory!", __func__);
+	do_warning_event(event, "%s: not enough memory!", __func__);
 out_free:
 	free_token(token);
 	*tok = NULL;
@@ -2385,7 +2397,7 @@ process_flags(struct event_format *event, struct print_arg *arg, char **tok)
 
 	field = alloc_arg();
 	if (!field) {
-		do_warning("%s: not enough memory!", __func__);
+		do_warning_event(event, "%s: not enough memory!", __func__);
 		goto out_free;
 	}
 
@@ -2438,7 +2450,7 @@ process_symbols(struct event_format *event, struct print_arg *arg, char **tok)
 
 	field = alloc_arg();
 	if (!field) {
-		do_warning("%s: not enough memory!", __func__);
+		do_warning_event(event, "%s: not enough memory!", __func__);
 		goto out_free;
 	}
 
@@ -2477,7 +2489,7 @@ process_hex(struct event_format *event, struct print_arg *arg, char **tok)
 
 	field = alloc_arg();
 	if (!field) {
-		do_warning("%s: not enough memory!", __func__);
+		do_warning_event(event, "%s: not enough memory!", __func__);
 		goto out_free;
 	}
 
@@ -2492,7 +2504,7 @@ process_hex(struct event_format *event, struct print_arg *arg, char **tok)
 
 	field = alloc_arg();
 	if (!field) {
-		do_warning("%s: not enough memory!", __func__);
+		do_warning_event(event, "%s: not enough memory!", __func__);
 		*tok = NULL;
 		return EVENT_ERROR;
 	}
@@ -2555,7 +2567,7 @@ process_dynamic_array(struct event_format *event, struct print_arg *arg, char **
 	free_token(token);
 	arg = alloc_arg();
 	if (!arg) {
-		do_warning("%s: not enough memory!", __func__);
+		do_warning_event(event, "%s: not enough memory!", __func__);
 		*tok = NULL;
 		return EVENT_ERROR;
 	}
@@ -2614,13 +2626,14 @@ process_paren(struct event_format *event, struct print_arg *arg, char **tok)
 
 		/* prevous must be an atom */
 		if (arg->type != PRINT_ATOM) {
-			do_warning("previous needed to be PRINT_ATOM");
+			do_warning_event(event, "previous needed to be PRINT_ATOM");
 			goto out_free;
 		}
 
 		item_arg = alloc_arg();
 		if (!item_arg) {
-			do_warning("%s: not enough memory!", __func__);
+			do_warning_event(event, "%s: not enough memory!",
+					 __func__);
 			goto out_free;
 		}
 
@@ -2721,21 +2734,24 @@ process_func_handler(struct event_format *event, struct pevent_function_handler
 	for (i = 0; i < func->nr_args; i++) {
 		farg = alloc_arg();
 		if (!farg) {
-			do_warning("%s: not enough memory!", __func__);
+			do_warning_event(event, "%s: not enough memory!",
+					 __func__);
 			return EVENT_ERROR;
 		}
 
 		type = process_arg(event, farg, &token);
 		if (i < (func->nr_args - 1)) {
 			if (type != EVENT_DELIM || strcmp(token, ",") != 0) {
-				warning("Error: function '%s()' expects %d arguments but event %s only uses %d",
+				do_warning_event(event,
+					"Error: function '%s()' expects %d arguments but event %s only uses %d",
 					func->name, func->nr_args,
 					event->name, i + 1);
 				goto err;
 			}
 		} else {
 			if (type != EVENT_DELIM || strcmp(token, ")") != 0) {
-				warning("Error: function '%s()' only expects %d arguments but event %s has more",
+				do_warning_event(event,
+					"Error: function '%s()' only expects %d arguments but event %s has more",
 					func->name, func->nr_args, event->name);
 				goto err;
 			}
@@ -2792,7 +2808,7 @@ process_function(struct event_format *event, struct print_arg *arg,
 		return process_func_handler(event, func, arg, tok);
 	}
 
-	do_warning("function %s not defined", token);
+	do_warning_event(event, "function %s not defined", token);
 	free_token(token);
 	return EVENT_ERROR;
 }
@@ -2878,7 +2894,7 @@ process_arg_token(struct event_format *event, struct print_arg *arg,
 
 	case EVENT_ERROR ... EVENT_NEWLINE:
 	default:
-		do_warning("unexpected type %d", type);
+		do_warning_event(event, "unexpected type %d", type);
 		return EVENT_ERROR;
 	}
 	*tok = token;
@@ -2901,7 +2917,8 @@ static int event_read_print_args(struct event_format *event, struct print_arg **
 
 		arg = alloc_arg();
 		if (!arg) {
-			do_warning("%s: not enough memory!", __func__);
+			do_warning_event(event, "%s: not enough memory!",
+					 __func__);
 			return -1;
 		}
 
@@ -3481,11 +3498,12 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 	return val;
 
 out_warning_op:
-	do_warning("%s: unknown op '%s'", __func__, arg->op.op);
+	do_warning_event(event, "%s: unknown op '%s'", __func__, arg->op.op);
 	return 0;
 
 out_warning_field:
-	do_warning("%s: field %s not found", __func__, arg->field.name);
+	do_warning_event(event, "%s: field %s not found",
+			 __func__, arg->field.name);
 	return 0;
 }
 
@@ -3591,7 +3609,8 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		}
 		str = malloc(len + 1);
 		if (!str) {
-			do_warning("%s: not enough memory!", __func__);
+			do_warning_event(event, "%s: not enough memory!",
+					 __func__);
 			return;
 		}
 		memcpy(str, data + field->offset, len);
@@ -3697,7 +3716,8 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	return;
 
 out_warning_field:
-	do_warning("%s: field %s not found", __func__, arg->field.name);
+	do_warning_event(event, "%s: field %s not found",
+			 __func__, arg->field.name);
 }
 
 static unsigned long long
@@ -3742,14 +3762,16 @@ process_defined_func(struct trace_seq *s, void *data, int size,
 			trace_seq_terminate(&str);
 			string = malloc(sizeof(*string));
 			if (!string) {
-				do_warning("%s(%d): malloc str", __func__, __LINE__);
+				do_warning_event(event, "%s(%d): malloc str",
+						 __func__, __LINE__);
 				goto out_free;
 			}
 			string->next = strings;
 			string->str = strdup(str.buffer);
 			if (!string->str) {
 				free(string);
-				do_warning("%s(%d): malloc str", __func__, __LINE__);
+				do_warning_event(event, "%s(%d): malloc str",
+						 __func__, __LINE__);
 				goto out_free;
 			}
 			args[i] = (uintptr_t)string->str;
@@ -3761,7 +3783,7 @@ process_defined_func(struct trace_seq *s, void *data, int size,
 			 * Something went totally wrong, this is not
 			 * an input error, something in this code broke.
 			 */
-			do_warning("Unexpected end of arguments\n");
+			do_warning_event(event, "Unexpected end of arguments\n");
 			goto out_free;
 		}
 		farg = farg->next;
@@ -3811,12 +3833,12 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 	if (!field) {
 		field = pevent_find_field(event, "buf");
 		if (!field) {
-			do_warning("can't find buffer field for binary printk");
+			do_warning_event(event, "can't find buffer field for binary printk");
 			return NULL;
 		}
 		ip_field = pevent_find_field(event, "ip");
 		if (!ip_field) {
-			do_warning("can't find ip field for binary printk");
+			do_warning_event(event, "can't find ip field for binary printk");
 			return NULL;
 		}
 		pevent->bprint_buf_field = field;
@@ -3830,7 +3852,8 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 	 */
 	args = alloc_arg();
 	if (!args) {
-		do_warning("%s(%d): not enough memory!", __func__, __LINE__);
+		do_warning_event(event, "%s(%d): not enough memory!",
+				 __func__, __LINE__);
 		return NULL;
 	}
 	arg = args;
@@ -3896,7 +3919,7 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 				bptr += vsize;
 				arg = alloc_arg();
 				if (!arg) {
-					do_warning("%s(%d): not enough memory!",
+					do_warning_event(event, "%s(%d): not enough memory!",
 						   __func__, __LINE__);
 					goto out_free;
 				}
@@ -3919,7 +3942,7 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 			case 's':
 				arg = alloc_arg();
 				if (!arg) {
-					do_warning("%s(%d): not enough memory!",
+					do_warning_event(event, "%s(%d): not enough memory!",
 						   __func__, __LINE__);
 					goto out_free;
 				}
@@ -3959,7 +3982,7 @@ get_bprint_format(void *data, int size __maybe_unused,
 	if (!field) {
 		field = pevent_find_field(event, "fmt");
 		if (!field) {
-			do_warning("can't find format field for binary printk");
+			do_warning_event(event, "can't find format field for binary printk");
 			return NULL;
 		}
 		pevent->bprint_fmt_field = field;
@@ -4003,8 +4026,8 @@ static void print_mac_arg(struct trace_seq *s, int mac, void *data, int size,
 		arg->field.field =
 			pevent_find_any_field(event, arg->field.name);
 		if (!arg->field.field) {
-			do_warning("%s: field %s not found",
-				   __func__, arg->field.name);
+			do_warning_event(event, "%s: field %s not found",
+					 __func__, arg->field.name);
 			return;
 		}
 	}
@@ -4176,7 +4199,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
 			case '*':
 				/* The argument is the length. */
 				if (!arg) {
-					do_warning("no argument match");
+					do_warning_event(event, "no argument match");
 					event->flags |= EVENT_FL_FAILED;
 					goto out_failed;
 				}
@@ -4213,7 +4236,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
 			case 'X':
 			case 'u':
 				if (!arg) {
-					do_warning("no argument match");
+					do_warning_event(event, "no argument match");
 					event->flags |= EVENT_FL_FAILED;
 					goto out_failed;
 				}
@@ -4223,7 +4246,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
 
 				/* should never happen */
 				if (len > 31) {
-					do_warning("bad format!");
+					do_warning_event(event, "bad format!");
 					event->flags |= EVENT_FL_FAILED;
 					len = 31;
 				}
@@ -4290,13 +4313,13 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
 						trace_seq_printf(s, format, (long long)val);
 					break;
 				default:
-					do_warning("bad count (%d)", ls);
+					do_warning_event(event, "bad count (%d)", ls);
 					event->flags |= EVENT_FL_FAILED;
 				}
 				break;
 			case 's':
 				if (!arg) {
-					do_warning("no matching argument");
+					do_warning_event(event, "no matching argument");
 					event->flags |= EVENT_FL_FAILED;
 					goto out_failed;
 				}
@@ -4306,7 +4329,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
 
 				/* should never happen */
 				if (len > 31) {
-					do_warning("bad format!");
+					do_warning_event(event, "bad format!");
 					event->flags |= EVENT_FL_FAILED;
 					len = 31;
 				}
diff --git a/tools/perf/Documentation/perf-bench.txt b/tools/perf/Documentation/perf-bench.txt
index 7065cd6..4464ad7 100644
--- a/tools/perf/Documentation/perf-bench.txt
+++ b/tools/perf/Documentation/perf-bench.txt
@@ -48,6 +48,12 @@ SUBSYSTEM
 'mem'::
 	Memory access performance.
 
+'numa'::
+	NUMA scheduling and MM benchmarks.
+
+'futex'::
+	Futex stressing benchmarks.
+
 'all'::
 	All benchmark subsystems.
 
@@ -187,6 +193,22 @@ Show only the result with page faults before memset.
 --no-prefault::
 Show only the result without page faults before memset.
 
+SUITES FOR 'numa'
+~~~~~~~~~~~~~~~~~
+*mem*::
+Suite for evaluating NUMA workloads.
+
+SUITES FOR 'futex'
+~~~~~~~~~~~~~~~~~~
+*hash*::
+Suite for evaluating hash tables.
+
+*wake*::
+Suite for evaluating wake calls.
+
+*requeue*::
+Suite for evaluating requeue calls.
+
 SEE ALSO
 --------
 linkperf:perf[1]
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index cdd8d49..976b00c 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -87,7 +87,6 @@ Default is to monitor all CPUS.
 --realtime=<priority>::
 	Collect data with this RT SCHED_FIFO priority.
 
--s <symbol>::
 --sym-annotate=<symbol>::
         Annotate this symbol.
 
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 50d875d..e969233 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -192,13 +192,13 @@ endif
 export PERL_PATH
 
 $(OUTPUT)util/parse-events-flex.c: util/parse-events.l $(OUTPUT)util/parse-events-bison.c
-	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/parse-events-flex.h $(PARSER_DEBUG_FLEX) -t util/parse-events.l > $(OUTPUT)util/parse-events-flex.c
+	$(QUIET_FLEX)$(FLEX) -o $@ --header-file=$(OUTPUT)util/parse-events-flex.h $(PARSER_DEBUG_FLEX) util/parse-events.l
 
 $(OUTPUT)util/parse-events-bison.c: util/parse-events.y
 	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d $(PARSER_DEBUG_BISON) -o $(OUTPUT)util/parse-events-bison.c -p parse_events_
 
 $(OUTPUT)util/pmu-flex.c: util/pmu.l $(OUTPUT)util/pmu-bison.c
-	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/pmu-flex.h -t util/pmu.l > $(OUTPUT)util/pmu-flex.c
+	$(QUIET_FLEX)$(FLEX) -o $@ --header-file=$(OUTPUT)util/pmu-flex.h util/pmu.l
 
 $(OUTPUT)util/pmu-bison.c: util/pmu.y
 	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c -p perf_pmu_
diff --git a/tools/perf/bench/numa.c b/tools/perf/bench/numa.c
index 97d86d8..ebfa163 100644
--- a/tools/perf/bench/numa.c
+++ b/tools/perf/bench/numa.c
@@ -1593,6 +1593,10 @@ static void init_params(struct params *p, const char *name, int argc, const char
 	p->data_rand_walk		= true;
 	p->nr_loops			= -1;
 	p->init_random			= true;
+	p->mb_global_str		= "1";
+	p->nr_proc			= 1;
+	p->nr_threads			= 1;
+	p->nr_secs			= 5;
 	p->run_all			= argc == 1;
 }
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 8b0e1c9..65a151e 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -174,13 +174,20 @@ static inline int perf_evsel__nr_cpus(struct perf_evsel *evsel)
 
 static void perf_evsel__reset_stat_priv(struct perf_evsel *evsel)
 {
-	memset(evsel->priv, 0, sizeof(struct perf_stat));
+	int i;
+	struct perf_stat *ps = evsel->priv;
+
+	for (i = 0; i < 3; i++)
+		init_stats(&ps->res_stats[i]);
 }
 
 static int perf_evsel__alloc_stat_priv(struct perf_evsel *evsel)
 {
 	evsel->priv = zalloc(sizeof(struct perf_stat));
-	return evsel->priv == NULL ? -ENOMEM : 0;
+	if (evsel == NULL)
+		return -ENOMEM;
+	perf_evsel__reset_stat_priv(evsel);
+	return 0;
 }
 
 static void perf_evsel__free_stat_priv(struct perf_evsel *evsel)
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index c234182..ee21fa9 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -65,10 +65,9 @@ ifndef NO_LIBELF
   ifdef LIBDW_DIR
     LIBDW_CFLAGS  := -I$(LIBDW_DIR)/include
     LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
-
-    FEATURE_CHECK_CFLAGS-libdw-dwarf-unwind := $(LIBDW_CFLAGS)
-    FEATURE_CHECK_LDFLAGS-libdw-dwarf-unwind := $(LIBDW_LDFLAGS) -ldw
   endif
+  FEATURE_CHECK_CFLAGS-libdw-dwarf-unwind := $(LIBDW_CFLAGS)
+  FEATURE_CHECK_LDFLAGS-libdw-dwarf-unwind := $(LIBDW_LDFLAGS) -ldw
 endif
 
 # include ARCH specific config
@@ -278,6 +277,8 @@ else
       NO_LIBELF := 1
       NO_DWARF := 1
       NO_DEMANGLE := 1
+      NO_LIBUNWIND := 1
+      NO_LIBDW_DWARF_UNWIND := 1
     else
       msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
     endif
diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 653a8fe..bfb1869 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -504,6 +504,7 @@ static int do_test_code_reading(bool try_kcore)
 		if (ret < 0) {
 			if (!excl_kernel) {
 				excl_kernel = true;
+				perf_evlist__set_maps(evlist, NULL, NULL);
 				perf_evlist__delete(evlist);
 				evlist = NULL;
 				continue;
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index df02386..5627621 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -985,7 +985,7 @@ static int debuginfo__find_probes(struct debuginfo *dbg,
 
 #if _ELFUTILS_PREREQ(0, 142)
 	/* Get the call frame information from this dwarf */
-	pf->cfi = dwarf_getcfi(dbg->dbg);
+	pf->cfi = dwarf_getcfi_elf(dwarf_getelf(dbg->dbg));
 #endif
 
 	off = 0;
@@ -1441,13 +1441,15 @@ static int line_range_walk_cb(const char *fname, int lineno,
 			      void *data)
 {
 	struct line_finder *lf = data;
+	int err;
 
 	if ((strtailcmp(fname, lf->fname) != 0) ||
 	    (lf->lno_s > lineno || lf->lno_e < lineno))
 		return 0;
 
-	if (line_range_add_line(fname, lineno, lf->lr) < 0)
-		return -EINVAL;
+	err = line_range_add_line(fname, lineno, lf->lr);
+	if (err < 0 && err != -EEXIST)
+		return err;
 
 	return 0;
 }
@@ -1473,14 +1475,15 @@ static int find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
 
 static int line_range_inline_cb(Dwarf_Die *in_die, void *data)
 {
-	find_line_range_by_line(in_die, data);
+	int ret = find_line_range_by_line(in_die, data);
 
 	/*
 	 * We have to check all instances of inlined function, because
 	 * some execution paths can be optimized out depends on the
-	 * function argument of instances
+	 * function argument of instances. However, if an error occurs,
+	 * it should be handled by the caller.
 	 */
-	return 0;
+	return ret < 0 ? ret : 0;
 }
 
 /* Search function definition from function name */
