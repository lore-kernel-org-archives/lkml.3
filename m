Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbbAPLFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 06:05:45 -0500
Received: from www.linutronix.de ([62.245.132.108]:33272 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbbAPLFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 06:05:44 -0500
Date: Fri, 16 Jan 2015 12:05:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [patch 00/23] x86: Cleanup apic/ioapic/x2apic setup code
In-Reply-To: <alpine.DEB.2.11.1501161120560.5526@nanos>
Message-ID: <alpine.DEB.2.11.1501161203340.5526@nanos>
References: <20150115210458.625399149@linutronix.de> <54B8DBC1.6080205@linux.intel.com> <alpine.DEB.2.11.1501161120560.5526@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2015, Thomas Gleixner wrote:
> On Fri, 16 Jan 2015, Jiang Liu wrote:
> > 5) x86_32, UP, IO_APIC disabled
> > 5.1) boot: panic with following call stack:
> > do_ono_initcall()->APIC_init_uniprocessor()->setup_local_APIC().
> > I can't capture the full log message due to lack of serial console.
> > It seems we have trouble with:
> > early_initcall(APIC_init_uniprocessor);
> 
> Hmm, worked here. Lemme find some other machine.

Found the issue, won't work. But I still want to remove that x86
nonsense from init. So we need to do it different.

Subject: init: Get rid of x86isms
From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 14 Jan 2015 14:59:48 +0100

Provide a config option and make the UP smp_init() implementation
depend on it and confine this to x86.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig            |    4 ++++
 arch/x86/kernel/apic/apic.c |    7 +++++++
 include/linux/smp.h         |    6 ++++++
 init/main.c                 |   13 -------------
 4 files changed, 17 insertions(+), 13 deletions(-)

Index: tip/arch/x86/Kconfig
===================================================================
--- tip.orig/arch/x86/Kconfig
+++ tip/arch/x86/Kconfig
@@ -855,6 +855,10 @@ config SCHED_MC
 
 source "kernel/Kconfig.preempt"
 
+config UP_SMP_INIT
+       def_bool y
+       depends on X86_UP_APIC
+
 config X86_UP_APIC
 	bool "Local APIC support on uniprocessors"
 	depends on X86_32 && !SMP && !X86_32_NON_STANDARD && !PCI_MSI
Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -2265,6 +2265,13 @@ int __init APIC_init_uniprocessor(void)
 	return 0;
 }
 
+#ifdef CONFIG_UP_SMP_INIT
+void smp_init(void)
+{
+	APIC_init_uniprocessor();
+}
+#endif
+
 /*
  * Power management
  */
Index: tip/include/linux/smp.h
===================================================================
--- tip.orig/include/linux/smp.h
+++ tip/include/linux/smp.h
@@ -151,6 +151,12 @@ smp_call_function_any(const struct cpuma
 static inline void kick_all_cpus_sync(void) {  }
 static inline void wake_up_all_idle_cpus(void) {  }
 
+#ifdef CONFIG_UP_SMP_INIT
+extern void __init smp_init(void);
+#else
+static inline void smp_init(void) { }
+#endif
+
 #endif /* !SMP */
 
 /*
Index: tip/init/main.c
===================================================================
--- tip.orig/init/main.c
+++ tip/init/main.c
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



