Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab3JRAux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 20:50:53 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:22901 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab3JRAuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 20:50:51 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Michel Lespinasse <walken@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        aswin@hp.com, linux-mm <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH 1/3] mm: add mlock_future_check helper
Date: Thu, 17 Oct 2013 17:50:36 -0700
Message-Id: <1382057438-3306-2-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382057438-3306-1-git-send-email-davidlohr@hp.com>
References: <1382057438-3306-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both do_brk and do_mmap_pgoff verify that we actually
capable of locking future pages if the corresponding
VM_LOCKED flags are used. Encapsulate this logic into
a single mlock_future_check() helper function.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
---
 mm/mmap.c | 45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 9d54851..6a7824d 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1192,6 +1192,24 @@ static inline unsigned long round_hint_to_min(unsigned long hint)
 	return hint;
 }
 
+static inline int mlock_future_check(struct mm_struct *mm,
+				     unsigned long flags,
+				     unsigned long len)
+{
+	unsigned long locked, lock_limit;
+
+	/*  mlock MCL_FUTURE? */
+	if (flags & VM_LOCKED) {
+		locked = len >> PAGE_SHIFT;
+		locked += mm->locked_vm;
+		lock_limit = rlimit(RLIMIT_MEMLOCK);
+		lock_limit >>= PAGE_SHIFT;
+		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
+			return -EAGAIN;
+	}
+	return 0;
+}
+
 /*
  * The caller must hold down_write(&current->mm->mmap_sem).
  */
@@ -1253,16 +1271,8 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 		if (!can_do_mlock())
 			return -EPERM;
 
-	/* mlock MCL_FUTURE? */
-	if (vm_flags & VM_LOCKED) {
-		unsigned long locked, lock_limit;
-		locked = len >> PAGE_SHIFT;
-		locked += mm->locked_vm;
-		lock_limit = rlimit(RLIMIT_MEMLOCK);
-		lock_limit >>= PAGE_SHIFT;
-		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
-			return -EAGAIN;
-	}
+	if (mlock_future_check(mm, vm_flags, len))
+		return -EAGAIN;
 
 	if (file) {
 		struct inode *inode = file_inode(file);
@@ -2593,18 +2603,9 @@ static unsigned long do_brk(unsigned long addr, unsigned long len)
 	if (error & ~PAGE_MASK)
 		return error;
 
-	/*
-	 * mlock MCL_FUTURE?
-	 */
-	if (mm->def_flags & VM_LOCKED) {
-		unsigned long locked, lock_limit;
-		locked = len >> PAGE_SHIFT;
-		locked += mm->locked_vm;
-		lock_limit = rlimit(RLIMIT_MEMLOCK);
-		lock_limit >>= PAGE_SHIFT;
-		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
-			return -EAGAIN;
-	}
+	error = mlock_future_check(mm, mm->def_flags, len);
+	if (error)
+		return error;
 
 	/*
 	 * mm->mmap_sem is required to protect against another thread
-- 
1.8.1.4

