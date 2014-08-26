Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbaHZTec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 15:34:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbaHZTeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 15:34:31 -0400
Date: Tue, 26 Aug 2014 21:31:45 +0200
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
Subject: [PATCH v3] ipc/shm: kill the historical/wrong mm->start_stack check
Message-ID: <20140826193145.GA26576@redhat.com>
References: <20140823144246.GA6281@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140823144246.GA6281@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_shmat() is the only user of ->start_stack (proc just reports its
value), and this check looks ugly and wrong.

The reason for this check is not clear at all, and it wrongly assumes
that the stack can only grow down.

But the main problem is that in general mm->start_stack has nothing
to do with stack_vma->vm_start. Not only the application can switch
to another stack and even unmap this area, setup_arg_pages() expands
the stack without updating mm->start_stack during exec(). This means
that in the likely case "addr > start_stack - size - PAGE_SIZE * 5"
is simply impossible after find_vma_intersection() == F, or the stack
can't grow anyway because of RLIMIT_STACK.

Many thanks to Hugh for his explanations.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 ipc/shm.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index 7fc9f9f..0145479 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -1172,13 +1172,6 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr,
 
 		if (find_vma_intersection(current->mm, addr, addr + size))
 			goto invalid;
-		/*
-		 * If shm segment goes below stack, make sure there is some
-		 * space left for the stack to grow (at least 4 pages).
-		 */
-		if (addr < current->mm->start_stack &&
-		    addr > current->mm->start_stack - size - PAGE_SIZE * 5)
-			goto invalid;
 	}
 
 	addr = do_mmap_pgoff(file, addr, size, prot, flags, 0, &populate);
-- 
1.5.5.1


