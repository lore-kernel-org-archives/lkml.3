Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaIXU0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:26:09 -0400
Received: from outbound-smtp01.blacknight.com ([81.17.249.7]:47931 "EHLO
	outbound-smtp01.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020AbaIXU0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:26:07 -0400
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
To: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, pure.logic@nexus-software.ie
Subject: [PATCH] x86: Quark: Add comment on TLB flush to setup_arch
Date: Wed, 24 Sep 2014 21:26:03 +0100
Message-Id: <1411590363-8052-1-git-send-email-pure.logic@nexus-software.ie>
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
to skip over a potential if/else for Quark

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
---
 arch/x86/kernel/setup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 41ead8d..e7d7f6e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -878,6 +878,11 @@ void __init setup_arch(char **cmdline_p)
 			initial_page_table + KERNEL_PGD_BOUNDARY,
 			KERNEL_PGD_PTRS);
 
+	/*
+	 * Locate the page directory and flush the TLB.
+	 * On Quark X1000 rewriting CR3 flushes the TLB no if/else is required
+	 * to choose between __flush_tlb() and __flush_tlb_all()
+	 */
 	load_cr3(swapper_pg_dir);
 	__flush_tlb_all();
 #else
-- 
1.9.1

