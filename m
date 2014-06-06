Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaFFEHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 00:07:49 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:51777 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750710AbaFFEHs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 00:07:48 -0400
Date: Fri, 6 Jun 2014 00:07:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH ftrace/core 3/3] trace: Fix memory leak when new
 instance creation failed
Message-ID: <20140606000746.4a25a708@gandalf.local.home>
In-Reply-To: <20140605223522.32311.31664.stgit@yunodevel>
References: <20140605223515.32311.71203.stgit@yunodevel>
	<20140605223522.32311.31664.stgit@yunodevel>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jun 2014 07:35:22 +0900
Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:

> Current new_instance_create() implements just two fail paths for four
> allocation operations. So, it can induce memory leak if new instance
> creation failed. This patch fixes it by defining all fail paths and
> freeing allocated memories appropriately.
> 

We don't need all the labels. The kfree() can handle NULL pointers.
Also, it's for a very unlikely case so we don't care about performance.

Here's the patch I'm adding:

-- Steve

>From 5ae90d9db393ac1b6189f8cb712ac5f526abd50e Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Fri, 6 Jun 2014 00:01:46 -0400
Subject: [PATCH] tracing: Fix leak of ring buffer data when new instances
 creation fails

Yoshihiro Yunomae reported that the ring buffer data for a trace
instance does not get properly cleaned up when it fails. He proposed
a patch that manually cleaned the data up and addad a bunch of labels.
The labels are not needed because all trace array is allocated with
a kzalloc which initializes it to 0 and all kfree()s can take a NULL
pointer and will ignore it.

Adding a new helper function free_trace_buffers() that can also take
null buffers to free the buffers that were allocated by
allocate_trace_buffers().

Link: http://lkml.kernel.org/r/20140605223522.32311.31664.stgit@yunodevel

Reported-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e29edee..26cfff3 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6232,6 +6232,25 @@ static int allocate_trace_buffers(struct trace_array *tr, int size)
 	return 0;
 }
 
+static void free_trace_buffers(struct trace_array *tr)
+{
+	if (!tr)
+		return;
+
+	if (tr->trace_buffer.buffer) {
+		ring_buffer_free(tr->trace_buffer.buffer);
+		tr->trace_buffer.buffer = NULL;
+		free_percpu(tr->trace_buffer.data);
+	}
+
+#ifdef CONFIG_TRACER_MAX_TRACE
+	if (tr->max_buffer.buffer) {
+		ring_buffer_free(tr->max_buffer.buffer);
+		tr->max_buffer.buffer = NULL;
+	}
+#endif
+}
+
 static int new_instance_create(const char *name)
 {
 	struct trace_array *tr;
@@ -6290,8 +6309,7 @@ static int new_instance_create(const char *name)
 	return 0;
 
  out_free_tr:
-	if (tr->trace_buffer.buffer)
-		ring_buffer_free(tr->trace_buffer.buffer);
+	free_trace_buffers(tr);
 	free_cpumask_var(tr->tracing_cpumask);
 	kfree(tr->name);
 	kfree(tr);
-- 
1.8.1.4

