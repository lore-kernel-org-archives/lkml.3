Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024AbbA2Jyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:54:50 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44795 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751941AbbA2JD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:03:26 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 055/176] mm: propagate error from stack expansion even for guard page
Date: Wed, 28 Jan 2015 15:28:05 +0100
Message-Id: <88d43e17473b56a9d86686766be810546807f2f4.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/mm.h | 2 +-
 mm/memory.c        | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 36556b2e07f8..306f0d4ce7e3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1642,7 +1642,7 @@ extern int expand_downwards(struct vm_area_struct *vma,
 #if VM_GROWSUP
 extern int expand_upwards(struct vm_area_struct *vma, unsigned long address);
 #else
-  #define expand_upwards(vma, address) do { } while (0)
+  #define expand_upwards(vma, address) (0)
 #endif
 
 /* Look up the first VMA which satisfies  addr < vm_end,  NULL if none. */
diff --git a/mm/memory.c b/mm/memory.c
index 827a7ed7f5a2..db2916f5f378 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3194,7 +3194,7 @@ static inline int check_stack_guard_page(struct vm_area_struct *vma, unsigned lo
 		if (prev && prev->vm_end == address)
 			return prev->vm_flags & VM_GROWSDOWN ? 0 : -ENOMEM;
 
-		expand_downwards(vma, address - PAGE_SIZE);
+		return expand_downwards(vma, address - PAGE_SIZE);
 	}
 	if ((vma->vm_flags & VM_GROWSUP) && address + PAGE_SIZE == vma->vm_end) {
 		struct vm_area_struct *next = vma->vm_next;
@@ -3203,7 +3203,7 @@ static inline int check_stack_guard_page(struct vm_area_struct *vma, unsigned lo
 		if (next && next->vm_start == address + PAGE_SIZE)
 			return next->vm_flags & VM_GROWSUP ? 0 : -ENOMEM;
 
-		expand_upwards(vma, address + PAGE_SIZE);
+		return expand_upwards(vma, address + PAGE_SIZE);
 	}
 	return 0;
 }
-- 
2.2.2

