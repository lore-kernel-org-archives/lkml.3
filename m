Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab3IKFnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:43:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab3IKE5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:11 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=ftTcxSLowJAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=jjDVOA6EzHIA:10 a=6rqHouBjAAAA:8 a=VwQbUJbxAAAA:8 a=l2GMBHiDmj2TBR4rejcA:9 a=TAmEwCHjoHMA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042920.787838637@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andrew Vagin <avagin@openvz.org>
Subject: [171/251] tracing: Fix fields of struct trace_iterator that are zeroed by
 mistake
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0171-tracing-Fix-fields-of-struct-trace_iterator-that-are.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Andrew Vagin <avagin@openvz.org>

[ Upstream commit ed5467da0e369e65b247b99eb6403cb79172bcda ]

tracing_read_pipe zeros all fields bellow "seq". The declaration contains
a comment about that, but it doesn't help.

The first field is "snapshot", it's true when current open file is
snapshot. Looks obvious, that it should not be zeroed.

The second field is "started". It was converted from cpumask_t to
cpumask_var_t (v2.6.28-4983-g4462344), in other words it was
converted from cpumask to pointer on cpumask.

Currently the reference on "started" memory is lost after the first read
from tracing_read_pipe and a proper object will never be freed.

The "started" is never dereferenced for trace_pipe, because trace_pipe
can't have the TRACE_FILE_ANNOTATE options.

Link: http://lkml.kernel.org/r/1375463803-3085183-1-git-send-email-avagin@openvz.org

Cc: stable@vger.kernel.org # 2.6.30
Signed-off-by: Andrew Vagin <avagin@openvz.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    4 +++-
 kernel/trace/trace.c         |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 642928c..86e6806 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -71,6 +71,8 @@ struct trace_iterator {
 	/* trace_seq for __print_flags() and __print_symbolic() etc. */
 	struct trace_seq	tmp_seq;
 
+	cpumask_var_t		started;
+
 	/* The below is zeroed out in pipe_read */
 	struct trace_seq	seq;
 	struct trace_entry	*ent;
@@ -83,7 +85,7 @@ struct trace_iterator {
 	loff_t			pos;
 	long			idx;
 
-	cpumask_var_t		started;
+	/* All new field here will be zeroed out in pipe_read */
 };
 
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a3e9083..0686c13 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3542,6 +3542,7 @@ waitagain:
 	memset(&iter->seq, 0,
 	       sizeof(struct trace_iterator) -
 	       offsetof(struct trace_iterator, seq));
+	cpumask_clear(iter->started);
 	iter->pos = -1;
 
 	trace_event_read_lock();
-- 
1.7.10.4


