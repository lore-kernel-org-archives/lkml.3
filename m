Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935044Ab3JPRvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:51:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934701Ab3JPRqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Sedat Dilek <sedat.dilek@gmail.com>, Rik van Riel <riel@redhat.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [ 43/50] ipc, shm: guard against non-existant vma in shmdt(2)
Date: Wed, 16 Oct 2013 10:45:29 -0700
Message-Id: <20131016174403.607244865@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174358.335646140@linuxfoundation.org>
References: <20131016174358.335646140@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <davidlohr.bueso@hp.com>

commit 530fcd16d87cd2417c472a581ba5a1e501556c86 upstream.

When !CONFIG_MMU there's a chance we can derefence a NULL pointer when the
VM area isn't found - check the return value of find_vma().

Also, remove the redundant -EINVAL return: retval is set to the proper
return code and *only* changed to 0, when we actually unmap the segments.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/shm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -1295,8 +1295,7 @@ SYSCALL_DEFINE1(shmdt, char __user *, sh
 #else /* CONFIG_MMU */
 	/* under NOMMU conditions, the exact address to be destroyed must be
 	 * given */
-	retval = -EINVAL;
-	if (vma->vm_start == addr && vma->vm_ops == &shm_vm_ops) {
+	if (vma && vma->vm_start == addr && vma->vm_ops == &shm_vm_ops) {
 		do_munmap(mm, vma->vm_start, vma->vm_end - vma->vm_start);
 		retval = 0;
 	}


