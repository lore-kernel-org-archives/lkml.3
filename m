Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935724Ab3DJBzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 21:55:43 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55764 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765536Ab3DJBzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 21:55:42 -0400
X-AuditID: 9c930197-b7b50ae00000018c-97-5164c69648b4
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH] tracing: Check result of ring_buffer_read_prepare()
Date: Wed, 10 Apr 2013 10:55:29 +0900
Message-Id: <1365558929-11211-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1365558422.25498.93.camel@gandalf.local.home>
References: <1365558422.25498.93.camel@gandalf.local.home>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The ring_buffer_read_prepare() can return NULL if memory allocation
fails.  Fail out in this case instead of succedding and then having
no output.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7270460cfe3c..13200de31f0b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2826,6 +2826,8 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
 		for_each_tracing_cpu(cpu) {
 			iter->buffer_iter[cpu] =
 				ring_buffer_read_prepare(iter->trace_buffer->buffer, cpu);
+			if (!iter->buffer_iter[cpu])
+				goto free;
 		}
 		ring_buffer_read_prepare_sync();
 		for_each_tracing_cpu(cpu) {
@@ -2836,6 +2838,9 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
 		cpu = iter->cpu_file;
 		iter->buffer_iter[cpu] =
 			ring_buffer_read_prepare(iter->trace_buffer->buffer, cpu);
+		if (!iter->buffer_iter[cpu])
+			goto free;
+
 		ring_buffer_read_prepare_sync();
 		ring_buffer_read_start(iter->buffer_iter[cpu]);
 		tracing_iter_reset(iter, cpu);
@@ -2847,6 +2852,23 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
 
 	return iter;
 
+free:
+	/*
+	 * For simplicity, just keep single loop without comparing cpu_file.
+	 */
+	for_each_tracing_cpu(cpu) {
+		if (iter->buffer_iter[cpu])
+			ring_buffer_read_finish(iter->buffer_iter[cpu]);
+	}
+
+	if (iter->trace && iter->trace->close)
+		iter->trace->close(iter);
+
+	if (!iter->snapshot)
+		tracing_start_tr(tr);
+
+	mutex_destroy(&iter->mutex);
+	free_cpumask_var(iter->started);
  fail:
 	mutex_unlock(&trace_types_lock);
 	kfree(iter->trace);
-- 
1.7.11.7

