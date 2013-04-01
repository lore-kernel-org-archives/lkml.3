Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759131Ab3DAQMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 12:12:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759099Ab3DAQMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 12:12:01 -0400
Date: Mon, 1 Apr 2013 18:08:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] uprobes/tracing: Make seq_printf() code
	uretprobe-friendly
Message-ID: <20130401160857.GA19586@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130401160827.GA19206@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change probes_seq_show() and print_uprobe_event() to check
is_ret_probe() and print the correct data.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_uprobe.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index f75e52d..1b3622a 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -434,9 +434,10 @@ static void probes_seq_stop(struct seq_file *m, void *v)
 static int probes_seq_show(struct seq_file *m, void *v)
 {
 	struct trace_uprobe *tu = v;
+	char c = is_ret_probe(tu) ? 'r' : 'p';
 	int i;
 
-	seq_printf(m, "p:%s/%s", tu->call.class->system, tu->call.name);
+	seq_printf(m, "%c:%s/%s", c, tu->call.class->system, tu->call.name);
 	seq_printf(m, " %s:0x%p", tu->filename, (void *)tu->offset);
 
 	for (i = 0; i < tu->nr_args; i++)
@@ -569,10 +570,18 @@ print_uprobe_event(struct trace_iterator *iter, int flags, struct trace_event *e
 	entry = (struct uprobe_trace_entry_head *)iter->ent;
 	tu = container_of(event, struct trace_uprobe, call.event);
 
-	if (!trace_seq_printf(s, "%s: (0x%lx)", tu->call.name, entry->vaddr[0]))
-		goto partial;
+	if (is_ret_probe(tu)) {
+		if (!trace_seq_printf(s, "%s: (0x%lx <- 0x%lx)", tu->call.name,
+					entry->vaddr[1], entry->vaddr[0]))
+			goto partial;
+		data = DATAOF_TRACE_ENTRY(entry, 2);
+	} else {
+		if (!trace_seq_printf(s, "%s: (0x%lx)", tu->call.name,
+					entry->vaddr[0]))
+			goto partial;
+		data = DATAOF_TRACE_ENTRY(entry, 1);
+	}
 
-	data = DATAOF_TRACE_ENTRY(entry, 1);
 	for (i = 0; i < tu->nr_args; i++) {
 		if (!tu->args[i].type->print(s, tu->args[i].name,
 					     data + tu->args[i].offset, entry))
-- 
1.5.5.1

