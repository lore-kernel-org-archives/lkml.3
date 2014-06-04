Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbaFDTlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 15:41:00 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:35702 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaFDTk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 15:40:59 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] smp,
 ipi: Speed up IPI handling by invoking the callbacks in reverse order
To: akpm@linux-foundation.org, fweisbec@gmail.com, peterz@infradead.org
Cc: tglx@linutronix.de, hch@infradead.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Thu, 05 Jun 2014 01:09:35 +0530
Message-ID: <20140604193934.21321.19185.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060419-5564-0000-0000-00000E1F3563
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of lockless list (llist) has a drawback: if we
want to traverse the list in FIFO order (oldest to newest), we need to
reverse the list first (and this can be expensive if the list is large,
since this is an O(n) operation).

However, for callbacks that are queued using smp-call-function IPIs, the
requirement is that:
a. we invoke all of them, without missing any.
b. we invoke them as soon as possible.

In other words, we don't actually (need to) guarantee that the callbacks
will be invoked in FIFO order. So don't bother reversing the list; just
invoke the callbacks as they are (i.e., in reverse order). This would
probably speed-up the smp-call-function interrupt handler a tiny bit, when
flushing multiple pending callbacks upon receiving a single IPI.

But for debugging purposes, reverse the list and print it in the original
(FIFO) order in the WARN_ON case.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/smp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 5295388..be55094 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -229,7 +229,6 @@ static void flush_smp_call_function_queue(bool warn_cpu_offline)
 
 	head = &__get_cpu_var(call_single_queue);
 	entry = llist_del_all(head);
-	entry = llist_reverse_order(entry);
 
 	/* There shouldn't be any pending callbacks on an offline CPU. */
 	if (unlikely(warn_cpu_offline && !cpu_online(smp_processor_id()) &&
@@ -237,6 +236,8 @@ static void flush_smp_call_function_queue(bool warn_cpu_offline)
 		warned = true;
 		WARN(1, "IPI on offline CPU %d\n", smp_processor_id());
 
+		entry = llist_reverse_order(entry);
+
 		/*
 		 * We don't have to use the _safe() variant here
 		 * because we are not invoking the IPI handlers yet.

