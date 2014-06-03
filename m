Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbaFCE2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 00:28:12 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39242 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbaFCE2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 00:28:09 -0400
X-AuditID: 85900ec0-d3b2cb9000001514-ca-538d4ed3bf72
Subject: [PATCH ftrace/core 1/2] [BUGFIX] ftrace: Avoid panic when
 allocation of max_buffer is failed
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com
Date: Tue, 03 Jun 2014 13:28:03 +0900
Message-ID: <20140603042803.27308.30956.stgit@yunodevel>
In-Reply-To: <20140603042800.27308.48050.stgit@yunodevel>
References: <20140603042800.27308.48050.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When allocation of max_buffer is failed, the kernel frees tr->trace_buffer.data
per CPU and return -ENOMEM in allocate_trace_buffers(). However,
tracer_alloc_buffers() calling allocate_trace_buffers() also frees the data
per CPU for -ENOMEM by allocate_trace_buffers(). Therefore, the allocation
failure induces double free.

For the out_free_mask path in tracer_alloc_buffers(),
global_trace.trace_buffer.data and global_trace.max_buffer.data are
not allocated yet, so free_percpu of those are not needed.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
---
 kernel/trace/trace.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 626dbfd..135af32 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6671,10 +6671,6 @@ __init static int tracer_alloc_buffers(void)
 out_free_temp_buffer:
 	ring_buffer_free(temp_buffer);
 out_free_cpumask:
-	free_percpu(global_trace.trace_buffer.data);
-#ifdef CONFIG_TRACER_MAX_TRACE
-	free_percpu(global_trace.max_buffer.data);
-#endif
 	free_cpumask_var(global_trace.tracing_cpumask);
 out_free_buffer_mask:
 	free_cpumask_var(tracing_buffer_mask);

