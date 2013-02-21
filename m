Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab3BUBpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 20:45:52 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:59649 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3BUBpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 20:45:50 -0500
From: Samu Kallio <samu.kallio@aberdeencloud.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
        Samu Kallio <samu.kallio@aberdeencloud.com>
Subject: [PATCH] x86: mm: Fix vmalloc_fault oops during lazy MMU updates
Date: Thu, 21 Feb 2013 03:45:33 +0200
Message-Id: <1361411133-6956-1-git-send-email-samu.kallio@aberdeencloud.com>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In paravirtualized x86_64 kernels, vmalloc_fault may cause an oops
when lazy MMU updates are enabled, because set_pgd effects are being
deferred.

One instance of this problem is during process mm cleanup with memory
cgroups enabled. The chain of events is as follows:

- zap_pte_range enables lazy MMU updates
- zap_pte_range eventually calls mem_cgroup_charge_statistics,
  which accesses the vmalloc'd mem_cgroup per-cpu stat area
- vmalloc_fault is triggered which tries to sync the corresponding
  PGD entry with set_pgd, but the update is deferred
- vmalloc_fault oopses due to a mismatch in the PUD entries

Calling arch_flush_lazy_mmu_mode immediately after set_pgd makes the
changes visible to the consistency checks.

Signed-off-by: Samu Kallio <samu.kallio@aberdeencloud.com>
---
 arch/x86/mm/fault.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 027088f..3ba3dba 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -378,10 +378,12 @@ static noinline __kprobes int vmalloc_fault(unsigned long address)
 	if (pgd_none(*pgd_ref))
 		return -1;
 
-	if (pgd_none(*pgd))
+	if (pgd_none(*pgd)) {
 		set_pgd(pgd, *pgd_ref);
-	else
+		arch_flush_lazy_mmu_mode();
+	} else {
 		BUG_ON(pgd_page_vaddr(*pgd) != pgd_page_vaddr(*pgd_ref));
+	}
 
 	/*
 	 * Below here mismatches are bugs because these lower tables
-- 
1.8.1.3

