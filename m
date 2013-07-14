Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab3GNQ76 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 12:59:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab3GNQ7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 12:59:48 -0400
Date: Sun, 14 Jul 2013 18:54:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Colin Cross <ccross@android.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] mm: shift VM_GROWS* check from mmap_region() to
	do_mmap_pgoff()
Message-ID: <20130714165451.GA20847@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130714165432.GA20828@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmap() doesn't allow the non-anonymous mappings with VM_GROWS* bit set.
In particular this means that mmap_region()->vma_merge(file, vm_flags)
must always fail if vm_flags & VM_GROWS. So it does not make sense to
check VM_GROWS* after we already allocated the new vma, the only caller,
do_mmap_pgoff(), which can pass this flag can do the check itself.

And this looks a bit more correct, mmap_region() already unmapped the
old mapping at this stage. But if mmap() is going to fail, it should
avoid do_munmap() if possible.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 mm/mmap.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index f681e18..6b69352 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1327,6 +1327,9 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 		}
 	}
 
+	/* Only MAP_PRIVATE|MAP_ANONYMOUS can use MAP_GROWS */
+	if ((vm_flags & VM_MAYSHARE) && (vm_flags & (VM_GROWSDOWN|VM_GROWSUP)))
+		return -EINVAL;
 	/*
 	 * Set 'VM_NORESERVE' if we should not account for the
 	 * memory use of this mapping.
@@ -1542,11 +1545,7 @@ munmap_back:
 	vma->vm_pgoff = pgoff;
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
 
-	error = -EINVAL;	/* when rejecting VM_GROWSDOWN|VM_GROWSUP */
-
 	if (file) {
-		if (vm_flags & (VM_GROWSDOWN|VM_GROWSUP))
-			goto free_vma;
 		if (vm_flags & VM_DENYWRITE) {
 			error = deny_write_access(file);
 			if (error)
@@ -1571,8 +1570,6 @@ munmap_back:
 		pgoff = vma->vm_pgoff;
 		vm_flags = vma->vm_flags;
 	} else if (vm_flags & VM_SHARED) {
-		if (unlikely(vm_flags & (VM_GROWSDOWN|VM_GROWSUP)))
-			goto free_vma;
 		error = shmem_zero_setup(vma);
 		if (error)
 			goto free_vma;
-- 
1.5.5.1

