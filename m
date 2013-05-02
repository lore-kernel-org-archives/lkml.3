Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761772Ab3EBSdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:33:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34728 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761755Ab3EBSds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:33:48 -0400
Date: Thu, 2 May 2013 11:33:33 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-78d77df71510a96e042de7ba6dbd7998103642cb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fernando@oss.ntt.co.jp, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fernando@oss.ntt.co.jp, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1367476850.5660.2.camel@nexus>
References: <1367476850.5660.2.camel@nexus>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-64, init:
  Do not set NX bits on non-NX capable hardware
Git-Commit-ID: 78d77df71510a96e042de7ba6dbd7998103642cb
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

Commit-ID:  78d77df71510a96e042de7ba6dbd7998103642cb
Gitweb:     http://git.kernel.org/tip/78d77df71510a96e042de7ba6dbd7998103642cb
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 2 May 2013 10:33:46 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 2 May 2013 11:27:35 -0700

x86-64, init: Do not set NX bits on non-NX capable hardware

During early init, we would incorrectly set the NX bit even if the NX
feature was not supported.  Instead, only set this bit if NX is
actually available and enabled.  We already do very early detection of
the NX bit to enable it in EFER, this simply extends this detection to
the early page table mask.

Reported-by: Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1367476850.5660.2.camel@nexus
Cc: <stable@vger.kernel.org> v3.9
---
 arch/x86/kernel/head64.c  | 3 ++-
 arch/x86/kernel/head_64.S | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 101ac1a9..dab95a8 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -34,6 +34,7 @@
 extern pgd_t early_level4_pgt[PTRS_PER_PGD];
 extern pmd_t early_dynamic_pgts[EARLY_DYNAMIC_PAGE_TABLES][PTRS_PER_PMD];
 static unsigned int __initdata next_early_pgt = 2;
+pmdval_t __initdata early_pmd_flags = __PAGE_KERNEL_LARGE & ~(_PAGE_GLOBAL | _PAGE_NX);
 
 /* Wipe all early page tables except for the kernel symbol map */
 static void __init reset_early_page_tables(void)
@@ -99,7 +100,7 @@ again:
 			pmd_p[i] = 0;
 		*pud_p = (pudval_t)pmd_p - __START_KERNEL_map + phys_base + _KERNPG_TABLE;
 	}
-	pmd = (physaddr & PMD_MASK) + (__PAGE_KERNEL_LARGE & ~_PAGE_GLOBAL);
+	pmd = (physaddr & PMD_MASK) + early_pmd_flags;
 	pmd_p[pmd_index(address)] = pmd;
 
 	return 0;
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 6859e96..08f7e80 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -200,6 +200,7 @@ ENTRY(secondary_startup_64)
 	btl	$20,%edi		/* No Execute supported? */
 	jnc     1f
 	btsl	$_EFER_NX, %eax
+	btsq	$_PAGE_BIT_NX,early_pmd_flags(%rip)
 1:	wrmsr				/* Make changes effective */
 
 	/* Setup cr0 */
