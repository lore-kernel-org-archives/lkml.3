Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933427AbaHYTOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 15:14:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933125AbaHYTOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 15:14:48 -0400
Date: Mon, 25 Aug 2014 21:12:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Julien Tinnes <jln@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ipc/shm: fix the historical/wrong mm->start_stack check
Message-ID: <20140825191207.GA26106@redhat.com>
References: <20140823144246.GA6281@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140823144246.GA6281@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ->start_stack check in do_shmat() looks ugly and simply wrong.

1. ->start_stack is only valid right after exec(), the application
   can switch to another stack and even unmap this area. Or a stack
   can simply grow, ->start_stack won't even notice this.

2. The reason for this check is not clear at all. The application
   should know what it does. And why 4 pages? And why in fact it
   requires 5 pages? Plus "start_stack - size - PAGE_SIZE * 5" can
   underflow although this is minor.

   As Hugh pointed out, we actually need to require the additional
   guard page, but this code was written before linux had it.

3. This wrongly assumes that the stack can only grown down.

Personally I think we should simply kill this check, but I did not
dare to do this. So the patch only fixes the 1st problem (mostly to
avoid the usage of mm->start_stack) and ignores the VM_GROWSUP case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 ipc/shm.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index 7fc9f9f..9a322f5 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -1166,19 +1166,25 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr,
 
 	down_write(&current->mm->mmap_sem);
 	if (addr && !(shmflg & SHM_REMAP)) {
-		err = -EINVAL;
-		if (addr + size < addr)
-			goto invalid;
+		struct vm_area_struct *vma;
 
-		if (find_vma_intersection(current->mm, addr, addr + size))
-			goto invalid;
+		err = -EINVAL;
 		/*
-		 * If shm segment goes below stack, make sure there is some
-		 * space left for the stack to grow (at least 4 pages).
+		 * Ensure this segment doesn't overlap with the next vma.
+		 * If it is stack, make sure there is some space left for
+		 * the stack to grow, at least 4 pages plus a guard page
+		 * enforced by check_stack_guard_page(). (Why?)
 		 */
-		if (addr < current->mm->start_stack &&
-		    addr > current->mm->start_stack - size - PAGE_SIZE * 5)
-			goto invalid;
+		vma = find_vma(current->mm, addr);
+		if (vma) {
+			unsigned long end = addr + size;
+
+			if (vma->vm_flags & VM_GROWSDOWN)
+				end += PAGE_SIZE * 5;
+
+			if (end < addr || end > vma->vm_start)
+				goto invalid;
+		}
 	}
 
 	addr = do_mmap_pgoff(file, addr, size, prot, flags, 0, &populate);
-- 
1.5.5.1


