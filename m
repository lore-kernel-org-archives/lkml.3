Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbaKRWRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 17:17:16 -0500
Received: from mga14.intel.com ([192.55.52.115]:19797 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932430AbaKRWRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 17:17:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,412,1413270000"; 
   d="scan'208";a="624500410"
Subject: [PATCH] shmdt: use i_size_read() instead of ->i_size
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave@sr71.net>, dave.hansen@linux.intel.com,
        akpm@linux-foundation.org, manfred@colorfullife.com, davidlohr@hp.com
From: Dave Hansen <dave@sr71.net>
Date: Tue, 18 Nov 2014 14:17:12 -0800
Message-Id: <20141118221712.E0062E98@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

Andrew Morton noted

	http://lkml.kernel.org/r/20141104142027.a7a0d010772d84560b445f59@linux-foundation.org

that the shmdt uses inode->i_size outside of i_mutex being held.
There is one more case in shm.c in shm_destroy().  This converts
both users over to use i_size_read().

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
---

 b/ipc/shm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN ipc/shm.c~shmdt-use-i_isize_read ipc/shm.c
--- a/ipc/shm.c~shmdt-use-i_isize_read	2014-11-18 11:13:52.293599642 -0800
+++ b/ipc/shm.c	2014-11-18 11:16:47.354495228 -0800
@@ -219,7 +219,8 @@ static void shm_destroy(struct ipc_names
 	if (!is_file_hugepages(shm_file))
 		shmem_lock(shm_file, 0, shp->mlock_user);
 	else if (shp->mlock_user)
-		user_shm_unlock(file_inode(shm_file)->i_size, shp->mlock_user);
+		user_shm_unlock(i_size_read(file_inode(shm_file)),
+				shp->mlock_user);
 	fput(shm_file);
 	ipc_rcu_putref(shp, shm_rcu_free);
 }
@@ -1272,7 +1273,7 @@ SYSCALL_DEFINE1(shmdt, char __user *, sh
 			(vma->vm_start - addr)/PAGE_SIZE == vma->vm_pgoff) {
 
 
-			size = file_inode(vma->vm_file)->i_size;
+			size = i_size_read(file_inode(vma->vm_file));
 			do_munmap(mm, vma->vm_start, vma->vm_end - vma->vm_start);
 			/*
 			 * We discovered the size of the shm segment, so
_
