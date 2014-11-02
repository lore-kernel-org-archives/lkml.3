Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbaKBDwA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 23:52:00 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17136 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaKBDv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 23:51:57 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: eparis@redhat.com, john@johnmccutchan.com, rlove@rlove.org,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] fsnotify: don't call mutex_lock from TASK_INTERRUPTIBLE context
Date: Sat,  1 Nov 2014 23:51:38 -0400
Message-Id: <1414900298-7871-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sleeping functions should only be called from TASK_RUNNING. The following
code in fanotify_read():

	prepare_to_wait(&group->notification_waitq, &wait, TASK_INTERRUPTIBLE);

        mutex_lock(&group->notification_mutex);

would call it under TASK_INTERRUPTIBLE, and trigger a warning:

[12326.092094] WARNING: CPU: 27 PID: 30207 at kernel/sched/core.c:7305 __might_sleep+0xd2/0x110()
[12326.092878] do not call blocking ops when !TASK_RUNNING; state=1 set at prepare_to_wait (./arch/x86/include/asm/current.h:14 kernel/sched/wait.c:179)
[12326.093938] Modules linked in:
[12326.094261] CPU: 27 PID: 30207 Comm: fanotify01 Not tainted 3.18.0-rc2-next-20141031-sasha-00057-g9a0b11b-dirty #1435
[12326.095255]  0000000000000009 0000000000000000 ffff88003b563000 ffff88005bfbbc38
[12326.096019]  ffffffff90dabf13 0000000000000000 ffff88005bfbbc98 ffff88005bfbbc88
[12326.096791]  ffffffff8c1b12fa ffff88005bfbbc88 ffffffff8c1f6112 00000000001d76c0
[12326.097610] Call Trace:
[12326.097881] dump_stack (lib/dump_stack.c:52)
[12326.098383] warn_slowpath_common (kernel/panic.c:432)
[12326.098973] ? __might_sleep (kernel/sched/core.c:7311)
[12326.099512] ? prepare_to_wait (./arch/x86/include/asm/current.h:14 kernel/sched/wait.c:179)
[12326.100100] warn_slowpath_fmt (kernel/panic.c:446)
[12326.100704] ? check_chain_key (kernel/locking/lockdep.c:2190)
[12326.101319] ? prepare_to_wait (./arch/x86/include/asm/current.h:14 kernel/sched/wait.c:179)
[12326.101870] ? prepare_to_wait (./arch/x86/include/asm/current.h:14 kernel/sched/wait.c:179)
[12326.102421] __might_sleep (kernel/sched/core.c:7311)
[12326.102949] ? prepare_to_wait (./arch/x86/include/asm/current.h:14 kernel/sched/wait.c:179)
[12326.103502] ? prepare_to_wait (kernel/sched/wait.c:181)
[12326.104060] mutex_lock_nested (kernel/locking/mutex.c:623)
[12326.104620] ? preempt_count_sub (kernel/sched/core.c:2641)
[12326.105324] ? _raw_spin_unlock_irqrestore (./arch/x86/include/asm/preempt.h:95 include/linux/spinlock_api_smp.h:161 kernel/locking/spinlock.c:191)
[12326.105986] ? prepare_to_wait (kernel/sched/wait.c:181)
[12326.106542] fanotify_read (./arch/x86/include/asm/atomic.h:27 include/linux/mutex.h:131 fs/notify/fanotify/fanotify_user.c:57 fs/notify/fanotify/fanotify_user.c:273)
[12326.107070] ? abort_exclusive_wait (kernel/sched/wait.c:291)
[12326.107676] vfs_read (fs/read_write.c:430)
[12326.108169] SyS_read (fs/read_write.c:569 fs/read_write.c:562)
[12326.108652] tracesys_phase2 (arch/x86/kernel/entry_64.S:529)

Instead of trying to fix fanotify_read() I've converted notification_mutex
into a spinlock. I didn't see a reason why it should be a mutex nor anything
complained when I ran the same tests again.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 fs/notify/fanotify/fanotify_user.c |   18 +++++++++---------
 fs/notify/group.c                  |    2 +-
 fs/notify/inotify/inotify_user.c   |   16 ++++++++--------
 fs/notify/notification.c           |   22 +++++++++++-----------
 include/linux/fsnotify_backend.h   |    2 +-
 5 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index c991616..f03bffc 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -49,12 +49,12 @@ struct kmem_cache *fanotify_perm_event_cachep __read_mostly;
  * enough to fit in "count". Return an error pointer if the count
  * is not large enough.
  *
