Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbaIXRHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:07:36 -0400
Received: from outbound-smtp02.blacknight.com ([81.17.249.8]:36162 "EHLO
	outbound-smtp02.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752611AbaIXRHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:07:35 -0400
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
To: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, pure.logic@nexus-software.ie
Subject: [PATCH] x86: Quark: Flush TLB via CR3 not CR4.PGE in setup_arch()
Date: Wed, 24 Sep 2014 18:07:32 +0100
Message-Id: <1411578452-4609-1-git-send-email-pure.logic@nexus-software.ie>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quark X1000 requires CR3 to be rewritten to flush TLB entries
irrespective of the PGE bits in CR4 or PTE.PGE

This patch flushes the TLB in the required way for Quark in setup_arch()
See Quark Core_DevMan_001.pdf section 6.4.11

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
---
 arch/x86/kernel/setup.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 41ead8d..1d2396a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -879,7 +879,10 @@ void __init setup_arch(char **cmdline_p)
 			KERNEL_PGD_PTRS);
 
 	load_cr3(swapper_pg_dir);
-	__flush_tlb_all();
+	if (boot_cpu_data.x86 == 5 && boot_cpu_data.x86_model == 9)
+		__flush_tlb();
+	else
+		__flush_tlb_all();
 #else
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
-- 
1.9.1

