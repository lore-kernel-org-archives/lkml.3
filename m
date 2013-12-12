Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab3LLJw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 04:52:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45849 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab3LLJwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 04:52:47 -0500
Date: Thu, 12 Dec 2013 01:52:10 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-8alv40z6ikk57jzbaobnxrjl@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        paulmck@us.ibm.com, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        paulmck@us.ibm.com, peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Optimize ring-buffer write by depending on control dependencies
Git-Commit-ID: c7f2e3cd6c1f4932ccc4135d050eae3f7c7aef63
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 12 Dec 2013 01:52:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7f2e3cd6c1f4932ccc4135d050eae3f7c7aef63
Gitweb:     http://git.kernel.org/tip/c7f2e3cd6c1f4932ccc4135d050eae3f7c7aef63
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 25 Nov 2013 11:49:10 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 11 Dec 2013 15:53:22 +0100

perf: Optimize ring-buffer write by depending on control dependencies

Remove a full barrier from the ring-buffer write path by relying on
a control dependency to order a LOAD -> STORE scenario.

Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-8alv40z6ikk57jzbaobnxrjl@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/ring_buffer.c | 42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index e8b168a..146a579 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -61,19 +61,20 @@ again:
 	 *
 	 *   kernel				user
 	 *
-	 *   READ ->data_tail			READ ->data_head
-	 *   smp_mb()	(A)			smp_rmb()	(C)
-	 *   WRITE $data			READ $data
-	 *   smp_wmb()	(B)			smp_mb()	(D)
-	 *   STORE ->data_head			WRITE ->data_tail
+	 *   if (LOAD ->data_tail) {		LOAD ->data_head
+	 *			(A)		smp_rmb()	(C)
+	 *	STORE $data			LOAD $data
+	 *	smp_wmb()	(B)		smp_mb()	(D)
+	 *	STORE ->data_head		STORE ->data_tail
+	 *   }
 	 *
 	 * Where A pairs with D, and B pairs with C.
 	 *
-	 * I don't think A needs to be a full barrier because we won't in fact
-	 * write data until we see the store from userspace. So we simply don't
-	 * issue the data WRITE until we observe it. Be conservative for now.
+	 * In our case (A) is a control dependency that separates the load of
+	 * the ->data_tail and the stores of $data. In case ->data_tail
+	 * indicates there is no room in the buffer to store $data we do not.
 	 *
-	 * OTOH, D needs to be a full barrier since it separates the data READ
+	 * D needs to be a full barrier since it separates the data READ
 	 * from the tail WRITE.
 	 *
 	 * For B a WMB is sufficient since it separates two WRITEs, and for C
@@ -81,7 +82,7 @@ again:
 	 *
 	 * See perf_output_begin().
 	 */
-	smp_wmb();
+	smp_wmb(); /* B, matches C */
 	rb->user_page->data_head = head;
 
 	/*
@@ -144,17 +145,26 @@ int perf_output_begin(struct perf_output_handle *handle,
 		if (!rb->overwrite &&
 		    unlikely(CIRC_SPACE(head, tail, perf_data_size(rb)) < size))
 			goto fail;
+
+		/*
+		 * The above forms a control dependency barrier separating the
+		 * @tail load above from the data stores below. Since the @tail
+		 * load is required to compute the branch to fail below.
+		 *
+		 * A, matches D; the full memory barrier userspace SHOULD issue
+		 * after reading the data and before storing the new tail
+		 * position.
+		 *
+		 * See perf_output_put_handle().
+		 */
+
 		head += size;
 	} while (local_cmpxchg(&rb->head, offset, head) != offset);
 
 	/*
-	 * Separate the userpage->tail read from the data stores below.
-	 * Matches the MB userspace SHOULD issue after reading the data
-	 * and before storing the new tail position.
-	 *
-	 * See perf_output_put_handle().
+	 * We rely on the implied barrier() by local_cmpxchg() to ensure
+	 * none of the data stores below can be lifted up by the compiler.
 	 */
-	smp_mb();
 
 	if (unlikely(head - local_read(&rb->wakeup) > rb->watermark))
 		local_add(rb->watermark, &rb->wakeup);
