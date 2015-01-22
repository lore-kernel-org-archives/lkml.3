Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbbAVObT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:31:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58033 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbbAVObP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:31:15 -0500
Date: Thu, 22 Jan 2015 06:30:51 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-30b8b0066cafef274fc92462578ee346211ce7cb@git.kernel.org>
Cc: hpa@zytor.com, jiang.liu@linux.intel.com, bp@alien8.de, joro@8bytes.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, tony.luck@intel.com,
        mingo@kernel.org
Reply-To: linux-kernel@vger.kernel.org, tglx@linutronix.de, joro@8bytes.org,
        hpa@zytor.com, bp@alien8.de, jiang.liu@linux.intel.com,
        mingo@kernel.org, tony.luck@intel.com
In-Reply-To: <20150115211703.827943883@linutronix.de>
References: <20150115211703.827943883@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] init: Get rid of x86isms
Git-Commit-ID: 30b8b0066cafef274fc92462578ee346211ce7cb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30b8b0066cafef274fc92462578ee346211ce7cb
Gitweb:     http://git.kernel.org/tip/30b8b0066cafef274fc92462578ee346211ce7cb
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 15 Jan 2015 21:22:39 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 15:10:56 +0100

init: Get rid of x86isms

The UP local API support can be set up from an early initcall. No need
for horrible hackery in the init code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/20150115211703.827943883@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig            |  4 ++++
 arch/x86/kernel/apic/apic.c |  7 +++++++
 include/linux/smp.h         |  7 +++++++
 init/main.c                 | 13 -------------
 4 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ba397bd..ffcc3ca 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -855,6 +855,10 @@ config SCHED_MC
 
 source "kernel/Kconfig.preempt"
 
+config UP_LATE_INIT
+       def_bool y
+       depends on X86_UP_APIC
+
 config X86_UP_APIC
 	bool "Local APIC support on uniprocessors"
 	depends on X86_32 && !SMP && !X86_32_NON_STANDARD && !PCI_MSI
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index c681e9b..19f1bc7 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2267,6 +2267,13 @@ int __init APIC_init_uniprocessor(void)
 	return 0;
 }
 
+#ifdef CONFIG_UP_LATE_INIT
+void __init up_late_init(void)
+{
+	APIC_init_uniprocessor();
+}
+#endif
+
 /*
  * Power management
  */
diff --git a/include/linux/smp.h b/include/linux/smp.h
index 93dff5f..be91db2 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -151,6 +151,13 @@ smp_call_function_any(const struct cpumask *mask, smp_call_func_t func,
 static inline void kick_all_cpus_sync(void) {  }
 static inline void wake_up_all_idle_cpus(void) {  }
 
+#ifdef CONFIG_UP_LATE_INIT
+extern void __init up_late_init(void);
+static inline void smp_init(void) { up_late_init(); }
+#else
+static inline void smp_init(void) { }
+#endif
+
 #endif /* !SMP */
 
 /*
diff --git a/init/main.c b/init/main.c
index 61b99376..179ada1 100644
--- a/init/main.c
+++ b/init/main.c
@@ -87,10 +87,6 @@
 #include <asm/sections.h>
 #include <asm/cacheflush.h>
 
-#ifdef CONFIG_X86_LOCAL_APIC
-#include <asm/smp.h>
-#endif
-
 static int kernel_init(void *);
 
 extern void init_IRQ(void);
@@ -351,15 +347,6 @@ __setup("rdinit=", rdinit_setup);
 
 #ifndef CONFIG_SMP
 static const unsigned int setup_max_cpus = NR_CPUS;
-#ifdef CONFIG_X86_LOCAL_APIC
-static void __init smp_init(void)
-{
-	APIC_init_uniprocessor();
-}
-#else
-#define smp_init()	do { } while (0)
-#endif
-
 static inline void setup_nr_cpu_ids(void) { }
 static inline void smp_prepare_cpus(unsigned int maxcpus) { }
 #endif
