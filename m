Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab3JVQJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:09:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:38706 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092Ab3JVQII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:08:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="311160586"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        rusty@rustcorp.com.au
Subject: [PATCH 2/7] x86, asmlinkage, lguest: Fix C functions used by inline assembler
Date: Tue, 22 Oct 2013 09:07:54 -0700
Message-Id: <1382458079-24450-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382458079-24450-1-git-send-email-andi@firstfloor.org>
References: <1382458079-24450-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

- Make the C code used by the paravirt stubs visible
- Since they have to be global now, give them a more unique
name.

Cc: rusty@rustcorp.com.au
Cc: x86@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/lguest/boot.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index bdf8532..ad1fb5f 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -233,13 +233,13 @@ static void lguest_end_context_switch(struct task_struct *next)
  * flags word contains all kind of stuff, but in practice Linux only cares
  * about the interrupt flag.  Our "save_flags()" just returns that.
  */
-static unsigned long save_fl(void)
+asmlinkage unsigned long lguest_save_fl(void)
 {
 	return lguest_data.irq_enabled;
 }
 
 /* Interrupts go off... */
-static void irq_disable(void)
+asmlinkage void lguest_irq_disable(void)
 {
 	lguest_data.irq_enabled = 0;
 }
@@ -253,8 +253,8 @@ static void irq_disable(void)
  * PV_CALLEE_SAVE_REGS_THUNK(), which pushes %eax onto the stack, calls the
  * C function, then restores it.
  */
-PV_CALLEE_SAVE_REGS_THUNK(save_fl);
-PV_CALLEE_SAVE_REGS_THUNK(irq_disable);
+PV_CALLEE_SAVE_REGS_THUNK(lguest_save_fl);
+PV_CALLEE_SAVE_REGS_THUNK(lguest_irq_disable);
 /*:*/
 
 /* These are in i386_head.S */
@@ -1291,9 +1291,9 @@ __init void lguest_init(void)
 	 */
 
 	/* Interrupt-related operations */
-	pv_irq_ops.save_fl = PV_CALLEE_SAVE(save_fl);
+	pv_irq_ops.save_fl = PV_CALLEE_SAVE(lguest_save_fl);
 	pv_irq_ops.restore_fl = __PV_IS_CALLEE_SAVE(lg_restore_fl);
-	pv_irq_ops.irq_disable = PV_CALLEE_SAVE(irq_disable);
+	pv_irq_ops.irq_disable = PV_CALLEE_SAVE(lguest_irq_disable);
 	pv_irq_ops.irq_enable = __PV_IS_CALLEE_SAVE(lg_irq_enable);
 	pv_irq_ops.safe_halt = lguest_safe_halt;
 
-- 
1.8.3.1

