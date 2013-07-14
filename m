Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab3GNRAA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 13:00:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab3GNQ7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 12:59:52 -0400
Date: Sun, 14 Jul 2013 18:54:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Colin Cross <ccross@android.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] mm: mmap_region: kill correct_wcount/inode, use
	allow_write_access()
Message-ID: <20130714165457.GA20857@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130714165432.GA20828@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

correct_wcount and inode in mmap_region() just complicate the code.
This boolean was needed previously, when deny_write_access() was
called before vma_merge(), now we can simply check VM_DENYWRITE and
do allow_write_access() if it is set.

allow_write_access() checks file != NULL, so this is safe even if it
was possible to use VM_DENYWRITE && !file. Just we need to ensure we
use the same file which was deny_write_access()'ed, so the patch also
moves "file = vma->vm_file" down after allow_write_access().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 mm/mmap.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 759dce7..7be923a 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1476,11 +1476,9 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev;
-	int correct_wcount = 0;
 	int error;
 	struct rb_node **rb_link, *rb_parent;
 	unsigned long charged = 0;
-	struct inode *inode =  file ? file_inode(file) : NULL;
 
 	/* Check against address space limit. */
 	if (!may_expand_vm(mm, len >> PAGE_SHIFT)) {
@@ -1549,7 +1547,6 @@ munmap_back:
 			error = deny_write_access(file);
 			if (error)
 				goto free_vma;
-			correct_wcount = 1;
 		}
 		vma->vm_file = get_file(file);
 		error = file->f_op->mmap(file, vma);
@@ -1590,11 +1587,10 @@ munmap_back:
 	}
 
 	vma_link(mm, vma, prev, rb_link, rb_parent);
-	file = vma->vm_file;
-
 	/* Once vma denies write, undo our temporary denial count */
-	if (correct_wcount)
-		atomic_inc(&inode->i_writecount);
+	if (vm_flags & VM_DENYWRITE)
+		allow_write_access(file);
+	file = vma->vm_file;
 out:
 	perf_event_mmap(vma);
 
@@ -1613,8 +1609,8 @@ out:
 	return addr;
 
 unmap_and_free_vma:
-	if (correct_wcount)
-		atomic_inc(&inode->i_writecount);
+	if (vm_flags & VM_DENYWRITE)
+		allow_write_access(file);
 	vma->vm_file = NULL;
 	fput(file);
 
-- 
1.5.5.1

