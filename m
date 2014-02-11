Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaBKPB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:01:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57075 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaBKPB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:01:28 -0500
Date: Tue, 11 Feb 2014 16:01:16 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, dzickus@redhat.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] x86/nmi: Push duration printk() to irq context
Message-ID: <20140211150116.GO27965@twins.programming.kicks-ass.net>
References: <tip-rdw0au56a5ymis1u8p48c12d@git.kernel.org>
 <52F9021C.1030801@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F9021C.1030801@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 08:45:16AM -0800, Dave Hansen wrote:
> The reason I coded this up was that NMIs were firing off so fast that
> nothing else was getting a chance to run.  With this patch, at least the
> printk() would come out and I'd have some idea what was going on.

How's something like this on top?

It will start spewing to early_printk() (which is a lot nicer to use
from NMI context too) when it fails to queue the IRQ-work because its
already enqueued.

It does have the false-positive for when two CPUs trigger the warn
concurrently, but that should be rare and some extra clutter on the
early printk shouldn't be a problem.

---
 include/linux/irq_work.h | 2 +-
 kernel/events/core.c     | 9 +++++++--
 kernel/irq_work.c        | 6 ++++--
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index add13c8..19ae05d 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -32,7 +32,7 @@ void init_irq_work(struct irq_work *work, void (*func)(struct irq_work *))
 
 #define DEFINE_IRQ_WORK(name, _f) struct irq_work name = { .func = (_f), }
 
-void irq_work_queue(struct irq_work *work);
+bool irq_work_queue(struct irq_work *work);
 void irq_work_run(void);
 void irq_work_sync(struct irq_work *work);
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2067cbb..45e5543 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -243,7 +243,7 @@ static void perf_duration_warn(struct irq_work *w)
 	printk_ratelimited(KERN_WARNING
 			"perf interrupt took too long (%lld > %lld), lowering "
 			"kernel.perf_event_max_sample_rate to %d\n",
-			avg_local_sample_len, allowed_ns,
+			avg_local_sample_len, allowed_ns >> 1,
 			sysctl_perf_event_sample_rate);
 }
 
@@ -283,7 +283,12 @@ void perf_sample_event_took(u64 sample_len_ns)
 
 	update_perf_cpu_limits();
 
-	irq_work_queue(&perf_duration_work);
+	if (!irq_work_queue(&perf_duration_work)) {
+		early_printk("perf interrupt took too long (%lld > %lld), lowering "
+			     "kernel.perf_event_max_sample_rate to %d\n",
+			     avg_local_sample_len, allowed_ns >> 1,
+			     sysctl_perf_event_sample_rate);
+	}
 }
 
 static atomic64_t perf_event_id;
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 55fcce6..a82170e 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -61,11 +61,11 @@ void __weak arch_irq_work_raise(void)
  *
  * Can be re-enqueued while the callback is still in progress.
  */
-void irq_work_queue(struct irq_work *work)
+bool irq_work_queue(struct irq_work *work)
 {
 	/* Only queue if not already pending */
 	if (!irq_work_claim(work))
-		return;
+		return false;
 
 	/* Queue the entry and raise the IPI if needed. */
 	preempt_disable();
@@ -83,6 +83,8 @@ void irq_work_queue(struct irq_work *work)
 	}
 
 	preempt_enable();
+
+	return true;
 }
 EXPORT_SYMBOL_GPL(irq_work_queue);
 
