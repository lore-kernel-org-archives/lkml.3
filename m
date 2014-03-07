Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbaCGMW3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 07:22:29 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:65231 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbaCGMW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 07:22:26 -0500
X-Nat-Received: from [202.181.97.72]:50938 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1394194815.27749
To: peterz@infradead.org, paulmck@linux.vnet.ibm.com, rgb@redhat.com
Cc: laijs@cn.fujitsu.com, akpm@linux-foundation.org, joe@perches.com,
        keescook@chromium.org, geert@linux-m68k.org, jkosina@suse.cz,
        viro@zeniv.linux.org.uk, davem@davemloft.net,
        linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
        tglx@linutronix.de, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Change task_struct->comm to use RCU.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201402102243.IEJ52676.JOFVMOQFOFSLtH@I-love.SAKURA.ne.jp>
	<201402172027.BFH81210.FJtOQOMLHFSVOF@I-love.SAKURA.ne.jp>
	<530BF6B4.3040206@cn.fujitsu.com>
	<201402252154.HAE13049.QFFSMVOFOOtLJH@I-love.SAKURA.ne.jp>
	<20140225144643.GU9987@twins.programming.kicks-ass.net>
In-Reply-To: <20140225144643.GU9987@twins.programming.kicks-ass.net>
Message-Id: <201403072120.BJB73489.OFMSOFHQFtOJLV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 7 Mar 2014 21:20:11 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 07032014 #7431531, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> I would have actually expected it to stop emitting chars at \0. But
> sure. Couldn't care less though; that's what you get, we all know this,
> we've all been through this discussion several times. Get over it
> already.
> 
> One of the last threads on this is:
> 
>   https://lkml.org/lkml/2011/5/17/516
> 
Yes, I knew the attempts to make comm access consistent. I was wondering why
such proposal is not yet accepted.

Thank you for pointing that thread out. I found the following comment in that
thread.

Linus Torvalds wrote:
| What folks?
| 
| I don't think a new lock (or any lock) is at all appropriate.
| 
| There's just no point. Just guarantee that the last byte is always
| zero, and you're done.
| 
| If you just guarantee that, THERE IS NO RACE. The last byte never
| changes. You may get odd half-way strings, but you've trivially
| guaranteed that they are C NUL-terminated, with no locking, no memory
| ordering, no nothing.

He stated that no locks are acceptable. Then, there is no room to insert
rcu_read_lock()/rcu_read_unlock() into the reader side. The only way which can
be implemented without any locks would be a heuristic atomicity shown later.

> >   Likewise, audit_log_untrustedstring(ab, current->comm) is racy.
> >   If task->comm was "Hello Linux" until audit_string_contains_control() in
> >   audit_log_n_untrustedstring() returns false, and becomes "Penguin" before
> >   memcpy() in audit_log_n_string() is called, memcpy() will emit "Penguin\0nux"
> >   into the audit log, which results in loss of information (e.g. SELinux
> >   context) due to the unexpected '\0' byte.
> 
> I expect the audit people don't like this? Also, how do audit and the
> LSM crap things interact? I thought they were both different piles of
> ignorable goo?
> 

I think the audit people do not like loss of information. Some of LSM modules
are using audit subsystem for recording security related events. An example is
shown later.

> See there's not actually a problem statement here at all, so you can't
> go about proposing solutions quite yet.
> 

Please see the patch.

> > Proposed solution:
> > 
> >   To fix abovementioned problem, I proposed commcpy() and "%pT" format
> >   specifier which does
> > 
> >     char tmp[16];
> >     memcpy(tmp, task->comm, 16);
> >     tmp[15] = '\0';
> >     sprintf(buf, "%s", tmp);
> > 
> >   instead of
> > 
> >     sprintf(buf, "%s", task->comm);
> > 
> >   .
> 
> How about you do what you're supposed to do when you want a reliable
> ->comm and use get_task_comm()?
> 

I always want a reliable ->comm . But get_task_comm() is not for calling from
vsnprintf(), for somebody might read task's commname from NMI context.
I tried to use RCU for reading from vsnprintf() but Linus will not accept it.

Regards.

----------

>From 212d983aa143954c089177942b6a7d9ab5393f8f Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Fri, 7 Mar 2014 11:00:24 +0900
Subject: [PATCH] Read/update task's commname sizeof(long) bytes at a time.

"struct task_struct"->comm is read from various locations, but it is not
updated atomically. As a result, readers may see a mixture of old and new
commname.

