Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030257Ab3FTOsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:48:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47634 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab3FTOsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:48:52 -0400
Date: Thu, 20 Jun 2013 07:48:36 -0700
From: tip-bot for Michel Lespinasse <tipbot@zytor.com>
Message-ID: <tip-b52e0a7c4e4100f8683af508664e60e1603070f9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de, walken@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de, walken@google.com
In-Reply-To: <1370518875-1346-1-git-send-email-walken@google.com>
References: <1370518875-1346-1-git-send-email-walken@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix trigger_all_cpu_backtrace()
  implementation
Git-Commit-ID: b52e0a7c4e4100f8683af508664e60e1603070f9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 20 Jun 2013 07:48:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b52e0a7c4e4100f8683af508664e60e1603070f9
Gitweb:     http://git.kernel.org/tip/b52e0a7c4e4100f8683af508664e60e1603070f9
Author:     Michel Lespinasse <walken@google.com>
AuthorDate: Thu, 6 Jun 2013 04:41:15 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 20 Jun 2013 14:00:21 +0200

x86: Fix trigger_all_cpu_backtrace() implementation

The following change fixes the x86 implementation of
trigger_all_cpu_backtrace(), which was previously (accidentally,
as far as I can tell) disabled to always return false as on
architectures that do not implement this function.

trigger_all_cpu_backtrace(), as defined in include/linux/nmi.h,
should call arch_trigger_all_cpu_backtrace() if available, or
return false if the underlying arch doesn't implement this
function.

x86 did provide a suitable arch_trigger_all_cpu_backtrace()
implementation, but it wasn't actually being used because it was
declared in asm/nmi.h, which linux/nmi.h doesn't include. Also,
linux/nmi.h couldn't easily be fixed by including asm/nmi.h,
because that file is not available on all architectures.

I am proposing to fix this by moving the x86 definition of
arch_trigger_all_cpu_backtrace() to asm/irq.h.

Tested via: echo l > /proc/sysrq-trigger

Before the change, this uses a fallback implementation which
shows backtraces on active CPUs (using
smp_call_function_interrupt() )

After the change, this shows NMI backtraces on all CPUs

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1370518875-1346-1-git-send-email-walken@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/irq.h    | 5 +++++
 arch/x86/include/asm/nmi.h    | 4 +---
 arch/x86/kernel/apic/hw_nmi.c | 1 +
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index ba870bb..57873be 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -41,4 +41,9 @@ extern int vector_used_by_percpu_irq(unsigned int vector);
 
 extern void init_ISA_irqs(void);
 
+#ifdef CONFIG_X86_LOCAL_APIC
+void arch_trigger_all_cpu_backtrace(void);
+#define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
+#endif
+
 #endif /* _ASM_X86_IRQ_H */
diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index c0fa356..86f9301 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -18,9 +18,7 @@ extern int proc_nmi_enabled(struct ctl_table *, int ,
 			void __user *, size_t *, loff_t *);
 extern int unknown_nmi_panic;
 
-void arch_trigger_all_cpu_backtrace(void);
-#define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
-#endif
+#endif /* CONFIG_X86_LOCAL_APIC */
 
 #define NMI_FLAG_FIRST	1
 
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 31cb9ae..a698d71 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -9,6 +9,7 @@
  *
  */
 #include <asm/apic.h>
+#include <asm/nmi.h>
 
 #include <linux/cpumask.h>
 #include <linux/kdebug.h>
