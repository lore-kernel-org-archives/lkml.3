Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbbAWFej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:34:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:26947 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbbAWFef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:34:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="444041920"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        linux-ia64@vger.kernel.org
Subject: [Resend Patch v4 04/16] smp, IA64: Kill SMP single function call interrupt
Date: Fri, 23 Jan 2015 13:36:43 +0800
Message-Id: <1421991416-20297-5-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9a46ad6d6df3b54 "smp: make smp_call_function_many() use logic
similar to smp_call_function_single()" has unified the way to handle
single and multiple cross-CPU function calls. Now only one interrupt
is needed for architecture specific code to support generic SMP function
call interfaces, so kill the redundant single function call interrupt.

Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/ia64/kernel/smp.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
index 9fcd4e63048f..0532909b6e8e 100644
--- a/arch/ia64/kernel/smp.c
+++ b/arch/ia64/kernel/smp.c
@@ -62,8 +62,7 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(unsigned short [NR_CPUS],
 
 #define IPI_CALL_FUNC		0
 #define IPI_CPU_STOP		1
-#define IPI_CALL_FUNC_SINGLE	2
-#define IPI_KDUMP_CPU_STOP	3
+#define IPI_KDUMP_CPU_STOP	2
 
 /* This needs to be cacheline aligned because it is written to by *other* CPUs.  */
 static DEFINE_PER_CPU_SHARED_ALIGNED(unsigned long, ipi_operation);
@@ -116,9 +115,6 @@ handle_IPI (int irq, void *dev_id)
 			case IPI_CALL_FUNC:
 				generic_smp_call_function_interrupt();
 				break;
-			case IPI_CALL_FUNC_SINGLE:
-				generic_smp_call_function_single_interrupt();
-				break;
 #ifdef CONFIG_KEXEC
 			case IPI_KDUMP_CPU_STOP:
 				unw_init_running(kdump_cpu_freeze, NULL);
@@ -318,7 +314,7 @@ smp_flush_tlb_mm (struct mm_struct *mm)
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	send_IPI_single(cpu, IPI_CALL_FUNC_SINGLE);
+	send_IPI_single(cpu, IPI_CALL_FUNC);
 }
 
 void arch_send_call_function_ipi_mask(const struct cpumask *mask)
-- 
1.7.10.4

