Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934115Ab3E1N1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:27:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50482 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933952Ab3E1N1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:27:49 -0400
Date: Tue, 28 May 2013 06:27:08 -0700
From: "tip-bot for Michael S. Tsirkin" <tipbot@zytor.com>
Message-ID: <tip-662bbcb2747c2422cf98d3d97619509379eee466@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, mst@redhat.com,
        peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mst@redhat.com, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <1369577426-26721-11-git-send-email-mst@redhat.com>
References: <1369577426-26721-11-git-send-email-mst@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/mm] mm, sched:
  Allow uaccess in atomic with pagefault_disable()
Git-Commit-ID: 662bbcb2747c2422cf98d3d97619509379eee466
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  662bbcb2747c2422cf98d3d97619509379eee466
Gitweb:     http://git.kernel.org/tip/662bbcb2747c2422cf98d3d97619509379eee466
Author:     Michael S. Tsirkin <mst@redhat.com>
AuthorDate: Sun, 26 May 2013 17:32:23 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 09:41:11 +0200

mm, sched: Allow uaccess in atomic with pagefault_disable()

This changes might_fault() so that it does not
trigger a false positive diagnostic for e.g. the following
sequence:

	spin_lock_irqsave()
	pagefault_disable()
	copy_to_user()
	pagefault_enable()
	spin_unlock_irqrestore()

In particular vhost wants to do this, to call
socket ops from under a lock.

There are 3 cases to consider:

 - CONFIG_PROVE_LOCKING - might_fault is non-inline
   so it's easy to move the in_atomic test to fix
   up the false positive warning.

 - CONFIG_DEBUG_ATOMIC_SLEEP - might_fault
   is currently inline, but we are calling a
   non-inline __might_sleep anyway,
   so let's use the non-line version of might_fault
   that does the right thing.

 - !CONFIG_DEBUG_ATOMIC_SLEEP && !CONFIG_PROVE_LOCKING
   __might_sleep is a nop so might_fault is a nop.

Make this explicit.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1369577426-26721-11-git-send-email-mst@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/kernel.h |  7 ++-----
 mm/memory.c            | 11 +++++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 24719ea..4c7e2e5 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -193,13 +193,10 @@ extern int _cond_resched(void);
 		(__x < 0) ? -__x : __x;		\
 	})
 
-#ifdef CONFIG_PROVE_LOCKING
+#if defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_DEBUG_ATOMIC_SLEEP)
 void might_fault(void);
 #else
-static inline void might_fault(void)
-{
-	__might_sleep(__FILE__, __LINE__, 0);
-}
+static inline void might_fault(void) { }
 #endif
 
 extern struct atomic_notifier_head panic_notifier_list;
diff --git a/mm/memory.c b/mm/memory.c
index c1f190f..d7d54a1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4210,7 +4210,7 @@ void print_vma_addr(char *prefix, unsigned long ip)
 	up_read(&mm->mmap_sem);
 }
 
-#ifdef CONFIG_PROVE_LOCKING
+#if defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_DEBUG_ATOMIC_SLEEP)
 void might_fault(void)
 {
 	/*
@@ -4222,14 +4222,17 @@ void might_fault(void)
 	if (segment_eq(get_fs(), KERNEL_DS))
 		return;
 
-	__might_sleep(__FILE__, __LINE__, 0);
-
 	/*
 	 * it would be nicer only to annotate paths which are not under
 	 * pagefault_disable, however that requires a larger audit and
 	 * providing helpers like get_user_atomic.
 	 */
-	if (!in_atomic() && current->mm)
+	if (in_atomic())
+		return;
+
+	__might_sleep(__FILE__, __LINE__, 0);
+
+	if (current->mm)
 		might_lock_read(&current->mm->mmap_sem);
 }
 EXPORT_SYMBOL(might_fault);
