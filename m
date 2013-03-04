Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab3CDFmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 00:42:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:37438 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab3CDFmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 00:42:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,777,1355126400"; 
   d="scan'208";a="298563574"
From: Illyas Mansoor <illyas.mansoor@intel.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: X86 <x86@kernel.org>, Len Brown <lenb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Tejun Heo <tj@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Illyas Mansoor" <illyas.mansoor@intel.com>,
        "Rudramuni, Vishwesh M" <vishwesh.m.rudramuni@intel.com>,
        richard@nod.at, josh@joshtriplett.org,
        "Kumar P, Mahesh" <mahesh.kumar.p@intel.com>,
        "Sil, Dyut K" <dyut.k.sil@intel.com>
Subject: [PATCH] x86: fix idle notifier not being called in CONFIG_X86_32
Date: Mon,  4 Mar 2013 11:11:13 +0530
Message-Id: <1362375673-29287-1-git-send-email-illyas.mansoor@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Idle notifier not registered if CONFIG_X86_32 is defined,
those callbacks are empty for X86_32 platform.

ifdef CONFIG_X86_64
 void enter_idle(void);
 void exit_idle(void);
else
static inline void enter_idle(void) { }
static inline void exit_idle(void) { }
static inline void __exit_idle(void) { }
endif

Make this work on X86_32 platforms by
removing the restriction for X86_64

Signed-off-by: Dyut Kumar Sil <dyut.k.sil@intel.com>
Signed-off-by: Ashish K <ashish.k@intel.com>
Signed-off-by: Illyas Mansoor <illyas.mansoor@intel.com>
Reviewed-by: Cuesta, Fernand <fernand.cuesta@intel.com>
Reviewed-by: Cuesta, Fernand <fernand.cuesta@intel.com>
Reviewed-by: Kumar P, Mahesh <mahesh.kumar.p@intel.com>
Tested-by: Cuesta, Fernand <fernand.cuesta@intel.com>
---
 arch/x86/include/asm/idle.h |    6 ------
 arch/x86/kernel/process.c   |    4 ----
 2 files changed, 10 deletions(-)

diff --git a/arch/x86/include/asm/idle.h b/arch/x86/include/asm/idle.h
index c5d1785..489ac46 100644
--- a/arch/x86/include/asm/idle.h
+++ b/arch/x86/include/asm/idle.h
@@ -8,14 +8,8 @@ struct notifier_block;
 void idle_notifier_register(struct notifier_block *n);
 void idle_notifier_unregister(struct notifier_block *n);
 
-#ifdef CONFIG_X86_64
 void enter_idle(void);
 void exit_idle(void);
-#else /* !CONFIG_X86_64 */
-static inline void enter_idle(void) { }
-static inline void exit_idle(void) { }
-static inline void __exit_idle(void) { }
-#endif /* CONFIG_X86_64 */
 
 void amd_e400_remove_cpu(int cpu);
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 14ae100..043e553 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -38,7 +38,6 @@
  */
 DEFINE_PER_CPU_SHARED_ALIGNED(struct tss_struct, init_tss) = INIT_TSS;
 
-#ifdef CONFIG_X86_64
 static DEFINE_PER_CPU(unsigned char, is_idle);
 static ATOMIC_NOTIFIER_HEAD(idle_notifier);
 
@@ -53,7 +52,6 @@ void idle_notifier_unregister(struct notifier_block *n)
 	atomic_notifier_chain_unregister(&idle_notifier, n);
 }
 EXPORT_SYMBOL_GPL(idle_notifier_unregister);
-#endif
 
 struct kmem_cache *task_xstate_cachep;
 EXPORT_SYMBOL_GPL(task_xstate_cachep);
@@ -277,7 +275,6 @@ static inline void play_dead(void)
 }
 #endif
 
-#ifdef CONFIG_X86_64
 void enter_idle(void)
 {
 	this_cpu_write(is_idle, 1);
@@ -299,7 +296,6 @@ void exit_idle(void)
 		return;
 	__exit_idle();
 }
-#endif
 
 /*
  * The idle thread. There's no useful work to be
-- 
1.7.9.5

