Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaI3XmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 19:42:10 -0400
Received: from outbound-smtp05.blacknight.com ([81.17.249.38]:40944 "EHLO
	outbound-smtp05.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751332AbaI3XmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 19:42:06 -0400
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, davej@redhat.com,
        hmh@hmh.eng.br
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: [PATCH 2/2] x86: Quark: Comment setup_arch for TLB/PGE bugfix
Date: Wed,  1 Oct 2014 00:41:57 +0100
Message-Id: <1412120517-14738-3-git-send-email-pure.logic@nexus-software.ie>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412120517-14738-1-git-send-email-pure.logic@nexus-software.ie>
References: <1412120517-14738-1-git-send-email-pure.logic@nexus-software.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quark X1000 requires CR3 to be rewritten to flush TLB entries
irrespective of the PGE bits in CR4 or PTE.PGE

Add a comment to setup_arch to indicate that the code

load_cr3(swapper_pg_dir);
__flush_tlb_all();

Will already have flushed the TLB @ the CR3 reload allowing us
to skip over a potential if/else for Quark.

This comment clearly states the bug, the behaviour we rely on
and the reason why we only do it this way - one time.

Later on cpu_has_pge() will be false due to a fixup in
intel_init_early() and __flush_tlb_all() will work as expected
from that point onwards

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
---
 arch/x86/kernel/setup.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 41ead8d..235cfd3 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -879,6 +879,15 @@ void __init setup_arch(char **cmdline_p)
 			KERNEL_PGD_PTRS);
 
 	load_cr3(swapper_pg_dir);
+	/*
+	 * Note: Quark X1000 CPUs advertise PGE incorrectly and require
+	 * a cr3 based tlb flush, so the following __flush_tlb_all()
+	 * will not flush anything because the cpu quirk which clears
+	 * X86_FEATURE_PGE has not been invoked yet. Though due to the
+	 * load_cr3() above the TLB has been flushed already. The
+	 * quirk is invoked before subsequent calls to __flush_tlb_all()
+	 * so proper operation is guaranteed.
+	 */
 	__flush_tlb_all();
 #else
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
-- 
1.9.1