- * Called with the group->notification_mutex held.
+ * Called with the group->notification_lock held.
  */
 static struct fsnotify_event *get_one_event(struct fsnotify_group *group,
 					    size_t count)
 {
-	BUG_ON(!mutex_is_locked(&group->notification_mutex));
+	BUG_ON(!spin_is_locked(&group->notification_lock));
 
 	pr_debug("%s: group=%p count=%zd\n", __func__, group, count);
 
@@ -64,7 +64,7 @@ static struct fsnotify_event *get_one_event(struct fsnotify_group *group,
 	if (FAN_EVENT_METADATA_LEN > count)
 		return ERR_PTR(-EINVAL);
 
-	/* held the notification_mutex the whole time, so this is the
+	/* held the notification_lock the whole time, so this is the
 	 * same event we peeked above */
 	return fsnotify_remove_first_event(group);
 }
@@ -244,10 +244,10 @@ static unsigned int fanotify_poll(struct file *file, poll_table *wait)
 	int ret = 0;
 
 	poll_wait(file, &group->notification_waitq, wait);
-	mutex_lock(&group->notification_mutex);
+	spin_lock(&group->notification_lock);
 	if (!fsnotify_notify_queue_is_empty(group))
 		ret = POLLIN | POLLRDNORM;
-	mutex_unlock(&group->notification_mutex);
+	spin_unlock(&group->notification_lock);
 
 	return ret;
 }
