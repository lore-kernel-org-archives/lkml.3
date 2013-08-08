Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966864Ab3HHXU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 19:20:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41008 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966455Ab3HHXUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 19:20:25 -0400
Date: Thu, 8 Aug 2013 16:20:07 -0700
From: tip-bot for Jeremy Fitzhardinge <tipbot@zytor.com>
Message-ID: <tip-80aefe73ea1611bb064f4dcfe49b1aa9648922b3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org,
        raghavendra.kt@linux.vnet.ibm.com, tglx@linutronix.de,
        hpa@linux.intel.com, attilio.rao@citrix.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org,
        raghavendra.kt@linux.vnet.ibm.com, tglx@linutronix.de,
        hpa@linux.intel.com, attilio.rao@citrix.com
In-Reply-To: <20130806114244.20643.21618.sendpatchset@codeblue.in.ibm.com>
References: <20130806114244.20643.21618.sendpatchset@codeblue.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] x86, pvticketlock:
  Use callee-save for lock_spinning
Git-Commit-ID: 80aefe73ea1611bb064f4dcfe49b1aa9648922b3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 08 Aug 2013 16:20:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  80aefe73ea1611bb064f4dcfe49b1aa9648922b3
Gitweb:     http://git.kernel.org/tip/80aefe73ea1611bb064f4dcfe49b1aa9648922b3
Author:     Jeremy Fitzhardinge <jeremy@goop.org>
AuthorDate: Tue, 6 Aug 2013 17:12:44 +0530
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 8 Aug 2013 16:06:46 -0700

x86, pvticketlock: Use callee-save for lock_spinning

Although the lock_spinning calls in the spinlock code are on the
uncommon path, their presence can cause the compiler to generate many
more register save/restores in the function pre/postamble, which is in
the fast path.  To avoid this, convert it to using the pvops callee-save
calling convention, which defers all the save/restores until the actual
function is called, keeping the fastpath clean.

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Link: http://lkml.kernel.org/r/20130806114244.20643.21618.sendpatchset@codeblue.in.ibm.com
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Tested-by: Attilio Rao <attilio.rao@citrix.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/paravirt.h       | 2 +-
 arch/x86/include/asm/paravirt_types.h | 2 +-
 arch/x86/kernel/paravirt-spinlocks.c  | 2 +-
 arch/x86/xen/spinlock.c               | 3 ++-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 040e72d..7131e12c 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -715,7 +715,7 @@ static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
 static __always_inline void __ticket_lock_spinning(struct arch_spinlock *lock,
 							__ticket_t ticket)
 {
-	PVOP_VCALL2(pv_lock_ops.lock_spinning, lock, ticket);
+	PVOP_VCALLEE2(pv_lock_ops.lock_spinning, lock, ticket);
 }
 
 static __always_inline void ____ticket_unlock_kick(struct arch_spinlock *lock,
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index d5deb6d..350d017 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -330,7 +330,7 @@ struct arch_spinlock;
 #include <asm/spinlock_types.h>
 
 struct pv_lock_ops {
-	void (*lock_spinning)(struct arch_spinlock *lock, __ticket_t ticket);
+	struct paravirt_callee_save lock_spinning;
 	void (*unlock_kick)(struct arch_spinlock *lock, __ticket_t ticket);
 };
 
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index c2e010e..4251c1d 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -9,7 +9,7 @@
 
 struct pv_lock_ops pv_lock_ops = {
 #ifdef CONFIG_SMP
-	.lock_spinning = paravirt_nop,
+	.lock_spinning = __PV_IS_CALLEE_SAVE(paravirt_nop),
 	.unlock_kick = paravirt_nop,
 #endif
 };
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 669a971..6c8792b 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -173,6 +173,7 @@ out:
 	local_irq_restore(flags);
 	spin_time_accum_blocked(start);
 }
+PV_CALLEE_SAVE_REGS_THUNK(xen_lock_spinning);
 
 static void xen_unlock_kick(struct arch_spinlock *lock, __ticket_t next)
 {
@@ -260,7 +261,7 @@ void __init xen_init_spinlocks(void)
 		return;
 	}
 
-	pv_lock_ops.lock_spinning = xen_lock_spinning;
+	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(xen_lock_spinning);
 	pv_lock_ops.unlock_kick = xen_unlock_kick;
 }
 
