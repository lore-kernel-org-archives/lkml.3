Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbaLJCec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 21:34:32 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:44593 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaLJCea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 21:34:30 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE...),
        Toshi Kani <toshi.kani@hp.com>, Igor Mammedov <imammedo@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE...)
Subject: [PATCH v2] smpboot: Check for successfull allocation of cpumask vars
Date: Tue,  9 Dec 2014 21:34:31 -0500
Message-Id: <1418178872-14949-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zalloc_cpumask_var() can return 0 on allocation failure when
CONFIG_CPUMASK_OFFSTACK is set. Check for the return value and warn on failure
of an allocation in such cases. Also remove the cpus from cpu masks so
that they are not accessed later on.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 arch/x86/kernel/smpboot.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7a8f584..35bc3f1 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1083,6 +1083,7 @@ static void __init smp_cpu_index_default(void)
 void __init native_smp_prepare_cpus(unsigned int max_cpus)
 {
 	unsigned int i;
+	bool ret = true;
 
 	preempt_disable();
 	smp_cpu_index_default();
@@ -1096,9 +1097,23 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 
 	current_thread_info()->cpu = 0;  /* needed? */
 	for_each_possible_cpu(i) {
-		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
-		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
-		zalloc_cpumask_var(&per_cpu(cpu_llc_shared_map, i), GFP_KERNEL);
+		ret &= zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
+		ret &= zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
+		ret &= zalloc_cpumask_var(&per_cpu(cpu_llc_shared_map, i), GFP_KERNEL);
+
+		if (!ret) {
+			/* cpumask allocation failed, remove this and next cpus from
+			 * possible/present/online/active masks
+			 */
+			pr_warn("cpumask allocation failed!\n");
+			for (; i < nr_cpu_ids; i = cpumask_next(i, &cpu_possible_mask)) {
+				set_cpu_possible(i, false);
+				set_cpu_active(i, false);
+				set_cpu_online(i, false);
+				set_cpu_present(i, false);
+			}
+			break;
+		}
 	}
 	set_cpu_sibling_map(0);
 
-- 
1.9.1

