Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbaG3J2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 05:28:35 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:57751 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaG3J2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 05:28:33 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        =?UTF-8?q?J=C3=B6rn=20Engel?= <joern@logfs.org>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Davidlohr Bueso <davidlohr@hp.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Graf <agraf@suse.de>,
        Michael Ellerman <michael@ellerman.id.au>
Subject: [RFC PATCH] mm: Add helpers for locked_vm
Date: Wed, 30 Jul 2014 19:28:13 +1000
Message-Id: <1406712493-9284-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073009-3568-0000-0000-000005FC6226
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds 2 helpers to change the locked_vm counter:
- try_increase_locked_vm - may fail if new locked_vm value will be greater
than the RLIMIT_MEMLOCK limit;
- decrease_locked_vm.

These will be used by drivers capable of locking memory by userspace
request. For example, VFIO can use it to check if it can lock DMA memory
or PPC-KVM can use it to check if it can lock memory for TCE tables.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 include/linux/mm.h |  3 +++
 mm/mlock.c         | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index e03dd29..1cb219d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2113,5 +2113,8 @@ void __init setup_nr_node_ids(void);
 static inline void setup_nr_node_ids(void) {}
 #endif
 
+extern long try_increment_locked_vm(long npages);
+extern void decrement_locked_vm(long npages);
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff --git a/mm/mlock.c b/mm/mlock.c
index b1eb536..39e4b55 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -864,3 +864,52 @@ void user_shm_unlock(size_t size, struct user_struct *user)
 	spin_unlock(&shmlock_user_lock);
 	free_uid(user);
 }
+
+/**
+ * try_increment_locked_vm() - checks if new locked_vm value is going to
+ * be less than RLIMIT_MEMLOCK and increments it by npages if it is.
+ *
+ * @npages: the number of pages to add to locked_vm.
+ *
+ * Returns 0 if succeeded or negative value if failed.
+ */
+long try_increment_locked_vm(long npages)
+{
+	long ret = 0, locked, lock_limit;
+
+	if (!current || !current->mm)
+		return -ESRCH; /* process exited */
+
+	down_write(&current->mm->mmap_sem);
+	locked = current->mm->locked_vm + npages;
+	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+	if (locked > lock_limit && !capable(CAP_IPC_LOCK)) {
+		pr_warn("RLIMIT_MEMLOCK (%ld) exceeded\n",
+				rlimit(RLIMIT_MEMLOCK));
+		ret = -ENOMEM;
+	} else {
+		current->mm->locked_vm += npages;
+	}
+	up_write(&current->mm->mmap_sem);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(try_increment_locked_vm);
+
+/**
+ * decrement_locked_vm() - decrements the current task's locked_vm counter.
+ *
+ * @npages: the number to decrement by.
+ */
+void decrement_locked_vm(long npages)
+{
+	if (!current || !current->mm)
+		return; /* process exited */
+
+	down_write(&current->mm->mmap_sem);
+	if (npages > current->mm->locked_vm)
+		npages = current->mm->locked_vm;
+	current->mm->locked_vm -= npages;
+	up_write(&current->mm->mmap_sem);
+}
+EXPORT_SYMBOL_GPL(decrement_locked_vm);
-- 
2.0.0

