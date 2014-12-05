Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaLETHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:07:51 -0500
Received: from service87.mimecast.com ([91.220.42.44]:35326 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbaLETFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:05:13 -0500
From: "Javi Merino" <javi.merino@arm.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: punit.agrawal@arm.com, broonie@kernel.org,
        Javi Merino <javi.merino@arm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [RFC PATCH v6 3/9] tools lib traceevent: Add support for __print_u{8,16,32,64}_array()
Date: Fri,  5 Dec 2014 19:04:14 +0000
Message-Id: <1417806260-9264-4-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
References: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
X-OriginalArrivalTime: 05 Dec 2014 19:05:09.0798 (UTC) FILETIME=[63CD6460:01D010BE]
X-MC-Unique: 114120519051201301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id sB5J7w7a013877

Trace can now generate traces with u8, u16, u32 and u64 dynamic
arrays.  Add support to parse them.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Javi Merino <javi.merino@arm.com>
---
 tools/lib/traceevent/event-parse.c | 62 +++++++++++++++++++++++++++++++++++---
 tools/lib/traceevent/event-parse.h |  4 +++
 2 files changed, 61 insertions(+), 5 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index f12ea53cc83b..f67260bddd65 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -753,6 +753,10 @@ static void free_arg(struct print_arg *arg)
 		free_arg(arg->symbol.field);
 		free_flag_sym(arg->symbol.symbols);
 		break;
+	case PRINT_U8:
+	case PRINT_U16:
+	case PRINT_U32:
+	case PRINT_U64:
 	case PRINT_HEX:
 		free_arg(arg->num.field);
 		free_arg(arg->num.size);
@@ -2827,6 +2831,22 @@ process_function(struct event_format *event, struct print_arg *arg,
 		free_token(token);
 		return process_hex(event, arg, tok);
 	}
+	if (strcmp(token, "__print_u8_array") == 0) {
+		free_token(token);
+		return process_num(event, arg, tok, PRINT_U8);
+	}
+	if (strcmp(token, "__print_u16_array") == 0) {
+		free_token(token);
+		return process_num(event, arg, tok, PRINT_U16);
+	}
+	if (strcmp(token, "__print_u32_array") == 0) {
+		free_token(token);
+		return process_num(event, arg, tok, PRINT_U32);
+	}
+	if (strcmp(token, "__print_u64_array") == 0) {
+		free_token(token);
+		return process_num(event, arg, tok, PRINT_U64);
+	}
 	if (strcmp(token, "__get_str") == 0) {
 		free_token(token);
 		return process_str(event, arg, tok);
@@ -3355,6 +3375,10 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 		break;
 	case PRINT_FLAGS:
 	case PRINT_SYMBOL:
+	case PRINT_U8:
+	case PRINT_U16:
+	case PRINT_U32:
+	case PRINT_U64:
 	case PRINT_HEX:
 		break;
 	case PRINT_TYPE:
@@ -3660,7 +3684,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	unsigned long long val, fval;
 	unsigned long addr;
 	char *str;
-	unsigned char *hex;
+	void *num;
 	int print;
 	int i, len;
 
@@ -3739,13 +3763,17 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			}
 		}
 		break;
+	case PRINT_U8:
+	case PRINT_U16:
+	case PRINT_U32:
+	case PRINT_U64:
 	case PRINT_HEX:
 		if (arg->num.field->type == PRINT_DYNAMIC_ARRAY) {
 			unsigned long offset;
 			offset = pevent_read_number(pevent,
 				data + arg->num.field->dynarray.field->offset,
 				arg->num.field->dynarray.field->size);
-			hex = data + (offset & 0xffff);
+			num = data + (offset & 0xffff);
 		} else {
 			field = arg->num.field->field.field;
 			if (!field) {
@@ -3755,13 +3783,24 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 					goto out_warning_field;
 				arg->num.field->field.field = field;
 			}
-			hex = data + field->offset;
+			num = data + field->offset;
 		}
 		len = eval_num_arg(data, size, event, arg->num.size);
 		for (i = 0; i < len; i++) {
 			if (i)
 				trace_seq_putc(s, ' ');
-			trace_seq_printf(s, "%02x", hex[i]);
+			if (arg->type == PRINT_HEX)
+				trace_seq_printf(s, "%02x",
+						((uint8_t *)num)[i]);
+			else if (arg->type == PRINT_U8)
+				trace_seq_printf(s, "%u", ((uint8_t *)num)[i]);
+			else if (arg->type == PRINT_U16)
+				trace_seq_printf(s, "%u", ((uint16_t *)num)[i]);
+			else if (arg->type == PRINT_U32)
+				trace_seq_printf(s, "%u", ((uint32_t *)num)[i]);
+			else    /* PRINT_U64 */
+				trace_seq_printf(s, "%lu",
+						((uint64_t *)num)[i]);
 		}
 		break;
 
@@ -4922,7 +4961,20 @@ static void print_args(struct print_arg *args)
 		printf(")");
 		break;
 	case PRINT_HEX:
-		printf("__print_hex(");
+	case PRINT_U8:
+	case PRINT_U16:
+	case PRINT_U32:
+	case PRINT_U64:
+		if (args->type == PRINT_HEX)
+			printf("__print_hex(");
+		else if (args->type == PRINT_U8)
+			printf("__print_u8_array(");
+		else if (args->type == PRINT_U16)
+			printf("__print_u16_array(");
+		else if (args->type == PRINT_U32)
+			printf("__print_u32_array(");
+		else /* PRINT_U64 */
+			printf("__print_u64_array(");
 		print_args(args->num.field);
 		printf(", ");
 		print_args(args->num.size);
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 2bf72e908a74..51f1f0f0a3b5 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -272,6 +272,10 @@ enum print_arg_type {
 	PRINT_FIELD,
 	PRINT_FLAGS,
 	PRINT_SYMBOL,
+	PRINT_U8,
+	PRINT_U16,
+	PRINT_U32,
+	PRINT_U64,
 	PRINT_HEX,
 	PRINT_TYPE,
 	PRINT_STRING,
-- 
1.9.1


