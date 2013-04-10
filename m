Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936503Ab3DJNv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:51:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59460 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab3DJNv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:51:57 -0400
Date: Wed, 10 Apr 2013 06:50:55 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-5952886bfeec065041d04dfcc2693b581e8f2424@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de
In-Reply-To: <1363886217-24703-1-git-send-email-bp@alien8.de>
References: <1363886217-24703-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/mm/cpa: Cleanup split_large_page()
  and its callee
Git-Commit-ID: 5952886bfeec065041d04dfcc2693b581e8f2424
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 10 Apr 2013 06:51:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5952886bfeec065041d04dfcc2693b581e8f2424
Gitweb:     http://git.kernel.org/tip/5952886bfeec065041d04dfcc2693b581e8f2424
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Thu, 21 Mar 2013 18:16:57 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 10 Apr 2013 14:39:08 +0200

x86/mm/cpa: Cleanup split_large_page() and its callee

So basically we're generating the pte_t * from a struct page and
we're handing it down to the __split_large_page() internal version
which then goes and gets back struct page * from it because it
needs it.

Change the caller to hand down struct page * directly and the
callee can compute the pte_t itself.

Net save is one virt_to_page() call and simpler code. While at
it, make __split_large_page() static.

Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1363886217-24703-1-git-send-email-bp@alien8.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/pgtable_types.h | 1 -
 arch/x86/mm/pageattr.c               | 9 ++++-----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 567b5d0..e642300 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -351,7 +351,6 @@ static inline void update_page_count(int level, unsigned long pages) { }
  * as a pte too.
  */
 extern pte_t *lookup_address(unsigned long address, unsigned int *level);
-extern int __split_large_page(pte_t *kpte, unsigned long address, pte_t *pbase);
 extern phys_addr_t slow_virt_to_phys(void *__address);
 
 #endif	/* !__ASSEMBLY__ */
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 091934e..25b1d35 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -542,13 +542,14 @@ out_unlock:
 	return do_split;
 }
 
-int __split_large_page(pte_t *kpte, unsigned long address, pte_t *pbase)
+static int
+__split_large_page(pte_t *kpte, unsigned long address, struct page *base)
 {
+	pte_t *pbase = (pte_t *)page_address(base);
 	unsigned long pfn, pfninc = 1;
 	unsigned int i, level;
 	pte_t *tmp;
 	pgprot_t ref_prot;
-	struct page *base = virt_to_page(pbase);
 
 	spin_lock(&pgd_lock);
 	/*
@@ -633,7 +634,6 @@ int __split_large_page(pte_t *kpte, unsigned long address, pte_t *pbase)
 
 static int split_large_page(pte_t *kpte, unsigned long address)
 {
-	pte_t *pbase;
 	struct page *base;
 
 	if (!debug_pagealloc)
@@ -644,8 +644,7 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	if (!base)
 		return -ENOMEM;
 
-	pbase = (pte_t *)page_address(base);
-	if (__split_large_page(kpte, address, pbase))
+	if (__split_large_page(kpte, address, base))
 		__free_page(base);
 
 	return 0;
