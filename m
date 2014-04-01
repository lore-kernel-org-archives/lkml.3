Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaDASzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 14:55:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34912 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaDASy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 14:54:28 -0400
Date: Tue, 1 Apr 2014 11:53:20 -0700
Message-Id: <201404011853.s31IrKFr025301@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] compat time conversion changes for v3.15
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Cc: akpm@linux-foundation.org, aquini@redhat.com, arnd@arndb.de,
        catalin.marinas@arm.com, dan.carpenter@oracle.com, davidlohr@hp.com,
        hans.verkuil@cisco.com, heiko.carstens@de.ibm.com, hjl.tools@gmail.com,
        hpa@linux.intel.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        m.chehab@samsung.com, manfred@colorfullife.com, mguzik@redhat.com,
        mingo@kernel.org, sfr@canb.auug.org.au, tglx@linutronix.de,
        torvalds@linux-foundation.org, toyoa@mvista.com,
        viro@zeniv.linux.org.uk, will.deacon@arm.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Despite the branch name this is really neither an x86 nor an
x32-specific patchset, although it the implementation of the
discussions that followed the x32 security hole a few months ago.

This removes get/put_compat_timespec/val() and replaces them with
compat_get/put_timespec/val() which are savvy as to the current status
of COMPAT_USE_64BIT_TIME.

