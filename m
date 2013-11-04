Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab3KDSFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:05:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38138 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab3KDSDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 13:03:52 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 26/29] tools lib traceevent: Have bprintk output the same as the kernel does
Date: Mon,  4 Nov 2013 14:59:04 -0300
Message-Id: <1383587947-17419-27-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383587947-17419-1-git-send-email-acme@infradead.org>
References: <1383587947-17419-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The trace_bprintk() in the kernel looks like:

 ring_buffer_producer_thread: Missed:   0
 ring_buffer_producer_thread: Hit:      62174350
 ring_buffer_producer_thread: Entries per millisec: 6296
 ring_buffer_producer_thread: 158 ns per entry
 ring_buffer_producer_thread: Sleeping for 10 secs
 ring_buffer_producer_thread: Starting ring buffer hammer
 ring_buffer_producer_thread: End ring buffer hammer

But the current output looks like this:

 ring_buffer_producer_thread : Time:     9407018 (usecs)
 ring_buffer_producer_thread : Overruns: 43285485
 ring_buffer_producer_thread : Read:     4405365  (by events)
 ring_buffer_producer_thread : Entries:  0
 ring_buffer_producer_thread : Total:    47690850
 ring_buffer_producer_thread : Missed:   0
 ring_buffer_producer_thread : Hit:      47690850

Remove the space between the function and the colon.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20131101215501.272654481@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 0a1ffe07de3f..e1c743c52834 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3802,8 +3802,8 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 	if (asprintf(&arg->atom.atom, "%lld", ip) < 0)
 		goto out_free;
 
-	/* skip the first "%pf : " */
-	for (ptr = fmt + 6, bptr = data + field->offset;
+	/* skip the first "%pf: " */
+	for (ptr = fmt + 5, bptr = data + field->offset;
 	     bptr < data + size && *ptr; ptr++) {
 		int ls = 0;
 
@@ -3929,12 +3929,12 @@ get_bprint_format(void *data, int size __maybe_unused,
 
 	printk = find_printk(pevent, addr);
 	if (!printk) {
-		if (asprintf(&format, "%%pf : (NO FORMAT FOUND at %llx)\n", addr) < 0)
+		if (asprintf(&format, "%%pf: (NO FORMAT FOUND at %llx)\n", addr) < 0)
 			return NULL;
 		return format;
 	}
 
-	if (asprintf(&format, "%s : %s", "%pf", printk->printk) < 0)
+	if (asprintf(&format, "%s: %s", "%pf", printk->printk) < 0)
 		return NULL;
 
 	return format;
-- 
1.8.1.4

