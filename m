Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab3GVBXD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 21:23:03 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:18759 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab3GVBVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 21:21:53 -0400
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH 1/4] ipc, shm: guard against non-existant vma in shmdt(2)
Date: Sun, 21 Jul 2013 18:21:40 -0700
Message-Id: <1374456103-25353-2-git-send-email-davidlohr.bueso@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1374456103-25353-1-git-send-email-davidlohr.bueso@hp.com>
References: <1374456103-25353-1-git-send-email-davidlohr.bueso@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When !CONFIG_MMU there's a chance we can derefence a NULL pointer
when the VM area isn't found - check the return value of find_vma().

Also, remove the redundant -EINVAL return: retval is set to the proper
return code and *only* changed to 0, when we actually unmap the segments.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/shm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index 59f2194..c7ee2f6 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -1288,8 +1288,7 @@ SYSCALL_DEFINE1(shmdt, char __user *, shmaddr)
 #else /* CONFIG_MMU */
 	/* under NOMMU conditions, the exact address to be destroyed must be
 	 * given */
-	retval = -EINVAL;
-	if (vma->vm_start == addr && vma->vm_ops == &shm_vm_ops) {
+	if (vma && vma->vm_start == addr && vma->vm_ops == &shm_vm_ops) {
 		do_munmap(mm, vma->vm_start, vma->vm_end - vma->vm_start);
 		retval = 0;
 	}
-- 
1.7.11.7

