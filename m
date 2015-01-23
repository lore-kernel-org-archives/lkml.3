Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbbAWFgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:36:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:23509 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265AbbAWFge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:36:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="444042462"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [Resend Patch v4 14/16] smp, s390: Kill SMP single function call interrupt
Date: Fri, 23 Jan 2015 13:36:53 +0800
Message-Id: <1421991416-20297-15-git-send-email-jiang.liu@linux.intel.com>
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

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Acked-by: Heiko Carstens <heiko.carst...@de.ibm.com>
---
 arch/s390/kernel/smp.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 0b499f5cbe19..5b89eabc3a01 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -50,7 +50,7 @@
 
 enum {
 	ec_schedule = 0,
-	ec_call_function_single,
+	ec_call_function,
 	ec_stop_cpu,
 };
 
@@ -416,8 +416,8 @@ static void smp_handle_ext_call(void)
 		smp_stop_cpu();
 	if (test_bit(ec_schedule, &bits))
 		scheduler_ipi();
-	if (test_bit(ec_call_function_single, &bits))
-		generic_smp_call_function_single_interrupt();
+	if (test_bit(ec_call_function, &bits))
+		generic_smp_call_function_interrupt();
 }
 
 static void do_ext_call_interrupt(struct ext_code ext_code,
@@ -432,12 +432,12 @@ void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 	int cpu;
 
 	for_each_cpu(cpu, mask)
-		pcpu_ec_call(pcpu_devices + cpu, ec_call_function_single);
+		pcpu_ec_call(pcpu_devices + cpu, ec_call_function);
 }
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	pcpu_ec_call(pcpu_devices + cpu, ec_call_function_single);
+	pcpu_ec_call(pcpu_devices + cpu, ec_call_function);
 }
 
 #ifndef CONFIG_64BIT
-- 
1.7.10.4

