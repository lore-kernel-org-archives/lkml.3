Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbaBUVNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:13:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58956 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbaBUVNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:13:07 -0500
Date: Fri, 21 Feb 2014 13:12:31 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-cd578abb24aa67ce468c427d3356c08ea32cf768@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, dave.hansen@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, dave.hansen@linux.intel.com
In-Reply-To: <20140211150116.GO27965@twins.programming.kicks-ass.net>
References: <20140211150116.GO27965@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Warn to early_printk()
  in case irq_work is too slow
Git-Commit-ID: cd578abb24aa67ce468c427d3356c08ea32cf768
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cd578abb24aa67ce468c427d3356c08ea32cf768
Gitweb:     http://git.kernel.org/tip/cd578abb24aa67ce468c427d3356c08ea32cf768
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 11 Feb 2014 16:01:16 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:49:07 +0100

perf/x86: Warn to early_printk() in case irq_work is too slow

On Mon, Feb 10, 2014 at 08:45:16AM -0800, Dave Hansen wrote:
> The reason I coded this up was that NMIs were firing off so fast that
> nothing else was getting a chance to run.  With this patch, at least the
> printk() would come out and I'd have some idea what was going on.

It will start spewing to early_printk() (which is a lot nicer to use
from NMI context too) when it fails to queue the IRQ-work because its
already enqueued.

It does have the false-positive for when two CPUs trigger the warn
concurrently, but that should be rare and some extra clutter on the
early printk shouldn't be a problem.

Cc: hpa@zytor.com
Cc: tglx@linutronix.de
Cc: dzickus@redhat.com
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: mingo@kernel.org
Fixes: 6a02ad66b2c4 ("perf/x86: Push the duration-logging printk() to IRQ context")
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140211150116.GO27965@twins.programming.kicks-ass.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
 
