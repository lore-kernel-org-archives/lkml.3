Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbaIYOka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:40:30 -0400
Received: from relay2.sgi.com ([192.48.180.65]:45499 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751641AbaIYOk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:40:28 -0400
From: James Custer <jcuster@sgi.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Cc: James Custer <jcuster@sgi.com>
Subject: [PATCH] x86: Allow 1GB pages to be SPECIAL similar to 2MB
Date: Thu, 25 Sep 2014 09:40:24 -0500
Message-Id: <1411656024-33114-1-git-send-email-jcuster@sgi.com>
X-Mailer: git-send-email 1.7.12.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Superpages allocated by SGI's superpages module can be backed by 1GB pages,
but direct i/o cannot be used. The superpages module uses _PAGE_BIT_SPECIAL
to disable direct i/o because some code depends on the memory being backed
by page structures. But, because superpages have no backing page structures
this causes a panic.

This is the way direct i/o on 1GB pages fails:

               BUG: unable to handle kernel paging request at ffffea0038000000
[60463.203795] IP: [<ffffffff8103c93a>] gup_huge_pud+0x9a/0xe0
[60463.210058] PGD 83ffd3067 PUD 83ffd2067 PMD 0
[60463.215052] Oops: 0000 [#1] SMP

Stack traceback for pid 77136
0xffff8867a88ae300    77136    74825  1   56   R  0xffff8867a88ae970 *readdirectsp
 [<ffffffff8103c93a>] gup_huge_pud+0x9a/0xe0
 [<ffffffff8103cc33>] gup_pud_range+0x173/0x1b0
 [<ffffffff8103cd57>] get_user_pages_fast+0xe7/0x1b0
 [<ffffffff8118eac3>] dio_get_page+0x83/0x150
 [<ffffffff8118f641>] do_direct_IO+0x81/0x420
 [<ffffffff8118fb89>] direct_io_worker+0x1a9/0x340
 [<ffffffffa00c5de8>] ext3_direct_IO+0xe8/0x2c0 [ext3]
 [<ffffffff810fa527>] generic_file_aio_read+0x237/0x260
 [<ffffffff81159878>] do_sync_read+0xc8/0x110
 [<ffffffff8115a027>] vfs_read+0xc7/0x130
 [<ffffffff8115a193>] sys_read+0x53/0xa0
 [<ffffffff81466192>] system_call_fastpath+0x16/0x1b

gup_huge_pud() is trying to find the page structure, and with superpages there
is none.

With direct i/o on 2MB pages:

static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
                int write, struct page **pages, int *nr)
{
 ...
                if (pmd_none(pmd) || pmd_trans_splitting(pmd))
                        return 0;

and pmd_trans_splitting() is testing _PAGE_SPLITTING, which is an alias
for _PAGE_SPECIAL which we set on the 2MB or 1GB pages mapped in by superpages.

But gup_pud_range() has no such check:

static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
                        int write, struct page **pages, int *nr)
{
  ...
                if (pud_none(pud))
                        return 0;

Therefore direct i/o on 1GB pages attempts to get a page structure and panics.

Signed-off-by: James Custer <jcuster@sgi.com>
---
 arch/x86/mm/gup.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index dd74e46..12ca9cf 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -121,7 +121,6 @@ static noinline int gup_huge_pmd(pmd_t pmd, unsigned long addr,
 		mask |= _PAGE_RW;
 	if ((pte_flags(pte) & mask) != mask)
 		return 0;
-	/* hugepages are never "special" */
 	VM_BUG_ON(pte_flags(pte) & _PAGE_SPECIAL);
 	VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 
@@ -191,7 +190,6 @@ static noinline int gup_huge_pud(pud_t pud, unsigned long addr,
 		mask |= _PAGE_RW;
 	if ((pte_flags(pte) & mask) != mask)
 		return 0;
-	/* hugepages are never "special" */
 	VM_BUG_ON(pte_flags(pte) & _PAGE_SPECIAL);
 	VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 
@@ -223,7 +221,7 @@ static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
 		pud_t pud = *pudp;
 
 		next = pud_addr_end(addr, end);
-		if (pud_none(pud))
+		if (pud_none(pud) || (pud_val(pud) & _PAGE_SPECIAL))
 			return 0;
 		if (unlikely(pud_large(pud))) {
 			if (!gup_huge_pud(pud, addr, next, write, pages, nr))
-- 
1.7.12.4

