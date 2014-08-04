Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaHDQzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:55:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56605 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752133AbaHDQt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Martin Lau" <kafai@fb.com>,
        "Chris Mason" <clm@fb.com>, "Steven Rostedt" <rostedt@goodmis.org>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.520974333@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 48/94] ring-buffer: Fix polling on trace_pipe
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: the poll implementation looks rather different
 but does have a conditional return before and after the poll_wait() call;
 delete the return before it.]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/ring_buffer.c | 4 ----
 1 file changed, 4 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3244,8 +3244,6 @@ tracing_poll_pipe(struct file *filp, pol
 		 */
 		return POLLIN | POLLRDNORM;
 	} else {
-		if (!trace_empty(iter))
-			return POLLIN | POLLRDNORM;
 		poll_wait(filp, &trace_wait, poll_table);
 		if (!trace_empty(iter))
 			return POLLIN | POLLRDNORM;

