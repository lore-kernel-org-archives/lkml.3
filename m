Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab3BRGNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 01:13:23 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:52929 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671Ab3BRGNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 01:13:21 -0500
Message-ID: <5121C647.7030608@huawei.com>
Date: Mon, 18 Feb 2013 14:12:23 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH v2] cgroup: fix cgroup_rmdir() vs close(eventfd) race
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 205a872bd6f9a9a09ef035ef1e90185a8245cc58 ("cgroup: fix lockdep
warning for event_control") solved a deadlock by introducing a new
bug.

Move cgrp->event_list to a temporary list doesn't mean you can traverse
this list locklessly, because at the same time cgroup_event_wake() can
be called and remove the event from the list. The result of this race
is disastrous.

We adopt the way how kvm irqfd code implements race-free event removal,
which is now described in the comments in cgroup_event_wake().

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 50 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 16 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 26c071c..65c8101 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -217,6 +217,10 @@ struct cgroup_event {
 	 */
 	struct list_head list;
 	/*
+	 * Need to notify userspace when this event is removed?
+	 */
+	bool signal_on_remove;
+	/*
 	 * All fields below needed to unregister event when
 	 * userspace closes eventfd.
 	 */
@@ -3833,8 +3837,17 @@ static void cgroup_event_remove(struct work_struct *work)
 			remove);
 	struct cgroup *cgrp = event->cgrp;
 
+	remove_wait_queue(event->wqh, &event->wait);
+
 	event->cft->unregister_event(cgrp, event->cft, event->eventfd);
 
+	/*
+	 * If this event is to be removed due to cgroup removal,
+	 * we notify userspace.
+	 */
+	if (event->signal_on_remove)
+		eventfd_signal(event->eventfd, 1);
+
 	eventfd_ctx_put(event->eventfd);
 	kfree(event);
 	dput(cgrp->dentry);
@@ -3854,15 +3867,25 @@ static int cgroup_event_wake(wait_queue_t *wait, unsigned mode,
 	unsigned long flags = (unsigned long)key;
 
 	if (flags & POLLHUP) {
-		__remove_wait_queue(event->wqh, &event->wait);
-		spin_lock(&cgrp->event_list_lock);
-		list_del_init(&event->list);
-		spin_unlock(&cgrp->event_list_lock);
 		/*
-		 * We are in atomic context, but cgroup_event_remove() may
-		 * sleep, so we have to call it in workqueue.
+		 * If the event has been detached at cgroup removal, we
+		 * can simply return knowing the other side will cleanup
+		 * for us.
+		 *
+		 * We can't race against event freeing since the other
+		 * side will require wqh->lock via remove_wait_queue(),
+		 * which we hold.
 		 */
-		schedule_work(&event->remove);
+		spin_lock(&cgrp->event_list_lock);
+		if (!list_empty(&event->list)) {
+			list_del_init(&event->list);
+			/*
+			 * We are in atomic context, but cgroup_event_remove()
+			 * may sleep, so we have to call it in workqueue.
+			 */
+			schedule_work(&event->remove);
+		}
+		spin_unlock(&cgrp->event_list_lock);
 	}
 
 	return 0;
@@ -4428,20 +4451,15 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	/*
 	 * Unregister events and notify userspace.
 	 * Notify userspace about cgroup removing only after rmdir of cgroup
-	 * directory to avoid race between userspace and kernelspace. Use
-	 * a temporary list to avoid a deadlock with cgroup_event_wake(). Since
-	 * cgroup_event_wake() is called with the wait queue head locked,
-	 * remove_wait_queue() cannot be called while holding event_list_lock.
+	 * directory to avoid race between userspace and kernelspace.
 	 */
 	spin_lock(&cgrp->event_list_lock);
-	list_splice_init(&cgrp->event_list, &tmp_list);
-	spin_unlock(&cgrp->event_list_lock);
-	list_for_each_entry_safe(event, tmp, &tmp_list, list) {
+	list_for_each_entry_safe(event, tmp, &cgrp->event_list, list) {
+		event->signal_on_remove = true;
 		list_del_init(&event->list);
-		remove_wait_queue(event->wqh, &event->wait);
-		eventfd_signal(event->eventfd, 1);
 		schedule_work(&event->remove);
 	}
+	spin_unlock(&cgrp->event_list_lock);
 
 	return 0;
 }
-- 
1.8.0.2
