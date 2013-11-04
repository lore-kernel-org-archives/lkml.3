Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab3KDUXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:23:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50152 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab3KDUXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:23:09 -0500
Date: Mon, 4 Nov 2013 12:22:51 -0800
From: tip-bot for Howard Cochran <tipbot@zytor.com>
Message-ID: <tip-b30f75eba27a9ab0704cbc501e9be3b025ce56fe@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        hcochran@lexmark.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        hcochran@lexmark.com
In-Reply-To: <1381503349-12271-1-git-send-email-hcochran@lexmark.com>
References: <1381503349-12271-1-git-send-email-hcochran@lexmark.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Handle __print_hex(
 __get_dynamic_array(fieldname), len)
Git-Commit-ID: b30f75eba27a9ab0704cbc501e9be3b025ce56fe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 04 Nov 2013 12:22:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b30f75eba27a9ab0704cbc501e9be3b025ce56fe
Gitweb:     http://git.kernel.org/tip/b30f75eba27a9ab0704cbc501e9be3b025ce56fe
Author:     Howard Cochran <hcochran@lexmark.com>
AuthorDate: Fri, 1 Nov 2013 17:53:56 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 4 Nov 2013 14:34:43 -0300

tools lib traceevent: Handle __print_hex(__get_dynamic_array(fieldname), len)

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
