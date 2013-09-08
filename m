Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759768Ab3IHDwK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:52:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56134 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756833Ab3IHDTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:00 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Steven Rostedt" <rostedt@goodmis.org>,
        "Andrew Vagin" <avagin@openvz.org>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.751138748@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [057/121] tracing: Fix fields of struct trace_iterator that are
 zeroed by mistake
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: there's no snapshot field]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/ftrace_event.h | 10 ++++++----
 kernel/trace/trace.c         |  1 +
 2 files changed, 7 insertions(+), 4 deletions(-)

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
 
 
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3375,6 +3375,7 @@ waitagain:
 	memset(&iter->seq, 0,
 	       sizeof(struct trace_iterator) -
 	       offsetof(struct trace_iterator, seq));
+	cpumask_clear(iter->started);
 	iter->pos = -1;
 
 	trace_event_read_lock();

