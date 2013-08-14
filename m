Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578Ab3HNKiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:38:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34618 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344Ab3HNKiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:38:10 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrew Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 49/75] tracing: Fix fields of struct trace_iterator that are zeroed by mistake
Date: Wed, 14 Aug 2013 11:36:38 +0100
Message-Id: <1376476624-10011-50-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Vagin <avagin@openvz.org>

commit ed5467da0e369e65b247b99eb6403cb79172bcda upstream.

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

Signed-off-by: Andrew Vagin <avagin@openvz.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ luis: backported to 3.5:
  - dropped the 'snapshot' field as it is not present in 3.5 kernel ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/ftrace_event.h | 4 +++-
 kernel/trace/trace.c         | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 176a939..16cad53 100644
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
index 8aba3f9..09739c6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3526,6 +3526,7 @@ waitagain:
 	memset(&iter->seq, 0,
 	       sizeof(struct trace_iterator) -
 	       offsetof(struct trace_iterator, seq));
+	cpumask_clear(iter->started);
 	iter->pos = -1;
 
 	trace_event_read_lock();
-- 
1.8.3.2

