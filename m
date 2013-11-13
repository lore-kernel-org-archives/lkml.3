Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab3KMFEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 00:04:45 -0500
Received: from intranet.asianux.com ([58.214.24.6]:34968 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3KMFEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 00:04:38 -0500
X-Spam-Score: -100.8
Message-ID: <528308E8.8040203@asianux.com>
Date: Wed, 13 Nov 2013 13:06:48 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>
CC: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        uml-user <user-mode-linux-user@lists.sourceforge.net>
Subject: [PATCH] arch: um: kernel: skas: mmu: remove pmd_free() and pud_free()
 for failure processing in init_stub_pte()
References: <alpine.LNX.2.00.1310150330350.9078@eggly.anvils>
In-Reply-To: <alpine.LNX.2.00.1310150330350.9078@eggly.anvils>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately, p?d_alloc() and p?d_free() are not pair!! If p?d_alloc()
succeed, they may be used, so in the next failure, we have to skip them
to let exit_mmap() or do_munmap() to process it.

According to "Documentation/vm/locking", 'mm->page_table_lock' is for
using vma list, so not need it when its related vmas are detached or
unmapped from using vma list.

The related work flow:

  exit_mmap() ->
    unmap_vmas(); /* so not need mm->page_table_lock */
    free_pgtables();

  do_munmap()->
    detach_vmas_to_be_unmapped(); /* so not need mm->page_table_lock */
    unmap_region() ->
      free_pgtables();

  free_pgtables() ->
    free_pgd_range() ->
      free_pud_range() ->
        free_pmd_range() ->
          free_pte_range() ->
            pmd_clear();
            pte_free_tlb();
          pud_clear();
          pmd_free_tlb();
        pgd_clear(); 
        pud_free_tlb();


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/um/kernel/skas/mmu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/kernel/skas/mmu.c b/arch/um/kernel/skas/mmu.c
index 007d550..3fd1951 100644
--- a/arch/um/kernel/skas/mmu.c
+++ b/arch/um/kernel/skas/mmu.c
@@ -40,9 +40,9 @@ static int init_stub_pte(struct mm_struct *mm, unsigned long proc,
 	return 0;
 
  out_pte:
-	pmd_free(mm, pmd);
+	/* used by mm->pgd->pud, will free in do_munmap() or exit_mmap() */
  out_pmd:
-	pud_free(mm, pud);
+	/* used by mm->pgd, will free in do_munmap() or exit_mmap() */
  out:
 	return -ENOMEM;
 }
-- 
1.7.7.6
