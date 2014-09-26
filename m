Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbaIZRWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:22:36 -0400
Received: from outbound-smtp01.blacknight.com ([81.17.249.7]:41108 "EHLO
	outbound-smtp01.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755338AbaIZRWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:22:33 -0400
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
To: hpa@zytor.org, mingo@redhat.com, tglx@linutronix.de, hmh@hmh.eng.br,
        boon.leong.ong@intel.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: [PATCH] x86: Quark: Add if/else to setup_arch for Quark TLB bug
Date: Fri, 26 Sep 2014 18:19:45 +0100
Message-Id: <1411751985-4351-1-git-send-email-pure.logic@nexus-software.ie>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quark X1000 incorrectly advertises PGE. In later the stages of boot
specifically in early_init_intel we setup_clear_cpu_cap for PGE.
At this point in time cpu_has_pge() will still be true.

Use the boot_cpu_data to decide if __flush_tlb_all() or __flush_tlb()
should be called subsequent to loading CR3

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
---
 arch/x86/kernel/setup.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 41ead8d..8e61d5e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -879,7 +879,20 @@ void __init setup_arch(char **cmdline_p)
 			KERNEL_PGD_PTRS);
 
 	load_cr3(swapper_pg_dir);
-	__flush_tlb_all();
+
+	/*
+	 * Flush the TLB after loading CR3
+	 *
+	 * Quark X1000 wrongly advertises PGE. Use boot_cpu_data to
+	 * to make sure the TLB is flushed correctly in the early
+	 * stage of setup_arch() for Quark X1000.
+	 * X86_FEATURE_PGE flag is only setup later stage at
+	 * early_cpu_init();
+	 */
+	if (boot_cpu_data.x86 == 5 && boot_cpu_data.x86_model == 9)
+		__flush_tlb();
+	else
+		__flush_tlb_all();
 #else
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
-- 
1.9.1

