Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaAJNQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 08:16:10 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:50299 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaAJNQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 08:16:06 -0500
X-Nat-Received: from [202.181.97.72]:58085 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1389359707.16517
To: pavel@ucw.cz
Cc: keescook@chromium.org, joe@perches.com, akpm@linux-foundation.org,
        geert@linux-m68k.org, jkosina@suse.cz, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <CAGXu5j+gHtgx9MVCaJ2ogJ0WGCeTDkphsH3gm7S=+mTssicABg@mail.gmail.com>
	<201401041126.BHJ81291.VOHLOtMFOJFQFS@I-love.SAKURA.ne.jp>
	<201401051215.ACJ30759.MJSHtFFFVOOOQL@I-love.SAKURA.ne.jp>
	<20140105222752.GA27517@amd.pavel.ucw.cz>
	<201401062302.FJG51045.tFSOFJQLOOHFMV@I-love.SAKURA.ne.jp>
In-Reply-To: <201401062302.FJG51045.tFSOFJQLOOHFMV@I-love.SAKURA.ne.jp>
Message-Id: <201401102215.IEJ51533.FFVQHOOLOFJSMt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 10 Jan 2014 22:15:06 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 10012014 #7293297, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Pavel Machek wrote:
> > > + * Please use this wrapper function which will be updated in the future to read
> > > + * @tsk->comm in a consistent way.
> > > + */
> > > +static inline int commcmp(const struct task_struct *tsk, const char *comm)
> > > +{
> > > +	return strcmp(tsk->comm, comm);
> > > +}
> > 
> > Is this useful to something? Printing command name is
> > useful. Comparing it...?
> >
> 
> (a) Using tsk->comm for reducing duplicated printk() messages.
> 
>     if (strcmp(p->comm, last_comm)) {
>         printk("hello\n");
>         strcpy(last_comm, p->comm);
>     }
> 
> (b) Using tsk->pid for reducing duplicated printk() messages.
> 
>     if (p->pid != last_pid) {
>         printk("hello\n");
>         last_pid = p->pid;
>     }
> 
> (c) Using printk_ratelimit() for reducing printk() flooding.
> 
>     printk_ratelimit("hello\n");
> 
> (d) Using plain printk().
> 
>     printk("hello\n");
> 
> (e) Other purposes. (e.g. drivers/target/iscsi/iscsi_target_tq.c )
> 
>     if (!strncmp(current->comm, ISCSI_RX_THREAD_NAME,
>                  strlen(ISCSI_RX_THREAD_NAME)))
>         thread_called = ISCSI_RX_THREAD;
>     else if (!strncmp(current->comm, ISCSI_TX_THREAD_NAME,
>                       strlen(ISCSI_TX_THREAD_NAME)))
>         thread_called = ISCSI_TX_THREAD;
> 
> commcmp() and commcpy() are for wrappring (a).
> Though (a) should consider changing to (b) or (c).
> 
> (e) should be rewritten not to depend on current->comm .
> 

I realized that we don't need commcmp() because we can rewrite like below.

  (a)
      char tmp_comm[TASK_COMM_LEN];
      commcpy(tmp_comm, p->comm);
      if (strcmp(tmp_comm, last_comm)) {
          printk("hello\n");
          strcpy(last_comm, tmp_comm);
      }

  (e)
      char tmp_comm[TASK_COMM_LEN];
      commcpy(tmp_comm, p->comm);
      if (!strncmp(tmp_comm, ISCSI_RX_THREAD_NAME,
                   strlen(ISCSI_RX_THREAD_NAME)))
          thread_called = ISCSI_RX_THREAD;
      else if (!strncmp(tmp_comm, ISCSI_TX_THREAD_NAME,
                        strlen(ISCSI_TX_THREAD_NAME)))
          thread_called = ISCSI_TX_THREAD;

Below is an updated patch (and one of users of this patch). I assume we can
agree on these patches, and I expect these patches go to linux-next.git via
linux-security.git (as I can save one merge window for fixing this issue in
the LSM auditing code.)
----------------------------------------
>From 0c183ad7aceb0db8ca4b9bd3a048182bf23e32be Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Fri, 10 Jan 2014 21:54:38 +0900
Subject: [PATCH] exec: Add wrapper function for reading task_struct->comm.

