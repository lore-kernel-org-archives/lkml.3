Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010AbaGPCtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 22:49:12 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:55653 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759208AbaGPCsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 22:48:39 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, x86@kernel.org
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 4/4] x86,kaslr: Use MSR_KVM_GET_RNG_SEED for KASLR if available
Date: Tue, 15 Jul 2014 19:48:10 -0700
Message-Id: <14a475cbeaf73ac45e6073f83c4e1386cd7f6a2b.1405477965.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1405477965.git.luto@amacapital.net>
References: <cover.1405477965.git.luto@amacapital.net>
In-Reply-To: <cover.1405477965.git.luto@amacapital.net>
References: <cover.1405477965.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's considerably better than any of the alternatives on KVM.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/boot/compressed/aslr.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index fc6091a..8583f0e 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -5,6 +5,8 @@
 #include <asm/archrandom.h>
 #include <asm/e820.h>
 
+#include <uapi/asm/kvm_para.h>
+
 #include <generated/compile.h>
 #include <linux/module.h>
 #include <linux/uts.h>
@@ -15,6 +17,22 @@
 static const char build_str[] = UTS_RELEASE " (" LINUX_COMPILE_BY "@"
 		LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION;
 
+static bool kvm_para_has_feature(unsigned int feature)
+{
+	u32 kvm_base;
+	u32 features;
+
+	if (!has_cpuflag(X86_FEATURE_HYPERVISOR))
+		return false;
+
+	kvm_base = hypervisor_cpuid_base("KVMKVMKVM\0\0\0", KVM_CPUID_FEATURES);
+	if (!kvm_base)
+		return false;
+
+	features = cpuid_eax(kvm_base | KVM_CPUID_FEATURES);
+	return features & (1UL << feature);
+}
+
 #define I8254_PORT_CONTROL	0x43
 #define I8254_PORT_COUNTER0	0x40
 #define I8254_CMD_READBACK	0xC0
@@ -81,6 +99,15 @@ static unsigned long get_random_long(void)
 		}
 	}
 
+	if (kvm_para_has_feature(KVM_FEATURE_GET_RNG_SEED)) {
+		u64 seed;
+
+		debug_putstr(" MSR_KVM_GET_RNG_SEED");
+		rdmsrl(MSR_KVM_GET_RNG_SEED, seed);
+		random ^= (unsigned long)seed;
+		use_i8254 = false;
+	}
+
 	if (has_cpuflag(X86_FEATURE_TSC)) {
 		debug_putstr(" RDTSC");
 		rdtscll(raw);
-- 
1.9.3