It removes several unused and/or incorrect/misleading functions (like
compat_put_timeval_convert which doesn't in fact do any conversion)
and also replaces several open-coded implementations what is now
called compat_convert_timespec() with that function.

The following changes since commit 5cb480f6b488128140c940abff3c36f524a334a8:

  Merge branch 'misc' of git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild (2014-02-01 11:03:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-x32-for-linus

for you to fetch changes up to dce44e03b0a3448ad11ac6c6e0cbe299e0400791:

  compat: Fix sparse address space warnings (2014-02-02 18:00:29 -0800)

----------------------------------------------------------------
H. Peter Anvin (2):
      compat: Get rid of (get|put)_compat_time(val|spec)
      compat: Fix sparse address space warnings

 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |   2 +-
 fs/compat.c                                   |   6 +-
 include/linux/compat.h                        |  23 +++---
 ipc/compat.c                                  |  12 +--
 ipc/compat_mq.c                               |  19 +----
 kernel/compat.c                               | 112 +++++++++++++-------------
 kernel/futex_compat.c                         |   2 +-
 7 files changed, 77 insertions(+), 99 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 8f7a6a4..6191968 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -733,7 +733,7 @@ static int put_v4l2_event32(struct v4l2_event *kp, struct v4l2_event32 __user *u
 		copy_to_user(&up->u, &kp->u, sizeof(kp->u)) ||
 		put_user(kp->pending, &up->pending) ||
 		put_user(kp->sequence, &up->sequence) ||
-		put_compat_timespec(&kp->timestamp, &up->timestamp) ||
+		compat_put_timespec(&kp->timestamp, &up->timestamp) ||
 		put_user(kp->id, &up->id) ||
 		copy_to_user(up->reserved, kp->reserved, 8 * sizeof(__u32)))
 			return -EFAULT;
diff --git a/fs/compat.c b/fs/compat.c
index 6af20de..62092f4 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -92,8 +92,8 @@ asmlinkage long compat_sys_utimensat(unsigned int dfd, const char __user *filena
 	struct timespec tv[2];
 
 	if  (t) {
-		if (get_compat_timespec(&tv[0], &t[0]) ||
-		    get_compat_timespec(&tv[1], &t[1]))
+		if (compat_get_timespec(&tv[0], &t[0]) ||
+		    compat_get_timespec(&tv[1], &t[1]))
 			return -EFAULT;
 
 		if (tv[0].tv_nsec == UTIME_OMIT && tv[1].tv_nsec == UTIME_OMIT)
@@ -512,7 +512,7 @@ compat_sys_io_getevents(aio_context_t ctx_id,
 				nr * sizeof(struct io_event))))
 		goto out;
 	if (timeout) {
-		if (get_compat_timespec(&t, timeout))
+		if (compat_get_timespec(&t, timeout))
 			goto out;
 
 		ut = compat_alloc_user_space(sizeof(*ut));
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 3f448c6..f7d5bc0 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -141,26 +141,23 @@ struct compat_sigaction {
 };
 
 /*
- * These functions operate strictly on struct compat_time*
- */
-extern int get_compat_timespec(struct timespec *,
-			       const struct compat_timespec __user *);
-extern int put_compat_timespec(const struct timespec *,
-			       struct compat_timespec __user *);
-extern int get_compat_timeval(struct timeval *,
-			      const struct compat_timeval __user *);
-extern int put_compat_timeval(const struct timeval *,
-			      struct compat_timeval __user *);
-/*
  * These functions operate on 32- or 64-bit specs depending on
- * COMPAT_USE_64BIT_TIME, hence the void user pointer arguments and the
- * naming as compat_get/put_ rather than get/put_compat_.
+ * COMPAT_USE_64BIT_TIME, hence the void user pointer arguments.
  */
 extern int compat_get_timespec(struct timespec *, const void __user *);
 extern int compat_put_timespec(const struct timespec *, void __user *);
 extern int compat_get_timeval(struct timeval *, const void __user *);
 extern int compat_put_timeval(const struct timeval *, void __user *);
 
+/*
+ * This function convert a timespec if necessary and returns a *user
+ * space* pointer.  If no conversion is necessary, it returns the
+ * initial pointer.  NULL is a legitimate argument and will always
+ * output NULL.
+ */
+extern int compat_convert_timespec(struct timespec __user **,
+				   const void __user *);
+
 struct compat_iovec {
 	compat_uptr_t	iov_base;
 	compat_size_t	iov_len;
diff --git a/ipc/compat.c b/ipc/compat.c
index f486b00..1048522 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -752,14 +752,8 @@ long compat_sys_shmctl(int first, int second, void __user *uptr)
 long compat_sys_semtimedop(int semid, struct sembuf __user *tsems,
 		unsigned nsops, const struct compat_timespec __user *timeout)
 {
-	struct timespec __user *ts64 = NULL;
-	if (timeout) {
-		struct timespec ts;
-		ts64 = compat_alloc_user_space(sizeof(*ts64));
-		if (get_compat_timespec(&ts, timeout))
-			return -EFAULT;
-		if (copy_to_user(ts64, &ts, sizeof(ts)))
-			return -EFAULT;
-	}
+	struct timespec __user *ts64;
+	if (compat_convert_timespec(&ts64, timeout))
+		return -EFAULT;
 	return sys_semtimedop(semid, tsems, nsops, ts64);
 }
diff --git a/ipc/compat_mq.c b/ipc/compat_mq.c
index 63d7c6de..a9cf163 100644
--- a/ipc/compat_mq.c
+++ b/ipc/compat_mq.c
@@ -64,20 +64,6 @@ asmlinkage long compat_sys_mq_open(const char __user *u_name,
 	return sys_mq_open(u_name, oflag, mode, p);
 }
 
-static int compat_prepare_timeout(struct timespec __user **p,
-				  const struct compat_timespec __user *u)
-{
-	struct timespec ts;
-	if (!u) {
-		*p = NULL;
-		return 0;
-	}
-	*p = compat_alloc_user_space(sizeof(ts));
-	if (get_compat_timespec(&ts, u) || copy_to_user(*p, &ts, sizeof(ts)))
-		return -EFAULT;
-	return 0;
-}
-
 asmlinkage long compat_sys_mq_timedsend(mqd_t mqdes,
 			const char __user *u_msg_ptr,
 			size_t msg_len, unsigned int msg_prio,
@@ -85,7 +71,7 @@ asmlinkage long compat_sys_mq_timedsend(mqd_t mqdes,
 {
 	struct timespec __user *u_ts;
 
-	if (compat_prepare_timeout(&u_ts, u_abs_timeout))
+	if (compat_convert_timespec(&u_ts, u_abs_timeout))
 		return -EFAULT;
 
 	return sys_mq_timedsend(mqdes, u_msg_ptr, msg_len,
@@ -98,7 +84,8 @@ asmlinkage ssize_t compat_sys_mq_timedreceive(mqd_t mqdes,
 			const struct compat_timespec __user *u_abs_timeout)
 {
 	struct timespec __user *u_ts;
-	if (compat_prepare_timeout(&u_ts, u_abs_timeout))
+
+	if (compat_convert_timespec(&u_ts, u_abs_timeout))
 		return -EFAULT;
 
 	return sys_mq_timedreceive(mqdes, u_msg_ptr, msg_len,
diff --git a/kernel/compat.c b/kernel/compat.c
index 0a09e48..7076b57 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -30,28 +30,6 @@
 
 #include <asm/uaccess.h>
 
-/*
- * Get/set struct timeval with struct timespec on the native side
- */
-static int compat_get_timeval_convert(struct timespec *o,
-				      struct compat_timeval __user *i)
-{
-	long usec;
-
-	if (get_user(o->tv_sec, &i->tv_sec) ||
-	    get_user(usec, &i->tv_usec))
-		return -EFAULT;
-	o->tv_nsec = usec * 1000;
-	return 0;
-}
-
-static int compat_put_timeval_convert(struct compat_timeval __user *o,
-				      struct timeval *i)
-{
-	return (put_user(i->tv_sec, &o->tv_sec) ||
-		put_user(i->tv_usec, &o->tv_usec)) ? -EFAULT : 0;
-}
-
 static int compat_get_timex(struct timex *txc, struct compat_timex __user *utp)
 {
 	memset(txc, 0, sizeof(struct timex));
@@ -116,7 +94,7 @@ asmlinkage long compat_sys_gettimeofday(struct compat_timeval __user *tv,
 	if (tv) {
 		struct timeval ktv;
 		do_gettimeofday(&ktv);
-		if (compat_put_timeval_convert(tv, &ktv))
+		if (compat_put_timeval(&ktv, tv))
 			return -EFAULT;
 	}
 	if (tz) {
@@ -130,59 +108,58 @@ asmlinkage long compat_sys_gettimeofday(struct compat_timeval __user *tv,
 asmlinkage long compat_sys_settimeofday(struct compat_timeval __user *tv,
 		struct timezone __user *tz)
 {
-	struct timespec kts;
-	struct timezone ktz;
+	struct timeval user_tv;
+	struct timespec	new_ts;
+	struct timezone new_tz;
 
 	if (tv) {
-		if (compat_get_timeval_convert(&kts, tv))
+		if (compat_get_timeval(&user_tv, tv))
 			return -EFAULT;
+		new_ts.tv_sec = user_tv.tv_sec;
+		new_ts.tv_nsec = user_tv.tv_usec * NSEC_PER_USEC;
 	}
 	if (tz) {
-		if (copy_from_user(&ktz, tz, sizeof(ktz)))
+		if (copy_from_user(&new_tz, tz, sizeof(*tz)))
 			return -EFAULT;
 	}
 
-	return do_sys_settimeofday(tv ? &kts : NULL, tz ? &ktz : NULL);
+	return do_sys_settimeofday(tv ? &new_ts : NULL, tz ? &new_tz : NULL);
 }
 
-int get_compat_timeval(struct timeval *tv, const struct compat_timeval __user *ctv)
+static int __compat_get_timeval(struct timeval *tv, const struct compat_timeval __user *ctv)
 {
 	return (!access_ok(VERIFY_READ, ctv, sizeof(*ctv)) ||
 			__get_user(tv->tv_sec, &ctv->tv_sec) ||
 			__get_user(tv->tv_usec, &ctv->tv_usec)) ? -EFAULT : 0;
 }
-EXPORT_SYMBOL_GPL(get_compat_timeval);
 
-int put_compat_timeval(const struct timeval *tv, struct compat_timeval __user *ctv)
+static int __compat_put_timeval(const struct timeval *tv, struct compat_timeval __user *ctv)
 {
 	return (!access_ok(VERIFY_WRITE, ctv, sizeof(*ctv)) ||
 			__put_user(tv->tv_sec, &ctv->tv_sec) ||
 			__put_user(tv->tv_usec, &ctv->tv_usec)) ? -EFAULT : 0;
 }
-EXPORT_SYMBOL_GPL(put_compat_timeval);
 
-int get_compat_timespec(struct timespec *ts, const struct compat_timespec __user *cts)
+static int __compat_get_timespec(struct timespec *ts, const struct compat_timespec __user *cts)
 {
 	return (!access_ok(VERIFY_READ, cts, sizeof(*cts)) ||
 			__get_user(ts->tv_sec, &cts->tv_sec) ||
 			__get_user(ts->tv_nsec, &cts->tv_nsec)) ? -EFAULT : 0;
 }
-EXPORT_SYMBOL_GPL(get_compat_timespec);
 
-int put_compat_timespec(const struct timespec *ts, struct compat_timespec __user *cts)
+static int __compat_put_timespec(const struct timespec *ts, struct compat_timespec __user *cts)
 {
 	return (!access_ok(VERIFY_WRITE, cts, sizeof(*cts)) ||
 			__put_user(ts->tv_sec, &cts->tv_sec) ||
 			__put_user(ts->tv_nsec, &cts->tv_nsec)) ? -EFAULT : 0;
 }
-EXPORT_SYMBOL_GPL(put_compat_timespec);
 
 int compat_get_timeval(struct timeval *tv, const void __user *utv)
 {
 	if (COMPAT_USE_64BIT_TIME)
 		return copy_from_user(tv, utv, sizeof *tv) ? -EFAULT : 0;
 	else
-		return get_compat_timeval(tv, utv);
+		return __compat_get_timeval(tv, utv);
 }
 EXPORT_SYMBOL_GPL(compat_get_timeval);
 
@@ -191,7 +168,7 @@ int compat_put_timeval(const struct timeval *tv, void __user *utv)
 	if (COMPAT_USE_64BIT_TIME)
 		return copy_to_user(utv, tv, sizeof *tv) ? -EFAULT : 0;
 	else
-		return put_compat_timeval(tv, utv);
+		return __compat_put_timeval(tv, utv);
 }
 EXPORT_SYMBOL_GPL(compat_put_timeval);
 
@@ -200,7 +177,7 @@ int compat_get_timespec(struct timespec *ts, const void __user *uts)
 	if (COMPAT_USE_64BIT_TIME)
 		return copy_from_user(ts, uts, sizeof *ts) ? -EFAULT : 0;
 	else
-		return get_compat_timespec(ts, uts);
+		return __compat_get_timespec(ts, uts);
 }
 EXPORT_SYMBOL_GPL(compat_get_timespec);
 
@@ -209,10 +186,33 @@ int compat_put_timespec(const struct timespec *ts, void __user *uts)
 	if (COMPAT_USE_64BIT_TIME)
 		return copy_to_user(uts, ts, sizeof *ts) ? -EFAULT : 0;
 	else
-		return put_compat_timespec(ts, uts);
+		return __compat_put_timespec(ts, uts);
 }
 EXPORT_SYMBOL_GPL(compat_put_timespec);
 
+int compat_convert_timespec(struct timespec __user **kts,
+			    const void __user *cts)
+{
+	struct timespec ts;
+	struct timespec __user *uts;
+
+	if (!cts || COMPAT_USE_64BIT_TIME) {
+		*kts = (struct timespec __user *)cts;
+		return 0;
+	}
+
+	uts = compat_alloc_user_space(sizeof(ts));
+	if (!uts)
+		return -EFAULT;
+	if (compat_get_timespec(&ts, cts))
+		return -EFAULT;
+	if (copy_to_user(uts, &ts, sizeof(ts)))
+		return -EFAULT;
+
+	*kts = uts;
+	return 0;
+}
+
 static long compat_nanosleep_restart(struct restart_block *restart)
 {
 	struct compat_timespec __user *rmtp;
@@ -229,7 +229,7 @@ static long compat_nanosleep_restart(struct restart_block *restart)
 	if (ret) {
 		rmtp = restart->nanosleep.compat_rmtp;
 
-		if (rmtp && put_compat_timespec(&rmt, rmtp))
+		if (rmtp && compat_put_timespec(&rmt, rmtp))
 			return -EFAULT;
 	}
 
@@ -243,7 +243,7 @@ asmlinkage long compat_sys_nanosleep(struct compat_timespec __user *rqtp,
 	mm_segment_t oldfs;
 	long ret;
 
-	if (get_compat_timespec(&tu, rqtp))
+	if (compat_get_timespec(&tu, rqtp))
 		return -EFAULT;
 
 	if (!timespec_valid(&tu))
@@ -263,7 +263,7 @@ asmlinkage long compat_sys_nanosleep(struct compat_timespec __user *rqtp,
 		restart->fn = compat_nanosleep_restart;
 		restart->nanosleep.compat_rmtp = rmtp;
 
-		if (rmtp && put_compat_timespec(&rmt, rmtp))
+		if (rmtp && compat_put_timespec(&rmt, rmtp))
 			return -EFAULT;
 	}
 
@@ -451,7 +451,7 @@ asmlinkage long compat_sys_old_getrlimit(unsigned int resource,
 	mm_segment_t old_fs = get_fs();
 
 	set_fs(KERNEL_DS);
-	ret = sys_old_getrlimit(resource, &r);
+	ret = sys_old_getrlimit(resource, (struct rlimit __user *)&r);
 	set_fs(old_fs);
 
 	if (!ret) {
@@ -647,8 +647,8 @@ asmlinkage long compat_sys_sched_getaffinity(compat_pid_t pid, unsigned int len,
 int get_compat_itimerspec(struct itimerspec *dst,
 			  const struct compat_itimerspec __user *src)
 {
-	if (get_compat_timespec(&dst->it_interval, &src->it_interval) ||
-	    get_compat_timespec(&dst->it_value, &src->it_value))
+	if (__compat_get_timespec(&dst->it_interval, &src->it_interval) ||
+	    __compat_get_timespec(&dst->it_value, &src->it_value))
 		return -EFAULT;
 	return 0;
 }
@@ -656,8 +656,8 @@ int get_compat_itimerspec(struct itimerspec *dst,
 int put_compat_itimerspec(struct compat_itimerspec __user *dst,
 			  const struct itimerspec *src)
 {
-	if (put_compat_timespec(&src->it_interval, &dst->it_interval) ||
-	    put_compat_timespec(&src->it_value, &dst->it_value))
+	if (__compat_put_timespec(&src->it_interval, &dst->it_interval) ||
+	    __compat_put_timespec(&src->it_value, &dst->it_value))
 		return -EFAULT;
 	return 0;
 }
@@ -727,7 +727,7 @@ long compat_sys_clock_settime(clockid_t which_clock,
 	mm_segment_t oldfs;
 	struct timespec ts;
 
-	if (get_compat_timespec(&ts, tp))
+	if (compat_get_timespec(&ts, tp))
 		return -EFAULT;
 	oldfs = get_fs();
 	set_fs(KERNEL_DS);
@@ -749,7 +749,7 @@ long compat_sys_clock_gettime(clockid_t which_clock,
 	err = sys_clock_gettime(which_clock,
 				(struct timespec __user *) &ts);
 	set_fs(oldfs);
-	if (!err && put_compat_timespec(&ts, tp))
+	if (!err && compat_put_timespec(&ts, tp))
 		return -EFAULT;
 	return err;
 }
@@ -789,7 +789,7 @@ long compat_sys_clock_getres(clockid_t which_clock,
 	err = sys_clock_getres(which_clock,
 			       (struct timespec __user *) &ts);
 	set_fs(oldfs);
-	if (!err && tp && put_compat_timespec(&ts, tp))
+	if (!err && tp && compat_put_timespec(&ts, tp))
 		return -EFAULT;
 	return err;
 }
@@ -799,7 +799,7 @@ static long compat_clock_nanosleep_restart(struct restart_block *restart)
 	long err;
 	mm_segment_t oldfs;
 	struct timespec tu;
-	struct compat_timespec *rmtp = restart->nanosleep.compat_rmtp;
+	struct compat_timespec __user *rmtp = restart->nanosleep.compat_rmtp;
 
 	restart->nanosleep.rmtp = (struct timespec __user *) &tu;
 	oldfs = get_fs();
@@ -808,7 +808,7 @@ static long compat_clock_nanosleep_restart(struct restart_block *restart)
 	set_fs(oldfs);
 
 	if ((err == -ERESTART_RESTARTBLOCK) && rmtp &&
-	    put_compat_timespec(&tu, rmtp))
+	    compat_put_timespec(&tu, rmtp))
 		return -EFAULT;
 
 	if (err == -ERESTART_RESTARTBLOCK) {
@@ -827,7 +827,7 @@ long compat_sys_clock_nanosleep(clockid_t which_clock, int flags,
 	struct timespec in, out;
 	struct restart_block *restart;
 
-	if (get_compat_timespec(&in, rqtp))
+	if (compat_get_timespec(&in, rqtp))
 		return -EFAULT;
 
 	oldfs = get_fs();
@@ -838,7 +838,7 @@ long compat_sys_clock_nanosleep(clockid_t which_clock, int flags,
 	set_fs(oldfs);
 
 	if ((err == -ERESTART_RESTARTBLOCK) && rmtp &&
-	    put_compat_timespec(&out, rmtp))
+	    compat_put_timespec(&out, rmtp))
 		return -EFAULT;
 
 	if (err == -ERESTART_RESTARTBLOCK) {
@@ -1130,7 +1130,7 @@ COMPAT_SYSCALL_DEFINE2(sched_rr_get_interval,
 	set_fs(KERNEL_DS);
 	ret = sys_sched_rr_get_interval(pid, (struct timespec __user *)&t);
 	set_fs(old_fs);
-	if (put_compat_timespec(&t, interval))
+	if (compat_put_timespec(&t, interval))
 		return -EFAULT;
 	return ret;
 }
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index f9f44fd..55c8c93 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -183,7 +183,7 @@ COMPAT_SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI ||
 		      cmd == FUTEX_WAIT_BITSET ||
 		      cmd == FUTEX_WAIT_REQUEUE_PI)) {
-		if (get_compat_timespec(&ts, utime))
+		if (compat_get_timespec(&ts, utime))
 			return -EFAULT;
 		if (!timespec_valid(&ts))
 			return -EINVAL;
