Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab3KYNT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:19:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57177 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab3KYNIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:08:11 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        michael@ellerman.id.au, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Michael Neuling <mikey@neuling.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, anton@samba.org,
        benh@kernel.crashing.org, Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 22/78] perf: Fix perf ring buffer memory ordering
Date: Mon, 25 Nov 2013 13:06:09 +0000
Message-Id: <1385384825-21681-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit bf378d341e4873ed928dc3c636252e6895a21f50 upstream.

The PPC64 people noticed a missing memory barrier and crufty old
comments in the perf ring buffer code. So update all the comments and
add the missing barrier.

When the architecture implements local_t using atomic_long_t there
will be double barriers issued; but short of introducing more
conditional barrier primitives this is the best we can do.

Reported-by: Victor Kaplansky <victork@il.ibm.com>
Tested-by: Victor Kaplansky <victork@il.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: michael@ellerman.id.au
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: anton@samba.org
Cc: benh@kernel.crashing.org
Link: http://lkml.kernel.org/r/20131025173749.GG19466@laptop.lan
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[ luis: backported to 3.5:
  - file rename: include/uapi/linux/perf_event.h -> include/linux/perf_event.h ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/perf_event.h  | 12 +++++++-----
 kernel/events/ring_buffer.c | 31 +++++++++++++++++++++++++++----
 2 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3faf0d4..7e72637 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -393,13 +393,15 @@ struct perf_event_mmap_page {
 	/*
 	 * Control data for the mmap() data buffer.
 	 *
-	 * User-space reading the @data_head value should issue an rmb(), on
-	 * SMP capable platforms, after reading this value -- see
-	 * perf_event_wakeup().
+	 * User-space reading the @data_head value should issue an smp_rmb(),
+	 * after reading this value.
 	 *
 	 * When the mapping is PROT_WRITE the @data_tail value should be
-	 * written by userspace to reflect the last read data. In this case
-	 * the kernel will not over-write unread data.
+	 * written by userspace to reflect the last read data, after issueing
+	 * an smp_mb() to separate the data read from the ->data_tail store.
+	 * In this case the kernel will not over-write unread data.
+	 *
+	 * See perf_output_put_handle() for the data ordering.
 	 */
 	__u64   data_head;		/* head in the data section */
 	__u64	data_tail;		/* user-space written tail */
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 6ddaba4..4636ecc 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -75,10 +75,31 @@ again:
 		goto out;
 
 	/*
-	 * Publish the known good head. Rely on the full barrier implied
-	 * by atomic_dec_and_test() order the rb->head read and this
-	 * write.
+	 * Since the mmap() consumer (userspace) can run on a different CPU:
+	 *
+	 *   kernel				user
+	 *
+	 *   READ ->data_tail			READ ->data_head
+	 *   smp_mb()	(A)			smp_rmb()	(C)
+	 *   WRITE $data			READ $data
+	 *   smp_wmb()	(B)			smp_mb()	(D)
+	 *   STORE ->data_head			WRITE ->data_tail
+	 *
+	 * Where A pairs with D, and B pairs with C.
+	 *
+	 * I don't think A needs to be a full barrier because we won't in fact
+	 * write data until we see the store from userspace. So we simply don't
+	 * issue the data WRITE until we observe it. Be conservative for now.
+	 *
+	 * OTOH, D needs to be a full barrier since it separates the data READ
+	 * from the tail WRITE.
+	 *
+	 * For B a WMB is sufficient since it separates two WRITEs, and for C
+	 * an RMB is sufficient since it separates two READs.
+	 *
+	 * See perf_output_begin().
 	 */
+	smp_wmb();
 	rb->user_page->data_head = head;
 
 	/*
@@ -142,9 +163,11 @@ int perf_output_begin(struct perf_output_handle *handle,
 		 * Userspace could choose to issue a mb() before updating the
 		 * tail pointer. So that all reads will be completed before the
 		 * write is issued.
+		 *
+		 * See perf_output_put_handle().
 		 */
 		tail = ACCESS_ONCE(rb->user_page->data_tail);
-		smp_rmb();
+		smp_mb();
 		offset = head = local_read(&rb->head);
 		head += size;
 		if (unlikely(!perf_output_space(rb, tail, offset, head)))
-- 
1.8.3.2

