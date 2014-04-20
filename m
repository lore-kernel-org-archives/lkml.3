Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbaDTC2o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 22:28:44 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:57917 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbaDTC0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 22:26:51 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org
Cc: zeus@gnu.org, aswin@hp.com, davidlohr@hp.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 4/6] arc: call find_vma with the mmap_sem held
Date: Sat, 19 Apr 2014 19:26:29 -0700
Message-Id: <1397960791-16320-5-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1397960791-16320-1-git-send-email-davidlohr@hp.com>
References: <1397960791-16320-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Performing vma lookups without taking the mm->mmap_sem is asking
for trouble. While doing the search, the vma in question can be
modified or even removed before returning to the caller. Take the
lock (shared) in order to avoid races while iterating through
the vmacache and/or rbtree.

This patch is completely *untested*.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/kernel/troubleshoot.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arc/kernel/troubleshoot.c b/arch/arc/kernel/troubleshoot.c
index 73a7450..3a5a5c1 100644
--- a/arch/arc/kernel/troubleshoot.c
+++ b/arch/arc/kernel/troubleshoot.c
@@ -90,7 +90,7 @@ static void show_faulting_vma(unsigned long address, char *buf)
 	/* can't use print_vma_addr() yet as it doesn't check for
 	 * non-inclusive vma
 	 */
-
+	down_read(&current->active_mm->mmap_sem);
 	vma = find_vma(current->active_mm, address);
 
 	/* check against the find_vma( ) behaviour which returns the next VMA
@@ -110,9 +110,10 @@ static void show_faulting_vma(unsigned long address, char *buf)
 			vma->vm_start < TASK_UNMAPPED_BASE ?
 				address : address - vma->vm_start,
 			nm, vma->vm_start, vma->vm_end);
-	} else {
+	} else
 		pr_info("    @No matching VMA found\n");
-	}
+
+	up_read(&current->active_mm->mmap_sem);
 }
 
 static void show_ecr_verbose(struct pt_regs *regs)
-- 
1.8.1.4

