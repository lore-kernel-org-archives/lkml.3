Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaJGATz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 20:19:55 -0400
Received: from outbound-smtp01.blacknight.com ([81.17.249.7]:58578 "EHLO
	outbound-smtp01.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752094AbaJGATx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 20:19:53 -0400
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, davej@redhat.com,
        hmh@hmh.eng.br
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: [PATCH 1/2] x86: Quark: Comment setup_arch() to document TLB/PGE bug
Date: Tue,  7 Oct 2014 01:19:48 +0100
Message-Id: <1412641189-12415-2-git-send-email-pure.logic@nexus-software.ie>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412641189-12415-1-git-send-email-pure.logic@nexus-software.ie>
References: <1412641189-12415-1-git-send-email-pure.logic@nexus-software.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quark SoC X1000 advertises Page Global Enable for it's
Translation Lookaside Buffer via cpuid. The silicon does not
in fact support PGE and hence will not flush the TLB when CR4.PGE
is rewritten. The Quark documentation makes clear the necessity to
instead rewrite CR3 in order to flush any TLB entries, irrespective
of the state of CR4.PGE or an individual PTE.PGE

See Intel Quark Core DevMan_001.pdf section 6.4.11

In setup.c setup_arch() the code will load_cr3() and then do a
__flush_tlb_all().

On Quark the entire TLB will be flushed at the load_cr3().
The __flush_tlb_all() have no effect and can be safely ignored.

Later on in the boot process we switch off the flag for cpu_has_pge()
which means that subsequent calls to __flush_tlb_all() will
call __flush_tlb() not __flush_tlb_global() flushing the TLB in the
correct way via load_cr3() not CR4.PGE rewrite

This patch documents the behaviour of flushing the TLB for Quark in
setup_arch()

Comment text suggested by Thomas Gleixner

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

