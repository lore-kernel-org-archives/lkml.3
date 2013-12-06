Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab3LFPX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:23:58 -0500
Received: from mail1.windriver.com ([147.11.146.13]:38332 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3LFPXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:23:55 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 1/1] waitq: abstract out locking/unlocking waitq head operations
Date: Fri, 6 Dec 2013 10:19:22 -0500
Message-ID: <1386343162-53574-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <1386343162-53574-1-git-send-email-paul.gortmaker@windriver.com>
References: <1386343162-53574-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We abstract out the wait queue head locking operations.  This is done
in order to be able to add future functionality to them in a single
place.  As a side benefit, it happens to increase code readability.

We rename the wait queue lock entry to "__lock" which ensures that
anyone who tries to use the old wq->lock or wq.lock will fail, and
hence be forced into being aware of this change.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[Still needs build coverage testing on non-x86]

 drivers/gpu/drm/radeon/radeon_sa.c                 | 18 ++++-----
 drivers/iio/industrialio-event.c                   | 26 ++++++-------
 .../lustre/lustre/libcfs/linux/linux-prim.c        |  4 +-
 drivers/usb/gadget/f_fs.c                          | 42 ++++++++++-----------
 fs/eventfd.c                                       | 32 ++++++++--------
 fs/eventpoll.c                                     |  4 +-
 fs/nilfs2/segment.c                                |  4 +-
 fs/timerfd.c                                       | 26 ++++++-------
 include/linux/wait.h                               | 36 +++++++++++++++---
 kernel/sched/completion.c                          | 24 ++++++------
 kernel/sched/core.c                                |  8 ++--
 kernel/sched/wait.c                                | 44 +++++++++++-----------
 mm/filemap.c                                       |  4 +-
 net/sunrpc/sched.c                                 |  4 +-
 14 files changed, 150 insertions(+), 126 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_sa.c b/drivers/gpu/drm/radeon/radeon_sa.c
