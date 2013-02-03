Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab3BCTYJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 14:24:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50794 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab3BCTYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 14:24:07 -0500
Date: Sun, 3 Feb 2013 11:23:51 -0800
From: tip-bot for Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Message-ID: <tip-2fd196ec1eab2623096e7fc7e6f3976160392bce@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, hiraku.toyooka.gu@hitachi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hiraku.toyooka.gu@hitachi.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20121226025252.3252.9276.stgit@liselsia>
References: <20121226025252.3252.9276.stgit@liselsia>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing:
  Replace static old_tracer check of tracer name
Git-Commit-ID: 2fd196ec1eab2623096e7fc7e6f3976160392bce
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 03 Feb 2013 11:23:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2fd196ec1eab2623096e7fc7e6f3976160392bce
Gitweb:     http://git.kernel.org/tip/2fd196ec1eab2623096e7fc7e6f3976160392bce
Author:     Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
AuthorDate: Wed, 26 Dec 2012 11:52:52 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 30 Jan 2013 11:02:05 -0500

tracing: Replace static old_tracer check of tracer name

Currently the trace buffer read functions use a static variable
"old_tracer" for detecting if the current tracer changes. This
was suitable for a single trace file ("trace"), but to add a
snapshot feature that will use the same function for its file,
a check against a static variable is not sufficient.

To use the output functions for two different files, instead of
storing the current tracer in a static variable, as the trace
iterator descriptor contains a pointer to the original current
tracer's name, that pointer can now be used to check if the
current tracer has changed between different reads of the trace
file.

Link: http://lkml.kernel.org/r/20121226025252.3252.9276.stgit@liselsia

Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 90a1c71..2c72466 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1948,18 +1948,20 @@ void tracing_iter_reset(struct trace_iterator *iter, int cpu)
 static void *s_start(struct seq_file *m, loff_t *pos)
 {
 	struct trace_iterator *iter = m->private;
-	static struct tracer *old_tracer;
 	int cpu_file = iter->cpu_file;
 	void *p = NULL;
 	loff_t l = 0;
 	int cpu;
 
-	/* copy the tracer to avoid using a global lock all around */
+	/*
+	 * copy the tracer to avoid using a global lock all around.
+	 * iter->trace is a copy of current_trace, the pointer to the
+	 * name may be used instead of a strcmp(), as iter->trace->name
+	 * will point to the same string as current_trace->name.
+	 */
 	mutex_lock(&trace_types_lock);
-	if (unlikely(old_tracer != current_trace && current_trace)) {
-		old_tracer = current_trace;
+	if (unlikely(current_trace && iter->trace->name != current_trace->name))
 		*iter->trace = *current_trace;
-	}
 	mutex_unlock(&trace_types_lock);
 
 	atomic_inc(&trace_record_cmdline_disabled);
@@ -3494,7 +3496,6 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 		  size_t cnt, loff_t *ppos)
 {
 	struct trace_iterator *iter = filp->private_data;
-	static struct tracer *old_tracer;
 	ssize_t sret;
 
 	/* return any leftover data */
@@ -3506,10 +3507,8 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 
 	/* copy the tracer to avoid using a global lock all around */
 	mutex_lock(&trace_types_lock);
-	if (unlikely(old_tracer != current_trace && current_trace)) {
-		old_tracer = current_trace;
+	if (unlikely(current_trace && iter->trace->name != current_trace->name))
 		*iter->trace = *current_trace;
-	}
 	mutex_unlock(&trace_types_lock);
 
 	/*
@@ -3665,7 +3664,6 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 		.ops		= &tracing_pipe_buf_ops,
 		.spd_release	= tracing_spd_release_pipe,
 	};
-	static struct tracer *old_tracer;
 	ssize_t ret;
 	size_t rem;
 	unsigned int i;
@@ -3675,10 +3673,8 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 
 	/* copy the tracer to avoid using a global lock all around */
 	mutex_lock(&trace_types_lock);
-	if (unlikely(old_tracer != current_trace && current_trace)) {
-		old_tracer = current_trace;
+	if (unlikely(current_trace && iter->trace->name != current_trace->name))
 		*iter->trace = *current_trace;
-	}
 	mutex_unlock(&trace_types_lock);
 
 	mutex_lock(&iter->mutex);
