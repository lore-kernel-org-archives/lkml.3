Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3KDSEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:04:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38143 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab3KDSDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 13:03:52 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Howard Cochran <hcochran@lexmark.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 25/29] tools lib traceevent: Handle __print_hex(__get_dynamic_array(fieldname), len)
Date: Mon,  4 Nov 2013 14:59:03 -0300
Message-Id: <1383587947-17419-26-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383587947-17419-1-git-send-email-acme@infradead.org>
References: <1383587947-17419-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Howard Cochran <hcochran@lexmark.com>

The kernel has a few events with a format similar to this excerpt:
        field:unsigned int len;     offset:12;      size:4; signed:0;
        field:__data_loc unsigned char[] data_array;  offset:16;      size:4; signed:0;
print fmt: "%s", __print_hex(__get_dynamic_array(data_array), REC->len)

trace-cmd could already parse that arg correctly, but print_str_arg()
was unable to handle the first parameter being a dynamic array. (It
just printed a "field not found" warning).

Teach print_str_arg's PRINT_HEX case to handle the nested
PRINT_DYNAMIC_ARRAY correctly. The output now matches the kernel's own
formatting for this case.

Signed-off-by: Howard Cochran <hcochran@lexmark.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1381503349-12271-1-git-send-email-hcochran@lexmark.com
[ Removed "polish compare", we don't do that here ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 013c8d3db806..0a1ffe07de3f 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3588,15 +3588,23 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		}
 		break;
 	case PRINT_HEX:
-		field = arg->hex.field->field.field;
-		if (!field) {
-			str = arg->hex.field->field.name;
-			field = pevent_find_any_field(event, str);
-			if (!field)
-				goto out_warning_field;
-			arg->hex.field->field.field = field;
+		if (arg->hex.field->type == PRINT_DYNAMIC_ARRAY) {
+			unsigned long offset;
+			offset = pevent_read_number(pevent,
+				data + arg->hex.field->dynarray.field->offset,
+				arg->hex.field->dynarray.field->size);
+			hex = data + (offset & 0xffff);
+		} else {
+			field = arg->hex.field->field.field;
+			if (!field) {
+				str = arg->hex.field->field.name;
+				field = pevent_find_any_field(event, str);
+				if (!field)
+					goto out_warning_field;
+				arg->hex.field->field.field = field;
+			}
+			hex = data + field->offset;
 		}
-		hex = data + field->offset;
 		len = eval_num_arg(data, size, event, arg->hex.size);
 		for (i = 0; i < len; i++) {
 			if (i)
-- 
1.8.1.4

