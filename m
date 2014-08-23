Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaHWWNF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 18:13:05 -0400
Received: from mail-ie0-f201.google.com ([209.85.223.201]:63737 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaHWWMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 18:12:34 -0400
From: Peter Feiner <pfeiner@google.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Peter Feiner <pfeiner@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jamie Liu <jamieliu@google.com>,
        Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 3/3] mm: mmap: cleanup code that preserves special vm_page_prot bits
Date: Sat, 23 Aug 2014 18:12:01 -0400
Message-Id: <1408831921-10168-4-git-send-email-pfeiner@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1408831921-10168-1-git-send-email-pfeiner@google.com>
References: <1408571182-28750-1-git-send-email-pfeiner@google.com>
 <1408831921-10168-1-git-send-email-pfeiner@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace logic that has been factored out into a utility method.

Signed-off-by: Peter Feiner <pfeiner@google.com>
---
 mm/mmap.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index abcac32..c18c49a 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1618,20 +1618,8 @@ munmap_back:
 			goto free_vma;
 	}
 
-	if (vma_wants_writenotify(vma)) {
-		pgprot_t pprot = vma->vm_page_prot;
-
-		/* Can vma->vm_page_prot have changed??
-		 *
-		 * Answer: Yes, drivers may have changed it in their
-		 *         f_op->mmap method.
-		 *
-		 * Ensures that vmas marked as uncached stay that way.
-		 */
-		vma->vm_page_prot = vm_get_page_prot(vm_flags & ~VM_SHARED);
-		if (pgprot_val(pprot) == pgprot_val(pgprot_noncached(pprot)))
-			vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-	}
+	if (vma_wants_writenotify(vma))
+		vma_enable_writenotify(vma);
 
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 	/* Once vma denies write, undo our temporary denial count */
-- 
2.1.0.rc2.206.gedb03e5

