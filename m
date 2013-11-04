Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab3KDUW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:22:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50121 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab3KDUW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:22:56 -0500
Date: Mon, 4 Nov 2013 12:22:42 -0800
From: "tip-bot for Steven Rostedt (Red Hat)" <tipbot@zytor.com>
Message-ID: <tip-0970b5f438261216afcd0ccaa2fcfffc83df7ca2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <20131101215500.698924777@goodmis.org>
References: <20131101215500.698924777@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: If %s is a pointer,
  check printk formats
Git-Commit-ID: 0970b5f438261216afcd0ccaa2fcfffc83df7ca2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 04 Nov 2013 12:22:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0970b5f438261216afcd0ccaa2fcfffc83df7ca2
Gitweb:     http://git.kernel.org/tip/0970b5f438261216afcd0ccaa2fcfffc83df7ca2
Author:     Steven Rostedt (Red Hat) <rostedt@goodmis.org>
AuthorDate: Fri, 1 Nov 2013 17:53:55 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 4 Nov 2013 14:34:26 -0300

tools lib traceevent: If %s is a pointer, check printk formats

If the format string of TP_printk() contains a %s, and the argument is
not a string, check if the argument is a pointer that might match the
printk_formats that were stored.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20131101215500.698924777@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
