Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbaHHUnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:43:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40199 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756601AbaHHUlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:41:53 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Martin Lau <kafai@fb.com>, Steven Rostedt <rostedt@goodmis.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 143/259] ring-buffer: Fix polling on trace_pipe
Date: Fri,  8 Aug 2014 13:39:26 -0700
Message-Id: <1407530482-4483-144-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Lau <kafai@fb.com>

commit 97b8ee845393701edc06e27ccec2876ff9596019 upstream.

ring_buffer_poll_wait() should always put the poll_table to its wait_queue
even there is immediate data available.  Otherwise, the following epoll and
read sequence will eventually hang forever:

1. Put some data to make the trace_pipe ring_buffer read ready first
2. epoll_ctl(efd, EPOLL_CTL_ADD, trace_pipe_fd, ee)
3. epoll_wait()
4. read(trace_pipe_fd) till EAGAIN
5. Add some more data to the trace_pipe ring_buffer
6. epoll_wait() -> this epoll_wait() will block forever

~ During the epoll_ctl(efd, EPOLL_CTL_ADD,...) call in step 2,
  ring_buffer_poll_wait() returns immediately without adding poll_table,
  which has poll_table->_qproc pointing to ep_poll_callback(), to its
  wait_queue.
~ During the epoll_wait() call in step 3 and step 6,
  ring_buffer_poll_wait() cannot add ep_poll_callback() to its wait_queue
  because the poll_table->_qproc is NULL and it is how epoll works.
~ When there is new data available in step 6, ring_buffer does not know
  it has to call ep_poll_callback() because it is not in its wait queue.
  Hence, block forever.

Other poll implementation seems to call poll_wait() unconditionally as the very
first thing to do.  For example, tcp_poll() in tcp.c.

Link: http://lkml.kernel.org/p/20140610060637.GA14045@devbig242.prn2.facebook.com

Fixes: 2a2cc8f7c4d0 "ftrace: allow the event pipe to be polled"
Reviewed-by: Chris Mason <clm@fb.com>
Signed-off-by: Martin Lau <kafai@fb.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/trace/ring_buffer.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 0e337ee..bca008f 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -613,10 +613,6 @@ int ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct rb_irq_work *work;
 
-	if ((cpu == RING_BUFFER_ALL_CPUS && !ring_buffer_empty(buffer)) ||
-	    (cpu != RING_BUFFER_ALL_CPUS && !ring_buffer_empty_cpu(buffer, cpu)))
-		return POLLIN | POLLRDNORM;
-
 	if (cpu == RING_BUFFER_ALL_CPUS)
 		work = &buffer->irq_work;
 	else {
-- 
1.9.1

