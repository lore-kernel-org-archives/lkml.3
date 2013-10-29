Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab3J2OIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:08:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45884 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860Ab3J2OIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:08:10 -0400
Date: Tue, 29 Oct 2013 07:06:55 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-bf378d341e4873ed928dc3c636252e6895a21f50@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, victork@il.ibm.com,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, tglx@linutronix.de,
        mikey@neuling.org
Reply-To: mingo@kernel.org, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
        linux-kernel@vger.kernel.org, peterz@infradead.org, victork@il.ibm.com,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, tglx@linutronix.de,
        mikey@neuling.org
In-Reply-To: <20131025173749.GG19466@laptop.lan>
References: <20131025173749.GG19466@laptop.lan>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix perf ring buffer memory ordering
Git-Commit-ID: bf378d341e4873ed928dc3c636252e6895a21f50
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 29 Oct 2013 07:07:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf378d341e4873ed928dc3c636252e6895a21f50
Gitweb:     http://git.kernel.org/tip/bf378d341e4873ed928dc3c636252e6895a21f50
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 28 Oct 2013 13:55:29 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 29 Oct 2013 12:01:19 +0100

perf: Fix perf ring buffer memory ordering

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
---
 include/uapi/linux/perf_event.h | 12 +++++++-----
 kernel/events/ring_buffer.c     | 31 +++++++++++++++++++++++++++----
 2 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 009a655..2fc1602 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -456,13 +456,15 @@ struct perf_event_mmap_page {
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
index cd55144..9c2ddfb 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -87,10 +87,31 @@ again:
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
@@ -154,9 +175,11 @@ int perf_output_begin(struct perf_output_handle *handle,
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
