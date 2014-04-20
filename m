Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161052AbaDTC2a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 22:28:30 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:53542 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbaDTC0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 22:26:48 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org
Cc: zeus@gnu.org, aswin@hp.com, davidlohr@hp.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: [PATCH 2/6] m68k: call find_vma with the mmap_sem held in sys_cacheflush()
Date: Sat, 19 Apr 2014 19:26:27 -0700
Message-Id: <1397960791-16320-3-git-send-email-davidlohr@hp.com>
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
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
---
 arch/m68k/kernel/sys_m68k.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/m68k/kernel/sys_m68k.c b/arch/m68k/kernel/sys_m68k.c
index 3a480b3..d2263a0 100644
--- a/arch/m68k/kernel/sys_m68k.c
+++ b/arch/m68k/kernel/sys_m68k.c
@@ -376,7 +376,6 @@ cache_flush_060 (unsigned long addr, int scope, int cache, unsigned long len)
 asmlinkage int
 sys_cacheflush (unsigned long addr, int scope, int cache, unsigned long len)
 {
-	struct vm_area_struct *vma;
 	int ret = -EINVAL;
 
 	if (scope < FLUSH_SCOPE_LINE || scope > FLUSH_SCOPE_ALL ||
@@ -389,16 +388,23 @@ sys_cacheflush (unsigned long addr, int scope, int cache, unsigned long len)
 		if (!capable(CAP_SYS_ADMIN))
 			goto out;
 	} else {
+		struct vm_area_struct *vma;
+		bool invalid;
+
+		/* Check for overflow.  */
+		if (addr + len < addr)
+			goto out;
+
 		/*
 		 * Verify that the specified address region actually belongs
 		 * to this process.
 		 */
-		vma = find_vma (current->mm, addr);
 		ret = -EINVAL;
-		/* Check for overflow.  */
-		if (addr + len < addr)
-			goto out;
-		if (vma == NULL || addr < vma->vm_start || addr + len > vma->vm_end)
+		down_read(&current->mm->mmap_sem);
+		vma = find_vma(current->mm, addr);
+		invalid = !vma || addr < vma->vm_start || addr + len > vma->vm_end;
+		up_read(&current->mm->mmap_sem);
+		if (invalid)
 			goto out;
 	}
 
-- 
1.8.1.4

