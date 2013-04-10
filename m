Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934660Ab3DJBaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 21:30:13 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55451 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762730Ab3DJBaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 21:30:12 -0400
X-AuditID: 9c930197-b7b50ae00000018c-63-5164c0a10b3b
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing: Check cpu file on tracing_release()
References: <1365553093-10180-1-git-send-email-namhyung@kernel.org>
	<1365553093-10180-3-git-send-email-namhyung@kernel.org>
	<1365553863.25498.84.camel@gandalf.local.home>
	<5164B3F0.2030506@lge.com>
	<1365554787.25498.88.camel@gandalf.local.home>
Date: Wed, 10 Apr 2013 10:30:07 +0900
In-Reply-To: <1365554787.25498.88.camel@gandalf.local.home> (Steven Rostedt's
	message of "Tue, 09 Apr 2013 20:46:27 -0400")
Message-ID: <878v4rtbog.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Apr 2013 20:46:27 -0400, Steven Rostedt wrote:
> On Wed, 2013-04-10 at 09:36 +0900, Namhyung Kim wrote:
>
>> You meant iter->cpu_file != RING_BUFFER_ALL_CPUS case, right?
>
> Yep.
>
>> 
>> So why bother trying to check other cpus then?
>
> Because it's a very slow path (closing a file), and it keeps the code
> simpler and more condense.
>
> We could add your change for consistency, but right now, its very low
> priority.

Hmm.. okay.

>
> But looking at the code, I do see a clean up that looks like it would be
> worth updating. If the ring_buffer_read_prepare() fails, we should
> probably let the user know, instead of succeeding and then having no
> output.

How about below.. :)


>From 7ba245dba217ef858b467552019acd49f7fdce7e Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung.kim@lge.com>
Date: Wed, 10 Apr 2013 09:10:44 +0900
Subject: [PATCH] tracing: Check result of ring_buffer_read_prepare()

The ring_buffer_read_prepare() can return NULL if memory allocation
fails.  Fail out in this case instead of succedding and then having
no output.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7270460cfe3c..3b3514dc8e5e 100644
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
@@ -2847,6 +2852,26 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
 
 	return iter;
 
+free:
+	if (iter->cpu_file == RING_BUFFER_ALL_CPUS) {
+		for_each_tracing_cpu(cpu) {
+			if (iter->buffer_iter[cpu])
+				ring_buffer_read_finish(iter->buffer_iter[cpu]);
+		}
+	} else {
+		cpu = iter->cpu_file;
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

