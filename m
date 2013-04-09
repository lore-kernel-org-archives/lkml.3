Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936039Ab3DITf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:35:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935999Ab3DITfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:35:23 -0400
Date: Tue, 9 Apr 2013 21:32:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/7] uprobes/tracing: Make seq_printf() code
	uretprobe-friendly
Message-ID: <20130409193241.GA27254@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409193200.GA26731@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change probes_seq_show() and print_uprobe_event() to check
is_ret_probe() and print the correct data.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Tested-by: Anton Arapov <anton@redhat.com>
---
 kernel/trace/trace_uprobe.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 4575762..8c9f489 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -435,9 +435,10 @@ static void probes_seq_stop(struct seq_file *m, void *v)
 static int probes_seq_show(struct seq_file *m, void *v)
 {
 	struct trace_uprobe *tu = v;
+	char c = is_ret_probe(tu) ? 'r' : 'p';
 	int i;
 
-	seq_printf(m, "p:%s/%s", tu->call.class->system, tu->call.name);
+	seq_printf(m, "%c:%s/%s", c, tu->call.class->system, tu->call.name);
 	seq_printf(m, " %s:0x%p", tu->filename, (void *)tu->offset);
 
 	for (i = 0; i < tu->nr_args; i++)
@@ -566,10 +567,18 @@ print_uprobe_event(struct trace_iterator *iter, int flags, struct trace_event *e
 	entry = (struct uprobe_trace_entry_head *)iter->ent;
 	tu = container_of(event, struct trace_uprobe, call.event);
 
-	if (!trace_seq_printf(s, "%s: (0x%lx)", tu->call.name, entry->vaddr[0]))
-		goto partial;
+	if (is_ret_probe(tu)) {
+		if (!trace_seq_printf(s, "%s: (0x%lx <- 0x%lx)", tu->call.name,
+					entry->vaddr[1], entry->vaddr[0]))
+			goto partial;
+		data = DATAOF_TRACE_ENTRY(entry, true);
+	} else {
+		if (!trace_seq_printf(s, "%s: (0x%lx)", tu->call.name,
+					entry->vaddr[0]))
+			goto partial;
+		data = DATAOF_TRACE_ENTRY(entry, false);
+	}
 
-	data = DATAOF_TRACE_ENTRY(entry, false);
 	for (i = 0; i < tu->nr_args; i++) {
 		if (!tu->args[i].type->print(s, tu->args[i].name,
 					     data + tu->args[i].offset, entry))
-- 
1.5.5.1

