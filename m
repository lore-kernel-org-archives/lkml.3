Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860AbaGPD1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 23:27:05 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:55746 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760775AbaGPD0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 23:26:39 -0400
Message-Id: <20140716032637.509579203@goodmis.org>
User-Agent: quilt/0.63-1
Date: Tue, 15 Jul 2014 23:24:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Chris Mason <clm@fb.com>,
        Martin Lau <kafai@fb.com>
Subject: [PATCH 4/4] ring-buffer: Fix polling on trace_pipe
References: <20140716032455.761976900@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0004-ring-buffer-Fix-polling-on-trace_pipe.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Lau <kafai@fb.com>

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

Cc: stable@vger.kernel.org # 2.6.27
Fixes: 2a2cc8f7c4d0 "ftrace: allow the event pipe to be polled"
Reviewed-by: Chris Mason <clm@fb.com>
Signed-off-by: Martin Lau <kafai@fb.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 7c56c3d06943..ff7027199a9a 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -616,10 +616,6 @@ int ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
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
2.0.0


