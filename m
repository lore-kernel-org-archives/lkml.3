Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936097Ab3DITfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:35:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935868Ab3DITfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:35:31 -0400
Date: Tue, 9 Apr 2013 21:32:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/7] uprobes/tracing: Make register_uprobe_event() paths
	uretprobe-friendly
Message-ID: <20130409193238.GA27247@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409193200.GA26731@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change uprobe_event_define_fields(), and __set_print_fmt() to check
is_ret_probe() and use the appropriate format/fields.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Tested-by: Anton Arapov <anton@redhat.com>
---
 kernel/trace/trace_uprobe.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 0ed99a2..4575762 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -628,8 +628,14 @@ static int uprobe_event_define_fields(struct ftrace_event_call *event_call)
 	struct uprobe_trace_entry_head field;
 	struct trace_uprobe *tu = event_call->data;
 
-	DEFINE_FIELD(unsigned long, vaddr[0], FIELD_STRING_IP, 0);
-	size = SIZEOF_TRACE_ENTRY(false);
+	if (is_ret_probe(tu)) {
+		DEFINE_FIELD(unsigned long, vaddr[0], FIELD_STRING_FUNC, 0);
+		DEFINE_FIELD(unsigned long, vaddr[1], FIELD_STRING_RETIP, 0);
+		size = SIZEOF_TRACE_ENTRY(true);
+	} else {
+		DEFINE_FIELD(unsigned long, vaddr[0], FIELD_STRING_IP, 0);
+		size = SIZEOF_TRACE_ENTRY(false);
+	}
 	/* Set argument names as fields */
 	for (i = 0; i < tu->nr_args; i++) {
 		ret = trace_define_field(event_call, tu->args[i].type->fmttype,
@@ -652,8 +658,13 @@ static int __set_print_fmt(struct trace_uprobe *tu, char *buf, int len)
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

