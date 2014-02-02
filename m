Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751075AbaBBDEF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 22:04:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:43751 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbaBBDED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 22:04:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,760,1384329600"; 
   d="scan'208";a="448290802"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Mateusz Guzik <mguzik@redhat.com>, Rafael Aquini <aquini@redhat.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H.J. Lu" <hjl.tools@gmail.com>
Subject: [PATCH RFC] compat: Get rid of (get|put)_compat_time(val|spec)
Date: Sat,  1 Feb 2014 19:03:52 -0800
Message-Id: <1391310232-8520-1-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

We have two APIs for compatiblity timespec/val, with confusingly
similar names.  compat_(get|put)_time(val|spec) *do* handle the case
where COMPAT_USE_64BIT_TIME is set, whereas
(get|put)_compat_time(val|spec) do not.  This is an accident waiting
to happen.

Clean it up by favoring the full-service version; the limited version
is replaced with double-underscore versions static to kernel/compat.c.

A common pattern is to convert a struct timeval/timespec to kernel
format in an allocation on the user stack.  Unfortunately it is
open-coded in several places.  Since this allocation isn't actually
needed if COMPAT_USE_64BIT_TIME is true (since user format == kernel
format) encapsulate that whole pattern into functions
compat_convert_time(spec|val).

Finally, get rid of compat_(get|put)_timeval_convert(): each was only
used once, and the latter was not even doing what the function said
(no conversion actually was being done.)  Moving the conversion into
compat_sys_settimeofday() itself makes the code much more similar to
sys_settimeofday() itself.

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Mateusz Guzik <mguzik@redhat.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: H.J. Lu <hjl.tools@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |   2 +-
 fs/compat.c                                   |   6 +-
 include/linux/compat.h                        |  23 ++---
 ipc/compat.c                                  |  12 +--
 ipc/compat_mq.c                               |  19 +---
 kernel/compat.c                               | 131 +++++++++++++++-----------
 kernel/futex_compat.c                         |   2 +-
 7 files changed, 98 insertions(+), 97 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 8f7a6a454a4c..6191968db8fa 100644
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
index 6af20de2c1a3..62092f433759 100644
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
index 3f448c65511b..0d9678e15823 100644
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
+ * These functions convert a timeval/timespec if necessary and return
+ * a user space pointer.
+ */
+extern int compat_convert_timespec(const struct timespec __user **,
+				   const void __user *);
+extern int compat_convert_timeval(const struct timeval __user **,
+				  const void __user *);
+
 struct compat_iovec {
 	compat_uptr_t	iov_base;
 	compat_size_t	iov_len;
diff --git a/ipc/compat.c b/ipc/compat.c
index f486b0096a67..1048522479e5 100644
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
index 63d7c6de335b..a9cf16378d7a 100644
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
index 0a09e481b70b..9533ba6bab59 100644
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
 
@@ -209,10 +186,56 @@ int compat_put_timespec(const struct timespec *ts, void __user *uts)
 	if (COMPAT_USE_64BIT_TIME)
 		return copy_to_user(uts, ts, sizeof *ts) ? -EFAULT : 0;
 	else
-		return put_compat_timespec(ts, uts);
+		return __compat_put_timespec(ts, uts);
 }
 EXPORT_SYMBOL_GPL(compat_put_timespec);
 
