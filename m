Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaCXM7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 08:59:41 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:48235 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaCXM7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 08:59:36 -0400
Message-Id: <20140324125926.204897920@openvz.org>
User-Agent: quilt/0.60-1
Date: Mon, 24 Mar 2014 16:28:42 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: hughd@google.com, xemul@parallels.com, akpm@linux-foundation.org,
        gorcunov@openvz.org
Subject: [patch 4/4] mm: Clear VM_SOFTDIRTY flag inside clear_refs_write instead of clear_soft_dirty
References: <20140324122838.490106581@openvz.org>
Content-Disposition: inline; filename=mm-vma-softdirty-clean-vma-softdirty-bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clear_refs_write is called earlier than clear_soft_dirty and it is
more natural to clear VM_SOFTDIRTY (which belongs to VMA entry but not
PTEs) that early instead of clearing it a way deeper inside call chain.

CC: Pavel Emelyanov <xemul@parallels.com>
CC: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 fs/proc/task_mmu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6.git/fs/proc/task_mmu.c
===================================================================
--- linux-2.6.git.orig/fs/proc/task_mmu.c
+++ linux-2.6.git/fs/proc/task_mmu.c
@@ -736,9 +736,6 @@ static inline void clear_soft_dirty(stru
 		ptent = pte_file_clear_soft_dirty(ptent);
 	}
 
-	if (vma->vm_flags & VM_SOFTDIRTY)
-		vma->vm_flags &= ~VM_SOFTDIRTY;
-
 	set_pte_at(vma->vm_mm, addr, pte, ptent);
 #endif
 }
@@ -843,6 +840,10 @@ static ssize_t clear_refs_write(struct f
 				continue;
 			if (type == CLEAR_REFS_MAPPED && !vma->vm_file)
 				continue;
+			if (type == CLEAR_REFS_SOFT_DIRTY) {
+				if (vma->vm_flags & VM_SOFTDIRTY)
+					vma->vm_flags &= ~VM_SOFTDIRTY;
+			}
 			walk_page_range(vma->vm_start, vma->vm_end,
 					&clear_refs_walk);
 		}

