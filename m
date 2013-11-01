Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab3KAVzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 17:55:05 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:64451 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754516Ab3KAVzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 17:55:01 -0400
Message-Id: <20131101215500.698924777@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 01 Nov 2013 17:53:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 3/8] tools lib traceevent: If %s is a pointer, check printk formats
References: <20131101215352.875376844@goodmis.org>
Content-Disposition: inline; filename=0003-tools-lib-traceevent-If-s-is-a-pointer-check-printk-.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

If the format string of TP_printk() contains a %s, and the argument
is not a string, check if the argument is a pointer that might match
the printk_formats that were stored.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 856b791..013c8d3 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3505,6 +3505,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	struct pevent *pevent = event->pevent;
 	struct print_flag_sym *flag;
 	struct format_field *field;
+	struct printk_map *printk;
 	unsigned long long val, fval;
 	unsigned long addr;
 	char *str;
@@ -3540,7 +3541,12 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		if (!(field->flags & FIELD_IS_ARRAY) &&
 		    field->size == pevent->long_size) {
 			addr = *(unsigned long *)(data + field->offset);
-			trace_seq_printf(s, "%lx", addr);
+			/* Check if it matches a print format */
+			printk = find_printk(pevent, addr);
+			if (printk)
+				trace_seq_puts(s, printk->printk);
+			else
+				trace_seq_printf(s, "%lx", addr);
 			break;
 		}
 		str = malloc(len + 1);
-- 
1.8.4.rc3


