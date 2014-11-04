Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaKDTQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:16:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60767 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaKDTQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:16:10 -0500
Date: Tue, 4 Nov 2014 11:15:54 -0800
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-2c773dd31fbacbbb6425f8a9d3f97e0010272368@git.kernel.org>
Cc: mingo@kernel.org, JBeulich@suse.com, jbeulich@suse.com, hpa@zytor.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org
Reply-To: mingo@kernel.org, JBeulich@suse.com, jbeulich@suse.com,
        hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <54589BD20200007800044A84@mail.emea.novell.com>
References: <54589BD20200007800044A84@mail.emea.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86:
  Convert a few more per-CPU items to read-mostly ones
Git-Commit-ID: 2c773dd31fbacbbb6425f8a9d3f97e0010272368
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

Commit-ID:  2c773dd31fbacbbb6425f8a9d3f97e0010272368
Gitweb:     http://git.kernel.org/tip/2c773dd31fbacbbb6425f8a9d3f97e0010272368
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Tue, 4 Nov 2014 08:26:42 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Nov 2014 20:13:28 +0100

x86: Convert a few more per-CPU items to read-mostly ones

Both this_cpu_off and cpu_info aren't getting modified post boot, yet
are being accessed on enough code paths that grouping them with other
frequently read items seems desirable. For cpu_info this at the same
time implies removing the cache line alignment (which afaict became
pointless when it got converted to per-CPU data years ago).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/54589BD20200007800044A84@mail.emea.novell.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/percpu.h    | 2 +-
 arch/x86/include/asm/processor.h | 4 ++--
 arch/x86/kernel/setup_percpu.c   | 2 +-
 arch/x86/kernel/smpboot.c        | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index fd47218..74da317 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -522,7 +522,7 @@ static inline int x86_this_cpu_variable_test_bit(int nr,
 #include <asm-generic/percpu.h>
 
 /* We can use this directly for local CPU (faster). */
-DECLARE_PER_CPU(unsigned long, this_cpu_off);
+DECLARE_PER_CPU_READ_MOSTLY(unsigned long, this_cpu_off);
 
 #endif /* !__ASSEMBLY__ */
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index eb71ec7..3aeb31c 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -127,7 +127,7 @@ struct cpuinfo_x86 {
 	/* Index into per_cpu list: */
 	u16			cpu_index;
 	u32			microcode;
-} __attribute__((__aligned__(SMP_CACHE_BYTES)));
+};
 
 #define X86_VENDOR_INTEL	0
 #define X86_VENDOR_CYRIX	1
@@ -151,7 +151,7 @@ extern __u32			cpu_caps_cleared[NCAPINTS];
 extern __u32			cpu_caps_set[NCAPINTS];
 
 #ifdef CONFIG_SMP
-DECLARE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
+DECLARE_PER_CPU_READ_MOSTLY(struct cpuinfo_x86, cpu_info);
 #define cpu_data(cpu)		per_cpu(cpu_info, cpu)
 #else
 #define cpu_info		boot_cpu_data
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 5cdff03..e4fcb87 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -30,7 +30,7 @@ EXPORT_PER_CPU_SYMBOL(cpu_number);
 #define BOOT_PERCPU_OFFSET 0
 #endif
 
-DEFINE_PER_CPU(unsigned long, this_cpu_off) = BOOT_PERCPU_OFFSET;
+DEFINE_PER_CPU_READ_MOSTLY(unsigned long, this_cpu_off) = BOOT_PERCPU_OFFSET;
 EXPORT_PER_CPU_SYMBOL(this_cpu_off);
 
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly = {
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 4d2128a..a03ec604 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -99,7 +99,7 @@ EXPORT_PER_CPU_SYMBOL(cpu_core_map);
 DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_llc_shared_map);
 
 /* Per CPU bogomips and other parameters */
-DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
+DEFINE_PER_CPU_READ_MOSTLY(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
 
 atomic_t init_deasserted;
