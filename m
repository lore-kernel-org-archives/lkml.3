Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbaI3DMO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 23:12:14 -0400
Received: from outbound-smtp05.blacknight.com ([81.17.249.38]:49469 "EHLO
	outbound-smtp05.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754818AbaI3DL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 23:11:58 -0400
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
To: mingo@redhat.com, davej@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        hmh@hmh.eng.br, x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: [PATCH 3/3] x86: Quark: Comment setup_arch for TLB/PGE bugfix
Date: Tue, 30 Sep 2014 04:11:50 +0100
Message-Id: <1412046710-2686-4-git-send-email-pure.logic@nexus-software.ie>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412046710-2686-1-git-send-email-pure.logic@nexus-software.ie>
References: <1412046710-2686-1-git-send-email-pure.logic@nexus-software.ie>
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
 arch/x86/kernel/setup.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 41ead8d..98b6660 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -878,6 +878,18 @@ void __init setup_arch(char **cmdline_p)
 			initial_page_table + KERNEL_PGD_BOUNDARY,
 			KERNEL_PGD_PTRS);
 
+	/*
+	 * Locate the page directory and flush the TLB.
+	 *
+	 * On Quark X1000 CPUs we still have the PGE bit incorrectly set
+	 * due to a processor erratum, so __flush_tlb_all() is not yet
+	 * doing what it says.  Fortunately we have a cr3 load here,
+	 * which is what is needed on this processor to flush TLBs, so
+	 * there's no need to add a Quark X1000 quirk here.
+	 *
+	 * early_init_intel will unset the X86_FEATURE_PGE flag later
+	 * and __flush_tlb_all() will flush via cr3
+	 */
 	load_cr3(swapper_pg_dir);
 	__flush_tlb_all();
 #else
-- 
1.9.1

