Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937054Ab3DJXxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:53:05 -0400
Received: from smtp.nfit.au.dk ([130.225.17.180]:57799 "EHLO nysmtp.nfit.au.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934808Ab3DJXxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 19:53:03 -0400
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Apr 2013 19:53:03 EDT
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] mm: madvise: complete input validation before taking lock
Organization: D03
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date: Wed, 10 Apr 2013 23:45:06 +0000
Message-ID: <u0leheij6gt.fsf@orc05.imf.au.dk>
User-Agent: Gnus/5.1002 (Gnus v5.10.2) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In madvise(), there doesn't seem to be any reason for taking the
&current->mm->mmap_sem before start and len_in have been
validated. Incidentally, this removes the need for the out: label.


Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---

diff --git a/mm/madvise.c b/mm/madvise.c
index c58c94b..d2ae668 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -473,27 +473,27 @@ SYSCALL_DEFINE3(madvise, unsigned long, start, size_t, len_in, int, behavior)
 	if (!madvise_behavior_valid(behavior))
 		return error;
 
-	write = madvise_need_mmap_write(behavior);
-	if (write)
-		down_write(&current->mm->mmap_sem);
-	else
-		down_read(&current->mm->mmap_sem);
-
 	if (start & ~PAGE_MASK)
-		goto out;
+		return error;
 	len = (len_in + ~PAGE_MASK) & PAGE_MASK;
 
 	/* Check to see whether len was rounded up from small -ve to zero */
 	if (len_in && !len)
-		goto out;
+		return error;
 
 	end = start + len;
 	if (end < start)
-		goto out;
+		return error;
 
 	error = 0;
 	if (end == start)
-		goto out;
+		return error;
+
+	write = madvise_need_mmap_write(behavior);
+	if (write)
+		down_write(&current->mm->mmap_sem);
+	else
+		down_read(&current->mm->mmap_sem);
 
 	/*
 	 * If the interval [start,end) covers some unmapped address
@@ -541,7 +541,6 @@ SYSCALL_DEFINE3(madvise, unsigned long, start, size_t, len_in, int, behavior)
 	}
 out_plug:
 	blk_finish_plug(&plug);
-out:
 	if (write)
 		up_write(&current->mm->mmap_sem);
 	else
