Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab3GTP2V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 11:28:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294Ab3GTP2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 11:28:13 -0400
Date: Sat, 20 Jul 2013 17:23:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Colin Cross <ccross@android.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] mm: shift VM_GROWS* check from mmap_region() to
	do_mmap_pgoff()
Message-ID: <20130720152307.GB588@redhat.com>
References: <20130714165432.GA20828@redhat.com> <20130714165451.GA20847@redhat.com> <20130716144315.2a8e80479d9b4789df69fb91@linux-foundation.org> <alpine.LNX.2.00.1307191900390.986@eggly.anvils> <20130720152246.GA588@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130720152246.GA588@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmap() doesn't allow the non-anonymous mappings with VM_GROWS* bit set.
In particular this means that mmap_region()->vma_merge(file, vm_flags)
must always fail if "vm_flags & VM_GROWS" is set incorrectly.

So it does not make sense to check VM_GROWS* after we already allocated
the new vma, the only caller, do_mmap_pgoff(), which can pass this flag
can do the check itself.

And this looks a bit more correct, mmap_region() already unmapped the
old mapping at this stage. But if mmap() is going to fail, it should
avoid do_munmap() if possible.

Note: we check VM_GROWS at the end to ensure that do_mmap_pgoff() won't
return EINVAL in the case when it currently returns another error code.

Many thanks to Hugh who nacked the buggy v1.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 mm/mmap.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index fbad7b0..92d9f54 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1302,6 +1302,8 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 
 			if (!file->f_op || !file->f_op->mmap)
 				return -ENODEV;
+			if (vm_flags & (VM_GROWSDOWN|VM_GROWSUP))
+				return -EINVAL;
 			break;
 
 		default:
@@ -1310,6 +1312,8 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 	} else {
 		switch (flags & MAP_TYPE) {
 		case MAP_SHARED:
+			if (vm_flags & (VM_GROWSDOWN|VM_GROWSUP))
+				return -EINVAL;
 			/*
 			 * Ignore pgoff.
 			 */
@@ -1544,11 +1548,7 @@ munmap_back:
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
@@ -1573,8 +1573,6 @@ munmap_back:
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


