Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaIYTVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:21:35 -0400
Received: from outbound-smtp05.blacknight.com ([81.17.249.38]:34711 "EHLO
	outbound-smtp05.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968AbaIYTVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:21:33 -0400
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
To: mingo@redhat.com, hpa@linuxtronix.de, hmh@hmh.eng.br, tglx@linuxtronix.de
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: [PATCH] x86: Quark: Comment setup_arch for TLB/PGE bugfix
Date: Thu, 25 Sep 2014 20:21:31 +0100
Message-Id: <1411672891-10319-1-git-send-email-pure.logic@nexus-software.ie>
X-Mailer: git-send-email 1.9.1
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
index 41ead8d..c59e2f8 100644
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
+	 * doing what it says.  Fortunately we have a cr3 flush here,
+	 * which is what is needed in this processor to flush TLBs, so
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

