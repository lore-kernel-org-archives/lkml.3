Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbaHZNpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:45:09 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:10647 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754945AbaHZNpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:45:07 -0400
Date: Tue, 26 Aug 2014 09:45:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Martin Lau <kafai@fb.com>,
        Josef Bacik <jbacik@fb.com>
Subject: [GIT PULL] tracing: Fix epoll hang when we race with new entries
Message-ID: <20140826094504.1500c4db@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Josef Bacik found a bug in the ring_buffer_poll_wait() where the
condition variable (waiters_pending) was set before being added to
the poll queue via poll_wait(). This allowed for a small race window
to happen where an event could come in, check the condition variable
see it set to true, clear it, and then wake all the waiters. But because
the waiter set the variable before adding itself to the queue, the
waker could have cleared the variable after it was set and then miss
waking it up as it wasn't added to the queue yet.

Discussing this bug, we realized that a memory barrier needed to be added
too, for the rare case that something polls for a single trace event
to happen (and just one, no more to come in), and miss the wakeup due
to memory ordering.  Ideally, a memory barrier needs to be added on the
writer side too, but as that will kill tracing performance and this is
for a situation that tracing wasn't even designed for (who traces one
instance of an event, use a printk instead!), this isn't worth adding the
barrier. But we can in the future add the barrier for when the buffer
goes from empty to the first event, as that would cover this case.

Please pull the latest trace-fixes-v3.17-rc1-2 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.17-rc1-2

Tag SHA1: 65a0d2a56a1c4edbe044c7d14177ebc032644799
Head SHA1: 4ce97dbf50245227add17c83d87dc838e7ca79d0


Josef Bacik (1):
      trace: Fix epoll hang when we race with new entries

----
 kernel/trace/ring_buffer.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)
---------------------------
commit 4ce97dbf50245227add17c83d87dc838e7ca79d0
Author: Josef Bacik <jbacik@fb.com>
Date:   Mon Aug 25 13:59:41 2014 -0400

    trace: Fix epoll hang when we race with new entries
    
    Epoll on trace_pipe can sometimes hang in a weird case.  If the ring buffer is
    empty when we set waiters_pending but an event shows up exactly at that moment
    we can miss being woken up by the ring buffers irq work.  Since
    ring_buffer_empty() is inherently racey we will sometimes think that the buffer
    is not empty.  So we don't get woken up and we don't think there are any events
    even though there were some ready when we added the watch, which makes us hang.
    This patch fixes this by making sure that we are actually on the wait list
    before we set waiters_pending, and add a memory barrier to make sure
    ring_buffer_empty() is going to be correct.
    
    Link: http://lkml.kernel.org/p/1408989581-23727-1-git-send-email-jbacik@fb.com
    
    Cc: stable@vger.kernel.org # 3.10+
    Cc: Martin Lau <kafai@fb.com>
    Signed-off-by: Josef Bacik <jbacik@fb.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index afb04b9b818a..b38fb2b9e237 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -626,8 +626,22 @@ int ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
 		work = &cpu_buffer->irq_work;
 	}
 
-	work->waiters_pending = true;
 	poll_wait(filp, &work->waiters, poll_table);
+	work->waiters_pending = true;
+	/*
+	 * There's a tight race between setting the waiters_pending and
+	 * checking if the ring buffer is empty.  Once the waiters_pending bit
+	 * is set, the next event will wake the task up, but we can get stuck
+	 * if there's only a single event in.
+	 *
+	 * FIXME: Ideally, we need a memory barrier on the writer side as well,
+	 * but adding a memory barrier to all events will cause too much of a
+	 * performance hit in the fast path.  We only need a memory barrier when
+	 * the buffer goes from empty to having content.  But as this race is
+	 * extremely small, and it's not a problem if another event comes in, we
+	 * will fix it later.
+	 */
+	smp_mb();
 
 	if ((cpu == RING_BUFFER_ALL_CPUS && !ring_buffer_empty(buffer)) ||
 	    (cpu != RING_BUFFER_ALL_CPUS && !ring_buffer_empty_cpu(buffer, cpu)))
