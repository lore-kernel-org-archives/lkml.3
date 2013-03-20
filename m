Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208Ab3CTOIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:08:18 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41223 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab3CTOHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:07:35 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 4/6] x86, cpu: Convert Cyrix coma bug detection
Date: Wed, 20 Mar 2013 15:07:26 +0100
Message-Id: <1363788448-31325-5-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1363788448-31325-1-git-send-email-bp@alien8.de>
References: <1363788448-31325-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

... to the new facility.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/cpufeature.h | 1 +
 arch/x86/include/asm/processor.h  | 1 -
 arch/x86/kernel/cpu/cyrix.c       | 5 +++--
 arch/x86/kernel/cpu/proc.c        | 2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 25eb9488a9a5..a2b65c11081e 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -224,6 +224,7 @@
 
 #define X86_BUG_F00F		X86_BUG(0) /* Intel F00F */
 #define X86_BUG_FDIV		X86_BUG(1) /* FPU FDIV */
+#define X86_BUG_COMA		X86_BUG(2) /* Cyrix 6x86 coma */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index ea22dfaf6c5e..4e2fa2859e39 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -91,7 +91,6 @@ struct cpuinfo_x86 {
 	/* Problems on some 486Dx4's and old 386's: */
 	char			hard_math;
 	char			rfu;
-	char			coma_bug;
 	char			pad0;
 #else
 	/* Number of 4K pages in DTLB/ITLB combined(in pages): */
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index 4fbd384fb645..d048d5ca43c1 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -249,7 +249,7 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 		/* Emulate MTRRs using Cyrix's ARRs. */
 		set_cpu_cap(c, X86_FEATURE_CYRIX_ARR);
 		/* 6x86's contain this bug */
-		c->coma_bug = 1;
+		set_cpu_bug(c, X86_BUG_COMA);
 		break;
 
 	case 4: /* MediaGX/GXm or Geode GXM/GXLV/GX1 */
@@ -317,7 +317,8 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 			/* Enable MMX extensions (App note 108) */
 			setCx86_old(CX86_CCR7, getCx86_old(CX86_CCR7)|1);
 		} else {
-			c->coma_bug = 1;      /* 6x86MX, it has the bug. */
+			/* A 6x86MX - it has the bug. */
+			set_cpu_bug(c, X86_BUG_COMA);
 		}
 		tmp = (!(dir0_lsn & 7) || dir0_lsn & 1) ? 2 : 0;
 		Cx86_cb[tmp] = cyrix_model_mult2[dir0_lsn & 7];
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 5dfb6c65138f..37a198bd48c8 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -36,7 +36,7 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 		   "wp\t\t: %s\n",
 		   static_cpu_has_bug(X86_BUG_FDIV) ? "yes" : "no",
 		   static_cpu_has_bug(X86_BUG_F00F) ? "yes" : "no",
-		   c->coma_bug ? "yes" : "no",
+		   static_cpu_has_bug(X86_BUG_COMA) ? "yes" : "no",
 		   c->hard_math ? "yes" : "no",
 		   c->hard_math ? "yes" : "no",
 		   c->cpuid_level,
-- 
1.8.1.3.535.ga923c31

