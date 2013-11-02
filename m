Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab3KBMSu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 08:18:50 -0400
Received: from us01smtp2.synopsys.com ([198.182.44.80]:41451 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab3KBMSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 08:18:48 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Noam Camus <noamc@ezchip.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>, <stable@vger.kernel.org>
Subject: [PATCH] ARC: Incorrect mm reference used in vmalloc fault handler
Date: Sat, 2 Nov 2013 17:47:49 +0530
Message-ID: <1383394669-20175-2-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383394669-20175-1-git-send-email-vgupta@synopsys.com>
References: <1383394669-20175-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A vmalloc fault needs to sync up PGD/PTE entry from init_mm to current task's
"active_mm". ARC vmalloc fault handler however was using mm.

A vmalloc fault for non user task context (actually pre-userland, from
init thread's open for /dev/console) caused the handler to deref NULL mm
(for mm->pgd)

The reasons it worked so far is amazing:

1. By default (!SMP), vmalloc fault handler uses a cached value of PGD.
   In SMP that MMU register is repurposed hence need for mm pointer deref.

2. In pre-3.12 SMP kernel, the problem triggering vmalloc didn't exist in
   pre-userland code path - it was introduced with commit 20bafb3d23d108bc
   "n_tty: Move buffers into n_tty_data"

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Noam Camus <noamc@ezchip.com>
Cc: stable@vger.kernel.org    #3.10 and 3.11
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: linux-kernel@vger.kernel.org
---
 arch/arc/mm/fault.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arc/mm/fault.c b/arch/arc/mm/fault.c
index 81554ded1260..9c69552350c4 100644
--- a/arch/arc/mm/fault.c
+++ b/arch/arc/mm/fault.c
@@ -17,7 +17,7 @@
 #include <asm/pgalloc.h>
 #include <asm/mmu.h>
 
-static int handle_vmalloc_fault(struct mm_struct *mm, unsigned long address)
+static int handle_vmalloc_fault(unsigned long address)
 {
 	/*
 	 * Synchronize this task's top level page-table
@@ -27,7 +27,7 @@ static int handle_vmalloc_fault(struct mm_struct *mm, unsigned long address)
 	pud_t *pud, *pud_k;
 	pmd_t *pmd, *pmd_k;
 
-	pgd = pgd_offset_fast(mm, address);
+	pgd = pgd_offset_fast(current->active_mm, address);
 	pgd_k = pgd_offset_k(address);
 
 	if (!pgd_present(*pgd_k))
@@ -72,7 +72,7 @@ void do_page_fault(unsigned long address, struct pt_regs *regs)
 	 * nothing more.
 	 */
 	if (address >= VMALLOC_START && address <= VMALLOC_END) {
-		ret = handle_vmalloc_fault(mm, address);
+		ret = handle_vmalloc_fault(address);
 		if (unlikely(ret))
 			goto bad_area_nosemaphore;
 		else
-- 
1.8.1.2

