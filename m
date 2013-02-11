Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab3BKLTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 06:19:50 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34204 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291Ab3BKLSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 06:18:49 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [RFC PATCH 4/4] x86, cpu: Convert Cyrix coma bug detection
Date: Mon, 11 Feb 2013 12:18:41 +0100
Message-Id: <1360581521-4712-5-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360581521-4712-1-git-send-email-bp@alien8.de>
References: <1360581521-4712-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

... to the new facility. Drop the padding too since it becomes
unnecessary now.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/cpufeature.h | 1 +
 arch/x86/include/asm/processor.h  | 2 --
 arch/x86/kernel/cpu/cyrix.c       | 5 +++--
 arch/x86/kernel/cpu/proc.c        | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 6be6fab3dced..62b9affc0948 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -218,6 +218,7 @@
 
 #define X86_BUG_F00F		(NCAPINTS*32+ 0) /* Intel F00F bug */
 #define X86_BUG_FDIV		(NCAPINTS*32+ 1) /* FPU FDIV bug */
+#define X86_BUG_COMA		(NCAPINTS*32+ 2) /* Cyrix 6x86 coma */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index d18dedf333aa..c7f1066bd93a 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -92,8 +92,6 @@ struct cpuinfo_x86 {
 	char			hlt_works_ok;
 	char			hard_math;
 	char			rfu;
-	char			coma_bug;
-	char			pad0;
 #else
 	/* Number of 4K pages in DTLB/ITLB combined(in pages): */
 	int			x86_tlbsize;
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index 4fbd384fb645..ef060edeb68e 100644
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
+			/* 6x86MX, it has the bug. */
+			set_cpu_bug(c, X86_BUG_COMA);
 		}
 		tmp = (!(dir0_lsn & 7) || dir0_lsn & 1) ? 2 : 0;
 		Cx86_cb[tmp] = cyrix_model_mult2[dir0_lsn & 7];
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index de41600664da..7497d1eb6053 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -38,7 +38,7 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 		   static_cpu_has_bug(X86_BUG_FDIV) ? "yes" : "no",
 		   c->hlt_works_ok ? "no" : "yes",
 		   static_cpu_has_bug(X86_BUG_F00F) ? "yes" : "no",
-		   c->coma_bug ? "yes" : "no",
+		   static_cpu_has_bug(X86_BUG_COMA) ? "yes" : "no",
 		   c->hard_math ? "yes" : "no",
 		   c->hard_math ? "yes" : "no",
 		   c->cpuid_level,
-- 
1.8.1.3.535.ga923c31

