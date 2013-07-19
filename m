Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965226Ab3GSOQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:16:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30454 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760569Ab3GSOOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:14:52 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=GIv12JQBCo4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=qxAwZi55NAMA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=-5kFnHe8gWvU2TnmosgA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130719141450.253881041@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 19 Jul 2013 10:12:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next-3.11][PATCH 12/12] tracing: Do not (ab)use trace_seq in event_id_read()
References: <20130719141224.703522101@goodmis.org>
Content-Disposition: inline; filename=0012-tracing-Do-not-ab-use-trace_seq-in-event_id_read.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

event_id_read() has no reason to kmalloc "struct trace_seq"
(more than PAGE_SIZE!), it can use a small buffer instead.

Note: "if (*ppos) return 0" looks strange and even wrong,
simple_read_from_buffer() handles ppos != 0 case corrrectly.

And it seems that almost every user of trace_seq in this file
should be converted too. Unless you use seq_open(), trace_seq
buys nothing compared to the raw buffer, but it needs a bit
more memory and code.

Link: http://lkml.kernel.org/r/20130718184712.GA4786@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 76defd9..898f868 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -947,23 +947,14 @@ static ssize_t
 event_id_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 {
 	struct ftrace_event_call *call = filp->private_data;
-	struct trace_seq *s;
-	int r;
+	char buf[32];
+	int len;
 
 	if (*ppos)
 		return 0;
 
-	s = kmalloc(sizeof(*s), GFP_KERNEL);
-	if (!s)
-		return -ENOMEM;
-
-	trace_seq_init(s);
-	trace_seq_printf(s, "%d\n", call->event.type);
-
-	r = simple_read_from_buffer(ubuf, cnt, ppos,
-				    s->buffer, s->len);
-	kfree(s);
-	return r;
+	len = sprintf(buf, "%d\n", call->event.type);
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, len);
 }
 
 static ssize_t
-- 
1.7.10.4


