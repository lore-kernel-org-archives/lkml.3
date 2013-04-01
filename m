Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172Ab3DAQMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 12:12:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759153Ab3DAQM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 12:12:27 -0400
Date: Mon, 1 Apr 2013 18:08:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] uprobes/tracing: Make register_uprobe_event() paths
	uretprobe-friendly
Message-ID: <20130401160854.GA19583@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130401160827.GA19206@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change uprobe_event_define_fields(), and __set_print_fmt() to check
is_ret_probe() and use the appropriate format/fields.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_uprobe.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index db2718a..f75e52d 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -631,8 +631,14 @@ static int uprobe_event_define_fields(struct ftrace_event_call *event_call)
 	struct uprobe_trace_entry_head field;
 	struct trace_uprobe *tu = event_call->data;
 
-	DEFINE_FIELD(unsigned long, vaddr[0], FIELD_STRING_IP, 0);
-	size = SIZEOF_TRACE_ENTRY(1);
+	if (is_ret_probe(tu)) {
+		DEFINE_FIELD(unsigned long, vaddr[0], FIELD_STRING_FUNC, 0);
+		DEFINE_FIELD(unsigned long, vaddr[1], FIELD_STRING_RETIP, 0);
+		size = SIZEOF_TRACE_ENTRY(2);
+	} else {
+		DEFINE_FIELD(unsigned long, vaddr[0], FIELD_STRING_IP, 0);
+		size = SIZEOF_TRACE_ENTRY(1);
+	}
 	/* Set argument names as fields */
 	for (i = 0; i < tu->nr_args; i++) {
 		ret = trace_define_field(event_call, tu->args[i].type->fmttype,
@@ -655,8 +661,13 @@ static int __set_print_fmt(struct trace_uprobe *tu, char *buf, int len)
 	int i;
 	int pos = 0;
 
-	fmt = "(%lx)";
-	arg = "REC->" FIELD_STRING_IP;
+	if (is_ret_probe(tu)) {
+		fmt = "(%lx <- %lx)";
+		arg = "REC->" FIELD_STRING_FUNC ", REC->" FIELD_STRING_RETIP;
+	} else {
+		fmt = "(%lx)";
+		arg = "REC->" FIELD_STRING_IP;
+	}
 
 	/* When len=0, we just calculate the needed length */
 
-- 
1.5.5.1

