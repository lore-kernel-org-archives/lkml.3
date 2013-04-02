Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762251Ab3DBThA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 15:37:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57405 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab3DBTg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:36:57 -0400
Date: Tue, 2 Apr 2013 12:36:03 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-c5b41a67505cc3c9744d8f105c63a3bf3c443a01@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de
In-Reply-To: <1363788448-31325-5-git-send-email-bp@alien8.de>
References: <1363788448-31325-5-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Convert Cyrix coma bug detection
Git-Commit-ID: c5b41a67505cc3c9744d8f105c63a3bf3c443a01
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 12:36:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5b41a67505cc3c9744d8f105c63a3bf3c443a01
Gitweb:     http://git.kernel.org/tip/c5b41a67505cc3c9744d8f105c63a3bf3c443a01
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Wed, 20 Mar 2013 15:07:26 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 2 Apr 2013 10:12:54 -0700

x86, cpu: Convert Cyrix coma bug detection

... to the new facility.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1363788448-31325-5-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/cpufeature.h | 1 +
 arch/x86/include/asm/processor.h  | 1 -
 arch/x86/kernel/cpu/cyrix.c       | 5 +++--
 arch/x86/kernel/cpu/proc.c        | 2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 25eb948..a2b65c1 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -224,6 +224,7 @@
 
 #define X86_BUG_F00F		X86_BUG(0) /* Intel F00F */
 #define X86_BUG_FDIV		X86_BUG(1) /* FPU FDIV */
+#define X86_BUG_COMA		X86_BUG(2) /* Cyrix 6x86 coma */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index ea22dfa..4e2fa28 100644
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
index 4fbd384..d048d5c 100644
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
index 5dfb6c6..37a198b 100644
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
