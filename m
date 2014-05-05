Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974AbaEEM50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:57:26 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:40985 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932238AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, LEROY Christophe <christophe.leroy@c-s.fr>,
        Scott Wood <scottwood@freescale.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 24/50] powerpc/8xx: mfspr SPRN_TBRx in lieu of mftb/mftbu is not supported
Date: Mon,  5 May 2014 14:43:06 +0200
Message-Id: <1e37176ee50aba87e7c4a31bcd588d04706fea03.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: LEROY Christophe <christophe.leroy@c-s.fr>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ae2163be10ac6090e7aeed72591e2d7fabb1cdda upstream.

Commit beb2dc0a7a84be003ce54e98b95d65cc66e6e536 breaks the MPC8xx which
seems to not support using mfspr SPRN_TBRx instead of mftb/mftbu
despite what is written in the reference manual.

This patch reverts to the use of mftb/mftbu when CONFIG_8xx is
selected.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Scott Wood <scottwood@freescale.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/powerpc/boot/util.S                  | 14 ++++++++++++++
 arch/powerpc/include/asm/ppc_asm.h        |  2 ++
 arch/powerpc/include/asm/reg.h            |  7 +++++++
 arch/powerpc/include/asm/timex.h          |  8 ++++++++
 arch/powerpc/kernel/vdso32/gettimeofday.S |  6 ++++++
 5 files changed, 37 insertions(+)

diff --git a/arch/powerpc/boot/util.S b/arch/powerpc/boot/util.S
index 5143228e3e5f..6636b1d7821b 100644
--- a/arch/powerpc/boot/util.S
+++ b/arch/powerpc/boot/util.S
@@ -71,18 +71,32 @@ udelay:
 	add	r4,r4,r5
 	addi	r4,r4,-1
 	divw	r4,r4,r5	/* BUS ticks */
+#ifdef CONFIG_8xx
+1:	mftbu	r5
+	mftb	r6
+	mftbu	r7
+#else
 1:	mfspr	r5, SPRN_TBRU
 	mfspr	r6, SPRN_TBRL
 	mfspr	r7, SPRN_TBRU
+#endif
 	cmpw	0,r5,r7
 	bne	1b		/* Get [synced] base time */
 	addc	r9,r6,r4	/* Compute end time */
 	addze	r8,r5
+#ifdef CONFIG_8xx
+2:	mftbu	r5
+#else
 2:	mfspr	r5, SPRN_TBRU
+#endif
 	cmpw	0,r5,r8
 	blt	2b
 	bgt	3f
+#ifdef CONFIG_8xx
+	mftb	r6
+#else
 	mfspr	r6, SPRN_TBRL
+#endif
 	cmpw	0,r6,r9
 	blt	2b
 3:	blr
diff --git a/arch/powerpc/include/asm/ppc_asm.h b/arch/powerpc/include/asm/ppc_asm.h
index c2dcfaa51987..0d2d0f03163b 100644
--- a/arch/powerpc/include/asm/ppc_asm.h
+++ b/arch/powerpc/include/asm/ppc_asm.h
@@ -438,6 +438,8 @@ BEGIN_FTR_SECTION_NESTED(96);		\
 	cmpwi dest,0;			\
 	beq-  90b;			\
 END_FTR_SECTION_NESTED(CPU_FTR_CELL_TB_BUG, CPU_FTR_CELL_TB_BUG, 96)
+#elif defined(CONFIG_8xx)
+#define MFTB(dest)			mftb dest
 #else
 #define MFTB(dest)			mfspr dest, SPRN_TBRL
 #endif
diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index 10d1ef016bf1..7ca729cac073 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -1154,12 +1154,19 @@
 
 #else /* __powerpc64__ */
 
+#if defined(CONFIG_8xx)
+#define mftbl()		({unsigned long rval;	\
+			asm volatile("mftbl %0" : "=r" (rval)); rval;})
+#define mftbu()		({unsigned long rval;	\
+			asm volatile("mftbu %0" : "=r" (rval)); rval;})
+#else
 #define mftbl()		({unsigned long rval;	\
 			asm volatile("mfspr %0, %1" : "=r" (rval) : \
 				"i" (SPRN_TBRL)); rval;})
 #define mftbu()		({unsigned long rval;	\
 			asm volatile("mfspr %0, %1" : "=r" (rval) : \
 				"i" (SPRN_TBRU)); rval;})
+#endif
 #endif /* !__powerpc64__ */
 
 #define mttbl(v)	asm volatile("mttbl %0":: "r"(v))
diff --git a/arch/powerpc/include/asm/timex.h b/arch/powerpc/include/asm/timex.h
index 18908caa1f3b..2cf846edb3fc 100644
--- a/arch/powerpc/include/asm/timex.h
+++ b/arch/powerpc/include/asm/timex.h
@@ -29,7 +29,11 @@ static inline cycles_t get_cycles(void)
 	ret = 0;
 
 	__asm__ __volatile__(
+#ifdef CONFIG_8xx
+		"97:	mftb %0\n"
+#else
 		"97:	mfspr %0, %2\n"
+#endif
 		"99:\n"
 		".section __ftr_fixup,\"a\"\n"
 		".align 2\n"
@@ -41,7 +45,11 @@ static inline cycles_t get_cycles(void)
 		"	.long 0\n"
 		"	.long 0\n"
 		".previous"
+#ifdef CONFIG_8xx
+		: "=r" (ret) : "i" (CPU_FTR_601));
+#else
 		: "=r" (ret) : "i" (CPU_FTR_601), "i" (SPRN_TBRL));
+#endif
 	return ret;
 #endif
 }
diff --git a/arch/powerpc/kernel/vdso32/gettimeofday.S b/arch/powerpc/kernel/vdso32/gettimeofday.S
index 6b1f2a6d5517..6b2b69616e77 100644
--- a/arch/powerpc/kernel/vdso32/gettimeofday.S
+++ b/arch/powerpc/kernel/vdso32/gettimeofday.S
@@ -232,9 +232,15 @@ __do_get_tspec:
 	lwz	r6,(CFG_TB_ORIG_STAMP+4)(r9)
 
 	/* Get a stable TB value */
+#ifdef CONFIG_8xx
+2:	mftbu	r3
+	mftbl	r4
+	mftbu	r0
+#else
 2:	mfspr	r3, SPRN_TBRU
 	mfspr	r4, SPRN_TBRL
 	mfspr	r0, SPRN_TBRU
+#endif
 	cmplw	cr0,r3,r0
 	bne-	2b
 
-- 
1.9.2

