Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbaHNHWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 03:22:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:21167 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407AbaHNHWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 03:22:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="372236817"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: bp@alien8.de
Cc: tony.luck@intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        "Chen, Gong" <gong.chen@linux.intel.com>, Borislav Petkov <bp@suse.de>
Subject: [PATCH v2 5/5] x86, MCE: Avoid potential deadlock in MCE context
Date: Thu, 14 Aug 2014 02:49:46 -0400
Message-Id: <1407998986-1834-6-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1407998986-1834-1-git-send-email-gong.chen@linux.intel.com>
References: <1407998986-1834-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Printing in MCE context is a no-no, currently, as printk is not
NMI-safe. If some of the notifiers on the MCE chain call *printk*, we
may deadlock. In order to avoid that, delay printk into process context
to fix it.

Background info at: https://lkml.org/lkml/2014/6/27/26

Reported-by: Xie XiuQi <xiexiuqi@huawei.com>
Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
Link: http://lkml.kernel.org/r/1406797523-28710-6-git-send-email-gong.chen@linux.intel.com
[ Boris: rewrite a bit. ]
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/mce.h               |  1 +
 arch/x86/kernel/cpu/mcheck/mce-apei.c    |  2 +-
 arch/x86/kernel/cpu/mcheck/mce.c         | 11 ++++++-----
 arch/x86/kernel/cpu/mcheck/mce_intel.c   |  2 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c |  1 +
 arch/x86/kernel/cpu/mcheck/threshold.c   |  1 +
 6 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 76e706767655..be2ec2902830 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -187,6 +187,7 @@ enum mcp_flags {
 void machine_check_poll(enum mcp_flags flags, mce_banks_t *b);
 
 int mce_notify_irq(void);
+void mce_queue_irq_work(void);
 #ifdef CONFIG_MEMORY_FAILURE
 void mce_notify_process(void);
 #endif
diff --git a/arch/x86/kernel/cpu/mcheck/mce-apei.c b/arch/x86/kernel/cpu/mcheck/mce-apei.c
index a1aef9533154..380e3ac8fb62 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-apei.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-apei.c
@@ -57,7 +57,7 @@ void apei_mce_report_mem_error(int severity, struct cper_sec_mem_err *mem_err)
 
 	m.addr = mem_err->physical_addr;
 	mce_log(&m);
-	mce_notify_irq();
+	mce_queue_irq_work();
 }
 EXPORT_SYMBOL_GPL(apei_mce_report_mem_error);
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index b0a25d5f7185..c7ac50d8c4b5 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -151,14 +151,11 @@ static struct mce_log mcelog = {
 void mce_log(struct mce *mce)
 {
 	unsigned next, entry;
-	int ret = 0;
 
 	/* Emit the trace record: */
 	trace_mce_record(mce);
 
-	ret = atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, mce);
-	if (ret == NOTIFY_STOP)
-		return;
+	mce_genpool_add(mce);
 
 	mce->finished = 0;
 	wmb();
@@ -488,6 +485,11 @@ static void mce_irq_work_cb(struct irq_work *entry)
 	mce_schedule_work();
 }
 
+void mce_queue_irq_work(void)
+{
+	irq_work_queue(&mce_irq_work);
+}
+
 static void mce_report_event(struct pt_regs *regs)
 {
 	if (regs->flags & (X86_VM_MASK|X86_EFLAGS_IF)) {
@@ -1044,7 +1046,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		/* assuming valid severity level != 0 */
 		m.severity = severity;
 		m.usable_addr = mce_usable_address(&m);
-		mce_genpool_add(&m);
 
 		mce_log(&m);
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 3bdb95ae8c43..ec2cf614152e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -195,8 +195,8 @@ static void intel_threshold_interrupt(void)
 {
 	if (cmci_storm_detect())
 		return;
+
 	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
-	mce_notify_irq();
 }
 
 /*
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 36a1bb6d1ee0..d100e2bb8ed7 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -427,6 +427,7 @@ static inline void __smp_thermal_interrupt(void)
 {
 	inc_irq_stat(irq_thermal_count);
 	smp_thermal_vector();
+	mce_queue_irq_work();
 }
 
 asmlinkage __visible void smp_thermal_interrupt(struct pt_regs *regs)
diff --git a/arch/x86/kernel/cpu/mcheck/threshold.c b/arch/x86/kernel/cpu/mcheck/threshold.c
index 7245980186ee..d695faa234eb 100644
--- a/arch/x86/kernel/cpu/mcheck/threshold.c
+++ b/arch/x86/kernel/cpu/mcheck/threshold.c
@@ -22,6 +22,7 @@ static inline void __smp_threshold_interrupt(void)
 {
 	inc_irq_stat(irq_threshold_count);
 	mce_threshold_vector();
+	mce_queue_irq_work();
 }
 
 asmlinkage __visible void smp_threshold_interrupt(void)
-- 
2.0.0.rc2

