Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab3KAJ5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 05:57:00 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:46042 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3KAJ47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 05:56:59 -0400
Date: Fri, 1 Nov 2013 10:56:53 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20131101095653.GA27888@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: e8a923cc1fff6e627f906655ad52ee694ef2f6d7 perf/x86: Fix NMI measurements

Two fixes:

 - Fix 'NMI handler took too long to run' false positives. [ Genuine 
   NMI overhead speedups will come for v3.13, this commit only fixes 
   a measurement bug. ]

 - Fix perf ring-buffer missed barrier causing (rare) ring-buffer
   data corruption on ppc64.

 Thanks,

	Ingo

------------------>
Peter Zijlstra (2):
      perf: Fix perf ring buffer memory ordering
      perf/x86: Fix NMI measurements


 arch/x86/kernel/cpu/perf_event.c |  6 +++---
 arch/x86/kernel/nmi.c            |  4 ++--
 include/uapi/linux/perf_event.h  | 12 +++++++-----
 kernel/events/ring_buffer.c      | 31 +++++++++++++++++++++++++++----
 4 files changed, 39 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 9d84491..8a87a32 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1276,16 +1276,16 @@ void perf_events_lapic_init(void)
 static int __kprobes
 perf_event_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 {
-	int ret;
 	u64 start_clock;
 	u64 finish_clock;
+	int ret;
 
 	if (!atomic_read(&active_events))
 		return NMI_DONE;
 
-	start_clock = local_clock();
+	start_clock = sched_clock();
 	ret = x86_pmu.handle_irq(regs);
-	finish_clock = local_clock();
+	finish_clock = sched_clock();
 
 	perf_sample_event_took(finish_clock - start_clock);
 
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index ba77ebc..6fcb49c 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -113,10 +113,10 @@ static int __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2
 		u64 before, delta, whole_msecs;
 		int remainder_ns, decimal_msecs, thishandled;
 
-		before = local_clock();
+		before = sched_clock();
 		thishandled = a->handler(type, regs);
 		handled += thishandled;
-		delta = local_clock() - before;
+		delta = sched_clock() - before;
 		trace_nmi_handler(a->handler, (int)delta, thishandled);
 
 		if (delta < nmi_longest_ns)
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
