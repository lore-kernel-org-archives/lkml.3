Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934182AbaGXE5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 00:57:48 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:47910 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934155AbaGXE5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 00:57:43 -0400
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
Subject: [PATCH v5 1/5] x86,kvm: Add MSR_KVM_GET_RNG_SEED and a matching feature bit
Date: Wed, 23 Jul 2014 21:57:27 -0700
Message-Id: <3e019617640d1b07d0ab1c9a91455957c201d4cd.1406177531.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1406177531.git.luto@amacapital.net>
References: <cover.1406177531.git.luto@amacapital.net>
In-Reply-To: <cover.1406177531.git.luto@amacapital.net>
References: <cover.1406177531.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a simple interface to allow a guest to request 64 bits of
host nonblocking entropy.  This is independent of virtio-rng for a
couple of reasons:

 - It's intended to be usable during early boot, when a trivial
   synchronous interface is needed.

 - virtio-rng gives blocking entropy, and making guest boot wait for
   the host's /dev/random will cause problems.

MSR_KVM_GET_RNG_SEED is intended to provide 64 bits of best-effort
cryptographically secure data for use as a seed.  It provides no
guarantee that the result contains any actual entropy.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 Documentation/virtual/kvm/cpuid.txt  | 3 +++
 arch/x86/include/uapi/asm/kvm_para.h | 2 ++
 arch/x86/kvm/cpuid.c                 | 3 ++-
 arch/x86/kvm/x86.c                   | 4 ++++
 4 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/Documentation/virtual/kvm/cpuid.txt b/Documentation/virtual/kvm/cpuid.txt
index 3c65feb..0ab043b 100644
--- a/Documentation/virtual/kvm/cpuid.txt
+++ b/Documentation/virtual/kvm/cpuid.txt
@@ -54,6 +54,9 @@ KVM_FEATURE_PV_UNHALT              ||     7 || guest checks this feature bit
                                    ||       || before enabling paravirtualized
                                    ||       || spinlock support.
 ------------------------------------------------------------------------------
+KVM_FEATURE_GET_RNG_SEED           ||     8 || host provides rng seed data via
+                                   ||       || MSR_KVM_GET_RNG_SEED.
+------------------------------------------------------------------------------
 KVM_FEATURE_CLOCKSOURCE_STABLE_BIT ||    24 || host will warn if no guest-side
                                    ||       || per-cpu warps are expected in
                                    ||       || kvmclock.
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 94dc8ca..e2eaf93 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -24,6 +24,7 @@
 #define KVM_FEATURE_STEAL_TIME		5
 #define KVM_FEATURE_PV_EOI		6
 #define KVM_FEATURE_PV_UNHALT		7
+#define KVM_FEATURE_GET_RNG_SEED	8
 
 /* The last 8 bits are used to indicate how to interpret the flags field
  * in pvclock structure. If no bits are set, all flags are ignored.
@@ -40,6 +41,7 @@
 #define MSR_KVM_ASYNC_PF_EN 0x4b564d02
 #define MSR_KVM_STEAL_TIME  0x4b564d03
 #define MSR_KVM_PV_EOI_EN      0x4b564d04
+#define MSR_KVM_GET_RNG_SEED 0x4b564d05
 
 struct kvm_steal_time {
 	__u64 steal;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 38a0afe..40d6763 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -479,7 +479,8 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			     (1 << KVM_FEATURE_ASYNC_PF) |
 			     (1 << KVM_FEATURE_PV_EOI) |
 			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
-			     (1 << KVM_FEATURE_PV_UNHALT);
+			     (1 << KVM_FEATURE_PV_UNHALT) |
+			     (1 << KVM_FEATURE_GET_RNG_SEED);
 
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f644933..4e81853 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -48,6 +48,7 @@
 #include <linux/pci.h>
 #include <linux/timekeeper_internal.h>
 #include <linux/pvclock_gtod.h>
+#include <linux/random.h>
 #include <trace/events/kvm.h>
 
 #define CREATE_TRACE_POINTS
@@ -2480,6 +2481,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_KVM_PV_EOI_EN:
 		data = vcpu->arch.pv_eoi.msr_val;
 		break;
+	case MSR_KVM_GET_RNG_SEED:
+		get_random_bytes(&data, sizeof(data));
+		break;
 	case MSR_IA32_P5_MC_ADDR:
 	case MSR_IA32_P5_MC_TYPE:
 	case MSR_IA32_MCG_CAP:
-- 
1.9.3