index f0bac68..b2d6701 100644
--- a/drivers/gpu/drm/radeon/radeon_sa.c
+++ b/drivers/gpu/drm/radeon/radeon_sa.c
@@ -330,7 +330,7 @@ int radeon_sa_bo_new(struct radeon_device *rdev,
 	INIT_LIST_HEAD(&(*sa_bo)->olist);
 	INIT_LIST_HEAD(&(*sa_bo)->flist);
 
-	spin_lock(&sa_manager->wq.lock);
+	waitq_lock(&sa_manager->wq);
 	do {
 		for (i = 0; i < RADEON_NUM_RINGS; ++i) {
 			fences[i] = NULL;
@@ -342,16 +342,16 @@ int radeon_sa_bo_new(struct radeon_device *rdev,
 
 			if (radeon_sa_bo_try_alloc(sa_manager, *sa_bo,
 						   size, align)) {
-				spin_unlock(&sa_manager->wq.lock);
+				waitq_unlock(&sa_manager->wq);
 				return 0;
 			}
 
 			/* see if we can skip over some allocations */
 		} while (radeon_sa_bo_next_hole(sa_manager, fences, tries));
 
-		spin_unlock(&sa_manager->wq.lock);
+		waitq_unlock(&sa_manager->wq);
 		r = radeon_fence_wait_any(rdev, fences, false);
-		spin_lock(&sa_manager->wq.lock);
+		waitq_lock(&sa_manager->wq);
 		/* if we have nothing to wait for block */
 		if (r == -ENOENT && block) {
 			r = wait_event_interruptible_locked(
@@ -365,7 +365,7 @@ int radeon_sa_bo_new(struct radeon_device *rdev,
 
 	} while (!r);
 
-	spin_unlock(&sa_manager->wq.lock);
+	waitq_unlock(&sa_manager->wq);
 	kfree(*sa_bo);
 	*sa_bo = NULL;
 	return r;
@@ -381,7 +381,7 @@ void radeon_sa_bo_free(struct radeon_device *rdev, struct radeon_sa_bo **sa_bo,
 	}
 
 	sa_manager = (*sa_bo)->manager;
-	spin_lock(&sa_manager->wq.lock);
+	waitq_lock(&sa_manager->wq);
 	if (fence && !radeon_fence_signaled(fence)) {
 		(*sa_bo)->fence = radeon_fence_ref(fence);
 		list_add_tail(&(*sa_bo)->flist,
@@ -390,7 +390,7 @@ void radeon_sa_bo_free(struct radeon_device *rdev, struct radeon_sa_bo **sa_bo,
 		radeon_sa_bo_remove_locked(*sa_bo);
 	}
 	wake_up_all_locked(&sa_manager->wq);
-	spin_unlock(&sa_manager->wq.lock);
+	waitq_unlock(&sa_manager->wq);
 	*sa_bo = NULL;
 }
 
@@ -400,7 +400,7 @@ void radeon_sa_bo_dump_debug_info(struct radeon_sa_manager *sa_manager,
 {
 	struct radeon_sa_bo *i;
 
-	spin_lock(&sa_manager->wq.lock);
+	waitq_lock(&sa_manager->wq);
 	list_for_each_entry(i, &sa_manager->olist, olist) {
 		if (&i->olist == sa_manager->hole) {
 			seq_printf(m, ">");
@@ -415,6 +415,6 @@ void radeon_sa_bo_dump_debug_info(struct radeon_sa_manager *sa_manager,
 		}
 		seq_printf(m, "\n");
 	}
-	spin_unlock(&sa_manager->wq.lock);
+	waitq_unlock(&sa_manager->wq);
 }
 #endif
diff --git a/drivers/iio/industrialio-event.c b/drivers/iio/industrialio-event.c
index c10eab6..2523fbb 100644
--- a/drivers/iio/industrialio-event.c
+++ b/drivers/iio/industrialio-event.c
@@ -50,7 +50,7 @@ int iio_push_event(struct iio_dev *indio_dev, u64 ev_code, s64 timestamp)
 	int copied;
 
 	/* Does anyone care? */
-	spin_lock_irqsave(&ev_int->wait.lock, flags);
+	waitq_lock_irqsave(&ev_int->wait, flags);
 	if (test_bit(IIO_BUSY_BIT_POS, &ev_int->flags)) {
 
 		ev.id = ev_code;
@@ -60,7 +60,7 @@ int iio_push_event(struct iio_dev *indio_dev, u64 ev_code, s64 timestamp)
 		if (copied != 0)
 			wake_up_locked_poll(&ev_int->wait, POLLIN);
 	}
-	spin_unlock_irqrestore(&ev_int->wait.lock, flags);
+	waitq_unlock_irqrestore(&ev_int->wait, flags);
 
 	return 0;
 }
@@ -81,10 +81,10 @@ static unsigned int iio_event_poll(struct file *filep,
 
 	poll_wait(filep, &ev_int->wait, wait);
 
-	spin_lock_irq(&ev_int->wait.lock);
+	waitq_lock_irq(&ev_int->wait);
 	if (!kfifo_is_empty(&ev_int->det_events))
 		events = POLLIN | POLLRDNORM;
-	spin_unlock_irq(&ev_int->wait.lock);
+	waitq_unlock_irq(&ev_int->wait);
 
 	return events;
 }
@@ -105,7 +105,7 @@ static ssize_t iio_event_chrdev_read(struct file *filep,
 	if (count < sizeof(struct iio_event_data))
 		return -EINVAL;
 
-	spin_lock_irq(&ev_int->wait.lock);
+	waitq_lock_irq(&ev_int->wait);
 	if (kfifo_is_empty(&ev_int->det_events)) {
 		if (filep->f_flags & O_NONBLOCK) {
 			ret = -EAGAIN;
@@ -127,7 +127,7 @@ static ssize_t iio_event_chrdev_read(struct file *filep,
 	ret = kfifo_to_user(&ev_int->det_events, buf, count, &copied);
 
 error_unlock:
-	spin_unlock_irq(&ev_int->wait.lock);
+	waitq_unlock_irq(&ev_int->wait);
 
 	return ret ? ret : copied;
 }
@@ -137,7 +137,7 @@ static int iio_event_chrdev_release(struct inode *inode, struct file *filep)
 	struct iio_dev *indio_dev = filep->private_data;
 	struct iio_event_interface *ev_int = indio_dev->event_interface;
 
-	spin_lock_irq(&ev_int->wait.lock);
+	waitq_lock_irq(&ev_int->wait);
 	__clear_bit(IIO_BUSY_BIT_POS, &ev_int->flags);
 	/*
 	 * In order to maintain a clean state for reopening,
@@ -145,7 +145,7 @@ static int iio_event_chrdev_release(struct inode *inode, struct file *filep)
 	 * any new __iio_push_event calls running.
 	 */
 	kfifo_reset_out(&ev_int->det_events);
-	spin_unlock_irq(&ev_int->wait.lock);
+	waitq_unlock_irq(&ev_int->wait);
 
 	iio_device_put(indio_dev);
 
@@ -168,20 +168,20 @@ int iio_event_getfd(struct iio_dev *indio_dev)
 	if (ev_int == NULL)
 		return -ENODEV;
 
-	spin_lock_irq(&ev_int->wait.lock);
+	waitq_lock_irq(&ev_int->wait);
 	if (__test_and_set_bit(IIO_BUSY_BIT_POS, &ev_int->flags)) {
-		spin_unlock_irq(&ev_int->wait.lock);
+		waitq_unlock_irq(&ev_int->wait);
 		return -EBUSY;
 	}
-	spin_unlock_irq(&ev_int->wait.lock);
+	waitq_unlock_irq(&ev_int->wait);
 	iio_device_get(indio_dev);
 
 	fd = anon_inode_getfd("iio:event", &iio_event_chrdev_fileops,
 				indio_dev, O_RDONLY | O_CLOEXEC);
 	if (fd < 0) {
-		spin_lock_irq(&ev_int->wait.lock);
+		waitq_lock_irq(&ev_int->wait);
 		__clear_bit(IIO_BUSY_BIT_POS, &ev_int->flags);
-		spin_unlock_irq(&ev_int->wait.lock);
+		waitq_unlock_irq(&ev_int->wait);
 		iio_device_put(indio_dev);
 	}
 	return fd;
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
index cc9829f..1794447 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
@@ -74,9 +74,9 @@ add_wait_queue_exclusive_head(wait_queue_head_t *waitq, wait_queue_t *link)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&LINUX_WAITQ_HEAD(waitq)->lock, flags);
+	waitq_lock_irqsave(LINUX_WAITQ_HEAD(waitq), flags);
 	__add_wait_queue_exclusive(LINUX_WAITQ_HEAD(waitq), LINUX_WAITQ(link));
-	spin_unlock_irqrestore(&LINUX_WAITQ_HEAD(waitq)->lock, flags);
+	waitq_unlock_irqrestore(LINUX_WAITQ_HEAD(waitq), flags);
 }
 EXPORT_SYMBOL(add_wait_queue_exclusive_head);
 
diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 774e8b8..4eee110 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -152,11 +152,11 @@ struct ffs_data {
 
 	/*
 	 * Possible transitions:
-	 * + FFS_NO_SETUP       -> FFS_SETUP_PENDING  -- P: ev.waitq.lock
+	 * + FFS_NO_SETUP       -> FFS_SETUP_PENDING  -- P: ev.waitq locked
 	 *               happens only in ep0 read which is P: mutex
-	 * + FFS_SETUP_PENDING  -> FFS_NO_SETUP       -- P: ev.waitq.lock
+	 * + FFS_SETUP_PENDING  -> FFS_NO_SETUP       -- P: ev.waitq locked
 	 *               happens only in ep0 i/o  which is P: mutex
-	 * + FFS_SETUP_PENDING  -> FFS_SETUP_CANCELED -- P: ev.waitq.lock
+	 * + FFS_SETUP_PENDING  -> FFS_SETUP_CANCELED -- P: ev.waitq locked
 	 * + FFS_SETUP_CANCELED -> FFS_NO_SETUP       -- cmpxchg
 	 */
 	enum ffs_setup_state		setup_state;
@@ -174,7 +174,7 @@ struct ffs_data {
 		struct usb_ctrlrequest		setup;
 
 		wait_queue_head_t		waitq;
-	} ev; /* the whole structure, P: ev.waitq.lock */
+	} ev; /* the whole structure, P: ev.waitq locked */
 
 	/* Flags */
 	unsigned long			flags;
@@ -360,7 +360,7 @@ static int __ffs_ep0_queue_wait(struct ffs_data *ffs, char *data, size_t len)
 
 	req->zero     = len < le16_to_cpu(ffs->ev.setup.wLength);
 
-	spin_unlock_irq(&ffs->ev.waitq.lock);
+	waitq_unlock_irq(&ffs->ev.waitq);
 
 	req->buf      = data;
 	req->length   = len;
@@ -477,7 +477,7 @@ static ssize_t ffs_ep0_write(struct file *file, const char __user *buf,
 		 * We're called from user space, we can use _irq
 		 * rather then _irqsave
 		 */
-		spin_lock_irq(&ffs->ev.waitq.lock);
+		waitq_lock_irq(&ffs->ev.waitq);
 		switch (FFS_SETUP_STATE(ffs)) {
 		case FFS_SETUP_CANCELED:
 			ret = -EIDRM;
@@ -493,7 +493,7 @@ static ssize_t ffs_ep0_write(struct file *file, const char __user *buf,
 
 		/* FFS_SETUP_PENDING */
 		if (!(ffs->ev.setup.bRequestType & USB_DIR_IN)) {
-			spin_unlock_irq(&ffs->ev.waitq.lock);
+			waitq_unlock_irq(&ffs->ev.waitq);
 			ret = __ffs_ep0_stall(ffs);
 			break;
 		}
@@ -501,7 +501,7 @@ static ssize_t ffs_ep0_write(struct file *file, const char __user *buf,
 		/* FFS_SETUP_PENDING and not stall */
 		len = min(len, (size_t)le16_to_cpu(ffs->ev.setup.wLength));
 
-		spin_unlock_irq(&ffs->ev.waitq.lock);
+		waitq_unlock_irq(&ffs->ev.waitq);
 
 		data = ffs_prepare_buffer(buf, len);
 		if (IS_ERR(data)) {
@@ -509,7 +509,7 @@ static ssize_t ffs_ep0_write(struct file *file, const char __user *buf,
 			break;
 		}
 
-		spin_lock_irq(&ffs->ev.waitq.lock);
+		waitq_lock_irq(&ffs->ev.waitq);
 
 		/*
 		 * We are guaranteed to be still in FFS_ACTIVE state
@@ -526,7 +526,7 @@ static ssize_t ffs_ep0_write(struct file *file, const char __user *buf,
 		if (FFS_SETUP_STATE(ffs) == FFS_SETUP_CANCELED) {
 			ret = -EIDRM;
 done_spin:
-			spin_unlock_irq(&ffs->ev.waitq.lock);
+			waitq_unlock_irq(&ffs->ev.waitq);
 		} else {
 			/* unlocks spinlock */
 			ret = __ffs_ep0_queue_wait(ffs, data, len);
@@ -547,7 +547,7 @@ static ssize_t __ffs_ep0_read_events(struct ffs_data *ffs, char __user *buf,
 				     size_t n)
 {
 	/*
-	 * We are holding ffs->ev.waitq.lock and ffs->mutex and we need
+	 * We are holding ffs->ev.waitq's lock and ffs->mutex and we need
 	 * to release them.
 	 */
 	struct usb_functionfs_event events[n];
@@ -571,7 +571,7 @@ static ssize_t __ffs_ep0_read_events(struct ffs_data *ffs, char __user *buf,
 		ffs->ev.count = 0;
 	}
 
-	spin_unlock_irq(&ffs->ev.waitq.lock);
+	waitq_unlock_irq(&ffs->ev.waitq);
 	mutex_unlock(&ffs->mutex);
 
 	return unlikely(__copy_to_user(buf, events, sizeof events))
@@ -607,7 +607,7 @@ static ssize_t ffs_ep0_read(struct file *file, char __user *buf,
 	 * We're called from user space, we can use _irq rather then
 	 * _irqsave
 	 */
-	spin_lock_irq(&ffs->ev.waitq.lock);
+	waitq_lock_irq(&ffs->ev.waitq);
 
 	switch (FFS_SETUP_STATE(ffs)) {
 	case FFS_SETUP_CANCELED:
@@ -637,14 +637,14 @@ static ssize_t ffs_ep0_read(struct file *file, char __user *buf,
 
 	case FFS_SETUP_PENDING:
 		if (ffs->ev.setup.bRequestType & USB_DIR_IN) {
-			spin_unlock_irq(&ffs->ev.waitq.lock);
+			waitq_unlock_irq(&ffs->ev.waitq);
 			ret = __ffs_ep0_stall(ffs);
 			goto done_mutex;
 		}
 
 		len = min(len, (size_t)le16_to_cpu(ffs->ev.setup.wLength));
 
-		spin_unlock_irq(&ffs->ev.waitq.lock);
+		waitq_unlock_irq(&ffs->ev.waitq);
 
 		if (likely(len)) {
 			data = kmalloc(len, GFP_KERNEL);
@@ -654,7 +654,7 @@ static ssize_t ffs_ep0_read(struct file *file, char __user *buf,
 			}
 		}
 
-		spin_lock_irq(&ffs->ev.waitq.lock);
+		waitq_lock_irq(&ffs->ev.waitq);
 
 		/* See ffs_ep0_write() */
 		if (FFS_SETUP_STATE(ffs) == FFS_SETUP_CANCELED) {
@@ -673,7 +673,7 @@ static ssize_t ffs_ep0_read(struct file *file, char __user *buf,
 		break;
 	}
 
-	spin_unlock_irq(&ffs->ev.waitq.lock);
+	waitq_unlock_irq(&ffs->ev.waitq);
 done_mutex:
 	mutex_unlock(&ffs->mutex);
 	kfree(data);
@@ -2058,9 +2058,9 @@ static void ffs_event_add(struct ffs_data *ffs,
 			  enum usb_functionfs_event_type type)
 {
 	unsigned long flags;
-	spin_lock_irqsave(&ffs->ev.waitq.lock, flags);
+	waitq_lock_irqsave(&ffs->ev.waitq, flags);
 	__ffs_event_add(ffs, type);
-	spin_unlock_irqrestore(&ffs->ev.waitq.lock, flags);
+	waitq_unlock_irqrestore(&ffs->ev.waitq, flags);
 }
 
 
@@ -2384,11 +2384,11 @@ static int ffs_func_setup(struct usb_function *f,
 		return -EOPNOTSUPP;
 	}
 
-	spin_lock_irqsave(&ffs->ev.waitq.lock, flags);
+	waitq_lock_irqsave(&ffs->ev.waitq, flags);
 	ffs->ev.setup = *creq;
 	ffs->ev.setup.wIndex = cpu_to_le16(ret);
 	__ffs_event_add(ffs, FUNCTIONFS_SETUP);
-	spin_unlock_irqrestore(&ffs->ev.waitq.lock, flags);
+	waitq_unlock_irqrestore(&ffs->ev.waitq, flags);
 
 	return 0;
 }
diff --git a/fs/eventfd.c b/fs/eventfd.c
index 35470d9..2888013 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -55,13 +55,13 @@ __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&ctx->wqh.lock, flags);
+	waitq_lock_irqsave(&ctx->wqh, flags);
 	if (ULLONG_MAX - ctx->count < n)
 		n = ULLONG_MAX - ctx->count;
 	ctx->count += n;
 	if (waitqueue_active(&ctx->wqh))
 		wake_up_locked_poll(&ctx->wqh, POLLIN);
-	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
+	waitq_unlock_irqrestore(&ctx->wqh, flags);
 
 	return n;
 }
@@ -122,14 +122,14 @@ static unsigned int eventfd_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &ctx->wqh, wait);
 
-	spin_lock_irqsave(&ctx->wqh.lock, flags);
+	waitq_lock_irqsave(&ctx->wqh, flags);
 	if (ctx->count > 0)
 		events |= POLLIN;
 	if (ctx->count == ULLONG_MAX)
 		events |= POLLERR;
 	if (ULLONG_MAX - 1 > ctx->count)
 		events |= POLLOUT;
-	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
+	waitq_unlock_irqrestore(&ctx->wqh, flags);
 
 	return events;
 }
@@ -158,12 +158,12 @@ int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_t *wait,
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&ctx->wqh.lock, flags);
+	waitq_lock_irqsave(&ctx->wqh, flags);
 	eventfd_ctx_do_read(ctx, cnt);
 	__remove_wait_queue(&ctx->wqh, wait);
 	if (*cnt != 0 && waitqueue_active(&ctx->wqh))
 		wake_up_locked_poll(&ctx->wqh, POLLOUT);
-	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
+	waitq_unlock_irqrestore(&ctx->wqh, flags);
 
 	return *cnt != 0 ? 0 : -EAGAIN;
 }
@@ -188,7 +188,7 @@ ssize_t eventfd_ctx_read(struct eventfd_ctx *ctx, int no_wait, __u64 *cnt)
 	ssize_t res;
 	DECLARE_WAITQUEUE(wait, current);
 
-	spin_lock_irq(&ctx->wqh.lock);
+	waitq_lock_irq(&ctx->wqh);
 	*cnt = 0;
 	res = -EAGAIN;
 	if (ctx->count > 0)
@@ -205,9 +205,9 @@ ssize_t eventfd_ctx_read(struct eventfd_ctx *ctx, int no_wait, __u64 *cnt)
 				res = -ERESTARTSYS;
 				break;
 			}
-			spin_unlock_irq(&ctx->wqh.lock);
+			waitq_unlock_irq(&ctx->wqh);
 			schedule();
-			spin_lock_irq(&ctx->wqh.lock);
+			waitq_lock_irq(&ctx->wqh);
 		}
 		__remove_wait_queue(&ctx->wqh, &wait);
 		__set_current_state(TASK_RUNNING);
@@ -217,7 +217,7 @@ ssize_t eventfd_ctx_read(struct eventfd_ctx *ctx, int no_wait, __u64 *cnt)
 		if (waitqueue_active(&ctx->wqh))
 			wake_up_locked_poll(&ctx->wqh, POLLOUT);
 	}
-	spin_unlock_irq(&ctx->wqh.lock);
+	waitq_unlock_irq(&ctx->wqh);
 
 	return res;
 }
@@ -253,7 +253,7 @@ static ssize_t eventfd_write(struct file *file, const char __user *buf, size_t c
 		return -EFAULT;
 	if (ucnt == ULLONG_MAX)
 		return -EINVAL;
-	spin_lock_irq(&ctx->wqh.lock);
+	waitq_lock_irq(&ctx->wqh);
 	res = -EAGAIN;
 	if (ULLONG_MAX - ctx->count > ucnt)
 		res = sizeof(ucnt);
@@ -269,9 +269,9 @@ static ssize_t eventfd_write(struct file *file, const char __user *buf, size_t c
 				res = -ERESTARTSYS;
 				break;
 			}
-			spin_unlock_irq(&ctx->wqh.lock);
+			waitq_unlock_irq(&ctx->wqh);
 			schedule();
-			spin_lock_irq(&ctx->wqh.lock);
+			waitq_lock_irq(&ctx->wqh);
 		}
 		__remove_wait_queue(&ctx->wqh, &wait);
 		__set_current_state(TASK_RUNNING);
@@ -281,7 +281,7 @@ static ssize_t eventfd_write(struct file *file, const char __user *buf, size_t c
 		if (waitqueue_active(&ctx->wqh))
 			wake_up_locked_poll(&ctx->wqh, POLLIN);
 	}
-	spin_unlock_irq(&ctx->wqh.lock);
+	waitq_unlock_irq(&ctx->wqh);
 
 	return res;
 }
@@ -292,10 +292,10 @@ static int eventfd_show_fdinfo(struct seq_file *m, struct file *f)
 	struct eventfd_ctx *ctx = f->private_data;
 	int ret;
 
-	spin_lock_irq(&ctx->wqh.lock);
+	waitq_lock_irq(&ctx->wqh);
 	ret = seq_printf(m, "eventfd-count: %16llx\n",
 			 (unsigned long long)ctx->count);
-	spin_unlock_irq(&ctx->wqh.lock);
+	waitq_unlock_irq(&ctx->wqh);
 
 	return ret;
 }
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 8b5e258..17594db 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -474,9 +474,9 @@ static inline void ep_wake_up_nested(wait_queue_head_t *wqueue,
 {
 	unsigned long flags;
 
-	spin_lock_irqsave_nested(&wqueue->lock, flags, subclass);
+	waitq_lock_irqsave_nested(wqueue, flags, subclass);
 	wake_up_locked_poll(wqueue, events);
-	spin_unlock_irqrestore(&wqueue->lock, flags);
+	waitq_unlock_irqrestore(wqueue, flags);
 }
 #else
 static inline void ep_wake_up_nested(wait_queue_head_t *wqueue,
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 9f6b486..7560a36 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2106,7 +2106,7 @@ static void nilfs_segctor_wakeup(struct nilfs_sc_info *sci, int err)
 	struct nilfs_segctor_wait_request *wrq, *n;
 	unsigned long flags;
 
-	spin_lock_irqsave(&sci->sc_wait_request.lock, flags);
+	waitq_lock_irqsave(&sci->sc_wait_request, flags);
 	list_for_each_entry_safe(wrq, n, &sci->sc_wait_request.task_list,
 				 wq.task_list) {
 		if (!atomic_read(&wrq->done) &&
@@ -2120,7 +2120,7 @@ static void nilfs_segctor_wakeup(struct nilfs_sc_info *sci, int err)
 				     0, NULL);
 		}
 	}
-	spin_unlock_irqrestore(&sci->sc_wait_request.lock, flags);
+	waitq_unlock_irqrestore(&sci->sc_wait_request, flags);
 }
 
 /**
diff --git a/fs/timerfd.c b/fs/timerfd.c
index 9293121..16791b2 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -60,11 +60,11 @@ static void timerfd_triggered(struct timerfd_ctx *ctx)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&ctx->wqh.lock, flags);
+	waitq_lock_irqsave(&ctx->wqh, flags);
 	ctx->expired = 1;
 	ctx->ticks++;
 	wake_up_locked(&ctx->wqh);
-	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
+	waitq_unlock_irqrestore(&ctx->wqh, flags);
 }
 
 static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
@@ -100,13 +100,13 @@ void timerfd_clock_was_set(void)
 	list_for_each_entry_rcu(ctx, &cancel_list, clist) {
 		if (!ctx->might_cancel)
 			continue;
-		spin_lock_irqsave(&ctx->wqh.lock, flags);
+		waitq_lock_irqsave(&ctx->wqh, flags);
 		if (ctx->moffs.tv64 != moffs.tv64) {
 			ctx->moffs.tv64 = KTIME_MAX;
 			ctx->ticks++;
 			wake_up_locked(&ctx->wqh);
 		}
-		spin_unlock_irqrestore(&ctx->wqh.lock, flags);
+		waitq_unlock_irqrestore(&ctx->wqh, flags);
 	}
 	rcu_read_unlock();
 }
@@ -221,10 +221,10 @@ static unsigned int timerfd_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &ctx->wqh, wait);
 
-	spin_lock_irqsave(&ctx->wqh.lock, flags);
+	waitq_lock_irqsave(&ctx->wqh, flags);
 	if (ctx->ticks)
 		events |= POLLIN;
-	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
+	waitq_unlock_irqrestore(&ctx->wqh, flags);
 
 	return events;
 }
@@ -238,7 +238,7 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
 
 	if (count < sizeof(ticks))
 		return -EINVAL;
-	spin_lock_irq(&ctx->wqh.lock);
+	waitq_lock_irq(&ctx->wqh);
 	if (file->f_flags & O_NONBLOCK)
 		res = -EAGAIN;
 	else
@@ -278,7 +278,7 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
 		ctx->expired = 0;
 		ctx->ticks = 0;
 	}
-	spin_unlock_irq(&ctx->wqh.lock);
+	waitq_unlock_irq(&ctx->wqh);
 	if (ticks)
 		res = put_user(ticks, (u64 __user *) buf) ? -EFAULT: sizeof(ticks);
 	return res;
@@ -370,7 +370,7 @@ static int do_timerfd_settime(int ufd, int flags,
 	 * it to the new values.
 	 */
 	for (;;) {
-		spin_lock_irq(&ctx->wqh.lock);
+		waitq_lock_irq(&ctx->wqh);
 
 		if (isalarm(ctx)) {
 			if (alarm_try_to_cancel(&ctx->t.alarm) >= 0)
@@ -379,7 +379,7 @@ static int do_timerfd_settime(int ufd, int flags,
 			if (hrtimer_try_to_cancel(&ctx->t.tmr) >= 0)
 				break;
 		}
-		spin_unlock_irq(&ctx->wqh.lock);
+		waitq_unlock_irq(&ctx->wqh);
 		cpu_relax();
 	}
 
@@ -404,7 +404,7 @@ static int do_timerfd_settime(int ufd, int flags,
 	 */
 	ret = timerfd_setup(ctx, flags, new);
 
-	spin_unlock_irq(&ctx->wqh.lock);
+	waitq_unlock_irq(&ctx->wqh);
 	fdput(f);
 	return ret;
 }
@@ -418,7 +418,7 @@ static int do_timerfd_gettime(int ufd, struct itimerspec *t)
 		return ret;
 	ctx = f.file->private_data;
 
-	spin_lock_irq(&ctx->wqh.lock);
+	waitq_lock_irq(&ctx->wqh);
 	if (ctx->expired && ctx->tintv.tv64) {
 		ctx->expired = 0;
 
@@ -436,7 +436,7 @@ static int do_timerfd_gettime(int ufd, struct itimerspec *t)
 	}
 	t->it_value = ktime_to_timespec(timerfd_get_remaining(ctx));
 	t->it_interval = ktime_to_timespec(ctx->tintv);
-	spin_unlock_irq(&ctx->wqh.lock);
+	waitq_unlock_irq(&ctx->wqh);
 	fdput(f);
 	return 0;
 }
diff --git a/include/linux/wait.h b/include/linux/wait.h
index eaa00b1..bc45ddb 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -33,11 +33,35 @@ struct wait_bit_queue {
 };
 
 struct __wait_queue_head {
-	spinlock_t		lock;
+	spinlock_t		__lock;		/* Use wrapper for access */
 	struct list_head	task_list;
 };
 typedef struct __wait_queue_head wait_queue_head_t;
 
+#define waitq_lock_irqsave_nested(qh, f, sc)				\
+	spin_lock_irqsave_nested(&(qh)->__lock, f, sc)
+
+#define waitq_lock_irqsave(qh, f)					\
+	spin_lock_irqsave(&(qh)->__lock, f)
+
+#define waitq_unlock_irqrestore(qh, f)					\
+	spin_unlock_irqrestore(&(qh)->__lock, f)
+
+#define waitq_lock_irq(qh)						\
+	spin_lock_irq(&(qh)->__lock)
+
+#define waitq_unlock_irq(qh)						\
+	spin_unlock_irq(&(qh)->__lock)
+
+#define waitq_lock(qh)							\
+	spin_lock(&(qh)->__lock)
+
+#define waitq_unlock(qh)						\
+	spin_unlock(&(qh)->__lock)
+
+#define waitq_lock_init(qh)						\
+	spin_lock_init(&(qh)->__lock)
+
 struct task_struct;
 
 /*
@@ -53,7 +77,7 @@ struct task_struct;
 	wait_queue_t name = __WAITQUEUE_INITIALIZER(name, tsk)
 
 #define __WAIT_QUEUE_HEAD_INITIALIZER(name) {				\
-	.lock		= __SPIN_LOCK_UNLOCKED(name.lock),		\
+	.__lock		= __SPIN_LOCK_UNLOCKED(name.__lock),		\
 	.task_list	= { &(name).task_list, &(name).task_list } }
 
 #define DECLARE_WAIT_QUEUE_HEAD(name) \
@@ -465,14 +489,14 @@ do {									\
 			break;						\
 		}							\
 		if (irq)						\
-			spin_unlock_irq(&(wq).lock);			\
+			waitq_unlock_irq(&(wq));			\
 		else							\
-			spin_unlock(&(wq).lock);			\
+			waitq_unlock(&(wq));				\
 		schedule();						\
 		if (irq)						\
-			spin_lock_irq(&(wq).lock);			\
+			waitq_lock_irq(&(wq));				\
 		else							\
-			spin_lock(&(wq).lock);				\
+			waitq_lock(&(wq));				\
 	} while (!(condition));						\
 	__remove_wait_queue(&(wq), &__wait);				\
 	__set_current_state(TASK_RUNNING);				\
diff --git a/kernel/sched/completion.c b/kernel/sched/completion.c
index a63f4dc..6d174f5 100644
--- a/kernel/sched/completion.c
+++ b/kernel/sched/completion.c
@@ -30,10 +30,10 @@ void complete(struct completion *x)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&x->wait.lock, flags);
+	waitq_lock_irqsave(&x->wait, flags);
 	x->done++;
 	__wake_up_locked(&x->wait, TASK_NORMAL, 1);
-	spin_unlock_irqrestore(&x->wait.lock, flags);
+	waitq_unlock_irqrestore(&x->wait, flags);
 }
 EXPORT_SYMBOL(complete);
 
@@ -50,10 +50,10 @@ void complete_all(struct completion *x)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&x->wait.lock, flags);
+	waitq_lock_irqsave(&x->wait, flags);
 	x->done += UINT_MAX/2;
 	__wake_up_locked(&x->wait, TASK_NORMAL, 0);
-	spin_unlock_irqrestore(&x->wait.lock, flags);
+	waitq_unlock_irqrestore(&x->wait, flags);
 }
 EXPORT_SYMBOL(complete_all);
 
@@ -71,9 +71,9 @@ do_wait_for_common(struct completion *x,
 				break;
 			}
 			__set_current_state(state);
-			spin_unlock_irq(&x->wait.lock);
+			waitq_unlock_irq(&x->wait);
 			timeout = action(timeout);
-			spin_lock_irq(&x->wait.lock);
+			waitq_lock_irq(&x->wait);
 		} while (!x->done && timeout);
 		__remove_wait_queue(&x->wait, &wait);
 		if (!x->done)
@@ -89,9 +89,9 @@ __wait_for_common(struct completion *x,
 {
 	might_sleep();
 
-	spin_lock_irq(&x->wait.lock);
+	waitq_lock_irq(&x->wait);
 	timeout = do_wait_for_common(x, action, timeout, state);
-	spin_unlock_irq(&x->wait.lock);
+	waitq_unlock_irq(&x->wait);
 	return timeout;
 }
 
@@ -267,12 +267,12 @@ bool try_wait_for_completion(struct completion *x)
 	unsigned long flags;
 	int ret = 1;
 
-	spin_lock_irqsave(&x->wait.lock, flags);
+	waitq_lock_irqsave(&x->wait, flags);
 	if (!x->done)
 		ret = 0;
 	else
 		x->done--;
-	spin_unlock_irqrestore(&x->wait.lock, flags);
+	waitq_unlock_irqrestore(&x->wait, flags);
 	return ret;
 }
 EXPORT_SYMBOL(try_wait_for_completion);
@@ -290,10 +290,10 @@ bool completion_done(struct completion *x)
 	unsigned long flags;
 	int ret = 1;
 
-	spin_lock_irqsave(&x->wait.lock, flags);
+	waitq_lock_irqsave(&x->wait, flags);
 	if (!x->done)
 		ret = 0;
-	spin_unlock_irqrestore(&x->wait.lock, flags);
+	waitq_unlock_irqrestore(&x->wait, flags);
 	return ret;
 }
 EXPORT_SYMBOL(completion_done);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e85cda2..c826ae6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2711,13 +2711,13 @@ sleep_on_common(wait_queue_head_t *q, int state, long timeout)
 
 	__set_current_state(state);
 
-	spin_lock_irqsave(&q->lock, flags);
+	waitq_lock_irqsave(q, flags);
 	__add_wait_queue(q, &wait);
-	spin_unlock(&q->lock);
+	waitq_unlock(q);
 	timeout = schedule_timeout(timeout);
-	spin_lock_irq(&q->lock);
+	waitq_lock_irq(q);
 	__remove_wait_queue(q, &wait);
-	spin_unlock_irqrestore(&q->lock, flags);
+	waitq_unlock_irqrestore(q, flags);
 
 	return timeout;
 }
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 7d50f79..b5cac50 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -12,8 +12,8 @@
 
 void __init_waitqueue_head(wait_queue_head_t *q, const char *name, struct lock_class_key *key)
 {
-	spin_lock_init(&q->lock);
-	lockdep_set_class_and_name(&q->lock, key, name);
+	waitq_lock_init(q);
+	lockdep_set_class_and_name(&q->__lock, key, name);
 	INIT_LIST_HEAD(&q->task_list);
 }
 
@@ -24,9 +24,9 @@ void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
 	unsigned long flags;
 
 	wait->flags &= ~WQ_FLAG_EXCLUSIVE;
-	spin_lock_irqsave(&q->lock, flags);
+	waitq_lock_irqsave(q, flags);
 	__add_wait_queue(q, wait);
-	spin_unlock_irqrestore(&q->lock, flags);
+	waitq_unlock_irqrestore(q, flags);
 }
 EXPORT_SYMBOL(add_wait_queue);
 
@@ -35,9 +35,9 @@ void add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
 	unsigned long flags;
 
 	wait->flags |= WQ_FLAG_EXCLUSIVE;
-	spin_lock_irqsave(&q->lock, flags);
+	waitq_lock_irqsave(q, flags);
 	__add_wait_queue_tail(q, wait);
-	spin_unlock_irqrestore(&q->lock, flags);
+	waitq_unlock_irqrestore(q, flags);
 }
 EXPORT_SYMBOL(add_wait_queue_exclusive);
 
@@ -45,9 +45,9 @@ void remove_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&q->lock, flags);
+	waitq_lock_irqsave(q, flags);
 	__remove_wait_queue(q, wait);
-	spin_unlock_irqrestore(&q->lock, flags);
+	waitq_unlock_irqrestore(q, flags);
 }
 EXPORT_SYMBOL(remove_wait_queue);
 
@@ -90,9 +90,9 @@ void __wake_up(wait_queue_head_t *q, unsigned int mode,
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&q->lock, flags);
+	waitq_lock_irqsave(q, flags);
 	__wake_up_common(q, mode, nr_exclusive, 0, key);
-	spin_unlock_irqrestore(&q->lock, flags);
+	waitq_unlock_irqrestore(q, flags);
 }
 EXPORT_SYMBOL(__wake_up);
 
@@ -140,9 +140,9 @@ void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode,
 	if (unlikely(nr_exclusive != 1))
 		wake_flags = 0;
 
-	spin_lock_irqsave(&q->lock, flags);
+	waitq_lock_irqsave(q, flags);
 	__wake_up_common(q, mode, nr_exclusive, wake_flags, key);
-	spin_unlock_irqrestore(&q->lock, flags);
+	waitq_unlock_irqrestore(q, flags);
 }
 EXPORT_SYMBOL_GPL(__wake_up_sync_key);
 
@@ -173,11 +173,11 @@ prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state)
 	unsigned long flags;
 
 	wait->flags &= ~WQ_FLAG_EXCLUSIVE;
-	spin_lock_irqsave(&q->lock, flags);
+	waitq_lock_irqsave(q, flags);
 	if (list_empty(&wait->task_list))
 		__add_wait_queue(q, wait);
 	set_current_state(state);
-	spin_unlock_irqrestore(&q->lock, flags);
+	waitq_unlock_irqrestore(q, flags);
 }
 EXPORT_SYMBOL(prepare_to_wait);
 
@@ -187,11 +187,11 @@ prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state)
 	unsigned long flags;
 
 	wait->flags |= WQ_FLAG_EXCLUSIVE;
-	spin_lock_irqsave(&q->lock, flags);
+	waitq_lock_irqsave(q, flags);
 	if (list_empty(&wait->task_list))
 		__add_wait_queue_tail(q, wait);
 	set_current_state(state);
-	spin_unlock_irqrestore(&q->lock, flags);
+	waitq_unlock_irqrestore(q, flags);
 }
 EXPORT_SYMBOL(prepare_to_wait_exclusive);
 
@@ -205,7 +205,7 @@ long prepare_to_wait_event(wait_queue_head_t *q, wait_queue_t *wait, int state)
 	wait->private = current;
 	wait->func = autoremove_wake_function;
 
-	spin_lock_irqsave(&q->lock, flags);
+	waitq_lock_irqsave(q, flags);
 	if (list_empty(&wait->task_list)) {
 		if (wait->flags & WQ_FLAG_EXCLUSIVE)
 			__add_wait_queue_tail(q, wait);
@@ -213,7 +213,7 @@ long prepare_to_wait_event(wait_queue_head_t *q, wait_queue_t *wait, int state)
 			__add_wait_queue(q, wait);
 	}
 	set_current_state(state);
-	spin_unlock_irqrestore(&q->lock, flags);
+	waitq_unlock_irqrestore(q, flags);
 
 	return 0;
 }
@@ -247,9 +247,9 @@ void finish_wait(wait_queue_head_t *q, wait_queue_t *wait)
 	 *    the list).
 	 */
 	if (!list_empty_careful(&wait->task_list)) {
-		spin_lock_irqsave(&q->lock, flags);
+		waitq_lock_irqsave(q, flags);
 		list_del_init(&wait->task_list);
-		spin_unlock_irqrestore(&q->lock, flags);
+		waitq_unlock_irqrestore(q, flags);
 	}
 }
 EXPORT_SYMBOL(finish_wait);
@@ -278,12 +278,12 @@ void abort_exclusive_wait(wait_queue_head_t *q, wait_queue_t *wait,
 	unsigned long flags;
 
 	__set_current_state(TASK_RUNNING);
-	spin_lock_irqsave(&q->lock, flags);
+	waitq_lock_irqsave(q, flags);
 	if (!list_empty(&wait->task_list))
 		list_del_init(&wait->task_list);
 	else if (waitqueue_active(q))
 		__wake_up_locked_key(q, mode, key);
-	spin_unlock_irqrestore(&q->lock, flags);
+	waitq_unlock_irqrestore(q, flags);
 }
 EXPORT_SYMBOL(abort_exclusive_wait);
 
diff --git a/mm/filemap.c b/mm/filemap.c
index b7749a9..ba9ef44 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -587,9 +587,9 @@ void add_page_wait_queue(struct page *page, wait_queue_t *waiter)
 	wait_queue_head_t *q = page_waitqueue(page);
 	unsigned long flags;
 
-	spin_lock_irqsave(&q->lock, flags);
+	waitq_lock_irqsave(q, flags);
 	__add_wait_queue(q, waiter);
-	spin_unlock_irqrestore(&q->lock, flags);
+	waitq_unlock_irqrestore(q, flags);
 }
 EXPORT_SYMBOL_GPL(add_page_wait_queue);
 
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index ff3cc4b..79120be 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -293,12 +293,12 @@ static int rpc_complete_task(struct rpc_task *task)
 
 	trace_rpc_task_complete(task->tk_client, task, NULL);
 
-	spin_lock_irqsave(&wq->lock, flags);
+	waitq_lock_irqsave(wq, flags);
 	clear_bit(RPC_TASK_ACTIVE, &task->tk_runstate);
 	ret = atomic_dec_and_test(&task->tk_count);
 	if (waitqueue_active(wq))
 		__wake_up_locked_key(wq, TASK_NORMAL, &k);
-	spin_unlock_irqrestore(&wq->lock, flags);
+	waitq_unlock_irqrestore(wq, flags);
 	return ret;
 }
 
-- 
1.8.5.rc3

