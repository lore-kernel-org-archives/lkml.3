Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760709AbaGPRrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:47:36 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:50319 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760201AbaGPRqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:46:15 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, x86@kernel.org
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 2/5] random,x86: Add arch_get_slow_rng_u64
Date: Wed, 16 Jul 2014 10:45:57 -0700
Message-Id: <5778e65d5ca52bebbaa023e177d863e44f098e96.1405532533.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1405532533.git.luto@amacapital.net>
References: <cover.1405532533.git.luto@amacapital.net>
In-Reply-To: <cover.1405532533.git.luto@amacapital.net>
References: <cover.1405532533.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_get_slow_rng_u64 tries to get 64 bits of RNG seed data.  Unlike
arch_get_random_{bytes,seed}, etc., it makes no claims about entropy
content.  It's also likely to be much slower and should not be used
frequently.  That being said, it should be fast enough to call
several times during boot without any noticeable slowdown.

This initial implementation backs it with MSR_KVM_GET_RNG_SEED if
available.  The intent is for other hypervisor guest implementations
to implement this interface.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/Kconfig                   |  4 ++++
 arch/x86/include/asm/archslowrng.h | 30 ++++++++++++++++++++++++++++++
 arch/x86/kernel/kvm.c              | 22 ++++++++++++++++++++++
 include/linux/random.h             |  9 +++++++++
 4 files changed, 65 insertions(+)
 create mode 100644 arch/x86/include/asm/archslowrng.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a8f749e..4dfb539 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -593,6 +593,7 @@ config KVM_GUEST
 	bool "KVM Guest support (including kvmclock)"
 	depends on PARAVIRT
 	select PARAVIRT_CLOCK
+	select ARCH_SLOW_RNG
 	default y
 	---help---
 	  This option enables various optimizations for running under the KVM
@@ -627,6 +628,9 @@ config PARAVIRT_TIME_ACCOUNTING
 config PARAVIRT_CLOCK
 	bool
 
+config ARCH_SLOW_RNG
+       bool
+
 endif #HYPERVISOR_GUEST
 
 config NO_BOOTMEM
diff --git a/arch/x86/include/asm/archslowrng.h b/arch/x86/include/asm/archslowrng.h
new file mode 100644
index 0000000..c8e8d0d
--- /dev/null
+++ b/arch/x86/include/asm/archslowrng.h
@@ -0,0 +1,30 @@
+/*
+ * This file is part of the Linux kernel.
+ *
+ * Copyright (c) 2014 Andy Lutomirski
+ * Authors: Andy Lutomirski <luto@amacapital.net>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#ifndef ASM_X86_ARCHSLOWRANDOM_H
+#define ASM_X86_ARCHSLOWRANDOM_H
+
+#ifndef CONFIG_ARCH_SLOW_RNG
+# error archslowrng.h should not be included if !CONFIG_ARCH_SLOW_RNG
+#endif
+
+/*
+ * Performance is irrelevant here, so there's no point in using the
+ * paravirt ops mechanism.  Instead just use a function pointer.
+ */
+extern int (*arch_get_slow_rng_u64)(u64 *v);
+
+#endif /* ASM_X86_ARCHSLOWRANDOM_H */
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 3dd8e2c..8d64d28 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -416,6 +416,25 @@ void kvm_disable_steal_time(void)
 	wrmsr(MSR_KVM_STEAL_TIME, 0, 0);
 }
 
+static int nop_get_slow_rng_u64(u64 *v)
+{
+	return 0;
+}
+
+static int kvm_get_slow_rng_u64(u64 *v)
+{
+	/*
+	 * Allow migration from a hypervisor with the GET_RNG_SEED
+	 * feature to a hypervisor without it.
+	 */
+	if (rdmsrl_safe(MSR_KVM_GET_RNG_SEED, v) == 0)
+		return 1;
+	else
+		return 0;
+}
+
+int (*arch_get_slow_rng_u64)(u64 *v) = nop_get_slow_rng_u64;
+
 #ifdef CONFIG_SMP
 static void __init kvm_smp_prepare_boot_cpu(void)
 {
@@ -493,6 +512,9 @@ void __init kvm_guest_init(void)
 	if (kvmclock_vsyscall)
 		kvm_setup_vsyscall_timeinfo();
 
+	if (kvm_para_has_feature(KVM_FEATURE_GET_RNG_SEED))
+		arch_get_slow_rng_u64 = kvm_get_slow_rng_u64;
+
 #ifdef CONFIG_SMP
 	smp_ops.smp_prepare_boot_cpu = kvm_smp_prepare_boot_cpu;
 	register_cpu_notifier(&kvm_cpu_notifier);
diff --git a/include/linux/random.h b/include/linux/random.h
index 57fbbff..ceafbcf 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -106,6 +106,15 @@ static inline int arch_has_random_seed(void)
 }
 #endif
 
+#ifdef CONFIG_ARCH_SLOW_RNG
+# include <asm/archslowrng.h>
+#else
+static inline int arch_get_slow_rng_u64(u64 *v)
+{
+	return 0;
+}
+#endif
+
 /* Pseudo random number generator from numerical recipes. */
 static inline u32 next_pseudo_random32(u32 seed)
 {
-- 
1.9.3

