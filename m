Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab3EXOSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:18:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756512Ab3EXOSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:18:20 -0400
Date: Fri, 24 May 2013 17:18:41 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Subject: [PATCH v3 11/11] kernel: uaccess in atomic with pagefault_disable
Message-ID: <1369404522-12927-11-git-send-email-mst@redhat.com>
References: <cover.1368702323.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1368702323.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes might_fault so that it does not
trigger a false positive diagnostic for e.g. the following
sequence:
	spin_lock_irqsave
	pagefault_disable
	copy_to_user
	pagefault_enable
	spin_unlock_irqrestore

In particular vhost wants to do this, to call
socket ops from under a lock.

There are 3 cases to consider:
CONFIG_PROVE_LOCKING - might_fault is non-inline
so it's easy to move the in_atomic test to fix
up the false positive warning.

CONFIG_DEBUG_ATOMIC_SLEEP - might_fault
is currently inline, but we are calling a
non-inline __might_sleep anyway,
so let's use the non-line version of might_fault
that does the right thing.

!CONFIG_DEBUG_ATOMIC_SLEEP && !CONFIG_PROVE_LOCKING
__might_sleep is a nop so might_fault is a nop.
Make this explicit.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/kernel.h |  7 ++-----
 mm/memory.c            | 11 +++++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index c514c06..0153be1 100644
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
-- 
MST
