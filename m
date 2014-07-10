Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbaGJOTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:19:24 -0400
Received: from service87.mimecast.com ([91.220.42.44]:44682 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbaGJOTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:19:22 -0400
From: "Javi Merino" <javi.merino@arm.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: punit.agrawal@arm.com, broonie@kernel.org,
        Javi Merino <javi.merino@arm.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [RFC PATCH v5 02/10] tools lib traceevent: Generalize numeric argument
Date: Thu, 10 Jul 2014 15:18:40 +0100
Message-Id: <1405001928-12697-3-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405001928-12697-1-git-send-email-javi.merino@arm.com>
References: <1405001928-12697-1-git-send-email-javi.merino@arm.com>
X-OriginalArrivalTime: 10 Jul 2014 14:19:16.0580 (UTC) FILETIME=[EE8D0A40:01CF9C49]
X-MC-Unique: 114071015192001401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s6AELeHq009857

Numeric arguments can be in different bases, so rename it to num so
that they can be used for formats other than PRINT_HEX

Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Javi Merino <javi.merino@arm.com>
---
 tools/lib/traceevent/event-parse.c | 26 +++++++++++++-------------
 tools/lib/traceevent/event-parse.h |  4 ++--
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 93825a17dcce..8a0a8749df4c 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -754,8 +754,8 @@ static void free_arg(struct print_arg *arg)
 		free_flag_sym(arg->symbol.symbols);
 		break;
 	case PRINT_HEX:
-		free_arg(arg->hex.field);
-		free_arg(arg->hex.size);
+		free_arg(arg->num.field);
+		free_arg(arg->num.size);
 		break;
 	case PRINT_TYPE:
 		free(arg->typecast.type);
@@ -2503,7 +2503,7 @@ process_hex(struct event_format *event, struct print_arg *arg, char **tok)
 	if (test_type_token(type, token, EVENT_DELIM, ","))
 		goto out_free;
 
-	arg->hex.field = field;
+	arg->num.field = field;
 
 	free_token(token);
 
@@ -2519,7 +2519,7 @@ process_hex(struct event_format *event, struct print_arg *arg, char **tok)
 	if (test_type_token(type, token, EVENT_DELIM, ")"))
 		goto out_free;
 
-	arg->hex.size = field;
+	arg->num.size = field;
 
 	free_token(token);
 	type = read_token_item(tok);
@@ -3740,24 +3740,24 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		}
 		break;
 	case PRINT_HEX:
-		if (arg->hex.field->type == PRINT_DYNAMIC_ARRAY) {
+		if (arg->num.field->type == PRINT_DYNAMIC_ARRAY) {
 			unsigned long offset;
 			offset = pevent_read_number(pevent,
-				data + arg->hex.field->dynarray.field->offset,
-				arg->hex.field->dynarray.field->size);
+				data + arg->num.field->dynarray.field->offset,
+				arg->num.field->dynarray.field->size);
 			hex = data + (offset & 0xffff);
 		} else {
-			field = arg->hex.field->field.field;
+			field = arg->num.field->field.field;
 			if (!field) {
-				str = arg->hex.field->field.name;
+				str = arg->num.field->field.name;
 				field = pevent_find_any_field(event, str);
 				if (!field)
 					goto out_warning_field;
-				arg->hex.field->field.field = field;
+				arg->num.field->field.field = field;
 			}
 			hex = data + field->offset;
 		}
-		len = eval_num_arg(data, size, event, arg->hex.size);
+		len = eval_num_arg(data, size, event, arg->num.size);
 		for (i = 0; i < len; i++) {
 			if (i)
 				trace_seq_putc(s, ' ');
@@ -4923,9 +4923,9 @@ static void print_args(struct print_arg *args)
 		break;
 	case PRINT_HEX:
 		printf("__print_hex(");
-		print_args(args->hex.field);
+		print_args(args->num.field);
 		printf(", ");
-		print_args(args->hex.size);
+		print_args(args->num.size);
 		printf(")");
 		break;
 	case PRINT_STRING:
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 7a3873ff9a4f..2bf72e908a74 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -240,7 +240,7 @@ struct print_arg_symbol {
 	struct print_flag_sym	*symbols;
 };
 
-struct print_arg_hex {
+struct print_arg_num {
 	struct print_arg	*field;
 	struct print_arg	*size;
 };
@@ -291,7 +291,7 @@ struct print_arg {
 		struct print_arg_typecast	typecast;
 		struct print_arg_flags		flags;
 		struct print_arg_symbol		symbol;
-		struct print_arg_hex		hex;
+		struct print_arg_num		num;
 		struct print_arg_func		func;
 		struct print_arg_string		string;
 		struct print_arg_bitmask	bitmask;
-- 
1.9.1


