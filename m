Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab3CPPYb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 11:24:31 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:52556 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab3CPPYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 11:24:30 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>, Tommi Rantala <tt.rantala@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] mm/fremap.c: fix another oops on error path
Date: Sat, 16 Mar 2013 23:23:32 +0800
Message-Id: <1363447412-23804-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since find_vma() may return NULL, so don't dereference the
returned 'vma' until it is valid.

The problem is introduced by the commit in linus tree:

 6d7825b(mm/fremap.c: fix oops on error path).

Also mark vm_flags as ninitialized_var() to avoid compile
warning.

Cc: Tommi Rantala <tt.rantala@gmail.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 mm/fremap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/fremap.c b/mm/fremap.c
index 6a8da7e..80088e9 100644
--- a/mm/fremap.c
+++ b/mm/fremap.c
@@ -129,7 +129,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 	struct vm_area_struct *vma;
 	int err = -EINVAL;
 	int has_write_lock = 0;
-	vm_flags_t vm_flags;
+	vm_flags_t uninitialized_var(vm_flags);
 
 	if (prot)
 		return err;
@@ -163,8 +163,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 	 * and that the remapped range is valid and fully within
 	 * the single existing vma.
 	 */
-	vm_flags = vma->vm_flags;
-	if (!vma || !(vm_flags & VM_SHARED))
+	if (!vma || !(vma->vm_flags & VM_SHARED))
 		goto out;
 
 	if (!vma->vm_ops || !vma->vm_ops->remap_pages)
-- 
1.7.9.5

