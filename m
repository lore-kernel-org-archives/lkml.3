Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbbANHgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:36:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434AbbANHgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:36:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 3.14 68/77] arm64: kernel: fix __cpu_suspend mm switch on warm-boot
Date: Tue, 13 Jan 2015 23:23:48 -0800
Message-Id: <20150114072228.068594511@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072224.182299947@linuxfoundation.org>
References: <20150114072224.182299947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

commit f43c27188a49111b58e9611afa2f0365b0b55625 upstream.

On arm64 the TTBR0_EL1 register is set to either the reserved TTBR0
page tables on boot or to the active_mm mappings belonging to user space
processes, it must never be set to swapper_pg_dir page tables mappings.

When a CPU is booted its active_mm is set to init_mm even though its
TTBR0_EL1 points at the reserved TTBR0 page mappings. This implies
that when __cpu_suspend is triggered the active_mm can point at
init_mm even if the current TTBR0_EL1 register contains the reserved
TTBR0_EL1 mappings.

Therefore, the mm save and restore executed in __cpu_suspend might
turn out to be erroneous in that, if the current->active_mm corresponds
to init_mm, on resume from low power it ends up restoring in the
TTBR0_EL1 the init_mm mappings that are global and can cause speculation
of TLB entries which end up being propagated to user space.

This patch fixes the issue by checking the active_mm pointer before
restoring the TTBR0 mappings. If the current active_mm == &init_mm,
the code sets the TTBR0_EL1 to the reserved TTBR0 mapping instead of
switching back to the active_mm, which is the expected behaviour
corresponding to the TTBR0_EL1 settings when __cpu_suspend was entered.

Fixes: 95322526ef62 ("arm64: kernel: cpu_{suspend/resume} implementation")
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/suspend.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/arch/arm64/kernel/suspend.c
+++ b/arch/arm64/kernel/suspend.c
@@ -5,6 +5,7 @@
 #include <asm/debug-monitors.h>
 #include <asm/pgtable.h>
 #include <asm/memory.h>
+#include <asm/mmu_context.h>
 #include <asm/smp_plat.h>
 #include <asm/suspend.h>
 #include <asm/tlbflush.h>
@@ -98,7 +99,18 @@ int __cpu_suspend(unsigned long arg, int
 	 */
 	ret = __cpu_suspend_enter(arg, fn);
 	if (ret == 0) {
-		cpu_switch_mm(mm->pgd, mm);
+		/*
+		 * We are resuming from reset with TTBR0_EL1 set to the
+		 * idmap to enable the MMU; restore the active_mm mappings in
+		 * TTBR0_EL1 unless the active_mm == &init_mm, in which case
+		 * the thread entered __cpu_suspend with TTBR0_EL1 set to
+		 * reserved TTBR0 page tables and should be restored as such.
+		 */
+		if (mm == &init_mm)
+			cpu_set_reserved_ttbr0();
+		else
+			cpu_switch_mm(mm->pgd, mm);
+
 		flush_tlb_all();
 
 		/*


