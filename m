Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab3CLWd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:33:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab3CLWdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 049/100] ARM: 7658/1: mm: fix race updating mm->context.id on ASID rollover
Date: Tue, 12 Mar 2013 15:31:34 -0700
Message-Id: <20130312223128.263018588@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 37f47e3d62533c931b04cb409f2eb299e6342331 upstream.

If a thread triggers an ASID rollover, other threads of the same process
must be made to wait until the mm->context.id for the shared mm_struct
has been updated to new generation and associated book-keeping (e.g.
TLB invalidation) has ben performed.

However, there is a *tiny* window where both mm->context.id and the
relevant active_asids entry are updated to the new generation, but the
TLB flush has not been performed, which could allow another thread to
return to userspace with a dirty TLB, potentially leading to data
corruption. In reality this will never occur because one CPU would need
to perform a context-switch in the time it takes another to do a couple
of atomic test/set operations but we should plug the race anyway.

This patch moves the active_asids update until after the potential TLB
flush on context-switch.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/context.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/mm/context.c
+++ b/arch/arm/mm/context.c
@@ -204,11 +204,11 @@ void check_and_switch_context(struct mm_
 	if ((mm->context.id ^ atomic64_read(&asid_generation)) >> ASID_BITS)
 		new_context(mm, cpu);
 
-	atomic64_set(&per_cpu(active_asids, cpu), mm->context.id);
-	cpumask_set_cpu(cpu, mm_cpumask(mm));
-
 	if (cpumask_test_and_clear_cpu(cpu, &tlb_flush_pending))
 		local_flush_tlb_all();
+
+	atomic64_set(&per_cpu(active_asids, cpu), mm->context.id);
+	cpumask_set_cpu(cpu, mm_cpumask(mm));
 	raw_spin_unlock_irqrestore(&cpu_asid_lock, flags);
 
 switch_mm_fastpath:


