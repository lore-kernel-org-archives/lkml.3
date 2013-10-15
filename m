Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab3JOKfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 06:35:16 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:57611 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758116Ab3JOKfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 06:35:14 -0400
Date: Tue, 15 Oct 2013 03:34:55 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Chen Gang <gang.chen@asianux.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH] mm: revert mremap pud_free anti-fix
Message-ID: <alpine.LNX.2.00.1310150330350.9078@eggly.anvils>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revert 1ecfd533f4c5 ("mm/mremap.c: call pud_free() after fail calling
pmd_alloc()").  The original code was correct: pud_alloc(), pmd_alloc(),
pte_alloc_map() ensure that the pud, pmd, pt is already allocated, and
seldom do they need to allocate; on failure, upper levels are freed if
appropriate by the subsequent do_munmap().  Whereas 1ecfd533f4c5 did an
unconditional pud_free() of a most-likely still-in-use pud: saved only
by the near-impossiblity of pmd_alloc() failing.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/mremap.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- 3.12-rc5/mm/mremap.c	2013-09-16 17:37:56.841072270 -0700
+++ linux/mm/mremap.c	2013-10-15 03:07:09.140091599 -0700
@@ -25,7 +25,6 @@
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
-#include <asm/pgalloc.h>
 
 #include "internal.h"
 
@@ -63,10 +62,8 @@ static pmd_t *alloc_new_pmd(struct mm_st
 		return NULL;
 
 	pmd = pmd_alloc(mm, pud, addr);
-	if (!pmd) {
-		pud_free(mm, pud);
+	if (!pmd)
 		return NULL;
-	}
 
 	VM_BUG_ON(pmd_trans_huge(*pmd));
 
