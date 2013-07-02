Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab3GBLJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:09:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36400 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab3GBLJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:09:12 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Zijlstra <peterz@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Zhouping Liu <zliu@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 49/50] perf: Fix perf mmap bugs
Date: Tue,  2 Jul 2013 12:07:37 +0100
Message-Id: <1372763258-20664-50-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 26cb63ad11e04047a64309362674bcbbd6a6f246 upstream.

Vince reported a problem found by his perf specific trinity
fuzzer.

Al noticed 2 problems with perf's mmap():

 - it has issues against fork() since we use vma->vm_mm for accounting.
 - it has an rb refcount leak on double mmap().

We fix the issues against fork() by using VM_DONTCOPY; I don't
think there's code out there that uses this; we didn't hear
about weird accounting problems/crashes. If we do need this to
work, the previously proposed VM_PINNED could make this work.

Aside from the rb reference leak spotted by Al, Vince's example
prog was indeed doing a double mmap() through the use of
perf_event_set_output().

This exposes another problem, since we now have 2 events with
one buffer, the accounting gets screwy because we account per
event. Fix this by making the buffer responsible for its own
accounting.

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/20130528085548.GA12193@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Zhouping Liu <zliu@redhat.com>
[ luis: backported to 3.5 using zliu suggestion for the 3.4 backport:
  - use 'VM_RESERVED' instead of 'VM_DONTEXPAND | VM_DONTDUMP' pair
    ('VM_RESERVED' was replaced in 314e51b9 since 3.7.0-rc1)          ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/perf_event.h |  3 +--
 kernel/events/core.c       | 37 ++++++++++++++++++++-----------------
 kernel/events/internal.h   |  3 +++
 3 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c145c45..c65c7d1 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -952,8 +952,7 @@ struct perf_event {
 	/* mmap bits */
 	struct mutex			mmap_mutex;
 	atomic_t			mmap_count;
-	int				mmap_locked;
-	struct user_struct		*mmap_user;
+
 	struct ring_buffer		*rb;
 	struct list_head		rb_entry;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1a6deb7..e758be0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2852,7 +2852,7 @@ static void free_event_rcu(struct rcu_head *head)
 	kfree(event);
 }
 
-static void ring_buffer_put(struct ring_buffer *rb);
+static bool ring_buffer_put(struct ring_buffer *rb);
 
 static void free_event(struct perf_event *event)
 {
@@ -3523,13 +3523,13 @@ static struct ring_buffer *ring_buffer_get(struct perf_event *event)
 	return rb;
 }
 
-static void ring_buffer_put(struct ring_buffer *rb)
+static bool ring_buffer_put(struct ring_buffer *rb)
 {
 	struct perf_event *event, *n;
 	unsigned long flags;
 
 	if (!atomic_dec_and_test(&rb->refcount))
-		return;
+		return false;
 
 	spin_lock_irqsave(&rb->event_lock, flags);
 	list_for_each_entry_safe(event, n, &rb->event_list, rb_entry) {
@@ -3539,6 +3539,7 @@ static void ring_buffer_put(struct ring_buffer *rb)
 	spin_unlock_irqrestore(&rb->event_lock, flags);
 
 	call_rcu(&rb->rcu_head, rb_free_rcu);
+	return true;
 }
 
 static void perf_mmap_open(struct vm_area_struct *vma)
@@ -3553,18 +3554,20 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 	struct perf_event *event = vma->vm_file->private_data;
 
 	if (atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex)) {
-		unsigned long size = perf_data_size(event->rb);
-		struct user_struct *user = event->mmap_user;
 		struct ring_buffer *rb = event->rb;
+		struct user_struct *mmap_user = rb->mmap_user;
+		int mmap_locked = rb->mmap_locked;
+		unsigned long size = perf_data_size(rb);
 
-		atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);
-		vma->vm_mm->pinned_vm -= event->mmap_locked;
 		rcu_assign_pointer(event->rb, NULL);
 		ring_buffer_detach(event, rb);
 		mutex_unlock(&event->mmap_mutex);
 
-		ring_buffer_put(rb);
-		free_uid(user);
+		if (ring_buffer_put(rb)) {
+			atomic_long_sub((size >> PAGE_SHIFT) + 1, &mmap_user->locked_vm);
+			vma->vm_mm->pinned_vm -= mmap_locked;
+			free_uid(mmap_user);
+		}
 	}
 }
 
@@ -3617,9 +3620,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	WARN_ON_ONCE(event->ctx->parent_ctx);
 	mutex_lock(&event->mmap_mutex);
 	if (event->rb) {
-		if (event->rb->nr_pages == nr_pages)
-			atomic_inc(&event->rb->refcount);
-		else
+		if (event->rb->nr_pages != nr_pages)
 			ret = -EINVAL;
 		goto unlock;
 	}
@@ -3661,12 +3662,14 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		ret = -ENOMEM;
 		goto unlock;
 	}
-	rcu_assign_pointer(event->rb, rb);
+
+	rb->mmap_locked = extra;
+	rb->mmap_user = get_current_user();
 
 	atomic_long_add(user_extra, &user->locked_vm);
-	event->mmap_locked = extra;
-	event->mmap_user = get_current_user();
-	vma->vm_mm->pinned_vm += event->mmap_locked;
+	vma->vm_mm->pinned_vm += extra;
+
+	rcu_assign_pointer(event->rb, rb);
 
 	perf_event_update_userpage(event);
 
@@ -3675,7 +3678,7 @@ unlock:
 		atomic_inc(&event->mmap_count);
 	mutex_unlock(&event->mmap_mutex);
 
-	vma->vm_flags |= VM_RESERVED;
+	vma->vm_flags |= VM_DONTCOPY | VM_RESERVED;
 	vma->vm_ops = &perf_mmap_vmops;
 
 	return ret;
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index b0b107f..04a14cc 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -30,6 +30,9 @@ struct ring_buffer {
 	spinlock_t			event_lock;
 	struct list_head		event_list;
 
+	int				mmap_locked;
+	struct user_struct		*mmap_user;
+
 	struct perf_event_mmap_page	*user_page;
 	void				*data_pages[0];
 };
-- 
1.8.1.2

