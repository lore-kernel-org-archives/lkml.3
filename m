Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaKDI0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:26:47 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:36724 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaKDI0p convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Tue, 4 Nov 2014 03:26:45 -0500
Message-Id: <54589BD20200007800044A84@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Tue, 04 Nov 2014 08:26:42 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: convert a few more per-CPU items to read-mostly
 ones
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both this_cpu_off and cpu_info aren't getting modified post boot, yet
are being accessed on enough code paths that grouping them with other
frequently read items seems desirable. For cpu_info this at the same
time implies removing the cache line alignment (which afaict became
pointless when it got converted to per-CPU data years ago).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
 arch/x86/include/asm/percpu.h    |    2 +-
 arch/x86/include/asm/processor.h |    4 ++--
 arch/x86/kernel/setup_percpu.c   |    2 +-
 arch/x86/kernel/smpboot.c        |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- 3.18-rc3/arch/x86/include/asm/percpu.h
+++ 3.18-rc3-x86-cpu-info-read-mostly/arch/x86/include/asm/percpu.h
@@ -522,7 +522,7 @@ static inline int x86_this_cpu_variable_
 #include <asm-generic/percpu.h>
 
 /* We can use this directly for local CPU (faster). */
-DECLARE_PER_CPU(unsigned long, this_cpu_off);
+DECLARE_PER_CPU_READ_MOSTLY(unsigned long, this_cpu_off);
 
 #endif /* !__ASSEMBLY__ */
 
--- 3.18-rc3/arch/x86/include/asm/processor.h
+++ 3.18-rc3-x86-cpu-info-read-mostly/arch/x86/include/asm/processor.h
@@ -127,7 +127,7 @@ struct cpuinfo_x86 {
 	/* Index into per_cpu list: */
 	u16			cpu_index;
 	u32			microcode;
-} __attribute__((__aligned__(SMP_CACHE_BYTES)));
+};
 
 #define X86_VENDOR_INTEL	0
 #define X86_VENDOR_CYRIX	1
@@ -151,7 +151,7 @@ extern __u32			cpu_caps_cleared[NCAPINTS
 extern __u32			cpu_caps_set[NCAPINTS];
 
 #ifdef CONFIG_SMP
-DECLARE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
+DECLARE_PER_CPU_READ_MOSTLY(struct cpuinfo_x86, cpu_info);
 #define cpu_data(cpu)		per_cpu(cpu_info, cpu)
 #else
 #define cpu_info		boot_cpu_data
--- 3.18-rc3/arch/x86/kernel/setup_percpu.c
+++ 3.18-rc3-x86-cpu-info-read-mostly/arch/x86/kernel/setup_percpu.c
@@ -30,7 +30,7 @@ EXPORT_PER_CPU_SYMBOL(cpu_number);
 #define BOOT_PERCPU_OFFSET 0
 #endif
 
-DEFINE_PER_CPU(unsigned long, this_cpu_off) = BOOT_PERCPU_OFFSET;
+DEFINE_PER_CPU_READ_MOSTLY(unsigned long, this_cpu_off) = BOOT_PERCPU_OFFSET;
 EXPORT_PER_CPU_SYMBOL(this_cpu_off);
 
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly = {
--- 3.18-rc3/arch/x86/kernel/smpboot.c
+++ 3.18-rc3-x86-cpu-info-read-mostly/arch/x86/kernel/smpboot.c
@@ -99,7 +99,7 @@ EXPORT_PER_CPU_SYMBOL(cpu_core_map);
 DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_llc_shared_map);
 
 /* Per CPU bogomips and other parameters */
-DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
+DEFINE_PER_CPU_READ_MOSTLY(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
 
 atomic_t init_deasserted;



