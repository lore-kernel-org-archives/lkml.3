Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbaHNFom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 01:44:42 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:55800 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbaHNFoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 01:44:39 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, x86@kernel.org
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Honig <ahonig@google.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v6 6/7] x86,random,kvm: Use KVM_GET_RNG_SEED in arch_get_rng_seed
Date: Wed, 13 Aug 2014 22:44:00 -0700
Message-Id: <b7b98b6cbf2f0373f3f447f4bebd45409e42305c.1407994624.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1407994704.git.luto@amacapital.net>
References: <cover.1407994704.git.luto@amacapital.net>
In-Reply-To: <cover.1407994624.git.luto@amacapital.net>
References: <cover.1407994624.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a straightforward implementation: for each bit of internal
RNG state, request one bit from KVM_GET_RNG_SEED.  This is done even
if RDSEED/RDRAND worked, since KVM_GET_RNG_SEED is likely to provide
cryptographically secure output even if the CPU's RNG is weak or
compromised.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/Kconfig                 |  4 ++++
 arch/x86/include/asm/kvm_guest.h |  9 +++++++++
 arch/x86/kernel/archrandom.c     | 25 ++++++++++++++++++++++++-
 arch/x86/kernel/kvm.c            | 10 ++++++++++
 4 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d24887b..ad87278 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -594,6 +594,7 @@ config KVM_GUEST
 	bool "KVM Guest support (including kvmclock)"
 	depends on PARAVIRT
 	select PARAVIRT_CLOCK
+	select ARCH_RANDOM
 	default y
 	---help---
 	  This option enables various optimizations for running under the KVM
@@ -1508,6 +1509,9 @@ config ARCH_RANDOM
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
index e8d2ffb..adbaa25 100644
--- a/arch/x86/kernel/archrandom.c
+++ b/arch/x86/kernel/archrandom.c
@@ -15,6 +15,7 @@
  */
 
 #include <asm/archrandom.h>
+#include <asm/kvm_guest.h>
 
 void arch_rng_init(void *ctx,
 		   void (*seed)(void *ctx, u32 data),
@@ -22,7 +23,7 @@ void arch_rng_init(void *ctx,
 		   const char *log_prefix)
 {
 	int i;
-	int rdseed_bits = 0, rdrand_bits = 0;
+	int rdseed_bits = 0, rdrand_bits = 0, kvm_bits = 0;
 	char buf[128] = "";
 	char *msgptr = buf;
 
@@ -42,10 +43,32 @@ void arch_rng_init(void *ctx,
 #endif
 	}
 
+	/*
+	 * Use KVM_GET_RNG_SEED regardless of whether the CPU RNG
+	 * worked, since it incorporates entropy unavailable to the CPU,
+	 * and we shouldn't trust the hardware RNG more than we need to.
+	 * We request enough bits for the entire internal RNG state,
+	 * because there's no good reason not to.
+	 */
+	for (i = 0; i < bits_per_source; i += 64) {
+		u64 rv;
+
+		if (kvm_get_rng_seed(&rv)) {
+			seed(ctx, (u32)rv);
+			seed(ctx, (u32)(rv >> 32));
+			kvm_bits += 8 * sizeof(rv);
+		} else {
+			break;	/* If it fails once, it will keep failing. */
+		}
+	}
+
 	if (rdseed_bits)
 		msgptr += sprintf(msgptr, ", %d bits from RDSEED", rdseed_bits);
 	if (rdrand_bits)
 		msgptr += sprintf(msgptr, ", %d bits from RDRAND", rdrand_bits);
+	if (kvm_bits)
+		msgptr += sprintf(msgptr, ", %d bits from KVM_GET_RNG_BITS",
+				  kvm_bits);
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

