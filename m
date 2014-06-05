Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaFEWfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 18:35:38 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:41938 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaFEWf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 18:35:26 -0400
X-AuditID: 85900ec0-d0927b9000001514-d0-5390f0ab61ae
Subject: [PATCH ftrace/core 3/3] trace: Fix memory leak when new instance
 creation failed
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com
Date: Fri, 06 Jun 2014 07:35:22 +0900
Message-ID: <20140605223522.32311.31664.stgit@yunodevel>
In-Reply-To: <20140605223515.32311.71203.stgit@yunodevel>
References: <20140605223515.32311.71203.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current new_instance_create() implements just two fail paths for four
allocation operations. So, it can induce memory leak if new instance
creation failed. This patch fixes it by defining all fail paths and
freeing allocated memories appropriately.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
---
 kernel/trace/trace.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 473eb68..bbd86d2 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6277,7 +6277,7 @@ static int new_instance_create(const char *name)
 		goto out_free_tr;
 
 	if (!alloc_cpumask_var(&tr->tracing_cpumask, GFP_KERNEL))
-		goto out_free_tr;
+		goto out_free_tr_name;
 
 	cpumask_copy(tr->tracing_cpumask, cpu_all_mask);
 
@@ -6291,16 +6291,16 @@ static int new_instance_create(const char *name)
 	INIT_LIST_HEAD(&tr->events);
 
 	if (allocate_trace_buffers(tr, trace_buf_size) < 0)
-		goto out_free_tr;
+		goto out_free_cpumask_var;
 
 	tr->dir = debugfs_create_dir(name, trace_instance_dir);
 	if (!tr->dir)
-		goto out_free_tr;
+		goto out_free_trace_buffers;
 
 	ret = event_trace_add_tracer(tr->dir, tr);
 	if (ret) {
 		debugfs_remove_recursive(tr->dir);
-		goto out_free_tr;
+		goto out_free_trace_buffers;
 	}
 
 	init_tracer_debugfs(tr, tr->dir);
@@ -6311,18 +6311,23 @@ static int new_instance_create(const char *name)
 
 	return 0;
 
- out_free_tr:
-	if (tr->trace_buffer.buffer)
-		ring_buffer_free(tr->trace_buffer.buffer);
+ out_free_trace_buffers:
+	ring_buffer_free(tr->trace_buffer.buffer);
+	free_percpu(tr->trace_buffer.data);
+#ifdef CONFIG_TRACER_MAX_TRACE
+	ring_buffer_free(tr->max_buffer.buffer);
+	free_percpu(tr->max_buffer.data);
+#endif
+ out_free_cpumask_var:
 	free_cpumask_var(tr->tracing_cpumask);
+ out_free_tr_name:
 	kfree(tr->name);
+ out_free_tr:
 	kfree(tr);
-
  out_unlock:
 	mutex_unlock(&trace_types_lock);
 
 	return ret;
-
 }
 
 static int instance_delete(const char *name)

