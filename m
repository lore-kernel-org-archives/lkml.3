Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935427Ab3DPSgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:36:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:32307 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964891Ab3DPSgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:36:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,487,1363158000"; 
   d="scan'208";a="323228004"
From: "Luck, Tony" <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, magnus.damm@gmail.com
Subject: [PATCH] ia64: Make sure interrupts enabled when we "safe_halt()"
In-reply-to: <CA+8MBbL0Gp3Y7f8SEuOwV-CJB8Hf9OnjrpVp5E7twXXrGpDB_Q@mail.gmail.com>
Date: Tue, 16 Apr 2013 11:35:56 -0700
Message-Id: <516d9a0c26048eae9c@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit d166991234347215dc23fc9dc15a63a83a1a54e1
   idle: Implement generic idle function
Thomas Gleixner cleaned up many things but perturbed some
fragile code that was keeping ia64 alive. So we started
seeing:
   WARNING: at kernel/cpu/idle.c:94 cpu_idle_loop+0x360/0x380()
and other unpleasantness like system hangs during boot.

We really shouldn't ever halt with interrupts disabled.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

Please fold into the same branch as the generic idle changes.

diff --git a/arch/ia64/include/asm/irqflags.h b/arch/ia64/include/asm/irqflags.h
index 2b68d85..1bf2cf2 100644
--- a/arch/ia64/include/asm/irqflags.h
+++ b/arch/ia64/include/asm/irqflags.h
@@ -89,6 +89,7 @@ static inline bool arch_irqs_disabled(void)
 
 static inline void arch_safe_halt(void)
 {
+	arch_local_irq_enable();
 	ia64_pal_halt_light();	/* PAL_HALT_LIGHT */
 }
 
