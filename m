Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301Ab3JKPjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 11:39:55 -0400
Received: from exprod8og105.obsmtp.com ([64.18.3.90]:34778 "HELO
	exprod8og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752348Ab3JKPjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 11:39:44 -0400
X-Greylist: delayed 1723 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Oct 2013 11:39:44 EDT
From: Howard Cochran <hcochran@lexmark.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Howard Cochran <hcochran@lexmark.com>
Subject: [PATCH] trace-cmd: Handle __print_hex(__get_dynamic_array(fieldname), len)
Date: Fri, 11 Oct 2013 10:55:49 -0400
Message-Id: <1381503349-12271-1-git-send-email-hcochran@lexmark.com>
X-Mailer: git-send-email 1.7.10.2.4.g36f8dc1
X-LPDEV-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: 78153BE0081.A280B
X-LPDEV-MailScanner: Found to be clean
X-LPDEV-MailScanner-From: hcochran@lpdev.prtdev.lexmark.com
X-MIMETrack: Itemize by SMTP Server on smtp5b/Lex/Lexmark(Release 6.5.5|November 30, 2005) at
 10/11/2013 10:56:11,
	Serialize by Router on smtp5b/Lex/Lexmark(Release 6.5.5|November 30, 2005) at
 10/11/2013 10:56:12,
	Serialize complete at 10/11/2013 10:56:12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 event-parse.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/event-parse.c b/event-parse.c
index e961553..fdb176e 100644
--- a/event-parse.c
+++ b/event-parse.c
@@ -3550,15 +3550,23 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
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
+		if (PRINT_DYNAMIC_ARRAY == arg->hex.field->type) {
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
1.7.10.2.4.g36f8dc1

