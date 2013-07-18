Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483Ab3GRSwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 14:52:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932803Ab3GRSwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 14:52:14 -0400
Date: Thu, 18 Jul 2013 20:47:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] tracing: Do not (ab)use trace_seq in event_id_read()
Message-ID: <20130718184712.GA4786@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718184647.GA4761@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

event_id_read() has no reason to kmalloc "struct trace_seq"
(more than PAGE_SIZE!), it can use a small buffer instead.

Note: "if (*ppos) return 0" looks strange and even wrong,
simple_read_from_buffer() handles ppos != 0 case corrrectly.

And it seems that almost every user of trace_seq in this file
should be converted too. Unless you use seq_open(), trace_seq
buys nothing compared to the raw buffer, but it needs a bit
more memory and code.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_events.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 2c3a8c5..1d2c8db 100644
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
1.5.5.1

