Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbaKTVqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 16:46:12 -0500
Received: from eddie.linux-mips.org ([148.251.95.138]:55177 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaKTVqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 16:46:10 -0500
Date: Thu, 20 Nov 2014 22:45:58 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
Cc: linux-mips@linux-mips.org, aaro.koskinen@iki.fi, david.daney@cavium.com,
        linux-kernel@vger.kernel.org, markos.chandras@imgtec.com,
        dengcheng.zhu@imgtec.com, chenhc@lemote.com, akpm@linux-foundation.org
Subject: Re: [PATCH] MIPS: Remove a temporary hack for debugging cache
 flushes in SMTC configuration
Message-ID: <20141120214557.GA19608@linux-mips.org>
References: <20140906022738.6957.53838.stgit@linux-yegoshin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140906022738.6957.53838.stgit@linux-yegoshin>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 07:27:38PM -0700, Leonid Yegoshin wrote:

> This patch removes a temporary hack for debugging SMTC configuration from
> 
> 	commit 41c594ab65fc89573af296d192aa5235d09717ab
> 	Author: Ralf Baechle <ralf@linux-mips.org>
> 	Date:   Wed Apr 5 09:45:45 2006 +0100
> 
> which is dropped now. Some performance degradation for multi-VPE systems
> is removed.

Your patch removes the sole location from where PROTECT_CACHE_FLUSHES
was defined leaving all the #ifdef'ed PROTECT_CACHE_FLUSHES code unused.
So I'm more thinking of something like below.

  Ralf

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 arch/mips/include/asm/r4kcache.h | 59 ----------------------------------------
 1 file changed, 59 deletions(-)

diff --git a/arch/mips/include/asm/r4kcache.h b/arch/mips/include/asm/r4kcache.h
index cd6e0af..e293a8d 100644
--- a/arch/mips/include/asm/r4kcache.h
+++ b/arch/mips/include/asm/r4kcache.h
@@ -47,79 +47,20 @@ extern void (*r4k_blast_icache)(void);
 
 #ifdef CONFIG_MIPS_MT
 
-/*
- * Optionally force single-threaded execution during I-cache flushes.
- */
-#define PROTECT_CACHE_FLUSHES 1
-
-#ifdef PROTECT_CACHE_FLUSHES
-
-extern int mt_protiflush;
-extern int mt_protdflush;
-extern void mt_cflush_lockdown(void);
-extern void mt_cflush_release(void);
-
-#define BEGIN_MT_IPROT \
-	unsigned long flags = 0;			\
-	unsigned long mtflags = 0;			\
-	if(mt_protiflush) {				\
-		local_irq_save(flags);			\
-		ehb();					\
-		mtflags = dvpe();			\
-		mt_cflush_lockdown();			\
-	}
-
-#define END_MT_IPROT \
-	if(mt_protiflush) {				\
-		mt_cflush_release();			\
-		evpe(mtflags);				\
-		local_irq_restore(flags);		\
-	}
-
-#define BEGIN_MT_DPROT \
-	unsigned long flags = 0;			\
-	unsigned long mtflags = 0;			\
-	if(mt_protdflush) {				\
-		local_irq_save(flags);			\
-		ehb();					\
-		mtflags = dvpe();			\
-		mt_cflush_lockdown();			\
-	}
-
-#define END_MT_DPROT \
-	if(mt_protdflush) {				\
-		mt_cflush_release();			\
-		evpe(mtflags);				\
-		local_irq_restore(flags);		\
-	}
-
-#else
-
-#define BEGIN_MT_IPROT
-#define BEGIN_MT_DPROT
-#define END_MT_IPROT
-#define END_MT_DPROT
-
-#endif /* PROTECT_CACHE_FLUSHES */
-
 #define __iflush_prologue						\
 	unsigned long redundance;					\
 	extern int mt_n_iflushes;					\
-	BEGIN_MT_IPROT							\
 	for (redundance = 0; redundance < mt_n_iflushes; redundance++) {
 
 #define __iflush_epilogue						\
-	END_MT_IPROT							\
 	}
 
 #define __dflush_prologue						\
 	unsigned long redundance;					\
 	extern int mt_n_dflushes;					\
-	BEGIN_MT_DPROT							\
 	for (redundance = 0; redundance < mt_n_dflushes; redundance++) {
 
 #define __dflush_epilogue \
-	END_MT_DPROT	 \
 	}
 
 #define __inv_dflush_prologue __dflush_prologue
