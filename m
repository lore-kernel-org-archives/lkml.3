Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab3JDVj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 17:39:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:30818 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab3JDVjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 17:39:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1035,1371106800"; 
   d="scan'208";a="414189164"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>, fweisbec@gmail.com
Subject: [PATCH 6/6] x86: Allow disabling HW_BREAKPOINTS and PERF_EVENTS
Date: Fri,  4 Oct 2013 14:39:48 -0700
Message-Id: <1380922788-23112-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
References: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

As suggested by Ingo.

Make HW_BREAKPOINTS a config option. HW_BREAKPOINTS depends
on perf. This allows disabling PERF_EVENTS for systems that
don't need it (e.g. anything not used for development)

Disabling PERF_EVENTS saves over 700k of kernel text (~5% of my config)
and significant data/bss:

   text	   data	    bss	    dec	    hex	filename
13692640	1922416	1478656	17093712	104d450	obj/vmlinux
12980092	1787544	1470464	16238100	 f7c614	obj-noperf/vmlinux

I didn't make it depend on CONFIG_EXPERT for now, as the system
should be very usable even without it. To actually disable perf
a couple of options depending on it need to be disabled, including
KVM and HW_BREAKPOINTS.

Longer term it would be probably nice to have modular perf.

Cc: fweisbec@gmail.com
Cc: peterz@infradead.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/Kconfig         | 11 ++++++++---
 arch/x86/kernel/Makefile |  3 ++-
 arch/x86/kvm/Kconfig     |  1 +
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c9d2b81..a8418ed 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -67,9 +67,6 @@ config X86
 	select HAVE_KERNEL_XZ
 	select HAVE_KERNEL_LZO
 	select HAVE_KERNEL_LZ4
-	select HAVE_HW_BREAKPOINT
-	select HAVE_MIXED_BREAKPOINTS_REGS
-	select PERF_EVENTS
 	select HAVE_PERF_EVENTS_NMI
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
@@ -602,6 +599,14 @@ config SCHED_OMIT_FRAME_POINTER
 
 	  If in doubt, say "Y".
 
+config HW_BREAKPOINTS
+	bool "Enable hardware breakpoints support"
+	select HAVE_HW_BREAKPOINT
+	select HAVE_MIXED_BREAKPOINTS_REGS
+	---help---
+	  Enable support for x86 hardware breakpoints for debuggers
+	  and perf.  This will implicitly enable perf-events.
+
 menuconfig HYPERVISOR_GUEST
 	bool "Linux guest support"
 	---help---
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index a5408b9..1b09567 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -31,7 +31,7 @@ obj-$(CONFIG_X86_64)	+= vsyscall_64.o
 obj-$(CONFIG_X86_64)	+= vsyscall_emu_64.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o topology.o kdebugfs.o
-obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
+obj-y			+= alternative.o i8253.o pci-nommu.o
 obj-y			+= tsc.o io_delay.o rtc.o
 obj-y			+= pci-iommu_table.o
 obj-y			+= resource.o
@@ -73,6 +73,7 @@ obj-$(CONFIG_DOUBLEFAULT)	+= doublefault.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
 obj-$(CONFIG_VM86)		+= vm86_32.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
+obj-$(CONFIG_HW_BREAKPOINTS) 	+= hw_breakpoint.o
 
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 obj-$(CONFIG_APB_TIMER)		+= apb_timer.o
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index a47a3e5..de4190a 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -36,6 +36,7 @@ config KVM
 	select TASKSTATS
 	select TASK_DELAY_ACCT
 	select PERF_EVENTS
+	select HW_BREAKPOINTS
 	select HAVE_KVM_MSI
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	---help---
-- 
1.8.3.1

