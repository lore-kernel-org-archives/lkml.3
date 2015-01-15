Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbbAOVW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:22:59 -0500
Received: from www.linutronix.de ([62.245.132.108]:58414 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178AbbAOVWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:22:55 -0500
Message-Id: <20150115211703.827943883@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 15 Jan 2015 21:22:39 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [patch 19/23] init: Get rid of x86isms
References: <20150115210458.625399149@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=init-get-rid-of-x86-isms.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The UP local API support can be set up from an early initcall. No need
for horrible hackery in the init code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic.c |    3 +++
 init/main.c                 |   14 +-------------
 2 files changed, 4 insertions(+), 13 deletions(-)

Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -2264,6 +2264,9 @@ int __init APIC_init_uniprocessor(void)
 	x86_init.timers.setup_percpu_clockev();
 	return 0;
 }
+#ifndef CONFIG_SMP
+early_initcall(APIC_init_uniprocessor);
+#endif
 
 /*
  * Power management
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
@@ -351,15 +347,7 @@ __setup("rdinit=", rdinit_setup);
 
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
+static inline void smp_init(void) { }
 static inline void setup_nr_cpu_ids(void) { }
 static inline void smp_prepare_cpus(unsigned int maxcpus) { }
 #endif


