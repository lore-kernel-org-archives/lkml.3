Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab3HCMv7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 08:51:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6277 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab3HCMvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 08:51:19 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=8bem4ONHe1QA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=9mZeSUoYnZoA:10 a=6rqHouBjAAAA:8 a=VwQbUJbxAAAA:8 a=l2GMBHiDmj2TBR4rejcA:9 a=TAmEwCHjoHMA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130803125117.226908504@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 03 Aug 2013 08:49:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, <stable@vger.kernel.org>,
        Andrew Vagin <avagin@openvz.org>
Subject: [for-next-3.11][PATCH 1/4] tracing: Fix fields of struct trace_iterator that are zeroed by
 mistake
References: <20130803124926.157378122@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Fix-fields-of-struct-trace_iterator-that-are.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Vagin <avagin@openvz.org>

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
 include/linux/ftrace_event.h |   10 ++++++----
 kernel/trace/trace.c         |    1 +
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index f98ab06..120d57a 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -78,6 +78,11 @@ struct trace_iterator {
 	/* trace_seq for __print_flags() and __print_symbolic() etc. */
 	struct trace_seq	tmp_seq;
 
+	cpumask_var_t		started;
+
+	/* it's true when current open file is snapshot */
+	bool			snapshot;
+
 	/* The below is zeroed out in pipe_read */
 	struct trace_seq	seq;
 	struct trace_entry	*ent;
@@ -90,10 +95,7 @@ struct trace_iterator {
 	loff_t			pos;
 	long			idx;
 
-	cpumask_var_t		started;
-
-	/* it's true when current open file is snapshot */
-	bool			snapshot;
+	/* All new field here will be zeroed out in pipe_read */
 };
 
 enum trace_iter_flags {
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 882ec1d..f5b35a5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4151,6 +4151,7 @@ waitagain:
 	memset(&iter->seq, 0,
 	       sizeof(struct trace_iterator) -
 	       offsetof(struct trace_iterator, seq));
+	cpumask_clear(iter->started);
 	iter->pos = -1;
 
 	trace_event_read_lock();
-- 
1.7.10.4


