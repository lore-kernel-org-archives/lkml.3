Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab3ISQBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 12:01:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:60050 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320Ab3ISQA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 12:00:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,937,1371106800"; 
   d="scan'208";a="380631665"
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, gregkh@linuxfoundation.org, len.brown@intel.com,
        rjw@sisk.pl, arjan@linux.intel.com, jacob.jun.pan@linux.intel.com,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: [PATCH v1 4/6] x86/msr: add 64bit _on_cpu access functions
Date: Thu, 19 Sep 2013 09:00:33 -0700
Message-Id: <1379606435-15871-5-git-send-email-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379606435-15871-1-git-send-email-srinivas.pandruvada@linux.intel.com>
References: <1379606435-15871-1-git-send-email-srinivas.pandruvada@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

Having 64-bit MSR access methods on given CPU can avoid shifting and
simplify MSR content manipulation. We already have other combinations
of rdmsrl_xxx and wrmsrl_xxx but missing the _on_cpu version.

Reviewed-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 arch/x86/include/asm/msr.h | 22 ++++++++++++++++
 arch/x86/lib/msr-smp.c     | 62 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index cb75028..e139b13 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -218,10 +218,14 @@ void msrs_free(struct msr *msrs);
 #ifdef CONFIG_SMP
 int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
+int rdmsrl_on_cpu(unsigned int cpu, u32 msr_no, u64 *q);
+int wrmsrl_on_cpu(unsigned int cpu, u32 msr_no, u64 q);
 void rdmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs);
 void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs);
 int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
+int rdmsrl_safe_on_cpu(unsigned int cpu, u32 msr_no, u64 *q);
+int wrmsrl_safe_on_cpu(unsigned int cpu, u32 msr_no, u64 q);
 int rdmsr_safe_regs_on_cpu(unsigned int cpu, u32 regs[8]);
 int wrmsr_safe_regs_on_cpu(unsigned int cpu, u32 regs[8]);
 #else  /*  CONFIG_SMP  */
@@ -235,6 +239,16 @@ static inline int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 	wrmsr(msr_no, l, h);
 	return 0;
 }
+static inline int rdmsrl_on_cpu(unsigned int cpu, u32 msr_no, u64 *q)
+{
+	rdmsrl(msr_no, *q);
+	return 0;
+}
+static inline int wrmsrl_on_cpu(unsigned int cpu, u32 msr_no, u64 q)
+{
+	wrmsrl(msr_no, q);
+	return 0;
+}
 static inline void rdmsr_on_cpus(const struct cpumask *m, u32 msr_no,
 				struct msr *msrs)
 {
@@ -254,6 +268,14 @@ static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 {
 	return wrmsr_safe(msr_no, l, h);
 }
+static inline int rdmsrl_safe_on_cpu(unsigned int cpu, u32 msr_no, u64 *q)
+{
+	return rdmsrl_safe(msr_no, q);
+}
+static inline int wrmsrl_safe_on_cpu(unsigned int cpu, u32 msr_no, u64 q)
+{
+	return wrmsrl_safe(msr_no, q);
+}
 static inline int rdmsr_safe_regs_on_cpu(unsigned int cpu, u32 regs[8])
 {
 	return rdmsr_safe_regs(regs);
diff --git a/arch/x86/lib/msr-smp.c b/arch/x86/lib/msr-smp.c
index a6b1b86..518532e 100644
--- a/arch/x86/lib/msr-smp.c
+++ b/arch/x86/lib/msr-smp.c
@@ -47,6 +47,21 @@ int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
 }
 EXPORT_SYMBOL(rdmsr_on_cpu);
 
+int rdmsrl_on_cpu(unsigned int cpu, u32 msr_no, u64 *q)
+{
+	int err;
+	struct msr_info rv;
+
+	memset(&rv, 0, sizeof(rv));
+
+	rv.msr_no = msr_no;
+	err = smp_call_function_single(cpu, __rdmsr_on_cpu, &rv, 1);
+	*q = rv.reg.q;
+
+	return err;
+}
+EXPORT_SYMBOL(rdmsrl_on_cpu);
+
 int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 {
 	int err;
@@ -63,6 +78,22 @@ int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 }
 EXPORT_SYMBOL(wrmsr_on_cpu);
 
+int wrmsrl_on_cpu(unsigned int cpu, u32 msr_no, u64 q)
+{
+	int err;
+	struct msr_info rv;
+
+	memset(&rv, 0, sizeof(rv));
+
+	rv.msr_no = msr_no;
+	rv.reg.q = q;
+
+	err = smp_call_function_single(cpu, __wrmsr_on_cpu, &rv, 1);
+
+	return err;
+}
+EXPORT_SYMBOL(wrmsrl_on_cpu);
+
 static void __rwmsr_on_cpus(const struct cpumask *mask, u32 msr_no,
 			    struct msr *msrs,
 			    void (*msr_func) (void *info))
@@ -159,6 +190,37 @@ int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 }
 EXPORT_SYMBOL(wrmsr_safe_on_cpu);
 
+int wrmsrl_safe_on_cpu(unsigned int cpu, u32 msr_no, u64 q)
+{
+	int err;
+	struct msr_info rv;
+
+	memset(&rv, 0, sizeof(rv));
+
+	rv.msr_no = msr_no;
+	rv.reg.q = q;
+
+	err = smp_call_function_single(cpu, __wrmsr_safe_on_cpu, &rv, 1);
+
+	return err ? err : rv.err;
+}
+EXPORT_SYMBOL(wrmsrl_safe_on_cpu);
+
+int rdmsrl_safe_on_cpu(unsigned int cpu, u32 msr_no, u64 *q)
+{
+	int err;
+	struct msr_info rv;
+
+	memset(&rv, 0, sizeof(rv));
+
+	rv.msr_no = msr_no;
+	err = smp_call_function_single(cpu, __rdmsr_safe_on_cpu, &rv, 1);
+	*q = rv.reg.q;
+
+	return err ? err : rv.err;
+}
+EXPORT_SYMBOL(rdmsrl_safe_on_cpu);
+
 /*
  * These variants are significantly slower, but allows control over
  * the entire 32-bit GPR set.
-- 
1.8.3.1

