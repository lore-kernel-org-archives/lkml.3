Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301AbaHYR7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:59:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30099 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933043AbaHYR7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:59:47 -0400
From: Josef Bacik <jbacik@fb.com>
To: <linux-kernel@vger.kernel.org>
CC: <kafai@fb.com>, <rostedt@goodmis.org>
Subject: [PATCH] trace: fix epoll hang when we race with new entries
Date: Mon, 25 Aug 2014 13:59:41 -0400
Message-ID: <1408989581-23727-1-git-send-email-jbacik@fb.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-25_04:2014-08-25,2014-08-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.58206781009085e-14 kscore.compositescore=0
 circleOfTrustscore=22.6900859407804 compositescore=0.997695897463551
 urlsuspect_oldscore=0.997695897463551 suspectscore=1
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.997695897463551 spamscore=0
 recipient_to_sender_domain_totalscore=6 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1408250232
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Epoll on trace_pipe can sometimes hang in a weird case.  If the ring buffer is
empty when we set waiters_pending but an event shows up exactly at that moment
we can miss being woken up by the ring buffers irq work.  Since
ring_buffer_empty() is inherently racey we will sometimes think that the buffer
is not empty.  So we don't get woken up and we don't think there are any events
even though there were some ready when we added the watch, which makes us hang.
This patch fixes this by making sure that we are actually on the wait list
before we set waiters_pending, and add a memory barrier to make sure
ring_buffer_empty() is going to be correct.

cc: kafai@fb.com
cc: rostedt@goodmis.org
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 kernel/trace/ring_buffer.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index afb04b9..b38fb2b 100644
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
-- 
1.9.3

