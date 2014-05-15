Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaEOLeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 07:34:10 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:40792 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751378AbaEOLeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 07:34:08 -0400
Date: Thu, 15 May 2014 07:34:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Javi Merino <javi.merino@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH v3] tracing: Add __bitmask() macro to trace events
 to cpumasks and other bitmasks
Message-ID: <20140515073405.11002d59@gandalf.local.home>
In-Reply-To: <20140514194241.GA3883@e102654-lin.cambridge.arm.com>
References: <1399377998-14870-1-git-send-email-javi.merino@arm.com>
	<1399377998-14870-6-git-send-email-javi.merino@arm.com>
	<20140506132238.22e136d1@gandalf.local.home>
	<484888063.12149.1399403794855.JavaMail.zimbra@efficios.com>
	<20140506231238.246c7d3e@gandalf.local.home>
	<20140514142324.GA10024@e102654-lin.cambridge.arm.com>
	<20140514113623.171f2a39@gandalf.local.home>
	<20140514155053.GB3052@e102654-lin.cambridge.arm.com>
	<20140514142500.020e9896@gandalf.local.home>
	<20140514194241.GA3883@e102654-lin.cambridge.arm.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/lQ54VsR8pj3FSqA0YDCQHbL"
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/lQ54VsR8pj3FSqA0YDCQHbL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, 14 May 2014 20:42:41 +0100
Javi Merino <javi.merino@arm.com> wrote:


> It looks like an off-by-one error.  The system that generated the
> trace.dat is running a kernel configured with NR_CPUS=5, can that be
> the culprit?

You were correct! Actually, I had two off by one errors :-/

One was with calculating the number of added commas

-	str_size += nr_bits / 32;
+	str_size += (nr_bits - 1) / 32

No comma if the we have exactly 32 bits (only one if we have 64).

The other was with the start:

-	for (i = str_size - 3; i >= 0; i -= 2) {
+	for (i = str_size - 2; i >= 0; i -= 2) {

I included the '\0' when I didn't have to :-p

Should work now. Thanks for testing.

-- Steve

--MP_/lQ54VsR8pj3FSqA0YDCQHbL
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=print-cpumask.patch

---
 event-parse.c |  113 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 event-parse.h |    7 +++
 2 files changed, 120 insertions(+)

Index: trace-cmd.git/event-parse.c
===================================================================
--- trace-cmd.git.orig/event-parse.c	2014-05-15 07:29:18.552527943 -0400
+++ trace-cmd.git/event-parse.c	2014-05-15 07:29:54.483122795 -0400
@@ -753,6 +753,9 @@
 	case PRINT_BSTRING:
 		free(arg->string.string);
 		break;
+	case PRINT_BITMASK:
+		free(arg->bitmask.bitmask);
+		break;
 	case PRINT_DYNAMIC_ARRAY:
 		free(arg->dynarray.index);
 		break;
@@ -2256,6 +2259,7 @@
 	case PRINT_FIELD ... PRINT_SYMBOL:
 	case PRINT_STRING:
 	case PRINT_BSTRING:
+	case PRINT_BITMASK:
 	default:
 		do_warning("invalid eval type %d", arg->type);
 		ret = 0;
@@ -2284,6 +2288,7 @@
 	case PRINT_FIELD ... PRINT_SYMBOL:
 	case PRINT_STRING:
 	case PRINT_BSTRING:
+	case PRINT_BITMASK:
 	default:
 		do_warning("invalid eval type %d", arg->type);
 		break;
@@ -2670,6 +2675,35 @@
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
@@ -2781,6 +2815,10 @@
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
@@ -3307,6 +3345,7 @@
 		return eval_type(val, arg, 0);
 	case PRINT_STRING:
 	case PRINT_BSTRING:
+	case PRINT_BITMASK:
 		return 0;
 	case PRINT_FUNC: {
 		struct trace_seq s;
@@ -3538,6 +3577,60 @@
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
@@ -3672,6 +3765,23 @@
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
@@ -4889,6 +4999,9 @@
 	case PRINT_BSTRING:
 		printf("__get_str(%s)", args->string.string);
 		break;
+	case PRINT_BITMASK:
+		printf("__get_bitmask(%s)", args->bitmask.bitmask);
+		break;
 	case PRINT_TYPE:
 		printf("(%s)", args->typecast.type);
 		print_args(args->typecast.item);
Index: trace-cmd.git/event-parse.h
===================================================================
--- trace-cmd.git.orig/event-parse.h	2014-05-15 07:29:18.552527943 -0400
+++ trace-cmd.git/event-parse.h	2014-05-15 07:29:19.772514187 -0400
@@ -211,6 +211,11 @@
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
@@ -277,6 +282,7 @@
 	PRINT_DYNAMIC_ARRAY,
 	PRINT_OP,
 	PRINT_FUNC,
+	PRINT_BITMASK,
 };
 
 struct print_arg {
@@ -291,6 +297,7 @@
 		struct print_arg_hex		hex;
 		struct print_arg_func		func;
 		struct print_arg_string		string;
+		struct print_arg_bitmask	bitmask;
 		struct print_arg_op		op;
 		struct print_arg_dynarray	dynarray;
 	};

--MP_/lQ54VsR8pj3FSqA0YDCQHbL--
