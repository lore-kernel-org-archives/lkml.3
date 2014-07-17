Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbaGQSXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 14:23:14 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63258 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbaGQSWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 14:22:44 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, x86@kernel.org
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        bsd@redhat.com, Andrew Honig <ahonig@google.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v4 4/5] x86,random,kvm: Use KVM_GET_RNG_SEED in arch_get_rng_seed
Date: Thu, 17 Jul 2014 11:22:19 -0700
Message-Id: <10d52b136b02e8c43daa225423106e6989060728.1405620944.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1405620944.git.luto@amacapital.net>
References: <cover.1405620944.git.luto@amacapital.net>
In-Reply-To: <cover.1405620944.git.luto@amacapital.net>
References: <cover.1405620944.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a straightforward implementation: for each bit of internal
RNG state, request one bit from KVM_GET_RNG_SEED.  This is done even
if RDSEED/RDRAND worked, since KVM_GET_RNG_SEED is likely to provide
cryptographically secure output even if the CPU's RNG is weak or
compromised.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/Kconfig                 |  4 ++++
 arch/x86/include/asm/kvm_guest.h |  9 +++++++++
 arch/x86/kernel/archrandom.c     | 22 +++++++++++++++++++++-
 arch/x86/kernel/kvm.c            | 10 ++++++++++
 4 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a8f749e..adfa09c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -593,6 +593,7 @@ config KVM_GUEST
 	bool "KVM Guest support (including kvmclock)"
 	depends on PARAVIRT
 	select PARAVIRT_CLOCK
+	select ARCH_RANDOM
 	default y
 	---help---
 	  This option enables various optimizations for running under the KVM
@@ -1507,6 +1508,9 @@ config ARCH_RANDOM
 	  If supported, this is a high bandwidth, cryptographically
 	  secure hardware random number generator.
 
+	  This also enables paravirt RNGs such as KVM's if the relevant
+	  PV guest support is enabled.
+
 config X86_SMAP
 	def_bool y
 	prompt "Supervisor Mode Access Prevention" if EXPERT
diff --git a/arch/x86/include/asm/kvm_guest.h b/arch/x86/include/asm/kvm_guest.h
index a92b176..8c4dbd5 100644
--- a/arch/x86/include/asm/kvm_guest.h
+++ b/arch/x86/include/asm/kvm_guest.h
@@ -3,4 +3,13 @@
 
 int kvm_setup_vsyscall_timeinfo(void);
 
+#if defined(CONFIG_KVM_GUEST) && defined(CONFIG_ARCH_RANDOM)
+extern bool kvm_get_rng_seed(u64 *rv);
+#else
+static inline bool kvm_get_rng_seed(u64 *rv)
+{
+	return false;
+}
+#endif
+
 #endif /* _ASM_X86_KVM_GUEST_H */
diff --git a/arch/x86/kernel/archrandom.c b/arch/x86/kernel/archrandom.c
index 5515fc8..3bcfa58 100644
--- a/arch/x86/kernel/archrandom.c
+++ b/arch/x86/kernel/archrandom.c
@@ -15,6 +15,7 @@
  */
 
 #include <asm/archrandom.h>
+#include <asm/kvm_guest.h>
 
 void arch_get_rng_seed(void *ctx,
 		       void (*seed)(void *ctx, u32 data),
@@ -22,7 +23,7 @@ void arch_get_rng_seed(void *ctx,
 		       const char *log_prefix)
 {
 	int i, longs = (bits_per_source + BITS_PER_LONG - 1) / BITS_PER_LONG;
-	int rdseed_bits = 0, rdrand_bits = 0;
+	int rdseed_bits = 0, rdrand_bits = 0, kvm_bits = 0;
 	int rdrand_longs_wanted = 0;
 	char buf[128] = "";
 	char *msgptr = buf;
@@ -74,6 +75,25 @@ void arch_get_rng_seed(void *ctx,
 	if (rdrand_bits)
 		msgptr += sprintf(msgptr, ", %d bits from RDRAND", rdrand_bits);
 
+	/*
+	 * Use KVM_GET_RNG_SEED regardless of whether the CPU RNG worked,
+	 * since it incorporates entropy unavailable to the CPU.  We
+	 * request enough bits for the entire internal RNG state, because
+	 * there's no good reason not to.
+	 */
+	for (i = 0; i < (bits_per_source + 63) / 64; i++) {
+		u64 rv;
+
+		if (kvm_get_rng_seed(&rv)) {
+			seed(ctx, (u32)rv);
+			seed(ctx, (u32)(rv >> 32));
+			kvm_bits += 8 * sizeof(rv);
+		}
+	}
+	if (kvm_bits)
+		msgptr += sprintf(msgptr, ", %d bits from KVM_GET_RNG_BITS",
+				  kvm_bits);
+
 	if (buf[0])
 		pr_info("%s with %s\n", log_prefix, buf + 2);
 }
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 3dd8e2c..bd8783a 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -416,6 +416,16 @@ void kvm_disable_steal_time(void)
 	wrmsr(MSR_KVM_STEAL_TIME, 0, 0);
 }
 
+bool kvm_get_rng_seed(u64 *v)
+{
+	/*
+	 * Allow migration from a hypervisor with the GET_RNG_SEED
+	 * feature to a hypervisor without it.
+	 */
+	return (kvm_para_has_feature(KVM_FEATURE_GET_RNG_SEED) &&
+		rdmsrl_safe(MSR_KVM_GET_RNG_SEED, v) == 0);
+}
+
 #ifdef CONFIG_SMP
 static void __init kvm_smp_prepare_boot_cpu(void)
 {
-- 
1.9.3

