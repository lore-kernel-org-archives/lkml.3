Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab3KAV4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 17:56:47 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:64451 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754534Ab3KAVzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 17:55:03 -0400
Message-Id: <20131101215500.967802153@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 01 Nov 2013 17:53:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Howard Cochran <hcochran@lexmark.com>
Subject: [PATCH 4/8] tools lib traceevent: Handle
 __print_hex(__get_dynamic_array(fieldname), len)
References: <20131101215352.875376844@goodmis.org>
Content-Disposition: inline; filename=0004-tools-lib-traceevent-Handle-__print_hex-__get_dynami.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
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

Link: http://lkml.kernel.org/r/1381503349-12271-1-git-send-email-hcochran@lexmark.com

Signed-off-by: Howard Cochran <hcochran@lexmark.com>
[ Removed "polish compare", we don't do that here ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 013c8d3..0a1ffe0 100644
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
1.8.4.rc3


