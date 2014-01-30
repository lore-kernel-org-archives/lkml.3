Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156AbaA3GWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 01:22:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52124 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaA3GWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 01:22:00 -0500
Date: Wed, 29 Jan 2014 22:21:31 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-9549b9b3479323a1ad6ae83eae8e98aa765994f0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, ak@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, ak@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1382458079-24450-3-git-send-email-andi@firstfloor.org>
References: <1382458079-24450-3-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] x86, asmlinkage, lguest:
  Fix C functions used by inline assembler
Git-Commit-ID: 9549b9b3479323a1ad6ae83eae8e98aa765994f0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 29 Jan 2014 22:21:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9549b9b3479323a1ad6ae83eae8e98aa765994f0
Gitweb:     http://git.kernel.org/tip/9549b9b3479323a1ad6ae83eae8e98aa765994f0
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Tue, 22 Oct 2013 09:07:54 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 29 Jan 2014 22:17:17 -0800

x86, asmlinkage, lguest: Fix C functions used by inline assembler

- Make the C code used by the paravirt stubs visible
- Since they have to be global now, give them a more unique
name.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1382458079-24450-3-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
 
