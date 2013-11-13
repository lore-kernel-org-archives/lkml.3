Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab3KMTnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 14:43:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54602 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab3KMTnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 14:43:18 -0500
Date: Wed, 13 Nov 2013 11:43:06 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-aa0d53260596c1bef23547537724d4bad78e6f52@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tony.luck@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, tony.luck@intel.com
In-Reply-To: <20130917183628.857145384@linutronix.de>
References: <20130917183628.857145384@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] ia64: Use preempt_schedule_irq
Git-Commit-ID: aa0d53260596c1bef23547537724d4bad78e6f52
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 13 Nov 2013 11:43:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aa0d53260596c1bef23547537724d4bad78e6f52
Gitweb:     http://git.kernel.org/tip/aa0d53260596c1bef23547537724d4bad78e6f52
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 17 Sep 2013 18:53:08 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 13 Nov 2013 20:21:47 +0100

ia64: Use preempt_schedule_irq

Use the proper core function instead of fiddling with PREEMPT_ACTIVE
and enable/disable interrupts in the low level code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org
Link: http://lkml.kernel.org/r/20130917183628.857145384@linutronix.de
---
 arch/ia64/kernel/entry.S | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/arch/ia64/kernel/entry.S b/arch/ia64/kernel/entry.S
index 7a53530..ddea607f 100644
--- a/arch/ia64/kernel/entry.S
+++ b/arch/ia64/kernel/entry.S
@@ -1169,21 +1169,8 @@ skip_rbs_switch:
 .work_pending:
 	tbit.z p6,p0=r31,TIF_NEED_RESCHED	// is resched not needed?
 (p6)	br.cond.sptk.few .notify
-#ifdef CONFIG_PREEMPT
-(pKStk) dep r21=-1,r0,PREEMPT_ACTIVE_BIT,1
-	;;
-(pKStk) st4 [r20]=r21
-#endif
-	SSM_PSR_I(p0, p6, r2)	// enable interrupts
-	br.call.spnt.many rp=schedule
+	br.call.spnt.many rp=preempt_schedule_irq
 .ret9:	cmp.eq p6,p0=r0,r0	// p6 <- 1 (re-check)
-	RSM_PSR_I(p0, r2, r20)	// disable interrupts
-	;;
-#ifdef CONFIG_PREEMPT
-(pKStk)	adds r20=TI_PRE_COUNT+IA64_TASK_SIZE,r13
-	;;
-(pKStk)	st4 [r20]=r0		// preempt_count() <- 0
-#endif
 (pLvSys)br.cond.sptk.few  __paravirt_pending_syscall_end
 	br.cond.sptk.many .work_processed_kernel
 
