Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964791AbaFLMBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:01:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60514 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933535AbaFLMBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:01:35 -0400
Date: Thu, 12 Jun 2014 05:01:13 -0700
From: "tip-bot for Steven Rostedt (Red Hat)" <tipbot@zytor.com>
Message-ID: <tip-473a778a2f2949972b52ad7fc61577f381f2d05e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, namhyung@kernel.org, javi.merino@arm.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, javi.merino@arm.com, namhyung@kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20140603032224.229186537@goodmis.org>
References: <20140506132238.22e136d1@gandalf.local.home>
	<20140603032224.229186537@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Added support for __get_bitmask() macro
Git-Commit-ID: 473a778a2f2949972b52ad7fc61577f381f2d05e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  473a778a2f2949972b52ad7fc61577f381f2d05e
Gitweb:     http://git.kernel.org/tip/473a778a2f2949972b52ad7fc61577f381f2d05e
Author:     Steven Rostedt (Red Hat) <rostedt@goodmis.org>
AuthorDate: Mon, 2 Jun 2014 23:20:16 -0400
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Sat, 7 Jun 2014 23:33:37 +0200

tools lib traceevent: Added support for __get_bitmask() macro

Coming in v3.16, trace events will be able to save bitmasks in raw
format in the ring buffer and output it with the __get_bitmask() macro.

In order for userspace tools to parse this, it must be able to handle
the __get_bitmask() call and be able to convert the data that's in
the ring buffer into a nice bitmask format. The output is similar to
what the kernel uses to print bitmasks, with a comma separator every
4 bytes (8 characters).

This allows for cpumasks to also be saved efficiently.

The first user is the thermal:thermal_power_limit event which has the
following output:

 thermal_power_limit:  cpus=0000000f freq=1900000 cdev_state=0 power=5252

Link: http://lkml.kernel.org/r/20140506132238.22e136d1@gandalf.local.home

Suggested-by: Javi Merino <javi.merino@arm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Javi Merino <javi.merino@arm.com>
Link: http://lkml.kernel.org/r/20140603032224.229186537@goodmis.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/traceevent/event-parse.c                 | 113 +++++++++++++++++++++
 tools/lib/traceevent/event-parse.h                 |   7 ++
 .../perf/util/scripting-engines/trace-event-perl.c |   1 +
 .../util/scripting-engines/trace-event-python.c    |   1 +
 4 files changed, 122 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index b83184f..93825a1 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -765,6 +765,9 @@ static void free_arg(struct print_arg *arg)
 	case PRINT_BSTRING:
 		free(arg->string.string);
 		break;
+	case PRINT_BITMASK:
+		free(arg->bitmask.bitmask);
+		break;
 	case PRINT_DYNAMIC_ARRAY:
 		free(arg->dynarray.index);
 		break;
@@ -2268,6 +2271,7 @@ static int arg_num_eval(struct print_arg *arg, long long *val)
 	case PRINT_FIELD ... PRINT_SYMBOL:
 	case PRINT_STRING:
 	case PRINT_BSTRING:
+	case PRINT_BITMASK:
 	default:
 		do_warning("invalid eval type %d", arg->type);
 		ret = 0;
@@ -2296,6 +2300,7 @@ static char *arg_eval (struct print_arg *arg)
 	case PRINT_FIELD ... PRINT_SYMBOL:
 	case PRINT_STRING:
 	case PRINT_BSTRING:
+	case PRINT_BITMASK:
 	default:
 		do_warning("invalid eval type %d", arg->type);
 		break;
@@ -2683,6 +2688,35 @@ process_str(struct event_format *event __maybe_unused, struct print_arg *arg,
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
@@ -2797,6 +2831,10 @@ process_function(struct event_format *event, struct print_arg *arg,
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
@@ -3324,6 +3362,7 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 		return eval_type(val, arg, 0);
 	case PRINT_STRING:
 	case PRINT_BSTRING:
+	case PRINT_BITMASK:
 		return 0;
 	case PRINT_FUNC: {
 		struct trace_seq s;
@@ -3556,6 +3595,60 @@ static void print_str_to_seq(struct trace_seq *s, const char *format,
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
+	str_size += (nr_bits - 1) / 32;
+
+	str = malloc(str_size + 1);
+	if (!str) {
+		do_warning("%s: not enough memory!", __func__);
+		return;
+	}
+	str[str_size] = 0;
+
+	/* Start out with -2 for the two chars per byte */
+	for (i = str_size - 2; i >= 0; i -= 2) {
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
@@ -3691,6 +3784,23 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
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
+		bitmask_offset = data2host4(pevent, data + arg->bitmask.offset);
+		bitmask_size = bitmask_offset >> 16;
+		bitmask_offset &= 0xffff;
+		print_bitmask_to_seq(pevent, s, format, len_arg,
+				     data + bitmask_offset, bitmask_size);
+		break;
+	}
 	case PRINT_OP:
 		/*
 		 * The only op for string should be ? :
@@ -4822,6 +4932,9 @@ static void print_args(struct print_arg *args)
 	case PRINT_BSTRING:
 		printf("__get_str(%s)", args->string.string);
 		break;
+	case PRINT_BITMASK:
+		printf("__get_bitmask(%s)", args->bitmask.bitmask);
+		break;
 	case PRINT_TYPE:
 		printf("(%s)", args->typecast.type);
 		print_args(args->typecast.item);
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 56e0e6c..7a3873f 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -208,6 +208,11 @@ struct print_arg_string {
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
@@ -274,6 +279,7 @@ enum print_arg_type {
 	PRINT_DYNAMIC_ARRAY,
 	PRINT_OP,
 	PRINT_FUNC,
+	PRINT_BITMASK,
 };
 
 struct print_arg {
@@ -288,6 +294,7 @@ struct print_arg {
 		struct print_arg_hex		hex;
 		struct print_arg_func		func;
 		struct print_arg_string		string;
+		struct print_arg_bitmask	bitmask;
 		struct print_arg_op		op;
 		struct print_arg_dynarray	dynarray;
 	};
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index e108207..af7da56 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -215,6 +215,7 @@ static void define_event_symbols(struct event_format *event,
 	case PRINT_BSTRING:
 	case PRINT_DYNAMIC_ARRAY:
 	case PRINT_STRING:
+	case PRINT_BITMASK:
 		break;
 	case PRINT_TYPE:
 		define_event_symbols(event, ev_name, args->typecast.item);
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index cd9774d..c3de097 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -197,6 +197,7 @@ static void define_event_symbols(struct event_format *event,
 	case PRINT_BSTRING:
 	case PRINT_DYNAMIC_ARRAY:
 	case PRINT_FUNC:
+	case PRINT_BITMASK:
 		/* we should warn... */
 		return;
 	}
