Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750885AbaAEDRA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 22:17:00 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:56897 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaAEDQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 22:16:59 -0500
X-Nat-Received: from [202.181.97.72]:64531 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1388891759.24008
To: keescook@chromium.org, joe@perches.com, pavel@ucw.cz,
        akpm@linux-foundation.org
Cc: geert@linux-m68k.org, jkosina@suse.cz, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201401021349.JGJ78109.OOFtFFHJMLSOQV@I-love.SAKURA.ne.jp>
	<CAGXu5jL7RunQuAw1MjnUMgWeYMX35+YcGeaZYCx6dhND3YUmsQ@mail.gmail.com>
	<1388770748.14334.19.camel@joe-AO722>
	<CAGXu5j+gHtgx9MVCaJ2ogJ0WGCeTDkphsH3gm7S=+mTssicABg@mail.gmail.com>
	<201401041126.BHJ81291.VOHLOtMFOJFQFS@I-love.SAKURA.ne.jp>
In-Reply-To: <201401041126.BHJ81291.VOHLOtMFOJFQFS@I-love.SAKURA.ne.jp>
Message-Id: <201401051215.ACJ30759.MJSHtFFFVOOOQL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 5 Jan 2014 12:15:57 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 04012014 #7249268, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Since my purpose is to make reading of task_struct->comm consistent, %pT-like
> extension is what I want for centralizing pointer dereferences.

If we have no objections for %pT[C012] patch, I'd like to propose a counterpart
patch for users reading/copying task_struct->comm for non-printing purposes.
With %pT[C012] patch and this patch, we can convert almost all
task_struct->comm users.
----------
>From 89e676ddce3e2a232fbb760085a1954cd53c8b63 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sun, 5 Jan 2014 11:54:39 +0900
Subject: [PATCH] exec: Add wrapper functions for reading/copying task_struct->comm.

Since task_struct->comm can be modified by other threads while the current
thread is reading it, it is recommended to use get_task_comm() for reading it.

However, since get_task_comm() holds task_struct->alloc_lock spinlock,
some users cannot use get_task_comm(). Also, a lot of users are directly
reading from task_struct->comm even if they can use get_task_comm().
Such users might obtain inconsistent comm name.

This patch introduces wrapper functions for reading/copying task_struct->comm
so that in the future we need to modify only these wrapper functions to obtain
consistent comm name.

Users directly reading from task_struct->comm for printing purpose can use
%pT[C012] format specifiers rather than these wrapper functions.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 include/linux/sched.h |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 53f97eb..ead439f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1665,6 +1665,40 @@ static inline cputime_t task_gtime(struct task_struct *t)
 extern void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
 extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
 
+/**
+ * commcmp - Compare task_struct->comm .
+ *
+ * @tsk:  Pointer to "struct task_struct".
+ * @comm: Comm name.
+ *
+ * Returns return value of strcmp(@tsk->comm, @comm).
+ *
+ * Please use this wrapper function which will be updated in the future to read
+ * @tsk->comm in a consistent way.
+ */
+static inline int commcmp(const struct task_struct *tsk, const char *comm)
+{
+	return strcmp(tsk->comm, comm);
+}
+
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
1.7.9.5
