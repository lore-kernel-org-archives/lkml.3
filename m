Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbbAVUNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:13:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32890 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbbAVUNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:13:18 -0500
Date: Thu, 22 Jan 2015 12:13:05 -0800
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-c922228efeeefa32e57f875764bfa6ca8053a68a@git.kernel.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        dave.hansen@linux.intel.com, hpa@zytor.com, dave@sr71.net,
        tglx@linutronix.de
Reply-To: dave.hansen@linux.intel.com, hpa@zytor.com, tglx@linutronix.de,
        dave@sr71.net, mingo@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20150108223021.AEEAB987@viggo.jf.intel.com>
References: <20150108223021.AEEAB987@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mpx:
  Fix potential performance issue on unmaps
Git-Commit-ID: c922228efeeefa32e57f875764bfa6ca8053a68a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c922228efeeefa32e57f875764bfa6ca8053a68a
Gitweb:     http://git.kernel.org/tip/c922228efeeefa32e57f875764bfa6ca8053a68a
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Thu, 8 Jan 2015 14:30:21 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 21:11:06 +0100

x86, mpx: Fix potential performance issue on unmaps

The 3.19 merge window saw some TLB modifications merged which caused a
performance regression. They were fixed in commit 045bbb9fa.

Once that fix was applied, I also noticed that there was a small
but intermittent regression still present.  It was not present
consistently enough to bisect reliably, but I'm fairly confident
that it came from (my own) MPX patches.  The source was reading
a relatively unused field in the mm_struct via arch_unmap.

I also noted that this code was in the main instruction flow of
do_munmap() and probably had more icache impact than we want.

This patch does two things:
1. Adds a static (via Kconfig) and dynamic (via cpuid) check
   for MPX with cpu_feature_enabled().  This keeps us from
   reading that cacheline in the mm and trades it for a check
   of the global CPUID variables at least on CPUs without MPX.
2. Adds an unlikely() to ensure that the MPX call ends up out
   of the main instruction flow in do_munmap().  I've added
   a detailed comment about why this was done and why we want
   it even on systems where MPX is present.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: luto@amacapital.net
Cc: Dave Hansen <dave@sr71.net>
Link: http://lkml.kernel.org/r/20150108223021.AEEAB987@viggo.jf.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/mmu_context.h | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 40269a2..4b75d59 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -130,7 +130,25 @@ static inline void arch_bprm_mm_init(struct mm_struct *mm,
 static inline void arch_unmap(struct mm_struct *mm, struct vm_area_struct *vma,
 			      unsigned long start, unsigned long end)
 {
-	mpx_notify_unmap(mm, vma, start, end);
+	/*
+	 * mpx_notify_unmap() goes and reads a rarely-hot
+	 * cacheline in the mm_struct.  That can be expensive
+	 * enough to be seen in profiles.
+	 *
+	 * The mpx_notify_unmap() call and its contents have been
+	 * observed to affect munmap() performance on hardware
+	 * where MPX is not present.
+	 *
+	 * The unlikely() optimizes for the fast case: no MPX
+	 * in the CPU, or no MPX use in the process.  Even if
+	 * we get this wrong (in the unlikely event that MPX
+	 * is widely enabled on some system) the overhead of
+	 * MPX itself (reading bounds tables) is expected to
+	 * overwhelm the overhead of getting this unlikely()
+	 * consistently wrong.
+	 */
+	if (unlikely(cpu_feature_enabled(X86_FEATURE_MPX)))
+		mpx_notify_unmap(mm, vma, start, end);
 }
 
 #endif /* _ASM_X86_MMU_CONTEXT_H */
