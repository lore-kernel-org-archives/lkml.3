Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762199Ab3DBTdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 15:33:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57345 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761551Ab3DBTdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:33:23 -0400
Date: Tue, 2 Apr 2013 12:32:27 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-65fc985b37dc241c4db7cd32adcbc989193fe3c8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de
In-Reply-To: <1363788448-31325-2-git-send-email-bp@alien8.de>
References: <1363788448-31325-2-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu:
  Expand cpufeature facility to include cpu bugs
Git-Commit-ID: 65fc985b37dc241c4db7cd32adcbc989193fe3c8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 12:32:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  65fc985b37dc241c4db7cd32adcbc989193fe3c8
Gitweb:     http://git.kernel.org/tip/65fc985b37dc241c4db7cd32adcbc989193fe3c8
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Wed, 20 Mar 2013 15:07:23 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 2 Apr 2013 10:12:52 -0700

x86, cpu: Expand cpufeature facility to include cpu bugs

We add another 32-bit vector at the end of the ->x86_capability
bitvector which collects bugs present in CPUs. After all, a CPU bug is a
kind of a capability, albeit a strange one.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1363788448-31325-2-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/cpufeature.h | 13 +++++++++++++
 arch/x86/include/asm/processor.h  |  2 +-
 arch/x86/kernel/alternative.c     |  2 +-
 arch/x86/kernel/cpu/common.c      |  4 ++++
 4 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 93fe929..16190ab 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -9,6 +9,7 @@
 #endif
 
 #define NCAPINTS	10	/* N 32-bit words worth of info */
+#define NBUGINTS	1	/* N 32-bit bug flags */
 
 /*
  * Note: If the comment begins with a quoted string, that string is used
@@ -216,6 +217,11 @@
 #define X86_FEATURE_ADX		(9*32+19) /* The ADCX and ADOX instructions */
 #define X86_FEATURE_SMAP	(9*32+20) /* Supervisor Mode Access Prevention */
 
+/*
+ * BUG word(s)
+ */
+#define X86_BUG(x)		(NCAPINTS*32 + (x))
+
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
 #include <asm/asm.h>
@@ -401,6 +407,13 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 #define static_cpu_has(bit) boot_cpu_has(bit)
 #endif
 
+#define cpu_has_bug(c, bit)	cpu_has(c, (bit))
+#define set_cpu_bug(c, bit)	set_cpu_cap(c, (bit))
+#define clear_cpu_bug(c, bit)	clear_cpu_cap(c, (bit));
+
+#define static_cpu_has_bug(bit)	static_cpu_has((bit))
+#define boot_cpu_has_bug(bit)	cpu_has_bug(&boot_cpu_data, (bit))
+
 #endif /* defined(__KERNEL__) && !defined(__ASSEMBLY__) */
 
 #endif /* _ASM_X86_CPUFEATURE_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 3270116..23c8081 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -107,7 +107,7 @@ struct cpuinfo_x86 {
 	__u32			extended_cpuid_level;
 	/* Maximum supported CPUID level, -1=no CPUID: */
 	int			cpuid_level;
-	__u32			x86_capability[NCAPINTS];
+	__u32			x86_capability[NCAPINTS + NBUGINTS];
 	char			x86_vendor_id[16];
 	char			x86_model_id[64];
 	/* in KB - valid for CPUS which support this call: */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index ef5ccca..c15cf9a 100644
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
index d814772..22018f7 100644
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
