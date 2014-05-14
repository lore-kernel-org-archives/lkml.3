Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210AbaENSZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 14:25:08 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:33359 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750862AbaENSZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 14:25:04 -0400
Date: Wed, 14 May 2014 14:25:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Javi Merino <javi.merino@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [RFC][PATCH v3] tracing: Add __bitmask() macro to trace events to
 cpumasks and other bitmasks
Message-ID: <20140514142500.020e9896@gandalf.local.home>
In-Reply-To: <20140514155053.GB3052@e102654-lin.cambridge.arm.com>
References: <1399377998-14870-1-git-send-email-javi.merino@arm.com>
	<1399377998-14870-6-git-send-email-javi.merino@arm.com>
	<20140506132238.22e136d1@gandalf.local.home>
	<484888063.12149.1399403794855.JavaMail.zimbra@efficios.com>
	<20140506231238.246c7d3e@gandalf.local.home>
	<20140514142324.GA10024@e102654-lin.cambridge.arm.com>
	<20140514113623.171f2a39@gandalf.local.home>
	<20140514155053.GB3052@e102654-lin.cambridge.arm.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_//lFGoIrGeslueE8fEVKZr4A"
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_//lFGoIrGeslueE8fEVKZr4A
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Updated version.

You can test it with the attached trace-cmd patch. I tested it against
big and little endian machines (each reading their own and the other
machine's trace.dat file). I did not test against 32bit, but it should
still work. I will test it before I commit it to traceevent library.

Can you review this and try it out?

Thanks!

-- Steve

=46rom be2f29847428f5a290496d1c44ad938f2c2ad040 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Tue, 6 May 2014 13:10:24 -0400
Subject: [PATCH] tracing: Add __bitmask() macro to trace events to cpumasks
 and other bitmasks

Being able to show a cpumask of events can be useful as some events
may affect only some CPUs. There is no standard way to record the
cpumask and converting it to a string is rather expensive during
the trace as traces happen in hotpaths. It would be better to record
the raw event mask and be able to parse it at print time.

The following macros were added for use with the TRACE_EVENT() macro:

  __bitmask()
  __assign_bitmask()
  __get_bitmask()

To test this, I added this to the sched_migrate_task event, which
looked like this:

TRACE_EVENT(sched_migrate_task,

	TP_PROTO(struct task_struct *p, int dest_cpu, const struct cpumask *cpus),

	TP_ARGS(p, dest_cpu, cpus),

	TP_STRUCT__entry(
		__array(	char,	comm,	TASK_COMM_LEN	)
		__field(	pid_t,	pid			)
		__field(	int,	prio			)
		__field(	int,	orig_cpu		)
		__field(	int,	dest_cpu		)
		__bitmask(	cpumask, num_possible_cpus()	)
	),

	TP_fast_assign(
		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
		__entry->pid		=3D p->pid;
		__entry->prio		=3D p->prio;
		__entry->orig_cpu	=3D task_cpu(p);
		__entry->dest_cpu	=3D dest_cpu;
		__assign_bitmask(cpumask, cpumask_bits(cpus), num_possible_cpus());
	),

	TP_printk("comm=3D%s pid=3D%d prio=3D%d orig_cpu=3D%d dest_cpu=3D%d cpumas=
k=3D%s",
		  __entry->comm, __entry->pid, __entry->prio,
		  __entry->orig_cpu, __entry->dest_cpu,
		  __get_bitmask(cpumask))
);

With the output of:

        ksmtuned-3613  [003] d..2   485.220508: sched_migrate_task: comm=3D=
ksmtuned pid=3D3615 prio=3D120 orig_cpu=3D3 dest_cpu=3D2 cpumask=3D00000000=
,0000000f
     migration/1-13    [001] d..5   485.221202: sched_migrate_task: comm=3D=
ksmtuned pid=3D3614 prio=3D120 orig_cpu=3D1 dest_cpu=3D0 cpumask=3D00000000=
,0000000f
             awk-3615  [002] d.H5   485.221747: sched_migrate_task: comm=3D=
rcu_preempt pid=3D7 prio=3D120 orig_cpu=3D0 dest_cpu=3D1 cpumask=3D00000000=
,000000ff
     migration/2-18    [002] d..5   485.222062: sched_migrate_task: comm=3D=
ksmtuned pid=3D3615 prio=3D120 orig_cpu=3D2 dest_cpu=3D3 cpumask=3D00000000=
,0000000f

Link: http://lkml.kernel.org/r/1399377998-14870-6-git-send-email-javi.merin=
o@arm.com

Suggested-by: Javi Merino <javi.merino@arm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |  3 +++
 include/linux/trace_seq.h    | 10 ++++++++
 include/trace/ftrace.h       | 57 ++++++++++++++++++++++++++++++++++++++++=
+++-
 kernel/trace/trace_output.c  | 41 +++++++++++++++++++++++++++++++
 4 files changed, 110 insertions(+), 1 deletion(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index d16da3e..cff3106 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -38,6 +38,9 @@ const char *ftrace_print_symbols_seq_u64(struct trace_seq=
 *p,
 								 *symbol_array);
 #endif
=20
+const char *ftrace_print_bitmask_seq(struct trace_seq *p, void *bitmask_pt=
r,
+				     unsigned int bitmask_size);
+
 const char *ftrace_print_hex_seq(struct trace_seq *p,
 				 const unsigned char *buf, int len);
=20
diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index a32d86e..1361169 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -46,6 +46,9 @@ extern int trace_seq_putmem_hex(struct trace_seq *s, cons=
t void *mem,
 extern void *trace_seq_reserve(struct trace_seq *s, size_t len);
 extern int trace_seq_path(struct trace_seq *s, const struct path *path);
=20
+extern int trace_seq_bitmask(struct trace_seq *s, const unsigned long *mas=
kp,
+			     int nmaskbits);
+
 #else /* CONFIG_TRACING */
 static inline int trace_seq_printf(struct trace_seq *s, const char *fmt, .=
..)
 {
@@ -57,6 +60,13 @@ trace_seq_bprintf(struct trace_seq *s, const char *fmt, =
const u32 *binary)
 	return 0;
 }
=20
+static inline int
+trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
+		  int nmaskbits)
+{
+	return 0;
+}
+
 static inline int trace_print_seq(struct seq_file *m, struct trace_seq *s)
 {
 	return 0;
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 0a1a4f7..9b7a989 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -53,6 +53,9 @@
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
=20
+#undef __bitmask
+#define __bitmask(item, nr_bits) __dynamic_array(char, item, -1)
+
 #undef TP_STRUCT__entry
 #define TP_STRUCT__entry(args...) args
=20
@@ -128,6 +131,9 @@
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
=20
+#undef __bitmask
+#define __bitmask(item, nr_bits) __dynamic_array(unsigned long, item, -1)
+
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 	struct ftrace_data_offsets_##call {				\
@@ -200,6 +206,15 @@
 #undef __get_str
 #define __get_str(field) (char *)__get_dynamic_array(field)
=20
+#undef __get_bitmask
+#define __get_bitmask(field)						\
+	({								\
+		void *__bitmask =3D __get_dynamic_array(field);		\
+		unsigned int __bitmask_size;				\
+		__bitmask_size =3D (__entry->__data_loc_##field >> 16) & 0xffff; \
+		ftrace_print_bitmask_seq(p, __bitmask, __bitmask_size);	\
+	})
+
 #undef __print_flags
 #define __print_flags(flag, delim, flag_array...)			\
 	({								\
@@ -322,6 +337,9 @@ static struct trace_event_functions ftrace_event_type_f=
uncs_##call =3D {	\
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
=20
+#undef __bitmask
+#define __bitmask(item, nr_bits) __dynamic_array(unsigned long, item, -1)
+
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, func, print)	\
 static int notrace __init						\
@@ -372,6 +390,29 @@ ftrace_define_fields_##call(struct ftrace_event_call *=
event_call)	\
 #define __string(item, src) __dynamic_array(char, item,			\
 		    strlen((src) ? (const char *)(src) : "(null)") + 1)
=20
+/*
+ * __bitmask_size_in_bytes_raw is the number of bytes needed to hold
+ * num_possible_cpus().
+ */
+#define __bitmask_size_in_bytes_raw(nr_bits)	\
+	(((nr_bits) + 7) / 8)
+
+#define __bitmask_size_in_longs(nr_bits)			\
+	((__bitmask_size_in_bytes_raw(nr_bits) +		\
+	  ((BITS_PER_LONG / 8) - 1)) / (BITS_PER_LONG / 8))
+
+/*
+ * __bitmask_size_in_bytes is the number of bytes needed to hold
+ * num_possible_cpus() padded out to the nearest long. This is what
+ * is saved in the buffer, just to be consistent.
+ */
+#define __bitmask_size_in_bytes(nr_bits)				\
+	(__bitmask_size_in_longs(nr_bits) * (BITS_PER_LONG / 8))
+
+#undef __bitmask
+#define __bitmask(item, nr_bits) __dynamic_array(unsigned long, item,	\
+					 __bitmask_size_in_longs(nr_bits))
+
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 static inline notrace int ftrace_get_offsets_##call(			\
@@ -513,12 +554,22 @@ static inline notrace int ftrace_get_offsets_##call(	=
		\
 	__entry->__data_loc_##item =3D __data_offsets.item;
=20
 #undef __string
-#define __string(item, src) __dynamic_array(char, item, -1)       	\
+#define __string(item, src) __dynamic_array(char, item, -1)
=20
 #undef __assign_str
 #define __assign_str(dst, src)						\
 	strcpy(__get_str(dst), (src) ? (const char *)(src) : "(null)");
=20
+#undef __bitmask
+#define __bitmask(item, nr_bits) __dynamic_array(unsigned long, item, -1)
+
+#undef __get_bitmask
+#define __get_bitmask(field) (char *)__get_dynamic_array(field)
+
+#undef __assign_bitmask
+#define __assign_bitmask(dst, src, nr_bits)					\
+	memcpy(__get_bitmask(dst), (src), __bitmask_size_in_bytes(nr_bits))
+
 #undef TP_fast_assign
 #define TP_fast_assign(args...) args
=20
@@ -586,6 +637,7 @@ static inline void ftrace_test_probe_##call(void)			\
 #undef __print_hex
 #undef __get_dynamic_array
 #undef __get_str
+#undef __get_bitmask
=20
 #undef TP_printk
 #define TP_printk(fmt, args...) "\"" fmt "\", "  __stringify(args)
@@ -651,6 +703,9 @@ __attribute__((section("_ftrace_events"))) *__event_##c=
all =3D &event_##call
 #undef __get_str
 #define __get_str(field) (char *)__get_dynamic_array(field)
=20
+#undef __get_bitmask
+#define __get_bitmask(field) (char *)__get_dynamic_array(field)
+
 #undef __perf_addr
 #define __perf_addr(a)	(__addr =3D (a))
=20
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index a436de1..f3dad80 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -126,6 +126,34 @@ trace_seq_printf(struct trace_seq *s, const char *fmt,=
 ...)
 EXPORT_SYMBOL_GPL(trace_seq_printf);
=20
 /**
+ * trace_seq_bitmask - put a list of longs as a bitmask print output
+ * @s:		trace sequence descriptor
+ * @maskp:	points to an array of unsigned longs that represent a bitmask
+ * @nmaskbits:	The number of bits that are valid in @maskp
+ *
+ * It returns 0 if the trace oversizes the buffer's free
+ * space, 1 otherwise.
+ *
+ * Writes a ASCII representation of a bitmask string into @s.
+ */
+int
+trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
+		  int nmaskbits)
+{
+	int len =3D (PAGE_SIZE - 1) - s->len;
+	int ret;
+
+	if (s->full || !len)
+		return 0;
+
+	ret =3D bitmap_scnprintf(s->buffer, len, maskp, nmaskbits);
+	s->len +=3D ret;
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(trace_seq_bitmask);
+
+/**
  * trace_seq_vprintf - sequence printing of trace information
  * @s: trace sequence descriptor
  * @fmt: printf format string
@@ -399,6 +427,19 @@ EXPORT_SYMBOL(ftrace_print_symbols_seq_u64);
 #endif
=20
 const char *
+ftrace_print_bitmask_seq(struct trace_seq *p, void *bitmask_ptr,
+			 unsigned int bitmask_size)
+{
+	const char *ret =3D p->buffer + p->len;
+
+	trace_seq_bitmask(p, bitmask_ptr, bitmask_size * 8);
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ftrace_print_bitmask_seq);
+
+const char *
 ftrace_print_hex_seq(struct trace_seq *p, const unsigned char *buf, int bu=
f_len)
 {
 	int i;
--=20
1.8.1.4



--MP_//lFGoIrGeslueE8fEVKZr4A
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=print-cpumask.patch

diff --git a/event-parse.c b/event-parse.c
index 114b41b..ca0d1fe 100644
--- a/event-parse.c
+++ b/event-parse.c
@@ -753,6 +753,9 @@ static void free_arg(struct print_arg *arg)
 	case PRINT_BSTRING:
 		free(arg->string.string);
 		break;
+	case PRINT_BITMASK:
+		free(arg->bitmask.bitmask);
+		break;
 	case PRINT_DYNAMIC_ARRAY:
 		free(arg->dynarray.index);
 		break;
@@ -2256,6 +2259,7 @@ static int arg_num_eval(struct print_arg *arg, long long *val)
 	case PRINT_FIELD ... PRINT_SYMBOL:
 	case PRINT_STRING:
 	case PRINT_BSTRING:
+	case PRINT_BITMASK:
 	default:
 		do_warning("invalid eval type %d", arg->type);
 		ret = 0;
@@ -2284,6 +2288,7 @@ static char *arg_eval (struct print_arg *arg)
 	case PRINT_FIELD ... PRINT_SYMBOL:
 	case PRINT_STRING:
 	case PRINT_BSTRING:
+	case PRINT_BITMASK:
 	default:
 		do_warning("invalid eval type %d", arg->type);
 		break;
@@ -2670,6 +2675,35 @@ process_str(struct event_format *event __maybe_unused, struct print_arg *arg,
 	return EVENT_ERROR;
 }
 
+static enum event_type
+process_bitmask(struct event_format *event __maybe_unused, struct print_arg *arg,
+	    char **tok)
+{
+	enum event_type type;
+	char *token;
+
+	if (read_expect_type(EVENT_ITEM, &token) < 0)
+		goto out_free;
+
+	arg->type = PRINT_BITMASK;
+	arg->bitmask.bitmask = token;
+	arg->bitmask.offset = -1;
+
+	if (read_expected(EVENT_DELIM, ")") < 0)
+		goto out_err;
+
+	type = read_token(&token);
+	*tok = token;
+
+	return type;
+
+ out_free:
+	free_token(token);
+ out_err:
+	*tok = NULL;
+	return EVENT_ERROR;
+}
+
 static struct pevent_function_handler *
 find_func_handler(struct pevent *pevent, char *func_name)
 {
@@ -2781,6 +2815,10 @@ process_function(struct event_format *event, struct print_arg *arg,
 		free_token(token);
 		return process_str(event, arg, tok);
 	}
+	if (strcmp(token, "__get_bitmask") == 0) {
+		free_token(token);
+		return process_bitmask(event, arg, tok);
+	}
 	if (strcmp(token, "__get_dynamic_array") == 0) {
 		free_token(token);
 		return process_dynamic_array(event, arg, tok);
@@ -3307,6 +3345,7 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 		return eval_type(val, arg, 0);
 	case PRINT_STRING:
 	case PRINT_BSTRING:
+	case PRINT_BITMASK:
 		return 0;
 	case PRINT_FUNC: {
 		struct trace_seq s;
@@ -3538,6 +3577,60 @@ static void print_str_to_seq(struct trace_seq *s, const char *format,
 		trace_seq_printf(s, format, str);
 }
 
+static void print_bitmask_to_seq(struct pevent *pevent,
+				 struct trace_seq *s, const char *format,
+				 int len_arg, const void *data, int size)
+{
+	int nr_bits = size * 8;
+	int str_size = (nr_bits + 3) / 4;
+	int len = 0;
+	char buf[3];
+	char *str;
+	int index;
+	int i;
+
+	/*
+	 * The kernel likes to put in commas every 32 bits, we
+	 * can do the same.
+	 */
+	str_size += nr_bits / 32;
+
+	str = malloc(str_size + 1);
+	if (!str) {
+		do_warning("%s: not enough memory!", __func__);
+		return;
+	}
+	str[str_size] = 0;
+
+	/* Start out with -3, 1 for the \0 and two for the byte */
+	for (i = str_size - 3; i >= 0; i -= 2) {
+		/*
+		 * data points to a bit mask of size bytes.
+		 * In the kernel, this is an array of long words, thus
+		 * endianess is very important.
+		 */
+		if (pevent->file_bigendian)
+			index = size - (len + 1);
+		else
+			index = len;
+
+		snprintf(buf, 3, "%02x", *((unsigned char *)data + index));
+		memcpy(str + i, buf, 2);
+		len++;
+		if (!(len & 3) && i > 0) {
+			i--;
+			str[i] = ',';
+		}
+	}			
+
+	if (len_arg >= 0)
+		trace_seq_printf(s, format, len_arg, str);
+	else
+		trace_seq_printf(s, format, str);
+
+	free(str);
+}
+
 static void print_str_arg(struct trace_seq *s, void *data, int size,
 			  struct event_format *event, const char *format,
 			  int len_arg, struct print_arg *arg)
@@ -3672,6 +3765,23 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	case PRINT_BSTRING:
 		print_str_to_seq(s, format, len_arg, arg->string.string);
 		break;
+	case PRINT_BITMASK: {
+		int bitmask_offset;
+		int bitmask_size;
+
+		if (arg->bitmask.offset == -1) {
+			struct format_field *f;
+
+			f = pevent_find_any_field(event, arg->bitmask.bitmask);
+			arg->bitmask.offset = f->offset;
+		}
+		bitmask_offset = data2host4(pevent, data + arg->string.offset);
+		bitmask_size = bitmask_offset >> 16;
+		bitmask_offset &= 0xffff;
+		print_bitmask_to_seq(pevent, s, format, len_arg,
+				     data + bitmask_offset, bitmask_size);
+		break;
+	}
 	case PRINT_OP:
 		/*
 		 * The only op for string should be ? :
@@ -4889,6 +4999,9 @@ static void print_args(struct print_arg *args)
 	case PRINT_BSTRING:
 		printf("__get_str(%s)", args->string.string);
 		break;
+	case PRINT_BITMASK:
+		printf("__get_bitmask(%s)", args->bitmask.bitmask);
+		break;
 	case PRINT_TYPE:
 		printf("(%s)", args->typecast.type);
 		print_args(args->typecast.item);
diff --git a/event-parse.h b/event-parse.h
index 108a4ef..babd4a4 100644
--- a/event-parse.h
+++ b/event-parse.h
@@ -211,6 +211,11 @@ struct print_arg_string {
 	int			offset;
 };
 
+struct print_arg_bitmask {
+	char			*bitmask;
+	int			offset;
+};
+
 struct print_arg_field {
 	char			*name;
 	struct format_field	*field;
@@ -277,6 +282,7 @@ enum print_arg_type {
 	PRINT_DYNAMIC_ARRAY,
 	PRINT_OP,
 	PRINT_FUNC,
+	PRINT_BITMASK,
 };
 
 struct print_arg {
@@ -291,6 +297,7 @@ struct print_arg {
 		struct print_arg_hex		hex;
 		struct print_arg_func		func;
 		struct print_arg_string		string;
+		struct print_arg_bitmask	bitmask;
 		struct print_arg_op		op;
 		struct print_arg_dynarray	dynarray;
 	};

--MP_//lFGoIrGeslueE8fEVKZr4A--
