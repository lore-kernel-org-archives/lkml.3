Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222Ab3JQQuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:50:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45160 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756847Ab3JQQua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:50:30 -0400
Date: Thu, 17 Oct 2013 09:49:48 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-8922915b38cd8b72f8e5af614b95be71d1d299d4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20131007183106.GA10973@redhat.com>
References: <20131007183106.GA10973@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/wait: Add ___wait_cond_timeout()
  to wait_event*_timeout() too
Git-Commit-ID: 8922915b38cd8b72f8e5af614b95be71d1d299d4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 17 Oct 2013 09:49:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8922915b38cd8b72f8e5af614b95be71d1d299d4
Gitweb:     http://git.kernel.org/tip/8922915b38cd8b72f8e5af614b95be71d1d299d4
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Mon, 7 Oct 2013 20:31:06 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Oct 2013 14:22:17 +0200

sched/wait: Add ___wait_cond_timeout() to wait_event*_timeout() too

Commit 4c663cfc ("wait: fix false timeouts when using
wait_event_timeout()") introduced the additional condition checks
after a timeout but only in the "slow" __wait*() paths.

wait_event_timeout(wq, CONDITION, 0) still returns 0 if CONDITION
is already true and we do not call __wait*().

Now that we have ___wait_cond_timeout() we can use it instead to
ensure that __ret will be properly updated.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131007183106.GA10973@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/wait.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index a2726c7..04c0260 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -270,7 +270,7 @@ do {									\
 #define wait_event_timeout(wq, condition, timeout)			\
 ({									\
 	long __ret = timeout;						\
-	if (!(condition))						\
+	if (!___wait_cond_timeout(condition))				\
 		__ret = __wait_event_timeout(wq, condition, timeout);	\
 	__ret;								\
 })
@@ -328,7 +328,7 @@ do {									\
 #define wait_event_interruptible_timeout(wq, condition, timeout)	\
 ({									\
 	long __ret = timeout;						\
-	if (!(condition))						\
+	if (!___wait_cond_timeout(condition))				\
 		__ret = __wait_event_interruptible_timeout(wq,		\
 						condition, timeout);	\
 	__ret;								\
@@ -769,7 +769,7 @@ do {									\
 						  timeout)		\
 ({									\
 	long __ret = timeout;						\
-	if (!(condition))						\
+	if (!___wait_cond_timeout(condition))				\
 		__ret = __wait_event_interruptible_lock_irq_timeout(	\
 					wq, condition, lock, timeout);	\
 	__ret;								\