A bogus NUL byte in the mixture of old and new commname caused by TOCTTOU
race can have unwanted side effect. For example, a sequence described below
could happen when audit_log_untrustedstring(ab, tsk->comm) is called.

  (1) Initial tsk->comm contains "penguin-kernel\0\0"
  (2) CPU 0 attempts to audit tsk->comm using
      audit_log_untrustedstring(ab, tsk->comm)
  (3) audit_log_untrustedstring(ab, tsk->comm) calls
      audit_log_n_untrustedstring(ab, tsk->comm, strlen(tsk->comm))
  (4) strlen(tsk->comm) is called and it returns 14
  (5) audit_log_n_untrustedstring(ab, tsk->comm, 14) calls
      audit_string_contains_control(tsk->comm, 14)
  (6) audit_string_contains_control(tsk->comm, 14) returns 0
  (7) CPU 1 attempts to write tsk->comm using set_task_comm(tsk, "penguin")
  (8) CPU 1 holds tsk->alloc_lock
  (9) CPU 1 calls strlcpy(tsk->comm, "penguin", 16)
      and now tsk->comm contains "penguin\0kernel\0\0"
  (10) CPU 1 releases task_struct->alloc_lock
  (11) audit_log_n_string(ab, tsk->comm, 14) calls memcpy(ptr, tsk->comm, 14)
  (12) memcpy(ptr, tsk->comm, 14) will copy "penguin\0kernel"
  (13) CPU 0 appends the rest of information and enqueues the entire log
  (14) the audit daemon reads the entire log, but the information after
       "penguin\0" are lost because of erroneously copied '\0' byte.

Since system call auditing and LSM modules include task's commname in their
record, the straying NUL byte can unexpectedly truncate that record, leading
loss of information which should have been recorded.

This patch introduces do_get_task_comm() and do_set_task_comm(). The former
locklessly reads task's commname using "long" and the latter locklessly updates
task's commname using "long". By using "long", we can reduce the possibility of
getting the mixture of old and new commname, for reading/writing of "long" is
atomic.

The horizontal axis of below map is the strlen() of current commname and the
vertical axis is the strlen() of commname to update to. If sizeof(long) == 8,
193 out of 256 patterns can be atomically updated without any locks. Moreover,
since strlen() of at least one of current commname and new commname tends to
be shorter than sizeof(long) (e.g. "bash" -> "ls", "rc.sysinit" -> "cat",
"bash" -> "avahi-daemon" ), update of commname will more likely be atomic
without any locks.

    | 0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
  --+-----------------------------------------------
   0| o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  o
   1| o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  o
   2| o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  o
   3| o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  o
   4| o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  o
   5| o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  o
   6| o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  o
   7| o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  o
   8| o  o  o  o  o  o  o  o  o  x  x  x  x  x  x  x
   9| o  o  o  o  o  o  o  o  x  x  x  x  x  x  x  x
  10| o  o  o  o  o  o  o  o  x  x  x  x  x  x  x  x
  11| o  o  o  o  o  o  o  o  x  x  x  x  x  x  x  x
  12| o  o  o  o  o  o  o  o  x  x  x  x  x  x  x  x
  13| o  o  o  o  o  o  o  o  x  x  x  x  x  x  x  x
  14| o  o  o  o  o  o  o  o  x  x  x  x  x  x  x  x
  15| o  o  o  o  o  o  o  o  x  x  x  x  x  x  x  x

By converting all readers to use [do_]get_task_comm() and all writers to
use [do_]set_task_comm(), we get the following advantages.

  (1) The straying NUL byte will be completely removed.

  (2) The possibility of seeing the mixture of old and new commname is
      to some degree reduced. The possibility will become 0 depending on
      the length of commname.

An example of how to use do_get_task_comm() is shown below.

  -audit_log_untrustedstring(ab, tsk->comm);
  +char buf[TASK_COMM_LEN];
  +audit_log_untrustedstring(ab, do_get_task_comm(buf, tsk));

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/exec.c             |   69 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/sched.h |   29 ++++++++++++++++++++
 2 files changed, 96 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a781dec..8e0a212 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1792,6 +1792,35 @@ static inline cputime_t task_gtime(struct task_struct *t)
 extern void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
 extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
 