+int compat_convert_timespec(const struct timespec __user **kts,
+			    const void __user *cts)
+{
+	struct timespec ts;
+	struct timespec __user *uts;
+
+	if (!cts || COMPAT_USE_64BIT_TIME) {
+		*kts = cts;
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
+int compat_convert_timeval(const struct timeval __user **ktv,
+			    const void __user *ctv)
+{
+	struct timeval tv;
+	struct timespec __user *utv;
+
+	if (!ctv || COMPAT_USE_64BIT_TIME) {
+		*ktv = ctv;
+		return 0;
+	}
+
+	utv = compat_alloc_user_space(sizeof(tv));
+	if (!utv)
+		return -EFAULT;
+	if (compat_get_timeval(&tv, ctv))
+		return -EFAULT;
+	if (copy_to_user(utv, &tv, sizeof(tv)))
+		return -EFAULT;
+
+	*ktv = utv;
+	return 0;
+}
+
 static long compat_nanosleep_restart(struct restart_block *restart)
 {
 	struct compat_timespec __user *rmtp;
@@ -229,7 +252,7 @@ static long compat_nanosleep_restart(struct restart_block *restart)
 	if (ret) {
 		rmtp = restart->nanosleep.compat_rmtp;
 
-		if (rmtp && put_compat_timespec(&rmt, rmtp))
+		if (rmtp && compat_put_timespec(&rmt, rmtp))
 			return -EFAULT;
 	}
 
@@ -243,7 +266,7 @@ asmlinkage long compat_sys_nanosleep(struct compat_timespec __user *rqtp,
 	mm_segment_t oldfs;
 	long ret;
 
-	if (get_compat_timespec(&tu, rqtp))
+	if (compat_get_timespec(&tu, rqtp))
 		return -EFAULT;
 
 	if (!timespec_valid(&tu))
@@ -263,7 +286,7 @@ asmlinkage long compat_sys_nanosleep(struct compat_timespec __user *rqtp,
 		restart->fn = compat_nanosleep_restart;
 		restart->nanosleep.compat_rmtp = rmtp;
 
-		if (rmtp && put_compat_timespec(&rmt, rmtp))
+		if (rmtp && compat_put_timespec(&rmt, rmtp))
 			return -EFAULT;
 	}
 
@@ -647,8 +670,8 @@ asmlinkage long compat_sys_sched_getaffinity(compat_pid_t pid, unsigned int len,
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
@@ -656,8 +679,8 @@ int get_compat_itimerspec(struct itimerspec *dst,
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
@@ -727,7 +750,7 @@ long compat_sys_clock_settime(clockid_t which_clock,
 	mm_segment_t oldfs;
 	struct timespec ts;
 
-	if (get_compat_timespec(&ts, tp))
+	if (compat_get_timespec(&ts, tp))
 		return -EFAULT;
 	oldfs = get_fs();
 	set_fs(KERNEL_DS);
@@ -749,7 +772,7 @@ long compat_sys_clock_gettime(clockid_t which_clock,
 	err = sys_clock_gettime(which_clock,
 				(struct timespec __user *) &ts);
 	set_fs(oldfs);
-	if (!err && put_compat_timespec(&ts, tp))
+	if (!err && compat_put_timespec(&ts, tp))
 		return -EFAULT;
 	return err;
 }
@@ -789,7 +812,7 @@ long compat_sys_clock_getres(clockid_t which_clock,
 	err = sys_clock_getres(which_clock,
 			       (struct timespec __user *) &ts);
 	set_fs(oldfs);
-	if (!err && tp && put_compat_timespec(&ts, tp))
+	if (!err && tp && compat_put_timespec(&ts, tp))
 		return -EFAULT;
 	return err;
 }
@@ -808,7 +831,7 @@ static long compat_clock_nanosleep_restart(struct restart_block *restart)
 	set_fs(oldfs);
 
 	if ((err == -ERESTART_RESTARTBLOCK) && rmtp &&
-	    put_compat_timespec(&tu, rmtp))
+	    compat_put_timespec(&tu, rmtp))
 		return -EFAULT;
 
 	if (err == -ERESTART_RESTARTBLOCK) {
@@ -827,7 +850,7 @@ long compat_sys_clock_nanosleep(clockid_t which_clock, int flags,
 	struct timespec in, out;
 	struct restart_block *restart;
 
-	if (get_compat_timespec(&in, rqtp))
+	if (compat_get_timespec(&in, rqtp))
 		return -EFAULT;
 
 	oldfs = get_fs();
@@ -838,7 +861,7 @@ long compat_sys_clock_nanosleep(clockid_t which_clock, int flags,
 	set_fs(oldfs);
 
 	if ((err == -ERESTART_RESTARTBLOCK) && rmtp &&
-	    put_compat_timespec(&out, rmtp))
+	    compat_put_timespec(&out, rmtp))
 		return -EFAULT;
 
 	if (err == -ERESTART_RESTARTBLOCK) {
@@ -1130,7 +1153,7 @@ COMPAT_SYSCALL_DEFINE2(sched_rr_get_interval,
 	set_fs(KERNEL_DS);
 	ret = sys_sched_rr_get_interval(pid, (struct timespec __user *)&t);
 	set_fs(old_fs);
-	if (put_compat_timespec(&t, interval))
+	if (compat_put_timespec(&t, interval))
 		return -EFAULT;
 	return ret;
 }
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index f9f44fd4d34d..55c8c9349cfe 100644
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
-- 
1.8.3.1

