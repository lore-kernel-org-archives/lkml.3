Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab3HMGkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:40:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60760 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757456Ab3HMGei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:34:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrew Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: [ 09/12] tracing: Fix fields of struct trace_iterator that are zeroed by mistake
Date: Mon, 12 Aug 2013 23:35:44 -0700
Message-Id: <20130813063520.998105519@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063520.285638946@linuxfoundation.org>
References: <20130813063520.285638946@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/ftrace_event.h |    4 +++-
 kernel/trace/trace.c         |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

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
@@ -82,7 +84,7 @@ struct trace_iterator {
 	loff_t			pos;
 	long			idx;
 
-	cpumask_var_t		started;
+	/* All new field here will be zeroed out in pipe_read */
 };
 
 
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3245,6 +3245,7 @@ waitagain:
 	memset(&iter->seq, 0,
 	       sizeof(struct trace_iterator) -
 	       offsetof(struct trace_iterator, seq));
+	cpumask_clear(iter->started);
 	iter->pos = -1;
 
 	trace_event_read_lock();


