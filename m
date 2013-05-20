Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab3ETPDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 11:03:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49620 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755608Ab3ETPDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 11:03:31 -0400
From: Michal Hocko <mhocko@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        =?UTF-8?q?Fernando=20Luis=20V=C3=A1zquez=20Cao?= 
	<fernando@oss.ntt.co.jp>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, x86@kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "x86-64, init: Do not set NX bits on non-NX capable hardware"
Date: Mon, 20 May 2013 17:03:12 +0200
Message-Id: <1369062192-7066-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130514160108.GA5055@dhcp22.suse.cz>
References: <20130514160108.GA5055@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 78d77df71510a96e042de7ba6dbd7998103642cb because
it breaks resume from suspend to ram. Git bisect pointed to this patch
and the revert fixes the problem.

There are no error messages neither during suspend not on resume when
the machine simply starts booting as if it wasn't suspended in RAM at
all.

References: https://lkml.org/lkml/2013/5/14/398
Cc: stable@vger.kernel.org # 3.9
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 arch/x86/kernel/head64.c  |    3 +--
 arch/x86/kernel/head_64.S |    1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index dab95a8..101ac1a9 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -34,7 +34,6 @@
 extern pgd_t early_level4_pgt[PTRS_PER_PGD];
 extern pmd_t early_dynamic_pgts[EARLY_DYNAMIC_PAGE_TABLES][PTRS_PER_PMD];
 static unsigned int __initdata next_early_pgt = 2;
-pmdval_t __initdata early_pmd_flags = __PAGE_KERNEL_LARGE & ~(_PAGE_GLOBAL | _PAGE_NX);
 
 /* Wipe all early page tables except for the kernel symbol map */
 static void __init reset_early_page_tables(void)
@@ -100,7 +99,7 @@ again:
 			pmd_p[i] = 0;
 		*pud_p = (pudval_t)pmd_p - __START_KERNEL_map + phys_base + _KERNPG_TABLE;
 	}
-	pmd = (physaddr & PMD_MASK) + early_pmd_flags;
+	pmd = (physaddr & PMD_MASK) + (__PAGE_KERNEL_LARGE & ~_PAGE_GLOBAL);
 	pmd_p[pmd_index(address)] = pmd;
 
 	return 0;
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 08f7e80..6859e96 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -200,7 +200,6 @@ ENTRY(secondary_startup_64)
 	btl	$20,%edi		/* No Execute supported? */
 	jnc     1f
 	btsl	$_EFER_NX, %eax
-	btsq	$_PAGE_BIT_NX,early_pmd_flags(%rip)
 1:	wrmsr				/* Make changes effective */
 
 	/* Setup cr0 */
-- 
1.7.10.4