Since task_struct->comm can be modified by other threads while the current
thread is reading it, it is recommended to use get_task_comm() for reading it.

However, since get_task_comm() holds task_struct->alloc_lock spinlock,
some users cannot use get_task_comm(). Also, a lot of users are directly
reading from task_struct->comm even if they can use get_task_comm().
Such users might obtain inconsistent result.

This patch introduces a wrapper function for reading task_struct->comm .
Currently this function does not provide consistency. I'm planning to change to
use RCU in the future. By using RCU, the comm name read from task_struct->comm
will be guaranteed to be consistent. But before modifying set_task_comm() to
use RCU, we need to kill direct ->comm users who do not use get_task_comm().

Users directly reading from task_struct->comm for printing purpose can use
%pT format specifier rather than this wrapper function.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 include/linux/sched.h |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e27baee..de12b27 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1601,6 +1601,24 @@ static inline cputime_t task_gtime(struct task_struct *t)
 extern void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
 extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
 
+/**
+ * commcpy - Copy task_struct->comm to buffer.
+ *
+ * @buf: Buffer to copy @tsk->comm which must be at least TASK_COMM_LEN bytes.
+ * @tsk: Pointer to "struct task_struct".
+ *
+ * Returns return value of memcpy(@buf, @tsk->comm, TASK_COMM_LEN).
+ *
+ * Please use get_task_comm(@buf, @tsk) if it is safe to call task_lock(@tsk),
+ * for get_task_comm() reads @tsk->comm in a consistent way. Otherwise, please
+ * use this wrapper function which will be updated in the future to read
+ * @tsk->comm in a consistent way.
+ */
+static inline void *commcpy(void *buf, const struct task_struct *tsk)
+{
+	return memcpy(buf, tsk->comm, TASK_COMM_LEN);
+}
+
 /*
  * Per process flags
  */
-- 
1.7.1
----------------------------------------
>From 3b5137f09bfdac7b0133ddaa194d181d7c897e1f Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Fri, 10 Jan 2014 22:02:14 +0900
Subject: [PATCH] LSM: Pass comm name via commcpy()

When we pass task->comm to audit_log_untrustedstring(), we need to pass a
snapshot of it using commcpy() because task->comm can be changed to contain
control character by other threads after audit_log_untrustedstring() confirmed
that task->comm does not contain control character.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/lsm_audit.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/security/lsm_audit.c b/security/lsm_audit.c
index 8d8d97d..76f37f7 100644
--- a/security/lsm_audit.c
+++ b/security/lsm_audit.c
@@ -212,6 +212,7 @@ static void dump_common_audit_data(struct audit_buffer *ab,
 				   struct common_audit_data *a)
 {
 	struct task_struct *tsk = current;
+	char name[TASK_COMM_LEN];
 
 	/*
 	 * To keep stack sizes in check force programers to notice if they
@@ -221,7 +222,7 @@ static void dump_common_audit_data(struct audit_buffer *ab,
 	BUILD_BUG_ON(sizeof(a->u) > sizeof(void *)*2);
 
 	audit_log_format(ab, " pid=%d comm=", tsk->pid);
-	audit_log_untrustedstring(ab, tsk->comm);
+	audit_log_untrustedstring(ab, commcpy(name, tsk));
 
 	switch (a->type) {
 	case LSM_AUDIT_DATA_NONE:
@@ -280,7 +281,7 @@ static void dump_common_audit_data(struct audit_buffer *ab,
 		tsk = a->u.tsk;
 		if (tsk && tsk->pid) {
 			audit_log_format(ab, " pid=%d comm=", tsk->pid);
-			audit_log_untrustedstring(ab, tsk->comm);
+			audit_log_untrustedstring(ab, commcpy(name, tsk));
 		}
 		break;
 	case LSM_AUDIT_DATA_NET:
-- 
1.7.1
----------------------------------------
