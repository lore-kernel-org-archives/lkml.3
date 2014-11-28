Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaK1SYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:24:49 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:54109 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaK1SYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:24:47 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC PATCH 20/30] signal: Convert obsolete cputime type to nsecs
Date: Fri, 28 Nov 2014 19:23:50 +0100
Message-Id: <1417199040-21044-21-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/signal.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index b0f1f39..d50006e 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1618,7 +1618,7 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	unsigned long flags;
 	struct sighand_struct *psig;
 	bool autoreap = false;
-	cputime_t utime, stime;
+	u64 utime, stime;
 
 	BUG_ON(sig == -1);
 
@@ -1656,9 +1656,9 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 				       task_uid(tsk));
 	rcu_read_unlock();
 
-	task_cputime_t(tsk, &utime, &stime);
-	info.si_utime = cputime_to_clock_t(utime + tsk->signal->utime);
-	info.si_stime = cputime_to_clock_t(stime + tsk->signal->stime);
+	task_cputime(tsk, &utime, &stime);
+	info.si_utime = nsec_to_clock_t(utime + tsk->signal->utime);
+	info.si_stime = nsec_to_clock_t(stime + tsk->signal->stime);
 
 	info.si_status = tsk->exit_code & 0x7f;
 	if (tsk->exit_code & 0x80)
@@ -1722,7 +1722,7 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
 	unsigned long flags;
 	struct task_struct *parent;
 	struct sighand_struct *sighand;
-	cputime_t utime, stime;
+	u64 utime, stime;
 
 	if (for_ptracer) {
 		parent = tsk->parent;
@@ -1741,9 +1741,9 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
 	info.si_uid = from_kuid_munged(task_cred_xxx(parent, user_ns), task_uid(tsk));
 	rcu_read_unlock();
 
-	task_cputime_t(tsk, &utime, &stime);
-	info.si_utime = cputime_to_clock_t(utime);
-	info.si_stime = cputime_to_clock_t(stime);
+	task_cputime(tsk, &utime, &stime);
+	info.si_utime = nsec_to_clock_t(utime);
+	info.si_stime = nsec_to_clock_t(stime);
 
  	info.si_code = why;
  	switch (why) {
-- 
2.1.3

