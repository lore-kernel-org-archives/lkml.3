Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaDAPkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 11:40:47 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:43792 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaDAPko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 11:40:44 -0400
Date: Tue, 1 Apr 2014 08:40:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [GIT PULL] s390 patches for the 3.15 merge window
In-Reply-To: <20140401085218.72f67e51@mschwide>
Message-ID: <alpine.LFD.2.11.1404010827140.26309@i7.linux-foundation.org>
References: <20140331092400.17071766@mschwide> <CA+55aFzPP6kBzWrcvps6NVu=f-FUtrfs1U6DyRpdwX6hH6PM-Q@mail.gmail.com> <20140401085218.72f67e51@mschwide>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Apr 2014, Martin Schwidefsky wrote:
> 
> I gave up after a few hours trying to solve the header dependencies, the two
> trouble makes are alpha with the task_thread_info call in mmu_context.h and
> arm with the preempt_enable_no_resched call. Welcome to include file hell.

I don't understand. The only file <asm/mmu_context.h> should need is 
<linux/mm.h>. Maybe <kernel/sched.h>.

Look at mm/mmu_context.c, for example. It includes <asm/mmu_context.h> 
without having included very many header files at all. So we *know* that 
that small set is sufficient. 

And there aren't very many users of <linux/mmu_context.h> and none of them 
are other header files, so there's no point in trying to religiously avoid 
including one or two header files from it.

So I'm thinking something like this should work. It's untested, and maybe 
some architecture really needs some other header file, but it looks quite 
likely to work. No?

              Linus

---
 include/linux/mmu_context.h | 8 +++++++-
 kernel/sched/core.c         | 2 +-
 kernel/sched/sched.h        | 3 ---
 mm/mmu_context.c            | 4 ----
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/include/linux/mmu_context.h b/include/linux/mmu_context.h
index 70fffeba7495..843bbc2abec0 100644
--- a/include/linux/mmu_context.h
+++ b/include/linux/mmu_context.h
@@ -1,7 +1,13 @@
 #ifndef _LINUX_MMU_CONTEXT_H
 #define _LINUX_MMU_CONTEXT_H
 
-struct mm_struct;
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <asm/mmu_context.h>
+
+#ifndef finish_arch_post_lock_switch
+#  define finish_arch_post_lock_switch() do { } while (0)
+#endif
 
 void use_mm(struct mm_struct *mm);
 void unuse_mm(struct mm_struct *mm);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a47902c687ae..20fc1bd8aec4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -32,7 +32,7 @@
 #include <linux/init.h>
 #include <linux/uaccess.h>
 #include <linux/highmem.h>
-#include <asm/mmu_context.h>
+#include <linux/mmu_context.h>
 #include <linux/interrupt.h>
 #include <linux/capability.h>
 #include <linux/completion.h>
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index f2de7a175620..5eafd5e8c236 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -960,9 +960,6 @@ static inline int task_running(struct rq *rq, struct task_struct *p)
 #ifndef finish_arch_switch
 # define finish_arch_switch(prev)	do { } while (0)
 #endif
-#ifndef finish_arch_post_lock_switch
-# define finish_arch_post_lock_switch()	do { } while (0)
-#endif
 
 #ifndef __ARCH_WANT_UNLOCKED_CTXSW
 static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
diff --git a/mm/mmu_context.c b/mm/mmu_context.c
index f802c2d216a7..56ecbbdbf364 100644
--- a/mm/mmu_context.c
+++ b/mm/mmu_context.c
@@ -8,8 +8,6 @@
 #include <linux/export.h>
 #include <linux/sched.h>
 
-#include <asm/mmu_context.h>
-
 /*
  * use_mm
  *	Makes the calling kernel thread take on the specified
@@ -31,9 +29,7 @@ void use_mm(struct mm_struct *mm)
 	tsk->mm = mm;
 	switch_mm(active_mm, mm, tsk);
 	task_unlock(tsk);
-#ifdef finish_arch_post_lock_switch
 	finish_arch_post_lock_switch();
-#endif
 
 	if (active_mm != mm)
 		mmdrop(active_mm);
