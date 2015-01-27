Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575AbbA0MtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:49:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34881 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758237AbbA0MRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:16 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 019/126] mm: propagate error from stack expansion even for guard page
Date: Tue, 27 Jan 2015 12:15:24 +0000
Message-Id: <1422361031-19364-20-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit fee7e49d45149fba60156f5b59014f764d3e3728 upstream.

Jay Foad reports that the address sanitizer test (asan) sometimes gets
confused by a stack pointer that ends up being outside the stack vma
that is reported by /proc/maps.

This happens due to an interaction between RLIMIT_STACK and the guard
page: when we do the guard page check, we ignore the potential error
from the stack expansion, which effectively results in a missing guard
page, since the expected stack expansion won't have been done.

And since /proc/maps explicitly ignores the guard page (commit
d7824370e263: "mm: fix up some user-visible effects of the stack guard
page"), the stack pointer ends up being outside the reported stack area.

This is the minimal patch: it just propagates the error.  It also
effectively makes the guard page part of the stack limit, which in turn
measn that the actual real stack is one page less than the stack limit.

Let's see if anybody notices.  We could teach acct_stack_growth() to
allow an extra page for a grow-up/grow-down stack in the rlimit test,
but I don't want to add more complexity if it isn't needed.

Reported-and-tested-by: Jay Foad <jay.foad@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/mm.h | 2 +-
 mm/memory.c        | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f988e4b189e1..663ad81d3c66 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1902,7 +1902,7 @@ extern int expand_downwards(struct vm_area_struct *vma,
 #if VM_GROWSUP
 extern int expand_upwards(struct vm_area_struct *vma, unsigned long address);
 #else
-  #define expand_upwards(vma, address) do { } while (0)
+  #define expand_upwards(vma, address) (0)
 #endif
 
 /* Look up the first VMA which satisfies  addr < vm_end,  NULL if none. */
diff --git a/mm/memory.c b/mm/memory.c
index 00a99f5614df..49787747ca33 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2601,7 +2601,7 @@ static inline int check_stack_guard_page(struct vm_area_struct *vma, unsigned lo
 		if (prev && prev->vm_end == address)
 			return prev->vm_flags & VM_GROWSDOWN ? 0 : -ENOMEM;
 
-		expand_downwards(vma, address - PAGE_SIZE);
+		return expand_downwards(vma, address - PAGE_SIZE);
 	}
 	if ((vma->vm_flags & VM_GROWSUP) && address + PAGE_SIZE == vma->vm_end) {
 		struct vm_area_struct *next = vma->vm_next;
@@ -2610,7 +2610,7 @@ static inline int check_stack_guard_page(struct vm_area_struct *vma, unsigned lo
 		if (next && next->vm_start == address + PAGE_SIZE)
 			return next->vm_flags & VM_GROWSUP ? 0 : -ENOMEM;
 
-		expand_upwards(vma, address + PAGE_SIZE);
+		return expand_upwards(vma, address + PAGE_SIZE);
 	}
 	return 0;
 }
-- 
2.1.4

