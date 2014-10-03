Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580AbaJCXA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:00:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758238AbaJCWX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:23:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Lau <kafai@fb.com>, Josef Bacik <jbacik@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3.10 019/143] trace: Fix epoll hang when we race with new entries
Date: Fri,  3 Oct 2014 14:33:34 -0700
Message-Id: <20141003213315.062520983@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fb.com>

commit 4ce97dbf50245227add17c83d87dc838e7ca79d0 upstream.

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

Cc: Martin Lau <kafai@fb.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ring_buffer.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -626,8 +626,22 @@ int ring_buffer_poll_wait(struct ring_bu
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