@@ -269,9 +269,9 @@ static ssize_t fanotify_read(struct file *file, char __user *buf,
 	while (1) {
 		prepare_to_wait(&group->notification_waitq, &wait, TASK_INTERRUPTIBLE);
 
-		mutex_lock(&group->notification_mutex);
+		spin_lock(&group->notification_lock);
 		kevent = get_one_event(group, count);
-		mutex_unlock(&group->notification_mutex);
+		spin_unlock(&group->notification_lock);
 
 		if (IS_ERR(kevent)) {
 			ret = PTR_ERR(kevent);
@@ -408,10 +408,10 @@ static long fanotify_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 
 	switch (cmd) {
 	case FIONREAD:
-		mutex_lock(&group->notification_mutex);
+		spin_lock(&group->notification_lock);
 		list_for_each_entry(fsn_event, &group->notification_list, list)
 			send_len += FAN_EVENT_METADATA_LEN;
-		mutex_unlock(&group->notification_mutex);
+		spin_unlock(&group->notification_lock);
 		ret = put_user(send_len, (int __user *) p);
 		break;
 	}
diff --git a/fs/notify/group.c b/fs/notify/group.c
index d16b62c..758f7d5 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -97,7 +97,7 @@ struct fsnotify_group *fsnotify_alloc_group(const struct fsnotify_ops *ops)
 	atomic_set(&group->refcnt, 1);
 	atomic_set(&group->num_marks, 0);
 
-	mutex_init(&group->notification_mutex);
+	spin_lock_init(&group->notification_lock);
 	INIT_LIST_HEAD(&group->notification_list);
 	init_waitqueue_head(&group->notification_waitq);
 	group->max_events = UINT_MAX;
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 283aa31..b474fb3 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -115,10 +115,10 @@ static unsigned int inotify_poll(struct file *file, poll_table *wait)
 	int ret = 0;
 
 	poll_wait(file, &group->notification_waitq, wait);
-	mutex_lock(&group->notification_mutex);
+	spin_lock(&group->notification_lock);
 	if (!fsnotify_notify_queue_is_empty(group))
 		ret = POLLIN | POLLRDNORM;
-	mutex_unlock(&group->notification_mutex);
+	spin_unlock(&group->notification_lock);
 
 	return ret;
 }
@@ -138,7 +138,7 @@ static int round_event_name_len(struct fsnotify_event *fsn_event)
  * enough to fit in "count". Return an error pointer if
  * not large enough.
  *
- * Called with the group->notification_mutex held.
+ * Called with the group->notification_lock held.
  */
 static struct fsnotify_event *get_one_event(struct fsnotify_group *group,
 					    size_t count)
@@ -157,7 +157,7 @@ static struct fsnotify_event *get_one_event(struct fsnotify_group *group,
 	if (event_size > count)
 		return ERR_PTR(-EINVAL);
 
-	/* held the notification_mutex the whole time, so this is the
+	/* hold the notification_lock the whole time, so this is the
 	 * same event we peeked above */
 	fsnotify_remove_first_event(group);
 
@@ -234,9 +234,9 @@ static ssize_t inotify_read(struct file *file, char __user *buf,
 
 	add_wait_queue(&group->notification_waitq, &wait);
 	while (1) {
-		mutex_lock(&group->notification_mutex);
+		spin_lock(&group->notification_lock);
 		kevent = get_one_event(group, count);
-		mutex_unlock(&group->notification_mutex);
+		spin_unlock(&group->notification_lock);
 
 		pr_debug("%s: group=%p kevent=%p\n", __func__, group, kevent);
 
@@ -300,13 +300,13 @@ static long inotify_ioctl(struct file *file, unsigned int cmd,
 
 	switch (cmd) {
 	case FIONREAD:
-		mutex_lock(&group->notification_mutex);
+		spin_lock(&group->notification_lock);
 		list_for_each_entry(fsn_event, &group->notification_list,
 				    list) {
 			send_len += sizeof(struct inotify_event);
 			send_len += round_event_name_len(fsn_event);
 		}
-		mutex_unlock(&group->notification_mutex);
+		spin_unlock(&group->notification_lock);
 		ret = put_user(send_len, (int __user *) p);
 		break;
 	}
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index a95d8e0..3c2a0ff 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -63,7 +63,7 @@ EXPORT_SYMBOL_GPL(fsnotify_get_cookie);
 /* return true if the notify queue is empty, false otherwise */
 bool fsnotify_notify_queue_is_empty(struct fsnotify_group *group)
 {
-	BUG_ON(!mutex_is_locked(&group->notification_mutex));
+	BUG_ON(!spin_is_locked(&group->notification_lock));
 	return list_empty(&group->notification_list) ? true : false;
 }
 
@@ -94,13 +94,13 @@ int fsnotify_add_event(struct fsnotify_group *group,
 
 	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
 
-	mutex_lock(&group->notification_mutex);
+	spin_lock(&group->notification_lock);
 
 	if (group->q_len >= group->max_events) {
 		ret = 2;
 		/* Queue overflow event only if it isn't already queued */
 		if (!list_empty(&group->overflow_event->list)) {
-			mutex_unlock(&group->notification_mutex);
+			spin_unlock(&group->notification_lock);
 			return ret;
 		}
 		event = group->overflow_event;
@@ -110,7 +110,7 @@ int fsnotify_add_event(struct fsnotify_group *group,
 	if (!list_empty(list) && merge) {
 		ret = merge(list, event);
 		if (ret) {
-			mutex_unlock(&group->notification_mutex);
+			spin_unlock(&group->notification_lock);
 			return ret;
 		}
 	}
@@ -118,7 +118,7 @@ int fsnotify_add_event(struct fsnotify_group *group,
 queue:
 	group->q_len++;
 	list_add_tail(&event->list, list);
-	mutex_unlock(&group->notification_mutex);
+	spin_unlock(&group->notification_lock);
 
 	wake_up(&group->notification_waitq);
 	kill_fasync(&group->fsn_fa, SIGIO, POLL_IN);
@@ -132,12 +132,12 @@ queue:
 void fsnotify_remove_event(struct fsnotify_group *group,
 			   struct fsnotify_event *event)
 {
-	mutex_lock(&group->notification_mutex);
+	spin_lock(&group->notification_lock);
 	if (!list_empty(&event->list)) {
 		list_del_init(&event->list);
 		group->q_len--;
 	}
-	mutex_unlock(&group->notification_mutex);
+	spin_unlock(&group->notification_lock);
 }
 
 /*
@@ -148,7 +148,7 @@ struct fsnotify_event *fsnotify_remove_first_event(struct fsnotify_group *group)
 {
 	struct fsnotify_event *event;
 
-	BUG_ON(!mutex_is_locked(&group->notification_mutex));
+	BUG_ON(!spin_is_locked(&group->notification_lock));
 
 	pr_debug("%s: group=%p\n", __func__, group);
 
@@ -170,7 +170,7 @@ struct fsnotify_event *fsnotify_remove_first_event(struct fsnotify_group *group)
  */
 struct fsnotify_event *fsnotify_peek_first_event(struct fsnotify_group *group)
 {
-	BUG_ON(!mutex_is_locked(&group->notification_mutex));
+	BUG_ON(!spin_is_locked(&group->notification_lock));
 
 	return list_first_entry(&group->notification_list,
 				struct fsnotify_event, list);
@@ -184,12 +184,12 @@ void fsnotify_flush_notify(struct fsnotify_group *group)
 {
 	struct fsnotify_event *event;
 
-	mutex_lock(&group->notification_mutex);
+	spin_lock(&group->notification_lock);
 	while (!fsnotify_notify_queue_is_empty(group)) {
 		event = fsnotify_remove_first_event(group);
 		fsnotify_destroy_event(group, event);
 	}
-	mutex_unlock(&group->notification_mutex);
+	spin_unlock(&group->notification_lock);
 }
 
 /*
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index ca060d7..1c98ca9 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -137,7 +137,7 @@ struct fsnotify_group {
 	const struct fsnotify_ops *ops;	/* how this group handles things */
 
 	/* needed to send notification to userspace */
-	struct mutex notification_mutex;	/* protect the notification_list */
+	spinlock_t notification_lock;	/* protect the notification_list */
 	struct list_head notification_list;	/* list of event_holder this group needs to send to userspace */
 	wait_queue_head_t notification_waitq;	/* read() on the notification file blocks on this waitq */
 	unsigned int q_len;			/* events on the queue */
-- 
1.7.10.4

