Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbaDMT4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 15:56:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754973AbaDMT4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 15:56:43 -0400
Date: Sun, 13 Apr 2014 21:56:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] kthreads: kill CLONE_KERNEL, change
	kernel_thread(kernel_init) to avoid CLONE_SIGHAND
Message-ID: <20140413195617.GA31819@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Remove CLONE_KERNEL, it has no users and it is dangerous.

   The (old) comment says "List of flags we want to share for kernel
   threads" but this is not true, we do not want to share ->sighand by
   default. This flag can only be used if the caller is sure that both
   parent/child will never play with signals (say, allow_signal/etc).

2. Change rest_init() to clone kernel_init() without CLONE_SIGHAND.

   In this case CLONE_SIGHAND does not really hurt, and it looks like
   optimization because copy_sighand() can avoid kmem_cache_alloc().

   But in fact this only adds the minor pessimization. kernel_init()
   is going to exec the init process, and de_thread() will need to
   unshare ->sighand and do kmem_cache_alloc(sighand_cachep) anyway,
   but it needs to do more work and take tasklist_lock and siglock.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/sched.h |    6 ------
 init/main.c           |    2 +-
 2 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a781dec..e44888e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -131,12 +131,6 @@ struct blk_plug;
 struct filename;
 
 /*
- * List of flags we want to share for kernel threads,
- * if only because they are not used by them anyway.
- */
-#define CLONE_KERNEL	(CLONE_FS | CLONE_FILES | CLONE_SIGHAND)
-
-/*
  * These are the constant used to fake the fixed-point load-average
  * counting. Some notes:
  *  - 11 bit fractions expand to 22 bits by the multiplies: this gives
diff --git a/init/main.c b/init/main.c
index 9c7fd4c..3815895 100644
--- a/init/main.c
+++ b/init/main.c
@@ -379,7 +379,7 @@ static noinline void __init_refok rest_init(void)
 	 * the init task will end up wanting to create kthreads, which, if
 	 * we schedule it before we create kthreadd, will OOPS.
 	 */
-	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
+	kernel_thread(kernel_init, NULL, CLONE_FS);
 	numa_default_policy();
 	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
 	rcu_read_lock();
-- 
1.5.5.1


