Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab3KIHGk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:06:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932797Ab3KIGwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vineet Gupta <vgupta@synopsys.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Noam Camus <noamc@ezchip.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.11 49/94] ARC: Incorrect mm reference used in vmalloc fault handler
Date: Fri,  8 Nov 2013 22:51:55 -0800
Message-Id: <20131109065207.739852448@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <Vineet.Gupta1@synopsys.com>

commit 9c41f4eeb9d51f3ece20428d35a3ea32cf3b5622 upstream.

A vmalloc fault needs to sync up PGD/PTE entry from init_mm to current
task's "active_mm".  ARC vmalloc fault handler however was using mm.

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
Cc: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/mm/fault.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
@@ -27,7 +27,7 @@ static int handle_vmalloc_fault(struct m
 	pud_t *pud, *pud_k;
 	pmd_t *pmd, *pmd_k;
 
-	pgd = pgd_offset_fast(mm, address);
+	pgd = pgd_offset_fast(current->active_mm, address);
 	pgd_k = pgd_offset_k(address);
 
 	if (!pgd_present(*pgd_k))
@@ -73,7 +73,7 @@ void do_page_fault(struct pt_regs *regs,
 	 * nothing more.
 	 */
 	if (address >= VMALLOC_START && address <= VMALLOC_END) {
-		ret = handle_vmalloc_fault(mm, address);
+		ret = handle_vmalloc_fault(address);
 		if (unlikely(ret))
 			goto bad_area_nosemaphore;
 		else


