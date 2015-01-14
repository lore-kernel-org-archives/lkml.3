Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339AbbANHl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:41:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58981 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbbANHj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:39:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 43/44] mm: propagate error from stack expansion even for guard page
Date: Tue, 13 Jan 2015 23:24:04 -0800
Message-Id: <20150114072229.706180579@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072227.419663002@linuxfoundation.org>
References: <20150114072227.419663002@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/mm.h |    2 +-
 mm/memory.c        |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1630,7 +1630,7 @@ extern int expand_downwards(struct vm_ar
 #if VM_GROWSUP
 extern int expand_upwards(struct vm_area_struct *vma, unsigned long address);
 #else
-  #define expand_upwards(vma, address) do { } while (0)
+  #define expand_upwards(vma, address) (0)
 #endif
 
 /* Look up the first VMA which satisfies  addr < vm_end,  NULL if none. */
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3200,7 +3200,7 @@ static inline int check_stack_guard_page
 		if (prev && prev->vm_end == address)
 			return prev->vm_flags & VM_GROWSDOWN ? 0 : -ENOMEM;
 
-		expand_downwards(vma, address - PAGE_SIZE);
+		return expand_downwards(vma, address - PAGE_SIZE);
 	}
 	if ((vma->vm_flags & VM_GROWSUP) && address + PAGE_SIZE == vma->vm_end) {
 		struct vm_area_struct *next = vma->vm_next;
@@ -3209,7 +3209,7 @@ static inline int check_stack_guard_page
 		if (next && next->vm_start == address + PAGE_SIZE)
 			return next->vm_flags & VM_GROWSUP ? 0 : -ENOMEM;
 
-		expand_upwards(vma, address + PAGE_SIZE);
+		return expand_upwards(vma, address + PAGE_SIZE);
 	}
 	return 0;
 }


