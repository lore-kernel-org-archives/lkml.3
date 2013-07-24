Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab3GXOIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:08:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45781 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751861Ab3GXOHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:07:05 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ingo Molnar" <mingo@kernel.org>,
        "Paul Mackerras" <paulus@samba.org>,
        "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Vince Weaver" <vincent.weaver@maine.edu>,
        "Zhouping Liu" <zliu@redhat.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.761070563@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [78/85] perf: Fix perf mmap bugs
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

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

[Backporting for 3.4-stable.
VM_RESERVED flag was replaced with pair 'VM_DONTEXPAND | VM_DONTDUMP' in
314e51b9 since 3.7.0-rc1, and 314e51b9 comes from a big patchset, we didn't
backport the patchset, so I restored 'VM_DNOTEXPAND | VM_DONTDUMP' as before:
-       vma->vm_flags |= VM_DONTCOPY | VM_DONTEXPAND | VM_DONTDUMP;
+       vma->vm_flags |= VM_DONTCOPY | VM_RESERVED;
 -- zliu]

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/20130528085548.GA12193@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Zhouping Liu <zliu@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/perf_event.h |  3 +--
 kernel/events/core.c       | 37 ++++++++++++++++++++-----------------
 kernel/events/internal.h   |  3 +++
 3 files changed, 24 insertions(+), 19 deletions(-)

--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -819,8 +819,7 @@ struct perf_event {
 	/* mmap bits */
 	struct mutex			mmap_mutex;
 	atomic_t			mmap_count;
-	int				mmap_locked;
-	struct user_struct		*mmap_user;
+
 	struct ring_buffer		*rb;
 	struct list_head		rb_entry;
 
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2960,7 +2960,7 @@ static void free_event_rcu(struct rcu_he
 	kfree(event);
 }
 
-static void ring_buffer_put(struct ring_buffer *rb);
+static bool ring_buffer_put(struct ring_buffer *rb);
 
 static void free_event(struct perf_event *event)
 {
@@ -3621,13 +3621,13 @@ static struct ring_buffer *ring_buffer_g
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
@@ -3637,6 +3637,7 @@ static void ring_buffer_put(struct ring_
 	spin_unlock_irqrestore(&rb->event_lock, flags);
 
 	call_rcu(&rb->rcu_head, rb_free_rcu);
+	return true;
 }
 
 static void perf_mmap_open(struct vm_area_struct *vma)
@@ -3651,18 +3652,20 @@ static void perf_mmap_close(struct vm_ar
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
 
@@ -3715,9 +3718,7 @@ static int perf_mmap(struct file *file,
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
@@ -3759,19 +3760,21 @@ static int perf_mmap(struct file *file,
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
 
 unlock:
 	if (!ret)
 		atomic_inc(&event->mmap_count);
 	mutex_unlock(&event->mmap_mutex);
 
-	vma->vm_flags |= VM_RESERVED;
+	vma->vm_flags |= VM_DONTCOPY | VM_RESERVED;
 	vma->vm_ops = &perf_mmap_vmops;
 
 	return ret;
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -26,6 +26,9 @@ struct ring_buffer {
 	spinlock_t			event_lock;
 	struct list_head		event_list;
 
+	int				mmap_locked;
+	struct user_struct		*mmap_user;
+
 	struct perf_event_mmap_page	*user_page;
 	void				*data_pages[0];
 };

