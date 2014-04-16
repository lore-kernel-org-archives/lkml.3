Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbaDPDU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 23:20:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:48724 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbaDPDUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 23:20:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,868,1389772800"; 
   d="scan'208";a="521389569"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: hpa@zytor.com, tony.luck@intel.com
Cc: tglx@linutronix.de, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux-tip-commits@vger.kernel.org,
        "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [PATCH 2/2 v2] x86, MCE: Clean get_cpu_xxx with this_cpu_xxx
Date: Tue, 15 Apr 2014 22:55:33 -0400
Message-Id: <1397616933-11239-2-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1397616933-11239-1-git-send-email-gong.chen@linux.intel.com>
References: <1397546035-6384-1-git-send-email-gong.chen@linux.intel.com>
 <1397616933-11239-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cleanup patch suggested by Peter. Use new
this_cpu_xxx to improve operation speed.

v2 -> v1: Separate cleanup from bug fix.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
Suggested-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 68317c8..5284189 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -402,7 +402,7 @@ static u64 mce_rdmsrl(u32 msr)
 
 		if (offset < 0)
 			return 0;
-		return *(u64 *)((char *)&__get_cpu_var(injectm) + offset);
+		return *(u64 *)((char *)this_cpu_ptr(&injectm) + offset);
 	}
 
 	if (rdmsrl_safe(msr, &v)) {
@@ -424,7 +424,7 @@ static void mce_wrmsrl(u32 msr, u64 v)
 		int offset = msr_to_offset(msr);
 
 		if (offset >= 0)
-			*(u64 *)((char *)&__get_cpu_var(injectm) + offset) = v;
+			*(u64 *)((char *)this_cpu_ptr(&injectm) + offset) = v;
 		return;
 	}
 	wrmsrl(msr, v);
@@ -480,7 +480,7 @@ static DEFINE_PER_CPU(struct mce_ring, mce_ring);
 /* Runs with CPU affinity in workqueue */
 static int mce_ring_empty(void)
 {
-	struct mce_ring *r = &__get_cpu_var(mce_ring);
+	struct mce_ring *r = this_cpu_ptr(&mce_ring);
 
 	return r->start == r->end;
 }
@@ -492,7 +492,7 @@ static int mce_ring_get(unsigned long *pfn)
 
 	*pfn = 0;
 	get_cpu();
-	r = &__get_cpu_var(mce_ring);
+	r = this_cpu_ptr(&mce_ring);
 	if (r->start == r->end)
 		goto out;
 	*pfn = r->ring[r->start];
@@ -506,7 +506,7 @@ out:
 /* Always runs in MCE context with preempt off */
 static int mce_ring_add(unsigned long pfn)
 {
-	struct mce_ring *r = &__get_cpu_var(mce_ring);
+	struct mce_ring *r = this_cpu_ptr(&mce_ring);
 	unsigned next;
 
 	next = (r->end + 1) % MCE_RING_SIZE;
@@ -528,7 +528,7 @@ int mce_available(struct cpuinfo_x86 *c)
 static void mce_schedule_work(void)
 {
 	if (!mce_ring_empty())
-		schedule_work(&__get_cpu_var(mce_work));
+		schedule_work(this_cpu_ptr(&mce_work));
 }
 
 DEFINE_PER_CPU(struct irq_work, mce_irq_work);
@@ -553,7 +553,7 @@ static void mce_report_event(struct pt_regs *regs)
 		return;
 	}
 
-	irq_work_queue(&__get_cpu_var(mce_irq_work));
+	irq_work_queue(this_cpu_ptr(&mce_irq_work));
 }
 
 /*
@@ -1050,7 +1050,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 
 	mce_gather_info(&m, regs);
 
-	final = &__get_cpu_var(mces_seen);
+	final = this_cpu_ptr(&mces_seen);
 	*final = m;
 
 	memset(valid_banks, 0, sizeof(valid_banks));
@@ -1282,16 +1282,14 @@ static unsigned long mce_adjust_timer_default(unsigned long interval)
 static unsigned long (*mce_adjust_timer)(unsigned long interval) =
 	mce_adjust_timer_default;
 
-static int cmc_error_seen(void)
+static inline int cmc_error_seen(void)
 {
-	unsigned long *v = &__get_cpu_var(mce_polled_error);
-
-	return test_and_clear_bit(0, v);
+	return this_cpu_xchg(mce_polled_error, 0);
 }
 
 static void mce_timer_fn(unsigned long data)
 {
-	struct timer_list *t = &__get_cpu_var(mce_timer);
+	struct timer_list *t = this_cpu_ptr(&mce_timer);
 	unsigned long iv;
 	int notify;
 
@@ -1299,7 +1297,7 @@ static void mce_timer_fn(unsigned long data)
 
 	if (mce_available(__this_cpu_ptr(&cpu_info))) {
 		machine_check_poll(MCP_TIMESTAMP,
-				&__get_cpu_var(mce_poll_banks));
+				this_cpu_ptr(&mce_poll_banks));
 		mce_intel_cmci_poll();
 	}
 
@@ -1329,7 +1327,7 @@ static void mce_timer_fn(unsigned long data)
  */
 void mce_timer_kick(unsigned long interval)
 {
-	struct timer_list *t = &__get_cpu_var(mce_timer);
+	struct timer_list *t = this_cpu_ptr(&mce_timer);
 	unsigned long when = jiffies + interval;
 	unsigned long iv = __this_cpu_read(mce_next_interval);
 
@@ -1665,7 +1663,7 @@ static void mce_start_timer(unsigned int cpu, struct timer_list *t)
 
 static void __mcheck_cpu_init_timer(void)
 {
-	struct timer_list *t = &__get_cpu_var(mce_timer);
+	struct timer_list *t = this_cpu_ptr(&mce_timer);
 	unsigned int cpu = smp_processor_id();
 
 	setup_timer(t, mce_timer_fn, cpu);
@@ -1708,8 +1706,8 @@ void mcheck_cpu_init(struct cpuinfo_x86 *c)
 	__mcheck_cpu_init_generic();
 	__mcheck_cpu_init_vendor(c);
 	__mcheck_cpu_init_timer();
-	INIT_WORK(&__get_cpu_var(mce_work), mce_process_work);
-	init_irq_work(&__get_cpu_var(mce_irq_work), &mce_irq_work_cb);
+	INIT_WORK(this_cpu_ptr(&mce_work), mce_process_work);
+	init_irq_work(this_cpu_ptr(&mce_irq_work), &mce_irq_work_cb);
 }
 
 /*
@@ -1961,7 +1959,7 @@ static struct miscdevice mce_chrdev_device = {
 static void __mce_disable_bank(void *arg)
 {
 	int bank = *((int *)arg);
-	__clear_bit(bank, __get_cpu_var(mce_poll_banks));
+	__clear_bit(bank, *this_cpu_ptr(&mce_poll_banks));
 	cmci_disable_bank(bank);
 }
 
-- 
1.9.0

