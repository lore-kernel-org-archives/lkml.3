Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949Ab3E1ERI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 00:17:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52553 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758922Ab3E1Dyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:31 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Robin Holt" <holt@sgi.com>,
        "Xiao Guangrong" <xiaoguangrong@linux.vnet.ibm.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.897650264@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [61/94] mm: mmu_notifier: re-fix freed page still mapped in
 secondary MMU
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: hlist_for_each_entry_rcu() still requires the
 struct hlist_node pointer]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/mmu_notifier.c |   79 ++++++++++++++++++++++++++---------------------------
 1 file changed, 39 insertions(+), 40 deletions(-)

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
@@ -302,31 +299,34 @@ void mmu_notifier_unregister(struct mmu_
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
 

