Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab3L2BpY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 20:45:24 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:42064 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab3L2BpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 20:45:22 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kirill@shutemov.name,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [RFC 1/2] mm: additional page lock debugging
Date: Sat, 28 Dec 2013 20:45:03 -0500
Message-Id: <1388281504-11453-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.3.2
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've recently stumbled on several issues with the page lock which
triggered BUG_ON()s.

While working on them, it was clear that due to the complexity of
locking its pretty hard to figure out if something is supposed
to be locked or not, and if we encountered a race it was quite a
pain narrowing it down.

This is an attempt at solving this situation. This patch adds simple
asserts to catch cases where someone is trying to lock the page lock
while it's already locked, and cases to catch someone unlocking the
lock without it being held.

My initial patch attempted to use lockdep to get further coverege,
but that attempt uncovered the amount of issues triggered and made
it impossible to debug the lockdep integration without clearing out
a large portion of existing bugs.

This patch adds a new option since it will horribly break any system
booting with it due to the amount of issues that it uncovers. This is
more of a "call for help" to other mm/ hackers to help clean it up.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 include/linux/pagemap.h | 11 +++++++++++
 lib/Kconfig.debug       |  9 +++++++++
 mm/filemap.c            |  4 +++-
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 1710d1b..da24939 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -321,6 +321,14 @@ static inline pgoff_t linear_page_index(struct vm_area_struct *vma,
 	return pgoff >> (PAGE_CACHE_SHIFT - PAGE_SHIFT);
 }
 
+#ifdef CONFIG_DEBUG_VM_PAGE_LOCKS
+#define VM_ASSERT_LOCKED(page) VM_BUG_ON_PAGE(!PageLocked(page), (page))
+#define VM_ASSERT_UNLOCKED(page) VM_BUG_ON_PAGE(PageLocked(page), (page))
+#else
+#define VM_ASSERT_LOCKED(page) do { } while (0)
+#define VM_ASSERT_UNLOCKED(page) do { } while (0)
+#endif
+
 extern void __lock_page(struct page *page);
 extern int __lock_page_killable(struct page *page);
 extern int __lock_page_or_retry(struct page *page, struct mm_struct *mm,
@@ -329,16 +337,19 @@ extern void unlock_page(struct page *page);
 
 static inline void __set_page_locked(struct page *page)
 {
+	VM_ASSERT_UNLOCKED(page);
 	__set_bit(PG_locked, &page->flags);
 }
 
 static inline void __clear_page_locked(struct page *page)
 {
+	VM_ASSERT_LOCKED(page);
 	__clear_bit(PG_locked, &page->flags);
 }
 
 static inline int trylock_page(struct page *page)
 {
+	VM_ASSERT_UNLOCKED(page);
 	return (likely(!test_and_set_bit_lock(PG_locked, &page->flags)));
 }
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 48d32cd..ae4b60d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -510,6 +510,15 @@ config DEBUG_VM_RB
 
 	  If unsure, say N.
 
+config DEBUG_VM_PAGE_LOCKS
+	bool "Debug VM page locking"
+	depends on DEBUG_VM
+	help
+	  Debug page locking by catching double locks and double frees. These
+	  checks may impact performance.
+
+	  If unsure, say N.
+
 config DEBUG_VIRTUAL
 	bool "Debug VM translations"
 	depends on DEBUG_KERNEL && X86
diff --git a/mm/filemap.c b/mm/filemap.c
index 7a7f3e0..665addc 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -607,7 +607,7 @@ EXPORT_SYMBOL_GPL(add_page_wait_queue);
  */
 void unlock_page(struct page *page)
 {
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	VM_ASSERT_LOCKED(page);
 	clear_bit_unlock(PG_locked, &page->flags);
 	smp_mb__after_clear_bit();
 	wake_up_page(page, PG_locked);
@@ -639,6 +639,7 @@ void __lock_page(struct page *page)
 {
 	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
 
+	VM_ASSERT_UNLOCKED(page);
 	__wait_on_bit_lock(page_waitqueue(page), &wait, sleep_on_page,
 							TASK_UNINTERRUPTIBLE);
 }
@@ -648,6 +649,7 @@ int __lock_page_killable(struct page *page)
 {
 	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
 
+	VM_ASSERT_UNLOCKED(page);
 	return __wait_on_bit_lock(page_waitqueue(page), &wait,
 					sleep_on_page_killable, TASK_KILLABLE);
 }
-- 
1.8.3.2

