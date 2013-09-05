Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965158Ab3IELBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 07:01:03 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:18718 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964843Ab3IELBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 07:01:01 -0400
From: Libin <huawei.libin@huawei.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <fenghua.yu@intel.com>, <paul.gortmaker@windriver.com>
CC: <linux-kernel@vger.kernel.org>, <guohanjun@huawei.com>,
        <wangyijing@huawei.com>
Subject: [PATCH] x86, smpboot: fix announce_cpu() to print the last OK
Date: Thu, 5 Sep 2013 18:57:56 +0800
Message-ID: <1378378676-18276-1-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting cpu, announce_cpu() is called to show which cpu is up
as following:
[    0.402751] smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 OK
[    0.525667] smpboot: Booting Node   1, Processors  #6 #7 #8 #9 #10 #11 OK
[    0.755592] smpboot: Booting Node   0, Processors  #12 #13 #14 #15 #16 #17 OK
[    0.890495] smpboot: Booting Node   1, Processors  #18 #19 #20 #21 #22 #23
But the last OK is lost, because 'nr_cpu_ids-1' represents the maxinum possible
cpu id. It should use the maxinum present cpu id.

Signed-off-by: Libin <huawei.libin@huawei.com>
---
 arch/x86/kernel/smpboot.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index aecc98a..549b8cb 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -653,6 +653,8 @@ static void announce_cpu(int cpu, int apicid)
 {
 	static int current_node = -1;
 	int node = early_cpu_to_node(cpu);
+	int max_cpu_present =
+	    find_last_bit(cpumask_bits(cpu_present_mask), NR_CPUS);
 
 	if (system_state == SYSTEM_BOOTING) {
 		if (node != current_node) {
@@ -661,7 +663,7 @@ static void announce_cpu(int cpu, int apicid)
 			current_node = node;
 			pr_info("Booting Node %3d, Processors ", node);
 		}
-		pr_cont(" #%d%s", cpu, cpu == (nr_cpu_ids - 1) ? " OK\n" : "");
+		pr_cont(" #%d%s", cpu, cpu == max_cpu_present ? " OK\n" : "");
 		return;
 	} else
 		pr_info("Booting Node %d Processor %d APIC 0x%x\n",
-- 
1.8.2.1


