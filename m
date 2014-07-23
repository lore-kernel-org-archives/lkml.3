Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbaGWACn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 20:02:43 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:42132 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283AbaGWACl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 20:02:41 -0400
Date: Tue, 22 Jul 2014 17:01:03 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Sasha Levin <sasha.levin@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michel Lespinasse <walken@google.com>,
        Lukas Czerner <lczerner@redhat.com>, Dave Jones <davej@redhat.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] shmem: fix faulting into a hole, not taking i_mutex: fix
Message-ID: <alpine.LSU.2.11.1407221658290.32060@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha reports various nasty trinity crashes when shmem_fault() tries
to finish_wait(), we guess from rare cases when the wait_queue_head
on shmem_fallocate()'s stack has already gone.  Fix those by using
TASK_UNINTERRUPIBLE instead of TASK_KILLABLE in prepare_to_wait(),
that's much simpler and safer: TASK_KILLABLE was a nice aspiration,
but not worth any more hassle.

Reported-and-tested-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
---
Andrew, please fold this into
shmem-fix-faulting-into-a-hole-not-taking-i_mutex.patch
before sending the fixes on to Linus - thanks.

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm/mm/shmem.c	2014-07-22 16:35:49.683985586 -0700
+++ linux/mm/shmem.c	2014-07-22 16:36:35.459984108 -0700
@@ -1283,7 +1283,7 @@ static int shmem_fault(struct vm_area_st
 
 			shmem_falloc_waitq = shmem_falloc->waitq;
 			prepare_to_wait(shmem_falloc_waitq, &shmem_fault_wait,
-					TASK_KILLABLE);
+					TASK_UNINTERRUPTIBLE);
 			spin_unlock(&inode->i_lock);
 			schedule();
