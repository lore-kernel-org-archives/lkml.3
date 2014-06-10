Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbaFJGGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 02:06:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8967 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273AbaFJGGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 02:06:52 -0400
Date: Mon, 9 Jun 2014 23:06:42 -0700
From: Martin Lau <kafai@fb.com>
To: <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>, <clm@fb.com>
Subject: [PATCH] ring-buffer: Fix polling on trace_pipe
Message-ID: <20140610060637.GA14045@devbig242.prn2.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-10_03:2014-06-09,2014-06-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=2.66864308429149e-12 kscore.compositescore=0
 circleOfTrustscore=22.4078557653337 compositescore=0.997695897463551
 urlsuspect_oldscore=0.997695897463551 suspectscore=1
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.997695897463551 spamscore=0
 recipient_to_sender_domain_totalscore=6 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406100083
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Martin Lau <kafai@fb.com>
---
 kernel/trace/ring_buffer.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index fd12cc5..a6e64e8 100644
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
1.8.1

