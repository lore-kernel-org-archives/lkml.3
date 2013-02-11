Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab3BKLTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 06:19:52 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34199 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260Ab3BKLSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 06:18:48 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [RFC PATCH 1/4] x86, cpu: Expand cpufeature facility to include cpu bugs
Date: Mon, 11 Feb 2013 12:18:38 +0100
Message-Id: <1360581521-4712-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360581521-4712-1-git-send-email-bp@alien8.de>
References: <1360581521-4712-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

We add another 32-bit vector at the end of the ->x86_capability
bitvector which collects bugs present in CPUs. After all, a CPU bug is a
kind of a capability, albeit a strange one.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/cpufeature.h | 34 ++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/processor.h  |  2 +-
 arch/x86/kernel/alternative.c     |  2 +-
 arch/x86/kernel/cpu/common.c      |  4 ++++
 4 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 2d9075e863a0..68daf877dad5 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -9,6 +9,7 @@
 #endif
 
 #define NCAPINTS	10	/* N 32-bit words worth of info */
+#define NBUGINTS	1	/* N 32-bit bug flags */
 
 /*
  * Note: If the comment begins with a quoted string, that string is used
@@ -399,6 +400,39 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 #define static_cpu_has(bit) boot_cpu_has(bit)
 #endif
 
+#define __BUG_CHECK_BIT(bit)					\
+({								\
+	WARN_ON(bit >> 5 < NCAPINTS);				\
+	bit;							\
+})
+
+#define cpu_has_bug(c, bit)					\
+({								\
+	unsigned __bit = __BUG_CHECK_BIT((bit));		\
+	cpu_has(c, __bit);					\
+})
+
+#define boot_cpu_has_bug(bit) \
+	cpu_has_bug(&boot_cpu_data, (bit))
+
+#define static_cpu_has_bug(bit)					\
+({								\
+	unsigned __bit = __BUG_CHECK_BIT((bit));		\
+	static_cpu_has(__bit);					\
+})
+
+#define set_cpu_bug(c, bit)					\
+({								\
+	unsigned __bit = __BUG_CHECK_BIT((bit));		\
+	set_cpu_cap(c, __bit);					\
+})
+
+#define clear_cpu_bug(c, bit)					\
+({								\
+	unsigned __bit = __BUG_CHECK_BIT((bit));		\
+	clear_cpu_cap(c, __bit);				\
+})
+
 #endif /* defined(__KERNEL__) && !defined(__ASSEMBLY__) */
 
 #endif /* _ASM_X86_CPUFEATURE_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 439f27a41ee8..67721c634bf0 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -108,7 +108,7 @@ struct cpuinfo_x86 {
 	__u32			extended_cpuid_level;
 	/* Maximum supported CPUID level, -1=no CPUID: */
 	int			cpuid_level;
-	__u32			x86_capability[NCAPINTS];
+	__u32			x86_capability[NCAPINTS + NBUGINTS];
 	char			x86_vendor_id[16];
 	char			x86_model_id[64];
 	/* in KB - valid for CPUS which support this call: */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index ef5ccca79a6c..c15cf9a25e27 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -271,7 +271,7 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 		replacement = (u8 *)&a->repl_offset + a->repl_offset;
 		BUG_ON(a->replacementlen > a->instrlen);
 		BUG_ON(a->instrlen > sizeof(insnbuf));
-		BUG_ON(a->cpuid >= NCAPINTS*32);
+		BUG_ON(a->cpuid >= (NCAPINTS + NBUGINTS) * 32);
 		if (!boot_cpu_has(a->cpuid))
 			continue;
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d814772c5bed..22018f70a671 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -920,6 +920,10 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 		/* AND the already accumulated flags with these */
 		for (i = 0; i < NCAPINTS; i++)
 			boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
+
+		/* OR, i.e. replicate the bug flags */
+		for (i = NCAPINTS; i < NCAPINTS + NBUGINTS; i++)
+			c->x86_capability[i] |= boot_cpu_data.x86_capability[i];
 	}
 
 	/* Init Machine Check Exception if available. */
-- 
1.8.1.3.535.ga923c31