+/**
+ * do_get_task_comm - Copy task_struct->comm to buffer.
+ *
+ * @buf: Buffer to copy @tsk->comm which must be at least TASK_COMM_LEN bytes.
+ * @tsk: Pointer to "struct task_struct".
+ *
+ * Returns @buf .
+ *
+ * Please use this wrapper function which reads @tsk->comm in a heuristic
+ * atomic way.
+ */
+static inline char *do_get_task_comm(char *buf, const struct task_struct *tsk)
+{
+	unsigned long *d = (unsigned long *) buf;
+	unsigned long *s = (unsigned long *) tsk->comm;
+#if BITS_PER_LONG == 32
+	*d++ = *s++;
+	*d++ = *s++;
+#endif
+	*d++ = *s++;
+	*d = *s;
+	/*
+	 * This is a safeguard which is used until all users are converted to
+	 * use [do_]set_task_comm().
+	 */
+	buf[TASK_COMM_LEN - 1] = '\0';
+	return buf;
+}
+
 /*
  * Per process flags
  */
diff --git a/fs/exec.c b/fs/exec.c
index 3d78fcc..7f66dcf 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1030,7 +1030,7 @@ char *get_task_comm(char *buf, struct task_struct *tsk)
 {
 	/* buf must be at least sizeof(tsk->comm) in size */
 	task_lock(tsk);
-	strncpy(buf, tsk->comm, sizeof(tsk->comm));
+	do_get_task_comm(buf, tsk);
 	task_unlock(tsk);
 	return buf;
 }
@@ -1041,11 +1041,76 @@ EXPORT_SYMBOL_GPL(get_task_comm);
  * so that a new one can be started
  */
 
+void do_set_task_comm(struct task_struct *tsk, char *buf)
+{
+	long new[TASK_COMM_LEN / sizeof(long)];
+	long *old = (unsigned long *) tsk->comm;
+	/*
+	 * This is a safeguard which is used until all users are converted to
+	 * use [do_]set_task_comm().
+	 */
+	const u8 old_len = strnlen((char *) old, TASK_COMM_LEN);
+	u8 new_len = 0;
+
+	BUILD_BUG_ON(TASK_COMM_LEN % sizeof(long));
+	/*
+	 * Copy to temporary buffer, for size of "buf" may be smaller than
+	 * TASK_COMM_LEN bytes. We do not use strnlen() + memcpy() in order to
+	 * avoid TOCTTOU race, in case "buf" changed while copying.
+	 */
+	while (new_len < TASK_COMM_LEN - 1 && *buf)
+		((char *) new)[new_len++] = *buf++;
+	while (new_len < TASK_COMM_LEN)
+		((char *) new)[new_len++] = '\0';
+	/*
+	 * Update tsk->comm in a heuristic atomic way.
+	 *
+	 * If writers update one byte at a time using string manipulating
+	 * functions, readers have at most 14 chances of race.
+	 *
+	 * If writers update sizeof(long) bytes at a time, readers have at most
+	 * 1 (for 64bits arch) or 3 (for 32bits arch) chances of race. And even
+	 * if a reader races, the reader never sees mixture of old and new
+	 * tsk->comm within each sizeof(long) bytes. Also, if length of old
+	 * tsk->comm is shorter than sizeof(long) bytes, readers who are using
+	 * do_get_task_comm() have no chance of reading partially updated
+	 * tsk->comm unless disturbed by other factors (e.g. interrupts,
+	 * preemption, memory access reordering).
+	 *
+	 * This preempt_disable_notrace() is meant for reducing the possibility
+	 * of disturbance, but not meant to be a perfect barrier; readers have
+	 * no locks and no memory access orderings after all.
+	 */
+	preempt_disable_notrace();
+	if (old_len < sizeof(long)) {
+		old[1] = new[1];
+#if BITS_PER_LONG == 32
+		old[2] = new[2];
+		old[3] = new[3];
+#endif
+		/*
+		 * This memory barrier is meant for reducing the possibility of
+		 * reading new[1] before new[0], but not meant to be a perfect
+		 * barrier.
+		 */
+		smp_wmb();
+		old[0] = new[0];
+	} else {
+		old[0] = new[0];
+		old[1] = new[1];
+#if BITS_PER_LONG == 32
+		old[2] = new[2];
+		old[3] = new[3];
+#endif
+	}
+	preempt_enable_no_resched_notrace();
+}
+
 void set_task_comm(struct task_struct *tsk, char *buf)
 {
 	task_lock(tsk);
 	trace_task_rename(tsk, buf);
-	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
+	do_set_task_comm(tsk, buf);
 	task_unlock(tsk);
 	perf_event_comm(tsk);
 }
-- 
1.7.1
