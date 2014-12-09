Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbaLIQDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:03:19 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:63995 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbaLIQDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:03:17 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE...),
        Toshi Kani <toshi.kani@hp.com>, Igor Mammedov <imammedo@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE...)
Subject: [RFC PATCH] smpboot: Check for successfull allocation of cpumask vars
Date: Tue,  9 Dec 2014 11:03:17 -0500
Message-Id: <1418140999-29092-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zalloc_cpumask_var() can return 0 on allocation failure when
CONFIG_CPUMASK_OFFSTACK is set. Check for the return value and WARN() on failure
of an allocation in such cases.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 arch/x86/kernel/smpboot.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7a8f584..9b1df21 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1083,6 +1083,7 @@ static void __init smp_cpu_index_default(void)
 void __init native_smp_prepare_cpus(unsigned int max_cpus)
 {
 	unsigned int i;
+	bool ret = true;
 
 	preempt_disable();
 	smp_cpu_index_default();
@@ -1096,9 +1097,12 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 
 	current_thread_info()->cpu = 0;  /* needed? */
 	for_each_possible_cpu(i) {
-		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
-		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
-		zalloc_cpumask_var(&per_cpu(cpu_llc_shared_map, i), GFP_KERNEL);
+		ret &= zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
+		ret &= zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
+		ret &= zalloc_cpumask_var(&per_cpu(cpu_llc_shared_map, i), GFP_KERNEL);
+
+		if (WARN(!ret, "cpumask alloc for cpu %d failed!", i))
+			break;
 	}
 	set_cpu_sibling_map(0);
 
-- 
1.9.1

