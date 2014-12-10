Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbaLJOYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:24:40 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:49365 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757610AbaLJOXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:23:45 -0500
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org, akpm@linux-foundation.org,
        heiko.carstens@de.ibm.com, dahi@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, borntraeger@de.ibm.com, mst@redhat.com,
        tglx@linutronix.de, David.Laight@ACULAB.COM, peterz@infradead.org,
        hughd@google.com, hocko@suse.cz
Subject: [PATCH v2 3/5] mm, uaccess: trigger might_sleep() in might_fault() when pagefaults are disabled
Date: Wed, 10 Dec 2014 15:23:32 +0100
Message-Id: <1418221414-60110-4-git-send-email-dahi@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1418221414-60110-1-git-send-email-dahi@linux.vnet.ibm.com>
References: <1418221414-60110-1-git-send-email-dahi@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121014-0013-0000-0000-0000022A7160
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 662bbcb2747c ("mm, sched: Allow uaccess in atomic with
pagefault_disable()") removed might_sleep() checks for all user access code
(that uses might_fault()).

The reason was to disable wrong "sleep in atomic" warnings in the following
scenario:
    pagefault_disable()
    rc = copy_to_user(...)
    pagefault_enable()

Which is valid, as pagefault_disable() increments the preempt counter and
therefore disables the pagefault handler. copy_to_user() will not sleep and return
an invalid return code if a page is not available.

However, as all might_sleep() checks are removed, CONFIG_DEBUG_ATOMIC_SLEEP
would no longer detect the following scenario:
    spin_lock(&lock);
    rc = copy_to_user(...)
    spin_unlock(&lock)

If the kernel is compiled with preemption turned on, the preempt counter would
be incremented and copy_to_user() would never sleep. However, with preemption
turned off, the preempt counter will not be touched, we will therefore sleep in
atomic context. We really want to enable CONFIG_DEBUG_ATOMIC_SLEEP checks for
user access functions again, otherwise horrible deadlocks might be hard to debug.

Root of all evil is that pagefault_disable() acted almost as preempt_disable(),
depending on preemption being turned on/off.

As we now have pagefault_disabled(), we can use it to distingusih whether user
acces functions might sleep.

Convert might_fault() into a makro that calls __might_fault(), to allow proper
file + line messages in case of a might_sleep() warning. We can't move the code
directly into kernel.h for now, as that results in ugly header recursions we
can't avoid for now.

Signed-off-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
---
 include/linux/kernel.h |  3 ++-
 mm/memory.c            | 18 ++++++------------
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 446d76a..7e65a55 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -232,7 +232,8 @@ static inline u32 reciprocal_scale(u32 val, u32 ep_ro)
 
 #if defined(CONFIG_MMU) && \
 	(defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_DEBUG_ATOMIC_SLEEP))
-void might_fault(void);
+#define might_fault() __might_fault(__FILE__, __LINE__)
+void __might_fault(const char *file, int line);
 #else
 static inline void might_fault(void) { }
 #endif
diff --git a/mm/memory.c b/mm/memory.c
index 0b3f6c7..563720a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3686,7 +3686,7 @@ void print_vma_addr(char *prefix, unsigned long ip)
 }
 
 #if defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_DEBUG_ATOMIC_SLEEP)
-void might_fault(void)
+void __might_fault(const char *file, int line)
 {
 	/*
 	 * Some code (nfs/sunrpc) uses socket ops on kernel memory while
@@ -3696,21 +3696,15 @@ void might_fault(void)
 	 */
 	if (segment_eq(get_fs(), KERNEL_DS))
 		return;
-
-	/*
-	 * it would be nicer only to annotate paths which are not under
-	 * pagefault_disable, however that requires a larger audit and
-	 * providing helpers like get_user_atomic.
-	 */
-	if (in_atomic())
+	if (pagefault_disabled())
 		return;
-
-	__might_sleep(__FILE__, __LINE__, 0);
-
+	__might_sleep(file, line, 0);
+#if defined(CONFIG_DEBUG_ATOMIC_SLEEP)
 	if (current->mm)
 		might_lock_read(&current->mm->mmap_sem);
+#endif
 }
-EXPORT_SYMBOL(might_fault);
+EXPORT_SYMBOL(__might_fault);
 #endif
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLBFS)
-- 
1.8.5.5

