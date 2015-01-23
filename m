Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbbAWFfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:35:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:45553 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbbAWFfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:35:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="444042125"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org
Subject: [Resend Patch v4 08/16] smp, sh: Kill SMP single function call interrupt
Date: Fri, 23 Jan 2015 13:36:47 +0800
Message-Id: <1421991416-20297-9-git-send-email-jiang.liu@linux.intel.com>
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

Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/sh/include/asm/smp.h |    1 -
 arch/sh/kernel/smp.c      |    5 +----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/sh/include/asm/smp.h b/arch/sh/include/asm/smp.h
index 78b0d0f4b24b..93ce87b3a18d 100644
--- a/arch/sh/include/asm/smp.h
+++ b/arch/sh/include/asm/smp.h
@@ -25,7 +25,6 @@ extern int __cpu_logical_map[NR_CPUS];
 enum {
 	SMP_MSG_FUNCTION,
 	SMP_MSG_RESCHEDULE,
-	SMP_MSG_FUNCTION_SINGLE,
 	SMP_MSG_TIMER,
 
 	SMP_MSG_NR,	/* must be last */
diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
index fc5acfc93c92..fc03baf8b661 100644
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -282,7 +282,7 @@ void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	mp_ops->send_ipi(cpu, SMP_MSG_FUNCTION_SINGLE);
+	mp_ops->send_ipi(cpu, SMP_MSG_FUNCTION);
 }
 
 void smp_timer_broadcast(const struct cpumask *mask)
@@ -309,9 +309,6 @@ void smp_message_recv(unsigned int msg)
 	case SMP_MSG_RESCHEDULE:
 		scheduler_ipi();
 		break;
-	case SMP_MSG_FUNCTION_SINGLE:
-		generic_smp_call_function_single_interrupt();
-		break;
 	case SMP_MSG_TIMER:
 		ipi_timer();
 		break;
-- 
1.7.10.4

