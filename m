Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab3FDREj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:04:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48621 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758637Ab3FDRDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:03:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 47/75] mm: mmu_notifier: re-fix freed page still mapped in secondary MMU
Date: Tue,  4 Jun 2013 09:55:31 -0700
Message-Id: <1370364959-9475-48-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

commit d34883d4e35c0a994e91dd847a82b4c9e0c31d83 upstream.

Commit 751efd8610d3 ("mmu_notifier_unregister NULL Pointer deref and
multiple ->release()") breaks the fix 3ad3d901bbcf ("mm: mmu_notifier:
fix freed page still mapped in secondary MMU").

Since hlist_for_each_entry_rcu() is changed now, we can not revert that
patch directly, so this patch reverts the commit and simply fix the bug
spotted by that patch

This bug spotted by commit 751efd8610d3 is:

    There is a race condition between mmu_notifier_unregister() and
    __mmu_notifier_release().

    Assume two tasks, one calling mmu_notifier_unregister() as a result
    of a filp_close() ->flush() callout (task A), and the other calling
    mmu_notifier_release() from an mmput() (task B).

                        A                               B
    t1                                            srcu_read_lock()
    t2            if (!hlist_unhashed())
    t3                                            srcu_read_unlock()
    t4            srcu_read_lock()
    t5                                            hlist_del_init_rcu()
    t6                                            synchronize_srcu()
    t7            srcu_read_unlock()
    t8            hlist_del_rcu()  <--- NULL pointer deref.

This can be fixed by using hlist_del_init_rcu instead of hlist_del_rcu.

The another issue spotted in the commit is "multiple ->release()
callouts", we needn't care it too much because it is really rare (e.g,
can not happen on kvm since mmu-notify is unregistered after
exit_mmap()) and the later call of multiple ->release should be fast
since all the pages have already been released by the first call.
Anyway, this issue should be fixed in a separate patch.

-stable suggestions: Any version that has commit 751efd8610d3 need to be
backported.  I find the oldest version has this commit is 3.0-stable.

[akpm@linux-foundation.org: tweak comments]
Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Tested-by: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/mmu_notifier.c | 80 +++++++++++++++++++++++++++----------------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index f5c3d96..2bf268d 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -37,51 +37,48 @@ static struct srcu_struct srcu;
 void __mmu_notifier_release(struct mm_struct *mm)
 {
 	struct mmu_notifier *mn;
+	struct hlist_node *n;
 	int id;
 
 	/*
-	 * srcu_read_lock() here will block synchronize_srcu() in
-	 * mmu_notifier_unregister() until all registered
-	 * ->release() callouts this function makes have
-	 * returned.
+	 * SRCU here will block mmu_notifier_unregister until
+	 * ->release returns.
 	 */
 	id = srcu_read_lock(&srcu);
+	hlist_for_each_entry_rcu(mn, n, &mm->mmu_notifier_mm->list, hlist)
+		/*
+		 * If ->release runs before mmu_notifier_unregister it must be
+		 * handled, as it's the only way for the driver to flush all
+		 * existing sptes and stop the driver from establishing any more
+		 * sptes before all the pages in the mm are freed.
+		 */
+		if (mn->ops->release)
+			mn->ops->release(mn, mm);
+	srcu_read_unlock(&srcu, id);
+
 	spin_lock(&mm->mmu_notifier_mm->lock);
 	while (unlikely(!hlist_empty(&mm->mmu_notifier_mm->list))) {
 		mn = hlist_entry(mm->mmu_notifier_mm->list.first,
 				 struct mmu_notifier,
 				 hlist);
-
 		/*
-		 * Unlink.  This will prevent mmu_notifier_unregister()
-		 * from also making the ->release() callout.
+		 * We arrived before mmu_notifier_unregister so
+		 * mmu_notifier_unregister will do nothing other than to wait
+		 * for ->release to finish and for mmu_notifier_unregister to
+		 * return.
 		 */
 		hlist_del_init_rcu(&mn->hlist);
-		spin_unlock(&mm->mmu_notifier_mm->lock);
-
-		/*
-		 * Clear sptes. (see 'release' description in mmu_notifier.h)
-		 */
-		if (mn->ops->release)
-			mn->ops->release(mn, mm);
-
-		spin_lock(&mm->mmu_notifier_mm->lock);
 	}
 	spin_unlock(&mm->mmu_notifier_mm->lock);
 
 	/*
-	 * All callouts to ->release() which we have done are complete.
-	 * Allow synchronize_srcu() in mmu_notifier_unregister() to complete
-	 */
-	srcu_read_unlock(&srcu, id);
-
-	/*
-	 * mmu_notifier_unregister() may have unlinked a notifier and may
-	 * still be calling out to it.	Additionally, other notifiers
-	 * may have been active via vmtruncate() et. al. Block here
-	 * to ensure that all notifier callouts for this mm have been
-	 * completed and the sptes are really cleaned up before returning
-	 * to exit_mmap().
+	 * synchronize_srcu here prevents mmu_notifier_release from returning to
+	 * exit_mmap (which would proceed with freeing all pages in the mm)
+	 * until the ->release method returns, if it was invoked by
+	 * mmu_notifier_unregister.
+	 *
+	 * The mmu_notifier_mm can't go away from under us because one mm_count
+	 * is held by exit_mmap.
 	 */
 	synchronize_srcu(&srcu);
 }
@@ -296,31 +293,34 @@ void mmu_notifier_unregister(struct mmu_notifier *mn, struct mm_struct *mm)
 {
 	BUG_ON(atomic_read(&mm->mm_count) <= 0);
 
-	spin_lock(&mm->mmu_notifier_mm->lock);
 	if (!hlist_unhashed(&mn->hlist)) {
+		/*
+		 * SRCU here will force exit_mmap to wait for ->release to
+		 * finish before freeing the pages.
+		 */
 		int id;
 
+		id = srcu_read_lock(&srcu);
 		/*
-		 * Ensure we synchronize up with __mmu_notifier_release().
+		 * exit_mmap will block in mmu_notifier_release to guarantee
+		 * that ->release is called before freeing the pages.
 		 */
-		id = srcu_read_lock(&srcu);
-
-		hlist_del_rcu(&mn->hlist);
-		spin_unlock(&mm->mmu_notifier_mm->lock);
-
 		if (mn->ops->release)
 			mn->ops->release(mn, mm);
+		srcu_read_unlock(&srcu, id);
 
+		spin_lock(&mm->mmu_notifier_mm->lock);
 		/*
-		 * Allow __mmu_notifier_release() to complete.
+		 * Can not use list_del_rcu() since __mmu_notifier_release
+		 * can delete it before we hold the lock.
 		 */
-		srcu_read_unlock(&srcu, id);
-	} else
+		hlist_del_init_rcu(&mn->hlist);
 		spin_unlock(&mm->mmu_notifier_mm->lock);
+	}
 
 	/*
-	 * Wait for any running method to finish, including ->release() if it
-	 * was run by __mmu_notifier_release() instead of us.
+	 * Wait for any running method to finish, of course including
+	 * ->release if it was run by mmu_notifier_relase instead of us.
 	 */
 	synchronize_srcu(&srcu);
 
-- 
1.8.1.2

