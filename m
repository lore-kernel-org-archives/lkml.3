Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3HBRRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 13:17:07 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:35345 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab3HBRRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 13:17:06 -0400
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, David Sharp <dhsharp@google.com>,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH] tracing: a few fields of struct trace_iterator are zeroed by mistake
Date: Fri,  2 Aug 2013 21:16:43 +0400
Message-Id: <1375463803-3085183-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tracing_read_pipe zeros all fields bellow "seq". The declaration contains
a comment about that, but it doesn't help.

The first field is "snapshot", it's true when current open file is
snapshot. Looks obvious, that it should not be zeroed.

The second field is "started". It was converted from cpumask_t to
cpumask_var_t (v2.6.28-4983-g4462344) or by another words it was
converted from cpumask to pointer on cpumask.

Currently the reference on "started" memory is lost after the first read
from tracing_read_pipe and a proper object will never be freed.

The "started" is never dereferenced for trace_pipe, because trace_pipe
can't have the TRACE_FILE_ANNOTATE options (why?).

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: David Sharp <dhsharp@google.com>
Cc: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 include/linux/ftrace_event.h |   10 ++++++----
 kernel/trace/trace.c         |    1 +
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 4372658..44cdc11 100644
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
index 0cd500b..897f553 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4166,6 +4166,7 @@ waitagain:
 	memset(&iter->seq, 0,
 	       sizeof(struct trace_iterator) -
 	       offsetof(struct trace_iterator, seq));
+	cpumask_clear(iter->started);
 	iter->pos = -1;
 
 	trace_event_read_lock();
-- 
1.7.1

